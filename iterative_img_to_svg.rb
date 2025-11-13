require "bundler/inline"

gemfile do
  source "https://rubygems.org"

  gem "debug"
  gem "dotenv"
  gem "ruby_llm"
  gem "slop"
  gem "vips"
end

Dotenv.load

class Converter
  attr_reader :input, :output, :model, :iterations, :provider

  def initialize(input:, output:, model:, iterations:, provider:)
    @input = input
    @output = output
    @model = model
    @iterations = iterations
    @provider = provider
  end

  def run
    svg = nil
    latest_png_path = nil

    iterations.times do |i|
      chat = RubyLLM.chat(model: model, provider: provider, assume_model_exists: true)
                    .with_instructions("Respond only with valid SVG")

      response =
        if svg.nil?
          chat.ask("Convert this image to SVG", with: input)
        else
          message = <<~MSG
            An LLM was asked to convert #{input} to SVG and responded with this:

            #{svg}

            When rendered, that SVG looks like #{latest_png_path}.

            Improve on the previous attempt with an SVG that looks even more like
            the target image.
          MSG

          chat.ask(message, with: [input, latest_png_path])
        end

      svg = svg_from_response(response.content)

      if svg.nil?
        puts "No SVG found in response: #{response.content}"
        response = chat.ask("No SVG found in response. Try again.", with: [input, latest_png_path])
        svg = svg_from_response(response.content)
      end

      latest_png_path = File.join(output, "#{model.gsub('/', '-')}_#{i}.png")

      File.write(latest_png_path.gsub(".png", ".svg"), svg)

      Vips::Image.new_from_buffer(svg, "", dpi: 144)
                 .write_to_file(latest_png_path)
    end
  end

  def svg_from_response(response)
    response[%r{<svg[^>]*>.*?</svg>}m]
  end

  def self.from_slop
    opts = Slop.parse do |o|
      o.string "-i", "--input", "Input image file", required: true
      o.string "-o", "--output", "Output directory", default: "./output"
      o.string "-m", "--model", "Model", default: "anthropic/claude-sonnet-4.5"
      o.integer "-n", "--iterations", "Number of iterations", default: 4
      o.string "-p", "--provider", "Model provider", default: "openrouter"

      o.on "-h", "--help" do
        puts "\nAdd your provider API key to `.env`\n\n#{o}\n"
        exit
      end
    end

    new(**opts.to_h)
  rescue Slop::Error => e
    puts e.message
    exit 1
  end
end

RubyLLM.configure do |config|
  # https://rubyllm.com/configuration/#api-keys
  config.openrouter_api_key = ENV.fetch("OPENROUTER_API_KEY", nil)
end

Converter.from_slop.run

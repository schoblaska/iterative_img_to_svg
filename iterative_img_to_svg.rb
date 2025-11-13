#!/usr/bin/env ruby

require "bundler/inline"

gemfile do
  source "https://rubygems.org"

  gem "dotenv"
  gem "ruby_llm"
  gem "slop"
  gem "vips"
end

Dotenv.load

class Converter
  attr_reader :input, :output, :model, :loops, :provider

  def initialize(input:, output:, model:, loops:, provider:)
    @input = input
    @output = output
    @model = model
    @loops = loops
    @provider = provider
  end

  def run
    svg = nil
    latest_png_path = nil

    loops.times do |i|
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

      svg = sanitize_response(response.content)
      latest_png_path = File.join(output, "#{model.gsub('/', '-')}_#{i}.png")

      begin
        Vips::Image.new_from_buffer(svg, "", dpi: 144)
                   .write_to_file(latest_png_path)
      rescue StandardError
        puts svg
      end

      File.write(latest_png_path.gsub(".png", ".svg"), svg)
    end
  end

  def sanitize_response(response)
    response.gsub(/^```\S+/, "").gsub(/^```/, "").strip
  end

  def self.from_slop
    opts ||= Slop.parse do |o|
      o.string "-i", "--input", "Input image file", required: true
      o.string "-o", "--output", "Output directory", default: "./output"
      o.string "-m", "--model", "Model", default: "anthropic/claude-sonnet-4.5"
      o.integer "-n", "--iterations", "Number of iterations", default: 4
      o.string "-p", "--provider", "Model provider", default: "openrouter"

      o.on "-h", "--help" do
        puts
        puts "Add your provider API key to `.env`"
        puts
        puts o
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

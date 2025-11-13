#!/usr/bin/env ruby

require "bundler/inline"

gemfile(true, quiet: true) do
  source "https://rubygems.org"

  gem "slop"
end

class Agent
  def opts
    @opts ||= Slop.parse do |o|
      o.string "-i", "--input", "Input image file", required: true
      o.string "-o", "--output", "Output directory", default: "./output"
      o.string "-m", "--model", "Model", default: "gemini-2.5-flash"
      o.integer "-n", "--num-iterations", "Number of agent loop iterations", default: 4

      o.on "-h", "--help" do
        puts o
        exit
      end
    end
  rescue Slop::Error => e
    puts e.message
    exit 1
  end
end

p Agent.new.opts

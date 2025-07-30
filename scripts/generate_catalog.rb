#!/usr/bin/env ruby

require "bundler/setup"
require "ruby_ui_mcp"
require "json"

class CatalogGenerator
  DOCS_URL = "https://rubyui.com/docs/introduction/"

  def initialize(output_file)
    @output_file = output_file
  end

  def generate
    puts("Pulling component references from #{DOCS_URL}...")

    references = fetch_component_references

    puts "Found #{references.size} components."
    puts "Fetching components..."

    components = references.map do
      puts "Fetching component: #{it.name} from #{it.url}"

      [it.url, fetch_component(it.url)]
    end

    output_catalog(components)
  end

  private

  def fetch_component_references
    docs = RubyUI_MCP::Docs.download(DOCS_URL)
    docs.component_references
  end

  def fetch_component(url)
    docs = RubyUI_MCP::Docs.download(url)
    docs.component
  end

  def output_catalog(components)
    File.open(@output_file, "w") do |file|
      build_catalog(components)
    end
  end

  def build_catalog(components)
    catalog = {"components" => []}

    components.each do |url, component|
      catalog["components"] << {
        "name" => component.name,
        "description" => component.description,
        "url" => url
      }
    end

    File.write(@output_file, JSON.pretty_generate(catalog))
  end
end

def main
  if ARGV.empty?
    puts "Usage: ruby generate_catalog.rb <output_file>"
    exit 1
  end

  output_file = ARGV[0]

  generator = CatalogGenerator.new(output_file)
  generator.generate
end

main

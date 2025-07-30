# frozen_string_literal: true

module RubyUI_MCP
  class Docs
    class Error < StandardError; end

    BASE_URL = "https://rubyui.com/"

    def initialize(content)
      @parser = DocsApi::Parser.new(content)
    end

    def self.download(url)
      response = Net::HTTP.get(URI(url))

      raise Error, "Failed to download content from #{url}" if response.nil? || response.empty?

      new(response)
    end

    def component_references
      @_component_references ||= @parser.parse_component_references.map do |ref|
        ref.url = URI.join(BASE_URL, URI.parse(ref.url).path).to_s

        ref
      end
    end

    def component
      @_component ||= @parser.parse_component
    end
  end
end

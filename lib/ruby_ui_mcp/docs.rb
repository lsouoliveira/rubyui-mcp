# frozen_string_literal: true

module RubyUI_MCP
  class Docs
    BASE_URL = "https://rubyui.com/"

    def initialize(content)
      @parser = DocsApi::Parser.new(content)
    end

    def self.download(url)
      response = Net::HTTP.get(URI(url))

      new(response)
    end

    def component_references
      @parser.parse_component_references.map do |ref|
        ref.url = URI.join(BASE_URL, URI.parse(ref.url).path).to_s

        ref
      end
    end

    def get_component(name)
      raise NotImplementedError
    end
  end
end

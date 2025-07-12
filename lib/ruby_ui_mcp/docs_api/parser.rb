# frozen_string_literal: true

module RubyUI_MCP
  module DocsApi
    class Parser
      def initialize(content)
        @doc = Nokogiri::HTML(content)
      end

      def parse_component_references
        containers = @doc.css('div[data-controller*="sidebar-menu"] div.grid')

        return [] if containers.nil? || containers.count < 3

        components_list = containers[2]

        components_list.css("a").map do |link|
          Objects::ComponentReference.new(
            name: link.inner_text&.strip,
            url: link["href"]&.strip
          )
        end
      end

      def parse_component
      end
    end
  end
end

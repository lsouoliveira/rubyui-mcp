# frozen_string_literal: true

module RubyUI_MCP
  module DocsApi
    class Parser
      def initialize(content)
        @content = content
      end

      def parse_component_references
        ComponentReferencesExtractor.new(
          @content,
          selectors: {
            sidebar_groups: 'div[data-controller*="sidebar-menu"] div.grid',
            sidebar_entry: "a"
          }
        ).extract
      end

      def parse_component
        ComponentExtractor.new(
          @content,
          selectors: {
            title: "main h1",
            description: "main h1 + p",
            examples: "main div div[id]",
            installation_cmd: "p:contains('Run the install command') + div pre",
            dependencies: "main div[data-value='manual'] div div div.relative div.overflow-hidden"
          }
        ).extract
      end
    end
  end
end

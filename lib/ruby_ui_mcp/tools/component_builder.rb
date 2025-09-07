module RubyUI_MCP
  module Tools
    class ComponentBuilder < FastMcp::Tool
      tool_name "component_builder"

      description "Retrieve documentation for all filtered components to prepare for component generation, This tool ONLY returns the text snippet for that UI component. After calling this tool, you must edit or add files to integrate the snippet into the codebase."

      arguments do
        required(:components)
          .filled(:string)
          .description("Components from components-filter tool, containing component objects with name, necessity, and justification")
      end

      def call(components:)
        parsed_components = parse_components(components)
        filtered_components = filter_components(parsed_components)
        component_docs = fetch_component_docs(filtered_components)

        RubyUI_MCP::Services::ComponentDocumentationFormatter.generate(component_docs)
      end

      private

      def parse_components(components)
        parsed_data = JSON.parse(components)

        parsed_data.is_a?(Array) ? parsed_data : parsed_data["components"]
      rescue JSON::ParserError
        raise ArgumentError, "Invalid components format. Expected a JSON array."
      end

      def filter_components(components)
        filtered_components = RubyUI_MCP::Services::ComponentNecessityFilter.filter_by_necessity(
          components,
          "optional"
        )

        raise ArgumentError, "No components found with the specified necessity." if filtered_components.empty?

        filtered_components
      end

      def fetch_component_docs(components)
        components.map do |component|
          fetch_component_doc(component["name"])
        end
      end

      def fetch_component_doc(component_name)
        doc = RubyUI_MCP.cached_components_service.get_component(component_name)

        {
          name: component_name,
          type: "component",
          doc: RubyUI_MCP::Services::ComponentDocRenderer.render(doc)
        }
      rescue => e
        RubyUI_MCP.logger.warn("Failed to fetch documentation for component '#{component_name}': #{e.message}")

        {
          name: component_name,
          type: "component",
          doc: "Documentation not available for this component. Error: #{e.message}"
        }
      end
    end
  end
end

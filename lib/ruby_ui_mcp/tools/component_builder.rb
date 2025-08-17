module RubyUI_MCP
  module Tools
    class ComponentBuilder < FastMcp::Tool
      description "Retrieve documentation for all filtered components to prepare for component generation. This tool ONLY returns the documentation for the UI components."

      arguments do
        required(:components).filled(:string).description("Components array from components-filter tool, containing component objects with name, necessity, and justification")
      end

      def call(components:)
        parsed_components = parse_components(components)
        filtered_components = filter_components(parsed_components)
        component_docs = fetch_component_docs(filtered_components)

        {
          content: [
            {
              type: "text",
              text: RubyUI_MCP::Services::ComponentDocumentationFormatter.generate(component_docs)
            }
          ]
        }
      end

      private

      def parse_components(components)
        JSON.parse(components)
      rescue JSON::ParserError
        raise ArgumentError, "Invalid components format. Expected a JSON array."
      end

      def filter_components(components)
        filtered_components = RubyUI_MCP::Services::ComponentNecessityFilter.filter_by_necessity(
          components,
          "optional"
        )

        if filtered_components.empty?
          raise ArgumentError, "No components found with the specified necessity."
        end

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
        {
          name: component_name,
          type: "component",
          doc: "Documentation not available for this component. Error: #{e.message}"
        }
      end
    end
  end
end

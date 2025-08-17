module RubyUI_MCP
  module Tools
    class ComponentsUsageDoc < FastMcp::Tool
      description "Read usage documentation of a RubyUI component. Use this tool when mentions /doc or when you need to get detailed documentation for a specific component."

      arguments do
        required(:name).filled(:string).description("Name of the component in lowercase (e.g., 'button', 'card', 'dialog', 'aspect ratio')")
      end

      def call(name:)
        component = RubyUI_MCP.catalog.search_component(name)

        if component.nil?
          return {
            content: [
              {
                type: "text",
                text: "Error: Component '#{name}' not found in the RubyUI catalog. Please check the component name and try again."
              }
            ]
          }
        end

        component_doc = create_component_doc(name, component)

        {
          content: [
            {
              type: "text",
              text: component_doc
            }
          ]
        }
      end

      private

      def create_component_doc(name, catalog_component)
        component = RubyUI_MCP.cached_components_service.get_component(name)

        renderer = RubyUI_MCP::Services::ComponentDocRenderer.new(component)
        renderer.render
      end
    end
  end
end

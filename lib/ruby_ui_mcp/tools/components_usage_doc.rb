module RubyUI_MCP
  module Tools
    class ComponentsUsageDoc < FastMcp::Tool
      tool_name "components_usage_doc"

      description "Read usage documentation of a RubyUI component. Use this tool when mentions /doc or when you need to get detailed documentation for a specific component."

      arguments do
        required(:name)
          .filled(:string)
          .description("Name of the component in lowercase (e.g., 'button', 'card', 'dialog', 'aspect ratio')")
      end

      def call(name:)
        component = RubyUI_MCP.catalog.search_component(name)

        raise "Component '#{name}' not found in the RubyUI catalog." if component.nil?

        get_component_doc(name, component)
      end

      private

      def get_component_doc(name, catalog_component)
        component = RubyUI_MCP.cached_components_service.get_component(name)

        renderer = RubyUI_MCP::Services::ComponentDocRenderer.new(component)
        renderer.render
      end
    end
  end
end

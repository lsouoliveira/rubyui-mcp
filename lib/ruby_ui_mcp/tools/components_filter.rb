module RubyUI_MCP
  module Tools
    class ComponentsFilter < FastMcp::Tool
      PROMPT_NAME = "components_filter.md"

      tool_name "components_filter"

      description "Filter components with RubyUI components and TailwindCSS. Use this tool when mentions /filter or when you need to select appropriate components based on structured requirements."

      arguments do
        required(:message)
          .filled(:string)
          .description("Requirement JSON from requirement-structuring tool")
      end

      def call(message:)
        render_prompt(message)
      rescue JSON::ParserError
        raise "Invalid input format. Expected structured JSON."
      end

      private

      def render_prompt(ui_requirement)
        prompt_template % {
          ui_requirement: JSON.pretty_generate(JSON.parse(ui_requirement)),
          components_list: "AVAILABLE_COMPONENTS:\n#{load_components_list}"
        }
      end

      def load_components_list
        catalog_path = File.join(File.dirname(__FILE__), "../../../catalog.json")
        catalog = JSON.parse(File.read(catalog_path))

        catalog["components"].map do |component|
          format_component(component)
        end.join("\n")
      end

      def format_component(component)
        "- { \"name\": \"#{component["name"]}\", \"description\": \"#{component["description"]}\" } }"
      end

      def prompt_template
        @_prompt ||= RubyUI_MCP.prompt_library.get_prompt(PROMPT_NAME)
      end
    end
  end
end

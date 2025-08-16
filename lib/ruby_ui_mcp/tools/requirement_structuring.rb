module RubyUI_MCP
  module Tools
    class RequirementStructuring < FastMcp::Tool
      PROMPT_NAME = "requirement_structuring.md"

      description "Analyze the user's natural language and structure the requirements into a clear and structured component requirement document. Use this tool when the user requests a new UI component—e.g., mentions /ui, or asks for a button, input, dialog, table, form, banner, card, or other RubyUI component."

      arguments do
        required(:message).filled(:string).description("Content about user requirement in specific contextual information")
      end

      def call(message:)
        {
          content: [
            {
              type: "text",
              text: prompt
            }
          ]
        }
      end

      private

      def prompt
        @_prompt ||= RubyUI_MCP.prompt_library.get_prompt(PROMPT_NAME)
      end
    end
  end
end

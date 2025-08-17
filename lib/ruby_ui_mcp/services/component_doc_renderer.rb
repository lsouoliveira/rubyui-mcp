module RubyUI_MCP
  module Services
    class ComponentDocRenderer
      def initialize(component)
        @component = component

        raise ArgumentError, "Component cannot be nil" if @component.nil?
      end

      def render
        content = [
          render_description,
          render_installation,
          render_dependencies,
          render_examples
        ].compact.reject(&:empty?)

        return default_message if content.empty?

        content.join("\n")
      end

      def self.render(component)
        new(component).render
      end

      private

      def render_description
        return "" if @component.description && @component.description.empty?

        "## Description\n#{@component.description}\n"
      end

      def render_installation
        return "" if @component.installation_cmd && @component.installation_cmd.empty?

        "## Installation\n```bash\n#{@component.installation_cmd}\n```\n"
      end

      def render_dependencies
        return "" unless @component.dependencies&.any?

        content = "## Dependencies\n"

        @component.dependencies.each do |dep|
          content += "- **#{dep.name}**:\n"
          content += "```ruby\n#{dep.source.strip}\n```\n"
          content += "- Path: `#{dep.path}`\n" if dep.path
        end

        content + "\n"
      end

      def render_examples
        return "" unless @component.examples&.any?

        content = "## Examples\n"

        @component.examples.each_with_index do |example, index|
          content += render_single_example(example, index)
        end

        content
      end

      def render_single_example(example, index)
        content = example_title(example, index) + "\n"
        content += render_example_description(example)
        content += render_example_source(example)
        content
      end

      def example_title(example, index)
        if !example.name&.empty?
          "### #{example.name}"
        else
          "### Example #{index + 1}"
        end
      end

      def render_example_description(example)
        return "" if example.description && example.description.empty?

        "#{example.description}\n\n"
      end

      def render_example_source(example)
        return "" if example.source && example.source.empty?

        "```ruby\n#{example.source.strip}\n```\n\n"
      end

      def default_message
        "This RubyUI component documentation is available but contains no detailed information."
      end
    end
  end
end

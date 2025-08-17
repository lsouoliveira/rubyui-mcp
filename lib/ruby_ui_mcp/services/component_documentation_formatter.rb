module RubyUI_MCP
  module Services
    class ComponentDocumentationFormatter
      def initialize(component_docs)
        @component_docs = component_docs
      end

      def generate
        markdown = header
        markdown += components_section if @component_docs.any?
        markdown += summary_section
        markdown
      end

      def self.generate(component_docs)
        new(component_docs).generate
      end

      private

      def header
        "# RubyUI Components Documentation\n\n"
      end

      def components_section
        content = "## Components\n\n"

        @component_docs.each_with_index do |component, index|
          content += component_section(component, index)
        end

        content
      end

      def component_section(component, index)
        component_title = format_component_title(component[:name])

        "### #{index + 1}. #{component_title} Component\n\n" \
        "#{component[:doc]}\n\n" \
        "---\n\n"
      end

      def format_component_title(name)
        name.to_s.split("-").map(&:capitalize).join(" ")
      end

      def summary_section
        "## Summary\n\n" \
        "- **Total Components**: #{@component_docs.length}\n" \
      end
    end
  end
end

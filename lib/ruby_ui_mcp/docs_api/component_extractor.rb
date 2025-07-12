module RubyUI_MCP
  module DocsApi
    class ComponentExtractor
      def initialize(content, selectors: {})
        @doc = Nokogiri::HTML(content)
        @selectors = selectors
      end

      def extract
        Objects::Component.new(
          name: extract_title,
          description: extract_description,
          examples: extract_examples,
          installation_cmd: extract_installation_cmd,
          dependencies: extract_dependencies
        )
      end

      private

      def extract_text(selector) = @doc.at_css(selector)&.text&.strip

      def extract_title = extract_text(@selectors[:title])

      def extract_description = extract_text(@selectors[:description])

      def extract_installation_cmd = extract_text(@selectors[:installation_cmd])

      def extract_examples
        @doc.css(@selectors[:examples]).map do |example|
          Objects::Example.new(
            name: example["id"].to_s.strip,
            description: example.at_css("p")&.text.to_s.strip,
            source: example.at_css("pre")&.text.to_s
          )
        end
      end

      def extract_dependencies
        @doc.css(@selectors[:dependencies]).filter_map do |dependency|
          title = dependency.at_css("p")&.text.to_s.strip

          next unless title&.match?(/Add .* to .*/)

          title_parts = title.split(" to ")
          name = title_parts.first.split(" ").last.strip
          path = title_parts.last.strip

          Objects::ComponentDependency.new(
            name:,
            path:,
            source: dependency.at_css("pre")&.text.to_s
          )
        end
      end
    end
  end
end

module RubyUI_MCP
  module DocsApi
    class ComponentReferencesExtractor
      def initialize(content, selectors: {})
        @doc = Nokogiri::HTML(content)
        @selectors = selectors
      end

      def extract
        sidebar_groups = @doc.css(@selectors[:sidebar_groups])

        return [] if sidebar_groups.nil? || sidebar_groups.count < 3

        sidebar_groups[2].css(@selectors[:sidebar_entry]).map do |link|
          build_component_reference(link)
        end
      end

      private

      def build_component_reference(link)
        Objects::ComponentReference.new(
          name: link.at_css(@selectors[:sidebar_entry_name])&.text&.strip,
          url: link["href"]&.strip
        )
      end
    end
  end
end

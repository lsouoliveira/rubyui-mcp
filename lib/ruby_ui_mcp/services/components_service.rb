module RubyUI_MCP
  module Services
    class ComponentsService
      def initialize(catalog)
        @catalog = catalog
      end

      def get_component(name)
        catalog_component = @catalog.search_component(name)

        raise "Component '#{name}' not found in catalog." if catalog_component.nil?

        docs = Docs.download(catalog_component.url)
        docs.component
      end
    end
  end
end

module RubyUI_MCP
  class ComponentsCatalogLoader
    def initialize(path)
      @path = path
    end

    def load
      file_content = File.read(@path)
      catalog_data = parse_catalog(file_content)
      components_map = build_components_map(catalog_data["components"])

      ComponentsCatalog.new(components_map)
    rescue Errno::ENOENT => e
      raise "Catalog file not found: #{e.message}"
    rescue JSON::ParserError => e
      raise "Failed to parse catalog file: #{e.message}"
    end

    private

    def parse_catalog(content)
      JSON.parse(content)
    rescue JSON::ParserError => e
      raise "Failed to parse catalog file: #{e.message}"
    end

    def build_components_map(components_data)
      components_data.each_with_object({}) do |data, map|
        component = build_component(data)
        map[component.name] = component
      end
    end

    def build_component(data)
      CatalogComponent.new(
        name: data["name"],
        description: data["description"],
        url: data["url"]
      )
    end
  end

  class CatalogComponent
    attr_reader :name, :description, :url

    def initialize(name:, description:, url:)
      @name = name
      @description = description
      @url = url
    end
  end

  class ComponentsCatalog
    def initialize(components_map)
      @components_map = components_map
    end

    def search_component(name)
      @components_map.find do |key, component|
        key.casecmp(name).zero?
      end&.last
    end

    def self.load(path)
      loader = ComponentsCatalogLoader.new(path)
      loader.load
    end
  end
end

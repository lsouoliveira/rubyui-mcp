module RubyUI_MCP
  module Services
    class ComponentNecessityFilter
      NECESSITY_SCORES = {
        "critical" => 3,
        "important" => 2,
        "optional" => 1
      }.freeze

      def initialize(min_necessity = "optional")
        @min_necessity = min_necessity
        @min_score = NECESSITY_SCORES[min_necessity] || 0
      end

      def filter(components)
        components.select do |component|
          component_necessity = component["necessity"]
          necessity_score(component_necessity) >= @min_score
        end
      end

      def self.filter_by_necessity(components, min_necessity)
        new(min_necessity).filter(components)
      end

      private

      def necessity_score(necessity)
        NECESSITY_SCORES[necessity] || 0
      end
    end
  end
end

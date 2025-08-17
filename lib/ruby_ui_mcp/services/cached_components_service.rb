module RubyUI_MCP
  module Services
    class CachedComponentsService
      EXPIRATION_TIME = 15 * 60

      class CacheEntry
        attr_reader :value, :timestamp

        def initialize(value, expiration_time: EXPIRATION_TIME)
          @value = value
          @timestamp = Time.now
          @expiration_time = expiration_time
        end

        def expired?
          (Time.now - @timestamp) > @expiration_time
        end
      end

      def initialize(catalog)
        @catalog = catalog
        @cache = {}
        @service = ComponentsService.new(catalog)
      end

      def get_component(name)
        cache(name) do
          @service.get_component(name)
        end
      end

      private

      def cache(key, expiration_time: EXPIRATION_TIME, &)
        entry = @cache[key]

        if entry.nil? || entry.expired?
          value = yield
          @cache[key] = CacheEntry.new(value)
          value
        else
          entry.value
        end
      end
    end
  end
end

# frozen_string_literal: true

require "test_helper"

module RubyUI_MCP
  module DocsApi
    class TestParser < BaseTest
      def test_component_references
        html = fixture_file("files/docs.html")
        parser = RubyUI_MCP::DocsApi::Parser.new(html)
        references = parser.parse_component_references

        assert_equal references.size, 43
        assert_equal references.first.name, "Accordion"
        assert_equal references.first.url, "/docs/accordion"
      end
    end
  end
end

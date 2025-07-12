require "test_helper"

module RubyUI_MCP
  class TestDocs < BaseTest
    def test_download
      Net::HTTP.stub :get, fixture_file("files/docs.html") do
        docs = RubyUI_MCP::Docs.download("http://localhost:1234/docs")

        assert_instance_of RubyUI_MCP::Docs, docs
      end
    end

    def test_component_references
      Net::HTTP.stub :get, fixture_file("files/docs.html") do
        docs = RubyUI_MCP::Docs.download("http://localhost:1234/docs")
        references = docs.component_references

        assert_equal references.size, 43
        assert_equal references.first.name, "Accordion"
        assert_equal references.first.url, "https://rubyui.com/docs/accordion"
      end
    end
  end
end

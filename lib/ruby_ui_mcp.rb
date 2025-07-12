# frozen_string_literal: true

require_relative "ruby_ui_mcp/version"

require "net/http"
require "nokogiri"

module RubyUI_MCP
  class Error < StandardError; end

  module DocsApi
    autoload :Objects, "ruby_ui_mcp/docs_api/objects"
    autoload :Parser, "ruby_ui_mcp/docs_api/parser"
    autoload :ComponentReferencesExtractor, "ruby_ui_mcp/docs_api/component_references_extractor"
    autoload :ComponentExtractor, "ruby_ui_mcp/docs_api/component_extractor"
  end

  autoload :Docs, "ruby_ui_mcp/docs"
end

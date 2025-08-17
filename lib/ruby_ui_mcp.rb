# frozen_string_literal: true

require_relative "ruby_ui_mcp/version"

require "net/http"
require "nokogiri"
require "fast_mcp"
require "logger"

module RubyUI_MCP
  class Error < StandardError; end

  module DocsApi
    autoload :Objects, "ruby_ui_mcp/docs_api/objects"
    autoload :Parser, "ruby_ui_mcp/docs_api/parser"
    autoload :ComponentReferencesExtractor, "ruby_ui_mcp/docs_api/component_references_extractor"
    autoload :ComponentExtractor, "ruby_ui_mcp/docs_api/component_extractor"
  end

  module Tools
    autoload :RequirementStructuring, "ruby_ui_mcp/tools/requirement_structuring"
    autoload :ComponentsFilter, "ruby_ui_mcp/tools/components_filter"
  end

  autoload :Docs, "ruby_ui_mcp/docs"
  autoload :Server, "ruby_ui_mcp/server"
  autoload :PromptLibrary, "ruby_ui_mcp/prompt_library"
  autoload :DefaultServer, "ruby_ui_mcp/default_server"

  def self.logger
    return @logger if defined?(@logger)

    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO

    @logger
  end

  def self.prompt_library
    @_prompt_library ||= PromptLibrary.new
  end

  def self.setup
    load_prompts
  end

  private

  def self.load_prompts
    Dir.glob(File.join(__dir__, "ruby_ui_mcp", "prompts", "*.md")).each do |file|
      filename = File.basename(file)

      prompt_library.load_prompt(filename)
    end
  end
end

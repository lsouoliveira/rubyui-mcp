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
    autoload :ComponentsUsageDoc, "ruby_ui_mcp/tools/components_usage_doc"
  end

  module Services
    autoload :ComponentsService, "ruby_ui_mcp/services/components_service"
    autoload :CachedComponentsService, "ruby_ui_mcp/services/cached_components_service"
    autoload :ComponentDocRenderer, "ruby_ui_mcp/services/component_doc_renderer"
  end

  autoload :Docs, "ruby_ui_mcp/docs"
  autoload :Server, "ruby_ui_mcp/server"
  autoload :PromptLibrary, "ruby_ui_mcp/prompt_library"
  autoload :DefaultServer, "ruby_ui_mcp/default_server"
  autoload :ComponentsCatalog, "ruby_ui_mcp/components_catalog"
  autoload :Config, "ruby_ui_mcp/config"

  def self.logger
    return @logger if defined?(@logger)

    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO

    @logger
  end

  def self.setup
    config.prompt_library = PromptLibrary.new
    config.catalog = ComponentsCatalog.load(File.join(__dir__, "..", "catalog.json"))

    load_prompts
  end

  def self.config
    @config ||= Config.new
  end

  def self.prompt_library = config.prompt_library

  def self.catalog = config.catalog

  def self.cached_components_service
    @cached_components_service ||= Services::CachedComponentsService.new(catalog)
  end

  private

  def self.load_prompts
    Dir.glob(File.join(__dir__, "ruby_ui_mcp", "prompts", "*.md")).each do |file|
      config.prompt_library.load_prompt(File.basename(file))
    end
  end
end

# frozen_string_literal: true

module RubyUI_MCP
  module DocsApi
    module Objects
      Component = Struct.new(:name, :description, :examples, :installation_cmd, :dependencies, keyword_init: true)
      ComponentDependency = Struct.new(:name, :source, :path, keyword_init: true)
      ComponentReference = Struct.new(:name, :url, keyword_init: true)
      Example = Struct.new(:name, :description, :source, keyword_init: true)
    end
  end
end

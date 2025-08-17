module RubyUI_MCP
  class DefaultServer
    def initialize
      @server = Server.new
    end

    def setup
      @server.register_tool(Tools::RequirementStructuring)
      @server.register_tool(Tools::ComponentsFilter)
      @server.register_tool(Tools::ComponentsUsageDoc)
    end

    def start
      @server.start
    end
  end
end

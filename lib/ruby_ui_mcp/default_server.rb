module RubyUI_MCP
  class DefaultServer
    def initialize
      @server = Server.new
    end

    def setup
      @server.register_tool(Tools::RequirementStructuring)
    end

    def start
      @server.start
    end
  end
end

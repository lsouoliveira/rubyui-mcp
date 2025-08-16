module RubyUI_MCP
  class Server
    NAME = "ruby_ui-mcp-server"

    attr_reader :server

    def initialize
      @logger = FastMcp::Logger.new(transport: :stdout)
      @server = FastMcp::Server.new(name: NAME, version: RubyUI_MCP::VERSION, logger: @logger)
    end

    def register_tool(tool)
      server.register_tool(tool)
    end

    def start = server.start
  end
end

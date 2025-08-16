module RubyUI_MCP
  class PromptLibrary
    def initialize
      @prompts = {}
    end

    def load_prompt(file_path)
      return @prompts[file_path] if @prompts.key?(file_path)

      fullpath = File.join(__dir__, "prompts", file_path)

      unless File.exist?(fullpath)
        raise "Prompt file not found: #{file_path}"
      end

      content = File.read(fullpath)

      @prompts[file_path] = content
    end

    def get_prompt(file_path)
      prompt = @prompts[file_path]

      raise "Prompt not found: #{file_path}" unless prompt

      prompt
    end
  end
end

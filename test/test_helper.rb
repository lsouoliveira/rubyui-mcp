# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "ruby_ui_mcp"

require "minitest/autorun"

class BaseTest < Minitest::Test
  def fixture_file(name)
    File.read(File.expand_path(File.join("fixtures", name), __dir__))
  end
end

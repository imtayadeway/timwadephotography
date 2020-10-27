require "bundler/setup"
require "minitest/autorun"
require "portfolio"

class TestPhoto < Minitest::Test
  def test_something
    Portfolio::Photo.new(name: "A Cat", path: "cat.jpg", alt_text: "a cat")
  end
end

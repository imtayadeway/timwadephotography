require "minitest/autorun"
require "mayatideway/photo"

class TestPhoto < Minitest::Test
  def test_something
    Mayatideway::Photo.new(path: "cat.jpg", category: "memes", alt_text: "a cat")
  end
end

require 'minitest/autorun'

require_relative './src'

class SquareTest < MiniTest::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_ok
    # Проверяем, что наша функция действительно возводит в квадрат
    # 81 == 9^2
    assert_equal 81, square(9)
  end

  # Fake test
  def test_fail
    # Проверяем, что метод выбросит исключение, если передать ему не то
    assert_raises NoMethodError do
      square 'aaa'
    end
  end
end

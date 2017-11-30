require 'test_helper'

class Lr8LogicControllerTest < ActionDispatch::IntegrationTest
  test "should get input" do
    get lr8_logic_input_url
    assert_response :success
  end

  test "should get output" do
    get lr8_logic_output_url
    assert_response :success
  end

end

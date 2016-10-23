require 'test_helper'

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get line_items_new_url
    assert_response :success
  end

  test "should get create" do
    get line_items_create_url
    assert_response :success
  end

  test "should get destroy" do
    get line_items_destroy_url
    assert_response :success
  end

  test "should get show" do
    get line_items_show_url
    assert_response :success
  end

end

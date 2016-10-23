require 'test_helper'

class CollectionControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get collection_new_url
    assert_response :success
  end

  test "should get create" do
    get collection_create_url
    assert_response :success
  end

  test "should get show" do
    get collection_show_url
    assert_response :success
  end

end

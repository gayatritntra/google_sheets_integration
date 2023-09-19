require "test_helper"

class DataEntriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get data_entries_index_url
    assert_response :success
  end

  test "should get new" do
    get data_entries_new_url
    assert_response :success
  end

  test "should get create" do
    get data_entries_create_url
    assert_response :success
  end
end

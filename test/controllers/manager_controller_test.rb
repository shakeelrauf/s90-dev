require 'test_helper'

class ManagerControllerTest < ActionDispatch::IntegrationTest
  test "should get artist_new" do
    get manager_artist_new_url
    assert_response :success
  end

  test "should get artist_save" do
    get manager_artist_save_url
    assert_response :success
  end

  test "should get artists" do
    get manager_artists_url
    assert_response :success
  end

end

require "test_helper"

class DailyreportsControllerTest < ActionDispatch::IntegrationTest
  test "should get ressources" do
    get dailyreports_ressources_url
    assert_response :success
  end
end

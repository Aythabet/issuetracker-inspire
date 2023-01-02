require "test_helper"

class IssuesControllerTest < ActionDispatch::IntegrationTest
  test "should get resources" do
    get issues_resources_url
    assert_response :success
  end
end

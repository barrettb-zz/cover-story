require "test_helper"

describe DashboardController do
  it "should get index" do
    get :index
    assert_response :success
  end

end

require "test_helper"

describe RequestsController do
  it "should get list" do
    get :list
    assert_response :success
  end

end

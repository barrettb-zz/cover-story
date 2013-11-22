require "test_helper"

describe LogImportController do
  describe "fetch_parse" do
    it "returns success false if log :type not in params hash " do
      get :fetch_parse, :format => :json
      assert_response :success
    end
  end
end
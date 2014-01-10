require "test_helper"

describe AnalyzedRoutes do
  before do
    @analyzed_routes = AnalyzedRoutes.new
  end

  it "must be valid" do
    @analyzed_routes.valid?.must_equal true
  end
end

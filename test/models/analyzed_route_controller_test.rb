require "test_helper"

describe AnalyzedRouteModel do
  before do
    @analyzed_route_model = AnalyzedRouteModel.new
  end

  it "must be valid" do
    @analyzed_route_model.valid?.must_equal true
  end
end

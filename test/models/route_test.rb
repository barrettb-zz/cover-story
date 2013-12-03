require "test_helper"

describe Route do
  before do
    @route = Route.new
  end

  it "must be valid" do
    @route.valid?.must_equal true
  end
end

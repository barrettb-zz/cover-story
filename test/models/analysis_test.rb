require "test_helper"

describe Analysis do
  before do
    @analysis = Analysis.new
  end

  it "must be valid" do
    @analysis.valid?.must_equal true
  end
end

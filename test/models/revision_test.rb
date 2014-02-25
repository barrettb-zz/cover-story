require "test_helper"

describe Revision do
  before do
    @revision = Revision.new
  end

  it "must be valid" do
    @revision.valid?.must_equal true
  end
end

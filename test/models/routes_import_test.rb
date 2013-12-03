require "test_helper"

describe RoutesImport do
  before do
    @routes_import = RoutesImport.new
  end

  it "must be valid" do
    @routes_import.valid?.must_equal true
  end
end

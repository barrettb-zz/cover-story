require "test_helper"

describe RoutesImportSource do
  before do
    @routes_import_source = RoutesImportSource.new
  end

  it "must be valid" do
    @routes_import_source.valid?.must_equal true
  end
end

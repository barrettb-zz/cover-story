require "test_helper"

describe RoutesImportParent do
  before do
    @routes_import_parent = RoutesImportParent.new
  end

  it "must be valid" do
    @routes_import_parent.valid?.must_equal true
  end
end

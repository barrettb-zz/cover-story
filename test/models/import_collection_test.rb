require "test_helper"

describe ImportCollection do
  before do
    @import_collection = ImportCollection.new
  end

  it "must be valid" do
    @import_collection.valid?.must_equal true
  end

  context "scoping" do
    it 'must scope for active records' do
      ImportCollection.active.pluck(:id).include?(1).must_equal true
      ImportCollection.active.pluck(:id).include?(23).must_equal false
      ImportCollection.unscoped.pluck(:id).include?(23).must_equal true
    end

    it 'must scope for active records by default' do
      ImportCollection.active.must_equal ImportCollection.all
      ImportCollection.active.wont_equal ImportCollection.unscoped
    end
  end

end

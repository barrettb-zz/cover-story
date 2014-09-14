require 'test_helper'

describe ProductionPath do
  before do
    @production_path = ProductionPath.new(analysis_id: 333)
  end

  it 'must be valid' do
    @production_path.valid?.must_equal true
  end

  it 'must scope for all time' do
    c = ProductionPath.all_time
    c.pluck(:path).must_include 'postings/in/space', 'pools/in/space'
    c.pluck(:path).wont_include 'inactives/in/space'
    c.pluck(:analysis_id).must_include 1, 2
    c.pluck(:analysis_id).wont_include 23
  end

  it 'must validate for analysis_id' do
    c = ProductionPath.create
    c.errors[:analysis_id].must_include "can't be blank"
  end

  it 'must allow for bulk path creation' do
    a = Analysis.find(1)
    a.production_paths.create_paths(
      ["path/to/a", "path/to/b", "path/to/b"])
    ap = a.production_paths.where(analysis_id: 1, path: "path/to/a")
    bp = a.production_paths.where(analysis_id: 1, path: "path/to/b")
    ap.count.must_equal 1 # only one record no matter what
    ap.first.count.must_equal 1 # one instance
    bp.count.must_equal 1 # only one record no matter what
    bp.first.count.must_equal 2 # two instances
  end
end

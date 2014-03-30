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
    c.pluck(:path).wont_include 'inactive/in/space'
    c.pluck(:analysis_id).must_include 1, 2
    c.pluck(:analysis_id).wont_include 23
  end

  it 'must validate for analysis_id' do
    c = ProductionPath.create
    c.errors[:analysis_id].must_include "can't be blank"
  end

  it 'must allow for bulk path creation' do
    t = Time.now.to_i
    a = Analysis.find(1)
    a.production_paths.create_paths(["a#{t}/n/space", "b#{}{t}/n/space"])
    ProductionPath.where(path: "a#{t}/n/space").any?.must_equal true
    ProductionPath.where(path: "b#{}{t}/n/space").any?.must_equal true
  end
end

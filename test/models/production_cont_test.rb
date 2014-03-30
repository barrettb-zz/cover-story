require 'test_helper'

describe ProductionCont do
  before do
    @production_cont = ProductionCont.new(analysis_id: 333)
  end

  it 'must be valid' do
    @production_cont.valid?.must_equal true
  end

  it 'must scope for all time' do
    c = ProductionCont.all_time
    c.pluck(:controller).must_include 'PostingController', 'PoolController'
    c.pluck(:controller).wont_include 'InactiveController'
    c.pluck(:analysis_id).must_include 1, 2
    c.pluck(:analysis_id).wont_include 23
  end

  it 'must validate for analysis_id' do
    c = ProductionCont.create
    c.errors[:analysis_id].must_include "can't be blank"
  end

  it 'must allow for bulk controller creation' do
    t = Time.now.to_i
    a = Analysis.find(1)
    a.production_conts.create_controllers(["A#{t}Controller", "B#{t}Controller"])
    ProductionCont.where(controller: "A#{t}Controller").any?.must_equal true
    ProductionCont.where(controller: "B#{t}Controller").any?.must_equal true
  end
end

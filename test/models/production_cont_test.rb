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
    c.pluck(:controller).must_include 'PostingsController', 'PoolsController'
    c.pluck(:controller).wont_include 'InactivesController'
    c.pluck(:analysis_id).must_include 1, 2
    c.pluck(:analysis_id).wont_include 23
  end

  it 'must validate for analysis_id' do
    c = ProductionCont.create
    c.errors[:analysis_id].must_include "can't be blank"
  end

  it 'must allow for bulk controller creation' do
    a = Analysis.find(1)
    a.production_conts.create_controllers(
      ["AController", "BController", "BController"])
    ac = a.production_conts.where(analysis_id: 1, controller: 'AController')
    bc = a.production_conts.where(analysis_id: 1, controller: 'BController')
    ac.count.must_equal 1 # only one record no matter what
    ac.first.count.must_equal 1 # one instance
    bc.count.must_equal 1 # only one record no matter what
    bc.first.count.must_equal 2 # two instances
  end
end

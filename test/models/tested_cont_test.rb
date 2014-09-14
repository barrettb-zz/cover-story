require 'test_helper'

describe TestedCont do

  it 'must validate for analysis_id' do
    c = TestedCont.create
    c.errors[:analysis_id].must_include "can't be blank"
  end

  it 'must allow for bulk controller creation' do
    a = Analysis.find(1)
    a.tested_conts.create_controllers(
      ["AController", "BController", "BController"])
    ac = a.tested_conts.where(analysis_id: 1, controller: 'AController')
    bc = a.tested_conts.where(analysis_id: 1, controller: 'BController')
    ac.count.must_equal 1 # only one record no matter what
    ac.first.count.must_equal 1 # one instance
    bc.count.must_equal 1 # only one record no matter what
    bc.first.count.must_equal 2 # two instances
  end
end

require 'test_helper'

describe TestedPath do

  it 'must validate for analysis_id' do
    p = TestedPath.create
    p.errors[:analysis_id].must_include "can't be blank"
  end

  it 'must allow for bulk path creation' do
    a = Analysis.find(1)
    a.tested_paths.create_paths(
      ["path/to/a", "path/to/b", "path/to/b"])
    ap = a.tested_paths.where(analysis_id: 1, path: "path/to/a")
    bp = a.tested_paths.where(analysis_id: 1, path: "path/to/b")
    ap.count.must_equal 1 # only one record no matter what
    ap.first.count.must_equal 1 # one instance
    bp.count.must_equal 1 # only one record no matter what
    bp.first.count.must_equal 2 # two instances
  end
end

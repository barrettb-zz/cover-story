require 'test_helper'

describe Analysis do
  before do
    @analysis = Analysis.new
  end

  it 'must be valid' do
    @analysis.valid?.must_equal true
  end

  it 'must return calculation names' do
    c = Analysis.calculations
    c.include?('tested_paths_percentage').must_equal true
  end

  it 'must know if test data is present' do
    Analysis.has_test_data?('hr_suite').must_equal true
  end

  it 'must know if test data is not present' do
    TestedPath.unscoped.delete_all
    Analysis.has_test_data?('hr_suite').must_equal false
  end

  it 'must know if production data is present' do
    Analysis.has_production_data?('hr_suite').must_equal true
  end

  it 'must know if production data is not present' do
    ProductionPath.unscoped.delete_all
    Analysis.has_production_data?('hr_suite').must_equal false
  end

  context 'scoping' do # relies on fixture data heavily
    it 'must scope for having tested controllers' do
      a = Analysis.with_tested_controllers
      a.pluck(:id).include?(1).must_equal true
      a.pluck(:id).include?(22).must_equal false
    end

    it 'must scope for having tested paths' do
      a = Analysis.with_tested_paths
      a.pluck(:id).include?(1).must_equal true
      a.pluck(:id).include?(22).must_equal false
    end

    it 'must scope for having production controllers' do
      a = Analysis.with_production_controllers
      a.pluck(:id).include?(1).must_equal true
      a.pluck(:id).include?(22).must_equal false
    end

    it 'must scope for having production paths' do
      a = Analysis.with_production_paths
      a.pluck(:id).include?(1).must_equal true
      a.pluck(:id).include?(22).must_equal false
    end

    it 'must scope for application' do
      a = (Analysis.application('applicant_portal').map &:application)
      a.include?('applicant_portal').must_equal true
      a.include?('hr_suite').must_equal false
    end

    it 'must scope for active records' do
      Analysis.active.pluck(:id).include?(1).must_equal true
      Analysis.active.pluck(:id).include?(23).must_equal false
    end

    it 'must scope for active records by default' do
      Analysis.active.must_equal Analysis.all
      Analysis.active.wont_equal Analysis.unscoped
    end
  end
end

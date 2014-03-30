require "test_helper"

describe Analysis do
  before do
    @analysis = Analysis.new
  end

  it "must be valid" do
    @analysis.valid?.must_equal true
  end

  # relies on fixture data heavily
  context "scoping" do
    it "must scope for having tested controllers" do
      a = Analysis.with_tested_controllers
      a.pluck(:id).include?(1).must_equal true
      a.pluck(:id).include?(22).must_equal false
    end

    it "must scope for having tested paths" do
      a = Analysis.with_tested_paths
      a.pluck(:id).include?(1).must_equal true
      a.pluck(:id).include?(22).must_equal false
    end

    it "must scope for having production controllers" do
      a = Analysis.with_production_controllers
      a.pluck(:id).include?(1).must_equal true
      a.pluck(:id).include?(22).must_equal false
    end

    it "must scope for having production paths" do
      a = Analysis.with_production_paths
      a.pluck(:id).include?(1).must_equal true
      a.pluck(:id).include?(22).must_equal false
    end

    it "must scope for application" do
      a = (Analysis.application('applicant_portal').map &:application)
      a.include?("applicant_portal").must_equal true
      a.include?("hr_suite").must_equal false
    end

    it "must scope for active records" do
      Analysis.active.pluck(:id).include?(1).must_equal true
      Analysis.active.pluck(:id).include?(23).must_equal false
    end

    it "must scope for active records by default" do
      Analysis.active.must_equal Analysis.all
      Analysis.active.wont_equal Analysis.unscoped
    end
  end
end

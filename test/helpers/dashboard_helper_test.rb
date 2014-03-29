require 'test_helper'

describe DashboardHelper do
# see fixture

  context 'percentage data for graph' do
    let(:p) { percentage_data('hr_suite', 'tested_paths_percentage') }

    it 'should get data' do
      p.find_index(['22 Mar 14', 50.0]).wont_be_nil
    end

    it 'should include headers' do
      p.find_index(['Date', 'Percentage']).wont_be_nil
    end

    it 'should ignore applications not called for' do
      p.find_index(['24 Mar 14', 50.0]).must_be_nil
    end
  end

  context 'show_tested_list?' do
    it 'should accepted tested' do
      show_tested_list?('tested_paths_percentage').must_equal true
    end

    it 'should not accept non-tested values' do
      show_tested_list?('production_paths_percentage').must_equal false
    end
  end
end

require 'test_helper'

describe Formatter do

  context 'route path formatting' do
    it 'should remove extra space' do
      Formatter.format_route_path('/path/to/place ').must_equal('/path/to/place')
    end

    it 'should remove trailing /' do
      Formatter.format_route_path('/path/to/place/').must_equal('/path/to/place')
    end

    it 'should format the id' do
      f = Formatter.format_route_path('/postings/:posting_id/hello')
      f.must_equal '/postings/:id/hello'
    end
  end

  context 'log path formatting' do
    it 'should remove extra space' do
      Formatter.format_log_path('/path/to/place ').must_equal('/path/to/place')
    end

    it 'should remove trailing /' do
      Formatter.format_log_path('/path/to/place/').must_equal('/path/to/place')
    end

    it 'should format the id' do
      f = Formatter.format_log_path('/programs/1/party')
      f.must_equal('/programs/:id/party')
    end
  end
end

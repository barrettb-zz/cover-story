require 'test_helper'

describe Route do

  context 'scoping' do
    it 'should scope for active routes' do
      Route.active.pluck('id').must_include(1)
      Route.active.pluck('id').wont_include(23)
    end

    it 'should scope for inactive routes' do
      Route.inactive.pluck('id').must_include(23)
      Route.inactive.pluck('id').wont_include(1)
    end
  end

  context 'status' do
    it 'should return if a route is inactive' do
      r = Route.where(controller: 'InactivesController').last
      r.active?.must_equal false
    end

    it 'should return if a route is active' do
      r = Route.where(controller: 'PostingsController').last
      r.active?.must_equal true
    end

    it 'should allow for specific routes to be tagged as activated' do
      # ONLY route(s) specified
      r1 = Route.create(path: 'to/you', method: 'GET', inactive: true)
      r2 = Route.create(path: 'to/you', method: 'POST', inactive: true)
      r1.activate(false)
      r1.reload.active?.must_equal true
      r2.reload.active?.must_equal false
    end

    it 'should allow for all related routes to be tagged as activated' do
      # matching paths, all methods
      r1 = Route.create(path: 'to/you', method: 'GET', inactive: true)
      r2 = Route.create(path: 'to/you', method: 'POST', inactive: true)
      r1.activate
      r1.reload.active?.must_equal true
      r2.reload.active?.must_equal true
    end

    it 'should allow for specific routes to be tagged as inactivated' do
      # ONLY route(s) specified
      r1 = Route.create(path: 'to/you', method: 'GET')
      r2 = Route.create(path: 'to/you', method: 'POST')
      r1.inactivate(false)
      r1.reload.active?.must_equal false
      r2.reload.active?.must_equal true
    end

    it 'should allow for all related routes to be tagged as inactivated' do
      # matching paths, all methods
      r1 = Route.create(path: 'to/you', method: 'GET')
      r2 = Route.create(path: 'to/you', method: 'POST')
      r1.inactivate
      r1.reload.active?.must_equal false
      r2.reload.active?.must_equal false
    end
  end

  context 'history' do
    let :r do
      r = Route.create(path: 'to/you')
      r.inactivate
      r.reload
    end

    it 'should create history when inactivated' do
      r.histories.count.must_equal 1
      r.histories.first.inactivated.must_equal true
      r.histories.first.activated.wont_equal true
    end

    it 'should create history when activated' do
      r.activate
      r.reload
      r.histories.count.must_equal 2
      r.histories.last.inactivated.wont_equal true
      r.histories.last.activated.must_equal true
    end
  end

  it 'should be able to parse application from filename' do
    r = Route.create(filename: 'hamster_test_applicant_portal')
    r.application.must_equal 'applicant_portal'
  end

  it 'should return all Route paths' do
    Route.paths.must_include('postings/in/space')
    Route.paths.must_include('pools/in/space')
  end

  it 'should return all Route controllers' do
    Route.controllers.must_include('PostingsController')
    Route.controllers.must_include('PoolsController')
  end
end

class DashboardController < ApplicationController
  def index
    @las = LogAnalysisService.new(type: 'rails_route_diff')
    @untested_routes = @las.analyze(diff_type: "untested_routes")
    @unused_routes = @las.analyze(diff_type: "unused_routes")
    @untested_prod_routes = @las.analyze(diff_type: "untested_prod_routes")

  end
end

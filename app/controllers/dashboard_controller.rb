class DashboardController < ApplicationController
  def index
    @las = LogAnalysisService.new(type: 'rails_route_diff')
    @untested_routes_with_method = @las.analyze(diff_type: "untested_routes_with_method")
    @unused_routes_with_method = @las.analyze(diff_type: "unused_routes_with_method")
    @untested_prod_routes_with_method = @las.analyze(diff_type: "untested_prod_routes_with_method")
    @tested_routes_with_method = @las.analyze(diff_type: "tested_routes_with_method")

    @untested_routes = @las.analyze(diff_type: "untested_routes")
    @unused_routes = @las.analyze(diff_type: "unused_routes")
    @untested_prod_routes = @las.analyze(diff_type: "untested_prod_routes")
    @tested_routes = @las.analyze(diff_type: "tested_routes")
  end
end

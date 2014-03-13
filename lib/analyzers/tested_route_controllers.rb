class TestedRouteControllers

  def setup(params)
    @type = params[:type] # tested_route_controllers
    @import = ImportCollection.latest_valid
    @route_controllers = Route.active.controllers
    @test_log = LogSource.latest_valid_test
    @tested_controllers = @test_log.log_started_lines.controllers
    true
  end

  def analyze
    percentage_covered = Analysis.unique_percentage(@tested_controllers, @route_controllers)
    analysis = Analysis.create(
      import_collection_id: @import.id, 
      analysis_type: @type,
      percentage_covered: percentage_covered
    )

    @tested_controllers.uniq.each do |c|
      AnalyzedRouteController.create(
        analysis_id: analysis.id,
        controller: c,
        count: @tested_controllers.count(c)
      )
    end
  end
end
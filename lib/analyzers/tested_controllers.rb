class TestedControllers

  def setup(params)
    @type = params[:type] # tested_controllers
    @import = ImportCollection.latest_valid
    @route_controllers = Route.active.controllers
    @test_logs = @import.log_sources.test

    @tested_controllers = [ ]
    @test_logs.each do |l|
      l.log_processing_lines.controllers.each {|p| @tested_controllers << p }
    end

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
      AnalyzedController.create(
        analysis_id: analysis.id,
        controller: c,
        count: @tested_controllers.count(c)
      )
    end
  end
end

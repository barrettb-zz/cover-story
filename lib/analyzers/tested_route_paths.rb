class TestedRoutePaths

  def setup(params)
    @type = params[:type] # tested_route_paths
    @import = ImportCollection.latest_valid
    @route_paths = Route.active.paths
    @test_log = LogSource.latest_valid_test
    @tested_paths = @test_log.log_started_lines.paths
    true
  end

  def analyze
    percentage_covered = Analysis.unique_percentage(@tested_paths, @route_paths)
    analysis = Analysis.create(
      import_collection_id: @import.id, 
      analysis_type: @type,
      percentage_covered: percentage_covered
    )

    @tested_paths.uniq.each do |p|
      AnalyzedRoutePath.create(
        analysis_id: analysis.id,
        path: p,
        count: @tested_paths.count(p)
      )
    end
  end
end

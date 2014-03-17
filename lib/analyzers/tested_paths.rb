class TestedPaths

  def setup(params)
    @type = params[:type] # tested_paths
    @import = ImportCollection.latest_valid
    @route_paths = Route.active.paths
    @test_logs = @import.log_sources.test

    @tested_paths = [ ]
    @test_logs.each do |l|
      l.log_started_lines.paths.each {|p| @tested_paths << p }
    end

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
      AnalyzedPath.create(
        analysis_id: analysis.id,
        path: p,
        count: @tested_paths.count(p)
      )
    end
  end
end

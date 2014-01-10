class RouteDiffGenerator
  def self.generate_records(options)
    results = RouteDiff.analyze(options)

    case options[:diff_type]
    when "tested_routes"
      analysis = Analysis.new
      analysis.update_attributes(
        routes_import_parent_id: results[:routes_import_parent_id],
        source_id: results[:test_log_source_id],
        percentage_covered: results[:percentage],
        analysis_type: options[:diff_type]
      )

      route_paths = results[:route_formatted_paths]
      route_paths.uniq.each do |route_path|
        analyzed_route = AnalyzedRoutes.new
        analyzed_route.update_attributes(
          analysis_id: analysis.id,
          formatted_path: route_path,
          count: route_paths.count(route_path)
        )
      end
    end
  end
end

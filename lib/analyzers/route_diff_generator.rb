class RouteDiffGenerator
  def self.generate_records(options)
    results = RouteDiff.analyze(options)

    case options[:diff_type]
    when "tested_routes"
      analysis = Analysis.new
      analysis.update_attributes(
        routes_import_id: results[:routes_import_id],
        source_id: results[:test_log_source_id],
        percentage_covered: results[:percentage],
        model_percentage_covered: results[:model_percentage],
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

      route_models = results[:route_models]
      route_models.uniq.each do |route_model|
        unless route_model.nil?
          analyzed_route_model = AnalyzedRouteModel.new
          analyzed_route_model.update_attributes(
            analysis_id: analysis.id,
            model: route_model,
            count: route_models.count(route_model)
          )
        end
      end
    end
  end
end

class RouteDiff

  def setup(params)
    @diff_options = params
    return true
  end

  def analyze
    @diff_options.assert_valid_keys :analysis_type, :diff_type
    valid_diff_type?(@diff_options[:diff_type])

    # gather all the needed information
    @routes_import_id = routes_import_id
    @test_log_source_id = test_log_source_id
    @diff_routes = send(@diff_options[:diff_type])
    @diff_models = send("#{@diff_options[:diff_type]}_models")

    # create core analysis record
    analysis = Analysis.new
    analysis.update_attributes(
      routes_import_id: @routes_import_id,
      source_id: @test_log_source_id,
      analysis_type: @diff_options[:diff_type]
    )

    case @diff_options[:diff_type]
    when "tested_routes"
      # update attributes specific to 'tested'
      @diff_percenatge = send("#{@diff_options[:diff_type]}_percentage")
      @diff_models_percentage = send("#{@diff_options[:diff_type]}_model_percentage")
      analysis.update_attributes(
        percentage_covered: @diff_percenatge,
        model_percentage_covered: @diff_models_percentage
      )

      # gather tested routes, with counts, into their own table
      @diff_routes.uniq.each do |route_path|
        analyzed_route = AnalyzedRoutes.new
        analyzed_route.update_attributes(
          analysis_id: analysis.id,
          formatted_path: route_path,
          count: @diff_routes.count(route_path)
        )
      end

      # gather tested models, with counts, into their own table
      @diff_models.uniq.each do |route_model|
        unless route_model.nil?
          analyzed_route_model = AnalyzedRouteModel.new
          analyzed_route_model.update_attributes(
            analysis_id: analysis.id,
            model: route_model,
            count: @diff_models.count(route_model)
          )
        end
      end
    end
  end

private

  def tested_routes
    LogStartedLine.where(source_id: test_log_source_id).map &:formatted_path
  end

  def tested_routes_percentage
    compare = tested_routes
    total = routes_import_routes
    unique_percentage(compare, total)
  end

  def tested_routes_models
    LogStartedLine.where(source_id: test_log_source_id).map &:model
  end

  def tested_routes_model_percentage
    compare = tested_routes_models
    total = routes_import_models
    unique_percentage(compare, total)
  end

  def valid_diff_type?(option)
    valid_diff_types = [
#TODO add these back in?
#      "untested_routes_with_method",
#      "unused_routes_with_method",
#      "untested_prod_routes_with_method",
#      "tested_routes_with_method",
#      "untested_routes",
#      "unused_routes",
#      "untested_prod_routes",
      "tested_routes"
    ]
    return if option.in?(valid_diff_types)
    raise "Not suppported: #{option}"
  end

  def test_log_source_id
    valid_log_sources = LogSource.where(env: 'test').where(ignore: [false, nil])
    unless valid_log_sources.count > 0
      raise "There are no valid log sources"
    end
    valid_log_sources.last.id
  end

  def routes_import_id
    valid_routes_imports = RoutesImport.where(ignore: [false, nil])
    unless valid_routes_imports.count > 0
      raise "There are no valid routes imports"
    end
    valid_routes_imports.last.id
  end

  def routes_import_routes
    RoutesImport.last.routes.map &:formatted_path
  end

  def routes_import_models
    RoutesImport.last.routes.map &:model
  end

  def unique_percentage(compare_array, total_array)
    (compare_array.uniq.size.to_f/total_array.uniq.size) * 100
  end
end

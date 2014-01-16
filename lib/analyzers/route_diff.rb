class RouteDiff
  class << self

    def analyze(options)
      options.assert_valid_keys(:diff_type)
      valid_diff_type?(options[:diff_type])
      diff_routes = send(options[:diff_type])
      diff_percenatge = send("#{options[:diff_type]}_percentage")
      diff_models = send("#{options[:diff_type]}_models")
      diff_models_percentage = send("#{options[:diff_type]}_model_percentage")
      results = {
        routes_import_id: @routes_import_id,
        test_log_source_id: @test_log_source_id,
        percentage: diff_percenatge,
        route_formatted_paths: @route_formatted_paths,
        route_models: diff_models,
        model_percentage: diff_models_percentage
      }
    end

    def tested_routes
      @route_formatted_paths = StartedLine.where(source_id: test_log_source_id).map &:formatted_path
    end

    def tested_routes_percentage
      compare = tested_routes
      total = routes_import_routes
      unique_percentage(compare, total)
    end

    def tested_routes_models
      StartedLine.where(source_id: test_log_source_id).map &:model
    end

    def tested_routes_model_percentage
      compare = tested_routes_models
      total = routes_import_models
      unique_percentage(compare, total)
    end

  private

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
      @test_log_source_id = LogSource.where(env: 'test').last.id
    end

    def routes_import_id
      @routes_import_id = RoutesImport.last.id
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
end

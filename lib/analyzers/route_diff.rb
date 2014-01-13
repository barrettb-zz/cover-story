class RouteDiff

  class << self

    def analyze(options)
      options.assert_valid_keys(:diff_type)
      valid_diff_type?(options[:diff_type])
      diff_routes = send(options[:diff_type])
      diff_percenatge = send("#{options[:diff_type]}_percentage")
      results = {
        routes_import_parent_id: @routes_import_parent_id,
        test_log_source_id: @test_log_source_id,
        percentage: diff_percenatge,
        route_formatted_paths: @route_formatted_paths
      }
    end

    # does not imply fully tested, just that we test something about it
    def tested_models
      routes = tested_routes
      extract_models_from_routes(routes)
    end

    def rake_routes_models
      routes = rake_routes
      extract_models_from_routes(routes)
    end

    def tested_models_percentage
      compare = tested_models
      total = rake_routes_models
      unique_percentage(compare, total)
    end

    def extract_models_from_routes(routes)
      # remove any nils just to keep things happy
      routes = routes.compact

      # split the routes into their parts
      routes_segments = routes.map{ |r|
        r.split("/")
      }

      # removing blank values in array (since they split with a blank at start)
      routes_segments = routes_segments.map { |r|
        r.tap{ |a| a.delete "" } # this is to return the contents after deleting
      }

      # removing the prefix ("/hr")
      routes_path_prefix = APP_CONFIG[:routes_config][:routes_path_prefix].gsub("/", "")
      if routes_path_prefix
        routes_path_prefix_segment = routes_path_prefix.gsub("/", "")
        routes_segments = routes_segments.map { |r|
          r.tap{ |a| a.delete routes_path_prefix_segment } # this is to return the contents after deleting
        }
      end

      routes_segments.map {|a| a[0]}
    end

    def tested_routes
      @route_formatted_paths = StartedLine.where(source_id: test_log_source_id).map &:formatted_path
    end

    def tested_routes_percentage
      compare = tested_routes
      total = rake_routes
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

    def routes_import_parent_id
      @routes_import_parent_id = RoutesImportParent.last.id
    end

    def test_log_source_id
      @test_log_source_id = LogSource.where(env: 'test').last.id
    end

    def routes_import_ids
      RoutesImport.where(routes_import_parent_id: routes_import_parent_id).select(:id).map{|import_route| import_route.id}
    end

    def rake_routes
      Route.where(routes_import_id: routes_import_ids).map &:formatted_path
    end

    def unique_percentage(compare_array, total_array)
      (compare_array.uniq.size.to_f/total_array.uniq.size) * 100
    end
  end
end

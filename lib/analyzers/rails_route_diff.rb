class RailsRouteDiff

  def initialize
  end

  def analyze(options)
    case options[:diff_type]

    when "untested_routes"
      tested_route_set = tested_routes
      puts tested_route_set
      rake_route_set = rake_routes
      puts rake_route_set
      diff_set = rake_route_set - tested_route_set
      percentage = (diff_set.size/rake_route_set.size)*100
    else
    end

  end

  def rake_routes
    routes_import_ids = RoutesImport.where(import_timestamp: RoutesImport.last.import_timestamp).select(:id).map{|import_route| import_route.id}
    routes = Set.new(Route.where(routes_import_id: routes_import_ids)) { |e| "#{e.method} -- #{e.formatted_path}" }
  end

  def tested_routes
    test_lines_id = LogSource.where(env: 'test').last.id
    routes = Set.new(StartedLine.where(source_id: test_lines_id)) { |e| "#{e.method} -- #{e.formatted_path}"  }


  end
end


class RailsRouteDiff

  def initialize
  end

  def analyze(options)
    case options[:diff_type]

    when "untested_routes"
      untested_routes
    when "unused_routes"
      unused_routes
    when "untested_prod_routes"
      untested_prod_routes
    else

    end
  end

 def untested_routes
    tested_route_set = test_routes
    rake_route_set = rake_routes
    set_diff_results(rake_route_set, prod_route_set)
  end

  def unused_routes
    rake_route_set = rake_routes
    prod_route_set = production_routes
    set_diff_results(rake_route_set, prod_route_set)
    
  end

  def untested_prod_routes
    tested_route_set = test_routes
    prod_route_set = production_routes
    set_diff_results(prod_route_set, tested_route_set)
  end

  def rake_routes
    routes_import_ids = RoutesImport.where(import_timestamp: RoutesImport.last.import_timestamp).select(:id).map{|import_route| import_route.id}
    routes = Set.new(Route.where(routes_import_id: routes_import_ids)) { |e| "#{e.http_verb} -- #{e.formatted_path}" }
  end

  def test_routes
    test_lines_id = LogSource.where(env: 'test').last.id
    routes = Set.new(StartedLine.where(source_id: test_lines_id)) { |e| "#{e.method} -- #{e.formatted_path}"  }
  end

  def production_routes
    prod_lines_id = LogSource.where(env: 'production').last.id
    routes = Set.new(StartedLine.where(source_id: prod_lines_id)) { |e| "#{e.method} -- #{e.formatted_path}"  }
  end

 

  def set_diff_results(start_set, end_set)
    diff_set = start_set - end_set
    percentage = (diff_set.size.to_f/start_set.size)*100 #Convert to float ensures precentage is not rounded.
    result_hash = {'percentage': percentage, 'routes': diff_set.to_a}
  end
end
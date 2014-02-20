#TODO deprecate this in favor of RouteDiff

=begin
class RailsRouteDiff

  def analyze(options)
    options.assert_valid_keys(:diff_type)
    valid_diff_type?(options[:diff_type])
    send(options[:diff_type])
  end

private

  def valid_diff_type?(option)
    valid_diff_types = [
      "untested_routes_with_method",
      "unused_routes_with_method",
      "untested_prod_routes_with_method",
      "tested_routes_with_method",
      "untested_routes",
      "unused_routes",
      "untested_prod_routes",
      "tested_routes"
    ]
    return if option.in?(valid_diff_types)
    raise "Not suppported: #{option}"
  end

######

  def routes_import_ids
    RoutesImport.where(routes_import_parent_id: RoutesImportParent.last.id).select(:id).map{|import_route| import_route.id}
  end

  def test_log_id
    LogSource.where(env: 'test').last.id
  end

  def rake_routes
    @rake_routes = Route.where(routes_import_id: routes_import_ids).map &:formatted_path
  end

  def tested_routes
    @tested_routes = StartedLine.where(source_id: test_log_id).map &:formatted_path
  end

# TODO how do I know that @rake_routes and @tested_routes will be defined when this is calculated?
  def tested_routes_percentage
    compare = @tested_routes
    total = @rake_routes
    unique_percentage(compare, total)
  end

  def unique_percentage(compare_array, total_array)
    (compare_array.uniq.size.to_f/total_array.uniq.size) * 100
  end

######

# TODO
  def untested_routes_with_method
    tested_route_set = test_routes_with_method
    rake_route_set = rake_routes_with_method
    set_diff_results(rake_route_set, tested_route_set)
  end

  def untested_routes
    tested_route_set = test_routes
    rake_route_set = rake_routes
    set_diff_results(rake_route_set, tested_route_set)
  end

  def tested_routes_with_method
    tested = test_routes_with_method
    total = rake_routes_with_method
    percentage = (tested.size.to_f/total.size)*100
    result_hash = {percentage: percentage, routes: tested.to_a}
   end

#  def tested_routes
#    tested = test_routes
#    total = rake_routes
#    percentage = (tested.size.to_f/total.size)*100
#    result_hash = {percentage: percentage, routes: tested.to_a}
#  end

  def unused_routes_with_method
    rake_route_set = rake_routes_with_method
    prod_route_set = production_routes_with_method
    set_diff_results(rake_route_set, prod_route_set)
  end

  def unused_routes
    rake_route_set = rake_routes
    prod_route_set = production_routes
    set_diff_results(rake_route_set, prod_route_set)
  end

  def untested_prod_routes_with_method
    tested_route_set = test_routes_with_method
    prod_route_set = production_routes_with_method
    set_diff_results(prod_route_set, tested_route_set)
  end

  def untested_prod_routes
    tested_route_set = test_routes
    prod_route_set = production_routes
    set_diff_results(prod_route_set, tested_route_set)
  end

  def rake_routes_with_method
    routes_import_ids = RoutesImport.where(routes_import_parent_id: RoutesImportParent.last.id).select(:id).map{|import_route| import_route.id}
    routes = Set.new(Route.where(routes_import_id: routes_import_ids)) { |e| "#{e.method} -- #{e.formatted_path}" }
  end

#  def rake_routes
#    routes_import_ids = RoutesImport.where(routes_import_parent_id: RoutesImportParent.last.id).select(:id).map{|import_route| import_route.id}
#    routes = Set.new(Route.where(routes_import_id: routes_import_ids)) { |e| e.formatted_path }
#  end

  def test_routes_with_method
    test_lines_id = LogSource.where(env: 'test').last.id
    routes = Set.new(StartedLine.where(source_id: test_lines_id)) { |e| "#{e.method} -- #{e.formatted_path}"  }
  end


#  def test_routes
#    test_lines_id = LogSource.where(env: 'test').last.id
#    routes = Set.new(StartedLine.where(source_id: test_lines_id)) { |e| e.formatted_path  }
#  end

  def production_routes_with_method
    prod_lines_id = LogSource.where(env: 'production').last.id
    routes = Set.new(StartedLine.where(source_id: prod_lines_id)) { |e| "#{e.method} -- #{e.formatted_path}"  }
  end

  def production_routes
    prod_lines_id = LogSource.where(env: 'production').last.id
    routes = Set.new(StartedLine.where(source_id: prod_lines_id)) { |e| e.formatted_path  }
  end

# TODO
  def diff_results(start_routes, end_routes)
    diff = start_routes.uniq - end_routes.uniq
    percentage = (diff.uniq.size.to_f/start_routes.uniq.size)*100 #Convert to float ensures precentage is not rounded.
    result_hash = {percentage: percentage, routes: diff}
  end

# TODO
  def set_diff_results(start_set, end_set)
    diff_set = start_set - end_set
    percentage = (diff_set.size.to_f/start_set.size)*100 #Convert to float ensures precentage is not rounded.
    result_hash = {percentage: percentage, routes: diff_set.to_a}
  end
end
=end
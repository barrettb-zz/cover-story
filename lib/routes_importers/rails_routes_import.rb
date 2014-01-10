class RailsRoutesImport

  include RailsRouteImportSupport

  def setup(routes_options)
    @routes_options = routes_options
    @routes_config = APP_CONFIG[:routes_config]
    return true
  end

  def fetch()
    # get file contents, prioritizing specified file, then defaule file location
    @tmp_routes_file = nil
    @tmp_routes_file = File.read(routes_import_file)
    return true
  end

  def parse()
    routes_import = @routes_options[:routes_import]
    records = @tmp_routes_file.lines.collect do |l|
       parse_out_route_info_and_add_to_database(l, routes_import)
    end
    PathProcessor.format_latest_routes_paths
    return true
  end
end

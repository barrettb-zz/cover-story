class RailsRoutesImport

  include RailsRouteImportSupport

  def setup(routes_options)
    @routes_type = "rails"
    @routes_options = routes_options
    @routes_config = APP_CONFIG[:routes_config]
    return true
  end

  def fetch()
    # get file contents, prioritizing specified file, then defaule file location
    file_location = ( @routes_options[:import_path] || @routes_config[:import_file_path] )
    @tmp_routes_file = nil
    @tmp_routes_file = File.read(file_location)
    return true
  end

  def parse()
    #setup options for request_log_analyzer
    import_timestamp_id = Time.now.to_i
    records = @tmp_routes_file.lines.collect do |l|
       parse_out_route_info_and_add_to_database(l, import_timestamp_id, @routes_type)
    end
    return true
  end
end

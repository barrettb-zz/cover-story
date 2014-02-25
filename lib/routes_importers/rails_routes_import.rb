class RailsRoutesImport

  include RailsRouteImportSupport

  def setup(params)
    @routes_options = params
    @routes_config = APP_CONFIG[:routes_config]
    return true
  end

  def fetch
    @tmp_routes_file = nil
    @tmp_routes_file = File.read(routes_import_file)
    return true
  end

  def parse
    routes_import = @routes_options[:routes_import]
    records = @tmp_routes_file.lines.collect do |l|
       parse_out_route_info_and_add_to_database(l, routes_import)
    end
    PathProcessor.format_latest_routes_paths
    return true
  end

  def import
    # grab configs
    routes_config = APP_CONFIG[:routes_config]

    # create core import record
    @routes_import = RoutesImport.create(
      route_type: @routes_options[:type]
    )

    @file_list = @routes_options[:file_list]

    @file_list.each do |import_path|
      @routes_options[:import_path] = import_path

      # create routes file source records
      @routes_import_source = RoutesImportSource.create(
        file_path: @routes_options[:import_path]
      )
      @routes_options[:routes_import_source] = @routes_import_source

      # process files
      @routes_options[:routes_import] = @routes_import
      self.fetch

      @import_status = self.parse
      raise "Routes import failed." unless @import_status
    end
    return @import_status
  end

  def teardown
    @file_list.each do |file|
      File.delete(file)
    end
  end
end

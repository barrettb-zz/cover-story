# TODO I don't like how with fetch the files are treated individually,
#      but the rest of the methods deal with the collection of files.

require_relative '../importers/accepted_files'

class RoutesImport
  include RoutesFileLines
  include AcceptedFiles

  def setup(params)
    @config = APP_CONFIG[:routes_config]
    @file_list = params[:file_list]
    true
  end

  def fetch
    ensure_file_includes_application_in_name File.basename(@file_path)
    @tmp_routes_file = File.read(@file_path)
    true
  end

  def parse
    incoming_lines = @tmp_routes_file.lines
    incoming_paths = []
    @file_name = File.basename(@file_path)

    incoming_lines.each { |l|
      incoming_paths << path_from_line(l)
    }

    paths ||= Route.paths
    deactivated_routes = paths - incoming_paths
    activated_routes = incoming_paths - paths
    incoming_lines.each do |l|
      if route_information_exists_in_line?(l)
        path = path_from_line(l)
        if path.in?(activated_routes)
          create_route_from_line(line: l, file_name: @file_name)
        else
          route = Route.find_by_path(path)
          route.inactivate if path.in?(deactivated_routes)
          route.activate if path.in?(incoming_paths)
        end
      end
    end
    true
  end

  def import
    @file_list.each do |path|
      @file_path = path
      self.fetch

      @import_status = self.parse
      raise "Routes import failed." unless @import_status
    end
    return @import_status
  end

  def teardown
    @file_list.each do |file|
      File.delete file
    end
  end
end

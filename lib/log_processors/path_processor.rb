class PathProcessor

  class << self

    def format_latest_log_paths
      latest_log_id = LogSource.last.id
      StartedLine.where(source_id: latest_log_id).each do |line|
        formatted_path = line.path
        # replace id with ":id"
        formatted_path.gsub!(/\d+/, ":id")
        # delete all query info, from "?" forward
        formatted_path.gsub!(/\?.*/, "")
        formatted_path.strip!
        line.update_attributes(formatted_path: formatted_path)
      end
    end

    def format_latest_routes_paths
      routes_with_latest_import_timestamp.each do |line|
        unless (line.name == "root" || line.name == "SKIPPED" || line.path == nil)
          formatted_path = line.path
          formatted_path.gsub!(/\/:(.*?)_id/, "/:id")
          formatted_path.strip!
          line.update_attributes(formatted_path: formatted_path)
        end
      end
    end

  private

    def routes_with_latest_import_timestamp
      raise "routes not imported" if RoutesImport.count == 0
      routes_imports = RoutesImport.where(import_timestamp: RoutesImport.last.import_timestamp)
      ids = routes_imports.select(:id).map{|import_route| import_route.id}
      routes = Route.where(routes_import_id: ids)
      routes
    end
  end
end

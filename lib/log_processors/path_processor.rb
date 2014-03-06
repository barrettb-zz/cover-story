class PathProcessor

  class << self

    def format_latest_log_paths
      latest_log_id = LogSource.last.id
      LogStartedLine.where(source_id: latest_log_id).each do |line|
        formatted_path = line.path
        # replace id with ":id"
        formatted_path.gsub!(/\d+/, ":id")
        # delete all query info, from "?" forward
        formatted_path.gsub!(/\?.*/, "")
        formatted_path.strip!
        line.update_attributes(formatted_path: formatted_path)
      end
    end

    def extract_models_for_latest_log_paths
      latest_log_id = LogSource.last.id
      LogStartedLine.where(source_id: latest_log_id).each do |line|
        path_model = extract_model_from_path(line.path)
        line.update_attributes(model: path_model)
      end
    end

    def format_latest_routes_paths
      latest_routes_paths.each do |line|
        unless (line.name == "root" || line.name == "SKIPPED" || line.path == nil)
          formatted_path = line.path
          formatted_path.gsub!(/\/:(.*?)_id/, "/:id")
          formatted_path.strip!
          line.update_attributes(formatted_path: formatted_path)
        end
      end
    end

    def extract_model_from_path(path)
      return if path.nil?
      path_segments = path.split("/")

      # delete blank segments:
      path_segments.tap{ |s| s.delete "" }

      # remove path prefix as needed (example: /hr)
      routes_path_prefix = APP_CONFIG[:routes_config][:routes_path_prefix].gsub("/", "")
      path_segments.tap{ |s| s.delete routes_path_prefix}

      # for first segment, delete all query info, from "?" forward
      path_segments[0].gsub!(/\?.*/, "") unless path_segments[0].nil?
      path_segments[0]
    end

  private

    def latest_routes_paths
      routes_import = RoutesImport.last
      routes_import.routes
    end
  end
end

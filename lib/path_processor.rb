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

    def format_route_path(path)
      path.gsub(/\/:(.*?)_id/, "/:id").strip
    end

    def format_route_controller(controller)
      "#{controller.camelize}Controller"
    end
  end
end

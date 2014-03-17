class Formatter
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

    def add_application_to_latest_log
      l = LogSource.last
      l.update_attributes(
        application: self.application_from_filename(l.filename)
      )
    end

    def format_route_path(path)
      path.gsub(/\/:(.*?)_id/, "/:id").strip
    end

    def format_route_controller(controller)
      "#{controller.camelize}Controller"
    end

    def application_from_filename(filename)
      accepted_applications = APP_CONFIG[:applications].split(', ')
      # convert to regex and compare
      line = ''
      accepted_applications.each do |app|
        line << app
        line << '|'
      end
      matcher = Regexp.new line.chomp('|')
      unless filename.match(matcher)
        raise "No match for supported application. expecting in filename: #{accepted_applications}"
      end
      filename.match(matcher).to_s
    end
  end
end

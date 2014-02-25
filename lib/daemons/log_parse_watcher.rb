#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "production"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment")

$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do

  import_listener = Listen.to(File.join(root, APP_CONFIG[:file_drop_dir])) do |modified, added, removed|
    if added.any?
      @results_output = ["Results for #{Time.now}:"]

      routes_files = added.select { |a| a.downcase.match("route") }
      log_files = added.select { |a| !a.downcase.match("route") }

      if routes_files.any?
        routes_files_parms = { }
        # TODO seems like this should be defined elsewhere?
        routes_files_parms[:type] = "rails"
        routes_files_parms[:file_list] = routes_files
        ris = RoutesImportService.new(routes_files_parms)
        ris.import
        ris.teardown
        @results_output.push("Routes files added: #{routes_files}") if routes_files.any?
      end

      if log_files.any?
        log_files_parms = { }
        log_files_parms[:file_list] = log_files
        # TODO seems like this should be defined elsewhere?
        log_files_parms[:type] = "local_rails"
        ls = LogService.new(log_files_parms)
        ls.fetch
        f_p_status = ls.parse
        ls.teardown
        @results_output.push("Log files added: #{log_files}") if log_files.any?
      end

      analysis_types = ["tested_routes"]
      analysis_types.each do |type|
        las = LogAnalysisService.new(
          analysis_type: "route_diff",
          diff_type: type
        )
        las.analyze
      end

      @results_output.push("Analyzed for: #{analysis_types.to_sentence}")
    end

    @results_output.push("Files modified: #{modified}") if modified.any?
    @results_output.push("Files removed: #{removed}") if removed.any?

    @results_output.each {|o| puts o}
  end

  import_listener.start
  puts "Listening for logs and routes at: #{APP_CONFIG[:file_drop_dir]}"
  sleep
end

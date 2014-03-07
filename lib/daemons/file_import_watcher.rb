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

  include ResultsLogger

  file_drop_dir = APP_CONFIG[:file_drop_dir]

  # fail fast if needed configs are missing
  unless file_drop_dir
    raise "Set config file_drop_dir (current environment: #{Rails.env.upcase})"
  end

  import_listener = Listen.to(File.join(root, file_drop_dir)) do |modified, added, removed|
    results_output = []

    if added.any?
      is = ImportService.new(added)
      is.import
      results_output << is.results
    end

    if modified.any?
      results_output << "~modified: #{modified.map {|f| File.basename(f)}}"
      logger.info "~modified: #{modified.map {|f| File.basename(f)}}"
    end

    if removed.any?
      results_output << "-removed: #{removed.map {|f| File.basename(f)}}"
      logger.info "-removed: #{removed.map {|f| File.basename(f)}}"
    end

    puts results_output
  end

  import_listener.start
  puts ".listening for logs and routes at: #{file_drop_dir}"
  sleep
end

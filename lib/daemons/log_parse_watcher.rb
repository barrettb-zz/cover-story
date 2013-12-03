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
  
  # Replace this with your code

listener = Listen.to(File.join(root, APP_CONFIG[:log_drop_dir])) do |modified, added, removed|
  #puts "modified absolute path: #{modified}"
  new_files_parms[:file_list] = added
  new_files_parms[:type] = local_rails
  ls = LogService.new(new_files_parms)
  ls.fetch
  f_p_status = ls.parse
  ls.teardown
  #puts "removed absolute path: #{removed}"
end
listener.start # not blocking
sleep
end

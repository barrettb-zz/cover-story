require "#{Rails.root}/config/application"
require "#{Rails.root}/config/initializers/app_config"
require "#{Rails.root}/app/controllers/application_controller"

namespace :analyze do

  desc "print untested routes"
  task :untested => :environment do
    las = LogAnalysisService.new(type: 'rails_route_diff')
    routes = las.analyze(diff_type: "untested_routes")
    sorted_routes = routes[:routes].sort{|a,b| a && b ? a <=> b : a ? -1 : 1 } # putting nil last
    sorted_routes.each_with_index { |x, i| puts "#{i + 1} #{x}" }
    puts "UNTESTED count: #{routes[:routes].count}"
    puts "UNTESTED percent: #{routes[:percentage]}"
  end

  desc "print tested routes"
  task :tested => :environment do
    las = LogAnalysisService.new(type: 'rails_route_diff')
    routes = las.analyze(diff_type: "tested_routes")
    sorted_routes = routes[:routes].sort{|a,b| a && b ? a <=> b : a ? -1 : 1 } # putting nil last
    sorted_routes.each_with_index { |x, i| puts "#{i + 1} #{x}" }
    puts "tested count: #{routes[:routes].count}"
    puts "TESTED percent: #{routes[:percentage]}"
  end

end

require "#{Rails.root}/config/application"
require "#{Rails.root}/config/initializers/app_config"
require "#{Rails.root}/app/controllers/application_controller"

namespace :analyze do

  desc "tested routes, generates data in analyses"
  task :tested => :environment do
    las = AnalysisService.new(
      analysis_type: "route_diff",
      diff_type: "tested_routes"
    )
    las.analyze

# TODO output route files as well once route related schema is cleaned up
    analysis = Analysis.last
    log = LogSource.where(env: "test").last

    puts "Tested: #{analysis.percentage_covered} %"
    puts "Test Log File: #{log.filename}"
  end

  namespace :clear do
    desc "clear analyses"
    task :analyses => :environment do
      if ENV["REALLY_CLEAR"]
        DataClearer.delete_analyses_data
      else
        puts "Nothing happened. If you intend to clear ALL analyses data, set REALLY_CLEAR=1"
      end
    end

    desc "clear analyzed routes"
    task :analyzed_routes => :environment do
      if ENV["REALLY_CLEAR"]
        DataClearer.delete_analyzed_routes_data
      else
        puts "Nothing happened. If you intend to clear ALL analyzed routes data, set REALLY_CLEAR=1"
      end
    end

    desc "clear all import types (routes and logs)"
    task :all => :environment do
      Rake::Task['analyze:clear:analyses'].invoke
      Rake::Task['analyze:clear:analyzed_routes'].invoke
    end
  end
end

require "#{Rails.root}/config/application"
require "#{Rails.root}/config/initializers/app_config"
require "#{Rails.root}/app/controllers/application_controller"

namespace :analyze do

  desc "tested routes, generates data in analyses"
  task :tested => :environment do
    LogAnalysisService.new(
      analysis_type: "generate_route_diff",
      diff_type: "tested_routes"
    )

# TODO output route files as well once route related schema is cleaned up
    analysis = Analysis.last
    log = LogSource.where(env: "test").last

    puts "Tested: #{analysis.percentage_covered} %"
    puts "Test Log File: #{log.filename}"
  end

  namespace :clear do
    desc "clear analyses"
    task :analyses => :environment do
      Analysis.delete_all
    end

    desc "clear analyzed routes"
    task :analyzed_routes => :environment do
      AnalyzedRoutes.delete_all
    end

    desc "clear analyzed route models"
    task :analyzed_route_models => :environment do
      AnalyzedRouteModel.delete_all
    end

    desc "clear all import types (routes and logs)"
    task :all => :environment do
      Rake::Task['analyze:clear:analyses'].invoke
      Rake::Task['analyze:clear:analyzed_routes'].invoke
      Rake::Task['analyze:clear:analyzed_route_models'].invoke
    end
  end
end

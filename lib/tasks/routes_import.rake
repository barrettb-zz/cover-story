require "#{Rails.root}/config/application"
require "#{Rails.root}/config/initializers/app_config"
require "#{Rails.root}/app/controllers/application_controller"
require "#{Rails.root}/app/controllers/routes_import_controller"
require "#{Rails.root}/lib/routes_importers/rails_route_import_support"
require "#{Rails.root}/lib/routes_importers/rails_routes_import"
require "#{Rails.root}/lib/log_processors/path_processor"
require "#{Rails.root}/app/services/routes_import_service"
require "#{Rails.root}/app/models/route"

include RailsRouteImportSupport
include PathProcessor

namespace :import_routes do
  desc "Import routes from provided import_path or default path"
  task :rails => :environment do
    start_count = Route.count
    if ENV["IMPORT_PATHS"]
      RoutesImport.import(type: "rails", import_paths: ENV["IMPORT_PATHS"])
    else
      RoutesImport.import(type: "rails")
      format_latest_routes_paths
    end
    end_count = Route.count
    added_count = end_count - start_count
    puts "Processed #{added_count} routes; import_timestamp: #{RoutesImport.last.import_timestamp}"
  end
end

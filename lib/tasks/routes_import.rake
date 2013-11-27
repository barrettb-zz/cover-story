require "#{Rails.root}/config/application"
require "#{Rails.root}/config/initializers/app_config"
require "#{Rails.root}/app/controllers/application_controller"
require "#{Rails.root}/app/controllers/routes_import_controller"
require "#{Rails.root}/lib/routes_importers/rails_route_import_support"
require "#{Rails.root}/lib/routes_importers/rails_routes_import"
require "#{Rails.root}/app/services/routes_import_service"
require "#{Rails.root}/app/models/route"

include RailsRouteImportSupport

namespace :import_routes do
  task :rails => :environment do
    start_count = Route.count
    r = RoutesImportController.new
    if ENV["PATH"]
      r.import(type: "rails", import_path: ENV["IMPORT_PATH"])
    else
      r.import(type: "rails")
    end
    end_count = Route.count
    added_count = end_count - start_count
    puts "Imported #{added_count} routes. Timestamp: #{Route.last.import_timestamp_id}"
  end
end

require "#{Rails.root}/config/application"
require "#{Rails.root}/config/initializers/app_config"
require "#{Rails.root}/app/controllers/application_controller"

desc "clear all data (routes, logs, analysis...)"
task :clear_all => :environment do
  Rake::Task['import:clear:all'].invoke
  Rake::Task['analyze:clear:all'].invoke
end

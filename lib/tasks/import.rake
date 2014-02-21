require "#{Rails.root}/config/application"
require "#{Rails.root}/config/initializers/app_config"
require "#{Rails.root}/app/controllers/application_controller"

namespace :import do
  desc "import log files"
  task :logs => :environment do
    start_count = LogSource.count
    if ENV["LOG_FILE_LIST"]
      files = ENV["LOG_FILE_LIST"]
    else
      config = APP_CONFIG[:log_import_config]
      files = config[:import_file_paths]
    end

    file_list = [ ]
    files.split(',').each { |file| file_list << file.strip }
    puts "importing from log file list: #{file_list}"

    ls = LogService.new(type: "local_rails", file_list: file_list)
    ls.fetch
    ls.parse

    end_count = LogSource.count
    added_count = end_count - start_count
    latest_log_source_id = LogSource.last.id
    puts "Imported log files (total added: #{added_count}):"

    added_count.times do |num|
      id = latest_log_source_id - num
      started_lines_added_count = StartedLine.where(source_id: id).count
      log_source_file = LogSource.find(id).filename
      puts " => SourceLog id: #{id}. Imported #{started_lines_added_count} lines (filename: #{log_source_file})"
    end
  end

  desc "import routes files"
  task :routes => :environment do
    start_count = Route.count
    if ENV["ROUTES_FILE_LIST"]
      ris = RoutesImportService.new(type: "rails", file_list: ENV["ROUTES_FILE_LIST"])
    else
      ris = RoutesImportService.new(type: "rails")
    end
    ris.import
    end_count = Route.count
    added_count = end_count - start_count
    puts "Processed #{added_count} routes; Routes Import: #{RoutesImport.last.id}"
  end

  desc "import all file types (routes and logs)"
  task :all => :environment do
    Rake::Task['import:routes'].invoke
    Rake::Task['import:logs'].invoke
  end

  namespace :clear do
    desc "clear log files"
    task :logs => :environment do
      if ENV["REALLY_CLEAR"]
        DataClearer.delete_log_import_data
      else
        puts "Nothing happened. If you intend to clear ALL log imports, set REALLY_CLEAR=1"
      end
    end

    desc "clear routes files"
    task :routes => :environment do
      if ENV["REALLY_CLEAR"]
        DataClearer.delete_routes_import_data
      else
        puts "Nothing happened. If you intend to clear ALL routes imports, set REALLY_CLEAR=1"
      end
    end

    desc "clear all import types (routes and logs)"
    task :all => :environment do
      Rake::Task['import:clear:routes'].invoke
      Rake::Task['import:clear:logs'].invoke
    end
  end

  namespace :ignore do
    desc "ignore log file"
    task :log => :environment do
      raise "need to set MATCHER=id, last or date" if ENV["MATCHER"].nil?
      if ENV["MATCHER"] == "date" || ENV["MATCHER"] == "id"
        raise "need to set VALUE when using 'date' or 'id'.  Date format is 'YYYY, MM, DD'" if ENV["VALUE"].nil?
      end
      DataClearer.ignore_import(:log, ENV["MATCHER"].to_sym, ENV["VALUE"])
    end

    desc "ignore routes import file"
    task :routes => :environment do
      raise "need to set MATCHER=id, last or date" if ENV["MATCHER"].nil?
      if ENV["MATCHER"] == "date" || ENV["MATCHER"] == "id"
        raise "need to set VALUE when using 'date' or 'id'.  Date format is 'YYYY, MM, DD'" if ENV["VALUE"].nil?
      end
      DataClearer.ignore_import(:routes, ENV["MATCHER"].to_sym, ENV["VALUE"])
    end
  end

end

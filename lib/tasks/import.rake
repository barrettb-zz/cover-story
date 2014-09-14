require "#{Rails.root}/config/application"
require "#{Rails.root}/config/initializers/app_config"
require "#{Rails.root}/app/controllers/application_controller"

namespace :import do
  desc "import log files"
  task :logs => :environment do
    start_count = LogSource.count

    # normally we use a listener in the log import directory,
    # but in the case of rake we run on a provided
    # list of files at runtime:
    # MANUAL_LOG_FILE_LIST="file1, file2")
    unless ENV["MANUAL_LOG_FILE_LIST"]
      raise "Need to provide files: MANUAL_LOG_FILE_LIST='file1, file2'"
    end

    file_list = [ ]
    ENV["MANUAL_LOG_FILE_LIST"].split(',').each { |file| file_list << file.strip }
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
      started_lines_added_count = LogStartedLine.where(source_id: id).count
      log_source_file = LogSource.find(id).filename
      puts " => SourceLog id: #{id}. Imported #{started_lines_added_count} lines (filename: #{log_source_file})"
    end
  end

  desc "import routes files"
  task :routes => :environment do
    start_count = Route.count

    # normally we use a listener in the routes import directory,
    # but in the case of rake we run on a provided
    # list of files at runtime:
    # MANUAL_ROUTES_FILE_LIST="file1, file2")
    unless ENV["MANUAL_ROUTES_FILE_LIST"]
      raise "Need to provide files: MANUAL_ROUTES_FILE_LIST='file1, file2'"
    end

    file_list = ENV["MANUAL_ROUTES_FILE_LIST"].gsub(" ", "").split(",")
    ris = RoutesImportService.new(type: "rails", file_list: file_list)
    ris.import
    end_count = Route.count
    added_count = end_count - start_count
    puts "Processed #{added_count} routes"
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
        DataClearer.delete_routes_data
      else
        puts "Nothing happened. If you intend to clear ALL routes imports, set REALLY_CLEAR=1"
      end
    end

    desc "clear import collections"
    task :collections => :environment do
      if ENV["REALLY_CLEAR"]
        DataClearer.delete_import_collection_data
      else
        puts "Nothing happened. If you intend to clear ALL routes imports, set REALLY_CLEAR=1"
      end
    end

    desc "clear all import types (routes and logs)"
    task :all => :environment do
      Rake::Task['import:clear:routes'].invoke
      Rake::Task['import:clear:logs'].invoke
      Rake::Task['import:clear:collections'].invoke
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

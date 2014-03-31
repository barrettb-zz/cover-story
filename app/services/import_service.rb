# ImportService.new(["/Users/cbradbury/pacode/cover-story/test/fixtures/files/bundle.zip"])

require 'zip'
require 'importers/bundle_handler'
require 'importers/accepted_files'

class ImportService < SimpleDelegator

  include AcceptedFiles
  include BundleFiles
  include ResultsLogger

  attr_accessor :results

  def initialize(file_names)
    self.results = []
    @file_names = file_names
  end

  def import
    #  log
    self.results << "*#{Time.now} - importing from: #{file_dirnames(@file_names).uniq}"
    logger.info "*importing from: #{file_dirnames(@file_names).uniq}"

    # unbundle
    self.unbundle

    # import prep
    ensure_are_files_are_accepted_for_import(@file_names)
    create_import_collection_record

    # routes
    self.import_routes_files
    self.import_log_files
    self.analyze
    self.teardown
  rescue StandardError => e
    message = "!error in importing files. See log. #{file_basenames @file_names}"
    output_and_log_error(message, e)
    self.results = "\n!something went wrong; likely nothing processed. See log\n\n"
  end

  def create_import_collection_record
    ic = ImportCollection.create
    @bundle_files && ic.update_attributes( bundle_file_name: File.basename(@bundle_files.last) )
    @import_collection_id = ic.id
  end

  def import_routes_files
    routes_files = routes_files_from_group(@file_names)
    if routes_files.any?
      puts "..importing routes: #{file_basenames routes_files}"
      params = { }
      # TODO seems like this should be defined elsewhere?
      params[:file_list] = routes_files
      ris = RoutesImportService.new(params)
      ris.import
      ris.teardown

      info = "+routes: #{file_basenames routes_files}"
      self.results << info
      logger.info info
    end

    # ensure at least some route files are present
    unless Route.active.any?
      raise "!no active routes. Import some"
    end
  end

  def import_log_files
    log_files = log_files_from_group(@file_names)
    if log_files.any?
      puts "..importing logs (have patience): #{file_basenames log_files}"
      log_files_params = { }
      log_files_params[:file_list] = log_files
      # TODO seems like this should be defined elsewhere?
      #      how do we process other files at this point?
      log_files_params[:type] = "local_rails"
      ls = LogService.new(log_files_params)
      ls.fetch
      f_p_status = ls.parse
      ls.teardown

      info = "+logs: #{file_basenames log_files}"
      self.results << info
      logger.info info
    end
  end

  def analyze
    log_files = log_files_from_group(@file_names)

    if log_files.any?
      analysis_config = APP_CONFIG[:analysis_config]
      analysis_types = analysis_config[:import_defaults].gsub(' ', '').split(',')
      analysis_types.each do |type|
        AnalysisService.new(type: type).analyze
      end
      info = "+analysis: #{analysis_types}"
    else
      info = ".no analysis run (no logs included in import)"
    end

    self.results << info
    logger.info info
  end

  def unbundle
    if bundle_files(@file_names).any?
      puts "..unbundling: #{file_basenames bundle_files(@file_names)}"
      @bundle_files = bundle_files(@file_names)
      bh = BundleHandler.new
      @file_names = bh.run(@file_names) # reset file names to bundle contents

      info = "+unbundle: #{file_basenames @bundle_files}"
      self.results << info
      logger.info info
    end
  end

  def teardown
    @file_names.each { |f| File.delete(f) if File.exists?(f) } unless @file_names.nil?
    @bundle_files.each { |f| File.delete(f) if File.exists?(f) } unless @bundle_files.nil?
  end

private

  def file_basenames(file_names)
    file_names.map { |f| File.basename(f)}
  end

  def file_dirnames(file_names)
    file_names.map { |f| File.dirname(f).gsub(Rails.root.to_s, '')}
  end
end

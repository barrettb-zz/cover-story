require 'collection_support/accepted_files'

class Collection
  include AcceptedFiles

  attr_accessor :results

  def initialize(file_names, delete_files) # file_names is array
    self.results = []
    @file_names = file_names
    @delete_files = delete_files
  end

  def process
    self.results << "*#{Time.now} - importing from: #{file_dirnames(@file_names).uniq}"
    logger.info "*importing from: #{file_dirnames(@file_names).uniq}"
    unbundled_files = Unbundler.run(@file_names)
    if unbundled_files
      @file_names = unbundled_files[:file_names]
      bundle_file = unbundled_files[:bundle_file]
      self.results << unbundled_files[:results_message]
    end

    FileGate.ensure_all_accepted(@file_names)
    ImportCollection.create(bundle_file_name: bundle_file)

    routes_import = RoutesImportService.new(file_list: @file_names).import
    if routes_import
      self.results << routes_import[:message]
    end

    log_import = LogService.new(file_list: @file_names).import
    if log_import
      self.results << log_import[:message]
    end

    self.analyze
    self.teardown
  rescue StandardError => e
    message = "!error in importing files. See log. #{file_basenames @file_names}"
    output_and_log_error(message, e)
    self.results = "\n!something went wrong; likely nothing processed. See log\n\n"
  end

# TODO get this in a reasonable place, wrap it in the service
  def analyze
    log_files = FileGate.filter(:log, @file_names)

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

  def teardown
    if @delete_files
      @file_names.each { |f| File.delete(f) if File.exists?(f) } unless @file_names.nil?
    end
  end
end

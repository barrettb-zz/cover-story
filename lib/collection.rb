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

    self.unbundle

    ensure_are_files_are_accepted_for_import(@file_names)
    self.create_collection_record

    self.results << RoutesImportService.new(file_list: @file_names).import
    self.import_log_files
    self.analyze
    self.teardown

  rescue StandardError => e
    message = "!error in importing files. See log. #{file_basenames @file_names}"
    output_and_log_error(message, e)
    self.results = "\n!something went wrong; likely nothing processed. See log\n\n"
  end

  def create_collection_record
    ic = ImportCollection.create
    @bundle_files.any? && ic.update_attributes(
      bundle_file_name: File.basename(@bundle_files.last)
    )
    @import_collection_id = ic.id
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
    @bundle_files = Unbundler.bundle_files(@file_names)
    if @bundle_files.any?
      puts "..unbundling: #{file_basenames @bundle_files}"
      @file_names = Unbundler.run(@file_names) # set file names to bundle contents

      info = "+unbundle: #{file_basenames @bundle_files}"
      self.results << info
      logger.info info
    end
  end

  def teardown
    if @delete_files
      @file_names.each { |f| File.delete(f) if File.exists?(f) } unless @file_names.nil?
      @bundle_files.each { |f| File.delete(f) if File.exists?(f) } unless @bundle_files.nil?
    end
  end
end

#ImportService.new(file_names: ["a.zip"])
# /Users/cbradbury/pacode/cover-story/test/fixtures/files/bundle.zip
# ImportService.new(["/Users/cbradbury/pacode/cover-story/test/fixtures/files/bundle.zip"])

class ImportService < SimpleDelegator
  require 'zip'
  require 'importers/bundle_handler'
  require 'importers/accepted_files'
  include AcceptedFiles
  include BundleFiles

  attr_accessor :results

  def initialize(file_names)
    self.results = []
    @file_names = file_names
  end

  def import
    self.unbundle
    ensure_are_files_are_accepted_for_import(@file_names)
    self.import_routes_files
    self.import_log_files
    self.import_meta_files
    self.analyze
    self.teardown
  end

# TODO figure out a way to organize all the below,
# in way that is consistent with the delegate model
# perhaps
  def import_routes_files
    routes_files = routes_files_from_group(@file_names)
    if routes_files.any?
      routes_files_parms = { }
      # TODO seems like this should be defined elsewhere?
      routes_files_parms[:type] = "rails"
      routes_files_parms[:file_list] = routes_files
      ris = RoutesImportService.new(routes_files_parms)
      ris.import
      ris.teardown
      self.results << "+routes: #{routes_files}"
    end
  end

  def import_log_files
    log_files = log_files_from_group(@file_names)
    if log_files.any?
      log_files_parms = { }
      log_files_parms[:file_list] = log_files
      # TODO seems like this should be defined elsewhere?
      log_files_parms[:type] = "local_rails"
      ls = LogService.new(log_files_parms)
      ls.fetch
      f_p_status = ls.parse
      ls.teardown
      self.results << "+logs: #{log_files}"
    end
  end

  def import_meta_files
    meta_files = meta_files_from_group(@file_names)
    if meta_files.any?
      # TODO
      self.results << "+meta: #{meta_files}"
    end
  end

  def analyze
    analysis_types = ["tested_routes"]
    analysis_types.each do |type|
      las = LogAnalysisService.new(
        analysis_type: "route_diff",
        diff_type: type
      )
      las.analyze
    end
    self.results << "+analysis: #{analysis_types}"
  end

  def unbundle
    if bundle_files(@file_names).any?
      @bundle_files = bundle_files(@file_names)
      bh = BundleHandler.new
      self.results << "+unbundled: #{@bundle_files}"
      @file_names = bh.run(@file_names) # reset file names to bundle contents
    end
  end

  def teardown
    @file_names.each { |f| File.delete(f) if File.exists?(f) } unless @file_names.nil?
    @bundle_files.each { |f| File.delete(f) if File.exists?(f) } unless @bundle_files.nil?
  end
end

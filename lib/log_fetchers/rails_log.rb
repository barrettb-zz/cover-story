require 'collection_support/accepted_files'

class RailsLog
  include AcceptedFiles

  attr_reader :file_list

  def setup(options)
    file_names = FileGate.filter(:log, options[:file_list])
    expanded_filenames = [ ]
    file_names.each do |f|
      expanded_filenames << File.expand_path(f)
    end
    @file_list = expanded_filenames
  end

  def import
    return false unless @file_list.any?
    puts "..importing logs (have patience): #{file_basenames @file_list}"
    self.fetch
    self.parse
    self.teardown
    message = "+logs: #{file_basenames @file_list}"
    logger.info message
    {message: message}
  end

  def fetch

  end

  def parse
    @file_list.each do |file|
      if File.exists?(file)
        parse_config = RequestLogAnalyzerRunner.gather_parse_config({tmp_log_file: file})

        RequestLogAnalyzerRunner.parse(parse_config)

        LogSource.parse_filename(file)
        Formatter.format_latest_log_paths
        Formatter.add_application_to_latest_log
        ic = ImportCollection.last
        ic.log_sources << LogSource.where(filename: file).last
      end
    end

    return true
  end

  def teardown
    @file_list.each do |file|
      File.delete(file)
    end
  end

end

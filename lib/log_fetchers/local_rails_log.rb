
class LocalRailsLog

  attr_reader :file_list

  def setup(options)
    expanded_filenames = [ ]
    options[:file_list].each do |f|
      expanded_filenames << File.expand_path(f)
    end
    @file_list = expanded_filenames
  end

  def fetch

  end

  def parse
    @file_list.each do |file|
      if File.exists?(file)
        parse_config = RequestLogAnalyzerRunner.gather_parse_config({tmp_log_file: file})

        RequestLogAnalyzerRunner.parse(parse_config)
        
        LogSource.parse_filename(file)
        PathProcessor.format_latest_log_paths
        PathProcessor.extract_models_for_latest_log_paths
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

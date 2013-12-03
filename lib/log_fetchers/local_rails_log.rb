
class LocalRailsLog
  attr_reader :file_list

  def setup(options)
    @file_list = options[:file_list]
  end

  def fetch

  end

  def parse
    @file_list.each do |file|
      if File.exists?(file)
        parse_config = RequestLogAnalyzerRunner.gather_parse_config({tmp_log_file: file})

        RequestLogAnalyzerRunner.parse(parse_config)
        
        LogSource.parse_filename(file)

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

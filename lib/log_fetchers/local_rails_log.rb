
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
# TODO we need to pull this out and do it somehow for all log files, not just local rails
        PathProcessor.format_latest_log_paths

# as with the above we need to pull this out and think it through.
# Right now we are just associating each file with the last ImportCollection,
# but what if someone just runs LogService.. you will overright the previous entry,
# since no new one will be created.
# either think this through or protect against it.
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

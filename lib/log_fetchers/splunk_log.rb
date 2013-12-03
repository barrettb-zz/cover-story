require 'source'

class SplunkLog
  def setup(splunk_options)
    @so = splunk_options
    @s_config = APP_CONFIG[:splunk_config]
    @ns = Splunk::namespace(:sharing => "app", :app => @s_config[:app])
    @config = {:host => @s_config[:host],
               :port => @s_config[:port],
               :username => @s_config[:user],
               :password => @s_config[:pass],
               :namespace => @ns
               }
    @tmp_log_file = File.directory?(APP_CONFIG[:tmp_dir]) ?
      File.join(APP_CONFIG[:tmp_dir], "log_service_#{Time.now.to_i}") :
      File.join(Rails.root, "tmp", "log_service_#{Time.now.to_i}")
  end

  def teardown
    File.delete(@tmp_log_file)
  end

  def fetch()
    if @so[:search_name]
      saved_search_to_file(@so[:search_name], @tmp_log_file, @so )
    else
      search_to_file(@so[:search_string], @tmp_log_file)
    end
  end

  def parse()
    #setup options for request_log_analyzer
    parse_config = RequestLogAnalyzerRunner.gather_parse_config({tmp_log_file: @tmp_log_file})

    RequestLogAnalyzerRunner.parse(parse_config)
  end


  def saved_search_to_file(search_name, file_name, search_params)
    save_file = File.open(file_name, "w")
    sc = Splunk::connect(@config)

    #saved serach dispatch jobs are asynchronous so loop to wait
    # for job to be done is added.
    # Saved search dispatch also takes a hash of values for search parameters
    #   These parameters can be seen here http://dev.splunk.com/view/SP-CAAAEP7#viewingmodifyingproperties
    #   in section "Saved search parameters"
    search_job = sc.saved_searches.fetch(search_name).dispatch(search_params)

    while !search_job.is_done?
      sleep(0.2)
    end

    search_results = Splunk::ResultsReader.new(search_job.results)
    search_results.each do |result|
      save_file.write(result["_raw"] + "\n")
    end
  ensure
    save_file.close
  end

  def search_to_file(query_string, file_name)
    save_file = File.open(file, "w")
    sc = Splunk::connect(@config)

    #create_oneshot blocks until query is done.
    search_job = sc.create_oneshot(query_string)

    search_results = Splunk::ResultsReader.new(search_job.results)
    search_results.each do |result|
      save_file.write(result["_raw"] + "\n")
    end
  ensure
    save_file.close
  end

  private




end
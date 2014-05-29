class LogService < SimpleDelegator
  attr_reader :log_options

  def initialize(params)
    @log_options = params
    @log_options[:log_type] ||= APP_CONFIG[:log_config][:type_for_file_drop]

    case @log_options[:log_type]
    when "splunk"
      super(SplunkLog.new)
    when "rails"
      super(RailsLog.new)
    else
      super(nil)
    end

    self.setup(@log_options)
  end

end

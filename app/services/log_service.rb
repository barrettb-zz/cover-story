class LogService < SimpleDelegator
  attr_reader :log_options

  def initialize(log_params)
    log_type = log_params[:type]

    @log_options = log_params


    case log_type
    when "splunk"
      super(SplunkLog.new)
    when "local_rails"
      super(LocalRailsLog.new)
    else
      super(nil)
    end

    self.setup(@log_options)
  end
end

require 'splunk_log'

class LogService < SimpleDelegator

  def initialize(log_params)
    log_type = log_params[:type]

    @log_options = log_params


    case log_type
    when "splunk"
      super(SplunkLog.new)
    else
      super(nil)
    end

    self.setup(log_params)
  end
end
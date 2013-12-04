class LogAnalysisService < SimpleDelegator
  attr_reader :analysis_options

  def initialize(log_params)
    log_type = log_params[:type]

    @analysis_options = log_params


    case log_type
    when "rails_route_diff"
      super(RailsRouteDiff.new(@analysis_options))
    else
      super(nil)
    end

    self.setup(@analysis_options)
  end
end
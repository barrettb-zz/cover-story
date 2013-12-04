class LogAnalysisService < SimpleDelegator
  attr_reader :analysis_options

  def initialize(analysis_params)
    analysis_type = analysis_params[:type]

    @analysis_options = analysis_params

    case analysis_type
    when "rails_route_diff"
      super(RailsRouteDiff.new)
    else
      super(nil)
    end
  end
end

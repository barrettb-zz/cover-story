class LogAnalysisService < SimpleDelegator
  attr_reader :analysis_options

  def initialize(analysis_params)
    analysis_type = analysis_params[:type]

    @analysis_options = analysis_params


    case analysis_type
    when "rails_route_diff"
      super(RailsRouteDiff.new(@analysis_options))
    else
      super(nil)
    end

    self.setup(@analysis_options)
  end
end
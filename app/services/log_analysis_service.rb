class LogAnalysisService < SimpleDelegator
  attr_reader :analysis_options

  def initialize(params)
    analysis_type = params[:analysis_type]
    diff_type = params[:diff_type]

    case analysis_type
    when "route_diff"
      super(RouteDiff.new)
    else
      raise "unsupported analysis_type: #{analysis_type}"
    end

    self.setup(params)
  end
end

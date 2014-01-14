class LogAnalysisService < SimpleDelegator
  attr_reader :analysis_options

  def initialize(analysis_params)
    analysis_params.assert_valid_keys :analysis_type, :diff_type
    analysis_type = analysis_params[:analysis_type]
    diff_type = analysis_params[:diff_type]

    case analysis_type
    when "generate_route_diff"
      super(RouteDiffGenerator.generate_records(diff_type: diff_type))
    else
      raise "unsupported analysis_type: #{analysis_type}"
    end
  end
end

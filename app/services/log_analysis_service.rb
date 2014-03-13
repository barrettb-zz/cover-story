class LogAnalysisService < SimpleDelegator
  attr_reader :analysis_options

  def initialize(params)
    params.assert_valid_keys :type
    type = params[:type]

    case type
    when "tested_route_paths"
      super(TestedRoutePaths.new)
    else
      raise "unsupported analysis_type: #{type}"
    end

    self.setup(params)
  end
end

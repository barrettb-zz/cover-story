class AnalysisService < SimpleDelegator
  attr_reader :analysis_options

  def initialize(params)
    params.assert_valid_keys :type
    type = params[:type]
    params[:import] = ImportCollection.latest_active

    klass = "#{type.singularize.classify}Analyzer".constantize
    super(klass.new)

    raise "Could not process analysis: #{type}" unless self.setup(params)
  end
end

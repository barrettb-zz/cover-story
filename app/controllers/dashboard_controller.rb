class DashboardController < ApplicationController
  def index
    @tested_results = Analysis.tested_results.to_json

    config = APP_CONFIG[:analysis_config]
    @tested_labels = {
      x_axis: config[:tested_x_axis_label],
      y_axis: config[:tested_y_axis_label]
    }.to_json
  end
end

class DashboardController < ApplicationController
  def index

    tested_results = Analysis.tested_results
    @tested_percentages = tested_results.map{|x| x[:percentage_covered]}
    @tested_dates = tested_results.map{|x| x[:date].strftime("%Y/%m/%d")}

# TODO this is not fully realized yet, demo only at this time
    @tested_model_percentages = Analysis.tested_model_percentages

# TODO determine if these need to go in view helpers, and also in config file
    @tested_x_axis_label = APP_CONFIG[:analysis_config][:tested_x_axis_label]
    @tested_y_axis_label = APP_CONFIG[:analysis_config][:tested_y_axis_label]
  end
end

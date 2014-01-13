class DashboardController < ApplicationController
  def index
    @tested_percentages = Analysis.tested_percentages
  end
end

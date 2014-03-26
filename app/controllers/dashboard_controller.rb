class DashboardController < ApplicationController

  def index
    @applications = APP_CONFIG[:applications].gsub(' ', '').split(',')
    @calculations = Analysis.calculations
  end

end

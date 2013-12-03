class LogImportController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def fetch_parse
    f_p_status = false
    if params[:type]
      ls = LogService.new(params)
      ls.fetch
      f_p_status = ls.parse
      ls.teardown
    end

    respond_to do |format|
      format.html
      format.json { render json: {success: f_p_status} }
    end
  end
end
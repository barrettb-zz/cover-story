class RequestsController < ApplicationController
  def list
    @requests = Request.all

  end
end

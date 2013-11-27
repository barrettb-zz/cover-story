class RoutesImportController < ApplicationController

  # [Example]
  # r = RoutesImportController.new
  # r.import => will default to rails and import the rails routes in tmp.
  def import(params={})
    params[:type] ||= "rails"
    import_status = false
    routes_import_service = RoutesImportService.new(params)
    routes_import_service.fetch
    import_status = routes_import_service.parse
    raise "Routes import failed." unless import_status 
    return import_status
  end
end

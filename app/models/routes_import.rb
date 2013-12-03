class RoutesImport < ActiveRecord::Base

  # Parameters used:
  #
  #   - import_paths: paths processed with RoutesImport.import
  #   - import_path: individual path sent to servies, 
  #       based on import_paths, stored as file_path
  #   - type: type of application, defaults to/only "rails"
  #   - routes_import: main import object, one per import_paths
  #   - import_timestamp: timestamp specific to run, 
  #       shared across routes_imports

  has_many :routes

  def self.import(params={})
    timestamp_id = Time.now.to_i
    params[:type] ||= "rails"
    routes_config = APP_CONFIG[:routes_config]
    params[:import_paths] ||= routes_config[:import_file_paths]
    paths = params[:import_paths].gsub(" ", "").split(",")  

    paths.each do |import_path|
      params[:import_path] = import_path

      @routes_import = RoutesImport.create(
        import_timestamp: timestamp_id,
        route_type: params[:type],
        file_path: params[:import_path]
      )

      params[:routes_import] = @routes_import
      @import_status = false
      routes_import_service = RoutesImportService.new(params)
      routes_import_service.fetch
      @import_status = routes_import_service.parse
      raise "Routes import failed." unless @import_status
    end
    return @import_status
  end
end


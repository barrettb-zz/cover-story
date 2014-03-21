class LogAnalyzer
  def setup(params)
    @type = params[:type]
    @import = params[:import]
    @logs = @import.log_sources
    true
  end

  def analyze
    @logs.each do |l|
      routes = Route.where(application: l.application).active
      route_paths = routes.paths
      log_paths = l.log_started_lines.paths
      log_controllers = l.log_processing_lines.controllers

      a = Analysis.find_or_create_by_import_collection_id_and_application(
        @import.id, 
        l.application
      )

      if l.test?
        a.tested_paths.create_paths(log_paths)
        a.tested_controllers.create_controllers(log_controllers)
      elsif l.production?
        a.production_paths.create_paths(log_paths)
        a.production_controllers.create_controllers(log_controllers)
      else 
        raise "no idea what to do in analysis for environment: #{l.env}"
      end

      a.update_attributes(
        tested_controllers_percentage: a.calc_tested_controllers_percentage,
        tested_paths_percentage: a.calc_tested_paths_percentage,

        used_controllers_percentage: a.calc_used_controllers_percentage,
        used_paths_percentage: a.calc_used_paths_percentage,

        tested_used_controllers_percentage: a.calc_tested_used_controllers_percentage,
        tested_used_paths_percentage: a.calc_tested_used_paths_percentage,

        used_controllers_percentage_all_time: a.calc_used_controllers_percentage(:all_time),
        used_paths_percentage_all_time: a.calc_used_paths_percentage(:all_time),

        tested_used_controllers_percentage_all_time: a.calc_tested_used_controllers_percentage(:all_time),
        tested_used_paths_percentage_all_time: a.calc_tested_used_paths_percentage(:all_time)
      )
    end
  end
end

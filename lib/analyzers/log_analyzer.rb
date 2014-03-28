class LogAnalyzer
  def setup(params)
    @type = params[:type]
    @import = params[:import]
    @logs = @import.log_sources
    true
  end

  def analyze
    @logs.each do |l|
      # don't analyze if there are no routes
      unless Route.where(application: l.application).active.any?
        begin
          raise
        rescue StandardError => e
          output_and_log_error("!No active routes for #{l.application}. Import some first", e)
        end
        return
      end

      # collect log data
      log_paths = l.log_started_lines.paths
      log_controllers = l.log_processing_lines.controllers

      # create analysis record for log
      a = Analysis.find_or_create_by_import_collection_id_and_application(
        @import.id, 
        l.application
      )

      # generate test log analysis content
      if l.test?
        a.tested_paths.create_paths(log_paths)
        a.tested_controllers.create_controllers(log_controllers)

      # generate production log analysis content
      elsif l.production?
        a.production_paths.create_paths(log_paths)
        a.production_controllers.create_controllers(log_controllers)
      else 
        raise "Unsupported environment: #{l.env}"
      end

      if Analysis.has_test_data?(l.application)
        a.update_attributes(
          tested_controllers_percentage: a.calc_tested_controllers_percentage,
          tested_paths_percentage: a.calc_tested_paths_percentage
        )
      end

      if Analysis.has_production_data?(l.application)
        a.update_attributes(
          used_controllers_percentage: a.calc_used_controllers_percentage,
          used_paths_percentage: a.calc_used_paths_percentage
        )
      end

      if Analysis.has_test_data?(l.application) && Analysis.has_production_data?(l.application)
        a.update_attributes(
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
end

class DataClearer

  class << self

    def clear_log_import_data
      LogSource.delete_all
      StartedLine.delete_all
      CompletedLine.delete_all
      FailureLine.delete_all
      ParametersLine.delete_all
      ProcessingLine.delete_all
      RenderedLine.delete_all
      Request.delete_all
      RoutingErrorsLine.delete_all
      Warning.delete_all
      puts "Cleared all log import data (harshly deleted)"
    end

    def clear_routes_import_data
      Route.delete_all
      RoutesImport.delete_all
      RoutesImportSource.delete_all
      puts "Cleared all routes import data (coldly deleted)"
    end

    def clear_analyses_data
      Analysis.delete_all
      puts "Cleared all analyses data (cruely deleted)"
    end

    def clear_analyzed_routes_data
      AnalyzedRoutes.delete_all
      AnalyzedRouteModel.delete_all
      puts "Cleared all analyzed routes data (hope you didn't need this)"
    end
  end
end

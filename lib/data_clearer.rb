class DataClearer

  class << self

    # type:     :log, :import_collection
    # matcher:  :date, :id, :last
    # value:    for :date, :id.  nil for :last
    #           Date format: "YYYY, MM, DD"
    #           TODO: Timezone has not been enforced
    def ignore_import(type, matcher, value=nil)
      toggle_import_ignore(true, type, matcher, value)
    end

    # type:     :log, :import_collection
    # matcher:  :date, :id, :last
    # value:    for :date, :id.  nil for :last
    #           Date format: "YYYY, MM, DD"
    #           TODO: Timezone has not been enforced
    def remember_import(type, matcher, value=nil)
      toggle_import_ignore(false, type, matcher, value)
    end

    def delete_log_import_data
      LogSource.delete_all
      LogStartedLine.delete_all
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

    def delete_routes_data
      Route.delete_all
      RouteHistory.delete_all
      puts "Cleared all routes data (coldly deleted)"
    end

    def delete_analyses_data
      Analysis.delete_all
      puts "Cleared all analyses data (cruely deleted)"
    end

    def delete_import_collection_data
      ImportCollection.delete_all
      Revision.delete_all
      puts "Cleared all import collection/revision data"
    end

    def delete_analyzed_routes_data
      AnalyzedRoutePath.delete_all
      AnalyzedRouteController.delete_all
      puts "Cleared all analyzed route data (hope you didn't need this)"
    end

  private

    # type:     :log, :import_collection
    # matcher:  :date, :id, :last
    # value:    for :date, :id.  nil for :last
    #           Date format: "YYYY, MM, DD"
    def toggle_import_ignore(setting, type, matcher, value=nil)
      raise "setting needs to be a boolean" unless !!setting == setting

      case type
      when :log
        klass = "LogSource"
      when :import_collection
        klass = "ImportCollection"
      else
        raise "please use :log or :import_collection"
      end

      case matcher
      when :id
        records = klass.constantize.where(id: value.to_i)
      when :date
        formatted_date = Date.strptime(value, "%Y, %m, %d")
        if type == :log
          records = klass.constantize.where(
            mtime: formatted_date.beginning_of_day..formatted_date.end_of_day
          )
        elsif type == :import_collection
          records = klass.constantize.where(
            created_at: formatted_date.beginning_of_day..formatted_date.end_of_day
          )
        end
      when :last
        records = [ ]
        records.push klass.constantize.last
      else
        raise "please use :id, :date, or :last"
      end

      records.each { |r| r.update_attributes(ignore: setting) }
    end
  end
end

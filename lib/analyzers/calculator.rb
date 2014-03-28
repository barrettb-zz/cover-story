module Calculator

  def calc_tested_controllers_percentage
    tested = latest_tested_controllers
    routes = Route.where(application: self.application).active.controllers
    unique_percentage(tested, routes).to_f
  end

  def calc_tested_paths_percentage
    tested = latest_tested_paths
    routes = Route.where(application: self.application).active.paths
    unique_percentage(tested, routes)
  end

  def calc_used_controllers_percentage(time_frame=:snapshot)
    case time_frame
    when :snapshot
      used = latest_production_controllers
    when :all_time
      used = ProductionController.all_time.map &:controller
    end
    routes = Route.where(application: self.application).active.controllers
    unique_percentage(used, routes)
  end

  def calc_used_paths_percentage(time_frame=:snapshot)
    case time_frame
    when :snapshot
      used = latest_production_paths
    when :all_time
      used = ProductionPath.all_time.map &:path
    end
    routes = Route.where(application: self.application).active.paths
    unique_percentage(used, routes)
  end

  def calc_tested_used_paths_percentage(time_frame=:snapshot)
    case time_frame
    when :snapshot
      used = latest_production_paths
    when :all_time
      used = ProductionPath.all_time.map &:path
    end
    tested = latest_tested_paths
    used_tested = (used & tested)
    unique_percentage(used_tested, used)
  end

  def calc_tested_used_controllers_percentage(time_frame=:snapshot)
    case time_frame
    when :snapshot
      used = latest_production_controllers
    when :all_time
      used = ProductionController.all_time.map &:controller
    end
    tested = latest_tested_controllers
    used_tested = (used & tested)
    unique_percentage(used_tested, used)
  end

  def untested_paths
    routes = Route.where(application: self.application).active.paths.uniq
    tested = latest_tested_paths
    (routes - tested).uniq
  end

  def untested_controllers
    routes = Route.where(application: self.application).active.controllers.uniq
    tested = latest_tested_controllers
    (routes - tested).uniq
  end

  def untested_used_paths
    tested = latest_tested_paths
    used = latest_production_paths
    used_tested = (used & tested).uniq
    (used - used_tested).uniq
  end

  def untested_used_controllers
    tested = latest_tested_contollers
    used = latest_production_controllers
    used_tested = (used & tested).uniq
    (used - used_tested).uniq
  end

private

  def unique_percentage(compare_array, total_array)
    p = (compare_array.uniq.size.to_f/total_array.uniq.size.to_f)
    ( p.is_a?(Float) && p.nan? ) ? 0 : (p * 100)  # protect against empty values
  end

  def latest_tested_controllers
    a = Analysis.valid.application(self.application).with_tested_controllers.last
    a.tested_controllers.pluck "controller"
  end

  def latest_tested_paths
    a = Analysis.valid.application(self.application).with_tested_paths.last
    a.tested_paths.pluck "path"
  end

  def latest_production_controllers
    a = Analysis.valid.application(self.application).with_production_controllers.last
    a.production_controllers.pluck "controller"
  end

  def latest_production_paths
    a = Analysis.valid.application(self.application).with_production_paths.last
    a.production_paths.pluck "path"
  end
end

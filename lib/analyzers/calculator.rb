module Calculator
  def calc_tested_controllers_percentage
    tested = self.tested_controllers.pluck "controller"
    routes = Route.where(application: self.application).active.controllers
    unique_percentage(tested, routes).to_f
  end

  def calc_tested_paths_percentage
    tested = self.tested_paths.pluck "path"
    routes = Route.where(application: self.application).active.paths
    unique_percentage(tested, routes)
  end

  def calc_used_controllers_percentage(time_frame=:snapshot)
    case time_frame
    when :snapshot
      used = self.production_controllers.pluck "controller"
    when :all_time
      used = ProductionController.all_time.map &:controller
    end
    routes = Route.where(application: self.application).active.controllers
    unique_percentage(used, routes)
  end

  def calc_used_paths_percentage(time_frame=:snapshot)
    case time_frame
    when :snapshot
      used = self.production_paths.pluck "path"
    when :all_time
      used = ProductionPath.all_time.map &:path
    end
    routes = Route.where(application: self.application).active.paths
    unique_percentage(used, routes)
  end

  def calc_tested_used_paths_percentage(time_frame=:snapshot)
    case time_frame
    when :snapshot
      used = self.production_paths.pluck "path"
    when :all_time
      used = ProductionPath.all_time.map &:path
    end
    tested = self.tested_paths.pluck "path"
    used_tested = (used & tested)
    unique_percentage(used_tested, used)
  end

  def calc_tested_used_controllers_percentage(time_frame=:snapshot)
    case time_frame
    when :snapshot
      used = self.production_controllers.pluck "controller"
    when :all_time
      used = ProductionController.all_time.map &:controller
    end
    tested = self.tested_controllers.pluck "controller"
    used_tested = (used & tested)
    unique_percentage(used_tested, used)
  end

  def untested_paths
    routes = Route.where(application: self.application).active.paths.uniq
    tested = self.tested_paths.pluck("path").uniq
    (routes - tested).uniq
  end

  def untested_controllers
    routes = Route.where(application: self.application).active.controllers.uniq
    tested = self.tested_controllers.pluck("controller").uniq
    (routes - tested).uniq
  end

  def untested_used_paths
    tested = self.tested_paths.pluck("path").uniq
    used = self.production_paths.pluck("path").uniq
    used_tested = (used & tested).uniq
    (used - used_tested).uniq
  end

  def untested_used_controllers
    tested = self.tested_controllers.pluck("controller").uniq
    used = self.production_controllers.pluck("controller").uniq
    used_tested = (used & tested).uniq
    (used - used_tested).uniq
  end

private

  def unique_percentage(compare_array, total_array)
    p = (compare_array.uniq.size.to_f/total_array.uniq.size.to_f)
    ( p.is_a?(Float) && p.nan? ) ? 0 : (p * 100)  # protect against empty values
  end
end
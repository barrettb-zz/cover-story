class Analysis < ActiveRecord::Base
  include Calculator

  belongs_to :import_collection
  has_many :production_paths
  has_many :production_controllers
  has_many :tested_paths
  has_many :tested_controllers

# TODO broke. broke. broke
  def self.tested_results
    self.pluck(:analysis_type, :percentage_covered, :created_at).map { |a, p, c|
      {
        analysis_type: a,
        percentage_covered: p.to_f,
        date: c
      }
    }
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

  def self.valid
    imports = ImportCollection.valid
    self.find_all_by_import_collection_id(imports.pluck("id"))
  end
end

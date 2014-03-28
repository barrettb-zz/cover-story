class Analysis < ActiveRecord::Base
  include Calculator

  belongs_to  :import_collection
  has_many    :production_paths
  has_many    :production_controllers
  has_many    :tested_paths
  has_many    :tested_controllers

  scope :with_tested_controllers, ->      { where(id: TestedController.pluck("analysis_id").uniq) }
  scope :with_tested_paths, ->            { where(id: TestedPath.pluck("analysis_id").uniq) }
  scope :with_production_controllers, ->  { where(id: ProductionController.pluck("analysis_id").uniq) }
  scope :with_production_paths, ->        { where(id: ProductionPath.pluck("analysis_id").uniq) }
  scope :application, -> (app)            { where application: app }
  scope :valid, ->                        { where import_collection_id: ImportCollection.valid.pluck("id") }
  default_scope                           { valid }

# TODO this is iffy
  def self.calculations
    a = Analysis.column_names.find_all { |e| /tested/ =~ e }
    b = Analysis.column_names.find_all { |e| /used/ =~ e }
    c = a + b
    c.uniq.sort
  end

  def self.has_test_data?(application)
    ( valid.application(application).map &:tested_paths ).flatten.any?
  end

  def self.has_production_data?(application)
    ( valid.application(application).map &:production_paths ).flatten.any?
  end
end

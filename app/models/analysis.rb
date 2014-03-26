class Analysis < ActiveRecord::Base
  include Calculator

  belongs_to :import_collection
  has_many :production_paths
  has_many :production_controllers
  has_many :tested_paths
  has_many :tested_controllers

  def self.valid
    imports = ImportCollection.valid
    self.find_all_by_import_collection_id(imports.pluck("id"))
  end

# TODO this is iffy
  def self.calculations
    a = Analysis.column_names.find_all { |e| /tested/ =~ e }
    b = Analysis.column_names.find_all { |e| /used/ =~ e }
    c = a + b
    c.uniq.sort
  end
end

# Umbrella for each application's route file used in the same run
# RoutesImport will have one record per application 
# (hrsuite, app portal, etc)

class RoutesImportParent < ActiveRecord::Base
  belongs_to :analysis
  has_many :routes_imports
end

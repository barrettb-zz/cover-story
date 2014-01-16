class Route < ActiveRecord::Base

  belongs_to :routes_import
  belongs_to :analysis
  has_one :routes_import_source

end

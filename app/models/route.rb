class Route < ActiveRecord::Base

  belongs_to :routes_import
  belongs_to :analysis

end

class RoutesImport < ActiveRecord::Base

  has_many :routes
  has_one :revision

end


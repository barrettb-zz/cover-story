class AnalyzedRoutes < ActiveRecord::Base
  belongs_to :analysis
  has_many :routes
end

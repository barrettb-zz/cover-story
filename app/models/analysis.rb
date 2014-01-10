class Analysis < ActiveRecord::Base
  has_many :log_sources
  has_one  :routes_imports_parent
  has_many :analyzed_routes
end

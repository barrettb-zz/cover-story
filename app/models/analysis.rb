class Analysis < ActiveRecord::Base
  has_many :log_sources
  has_one  :routes_imports_parent
  has_many :analyzed_routes

# TODO - does this need to convert to float?
  # for now defining tested_percentages as anything we have collected over time
  def self.tested_percentages
    self.pluck(:percentage_covered).map(&:to_f)
  end
end

class Analysis < ActiveRecord::Base
  has_many :log_sources
  has_one  :routes_import
  has_many :analyzed_routes
  has_many :analyzed_route_models

# TODO - does this need to convert to float? is this one even used?
  # for now defining tested_percentages as anything we have collected over time
  def self.tested_percentages
    self.pluck(:percentage_covered).map(&:to_f)
  end

# TODO - does this need to convert to float?
  def self.tested_results
    self.pluck(:percentage_covered, :created_at).map {|p, c| {percentage_covered: p.to_f, date: c.to_date}}
  end

# TODO this is not fully realized yet, demo only at this time
  def self.tested_model_percentages
    self.pluck(:model_percentage_covered).map(&:to_f)
  end
end

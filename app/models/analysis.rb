class Analysis < ActiveRecord::Base
  has_many :log_sources
  has_one  :routes_import
  has_many :analyzed_routes
  has_many :analyzed_route_models

  def self.tested_results
    self.pluck(:percentage_covered, :created_at, :model_percentage_covered).map {|p, c, m|
      {
        percentage_covered: p.to_f,
        date: c,
        model_percentage_covered: m.to_f
      }
    }
  end
end

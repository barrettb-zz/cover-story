class AnalyzedRoutePath < ActiveRecord::Base
  belongs_to :analysis
  belongs_to :route
end

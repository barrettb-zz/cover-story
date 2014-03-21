class ProductionController < ActiveRecord::Base
  belongs_to :analysis
  validates_presence_of :analysis_id

  def self.create_controllers(controllers)
    controllers.uniq.each do |l|
      self.create(
        controller: l,
        count: controllers.count(l)
      )
    end
  end

  def self.all_time
    analyses_ids = Analysis.valid.map &:id
    self.find_all_by_analysis_id(analyses_ids)
  end
end

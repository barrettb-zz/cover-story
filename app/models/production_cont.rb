class ProductionCont < ActiveRecord::Base
  belongs_to :analysis
  validates_presence_of :analysis_id

  scope :all_time, -> { where(analysis_id: Analysis.active.pluck("id")) }

  def self.create_controllers(controllers)
    controllers.uniq.each do |l|
      self.create(
        controller: l,
        count: controllers.count(l)
      )
    end
  end
end

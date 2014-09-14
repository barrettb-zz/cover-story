class TestedCont < ActiveRecord::Base
  belongs_to :analysis
  validates_presence_of :analysis_id

  def self.create_controllers(log_controllers)
    log_controllers.uniq.each do |l|
      self.create(
        controller: l,
        count: log_controllers.count(l)
      )
    end
  end
end

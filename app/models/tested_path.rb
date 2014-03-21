class TestedPath < ActiveRecord::Base
  belongs_to :analysis
  validates_presence_of :analysis_id

  def self.create_paths(log_paths)
    log_paths.uniq.each do |l|
      self.create(
        path: l,
        count: log_paths.count(l)
      )
    end
  end
end

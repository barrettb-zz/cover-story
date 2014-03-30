class ImportCollection < ActiveRecord::Base
  has_one :revision
  has_many :routes
  has_many :log_sources
  has_many :analyses

  scope :active, -> { where ignore: [false, nil] }
  default_scope  { active }

  def self.latest_active
    # TODO logger
    raise "No active imports." unless self.active.last
    self.active.last
  end
end

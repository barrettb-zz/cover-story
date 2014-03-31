class ImportCollection < ActiveRecord::Base
  has_many :routes
  has_many :log_sources
  has_many :analyses

  scope :active, -> { where ignore: [false, nil] }
  default_scope  { active }

end

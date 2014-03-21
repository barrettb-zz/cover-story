class ImportCollection < ActiveRecord::Base
  has_one :revision
  has_many :routes
  has_many :log_sources
  has_many :analyses

  def self.valid
    self.where(ignore: [false, nil])
  end

  def self.latest_valid
    # TODO logger
    raise "No valid imports." unless self.valid.last
    self.valid.last
  end
end

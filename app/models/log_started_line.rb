# TODO I would really like to get associations working between here and LogSource/Source,
#      not sure what is up, but for now controllers and paths need an ID, but should allow
#      for an association?

class LogStartedLine < ActiveRecord::Base

  self.table_name = "started_lines"
  belongs_to :request
  belongs_to :log_source

  def self.paths
    self.pluck("path")
  end

  def self.controllers
    self.pluck("controller")
  end
end

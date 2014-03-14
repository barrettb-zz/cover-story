class LogStartedLine < ActiveRecord::Base

  self.table_name = "started_lines"
  belongs_to :request
  belongs_to :log_source

  def self.paths
    self.pluck("formatted_path")
  end
end

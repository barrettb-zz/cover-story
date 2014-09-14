class LogProcessingLine < ActiveRecord::Base
  self.table_name = "processing_lines"
  belongs_to :log_source

  def self.controllers
    self.pluck("controller")
  end
end

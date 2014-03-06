class LogStartedLine < ActiveRecord::Base
  self.table_name = "started_lines"

    belongs_to :request



end


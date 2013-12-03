class LogSource < ActiveRecord::Base
  self.table_name = "sources"
    has_many :requests, dependent: :destroy

  def self.parse_filename(filename)
    md = /(?<ci_job_num>[\d]*)-*(?<ci_job>[\w\ ]*)-*(?<env>development|production|test).log/.match filename
    log_source = find_by(filename: filename)
    log_source.update_attributes(file_type: "rails", env: md[:env])

  end


end

class LogSource < ActiveRecord::Base
  self.table_name = "sources"
    has_many :requests, dependent: :destroy
    belongs_to :analysis

  def self.parse_filename(filename)
    md = /(?<ci_job_num>[\d]*)-*(?<ci_job>[\w\ ]*)-*(?<env>development|production|test).log/.match filename
    log_source = where(filename: filename).last
    log_source.update_attributes(file_type: "rails", env: md[:env])

  end


end

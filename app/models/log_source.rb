class LogSource < ActiveRecord::Base

  include ResultsLogger

  self.table_name = "sources"
    has_many :requests, dependent: :destroy
    belongs_to :analysis

  def self.parse_filename(filename)
    # moved to config: /(?<ci_job_num>[\d]*)-*(?<ci_job>[\w\ ]*)-*(?<env>development|production|test).log/
    format = APP_CONFIG[:log_config][:log_file_format]
    format_regexp = Regexp.new format
    md = format_regexp.match filename
    if md.nil?
      logger.info "Error processing log file.\n  Check name/extension (.log expected):\n  #{filename}"
    end
    log_source = where(filename: filename).last
    log_source.update_attributes(file_type: "rails", env: md[:env])
  end

end

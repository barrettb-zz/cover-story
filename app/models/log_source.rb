class LogSource < ActiveRecord::Base

  include ResultsLogger

  self.table_name = "sources"
  belongs_to :import_collection
  has_many :requests, dependent: :destroy
  has_many :log_started_lines, :foreign_key => 'source_id'

  def self.parse_filename(filename)
    format = APP_CONFIG[:log_config][:log_file_format]
    format_regexp = Regexp.new format
    md = format_regexp.match filename
    if md.nil?
      logger.info "Error processing log file.\n  Check name/extension (.log expected):\n  #{filename}"
    end
    log_source = where(filename: filename).last
    log_source.update_attributes(file_type: "rails", env: md[:env])
  end

  def self.valid
    self.where(ignore: [false, nil])
  end

  def self.test
    self.where(env: 'test')
  end

  def self.production
    self.where(env: 'production')
  end

  def self.latest_valid_test
    import_id = ImportCollection.latest_valid.id
    test_logs = self.valid.test
    valids = test_logs.where(import_collection_id: import_id)
    # TODO logger
    raise "No valid test logs" unless valids.last
    valids.last
  end
end

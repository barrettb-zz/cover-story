require 'logger'

module ResultsLogger
  def self.included(base)
    base.extend self
  end

  def logger
    @logger ||= begin
      name = 'results'
      l = Logger.new(File.join(Rails.root, 'log', "#{name}.#{Rails.env}.log"))
      l.level = ::Logger::DEBUG
      l.datetime_format = "%H:%M:%S"
      l.formatter = ::Logger::Formatter.new
      l.progname = name
      l
    end
  end

end

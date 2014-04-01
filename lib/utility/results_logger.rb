require 'logger'

module ResultsLogger
  def self.included(base)
    base.extend self
  end

  def logger
    @logger ||= begin
      name = 'results'
      Logger.new(File.join(Rails.root, 'log', "#{name}.#{Rails.env}.log"))
    end
  end

  def output_and_log_error(message, e)
    m = "#{message}\n  #{e.message}"
    puts m
    backtrace = e.backtrace.join("\n  ")
    logger.error "#{m}\n  #{backtrace}"
  end

  def output_and_log_info(message)
    m = "#{message.gsub('\n', ' ').squeeze(' ')}"
    puts m
    logger.info m
  end
end

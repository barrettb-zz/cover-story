
require 'request_log_analyzer'

#RequestLogAnalyzerRunner is class to handle the parsing a log file supported by the
# Request_log_analyzer. Instead of running the tool from command-line it will run the
# classes directly.
class RequestLogAnalyzerRunner

  #parse class method will build a Request_log_analyzer controller and then perform the run!
  # method. The following are the options available to use in the passed options parameter hash.
  #
  #Options
  # * <tt>:after</tt> Drop all requests after this date (Date, DateTime, Time, or a String in "YYYY-MM-DD hh:mm:ss" format)
  # * <tt>:aggregator</tt> Array of aggregators (Strings or Symbols for the builtin aggregators or a RequestLogAnalyzer::Aggregator class - Defaults to [:summarizer]).
  # * <tt>:boring</tt> Do not show color on STDOUT (Defaults to false).
  # * <tt>:before</tt> Drop all requests before this date (Date, DateTime, Time or a String in "YYYY-MM-DD hh:mm:ss" format)
  # * <tt>:database</tt> Database file to insert encountered requests to.
  # * <tt>:debug</tt> Enables echo aggregator which will echo each request analyzed.
  # * <tt>:file</tt> Filestring, File or StringIO.
  # * <tt>:format</tt> :rails, {:apache => 'FORMATSTRING'}, :merb, :amazon_s3, :mysql or RequestLogAnalyzer::FileFormat class. (Defaults to :rails).
  # * <tt>:mail</tt> Email the results to this email address.
  # * <tt>:mailhost</tt> Email the results to this mail server.
  # * <tt>:mailsubject</tt> Email subject.
  # * <tt>:no_progress</tt> Do not display the progress bar (increases parsing speed).
  # * <tt>:output</tt> 'FixedWidth', 'HTML' or RequestLogAnalyzer::Output class. Defaults to 'FixedWidth'.
  # * <tt>:reject</tt> Reject specific {:field => :value} combination (expects a single hash).
  # * <tt>:report_width</tt> Width of reports in characters for FixedWidth reports. (Defaults to 80)
  # * <tt>:reset_database</tt> Reset the database before starting.
  # * <tt>:select</tt> Select specific {:field => :value} combination (expects a single hash).
  # * <tt>:source_files</tt> Source files to analyze. Provide either File, array of files or STDIN.
  # * <tt>:yaml</tt> Output to YAML file.
  # * <tt>:silent</tt> Minimal output automatically implies :no_progress
  # * <tt>:source</tt> The class to instantiate to grab the requestes, must be a RequestLogAnalyzer::Source::Base descendant. (Defaults to RequestLogAnalyzer::Source::LogParser)
  #
  def self.parse(options)
    begin
      a = RequestLogAnalyzer::Controller.build(options)
      a.run!
      return true
    rescue
      return false
    end
  end
end
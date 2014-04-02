module AcceptedFiles

  def routes_file_matcher
    APP_CONFIG[:log_config][:routes_file_matcher]
  end

  def log_file_matcher
    APP_CONFIG[:log_config][:log_file_matcher]
  end

  def meta_file_matcher
    APP_CONFIG[:log_config][:meta_file_matcher]
  end

  def accepted_file_types
    [log_file_matcher, routes_file_matcher, meta_file_matcher]
  end

  def accepted_log_environments
    APP_CONFIG[:log_config][:environments].split(", ")
  end

  def accepted_applications
    APP_CONFIG[:applications].split(', ')
  end

  def accepted_file?(file_name)
    accepted_file_types.each do |type|
      return true if file_name.match type
    end
    return false
  end

  def ensure_are_files_are_accepted_for_import(file_names)
    file_names.each do |f|
      unless accepted_file?(f)
        raise "file '#{f}' not accepted. No files in drop processed: #{file_names}"
      end
      ensure_log_file_format(f)
      # TODO: ths is redundant with the above format check.
      #   need to discuss best practice here
      ensure_log_file_includes_environment_in_name(f)
      ensure_file_includes_application_in_name(f)
    end
  end

  def ensure_log_file_format(file_name)
    return unless file_type(file_name) == :log
    format = APP_CONFIG[:log_config][:log_file_format]
    format_regexp = Regexp.new format
    unless format_regexp.match file_name
      raise "LOG file name not in correct format. No files in drop processed: #{file_name}"
    end
  end

  def ensure_log_file_includes_environment_in_name(file_name)
    return unless file_type(file_name) == :log

    # convert to regex and compare
    line = ''
    accepted_log_environments.each do |e|
      line << e
      line << '|'
    end
    matcher = Regexp.new line.chomp('|')

    unless file_name.match(matcher)
      raise "LOG file names need to specify environment. No files in drop processed. Environments: #{accepted_log_environments}"
    end
  end

  def ensure_file_includes_application_in_name(file_name)
    return unless file_type(file_name) == :log

    # convert to regex and compare
    line = ''
    accepted_applications.each do |a|
      line << a
      line << '|'
    end
    matcher = Regexp.new line.chomp('|')

    unless file_name.match(matcher)
      raise "Route/Log filename needs to specify application. Applications: #{accepted_applications}"
    end
  end

  def file_type(file_name)
    accepted_file_types.each do |type|
      return type.gsub(/[[:punct:]]/, '').to_sym if file_name.match type
    end
    return false
  end

  def routes_files_from_group(file_names)
    file_names.select { |a| a.match(routes_file_matcher) }
  end

  def log_files_from_group(file_names)
    file_names.select { |a| a.match(log_file_matcher) }
  end

  def meta_files_from_group(file_names)
    file_names.select { |a| a.match(meta_file_matcher) }
  end

  def file_basenames(file_names)
    file_names.map { |f| File.basename(f)}
  end

  def file_dirnames(file_names)
    file_names.map { |f| File.dirname(f).gsub(Rails.root.to_s, '')}
  end
end

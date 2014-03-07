module AcceptedFiles

# TODO consider moving these to config
  def routes_file_matcher
    "routes"
  end

  def log_file_matcher
    "log"
  end

  def meta_file_matcher
    "meta"
  end

  def accepted_file_types
    [log_file_matcher, routes_file_matcher, meta_file_matcher]
  end

# TODO consider moving these to config, reference it in monte's log_source model
  def accepted_log_environments
    ['production', 'test', 'development']
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

  def delete_all_files_from_unbundled_directory
    Dir.entries(bundle_unzip_dir).each do |f| 
      fn = File.join(bundle_unzip_dir, f)
      File.delete(fn) if !File.directory?(fn)
    end
  end

end

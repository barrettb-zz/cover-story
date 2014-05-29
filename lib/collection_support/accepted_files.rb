module AcceptedFiles

  class FileGate
    class << self

      def filter(type, file_names=[])
        return unless file_names.any?
        case type
        when :routes
          file_names.select { |a| a.match(routes_file_matcher) }
        when :log
          file_names.select { |a| a.match(log_file_matcher) }
        when :meta
          file_names.select { |a| a.match(meta_file_matcher) }
        else
          raise # TODO
        end
      end

      def ensure_all_accepted(file_names)
        file_names.each do |f|
          unless accepted_file?(f)
            raise "file '#{f}' not accepted. No files in drop processed: #{file_names}"
          end
          ensure_format(f)
          # TODO: ths is redundant with the above format check.
          #   need to discuss best practice here
          ensure_environment_in_name(f)
          ensure_application_in_name(f)
        end
      end

      def ensure_environment_in_name(file_name)
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

      def ensure_application_in_name(file_name)
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

    private

      def accepted_file?(file_name)
        accepted_file_types.each do |type|
          return true if file_name.match type
        end
        return false
      end

      def accepted_file_types
        [log_file_matcher, routes_file_matcher, meta_file_matcher]
      end

      def routes_file_matcher
        APP_CONFIG[:log_config][:routes_file_matcher]
      end

      def log_file_matcher
        APP_CONFIG[:log_config][:log_file_matcher]
      end

      def meta_file_matcher
        APP_CONFIG[:log_config][:meta_file_matcher]
      end


      def accepted_log_environments
        APP_CONFIG[:log_config][:environments].split(", ")
      end

      def accepted_applications
        APP_CONFIG[:applications].split(', ')
      end

      def ensure_format(file_name)
        return unless file_type(file_name) == :log
        format = APP_CONFIG[:log_config][:log_file_format]
        format_regexp = Regexp.new format
        unless format_regexp.match file_name
          raise "LOG file name not in correct format. No files in drop processed: #{file_name}"
        end
      end

      def file_type(file_name)
        accepted_file_types.each do |type|
          return type.gsub(/[[:punct:]]/, '').to_sym if file_name.match type
        end
        return false
      end
    end
  end

  def file_basenames(file_names)
    file_names.map { |f| File.basename(f)}
  end

  def file_dirnames(file_names)
    file_names.map { |f| File.dirname(f).gsub(Rails.root.to_s, '')}
  end
end

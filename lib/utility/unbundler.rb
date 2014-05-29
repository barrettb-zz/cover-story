require 'zip'

class Unbundler

  class << self

    def run(file_names)
      bundle_files = self.bundle_files(file_names)
      return false if bundle_files.empty?
      enforce_exclusively_one_bundle_file(file_names)
      bundle_file = bundle_files(file_names).last
      puts "..unbundling: #{File.basename bundle_file}"
      enforce_required_file_types(bundle_file)
      file_names = unpack(bundle_file)
      message = "+unbundled: #{File.basename bundle_file}"
      logger.info message
      bundle_files.each do |f|
        File.delete(f) if File.exists?(f) unless bundle_files.nil?
      end
      output = {
        file_names: file_names,
        message: message,
        bundle_file: File.basename(bundle_file) # don't care about full path
      }
      output
    end

    def bundle_files(file_names)
      file_names.select { |f| File.extname(f) == ".zip" }
    end

  private

    def unpack(bundle_file)
      delete_all_files_from_unbundled_directory
      unbundled_files = [ ]
      Zip::File.open(bundle_file) do |zip_file|
        zip_file.each do |entry|
          unless entry.name_is_directory?
            name = File.basename(entry.name)
            unless system_file? name
              debundle_path = "#{bundle_unzip_dir}/#{name}"
              entry.extract(debundle_path)
              unbundled_files.push debundle_path
            end
          end
        end
      end

      unbundled_files
    end

    def system_file?(name)
      # to match something like:
      # "._log_feature_regressions_test.log"
      # ".DS_Store"
      name.starts_with?('.') || name.match(/[[:punct:]][[:punct:]]/)
    end

    def required_file_types_for_bundle
      APP_CONFIG[:bundle][:required_file_types].gsub(' ', '').split(',')
    end

    def enforce_required_file_types(bundle_file)
      contents = contents_of_bundle(bundle_file)
      basenames = contents.map { |f| File.basename(f) }
      prefixes = basenames.map { |n| n.split("_")[0] }
      missing = required_file_types_for_bundle - prefixes.uniq
      if missing.count > 0
        raise raise "Bundle must contain file types: #{required_file_types_for_bundle}. No files in drop processed."
      end
    end

    def enforce_exclusively_one_bundle_file(file_names)
      if bundle_files(file_names).any? && file_names.count > 1
        raise "can only accept ONE bundle or individual files - Don't do do both. No files in drop processed: #{file_names}"
      end
    end

    def bundle_unzip_dir
      File.join(Rails.root, APP_CONFIG[:bundle][:dir])
    end

    def contents_of_bundle(bundle_file)
      contents = [ ]
      Zip::File.open(bundle_file) do |zip_file|
        zip_file.each do |entry|
          next if entry.name =~ /__MACOSX/ || entry.name =~ /\.DS_Store/ || !entry.file?
          contents.push entry.name unless entry.name_is_directory?
        end
      end
      contents
    end

    def delete_all_files_from_unbundled_directory
      Dir.entries(bundle_unzip_dir).each do |f|
        fn = File.join(bundle_unzip_dir, f)
        File.delete(fn) if !File.directory?(fn)
      end
    end
  end
end

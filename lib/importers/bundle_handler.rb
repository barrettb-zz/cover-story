class BundleHandler

  require 'importers/bundle_files'
  include BundleFiles

  def run(file_names)
    enforce_exclusively_one_bundle_file(file_names)
    bundle_file = bundle_files(file_names).last
    enforce_required_file_types_in_bundle(bundle_file)
    @file_names = unpack(bundle_file)
  end

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

private

  def system_file?(name)
    # to match something like:
    # "._log_feature_regressions_test.log"
    name.match(/[[:punct:]][[:punct:]]/)
  end
end

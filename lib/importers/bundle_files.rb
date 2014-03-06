module BundleFiles

  def required_file_types_for_bundle
    ["log", "routes", "meta"]
  end

  def enforce_required_file_types_in_bundle(bundle_file)
    contents = contents_of_bundle(bundle_file)
    basenames = contents.map { |f| File.basename(f) }
    prefixes = basenames.map { |n| n.split("_")[0] }
    missing = required_file_types_for_bundle - prefixes.uniq
    if missing.count > 0
      raise raise "Bundle must contain file types: #{required_file_types_for_bundle}. No files in drop processed."
    end
  end

  def bundle_files(file_names)
    file_names.select { |f| File.extname(f) == ".zip" }
  end

  def enforce_exclusively_one_bundle_file(file_names)
    if bundle_files(file_names).any? && file_names.count > 1
      raise "can only accept ONE bundle or individual files - Don't do do both. No files in drop processed: #{file_names}"
    end
  end

  def bundle_unzip_dir
    File.join(Rails.root, "tmp", "unbundled_files")
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

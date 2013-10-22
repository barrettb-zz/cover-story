module RouteImporterDefinitionsHelper

  def default_shared_file_location # assuming file in main cover-story directory for now
    "slop_routes.txt"
  end

# TODO this will not be part of the test flow.  This will be a file.
# likely generated from hr_suite, but stored somewhere shared.
#  def generate_sloppy_routes_output_file(file_destination=default_shared_file_location)
#    rr = %x[rake routes]
#    File.open(file_destination, 'w+') { |file| file.write(rr) }
#  end

  def generate_clean_routes(location=default_shared_file_location)
    # get file contents
    sloppy_routes_output = File.read(location)
    import_timestamp_id = Time.now.to_i
    records = sloppy_routes_output.lines.collect do |l|
      parse_out_route_info_and_add_to_database(l, import_timestamp_id)
    end
    return "#{records.count} records for #{import_timestamp_id}"
  end

  #TODO what do we call all the information parsed out??
  #     maybe have someone talk through the rake routes output for our app?
  def parse_out_route_info_and_add_to_database(line, import_timestamp_id)
    return unless route_information_exists_in(line)
    r = RouteImporter.new
    r.update_attributes(
      :import_timestamp_id  => import_timestamp_id,
      :name                 => extract_name_from(line),
      :http_verb            => extract_http_verb_from(line),
      :path                 => extract_path_from(line),
      :action_path          => extract_action_path_from(line),
      :action               => extract_action_from(line),
      :original_route_info  => keep_original_path_info(line)
    )
    r.save
  end

  def route_information_exists_in(line)
    segments = split_line_into_segments(line)
    return true if segments.find { |e| /#/ =~ e }
  end

  def extract_http_verb_from(line)
    http_verb = case
    when line.match("GET"); "GET"
    when line.match("PUT"); "PUT"
    when line.match("POST"); "POST"
    when line.match("DELETE"); "DELETE"
    end
    http_verb
  end

  def extract_name_from(line)
    segments = split_line_into_segments(line)
    http_verb = extract_http_verb_from(line)
    #get name, if the first segment is a verb or path, set name to nil
    first_segment = segments[0]
    if first_segment == http_verb
      name = nil
    elsif first_segment.include?("/")
      name = nil
    else
      name = first_segment
    end
    name
  end

  def extract_path_from(line)
    segments = split_line_into_segments(line)
    return unless segments.find { |e| /(.:format)/ =~ e } # nothing to process
    p = segments.find { |e| /(.:format)/ =~ e }
    "/hr#{p.gsub('(.:format)', '')}"
  end

  def extract_action_from(line)
    segments = split_line_into_segments(line)
    compiled_route = segments.find { |e| /#/ =~ e }.split("#")
    action = compiled_route[1]
  end

  def extract_action_path_from(line)
    segments = split_line_into_segments(line)
    compiled_route = segments.find { |e| /#/ =~ e }.split("#")
    action_path = compiled_route[0]
  end

  def keep_original_path_info(line)
    original_route_info = line.squeeze(" ")
  end

  def split_line_into_segments(line)
    line.squeeze(" ").split(" ")
  end
end

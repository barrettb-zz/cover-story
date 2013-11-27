module RailsRouteImportSupport

  def parse_out_route_info_and_add_to_database(line, import_timestamp_id, route_type)
    r = Route.new
    if route_information_exists_in(line)
      r.update_attributes(
        :import_timestamp_id  => import_timestamp_id,
        :route_type           => route_type,
        :name                 => name_from(line),
        :http_verb            => http_verb_from(line),
        :path                 => path_from(line),
        :action_path          => action_path_from(line),
        :action               => action_from(line),
        :original_route_info  => original_path_info(line)
      )
    else
      r.update_attributes(
        :import_timestamp_id  => import_timestamp_id,
        :route_type           => route_type,
        :name                 => "SKIPPED",
        :original_route_info  => original_path_info(line)
      )
    end
    r.save
  end

private

  def route_information_exists_in(line)
    segments = split_line_into_segments(line)
    return true if segments.find { |e| /#/ =~ e }
  end

  def http_verb_from(line)
    http_verb = case
    when line.match("GET"); "GET"
    when line.match("PUT"); "PUT"
    when line.match("POST"); "POST"
    when line.match("DELETE"); "DELETE"
    end
    http_verb
  end

  def name_from(line)
    segments = split_line_into_segments(line)
    http_verb = http_verb_from(line)
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

  def path_from(line)
    segments = split_line_into_segments(line)
    return unless segments.find { |e| /(.:format)/ =~ e } # nothing to process
    p = segments.find { |e| /(.:format)/ =~ e }
    "/hr#{p.gsub('(.:format)', '')}"
  end

  def action_from(line)
    segments = split_line_into_segments(line)
    compiled_route = segments.find { |e| /#/ =~ e }.split("#")
    action = compiled_route[1]
  end

  def action_path_from(line)
    segments = split_line_into_segments(line)
    compiled_route = segments.find { |e| /#/ =~ e }.split("#")
    action_path = compiled_route[0]
  end

  def original_path_info(line)
    original_route_info = line.squeeze(" ")
  end

  def split_line_into_segments(line)
    line.squeeze(" ").split(" ")
  end
end

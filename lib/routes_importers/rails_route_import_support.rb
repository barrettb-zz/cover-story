module RailsRouteImportSupport

  def parse_out_route_info_and_add_to_database(line, routes_import)
    route = routes_import.routes.create(
      :routes_import_id         => routes_import.id,
      :routes_import_source_id  => routes_import_source.id,
      :original_route_info      => original_path_info(line)
      )
    if route_information_exists_in(line)
      path = path_from_line(line)
      route.update_attributes(
        :name                 => name_from_line(line),
        :method               => method_from_line(line),
        :path                 => path,
        :action_path          => action_path_from_line(line),
        :action               => action_from_line(line),
        :model                => PathProcessor.extract_model_from_path(path)
      )
    else
      route.update_attributes(
        :name                 => "SKIPPED"
      )
    end
  end

private

  def route_information_exists_in(line)
    segments = split_line_into_segments(line)
    return true if segments.find { |e| /#/ =~ e }
  end

  def method_from_line(line)
    method = case
    when line.match("GET"); "GET"
    when line.match("PUT"); "PUT"
    when line.match("POST"); "POST"
    when line.match("DELETE"); "DELETE"
    end
    method
  end

  def name_from_line(line)
    segments = split_line_into_segments(line)
    method = method_from_line(line)
    #get name, if the first segment is a verb or path, set name to nil
    first_segment = segments[0]
    if first_segment == method
      name = nil
    elsif first_segment.include?("/")
      name = nil
    else
      name = first_segment
    end
    name
  end

  def routes_import_file
    @routes_options[:import_path]
  end

  def routes_import_source
    @routes_options[:routes_import_source]
  end

  def path_from_line(line)
    segments = split_line_into_segments(line)
    return unless segments.find { |e| /(.:format)/ =~ e } # nothing to process
    p = segments.find { |e| /(.:format)/ =~ e }

    routes_path_prefix = @routes_config[:routes_path_prefix]
    routes_path_prefix_file_matcher = @routes_config[:routes_path_prefix_file_matcher]
    if routes_import_file.match routes_path_prefix_file_matcher
      path = "#{routes_path_prefix}#{p.gsub('(.:format)', '')}"
    else
      path = "#{p.gsub('(.:format)', '')}"
    end
    path
  end

  def action_from_line(line)
    segments = split_line_into_segments(line)
    compiled_route = segments.find { |e| /#/ =~ e }.split("#")
    action = compiled_route[1]
  end

  def action_path_from_line(line)
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

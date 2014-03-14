module RoutesFileLines
  include ResultsLogger

  def create_route_from_line(params)
    line = params[:line]
    file_name = params[:file_name]
    path = path_from_line(line)
    route = Route.create(
      method:                 method_from_line(line),
      controller:             controller_from_line(line),
      action:                 action_from_line(line),
      path:                   path,
      source:                 File.basename(file_name)
    )

    route.add_history :active
    route.histories.last.update_attributes(
      preformatted_path:    preformatted_path_from_line(line),
      name:                 name_from_line(line),
      original_route_info:  original_route_info(line)
    )
  end

private

  def route_information_exists_in_line?(line)
    if route_is_root(line)
      return false
    end
    segments = split_line_into_segments(line)
    if segments[0] == "\/"
      output_and_log_info("!cannot process route file line: #{line}")
      return false
    end
    return true if segments.find { |e| /#/ =~ e }
    false
  end

  def route_is_root(line)
    segments = split_line_into_segments(line)
    return true if segments[0] == "root"
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

  def preformatted_path_from_line(line)
    segments = split_line_into_segments(line)
    return unless segments.find { |e| /(.:format)/ =~ e } # nothing to process
    p = segments.find { |e| /(.:format)/ =~ e }

    routes_path_prefix = @config[:routes_path_prefix]
    routes_path_prefix_file_matcher = @config[:routes_path_prefix_file_matcher]
    if @file_path.match routes_path_prefix_file_matcher
      path = "#{routes_path_prefix}#{p.gsub('(.:format)', '')}"
    else
      path = "#{p.gsub('(.:format)', '')}"
    end
    path
  end

  def path_from_line(line)
    return unless route_information_exists_in_line?(line)
    p = preformatted_path_from_line(line)
    PathProcessor.format_route_path(p)
  end

  def action_from_line(line)
    segments = split_line_into_segments(line)
    compiled_route = segments.find { |e| /#/ =~ e }.split("#")
    compiled_route[1]
  end

  def controller_from_line(line)
    segments = split_line_into_segments(line)
    compiled_route = segments.find { |e| /#/ =~ e }.split("#")
    c = compiled_route[0]
    PathProcessor.format_route_controller(c)
  end

  def original_route_info(line)
    line.squeeze(" ")
  end

  def split_line_into_segments(line)
    line.squeeze(" ").split(" ")
  end
end

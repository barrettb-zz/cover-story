require "#{Rails.root}/lib/routes_importers/rails_routes_import"

class RoutesImportService < SimpleDelegator
  def initialize(params)
    routes_type = params[:type]

    # default to rails
    routes_type ||= "rails"

    case routes_type.downcase
    when "rails"
      super(RailsRoutesImport.new)
    else
      raise "Unsupported type: #{routes_type}. Try 'rails'"
    end

    self.setup(params)
  end
end

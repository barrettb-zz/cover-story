require "#{Rails.root}/lib/routes_importers/routes_import"

class RoutesImportService < SimpleDelegator
  def initialize(params)
    routes_type = APP_CONFIG[:routes_config][:type]
    case routes_type.downcase
    when "rails"
      super(RoutesImport.new)
    else
      raise "Unsupported type: #{routes_type}. Try 'rails'"
    end

    self.setup(params)
  end
end

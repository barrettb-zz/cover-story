class FixupAnalysisRelatedColumns < ActiveRecord::Migration
  def change
    rename_column :analyses, :model_percentage_covered, :controller_percentage_covered
    rename_column :analyzed_route_models, :model, :controller
    rename_column :analyzed_routes, :formatted_path, :path
    remove_column :analyses, :routes_import_id
  end
end

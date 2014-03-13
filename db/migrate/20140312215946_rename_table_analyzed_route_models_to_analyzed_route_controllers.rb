class RenameTableAnalyzedRouteModelsToAnalyzedRouteControllers < ActiveRecord::Migration
  def change
    rename_table :analyzed_route_models, :analyzed_route_controllers
  end
end

class RenameAnalyzedRoutesTable < ActiveRecord::Migration
  def change
    rename_table :analyzed_routes, :analyzed_route_paths
  end
end

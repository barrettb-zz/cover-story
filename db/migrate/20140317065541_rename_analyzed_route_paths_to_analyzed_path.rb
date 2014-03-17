class RenameAnalyzedRoutePathsToAnalyzedPath < ActiveRecord::Migration
  def change
    rename_table :analyzed_route_paths, :analyzed_paths
  end
end

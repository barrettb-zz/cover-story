class RemoveRouteIdFromAnalyzedRoutes < ActiveRecord::Migration
  def change
    remove_column :analyzed_routes, :route_id, :integer
  end
end

class MakePathColumnsText < ActiveRecord::Migration
  def change
    change_column :analyzed_route_paths, :path, :text
    change_column :route_histories, :preformatted_path, :text
    change_column :routes, :path, :text
  end
end

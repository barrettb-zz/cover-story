class FixupRoutesColumns < ActiveRecord::Migration
  def change
    add_column :routes, :inactive, :boolean
    add_column :routes, :source, :string

    remove_column :routes, :name
    remove_column :routes, :path
    remove_column :routes, :original_route_info

    remove_column :routes, :routes_import_id
    remove_column :routes, :routes_import_source_id

    rename_column :routes, :formatted_path, :path
    rename_column :routes, :action_path, :controller
    rename_column :routes, :model, :controller_association
  end
end

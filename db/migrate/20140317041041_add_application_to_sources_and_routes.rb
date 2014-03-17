class AddApplicationToSourcesAndRoutes < ActiveRecord::Migration
  def change
    add_column :sources, :application, :string
    add_column :routes, :application, :string
    rename_column :routes, :source, :filename
  end
end

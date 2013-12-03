class DeleteRouteImporterTables < ActiveRecord::Migration
  def change
    drop_table :route_importer_definitions
    drop_table :route_importers
  end
end

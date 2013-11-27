class CreateRouteImporterDefinitions < ActiveRecord::Migration
  def change
    create_table :route_importer_definitions do |t|
      t.string :name
      t.string :path_to_import_file

      t.timestamps
    end
  end
end
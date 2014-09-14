class DropUnusedRoutesImportTables < ActiveRecord::Migration
  def change
    drop_table :routes_import_sources
    drop_table :routes_imports
  end
end

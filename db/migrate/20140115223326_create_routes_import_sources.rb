class CreateRoutesImportSources < ActiveRecord::Migration
  def change
    create_table :routes_import_sources do |t|
      t.string :file_path

      t.timestamps
    end

    remove_column :routes_imports, :routes_import_parent_id

    change_table :routes do |t|
      t.references :routes_import_source
    end
  end
end

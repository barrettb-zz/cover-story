class CreateRoutesImports < ActiveRecord::Migration
  def change
    create_table :routes_imports do |t|
      t.string :import_timestamp
      t.string :route_type
      t.string :file_path

      t.timestamps
    end

    add_reference :routes, :routes_import, index: true
  end
end

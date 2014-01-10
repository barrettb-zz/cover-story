class CreateRoutesImportParents < ActiveRecord::Migration
  def change
    create_table :routes_import_parents do |t|
      t.timestamps
    end

    change_table :routes_imports do |t|
      t.belongs_to :routes_imports_parent
    end

    remove_column :routes_imports, :import_timestamp

    change_table :analyses do |t|
      t.references :routes_import_parent
    end
  end
end

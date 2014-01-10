class FixRoutesImportParentIdName < ActiveRecord::Migration
  def change
    rename_column :routes_imports, :routes_imports_parent_id, :routes_import_parent_id
  end
end

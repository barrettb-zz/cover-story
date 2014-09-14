class RemoveRoutesImportParentRelatedItems < ActiveRecord::Migration
  def change
    change_table :analyses do |t|
      t.references :routes_import
    end
    remove_column :analyses, :routes_import_parent_id
  end
end

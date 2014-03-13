class ChangeImportColumnInRevisions < ActiveRecord::Migration
  def change
    rename_column :revisions, :routes_import_id, :import_collection_id
  end
end

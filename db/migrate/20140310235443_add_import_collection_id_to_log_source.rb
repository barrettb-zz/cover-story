class AddImportCollectionIdToLogSource < ActiveRecord::Migration
  def change
    add_column :sources, :import_collection_id, :integer
  end
end

class AddImportCollectionIdToAnalyses < ActiveRecord::Migration
  def change
    add_column :analyses, :import_collection_id, :integer
  end
end

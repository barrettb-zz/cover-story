class FixupImportCollectionRelatedColumns < ActiveRecord::Migration
  def change
    remove_column :analyses, :source_id
    add_column :import_collections, :ignore, :boolean
  end
end

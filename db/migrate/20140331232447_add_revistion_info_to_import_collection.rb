class AddRevistionInfoToImportCollection < ActiveRecord::Migration
  def change
    add_column :import_collections, :release_tag, :string
    drop_table :revisions
  end
end

class CreateImportCollections < ActiveRecord::Migration
  def change
    create_table :import_collections do |t|
      t.string :bundle_file_name
      t.timestamps
    end
  end
end

class CreateRevisions < ActiveRecord::Migration
  def change
    create_table :revisions do |t|
      t.belongs_to :routes_import
      t.string :tag
      t.timestamps
    end
  end
end

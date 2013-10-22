class CreateRouteImporters < ActiveRecord::Migration
  def change
    create_table :route_importers do |t|
      t.integer :import_timestamp_id
      t.string :name
      t.string :http_verb
      t.string :path
      t.string :action_path
      t.string :action
      t.text :original_route_info

      t.timestamps
    end
  end
end

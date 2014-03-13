class CreateRouteHistories < ActiveRecord::Migration
  def change
    create_table :route_histories do |t|
      t.belongs_to :route
      t.boolean :activated
      t.boolean :inactivated
      t.string :preformatted_path
      t.string :name
      t.text :original_route_info
      t.timestamps
    end
  end
end

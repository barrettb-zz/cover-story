class CreateProductionPathsAndControllers < ActiveRecord::Migration
  def change
    create_table :production_paths do |t|
      t.belongs_to :analysis
      t.string :path
      t.integer :count

      t.timestamps
    end

    create_table :production_controllers do |t|
      t.belongs_to :analysis
      t.string :controller
      t.integer :count

      t.timestamps
    end
  end
end

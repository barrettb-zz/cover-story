class CreateAnalyzedRoutes < ActiveRecord::Migration
  def change
    create_table :analyzed_routes do |t|
      t.belongs_to :analysis
      t.references :route, index: true
      t.string :formatted_path
      t.integer :count

      t.timestamps
    end
  end
end

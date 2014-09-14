class CreateAnalyzedRouteModels < ActiveRecord::Migration
  def change
    create_table :analyzed_route_models do |t|
      t.references :analysis, index: true
      t.string :model
      t.integer :count

      t.timestamps
    end
  end
end

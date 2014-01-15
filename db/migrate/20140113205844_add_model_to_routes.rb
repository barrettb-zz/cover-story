class AddModelToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :model, :string
  end
end

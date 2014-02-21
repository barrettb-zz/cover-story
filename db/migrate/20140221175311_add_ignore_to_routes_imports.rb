class AddIgnoreToRoutesImports < ActiveRecord::Migration
  def change
    add_column :routes_imports, :ignore, :boolean
  end
end

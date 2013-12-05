class FixRoutesColumnNames < ActiveRecord::Migration
  def change
    rename_column :routes, :http_verb, :method
  end
end

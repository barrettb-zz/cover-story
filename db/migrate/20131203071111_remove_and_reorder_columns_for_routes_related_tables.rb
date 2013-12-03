class RemoveAndReorderColumnsForRoutesRelatedTables < ActiveRecord::Migration
  def change
    remove_column :routes, :import_timestamp_id
    remove_column :routes, :route_type
  end
end

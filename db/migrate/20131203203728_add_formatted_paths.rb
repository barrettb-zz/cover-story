class AddFormattedPaths < ActiveRecord::Migration
  def change
    add_column :started_lines, :formatted_path, :string
    add_column :routes, :formatted_path, :string
  end
end

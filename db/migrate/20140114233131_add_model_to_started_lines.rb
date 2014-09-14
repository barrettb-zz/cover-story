class AddModelToStartedLines < ActiveRecord::Migration
  def change
    add_column :started_lines, :model, :string
  end
end

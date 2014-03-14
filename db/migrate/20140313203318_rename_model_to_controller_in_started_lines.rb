class RenameModelToControllerInStartedLines < ActiveRecord::Migration
  def change
    rename_column :started_lines, :model, :controller
  end
end

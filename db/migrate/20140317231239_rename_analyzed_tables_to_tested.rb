class RenameAnalyzedTablesToTested < ActiveRecord::Migration
  def change
    rename_table :analyzed_controllers, :tested_controllers
    rename_table :analyzed_paths, :tested_paths
  end
end

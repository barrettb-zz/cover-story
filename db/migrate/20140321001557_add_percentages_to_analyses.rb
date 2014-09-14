class AddPercentagesToAnalyses < ActiveRecord::Migration
  def up
    change_table :analyses do |t|
      t.remove :percentage_covered
      t.remove :analysis_type

      t.decimal :tested_controllers_percentage, :precision => 6, :scale => 3
      t.decimal :tested_paths_percentage, :precision => 6, :scale => 3

      t.decimal :used_controllers_percentage, :precision => 6, :scale => 3
      t.decimal :used_paths_percentage, :precision => 6, :scale => 3

      t.decimal :tested_used_controllers_percentage, :precision => 6, :scale => 3
      t.decimal :tested_used_paths_percentage, :precision => 6, :scale => 3

      t.decimal :used_controllers_percentage_all_time, :precision => 6, :scale => 3
      t.decimal :used_paths_percentage_all_time, :precision => 6, :scale => 3

      t.decimal :tested_used_controllers_percentage_all_time, :precision => 6, :scale => 3
      t.decimal :tested_used_paths_percentage_all_time, :precision => 6, :scale => 3
    end
  end

  def down
    change_table :analyses do |t|
      t.decimal :percentage_covered
      t.string :analysis_type

      t.remove :tested_controllers_percentage
      t.remove :tested_paths_percentage

      t.remove :used_controllers_percentage
      t.remove :used_paths_percentage

      t.remove :tested_used_controllers_percentage
      t.remove :tested_used_paths_percentage

      t.remove :used_controllers_percentage_all_time
      t.remove :used_paths_percentage_all_time

      t.remove :tested_used_controllers_percentage_all_time
      t.remove :tested_used_paths_percentage_all_time
    end
  end
end

class ChangeColumnsToTextInParametersAndStartedLines < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :parameters_lines do |t|
        dir.up   { t.change :params, :text }
        dir.down { t.change :params, :string }
      end

      change_table :started_lines do |t|
        dir.up   { t.change :path, :text }
        dir.down { t.change :path, :string }
      end
    end
  end
end

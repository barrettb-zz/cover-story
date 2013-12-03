class AddSourceTypeAndEnvironment < ActiveRecord::Migration
  def change
    add_column :sources, :file_type, :string
    add_column :sources, :env, :string
    add_index :sources, :env
  end
end

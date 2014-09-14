class AddIgnoreToSources < ActiveRecord::Migration
  def change
    add_column :sources, :ignore, :boolean
  end
end

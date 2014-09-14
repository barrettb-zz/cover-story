class AddApplicationToAnalyses < ActiveRecord::Migration
  def change
    add_column :analyses, :application, :string
  end
end

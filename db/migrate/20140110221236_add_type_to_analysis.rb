class AddTypeToAnalysis < ActiveRecord::Migration
  def change
    add_column :analyses, :analysis_type, :string
  end
end

class AddModelPercentageCoveredToAnalyses < ActiveRecord::Migration
  def change
    add_column :analyses, :model_percentage_covered, :integer
  end
end

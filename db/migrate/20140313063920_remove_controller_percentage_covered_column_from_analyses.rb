class RemoveControllerPercentageCoveredColumnFromAnalyses < ActiveRecord::Migration
  def change
    remove_column :analyses, :controller_percentage_covered
  end
end

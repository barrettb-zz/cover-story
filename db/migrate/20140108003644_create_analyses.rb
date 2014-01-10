class CreateAnalyses < ActiveRecord::Migration
  def change
    create_table :analyses do |t|
      t.belongs_to :source, index: true
      t.decimal :percentage_covered

      t.timestamps
    end
  end
end

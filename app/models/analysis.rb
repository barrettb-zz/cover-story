class Analysis < ActiveRecord::Base
  belongs_to :import_collection

  def self.tested_results
    self.pluck(:analysis_type, :percentage_covered, :created_at).map { |a, p, c|
      {
        analysis_type: a,
        percentage_covered: p.to_f,
        date: c
      }
    }
  end

  def self.unique_percentage(compare_array, total_array)
    (compare_array.uniq.size.to_f/total_array.uniq.size) * 100
  end
end

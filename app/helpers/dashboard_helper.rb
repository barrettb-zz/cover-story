# TODO make sure we only pull in active things here.

require 'gchart'
module DashboardHelper

  def percentage_data(application, calculation)
    array = Analysis.valid.where(application: application).pluck(
      :created_at,
      calculation.to_sym
    ).map { |d, p|
      [
        d.strftime('%d %b %y'), # get date formatting happy
        p.to_f
      ]
    }

    # add in header info
    array.unshift ['Date', 'Percentage']
  end

  def list_content(calculation)
    c = (
      calculation.match(/controller/) ||
      calculation.match(/path/)
    ).to_s
    raise "no supported content found. Expected controller, path or used" if c.empty?
    c
  end

  def show_tested_list?(calculation)
    return false if calculation.match(/used/) # used not supported for now? temporary..
    return false if calculation.match(/all_time/) # used not supported for now? temporary..
    return true if calculation.match(/tested/)
    false
  end
end

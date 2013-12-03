class Request < ActiveRecord::Base

    has_one :started_line, dependent: :destroy
    has_one :completed_line, dependent: :destroy

    belongs_to :source



end

class Source < ActiveRecord::Base

    has_many :requests, dependent: :destroy



end

class Revision < ActiveRecord::Base
  belongs_to :import_collection
end

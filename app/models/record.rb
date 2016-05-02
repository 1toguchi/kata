class Record < ActiveRecord::Base
  validates :content, presence: true
end

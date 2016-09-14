class Make < ActiveRecord::Base
  has_many :models

  validates :name, :webmotors_id, presence: true
end

class Model < ActiveRecord::Base
  belongs_to :make

  validates :name, :make, presence: true
end

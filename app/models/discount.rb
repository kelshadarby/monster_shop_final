class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :percent_off,
                        :min_quantity

  validates_numericality_of :percent_off, greater_than: 0, only_integer: true
  validates_numericality_of :min_quantity, greater_than: 0, only_integer: true

end

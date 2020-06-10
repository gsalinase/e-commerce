class Variation < ApplicationRecord
  belongs_to :size
  belongs_to :color
  belongs_to :product
end

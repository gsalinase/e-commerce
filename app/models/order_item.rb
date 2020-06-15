class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_many :variations, through: :product

  def variation
    variations
  end
end

class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_many :variations, through: :product

  def product
    variations
  end
end

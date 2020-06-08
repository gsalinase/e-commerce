class Order < ApplicationRecord
  ORDER_PREFIX = 'PO'
  RANDOM_SIZE = 9
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items
  has_many :payments
  before_create -> { generate_number(RANDOM_SIZE) }
  validates :number, uniqueness: true

  def generate_number(size) self.number ||= loop do
    random = random_candidate(size)
      break random unless self.class.exists?(number: random) 
    end
  end

  def random_candidate(size)
    "#{ORDER_PREFIX}#{Array.new(size){rand(size)}.join}"
  end

  def add_product(product_id, quantity)
    product = Product.find(product_id)
    if product && product.stock > 0
      order_items.create(product_id: product.id, quantity: quantity, price: product.price)
    end
  end

  def add_to_order(price, user_id)
    order = Order.find_by(user_id: user_id)
    total_cart = order.total + price.to_f
    order.update(total: total_cart)
  end
end

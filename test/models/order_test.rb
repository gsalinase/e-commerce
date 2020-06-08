require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test "generates a random number on create" do
    user = users(:one)
    order = Order.create(user_id: user.id)
    assert_not order.number.nil? 
  end

  test "Number must be a unique " do
    user = users(:one)
    order = Order.create(user_id: user.id)
    duplicate_order = order.dup

    assert_not duplicate_order.valid?
  end

  test "adds products as order_items " do
    user = users(:one)
    order = Order.create(user_id: user.id)
    product = products(:one)
    order.add_product(product.id, 1)

    assert_equal(order.order_items.count, 1)
  end

  test "product with zero stock cannot be added to cart" do
    user = users(:one)
    order = Order.create(user_id: user.id)

    product = products(:two)
    order.add_product(product.id, 1)

    assert_equal(order.order_items.count, 0)
  end
end

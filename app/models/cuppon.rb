class Cuppon < ApplicationRecord
  belongs_to :user
  validate :valid_cuppon

  # Get Percentage discount
  def discount_percentage(percentage, price)
    discount_percent = (price * percentage) / 100
    price - discount_percent
  end

  # Get total discount
  def total_discount(price)
    # Assign if have a data
    discounted = discount || amount
    # Returns:
    # total discount with percentage
    return discount_percentage(discounted, price) if discount.present?
    # total discount with amount
    return (price - discounted.to_i) if amount.present?
  end

  # Validate if discount is major to price
  def major_to_price(price)
    return errors.add(:base, 'Cuppon used') if total_discount(price) >= price
  end

  # Validate Cuppon
  def valid_cuppon
    # Type of Cuppon:
    # Unique: used fo specific user
    # rrss: used for normal promotions and all users
    if kind == 'unique' && used_count.positive?
      errors.add(:base, 'Cuppon used')
    elsif Cuppon.find_by(user_id: user_id).present?
      errors.add(:base, 'Cuppon used')
  end
end

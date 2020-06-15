class PaymentMethod < ApplicationRecord
  has_many :payments

  # Paypal
  def setup_purchase(price, setup)
    # Setup purchase
    EXPRESS_GATEWAY.setup_purchase(
      price,
      setup
    )
  end

  def purchase(price, setup)
    # Set a purchase
    EXPRESS_GATEWAY.purchase(
      price,
      setup
    )
  end

  def details(token)
    # Get details of purchase
    EXPRESS_GATEWAY.details_for(token)
  end

  def redirect_to_paypal(token)
    # Redirect to paypal
    EXPRESS_GATEWAY.redirect_url_for(token)
  end

  def payment_success(query)
    # Find and assign payment
    payment = Payment.find_by(query)
    order = payment.order

    # Update object states
    payment.state = 'completed'
    order.state = 'completed'

    # Avoid errors on transaction
    ActiveRecord::Base.transaction do
      order.save!
      payment.save!
    end
  end
end

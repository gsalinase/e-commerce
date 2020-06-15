require 'rails_helper'

RSpec.describe PaymentMethod, type: :model do
  context 'when payment method is paypal' do
    it "create a setup" do
      paypal = PaymentMethod.find_by(code: 'PEC')
      setup_purchase = paypal.setup_purchase(
        0.4752e5,
        {
          ip: '::1',
          return_url: 'http://localhost:3000/cart/process_paypal_payment',
          cancel_return_url: 'http://localhost:3000/',
          allow_guest_checkout: true,
          currency: 'USD'
        }
      )

      expect(setup_purchase).to eq(setup_purchase)
    end
  end
end

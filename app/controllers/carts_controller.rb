class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_payment, only: [:pay_with_paypal, :process_paypal_payment]

  def update
    current_order.add_product(params[:cart][:product_id], params[:cart][:quantity])
    current_order.add_to_order(params[:cart][:price], current_user.id)

    redirect_to root_path, notice: 'Product added successfuly'
  end

  def show
    @order = current_order
  end

  def pay_with_paypal
    # Setup purchase
    prepare_purchase = @payment_method.setup_purchase(
      current_order.total,
      {
        ip: request.remote_ip,
        return_url: process_paypal_payment_cart_url,
        cancel_return_url: root_url,
        allow_guest_checkout: true,
        currency: 'USD'
      }
    )

    pry

    # Initialize payment
    Payment.create(
      order_id: current_order.id,
      payment_method_id: @payment_method.id,
      state: 'processing',
      total: current_order.total,
      token: prepare_purchase.token
    )

    # Redirect to PayPal
    redirect_to @payment_method.redirect_to_paypal(prepare_purchase.token)
  end

  def process_paypal_payment
    # Get details
    details = @payment_method.details(params[:token])
    price = details.params['order_total'].to_d * 100

    # Set a purchase
    purchase = @payment_method.purchase(
      price,
      {
        ip: request.remote_ip,
        token: params[:token],
        payer_id: details.payer_id,
        currency: 'USD'
      }
    )

    if purchase.success?
      # Change state and save changes
      @payment_method.payment_success(token: purchase.token)

      redirect_to root_url, notice: 'Compra exitosa'
    else
      redirect_to root_url, alert: 'Hemos tenido problemas para procesar tu pago'
    end
  end

  private
  def find_payment
    @payment_method = PaymentMethod.find_by(code: 'PEC')
  end

  def category_params
    params.require(:category).permit(:name)
  end
end

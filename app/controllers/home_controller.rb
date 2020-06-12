class HomeController < ApplicationController
  def index
    @products = Product.in_stock
  end
end

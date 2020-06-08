class ApplicationController < ActionController::Base
  def current_order
    if current_user
      Order.find_or_create_by(user_id: current_user.id, state: 'created')
    end
  end
end

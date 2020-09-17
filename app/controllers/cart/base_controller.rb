class Cart::BaseController < ApplicationController
  before_action :require_not_admin

  def require_not_admin
    if current_admin?
      render file: "/public/404"
    end
  end
end

class Merchant::BaseController < ApplicationController
  before_action :require_merchant

  def require_merchant
    if !current_merchant?
      render file: "/public/404"
    end
  end
end

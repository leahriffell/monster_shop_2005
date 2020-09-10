class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    session[:user_id] = user.id
    if user.role == "admin"
      flash[:success] = "Welcome Admin #{user.name}!"
      redirect_to '/admin/dashboard'
    elsif user.role == "merchant"
      flash[:success] = "Welcome Merchant, #{user.name}!"
      redirect_to '/merchants/dashboard'
    else
      flash[:success] = "Welcome, #{user.name}. You are logged in!"
      redirect_to "/profile"
    end
  end


end

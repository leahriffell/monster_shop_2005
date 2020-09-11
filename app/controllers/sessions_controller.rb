class SessionsController < ApplicationController

  def new
    if session[:user_id]
      user = User.find(session[:user_id])
      # Can we make this condition a model method (maybe a case statement)? Use it to refactor sessions#create as well?
      if user.role == "admin"
        redirect_to(admin_dashboard_path)
      elsif user.role == "merchant"
        redirect_to(merchants_dashboard_path)
      else
        redirect_to(profile_path)
      end
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user == nil || !user.authenticate(params[:password])
      flash[:failure] = "Incorrect email or password."
      redirect_to(login_path)
    else
      session[:user_id] = user.id
      if user.role == "admin"
        flash[:success] = "Welcome Admin, #{user.name}!"
        redirect_to(admin_dashboard_path)
      elsif user.role == "merchant"
        flash[:success] = "Welcome Merchant, #{user.name}!"
        redirect_to(merchants_dashboard_path)
      else
        flash[:success] = "Welcome, #{user.name}. You are logged in!"
        redirect_to(profile_path)
      end
    end
  end


end

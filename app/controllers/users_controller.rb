class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      flash[:success] = "Welcome, #{user.name}"
      redirect_to '/profile'
    else
      flash[:failure] = "You are missing one or more required fields"
      redirect_to '/register'
    end

  end

  def show

  end

  private
  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end

end

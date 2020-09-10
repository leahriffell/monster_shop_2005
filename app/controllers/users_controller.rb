class UsersController < ApplicationController

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome, #{@user.name}"
      redirect_to '/profile'
    elsif user_params.values.any?('')
      flash[:failure] = "You are missing one or more required fields"
      render :new
    else
      flash[:error] = "The email address #{@user.email} is already in use"
      @user.email = nil
      render :new
    end
  end

  def show

  end

  private
  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end

end

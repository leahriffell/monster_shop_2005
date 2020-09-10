class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    require "pry"; binding.pry
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome, #{@user.name}"
      redirect_to '/profile'
      # if @user.role == 2
      #   flash[:success] = "Welcome Admin #{@user.name}!"
      #   redirect_to '/admin/dashboard'
      # elsif @user.role == 1
      #   flash[:success] = "Welcome Merchant, #{@user.name}!"
      #   redirect_to '/merchants/dashboard'
      # else
      #   flash[:success] = "Welcome, #{@user.name}"
      #   redirect_to '/profile'
      # end
    elsif User.email_exists?(@user.email)
      flash[:failure] = @user.errors.full_messages.to_sentence
      @user.email = nil
      render :new
    else
      flash[:failure] = @user.errors.full_messages.to_sentence
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

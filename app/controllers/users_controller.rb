class UsersController < ApplicationController

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome, #{@user.name}"
      redirect_to '/profile'
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

class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      # condition 1 = all params are great
      flash[:success] = "Welcome, #{user.name}"
      redirect_to '/profile'
      # condition 2 = email param she empty
    elsif
      # condition 1 - just missing field
      flash[:failure] = "You are missing one or more required fields"
      redirect_to '/register'
    else
      # pass params to a session and call from there
      #within "new" we would have that logic (maybe a PORO?)
      # condition 2 - email isn't unique - save as @user without pass/email (model condition that allows this, private empty_fields)?
        # user.update(passowrd, email)
    end

  end

  def show

  end

  private
  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end

end

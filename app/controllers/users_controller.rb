class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if User.email_exists?(@user.email)
      @user.email = nil
      # user_fails_create_validation # This is failing BECAUSE, @user.errors doesn't show ANY errors - we wonder if this is because we had to update a user to "save" without unique email to prompt errors; our current solution is to handroll this flash[:error] message :)
      flash[:error] = "Email has already been taken"
      render :new
    elsif @user.save
      flash[:success] = "Welcome, #{@user.name}"
      redirect_to '/profile'
    else
      user_fails_create_validation
    end
  end

  def show
    if current_visitor?
      render file: "/public/404"
    end
  end

  def edit
    if params[:password]
      render :change_password
    else
      render :edit
    end
  end

  def update
    current_user.update(user_params)
    if user_params[:password]
      if current_user.save
        flash[:success] = "Your password has been updated."
        redirect_to profile_path
      else
        flash[:error] = current_user.errors.full_messages.to_sentence
        render :change_password
      end
    else
      if current_user.save
        flash[:success] = "Your profile info has been updated."
        redirect_to profile_path
      else
        flash[:error] = current_user.errors.full_messages.to_sentence
        render :edit
      end
    end
  end

  private
  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end

  def user_fails_create_validation
    flash[:error] = @user.errors.full_messages.to_sentence
    render :new
  end
end
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
      flash[:error] = @user.errors.full_messages.to_sentence
      @user.email = nil
      render :new
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :new
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
        flash[:error] = "The passwords entered do not match."
        render :change_password
      end
    else 
      if current_user.save
        flash[:success] = "Your profile info has been updated."
        redirect_to profile_path
      elsif User.email_exists?(current_user.email)
        flash[:error] = current_user.errors.full_messages.to_sentence
        render :edit
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
end

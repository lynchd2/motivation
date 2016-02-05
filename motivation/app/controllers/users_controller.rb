class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	@user = User.create(user_params)
  	if @user.save!
  		session[:user_id] = @user.id
  		flash[:notice] = "User successfully created"
  		redirect_to @user
  	else
  		flash.now[:notice] = "Failed to create user"
      render 'new'
  	end
  end

  def show
  end

  private

  def user_params
  	params.require(:user).permit(:email, :password, :password_confirmation)
  end
end

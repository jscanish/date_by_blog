class UsersController < ApplicationController
  before_action :require_user, only: [:index, :show]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to home_path, notice: "You've been registered!"
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end


  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end

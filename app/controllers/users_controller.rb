class UsersController < ApplicationController
  before_action :require_user, only: [:index, :show, :edit, :update, :search]
  before_action :set_user, only: [:edit]
  before_action :require_creator, only: [:edit, :update]

  def index
    @users = User.all
  end


  def new
    @user = User.new
  end


  def create
    @user = User.new(user_params)

    if @user.save
      Question.create(user: @user)
      session[:user_id] = @user.id
      redirect_to home_path, notice: "You've been registered!"
    else
      render :new
    end
  end


  def show
    @user = User.find(params[:id])
  end


  def edit
    @questions = @user.set_of_questions
  end


  def update; end


  def search
    @users = nearby_matches
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :gender, :address)
  end

  def nearby_matches
    users = User.near([current_user.latitude, current_user.longitude], 30)
    users.select { |user| user.gender != current_user.gender }
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_creator
    redirect_to home_path unless logged_in? && @user == current_user
  end
end

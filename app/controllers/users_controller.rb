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

  def search; end

  def search_results
    @users = results
  end



  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :gender, :address, :age)
  end

  def results
    params[:distance] == "All" ? distance = User.all : distance =
    User.near([current_user.latitude, current_user.longitude], params[:distance])

    params[:gender] == "Both" ? distance_gender = distance : distance_gender =
    distance.select{|user| user.gender == params[:gender]}

    distance_gender_age = distance_gender.select{ |user| user.age <=
    params[:max_age].to_i && user.age >= params[:min_age].to_i }

    distance_gender_age.delete(current_user)
    distance_gender_age
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_creator
    redirect_to home_path unless logged_in? && @user == current_user
  end
end

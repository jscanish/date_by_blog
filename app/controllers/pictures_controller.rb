class PicturesController < ApplicationController
  before_action :require_user

  def new
    @picture = Picture.new
  end

  def create
    @user = current_user
    @picture = Picture.new(picture_params)

    if @picture.save
      @user.pictures << @picture
      flash[:notice] = "Picture Added!"
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def show
    @picture = Picture.find(params[:id])
  end

  def destroy
    @picture = Picture.find(params[:id])
    if logged_in? && @picture.user == current_user
      @picture.delete
      redirect_to user_path(current_user)
    else
      redirect_to login_path
      flash[:notice] = "You can't do that!"
    end
  end


  private

  def picture_params
    params.require(:picture).permit(:title, :description, :image)
  end
end

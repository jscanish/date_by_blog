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
    @user = @picture.user
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

  def set_avatar
    @picture = Picture.find(params[:id])
    @user = @picture.user

    if @user == current_user
      @user.update_column(:avatar, fix_url(@picture.image.to_s))
      redirect_to user_path(@user)
    else
      redirect_to login_path
    end
  end


  private

  def picture_params
    params.require(:picture).permit(:title, :description, :image)
  end

  def fix_url(string)
    string[9..-1]
  end
end


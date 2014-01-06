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


  private

  def picture_params
    params.require(:picture).permit(:title, :description, :image, :large_image)
  end
end

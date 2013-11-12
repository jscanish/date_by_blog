class PostsController < ApplicationController
  before_action :require_user
  before_action :require_creator, only: [:new]

  def index
    @user = User.find(params[:user_id])
    @posts = @user.posts
  end

  def show
    @user = User.find(params[:user_id])
    @post = Post.find(params[:id])
  end

  def new
    @user = User.find(params[:user_id])
    @post = @user.posts.new
  end

  def create
    @user = User.find(params[:user_id])
    @post = @user.posts.new(post_params)

    if @post.save
      flash[:notice] = "Post Created!"
      redirect_to user_posts_path(@user)
    else
      render :new
    end
  end

  private

  def post_params
    params.require(:post).permit(:body, :title)
  end

  def require_creator
    redirect_to home_path unless logged_in? && current_user == User.find(params[:user_id])
  end

end

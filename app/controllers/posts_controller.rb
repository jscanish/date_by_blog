class PostsController < ApplicationController
  before_action :require_user
  before_action :require_creator, only: [:new, :create, :edit, :update, :destroy]

  def show
    @user = User.find(params[:user_id])
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments
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
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @post = Post.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    @post = Post.find(params[:id])

    if @post.update(post_params)
      flash[:notice] = "Post Updated!"
      redirect_to user_posts_path(@user, @post)
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @post = Post.find(params[:id])

    if current_user == @post.user
      @post.delete
      flash[:notice] = "Post Deleted"
      redirect_to user_path(@user)
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

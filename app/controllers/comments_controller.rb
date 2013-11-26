class CommentsController < ApplicationController
  before_action :require_user

  def create
    @user = User.find(params[:user_id])
    @post = Post.find(params[:post_id])
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.post = @post

    if @comment.save
      redirect_to user_post_path(@user, @post)
    else
      flash[:error] = "Comment can't be blank!"
      redirect_to user_post_path(@user, @post)
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])

    if logged_in? && current_user == @comment.user || current_user == @post.user
      @comment.delete
      redirect_to user_post_path(@user, @post)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

end

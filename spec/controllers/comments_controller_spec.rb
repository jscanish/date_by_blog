require 'spec_helper'

describe CommentsController do
  before(:each) do
    User.any_instance.stub(:geocode).and_return([1,1])
  end

  describe "POST create" do
    before do
      @current_user = Fabricate(:user)
      session[:user_id] = @current_user.id
      @user = Fabricate(:user)
      @post = Fabricate(:post)
    end
    it "requires a logged in user" do
      session[:user_id] = nil
      post :create, user_id: @user.id, post_id: @post.id, comment: Fabricate.to_params(:comment)
      expect(response).to redirect_to login_path
    end
    it "sets @user variable" do
      post :create, user_id: @user.id, post_id: @post.id, comment: Fabricate.to_params(:comment)
      expect(assigns(:user)).to eq(@user)
    end
    it "sets @post variable" do
      post :create, user_id: @user.id, post_id: @post.id, comment: Fabricate.to_params(:comment)
      expect(assigns(:post)).to eq(@post)
    end
    context "valid inputs" do
      it "creates a new comment" do
        post :create, user_id: @user.id, post_id: @post.id, comment: Fabricate.to_params(:comment)
        expect(@current_user.comments.count).to eq(1)
      end
      it "redirects to the post show page" do
        post :create, user_id: @user.id, post_id: @post.id, comment: Fabricate.to_params(:comment)
        expect(response).to redirect_to user_post_path(@user, @post)
      end
    end
    context "invalid inputs" do
      it "doesn't create a comment" do
        post :create, user_id: @user.id, post_id: @post.id, comment: Fabricate.to_params(:comment, body: nil)
        expect(@current_user.comments.count).to eq(0)
      end
      it "redirects to the post show page" do
        post :create, user_id: @user.id, post_id: @post.id, comment: Fabricate.to_params(:comment, body: nil)
        expect(response).to redirect_to user_post_path(@user, @post)
      end
      it "sets error message" do
        post :create, user_id: @user.id, post_id: @post.id, comment: Fabricate.to_params(:comment, body: nil)
        expect(flash[:error]).to_not be_blank
      end
    end
  end

  describe "DELETE destroy" do
    before do
      @current_user = Fabricate(:user)
      session[:user_id] = @current_user.id
      @user = Fabricate(:user)
      @user2 = Fabricate(:user)
      @post = Fabricate(:post, user: @user)
      @comment = Fabricate(:comment, body: "Hi there", user: @current_user)
    end
    it "requires a loged in user" do
      session[:user_id] = nil
      delete :destroy, user_id: @user.id, post_id: @post.id, id: @comment.id
      expect(response).to redirect_to login_path
    end
    it "deletes comment if current_user is creator" do
      delete :destroy, user_id: @user.id, post_id: @post.id, id: @comment.id
      expect(@current_user.comments.count).to eq(0)
    end
    it "deletes comment if current_user is post creator" do
      session[:user_id] = @user.id
      delete :destroy, user_id: @user.id, post_id: @post.id, id: @comment.id
      expect(@current_user.comments.count).to eq(0)
    end
  end
end

require 'spec_helper'

describe PostsController do
  describe "GET index" do
    before do
      @user = Fabricate(:user)
      session[:user_id] = @user.id
    end
    it "sets @user variable" do
      get :index, user_id: @user.id
      expect(assigns(:user)).to eq(@user)
    end
    it "sets @osts variable" do
      post1 = Post.create(user: @user, title: 'hi', body: 'hello' )
      post2 = Post.create(user: @user, title: 'no', body: 'yes')
      get :index, user_id: @user.id
      expect(assigns(:posts)).to match_array([post1, post2])
    end
    it "requires logged in user" do
      session[:user_id] = nil
      get :index, user_id: @user.id
      expect(response).to redirect_to login_path
    end
  end

  describe "GET show" do
    before do
      @user = Fabricate(:user)
      session[:user_id] = @user.id
      @post = Post.create(user: @user, title: "hi", body: "hello")
    end
    it "sets @user variable" do
      get :show, user_id: @user.id, id: @post.id
      expect(assigns(:user)).to eq(@user)
    end
    it "sets @post variable" do
      get :show, user_id: @user.id, id: @post.id
      expect(assigns(:post)).to eq(@post)
    end
    it "requires logged in user" do
      session[:user_id] = nil
      get :show, user_id: @user.id, id: @post.id
      expect(response).to redirect_to login_path
    end
  end
end

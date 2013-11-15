require 'spec_helper'

describe PostsController do
  describe "GET index" do
    before do
      @user = Fabricate(:user, address: "Coatesville, Pennsylvania")
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
      @user = Fabricate(:user, address: "Coatesville, Pennsylvania")
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

  describe "GET new" do
    before do
      @user = Fabricate(:user, address: 'Coatesville, Pennsylvania')
      session[:user_id] = @user.id
      get :new, user_id: @user.id
    end
    it "requires logged in user" do
      session[:user_id] = nil
      get :new, user_id: @user.id
      expect(response).to redirect_to login_path
    end
    it "sets @user variable" do
      expect(assigns(:user)).to eq(@user)
    end
    it "sets @post variable" do
      expect(assigns(:post)).to be_instance_of(Post)
    end
  end

  describe "POST create" do
    before do
      @user = Fabricate(:user, address: 'Coatesville, Pennsylvania')
      session[:user_id] = @user.id
    end
    it "requires logged in user" do
      session[:user_id] = nil
      post :create, user_id: @user.id, post: Fabricate.to_params(:post)
      expect(response).to redirect_to login_path
    end
    it "sets the @user variable" do
      post :create, user_id: @user.id, post: Fabricate.to_params(:post)
      expect(assigns(:user)).to eq(@user)
    end
    it "creates a post with valid inputs" do
      post :create, user_id: @user.id, post: Fabricate.to_params(:post)
      expect(@user.posts.count).to eq(1)
    end
    it "doesn't create a post with invalid inputs" do
      post :create, user_id: @user.id, post: Fabricate.to_params(:post, body: nil)
      expect(@user.posts.count).to eq(0)
    end
  end

  describe "GET edit" do
    before do
      @user = Fabricate(:user, address: "Coatesville, Pennsylvania")
      session[:user_id] = @user.id
      @post = Post.create(user: @user, title: "hi", body: "hi there")
    end
    it "requires logged in user" do
      session[:user_id] = nil
      get :edit, user_id: @user.id, id: @post.id
      expect(response).to redirect_to login_path
    end
    it "sets @user variable" do
      get :edit, user_id: @user.id, id: @post.id
      expect(assigns(:user)).to eq(@user)
    end
    it "sets @post variable" do
      get :edit, user_id: @user.id, id: @post.id
      expect(assigns(:post)).to eq(@post)
    end
  end

  describe "PUT update" do
    before do
      @user = Fabricate(:user, address: 'Coatesville, Pennsylvania')
      session[:user_id] = @user.id
      @post = Post.create(user: @user, title: "hi", body: "hi there")
    end
    it "requires logged in user" do
      session[:user_id] = nil
      @attr = { title: "new title" }
      put :update, user_id: @user.id, id: @post.id, post: @attr
      expect(response).to redirect_to login_path
    end

    context "with valid inputs" do
      it "updates the post" do
        @attr = { title: "new title" }
        put :update, user_id: @user.id, id: @post.id, post: @attr
        @post.reload
        expect(@post.title).to eq("new title")
      end
      it "sets the flash message" do
        @attr = { title: "new title" }
        put :update, user_id: @user.id, id: @post.id, post: @attr
        @post.reload
        expect(flash[:notice]).to_not be_blank
      end
      it "redirects to the user posts path" do
        @attr = { title: "new title" }
        put :update, user_id: @user.id, id: @post.id, post: @attr
        @post.reload
        expect(response).to redirect_to user_posts_path(@user, @post)
      end
    end

    context "with invalid inputs" do
      it "does not update the post" do
        @attr = { title: nil }
        put :update, user_id: @user.id, id: @post.id, post: @attr
        @post.reload
        expect(@post.title).to eq("hi")
      end
      it "renders the edit page" do
        @attr = { title: nil }
        put :update, user_id: @user.id, id: @post.id, post: @attr
        @post.reload
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE destroy" do
    before do
      @user = Fabricate(:user, address: 'Coatesville, Pennsylvania')
      session[:user_id] = @user.id
      @post = Fabricate(:post, user: @user)
    end
    it "requires logged in user" do
      session[:user_id] = nil
      delete :destroy, user_id: @user.id, id: @post.id
      expect(response).to redirect_to login_path
    end
    it "does not delete post if current user is not post creator" do
      user2 = Fabricate(:user, address: 'Coatesville, Pennsylvania')
      delete :destroy, user_id: user2.id, id: @post.id
      expect(response).to redirect_to home_path
    end
    it "deletes post if current user is post creator" do
      delete :destroy, user_id: @user.id, id: @post.id
      expect(@user.posts.count).to eq(0)
    end
    it "sets the flash message" do
      delete :destroy, user_id: @user.id, id: @post.id
      expect(flash[:notice]).to_not be_blank
    end
    it "redirects to user posts path" do
      delete :destroy, user_id: @user.id, id: @post.id
      expect(response).to redirect_to user_posts_path(@user)
    end
  end
end

require 'spec_helper'

describe UsersController do
  describe "GET index" do
    it "sets @users variable" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      session[:user_id] = user1.id
      get :index
      expect(assigns(:users)).to match_array([user1, user2])
    end
    it "requires logged in user" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      get :index
      expect(response).to redirect_to root_path
    end
  end

  describe "GET new" do
    it "sets the @user variable" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valid input" do
      it "creates a new user" do
        post :create, user: Fabricate.to_params(:user)
        expect(User.count).to eq(1)
      end
      it "redirects to home_path" do
        post :create, user: Fabricate.to_params(:user)
        expect(response).to redirect_to home_path
      end
      it "sets flash message" do
        post :create, user: Fabricate.to_params(:user)
        expect(flash[:notice]).to_not be_blank
      end
    end

    context "with invalid input" do
      it "does not create new user" do
        post :create, user: Fabricate.to_params(:user, password: nil)
        expect(User.count).to eq(0)
      end
      it "renders the new user page" do
        post :create, user: Fabricate.to_params(:user, password: nil)
        expect(response).to render_template :new
      end
    end
  end

  describe "GET show" do
    it "sets the @user variable" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      user_2 = Fabricate(:user, username: "Josh")
      get :show, id: user_2.id
      expect(assigns(:user)).to eq(user_2)
    end
  end
end

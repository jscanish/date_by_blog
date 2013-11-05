require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "redirects to new path if user is logged in" do
      set_current_user
      get :new
      expect(response).to redirect_to root_path
    end
  end

  describe "GET destroy" do
    before { set_current_user }
    it "clears the current session" do
      get :destroy
      expect(session[:user_id]).to eq(nil)
    end
    it "sets the flash message" do
      get :destroy
      expect(flash[:notice]).to_not be_blank
    end
  end

  describe "POST create" do
    context "with valid input" do
      before do
        @user = Fabricate(:user)
        post :create, username: @user.username, password: @user.password
      end
      it "puts the user in the session" do
        expect(session[:user_id]).to eq(@user.id)
      end
      it "redirects to root_path" do
        expect(response).to redirect_to root_path
      end
    end

    context "with invalid input" do
      before do
        @user = Fabricate(:user)
        post :create, username: @user.username, password: @user.password + "abcd"
      end
      it "should not put the user in the session" do
        expect(session[:user_id]).to eq(nil)
      end
      it "sets flash message" do
        expect(flash[:error]).to_not be_blank
      end
      it "redirects to login page" do
        expect(response).to redirect_to login_path
      end
    end
  end
end

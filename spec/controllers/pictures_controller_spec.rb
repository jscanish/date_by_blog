require 'spec_helper'

describe PicturesController do
  before(:each) do
    User.any_instance.stub(:geocode).and_return([1,1])
    @file = fixture_file_upload("ironman3posterfinal.jpg")
  end


  describe "GET new" do
    before { set_current_user}

    it "requires logged in user" do
      session[:user_id] = nil
      get :new
      expect(response).to redirect_to login_path
    end
    it "sets @post instance variable" do
      get :new
      expect(assigns(:picture)).to be_instance_of(Picture)
    end
  end


  describe "POST create" do
    before { set_current_user }

    it "requires logged in user" do
      session[:user_id] = nil
      post :create, picture: Fabricate.to_params(:picture, image: @file)
      expect(response).to redirect_to login_path
    end
    it "sets user variable" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      post :create, picture: Fabricate.to_params(:picture, image: @file)
      expect(assigns(:user)).to eq(user)
    end

    context "with valid input" do
      it "creats picture and adds it to user array" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        post :create, picture: Fabricate.to_params(:picture, image: @file)
        expect(user.pictures.count).to eq(1)
      end
      it "sets the flash message" do
        post :create, picture: Fabricate.to_params(:picture, image: @file)
        expect(flash[:notice]).to_not be_blank
      end
      it "redirects to user_path" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        post :create, picture: Fabricate.to_params(:picture, image: @file)
        expect(response).to redirect_to user_path(user)
      end
    end

    context "with invalid input" do
      it "does not create the picture" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        post :create, picture: Fabricate.to_params(:picture, image: nil)
        expect(user.pictures.count).to eq(0)
      end
      it "renders new template" do
        post :create, picture: Fabricate.to_params(:picture, image: nil)
        expect(response).to render_template(:new)
      end
    end
  end


  describe "GET show" do
    before do
      set_current_user
      @picture = Fabricate(:picture, image: @file)
    end
    it "requires logged in user" do
      session[:user_id] = nil
      get :show, id: @picture.id
      expect(response).to redirect_to login_path
    end
    it "sets picture variable" do
      get :show, id: @picture.id
      expect(assigns(:picture)).to eq(@picture)
    end
  end


  describe "DELETE destroy" do
    before do
      @user = Fabricate(:user)
      session[:user_id] = @user.id
      @picture = Fabricate(:picture, image: @file, user_id: @user.id)
    end

    it "requires logged in user" do
      session[:user_id] = nil
      delete :destroy, id: @picture.id
      expect(response).to redirect_to login_path
    end
    it "delets the picture if picture user is current user" do
      delete :destroy, id: @picture.id
      expect(@user.pictures.count).to eq(0)
    end
    it "redirects to user path if current user is picture user" do
      delete :destroy, id: @picture.id
      expect(response).to redirect_to user_path(@user)
    end
    it "redirects to login path if current user is not picture user" do
      session[:user_id] = Fabricate(:user).id
      delete :destroy, id: @picture.id
      expect(response).to redirect_to login_path
    end
    it "flashes message if current user is not picture user" do
      session[:user_id] = Fabricate(:user).id
      delete :destroy, id: @picture.id
      expect(flash[:notice]).to_not be_blank
    end
  end
end

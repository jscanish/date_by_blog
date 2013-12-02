require 'spec_helper'

describe MessagesController do
  before(:each) do
    User.any_instance.stub(:geocode).and_return([1,1])
  end

  describe "GET index" do
    before do
      @user = Fabricate(:user)
      session[:user_id] = @user.id
      @user2 = Fabricate(:user)
      @message = Fabricate(:message, sender_id: @user.id, receiver_id: @user2.id)
      @message2 = Fabricate(:message, sender_id: @user2.id, receiver_id: @user.id)
      @message3 = Fabricate(:message, sender_id: @user2.id, receiver_id: @user.id)
    end
    it "requires logged in user" do
      session[:user_id] = nil
      get :index
      expect(response).to redirect_to login_path
    end
    it "sets @messages variable" do
      get :index
      expect(assigns(:messages)).to match_array([@message2, @message3])
    end
    it "sets @sent_messages variable" do
      get :index
      expect(assigns(:sent_messages)).to match_array([@message])
    end
  end

  describe "GET show" do
    before do
      @user = Fabricate(:user)
      session[:user_id] = @user.id
      @message = Fabricate(:message, receiver_id: @user.id, unread: true)
    end
    it "requires logged in user" do
      session[:user_id] = nil
      get :show, id: @message.id
      expect(response).to redirect_to login_path
    end
    it "sets @message variable" do
      get :show, id: @message.id
      expect(assigns(:message)).to eq(@message)
    end
    it "sets unread column to false" do
      get :show, id: @message.id
      @message.reload
      expect(@message.unread).to eq(false)
    end
  end

  describe "GET new" do
    before do
      @user = Fabricate(:user)
      session[:user_id] = @user.id
    end
    it "requires logged in user" do
      session[:user_id] = nil
      get :new, user_id: @user.id
      expect(response).to redirect_to login_path
    end
    it "sets @user variable" do
      get :new, user_id: @user.id
      expect(assigns(:user)).to eq(@user)
    end
    it "sets @message variable" do
      get :new, user_id: @user.id
      expect(assigns(:message)).to be_instance_of(Message)
    end
  end

  describe "DELETE destroy" do
    before do
      @user = Fabricate(:user)
      session[:user_id] = @user.id
      @message = Fabricate(:message, receiver_id: @user.id)
    end
    it "requires logged in user" do
      session[:user_id] = nil
      delete :destroy, id: @message.id
      expect(response).to redirect_to login_path
    end
    it "sets @message variable" do
      delete :destroy, id: @message.id
      expect(assigns(:message)).to eq(@message)
    end
    it "deletes message if current_user is message receiver" do
      delete :destroy, id: @message.id
      expect(@user.messages.count).to eq(0)
    end
    it "does not delete message if current_user is not message receiver" do
      user2 = Fabricate(:user)
      session[:user_id] = user2.id
      delete :destroy, id: @message.id
      expect(@user.messages.count).to eq(1)
    end
    it "redirects to messages path" do
      delete :destroy, id: @message.id
      expect(response).to redirect_to messages_path
    end
  end

  describe "POST create" do
    before do
      @current_user = Fabricate(:user)
      session[:user_id] = @current_user.id
      @user = Fabricate(:user)
    end
    it "requires logged in user" do
      session[:user_id] = nil
      post :create, user_id: @user.id, id: Fabricate.to_params(:message)
      expect(response).to redirect_to login_path
    end
    context "with valid inputs" do
      it "creates the message" do
        post :create, user_id: @user.id, message: Fabricate.to_params(:message, receiver: @user, sender: @current_user)
        expect(@user.messages.count).to eq(1)
      end
      it "adds message to current user's sent messages" do
        post :create, user_id: @user.id, message: Fabricate.to_params(:message, receiver: @user, sender: @current_user)
        expect(@current_user.sent_messages.count).to eq(1)
      end
      it "sets the flash message" do
        post :create, user_id: @user.id, message: Fabricate.to_params(:message, receiver: @user, sender: @current_user)
        expect(flash[:notice]).to_not be_blank
      end
      it "redirects to user path" do
        post :create, user_id: @user.id, message: Fabricate.to_params(:message, receiver: @user, sender: @current_user)
        expect(response).to redirect_to user_path(@user)
      end
    end
    context "with invalid inputs" do
      it "renders new message template" do
        post :create, user_id: @user.id, message: Fabricate.to_params(:message, receiver: @user, sender: @current_user, body: nil)
        expect(response).to render_template :new
      end
    end
  end
end

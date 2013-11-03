require 'spec_helper'

describe UsersController do
  describe "GET index" do
    it "sets @users variable" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      get :index
      expect(assigns(:users)).to match_array([user1, user2])
    end
  end


end

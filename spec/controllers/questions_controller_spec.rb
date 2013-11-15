require 'spec_helper'


describe QuestionsController do
  before(:each) do
    User.any_instance.stub(:geocode).and_return([1,1])
  end

  describe "PUT update" do
    it "updates user's questions if user is current user" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      question = Question.create(self_summary: "hi", user: user)
      @attr = { self_summary: "new summary" }
      put :update, id: question.id, user_id: user.id, question: @attr
      question.reload
      expect(question.self_summary).to eq("new summary")
    end
    it "does not update questions for other users" do
      user = Fabricate(:user)
      question = Question.create(self_summary: "hi", user: user)
      @attr = { self_summary: "new summary" }
      put :update, id: question.id, user_id: user.id, question: @attr
      question.reload
      expect(question.self_summary).to eq("hi")
    end
    it "redirects to user path" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      question = Question.create(self_summary: "hi", user: user)
      @attr = { self_summary: "new summary" }
      put :update, id: question.id, user_id: user.id, question: @attr
      question.reload
      expect(response).to redirect_to user_path
    end
  end
end

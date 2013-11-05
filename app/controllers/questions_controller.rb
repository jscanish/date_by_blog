class QuestionsController < ApplicationController
  before_action :require_user
  before_action :set_user, only: [:update]
  before_action :require_creator

  def edit; end

  def update
    @questions = @user.set_of_questions.update_attributes(question_params)
    redirect_to user_path(@user)
  end

  private

  def question_params
    params.require(:question).permit!
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def require_creator
    redirect_to home_path unless logged_in? && current_user == @user
  end

end

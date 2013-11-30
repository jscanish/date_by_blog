class MessagesController < ApplicationController
  before_action :require_user

  def index
    @messages = current_user.messages
  end

  def show
    @message = Message.find(params[:id])
    @message.update_column(:unread, false)
  end

  def new
    @user = User.find(params[:user_id])
    @message = Message.new
  end

  def create
    @user = User.find(params[:user_id])
    @message = Message.new(message_params)

    if @message.save
      @user.messages << @message
      current_user.sent_messages << @message
      flash[:notice] = "Message Sent!"
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.delete if @message.receiver_id == current_user.id
    redirect_to messages_path
  end

  def sent
    @messages = current_user.sent_messages.sort_by(&:created_at).reverse
  end


  private

  def message_params
    params.require(:message).permit(:title, :body, :sender_id, :receiver_id, :unread)
  end
end

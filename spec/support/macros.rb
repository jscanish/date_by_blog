
def set_current_user
  @user = Fabricate(:user, address: "New York")
  session[:user_id] = @user.id
end

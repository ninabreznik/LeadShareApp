class UsersController < ApplicationController
  before_filter :authenticate_user!

  def create
    if @user.save
      # Tell the UserMailer to send a welcome email after save
      UserMailer.welcome_email(user, pass).deliver 
    end
  end

  def show
  end

  def edit
  end

  def index
    @users = User.all
  end

  def destroy
  end

  private

  # def correct_user
  #   @user = User.find_by_id(params[:id])
  #   redirect_to(root_path) unless current_user?(@user)
  # end

end

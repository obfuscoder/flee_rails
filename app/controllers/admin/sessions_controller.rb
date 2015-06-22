module Admin
  class SessionsController < ApplicationController
    def new
      @user = User.new
    end

    def create
      @user = User.new user_params
      if login(@user.email, @user.password)
        redirect_back_or_to admin_path
      else
        flash.now.alert = t('.failure')
        render :new
      end
    end

    private

    def user_params
      params.require(:user).permit :email, :password
    end
  end
end

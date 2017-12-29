# frozen_string_literal: true

module Admin
  class SessionsController < ApplicationController
    def new
      @user = User.new
    end

    def create
      @user = User.new user_params
      user = login(@user.email, @user.password)
      if user && user.client == current_client
        redirect_back_or_to admin_path
      else
        logout if user
        flash.now.alert = t('.failure')
        render :new
      end
    end

    def destroy
      logout
      redirect_to root_path, notice: t('.success')
    end

    private

    def user_params
      params.require(:user).permit :email, :password
    end
  end
end

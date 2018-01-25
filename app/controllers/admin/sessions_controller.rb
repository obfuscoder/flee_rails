# frozen_string_literal: true

module Admin
  class SessionsController < ApplicationController
    def new
      if current_client.users.nil?
        redirect_to pages_index_path
      else
        @user = current_client.users.build
      end
    end

    def create
      @user = current_client.users.build user_params
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

module Admin
  class ResetPasswordsController < ApplicationController
    def new; end

    def create
      @email = create_params[:email]
      user = current_client.users.find_by email: @email
      if user.nil?
        redirect_to new_admin_reset_password_path, alert: t('.unknown_email', email: @email)
      else
        user.generate_reset_password_token!
        password_reset_url = admin_reset_password_edit_url(user.reset_password_token)
        NotificationMailer.reset_password_instructions(user, password_reset_url).deliver_now
        redirect_to admin_login_path, notice: t('.success', email: @email)
      end
    end

    def edit
      @token = params[:token]
      @user = current_client.users.load_from_reset_password_token(@token)
      redirect_to admin_login_path, alert: t('.unknown_token') if @user.nil?
    end

    def update
      @token = params[:token]
      @user = current_client.users.load_from_reset_password_token(@token)
      if @user.nil?
        redirect_to admin_login_path, alert: t('.unknown_token')
      else
        @user.reset_password_token = nil
        @user.assign_attributes(update_params)
        if @user.save(context: :reset_password)
          redirect_to admin_login_path, notice: t('.success', email: @user.email)
        else
          render :edit
        end
      end
    end

    private

    def create_params
      params.require(:reset_password).permit(:email)
    end

    def update_params
      params.require(:user).permit(:token, :password, :password_confirmation)
    end
  end
end

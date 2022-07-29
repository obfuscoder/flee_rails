module Admin
  class UsersController < AdminController
    def edit
      @user = current_user
    end

    def update
      @user = current_user
      @user.assign_attributes(user_params)
      if @user.save(context: :change_password)
        redirect_to admin_path, notice: t('.success')
      else
        render :edit
      end
    end

    private

    def user_params
      params.require(:user).permit :old_password, :password, :password_confirmation
    end
  end
end

module Admin
  class UsersController < AdminController
    def index
      @users = current_client.users.search(params[:search]).page(@page).order(column_order)
    end

    def new
      @user = current_client.users.build
    end

    def create
      @user = current_client.users.build user_params
      @user.password = password = GeneratePassword.execute
      if @user.save
        NotificationMailer.user_created(@user, password).deliver_now
        redirect_to admin_users_path, notice: t('.success', user: @user, email: @user.email)
      else
        render :new
      end
    end

    def edit
      @user = current_client.users.find params[:id]
    end

    def update
      @user = current_client.users.find params[:id]
      if @user.update user_params
        redirect_to admin_users_path, notice: t('.success', user: @user)
      else
        render :edit
      end
    end

    def show
      @user = current_client.users.find params[:id]
    end

    def destroy
      if current_client.users.find(params[:id]).destroy
        redirect_to admin_users_path, notice: t('.success')
      else
        redirect_to admin_users_path, alert: t('.failure')
      end
    end

    def searchable?
      action_name == 'index'
    end

    private

    def user_params
      params.require(:user).permit :name, :email
    end
  end
end

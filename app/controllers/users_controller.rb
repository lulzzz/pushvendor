class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource

  def index
    @users = User.paginate(page: params[:page], per_page: 20)
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = 'User was successfully created.'
      redirect_to @user
    else
      render action: 'new'
    end
  end

  def new_user
    @user = User.new(email: params[:user][:email],
                     username: params[:user][:username],
                     password: params[:user][:password],
                     password_confirmation: params[:user][:password_confirmation])

    if @user.save
      flash[:notice] = 'User was successfully created.'
      redirect_to @user
    else
      render action: 'new'
    end
  end

  def update
    if user_params[:password].blank?
      user_params.delete('password')
      user_params.delete('password_confirmation')
    end

    if @user.update(user_params)
      flash[:notice] = 'User was successfully updated.'
      redirect_to @user
    else
      render action: 'edit'
    end
  end

  def destroy
    if @user.id == 1
      flash[:notice] = "You can't delete the main administrator!"
      redirect_to users_url
    else
      @user.destroy
      redirect_to users_url
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:email,
                                 :username,
                                 :password,
                                 :password_confirmation,
                                 :remember_me,
                                 :can_update_users,
                                 :can_update_items,
                                 :can_update_configuration,
                                 :can_view_reports,
                                 :can_update_sale_discount,
                                 :can_remove_sales)
  end
end

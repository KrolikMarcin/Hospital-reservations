class Admin::UsersController < ApplicationController
  before_action :admin_only

  def index
    @users = if params[:role]
               User.send(params[:role].to_sym)
             else
               User.all.order(:roles)
             end
  end

  def show
    @user = User.find(params[:id])
  end

  def change_role
    @user = User.find(params[:user_id])
    @user.update(roles: 'admin', specialization: nil)
    redirect_to admin_user_path(@user)
  end

  def destroy
    @user = User.find(params[:id])
    redirect_to admin_users_path
  end
end

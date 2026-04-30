class UsersController < ApplicationController
  before_action :redirect_if_authenticated

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Welcome, #{@user.name}!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def redirect_if_authenticated
    redirect_to root_path if logged_in?
  end

  def user_params
    params.expect(user: [ :name, :email, :password, :password_confirmation ])
  end
end

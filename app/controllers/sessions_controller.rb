class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [ :new, :create ]

  def new; end

  def create
    user = User.find_by(email: params[:email].to_s.strip.downcase)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, status: :see_other, notice: "Welcome back, #{user.name}!"
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to new_session_path, status: :see_other, notice: "You have been logged out."
  end

  private

  def redirect_if_authenticated
    redirect_to root_path, status: :see_other if logged_in?
  end
end

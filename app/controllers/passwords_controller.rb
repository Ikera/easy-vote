class PasswordsController < ApplicationController
  before_action :set_user_from_token, only: [ :edit, :update ]

  def new; end

  def create
    if (user = User.find_by(email: params[:email].to_s.strip.downcase))
      PasswordsMailer.with(user: user).reset.deliver_later
    end

    redirect_to new_session_path, notice: "If your email exists in our system, you will receive reset instructions shortly."
  end

  def edit; end

  def update
    if @user.update(password_params)
      reset_session
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Your password has been updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def password_params
    params.expect(user: [ :password, :password_confirmation ])
  end

  def set_user_from_token
    @user = User.find_by_password_reset_token!(params[:token])
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to new_password_reset_path, alert: "Password reset link is invalid or has expired."
  end
end

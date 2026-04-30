class PasswordsMailer < ApplicationMailer
  def reset
    @user = params[:user]
    @token = @user.password_reset_token

    mail subject: "Reset your Easy Vote password", to: @user.email
  end
end

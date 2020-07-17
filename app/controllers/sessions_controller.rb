class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      log_in user
      flash[:success] = t "users.success_user"
      redirect_to user
    else
      flash.now[:danger] = t "users.invalid_user"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end

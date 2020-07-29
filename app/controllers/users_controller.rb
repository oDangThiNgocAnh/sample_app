class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new show create)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.page(params[:page]).per Settings.user.per_page
  end

  def new
    @user = User.new
  end

  def show
    @microposts = @user.microposts.page(params[:page])
                         .per Settings.user.per_page
    end
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "users.mailer.check_email"
      redirect_to root_url
    else
      flash[:danger] = t "users.error_signup"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "users.profile_update"
      redirect_to @user
    else
      flash[:danger] = t "users.error_edit"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.destroy_success"
      redirect_to users_url
    else
      flash[:danger] = t "users.destroy_success"
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end

  def correct_user
    return if current_user? @user

    flash[:warning] = t "users.not_correct", id: params[:id]
    redirect_to root_url
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.notfound", id: params[:id]
    redirect_to root_path
  end
end

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin, only: %i[index edit update destroy]
  before_action :set_user, only: %i[edit update destroy]
  before_action :set_roles, only: %i[edit update]

  def index
    @users = User.all
  end

  def destroy
    @user = User.find(params[:id])

    if @user.destroy
      redirect_to users_path, notice: 'Das Profil wurde erfolgreich gelöscht.'
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
      redirect_to users_path
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: 'Das Profil wurde erfolgreich bearbeitet.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # This method sets the @user variable for edit, update, and destroy actions
  def set_roles
    @roles = [['Expert*in', 'expert'], ['Standard', 'user'], ['Admin', 'admin']]
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :role)
  end
end

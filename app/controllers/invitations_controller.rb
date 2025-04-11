class InvitationsController < ApplicationController
  before_action :ensure_admin, only: %i[new create]
  before_action :validate_invitation_token, only: %i[sign_up create_user]

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.expires_at = 2.weeks.from_now
    @invitation.used = false

    if @invitation.save
      UserMailer.onetime_link(@invitation.email, sign_up_with_token_url(@invitation.token)).deliver_later
      redirect_back fallback_location: users_path,
                    notice: I18n.t('users.notice.token_created') + ": #{sign_up_with_token_url(@invitation.token)}"
    else
      redirect_back fallback_location: users_path, notice: I18n.t('users.errors.token_create_fail')
    end
  end

  def sign_up
    if @invitation.used? || @invitation.expired?
      redirect_to root_path, alert: I18n.t('users.errors.expired_token')
    else
      @user = User.new(email: @invitation.email)
    end
  end

  # Create user and mark invitation as used
  def create_user
    @user = User.new(user_params)
    @user.email = @invitation.email

    # Check if there is an expert with the same email
    existing_expert = Expert.find_by(email: @user.email)

    if existing_expert
      @user.expert = existing_expert
      @user.initiated = true
    end

    if @user.save
      @invitation.update(used: true)
      UserMailer.welcome_email(@user.email).deliver_later
      redirect_to root_path, notice: I18n.t('users.notice.register_success')
    else
      render :sign_up
    end
  end

  private

  def validate_invitation_token
    @invitation = Invitation.find_by(token: params[:token])

    if @invitation.nil?
      redirect_to root_path, alert: I18n.t('users.errors.invalid_token')
    elsif @invitation.expired? || @invitation.used?
      redirect_to root_path, alert: I18n.t('users.errors.expired_token')
    end
  end

  def invitation_params
    params.require(:invitation).permit(:email)
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end

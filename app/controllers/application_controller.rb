class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def ensure_admin
    return if current_user&.role == 'admin'

    if current_user&.role == 'expert'
      redirect_to '/experts/me', alert: 'Sie haben nicht die nötige Berechtigung, um auf diese Seite zuzugreifen.'
    else
      redirect_to '/experts', alert: 'Sie haben nicht die nötige Berechtigung, um auf diese Seite zuzugreifen.'
    end
  end

  def ensure_staff
    # Allow access only to users with roles: admin or user
    return if current_user.present? && %w[admin user].include?(current_user.role)

    redirect_to '/experts/me', alert: 'Sie haben nicht die nötige Berechtigung, um auf diese Seite zuzugreifen.'
  end
end

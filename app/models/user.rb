class User < ApplicationRecord
  before_destroy :ensure_another_admin_exists, if: -> { admin? }
  before_update :ensure_another_admin_exists_for_role_change, if: :will_save_change_to_role?
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  belongs_to :expert, optional: true

  validates :email, presence: { message: I18n.t('users.errors.email_missing') }
  validates :password, length: { minimum: 6, message: I18n.t('users.errors.password_too_short') }, if: lambda {
    password.present?
  }
  validates :password, presence: { message: I18n.t('users.errors.password_missing') }, if: :password_required?

  enum :role, %i[expert user admin]
  after_initialize :set_default_role, if: :new_record?

  belongs_to :expert, optional: true

  def set_default_role
    self.role ||= 'expert'
  end

  private

  def password_required?
    new_record? || changes[:encrypted_password].present?
  end

  def ensure_another_admin_exists
    return unless User.admin.count <= 1

    errors.add(:base, I18n.t('users.errors.delete_last_admin'))
    throw(:abort)
  end

  def ensure_another_admin_exists_for_role_change
    return unless role_change.first == 'admin' && role_change.last != 'admin' && User.admin.count <= 1

    errors.add(:base, I18n.t('users.errors.change_last_admin'))
    throw(:abort)
  end
end

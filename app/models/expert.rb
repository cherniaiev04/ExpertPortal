class Expert < ApplicationRecord
  before_destroy :reset_users_associations

  validates :salutation, presence: { message: I18n.t('experts.errors.salutation_missing') }
  validates :name, presence: { message: I18n.t('experts.errors.name_missing') }
  validates :firstname, presence: { message: I18n.t('experts.errors.firstname_missing') }
  validates :email, presence: { message: I18n.t('experts.errors.email_missing') }
  validates :telephone, presence: { message: I18n.t('experts.errors.telephone_missing') }

  # institution check
  validates :institution_bool, inclusion: {
    in: [true, false],
    message: I18n.t("experts.errors.institution_bool_missing")
  }
  validates :institution, presence: {
    message: I18n.t("experts.errors.institution_missing")
  }, if: :institution_bool?

  has_one_attached :cv
  has_many_attached :certificates
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :course_modules
  has_and_belongs_to_many :projects

  validate :must_have_at_least_one_category

  has_many :users

  private

  def must_have_at_least_one_category
    return unless categories.empty?

    errors.add(:categories, I18n.t('experts.errors.category_missing'))
  end

  def reset_users_associations
    users.update_all(expert_id: nil, initiated: false)
  end
end

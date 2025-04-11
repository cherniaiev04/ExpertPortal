class CourseModule < ApplicationRecord
   validates :name, presence: { message: I18n.t('course_modules.errors.name_missing') },
                   uniqueness: { message: I18n.t('course_modules.errors.name_not_unique') }

   has_and_belongs_to_many :experts

  # soft delete (still displayed on "legacy" experts)
  # use Category.active instead of .all
  scope :active, -> { where(deleted_at: nil) }
  scope :archived, -> { where.not(deleted_at: nil) }

  def soft_delete
   update(deleted_at: Time.current)
  end

  def deleted?
   deleted_at.present?
  end
end
  
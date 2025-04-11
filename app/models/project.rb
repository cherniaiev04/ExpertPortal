class Project < ApplicationRecord
  VALID_DATE_REGEX = /\A(\d{4}-\d{2}-\d{2}|(\d{2}\/\d{2}\/\d{4})|(\d{2}-\d{2}-\d{4})|(\d{1,2}\.\d{1,2}\.\d{4})|(\d{1,2} \w+ \d{4})|(\w+ \d{1,2}, \d{4})|(\d{4} \w+ \d{1,2} \d{1,2}))\z/

  validate :end_date_after_start_date
  serialize :location, coder: YAML
  serialize :key_topics, coder: YAML
  serialize :project_type, coder: YAML
  validates :name, presence: { message: I18n.t("projects.messages.name_blank") }, length: { maximum: 255 }

  has_and_belongs_to_many :experts

  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    if time_period_end.present? && time_period_start.present? && time_period_end < time_period_start
      errors.add(:time_period_end, I18n.t("projects.messages.end_date_before_start_date"))
    end
  end
end

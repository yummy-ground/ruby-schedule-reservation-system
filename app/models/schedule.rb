class Schedule < ApplicationRecord
  PERSONNEL_LIMIT = 50_000
  belongs_to :user

  validates :personnel, presence: true, numericality: { only_integer: true }
  validates :start_datetime, presence: true
  validates :end_datetime, presence: true
  validates :is_confirm, inclusion: { in: [ true, false ] }

  validate :verify_personnel
  validate :verify_start_datetime
  validate :verify_end_datetime

  private

  def verify_personnel
    if personnel.present? && personnel > PERSONNEL_LIMIT
      errors.add(:personnel, "can't be bigger than 50,000")
    end
  end

  def verify_start_datetime
    if start_datetime.present? && Time.now + 3.days > start_datetime.to_time
      errors.add(:start_datetime, "can't be before the last 3 days")
    end
  end

  def verify_end_datetime
    if end_datetime <= start_datetime
      errors.add(:end_datetime, "can't be after the start date")
    end
  end
end

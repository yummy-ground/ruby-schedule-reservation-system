class Schedule < ApplicationRecord
  PERSONNEL_LIMIT = 50_000
  belongs_to :user

  scope :confirmed, -> { where(is_confirm: true) }
  scope :unconfirmed, -> { where(is_confirm: false) }

  validates :name, presence: true
  validates :personnel, presence: true, numericality: { only_integer: true, less_than_or_equal_to: PERSONNEL_LIMIT }
  validates :start_datetime, presence: true
  validates :end_datetime, presence: true
  validates :is_confirm, inclusion: { in: [ true, false ] }

  validate :verify_start_datetime
  validate :verify_end_datetime

  # attr_reader :id, :name, :user_id, :personnel, :start_datetime, :end_datetime, :is_confirm

  def is_owner?(user_id)
    self.user_id.eql? user_id
  end

  def start_at
    self.start_datetime.strftime("%Y-%m-%d %H:%M:%S")
  end
  def end_at
    self.end_datetime.strftime("%Y-%m-%d %H:%M:%S")
  end

  private

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

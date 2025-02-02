class User < ApplicationRecord
  has_many :schedules, dependent: :destroy

  validates :role, presence: true, inclusion: { in: [ "user", "admin" ] }
end

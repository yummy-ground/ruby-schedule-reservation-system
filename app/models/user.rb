class User < ApplicationRecord
  has_many :schedules, dependent: :destroy
  enum :role, { user: "user", admin: "admin" }

  validates :role, presence: true, inclusion: { in: [ "user", "admin" ] }
end

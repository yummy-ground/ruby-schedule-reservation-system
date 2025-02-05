class User < ApplicationRecord
  has_many :schedules, dependent: :destroy
  enum :role, { user: "user", admin: "admin" }
  # enum role, [ :user, :admin ], instance_method: true
  #
  # enum("user", :user)
  # enum("admin", :admin)

  validates :role, presence: true, inclusion: { in: [ "user", "admin" ] }
end

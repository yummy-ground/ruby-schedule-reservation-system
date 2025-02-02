# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.create!([
    { id: 1, role: "user" },
    { id: 2, role: "admin" },
    { id: 3, role: "user" },
    { id: 4, role: "user" }
])
puts "Insert user dummy data successfully"

Schedule.create!([
    { id: 1, user_id: 1, personnel: 10000, start_datetime: "2025-02-23 10:00:00", end_datetime: "2025-02-23 16:00:00", is_confirm: true  },
    { id: 2, user_id: 1, personnel: 10000, start_datetime: "2025-02-23 12:00:00", end_datetime: "2025-02-23 18:00:00", is_confirm: false  },
    { id: 3, user_id: 1, personnel: 10000, start_datetime: "2025-02-23 14:00:00", end_datetime: "2025-02-23 18:00:00", is_confirm: true  },
    { id: 4, user_id: 3, personnel: 10000, start_datetime: "2025-02-22 10:00:00", end_datetime: "2025-02-22 12:00:00", is_confirm: false  },
    { id: 5, user_id: 3, personnel: 10000, start_datetime: "2025-02-23 18:00:00", end_datetime: "2025-02-24 10:00:00", is_confirm: true  },
    { id: 6, user_id: 3, personnel: 10000, start_datetime: "2025-02-24 08:00:00", end_datetime: "2025-02-24 16:00:00", is_confirm: false  },
    { id: 7, user_id: 4, personnel: 10000, start_datetime: "2025-02-22 10:00:00", end_datetime: "2025-02-23 10:00:00", is_confirm: true  },
    { id: 8, user_id: 4, personnel: 10000, start_datetime: "2025-02-23 10:00:00", end_datetime: "2025-02-24 10:00:00", is_confirm: false  },
    { id: 9, user_id: 4, personnel: 10000, start_datetime: "2025-02-24 10:00:00", end_datetime: "2025-02-25 10:00:00", is_confirm: true  }
])
puts "Insert schedule dummy data successfully"

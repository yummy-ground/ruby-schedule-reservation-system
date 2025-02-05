if User.table_exists?
  puts "> User table already exists"
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE users RESTART IDENTITY CASCADE")
  puts "> User table truncate succeeded"
  puts ""
end
if Schedule.table_exists?
  puts "> Schedule table already exists"
  ActiveRecord::Base.connection.execute("TRUNCATE TABLE schedules RESTART IDENTITY CASCADE")
  puts "> Schedule table truncate succeeded"
  puts ""
end


User.create!([
               { id: 1, role: "user" },
               { id: 2, role: "admin" },
               { id: 3, role: "user" },
               { id: 4, role: "user" }
             ])
puts "> User dummy data insert succeeded"

Schedule.create!([
                   { id: 1, user_id: 1, personnel: 10000, start_datetime: "2025-02-23 10:00:00", end_datetime: "2025-02-23 16:00:00", is_confirm: true, name: "User 1 - Schedule 1" },
                   { id: 2, user_id: 1, personnel: 10000, start_datetime: "2025-02-23 12:00:00", end_datetime: "2025-02-23 18:00:00", is_confirm: false, name: "User 1 - Schedule 2" },
                   { id: 3, user_id: 1, personnel: 10000, start_datetime: "2025-02-23 14:00:00", end_datetime: "2025-02-23 18:00:00", is_confirm: true, name: "User 1 - Schedule 3" },
                   { id: 4, user_id: 3, personnel: 10000, start_datetime: "2025-02-22 10:00:00", end_datetime: "2025-02-22 12:00:00", is_confirm: false, name: "User 3 - Schedule 1" },
                   { id: 5, user_id: 3, personnel: 10000, start_datetime: "2025-02-23 18:00:00", end_datetime: "2025-02-24 10:00:00", is_confirm: true, name: "User 3 - Schedule 2" },
                   { id: 6, user_id: 3, personnel: 10000, start_datetime: "2025-02-24 08:00:00", end_datetime: "2025-02-24 16:00:00", is_confirm: false, name: "User 3 - Schedule 3" },
                   { id: 7, user_id: 4, personnel: 10000, start_datetime: "2025-02-22 10:00:00", end_datetime: "2025-02-23 10:00:00", is_confirm: true, name: "User 4 - Schedule 1" },
                   { id: 8, user_id: 4, personnel: 10000, start_datetime: "2025-02-23 10:00:00", end_datetime: "2025-02-24 10:00:00", is_confirm: false, name: "User 4 - Schedule 2" },
                   { id: 9, user_id: 4, personnel: 10000, start_datetime: "2025-02-24 10:00:00", end_datetime: "2025-02-25 10:00:00", is_confirm: true, name: "User 4 - Schedule 3" },
                 ])
puts "> Schedule dummy data insert succeeded"
puts ""

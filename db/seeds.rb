require "jwt"

def generate_static_jwt(user_id, role)
  payload = {
    id: user_id,
    role: role,
    iat: Time.now.to_i,
    exp: Time.now.to_i + (24 * 60 * 60)
  }
  secret = ENV["JWT_SECRET"]
  JWT.encode(payload, secret, 'HS256')
end

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
puts "> Schedule dummy data insert succeeded"
puts ""

puts "> User (user_id 1) JWT : #{generate_static_jwt(1, "user")}"
puts "> Admin (user_id 2) JWT : #{generate_static_jwt(2, "admin")}"
puts ""

namespace :jwt do
  desc "Generate a static JWT token"
  task generate_for_user: :environment do
    puts "> User (user_id 1) JWT : #{generate_static_jwt(1, "user")}"
  end
  task generate_for_admin: :environment do
    puts "> Admin (user_id 2) JWT : #{generate_static_jwt(2, "admin")}"
  end

  private
  def generate_static_jwt(user_id, role)
    # require "jwt"
    payload = {
      id: user_id,
      role: role,
      iat: Time.now.to_i,
      exp: Time.now.to_i + (24 * 60 * 60)
    }
    secret = ENV["JWT_SECRET"]
    JWT.encode(payload, secret, "HS256")
  end
end

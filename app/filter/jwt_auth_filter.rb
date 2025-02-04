# frozen_string_literal: true

class JwtAuthFilter
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    token = request.get_header("Authorization")&.split(" ")&.last

    if token.nil?
      return [ 400, { "Content-Type" => "application/json" }, [ { error: "Token missing" }.to_json ] ]
    else
      begin
        validate_jwt(env, token)
      rescue JWT::ExpiredSignature => e
        return [ 401, { "Content-Type" => "application/json" }, [ { error: "Invalid token" }.to_json ] ]
      end
    end
    @app.call(env)
  end

  private
  def validate_jwt(env, token)
    payload, = JWT.decode(token, ENV["JWT_SECRET"], true, { algorithm: "HS256" })
    env["user_id"] = payload["user_id"]
    env["user_role"] = payload["role"]
  end
end

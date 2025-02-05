require_relative "../code/failure"
require_relative "../utils/base_response"

class JwtAuthFilter
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    token = request.get_header("HTTP_AUTHORIZATION")&.split(" ")&.last

    unless request.url.include? "/api-docs"
      if token.nil?
        return [
          Failure::NO_TOKEN_IN_HEADER.status_code,
          { "Content-Type" => "application/json" },
          [ BaseResponse.of_failure(Failure::NO_TOKEN_IN_HEADER).to_json ]
        ]
      else
        begin
          validate_jwt(env, token)
        rescue JWT::ExpiredSignature => e
          return [
            Failure::INVALID_TOKEN_IN_HEADER.status_code,
            { "Content-Type" => "application/json" },
            [ BaseResponse.of_failure(Failure::INVALID_TOKEN_IN_HEADER).to_json ]
          ]
        end
      end
    end
    @app.call(env)
  end

  private
  def validate_jwt(env, token)
    payload, = JWT.decode(token, ENV["JWT_SECRET"], true, { algorithm: "HS256" })
    env["user_id"] = payload["id"]
    env["user_role"] = payload["role"]
  end
end

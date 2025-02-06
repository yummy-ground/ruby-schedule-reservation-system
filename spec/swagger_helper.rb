require "rails_helper"

RSpec.configure do |config|
  config.openapi_root = Rails.root.join("swagger").to_s

  config.openapi_specs = {
    "v1/swagger.yaml" => {
      openapi: "3.0.1",
      info: {
        title: "시험 일정 예약 시스템 API",
        description: "고객과 어드민이 각각의 필요에 맞게 시험 일정 예약을 처리할 수 있는 <strong>일정 예약 시스템 API</strong>입니다.</br>콘솔창에 발급받은 권한별 토큰을 활용해주세요.",
        version: "v1"
      },
      components: {
        securitySchemes: {
          bearer_auth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: "JWT"
          }
        }
      },
      security: {
        Bearer: {}
      },
      paths: {},
      servers: [
        {
          url: "http://{defaultDNSLocalHost}",
          variables: {
            defaultDNSLocalHost: {
              default: "localhost:8080"
            }
          }
        },
        {
          url: "http://{defaultLocalHost}",
          variables: {
            defaultLocalHost: {
              default: "127.0.0.1:8080"
            }
          }
        }
      ]
    }
  }

  config.openapi_format = :yaml

end

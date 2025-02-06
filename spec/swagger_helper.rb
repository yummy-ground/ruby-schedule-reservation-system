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
        },
        schemas: {
          errors_object: {
            type: :object,
            properties: {
              message: { type: :string },
              data: {  type: :nil }
            }
          },
          schedule_content: {
            type: :object,
            properties: {
              name: { type: :string },
              start_at: { type: :string, format: "%Y-%m-%d %H:%M" },
              end_datetime: { type: :string, format: "%Y-%m-%d %H:%M" },
              personnel: { type: :integer, required: true }
            },
            required: %w[name start_at end_at personnel]
          },
          schedule_availables: {
            type: :object,
            properties: {
              message: { type: :string },
              data: {
                type: :object,
                properties: {
                  available: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        date: { type: :string, format: "%Y-%m-%d" },
                        time: { type: :string, format: "%H" },
                        personnel: { type: :integer }
                      }
                    }
                  }
                }
              }
            }
          },
          schedules: {
            type: :object,
            properties: {
              message: { type: :string },
              data: {
                type: :object,
                properties: {
                  schedules: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        id: { type: :integer },
                        name: { type: :string },
                        start_at: { type: :string, format: "%Y-%m-%d %H:%M" },
                        end_at: { type: :string, format: "%Y-%m-%d %H:%M" },
                        is_confirmed: { type: :boolean }
                      }
                    }
                  }
                }
              }
            }
          },
          schedule: {
            type: :object,
            properties: {
              message: { type: :string },
              data: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  user_id: { type: :integer },
                  name: { type: :string },
                  personnel: { type: :integer },
                  start_at: { type: :string, format: "%Y-%m-%d %H:%M" },
                  end_at: { type: :string, format: "%Y-%m-%d %H:%M" },
                  is_confirmed: { type: :boolean }
                }
              }
            }
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

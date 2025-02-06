require 'swagger_helper'
require_relative "../../app/controllers/code/failure"

describe "Schedules API", type: :request do
  path "/schedules" do
    get "예약 전체 조회" do
      tags "Schedules"
      security [ bearer_auth: [] ]
      produces "application/json"

      response "200", "Success" do
        schema "$ref" => "#/components/schemas/schedules"
        let(:Authorization) { "Bearer #{SwaggerAuthHelper.get_token}" }
        run_test!
      end
      response "400", "Bad Request - No Token" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "401", "Not authorized" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "404", "Not found User" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
    end

    post "예약 생성" do
      tags "Schedules"
      security [ bearer_auth: [] ]
      consumes 'application/json'
      produces "application/json"
      parameter name: :schedule, in: :body, schema: { '$ref' => '#/components/schemas/schedule_content' }

      response "201", "Success" do
        schema "$ref" => "#/components/schemas/schedule"
        let(:Authorization) { "Bearer #{SwaggerAuthHelper.get_token}" }
        run_test!
      end
      response "400", "Bad Request - No Token" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "400", "Bad Request - Invalid Parameter" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "401", "Not authorized" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "404", "Not found User" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
    end
  end

  path "/schedules/available" do
    get "예약 가능 시간대 & 인원수 조회" do
      tags "Schedules"
      security [ bearer_auth: [] ]
      produces "application/json"
      parameter name: :target_month, in: :query, schema: { type: :string, format: "yyyy-MM", example: "2025-02" }

      response "200", "Success" do
        schema "$ref" => "#/components/schemas/schedule_availables"
        let(:Authorization) { "Bearer #{SwaggerAuthHelper.get_token}" }
        run_test!
      end
      response "400", "Bad Request - No Token" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "401", "Not authorized" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "404", "Not found User" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
    end
  end

  path "/schedules/{id}" do
    get "예약 상세 조회" do
      tags "Schedules"
      security [ bearer_auth: [] ]
      produces "application/json"
      parameter name: :id, in: :path, type: :integer

      response "200", "Success" do
        schema "$ref" => "#/components/schemas/schedule"
        let(:Authorization) { "Bearer #{SwaggerAuthHelper.get_token}" }
        run_test!
      end
      response "400", "Bad Request - No Token" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "401", "Not authorized" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "404", "Not found User" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "404", "Not found Schedule" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
    end

    put "예약 수정" do
      tags "Schedules"
      security [ bearer_auth: [] ]
      produces "application/json"
      parameter name: :id, in: :path, type: :integer
      parameter name: :schedule, in: :body, schema: { '$ref' => '#/components/schemas/schedule_content' }

      response "204", "Success" do
        let(:Authorization) { "Bearer #{SwaggerAuthHelper.get_token}" }
        run_test!
      end
      response "400", "Bad Request - No Token" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "400", "Bad Request - Invalid Parameter" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "400", "Bad Request - Already Confirm" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "401", "Not authorized" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "403", "No Permission (No Admin && No Owner)" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "404", "Not found User" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "404", "Not found Schedule" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
    end

    delete "예약 삭제" do
      tags "Schedules"
      security [ bearer_auth: [] ]
      produces "application/json"
      parameter name: :id, in: :path, type: :integer

      response "204", "Success" do
        let(:Authorization) { "Bearer #{SwaggerAuthHelper.get_token}" }
        run_test!
      end
      response "400", "Bad Request - No Token" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "400", "Bad Request - Already Confirm" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "401", "Not authorized" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "403", "No Permission (No Admin && No Owner)" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "404", "Not found User" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "404", "Not found Schedule" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
    end
  end

  path "/schedules/{id}/confirm" do
    patch "예약 확정" do
      tags "Schedules"
      security [ bearer_auth: [] ]
      produces "application/json"
      parameter name: :id, in: :path, type: :integer

      response "204", "Success" do
        let(:Authorization) { "Bearer #{SwaggerAuthHelper.get_token}" }
        run_test!
      end
      response "400", "Bad Request - No Token" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end

      response "401", "Not authorized" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "403", "No Permission (No Admin)" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "404", "Not found User" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
      response "404", "Not found Schedule" do
        schema "$ref" => "#/components/schemas/errors_object"
        run_test!
      end
    end
  end
end

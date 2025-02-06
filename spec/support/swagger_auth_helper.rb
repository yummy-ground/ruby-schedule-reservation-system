# frozen_string_literal: true

module SwaggerAuthHelper
  def self.get_token
    OpenStruct.new(Rails.application.credentials[:swagger_auth] || {}).token
  end
end

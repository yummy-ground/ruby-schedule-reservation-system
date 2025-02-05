class BaseResponse
  attr_reader :message, :data
  def self.of_failure(failure, data = nil)
    new(message: failure.message, data: data)
  end
  def self.of_success(success, data = nil)
    new(message: success.message, data: data)
  end

  def initialize(message:, data: nil)
    @message = message
    @data = data
  end

  def to_json(*_args)
    { message: @message, data: @data }.to_json
  end
end

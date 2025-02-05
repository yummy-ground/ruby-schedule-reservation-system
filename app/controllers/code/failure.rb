
FailureData = Struct.new(:status_code, :message, keyword_init: true)
module Failure
  # 400
  NO_TOKEN_IN_HEADER = FailureData.new(status_code: 400, message: "인증 토큰이 없습니다.")

  # 401
  INVALID_TOKEN_IN_HEADER =  FailureData.new(status_code: 400, message: "인증 토큰이 유효하지 않습니다.")

  # 403
  NO_PERMISSION_CONFIRM =  FailureData.new(status_code: 403, message: "예약 확정 권한이 없습니다.")

  # 404
  NOT_FOUND_USER =  FailureData.new(status_code: 404, message: "해당 유저를 찾을 수 없습니다.")
end


FailureData = Struct.new(:status_code, :message, keyword_init: true)

module Failure
  # 400
  NO_TOKEN_IN_HEADER = FailureData.new(status_code: 400, message: "인증 토큰이 없습니다.")
  INVALID_PARAMETER = FailureData.new(status_code: 400, message: "잘못된 파라미터 값입니다.")
  IMPOSSIBLE_CREATE_TOO_LATE = FailureData.new(status_code: 400, message: "시작 전 3일 이내에는 예약이 불가능합니다.")
  IMPOSSIBLE_UPDATE_NOT_OWNER = FailureData.new(status_code: 400, message: "다른 사용자의 예약 수정은 불가능합니다.")
  IMPOSSIBLE_DELETE_NOT_OWNER = FailureData.new(status_code: 400, message: "다른 사용자의 예약 삭제는 불가능합니다.")
  IMPOSSIBLE_UPDATE_ALREADY_CONFIRM = FailureData.new(status_code: 400, message: "이미 확정된 예약은 수정이 불가능합니다.")
  IMPOSSIBLE_DELETE_ALREADY_CONFIRM = FailureData.new(status_code: 400, message: "이미 확정된 예약은 삭제가 불가능합니다.")
  OVER_PERSONNEL_TO_RESERVE = FailureData.new(status_code: 400, message: "최대 인원 초과로 예약이 불가능합니다.")
  OVER_PERSONNEL_TO_CONFIRM = FailureData.new(status_code: 400, message: "최대 인원 초과로 확정이 불가능합니다.")

  # 401
  INVALID_TOKEN_IN_HEADER =  FailureData.new(status_code: 400, message: "인증 토큰이 유효하지 않습니다.")

  # 403
  NO_PERMISSION_SHOW = FailureData.new(status_code: 403, message: "예약 상세 조회 권한이 없습니다.")
  NO_PERMISSION_CONFIRM =  FailureData.new(status_code: 403, message: "예약 확정 권한이 없습니다.")
  NO_PERMISSION_UPDATE = FailureData.new(status_code: 403, message: "예약 수정 권한이 없습니다.")
  NO_PERMISSION_DELETE = FailureData.new(status_code: 403, message: "예약 삭제 권한이 없습니다.")

  # 404
  NOT_FOUND_USER =  FailureData.new(status_code: 404, message: "해당 유저를 찾을 수 없습니다.")
  NOT_FOUND_SCHEDULE =  FailureData.new(status_code: 404, message: "해당 예약 일정을 찾을 수 없습니다.")
end

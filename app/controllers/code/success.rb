SuccessData = Struct.new(:status_code, :message, keyword_init: true)

module Success
  # 200
  GET_RESERVATION_DETAIL = SuccessData.new(status_code: 200, message: "예약 상세 조회를 성공했습니다.")
  GET_RESERVATION_ALL = SuccessData.new(status_code: 200, message: "예약 내역 조회를 성공했습니다.")
  GET_RESERVATION_AVAILABILITY_TIME = SuccessData.new(status_code: 200, message: "예약 가능 시간 조회를 성공했습니다.")

  # 201
  CREATE_RESERVATION = SuccessData.new(status_code: 201, message: "예약 등록을 성공했습니다.")

  # 204
  MODIFY_RESERVATION = SuccessData.new(status_code: 204, message: "예약 수정을 성공했습니다.")
  DELETE_RESERVATION = SuccessData.new(status_code: 204, message: "예약 삭제를 성공했습니다.")
  CONFIRM_RESERVATION = SuccessData.new(status_code: 204, message: "예약 확정을 성공했습니다.")
end


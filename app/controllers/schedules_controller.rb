require_relative "./dto/response/schedule_detail"
require_relative "./dto/response/schedule_simple"
require_relative "./dto/response/schedule_available"

class SchedulesController < ApplicationController
  before_action :authenticate_user
  before_action :find_schedule, only: [ :show, :update, :destroy, :confirm ]
  before_action :find_all_schedules, only: [ :index ]

  # 예약 상세 조회
  def show
    return render json: BaseResponse.of_failure(Failure::NO_PERMISSION_SHOW).to_json,
                  status: Failure::NO_PERMISSION_SHOW.status_code unless admin? || @current_user.eql?(@schedule.user)
    render json: BaseResponse.of_success(Success::GET_RESERVATION_DETAIL, ScheduleDetail.new(@schedule)).to_json,
           status: Success::GET_RESERVATION_DETAIL.status_code
  end

  # 예약 내역 조회
  def index
    result = @schedules.map do |schedule| ScheduleSimple.new(schedule) end
    render json: BaseResponse.of_success(Success::GET_RESERVATION_ALL, result).to_json,
           status: Success::GET_RESERVATION_DETAIL.status_code
  end

  # 예약 신청 가능 시간 및 인원 조회
  def available
    start_date = target_month_start_date
    end_date = target_month_start_date.end_of_month

    confirmed_schedules = Schedule.confirmed.where(start_datetime: start_date..end_date)

    available_times = calculate_available_times(confirmed_schedules, start_date, end_date)

    render json: BaseResponse.of_success(Success::GET_RESERVATION_AVAILABILITY_TIME, available_times.map { |datetime, personnel| ScheduleAvailable.new(datetime, personnel) }).to_json,
           status: Success::GET_RESERVATION_AVAILABILITY_TIME.status_code
  rescue ArgumentError
    render json: BaseResponse.of_failure(Failure::INVALID_PARAMETER).to_json,
           status: Failure::INVALID_PARAMETER.status_code
  end

  # 예약 신청
  def create
    return render json: BaseResponse.of_failure(Failure::IMPOSSIBLE_CREATE_TOO_LATE).to_json,
                  status: Failure::IMPOSSIBLE_CREATE_TOO_LATE.status_code if too_late?
    return render json: BaseResponse.of_failure(Failure::OVER_PERSONNEL_TO_RESERVE).to_json,
                  status: Failure::OVER_PERSONNEL_TO_RESERVE.status_code if exceeds_capacity?

    schedule = @current_user.schedules.create!(create_schedule_body)
    render json: BaseResponse.of_success(Success::CREATE_RESERVATION, schedule).to_json,
           status: Success::CREATE_RESERVATION.status_code
  end

  # 예약 확정 (Admin only)
  def confirm
    return render json: BaseResponse.of_failure(Failure::OVER_PERSONNEL_TO_CONFIRM).to_json,
                  status: Failure::OVER_PERSONNEL_TO_CONFIRM.status_code if exceeds_capacity?(true)
    return render json: BaseResponse.of_failure(Failure::NO_PERMISSION_CONFIRM).to_json,
                  status: Failure::NO_PERMISSION_CONFIRM.status_code unless admin? || @schedule.user(@current_user)

    @schedule.update!(is_confirm: true)
    render status: Success::CONFIRM_RESERVATION.status_code
  end

  # 예약 수정
  def update
    return render json: BaseResponse.of_failure(Failure::IMPOSSIBLE_UPDATE_ALREADY_CONFIRM).to_json,
                  status: Failure::IMPOSSIBLE_UPDATE_ALREADY_CONFIRM.status_code  if !admin? && @schedule.is_confirm
    return render json: BaseResponse.of_failure(Failure::OVER_PERSONNEL_TO_CONFIRM).to_json,
                  status: Failure::OVER_PERSONNEL_TO_CONFIRM.status_code if exceeds_capacity?
    @schedule.update!(create_schedule_body)
    render status: Success::MODIFY_RESERVATION.status_code
  end

  # 예약 삭제
  def destroy
    return render json: BaseResponse.of_failure(Failure::IMPOSSIBLE_DELETE_ALREADY_CONFIRM).to_json,
                  status: Failure::IMPOSSIBLE_DELETE_ALREADY_CONFIRM.status_code  if !admin? && @schedule.is_confirm
    @schedule.destroy
    render status: Success::DELETE_RESERVATION.status_code
  end

  private
  def authenticate_user
    @current_user = User.find_by(id: request.env["user_id"])
    render json: BaseResponse.of_failure(Failure::NOT_FOUND_USER).to_json,
           status: Failure::NOT_FOUND_USER.status_code unless @current_user
  end

  def admin?
    @current_user&.admin?
  end

  def target_month_start_date
    params[:target_month].present? ? Date.strptime(params[:target_month].to_s, "%Y-%m") : Date.today
  end

  def find_schedule
    @schedule = admin? ? Schedule.find(params[:id]) : @current_user.schedules.find(params[:id])
    render json: BaseResponse.of_failure(Failure::NOT_FOUND_SCHEDULE).to_json,
           status: Failure::NOT_FOUND_SCHEDULE.status_code unless @schedule
  end

  def find_all_schedules
    @schedules = admin? ? Schedule.all : Schedule.where(user_id: request.env["user_id"])
  end

  def create_schedule_body
    params.require(:schedule).permit(:start_datetime, :end_datetime, :personnel)
  end

  def too_late?
    params[:start_datetime].to_date <= 3.days.from_now.to_date
  end

  def exceeds_capacity?(confirming = false)
    current_count = Schedule.confirmed.where(start_datetime: params[:start_datetime]).sum(:personnel)
    new_count = confirming ? @schedule.personnel : params[:personnel].to_i
    (current_count + new_count) > 50_000
  end

  def calculate_available_times(schedules, start_date, end_date)
    available_slots = {}
    # 해당 월의 각 날짜를 순회하며 기본 값(50,000명 가능) 설정
    (start_date..end_date).each do |date|
      datetime = date.to_datetime
      if datetime >= Date.today + 3.days
        (0..23).each do  |hour|
          available_slots[datetime.change(hour: hour)] = 50_000
        end
      end
    end

    # 예약된 일정 반영하여 예약 가능 인원 조정
    schedules.each do |schedule|
      (schedule.start_datetime.hour..schedule.end_datetime.hour - 1).each do |hour|
        datetime = schedule.start_datetime.to_datetime.change(hour: hour)
        available_slots[datetime] -= schedule.personnel if available_slots[datetime]
      end
    end

    available_slots.select { |_, personnel| personnel > 0 }
  end
end

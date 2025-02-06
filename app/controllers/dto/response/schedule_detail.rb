# frozen_string_literal: true

class ScheduleDetail
  def initialize(schedule)
    @id = schedule.id
    @user_id = schedule.user.id
    @name = schedule.name
    @personnel = schedule.personnel
    @start_at = schedule.start_at
    @end_at = schedule.end_at
    @is_confirmed = schedule.is_confirm
  end
  def to_json(* args)
    {
      id: @id,
      user_id: @user_id,
      name: @name,
      personnel: @personnel,
      start_at: @start_at,
      end_at: @end_at,
      is_confirmed: @is_confirmed
    }.to_json
  end
end

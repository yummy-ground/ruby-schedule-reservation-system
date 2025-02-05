# frozen_string_literal: true

class ScheduleDetail
  def initialize(schedule)
    @id = schedule.id
    @user_id = schedule.user.id
    @name = schedule.name
    @personnel = schedule.personnel
    @start_time = schedule.start_at
    @end_time = schedule.end_at
  end
  def to_json(* args)
    {
      id: @id,
      user_id: @user_id,
      name: @name,
      personnel: @personnel,
      start_at: @start_time,
      end_at: @end_time
    }.to_json
  end
end

# frozen_string_literal: true

class ScheduleSimple
  def initialize(schedule)
    @id = schedule.id
    @name = schedule.name
    @start_at = schedule.start_at
    @end_at = schedule.end_at
    @is_confirmed = schedule.is_confirm
  end
  def to_json(* args)
    {
      id: @id,
      name: @name,
      start_at: @start_at,
      end_at: @end_at,
      is_confirmed: @is_confirmed
    }.to_json
  end
end

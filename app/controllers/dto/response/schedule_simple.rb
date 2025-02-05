# frozen_string_literal: true

class ScheduleSimple
  def initialize(schedule)
    @id = schedule.id
    @name = schedule.name
    @start_time = schedule.start_at
    @end_time = schedule.end_at
  end
  def to_json(* args)
    {
      id: @id,
      name: @name,
      start_at: @start_time,
      end_at: @end_time
    }.to_json
  end
end

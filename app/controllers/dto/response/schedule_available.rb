# frozen_string_literal: true

class ScheduleAvailable
  def initialize(datetime, possible_personnel)
    @date = datetime.strftime("%Y-%m-%d")
    @time = datetime.strftime("%H")
    @personnel = possible_personnel
  end
  def to_json(* args)
    {
      date: @date,
      time: @time,
      personnel: @personnel.to_i
    }.to_json
  end
end

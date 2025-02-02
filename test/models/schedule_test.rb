require "test_helper"

class ScheduleTest < ActiveSupport::TestCase
  test "schedule personnel can't be bigger than 50,000" do
    schedule = Schedule.new(personnel: 50, start_datetime: Time.now + 3.days, end_datetime: Time.now + 4.seconds, is_confirm: false)
    assert_not schedule.valid?
  end
  test "schedule start datetime can't be after the start date" do
    start_date = Time.now
    end_date = start_date - 1.days
    schedule = Schedule.new(personnel: 50, start_datetime: start_date, end_datetime: end_date, is_confirm: false)
    assert_not schedule.valid?
  end
  test "schedule start datetime can't be before the last 3 days" do
    start_date = Time.now + 2.days
    schedule = Schedule.new(personnel: 50, start_datetime: start_date, end_datetime: Time.now + 1.months, is_confirm: false)
    assert_not schedule.valid?
  end
end

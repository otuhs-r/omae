FactoryBot.define do
  factory :attendance, class: Attendance do
    clock_in_time Time.zone.local(2018, 7, 29, 8, 55, 0)
    clock_out_time Time.zone.local(2018, 7, 29, 18, 5, 0)
    date Date.new(2018, 7, 29)
    user
  end

  factory :attendance_apr, class: Attendance do
    clock_in_time Time.zone.local(2018, 7, 29, 4, 0, 0)
    clock_out_time Time.zone.local(2018, 7, 29, 23, 0, 0)
    sequence(:date, 1) { |n| Date.new(2018, 4, n) }
    user
  end

  factory :attendance_may, class: Attendance do
    clock_in_time Time.zone.local(2018, 7, 29, 4, 0, 0)
    clock_out_time Time.zone.local(2018, 7, 29, 23, 0, 0)
    sequence(:date, 1) { |n| Date.new(2018, 5, n) }
    user
  end

  factory :attendance_jun, class: Attendance do
    clock_in_time Time.zone.local(2018, 7, 29, 4, 0, 0)
    clock_out_time Time.zone.local(2018, 7, 29, 23, 0, 0)
    sequence(:date, 1) { |n| Date.new(2018, 6, n) }
    user
  end
end

FactoryBot.define do
  factory :attendance, class: Attendance do
    clock_in_time Time.zone.local(2018, 7, 29, 8, 55, 0)
    clock_out_time Time.zone.local(2018, 7, 29, 18, 5, 0)
    date Date.new(2018, 7, 29)
    user
  end
end

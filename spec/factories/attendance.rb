FactoryBot.define do
  factory :attendance, class: Attendance do
    clock_in_time '2018-07-29 08:55:00'
    clock_out_time '2018-07-29 18:05:00'
    date '2018-07-29'
    user
  end
end

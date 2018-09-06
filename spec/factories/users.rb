FactoryBot.define do
  factory :user, class: User do
    user_name 'user_name'
    email 'test@example.com'
    password 'password'
    work_start_time Time.zone.local(2018, 1, 1, 9, 0, 0)
    work_end_time Time.zone.local(2018, 1, 1, 18, 0, 0)
    rest_start_time Time.zone.local(2018, 1, 1, 12, 0, 0)
    rest_end_time Time.zone.local(2018, 1, 1, 13, 0, 0)
  end
end

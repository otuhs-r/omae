json.extract! attendance, :id, :clock_in_time, :clock_out_time, :user_id, :created_at, :updated_at
json.url attendance_url(attendance, format: :json)

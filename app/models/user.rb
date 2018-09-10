class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :user_name, presence: true, length: { maximum: 10 }
  validates :work_start_time, presence: true
  validates :work_end_time, presence: true
  validates :rest_start_time, presence: true
  validates :rest_end_time, presence: true
  validate :time_validation
  has_many :attendances

  def working_seconds(start_date, end_date)
    attendances.where(date: start_date..end_date).reduce(0.0) do |sum, attendance|
      sum + attendance.working_seconds
    end
  end

  def extra_working_seconds(start_date, end_date)
    attendances.where(date: start_date..end_date).reduce(0.0) do |sum, attendance|
      sum + attendance.extra_working_seconds
    end
  end

  def average_extra_working_hours_by_day_of_week(start_date, end_date)
    grouped_attendances = attendances.where(date: start_date..end_date).group_by_day_of_week(&:date)
    data = {}
    { 0 => 'Sun', 1 => 'Mon', 2 => 'Tue', 3 => 'Wed', 4 => 'Thu', 5 => 'Fri', 6 => 'Sat' }.each do |key, value|
      if grouped_attendances.key?(key)
        average = grouped_attendances[key].reduce(0.0) { |sum, attendance| sum + attendance.extra_working_seconds / 3600 } / grouped_attendances[key].count
        data.store(value, average.round(2))
      else
        data.store(value, 0.0)
      end
    end
    data
  end

  def time_validation
    unless work_start_time.present? && work_end_time.present? && rest_start_time.present? && rest_end_time.present?
      return
    end

    if work_start_time.to_s(:time) >= work_end_time.to_s(:time)
      errors.add(:work_end_time, 'should be later than work start time.')
    elsif rest_start_time.to_s(:time) >= rest_end_time.to_s(:time)
      errors.add(:rest_end_time, 'should be later than rest start time.')
    elsif work_start_time.to_s(:time) >= rest_start_time.to_s(:time)
      errors.add(:rest_start_time, 'should be later than work start time.')
    elsif rest_end_time.to_s(:time) >= work_end_time.to_s(:time)
      errors.add(:work_end_time, 'should be later than rest end time.')
    end
  end
end

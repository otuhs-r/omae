class Dashboard
  def initialize(attendances)
    @attendances = attendances
  end

  def all_working_seconds
    @attendances.reduce(0.0) do |sum, attendance|
      sum + attendance.working_seconds
    end
  end

  def all_extra_working_seconds
    @attendances.reduce(0.0) do |sum, attendance|
      sum + attendance.extra_working_seconds
    end
  end

  def days_worked
    @attendances.count
  end

  def days_worked_off
    @attendances.where(division: :off_day).count
  end

  def worked_off_rate
    days_worked_off.zero? ? 0 : (days_worked_off / days_worked.to_f) * 100
  end

  def average_extra_working_seconds
    days_worked.zero? ? 0 : all_extra_working_seconds / days_worked
  end

  def extra_working_rate
    all_working_seconds.zero? ? 0 : ((all_extra_working_seconds / all_working_seconds) * 100).to_i
  end

  def average_extra_working_hours_by_day_of_week
    grouped_attendances = @attendances.group_by_day_of_week(&:date)
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
end

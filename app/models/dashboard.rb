class Dashboard
  attr_reader :attendances

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

  def average_extra_working_seconds
    days_worked.zero? ? 0 : all_extra_working_seconds / days_worked
  end

  def extra_working_rate
    all_working_seconds.zero? ? 0 : ((all_extra_working_seconds / all_working_seconds) * 100).to_i
  end

  def all_working_hours_group_by_day
    @attendances.group_by_day(&:date).map do |k, attendances|
      [k.strftime('%m-%d'), attendances.reduce(0.0) { |sum, attendance| sum + attendance.working_seconds / 3600 }.round(2)]
    end
  end

  def all_working_hours_group_by_week
    @attendances.group_by_week(&:date).map do |k, attendances|
      [k.strftime('%m-%d~'), attendances.reduce(0.0) { |sum, attendance| sum + attendance.working_seconds / 3600 }.round(2)]
    end
  end

  def all_working_hours_group_by_month
    @attendances.group_by_month(&:date).map do |k, attendances|
      [k.strftime('%m月'), attendances.reduce(0.0) { |sum, attendance| sum + attendance.working_seconds / 3600 }.round(2)]
    end
  end

  def average_extra_working_hours_by_day_of_week
    grouped_attendances = @attendances.group_by_day_of_week(&:date)
    data = {}
    { 0 => '日', 1 => '月', 2 => '火', 3 => '水', 4 => '木', 5 => '金', 6 => '土' }.each do |key, value|
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

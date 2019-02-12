class LaborStandardLawBoard
  def initialize(user)
    today = Time.zone.now.to_date
    one_year_ago = today - 1.year
    monthly_attendances = user.attendances.where(date: one_year_ago..today).group_by_month(&:date)
    @monthly_extra_working_seconds = 11.downto(0).map { |n| (Time.zone.now - n.months).month }.map do |m|
      tmp = monthly_attendances.map do |k, attendances|
        [k.month, attendances.reduce(0.0) { |sum, attendance| sum + attendance.extra_working_seconds }]
      end.to_h
      # 勤怠データがない月は 0.0 で埋める
      tmp.key?(m) ? [m, tmp[m]] : [m, 0.0]
    end
  end

  def extra_working_hours_group_by_month
    @monthly_extra_working_seconds.map { |m, ews| [format('%02d月', m), (ews / 3600).round(2)] }
  end

  def extra_working_seconds_of_this_month
    @monthly_extra_working_seconds.select { |month, _v| month == Time.zone.now.month }.first.last
  end

  def extra_working_seconds_of_this_year
    @monthly_extra_working_seconds.reduce(0.0) { |sum, (_m, extra_working_seconds)| sum + extra_working_seconds }
  end

  def count_more_than_45hours
    @monthly_extra_working_seconds.count { |_m, extra_working_seconds| extra_working_seconds >= 45 * 60 * 60 }
  end

  def averages_of_extra_working_seconds
    (2..6).map { |n| ["#{n}ヶ月", average_of_extra_working_seconds(n)] }
  end

  private

  def average_of_extra_working_seconds(months)
    @monthly_extra_working_seconds[-months..-1].reduce(0.0) { |sum, (_m, extra_working_seconds)| sum + extra_working_seconds } / months
  end
end

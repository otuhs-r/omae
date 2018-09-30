class Dashboard
  attr_reader :all_working_seconds, :all_extra_working_seconds,
              :days_worked, :average_extra_working_seconds, :extra_working_rate

  def initialize(user, start_date, end_date)
    @all_working_seconds = user.working_seconds(start_date, end_date)
    @all_extra_working_seconds = user.extra_working_seconds(start_date, end_date)
    @days_worked = user.attendances.where(date: start_date..end_date).count
    @average_extra_working_seconds = days_worked.zero? ? 0 : @all_extra_working_seconds / @days_worked
    @extra_working_rate = @all_working_seconds.zero? ? 0 : ((@all_extra_working_seconds / @all_working_seconds) * 100).to_i
  end
end

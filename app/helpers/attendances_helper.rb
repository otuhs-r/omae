module AttendancesHelper
  def default_clock_in_time(mode, attendance)
    mode == 'New' ? current_user.work_start_time.to_s(:time) : attendance.clock_in_time.to_s(:time)
  end

  def default_clock_out_time(mode, attendance)
    mode == 'New' ? current_user.work_end_time.to_s(:time) : attendance.clock_out_time.to_s(:time)
  end

  def default_date(mode, attendance)
    mode == 'New' ? Date.today : attendance.date
  end

  def avg_by_day_of_week_chart(start_date, end_date)
    now = Time.current
    start_date ||= now.beginning_of_month
    end_date ||= now
    column_chart by_day_of_week_api_user_attendances_path(current_user, start_date: start_date, end_date: end_date), basic_opts
  end

  def all_working_hours(start_date, end_date)
    now = Time.current
    start_date ||= now.beginning_of_month
    end_date ||= now
    working_sec = current_user.working_seconds(start_date, end_date)
    convert_to_hh_mm_from_sec(working_sec)
  end

  def all_extra_working_hours(start_date, end_date)
    now = Time.current
    start_date ||= now.beginning_of_month
    end_date ||= now
    extra_working_sec = current_user.extra_working_seconds(start_date, end_date)
    convert_to_hh_mm_from_sec(extra_working_sec)
  end

  private

  def basic_opts
    {
      discrete: true,
      legend: false,
      download: true
    }
  end
end

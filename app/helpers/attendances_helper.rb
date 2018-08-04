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
end

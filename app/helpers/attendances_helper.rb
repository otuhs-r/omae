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

  def default_check(attendance)
    attendance.off_day?
  end

  def mode_to_ja(mode)
    mode == 'New' ? '登録' : '編集'
  end

  def warning_message(month, extra_working_seconds)
    seconds = (80 * 60 * 60) * month.to_i - extra_working_seconds
    if seconds >= 0
      "今月あと #{convert_to_hh_mm_from_sec(seconds)} 時間残業すると上限に到達します"
    else
      "今月の残業時間を #{convert_to_hh_mm_from_sec(-seconds)} 時間削減すると上限に収まります"
    end
  end

  private

  def basic_opts
    {
      discrete: true,
      legend: false,
      download: true,
      label: ' ',
      ytitle: '時間',
      suffix: ' 時間'
    }
  end
end

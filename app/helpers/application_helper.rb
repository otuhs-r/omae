module ApplicationHelper
  def convert_to_hh_mm_from_sec(seconds)
    seconds >= 0 ? convert(seconds) : "-#{convert(-seconds)}"
  end

  def min(attendances)
    attendances.min_by(&:date)
  end

  def max(attendances)
    attendances.max_by(&:date)
  end

  private

  def convert(seconds)
    min = seconds.to_i / 60
    hh, mm = min.divmod(60)
    format('%02d:%02d', hh, mm)
  end
end

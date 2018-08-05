module ApplicationHelper
  def convert_to_hh_mm_from_sec(seconds)
    min = seconds.to_i / 60
    hh, mm = min.divmod(60)
    format('%02d:%02d', hh, mm)
  end
end

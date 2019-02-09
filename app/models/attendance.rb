class Attendance < ApplicationRecord
  belongs_to :user
  validates :date, uniqueness: { scope: :user }, presence: true
  validates :clock_in_time, presence: true
  validates :clock_out_time, presence: true
  validate :time_validation

  enum division: { ordinary: 0, off_day: 1, morning_off: 2, afternoon_off: 3 }

  def working_seconds
    diff_sec_between_clock_in_out - resting_sec
  end

  def extra_working_seconds
    working_seconds - normal_working_seconds
  end

  def normal_working_seconds
    case
    when ordinary?
      (work_end_time - work_start_time) - (rest_end_time - rest_start_time)
    when off_day?
      0.0
    when morning_off?
      work_end_time - rest_end_time
    when afternoon_off?
      rest_start_time - work_start_time
    end
  end

  def time_validation
    return if clock_in_time.blank? || clock_out_time.blank?

    if clock_in_time >= clock_out_time
      errors.add(:clock_out_time, 'は出勤時刻より後にしてください')
    end
  end

  def clock_in_time
    self[:clock_in_time].present? ? Time.zone.parse(self[:clock_in_time].to_s(:time)) : nil
  end

  def clock_out_time
    self[:clock_out_time].present? ? Time.zone.parse(self[:clock_out_time].to_s(:time)) : nil
  end

  def work_start_time
    Time.zone.parse(user.work_start_time.to_s(:time))
  end

  def work_end_time
    Time.zone.parse(user.work_end_time.to_s(:time))
  end

  def rest_start_time
    Time.zone.parse(user.rest_start_time.to_s(:time))
  end

  def rest_end_time
    Time.zone.parse(user.rest_end_time.to_s(:time))
  end

  private

  def diff_sec_between_clock_in_out
    clock_out_time - clock_in_time
  end

  def resting_sec
    case
    when clock_in_before_rest_start? && clock_out_after_rest_end?
      rest_end_time - rest_start_time
    when clock_in_before_rest_start? && clock_out_during_recess?
      clock_out_time - rest_start_time
    when clock_in_before_rest_start? && clock_out_before_rest_start?
      0.0
    when clock_in_during_recess? && clock_out_after_rest_end?
      rest_end_time - clock_in_time
    when clock_in_during_recess? && clock_out_during_recess?
      clock_out_time - clock_in_time
    else
      0.0
    end
  end

  def clock_in_before_rest_start?
    clock_in_time <= rest_start_time
  end

  def clock_in_during_recess?
    clock_in_time.between?(rest_start_time, rest_end_time)
  end

  def clock_in_after_rest_end?
    rest_end_time <= clock_in_time
  end

  def clock_out_before_rest_start?
    clock_out_time <= rest_start_time
  end

  def clock_out_during_recess?
    clock_out_time.between?(rest_start_time, rest_end_time)
  end

  def clock_out_after_rest_end?
    rest_end_time <= clock_out_time
  end
end

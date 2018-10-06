class Attendance < ApplicationRecord
  belongs_to :user
  validates :date, uniqueness: { scope: :user }, presence: true
  validates :clock_in_time, presence: true
  validates :clock_out_time, presence: true
  validate :time_validation

  enum division: { ordinary: 0, off_day: 1 }

  def working_seconds
    diff_sec_between_clock_in_out - resting_sec
  end

  def extra_working_seconds
    if ordinary?
      earlier_extra_sec + later_extra_sec
    else
      working_seconds
    end
  end

  def time_validation
    if clock_in_time.present? && clock_out_time.present?
      if clock_in_time.to_s(:time) >= clock_out_time.to_s(:time)
        errors.add(:clock_out_time, 'should be later than clock in time.')
      end
    end
  end

  private

  def diff_sec_between_clock_in_out
    setup_times
    if @clock_in_time.between?(@rest_start_time, @rest_end_time) &&
       @clock_out_time.between?(@rest_start_time, @rest_end_time)
      0.0
    else
      @clock_out_time - @clock_in_time
    end
  end

  def resting_sec
    setup_times
    return 0.0 unless @rest_start_time.between?(@clock_in_time, @clock_out_time) ||
                      @rest_end_time.between?(@clock_in_time, @clock_out_time)
    if @clock_in_time <= @rest_start_time
      if @rest_end_time <= @clock_out_time
        @rest_end_time - @rest_start_time
      elsif @rest_start_time <= @clock_out_time
        @clock_out_time - @rest_start_time
      end
    elsif @clock_in_time <= @rest_end_time
      if @rest_end_time <= @clock_out_time
        @rest_end_time - @clock_in_time
      end
    end
  end

  def earlier_extra_sec
    setup_times
    if @work_start_time <= @clock_out_time
      earlier_sec = @work_start_time - @clock_in_time
      earlier_sec >= 0 ? earlier_sec : 0.0
    else
      @clock_out_time - @clock_in_time
    end
  end

  def later_extra_sec
    setup_times
    if @clock_in_time <= @work_end_time
      later_sec = @clock_out_time - @work_end_time
      later_sec >= 0 ? later_sec : 0.0
    else
      @clock_out_time - @clock_in_time
    end
  end

  def setup_times
    @clock_in_time = Time.parse(clock_in_time.to_s(:time))
    @clock_out_time = Time.parse(clock_out_time.to_s(:time))
    @work_start_time = Time.parse(user.work_start_time.to_s(:time))
    @work_end_time = Time.parse(user.work_end_time.to_s(:time))
    @rest_start_time = Time.parse(user.rest_start_time.to_s(:time))
    @rest_end_time = Time.parse(user.rest_end_time.to_s(:time))
  end
end

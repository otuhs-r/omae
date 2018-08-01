class Attendance < ApplicationRecord
  belongs_to :user
  validates :date, uniqueness: { scope: :user }, presence: true
  validates :clock_in_time, presence: true
  validates :clock_out_time, presence: true
  validate :time_validation

  def time_validation
    if clock_in_time.present? && clock_out_time.present?
      if clock_in_time.to_s(:time) >= clock_out_time.to_s(:time)
        errors.add(:clock_out_time, 'should be later than clock in time.')
      end
    end
  end
end

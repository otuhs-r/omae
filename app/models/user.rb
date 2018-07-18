class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :user_name, presence: true, length: { maximum: 10 }
  validates :work_start_time, presence: true
  validates :work_end_time, presence: true
  validates :rest_start_time, presence: true
  validates :rest_end_time, presence: true
  validate :time_validation

  def time_validation
    if work_start_time.present? && work_end_time.present? && work_start_time.to_s(:time) >= work_end_time.to_s(:time) 
      errors.add(:work_end_time, 'should be later than work start time.')
    elsif rest_start_time.present? && rest_end_time.present? && rest_start_time.to_s(:time) >= rest_end_time.to_s(:time)
      errors.add(:rest_end_time, 'should be later than rest start time.')
    elsif rest_start_time.present? && work_start_time.present? && rest_start_time.to_s(:time) <= work_start_time.to_s(:time)
      errors.add(:rest_start_time, 'should be later than work start time.')
    elsif rest_end_time.present? && work_end_time.present? && rest_end_time.to_s(:time) >= work_end_time.to_s(:time)
      errors.add(:work_end_time, 'should be later than rest end time.')
    end
  end
end

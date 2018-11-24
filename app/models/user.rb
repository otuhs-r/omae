class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:user_name]
  validates :user_name, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :work_start_time, presence: true
  validates :work_end_time, presence: true
  validates :rest_start_time, presence: true
  validates :rest_end_time, presence: true
  validate :time_validation
  has_many :attendances

  def time_validation
    unless work_start_time.present? && work_end_time.present? && rest_start_time.present? && rest_end_time.present?
      return
    end

    if work_start_time.to_s(:time) >= work_end_time.to_s(:time)
      errors.add(:work_end_time, 'は始業時刻より後にしてください')
    elsif rest_start_time.to_s(:time) >= rest_end_time.to_s(:time)
      errors.add(:rest_end_time, 'は休憩開始時刻より後にしてください')
    elsif work_start_time.to_s(:time) >= rest_start_time.to_s(:time)
      errors.add(:rest_start_time, 'は始業時刻より後にしてください')
    elsif rest_end_time.to_s(:time) >= work_end_time.to_s(:time)
      errors.add(:work_end_time, 'は休憩終了時刻より後にしてください')
    end
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if conditions.delete(:login)
      where(conditions).where(['user_name = :value', { value: user_name }]).first
    else
      where(conditions).first
    end
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end
end

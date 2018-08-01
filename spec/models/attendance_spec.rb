require 'rails_helper'

describe Attendance do
  let(:attendance) { Attendance.new(date: date, clock_in_time: clock_in_time, clock_out_time: clock_out_time, user: user) }
  subject { attendance }

  context 'with all valid params' do
    let(:date) { '2018-07-29' }
    let(:clock_in_time) { '2018-07-29 08:55:00' }
    let(:clock_out_time) { '2018-07-29 18:05:00' }
    let(:user) { build(:user) }

    it 'is valid.' do
      is_expected.to be_valid
    end
  end

  context 'without a date' do
    let(:date) { '' }
    let(:clock_in_time) { '2018-07-29 08:55:00' }
    let(:clock_out_time) { '2018-07-29 18:05:00' }
    let(:user) { build(:user) }

    it 'is invalid.' do
      is_expected.to be_invalid
    end
  end

  context 'without a clock_in_time' do
    let(:date) { '2018-07-29' }
    let(:clock_in_time) { '' }
    let(:clock_out_time) { '2018-07-29 18:05:00' }
    let(:user) { build(:user) }

    it 'is invalid.' do
      is_expected.to be_invalid
    end
  end

  context 'without a clock_out_time' do
    let(:date) { '2018-07-29' }
    let(:clock_in_time) { '2018-07-29 08:55:00' }
    let(:clock_out_time) { '' }
    let(:user) { build(:user) }

    it 'is invalid.' do
      is_expected.to be_invalid
    end
  end

  context 'a clock in time is later than clock out time' do
    let(:date) { '2018-07-29' }
    let(:clock_in_time) { '2018-07-29 18:05:00' }
    let(:clock_out_time) { '2018-07-29 08:55:00' }
    let(:user) { build(:user) }

    it 'is invalid.' do
      is_expected.to be_invalid
    end
  end

  context 'with ununiqueness date' do
    let(:duplicated_attendance) { Attendance.new(date: '2018-07-29', clock_in_time: clock_in_time, clock_out_time: clock_out_time, user: user) }
    let(:date) { '2018-07-29' }
    let(:clock_in_time) { '2018-07-29 08:55:00' }
    let(:clock_out_time) { '2018-07-29 18:05:00' }
    let(:user) { build(:user) }

    it 'is invalid.' do
      duplicated_attendance.save
      is_expected.to be_invalid
    end
  end
end

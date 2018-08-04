require 'rails_helper'

describe Attendance do
  subject { attendance }

  context 'with all valid params' do
    let(:attendance) { build(:attendance, user: build(:user)) }

    it 'is valid.' do
      is_expected.to be_valid
    end
  end

  context 'without a date' do
    let(:attendance) { build(:attendance, date: '', user: build(:user)) }

    it 'is invalid.' do
      is_expected.to be_invalid
    end
  end

  context 'without a clock_in_time' do
    let(:attendance) { build(:attendance, clock_in_time: '', user: build(:user)) }

    it 'is invalid.' do
      is_expected.to be_invalid
    end
  end

  context 'without a clock_out_time' do
    let(:attendance) { build(:attendance, clock_out_time: '', user: build(:user)) }

    it 'is invalid.' do
      is_expected.to be_invalid
    end
  end

  context 'a clock in time is later than clock out time' do
    let(:attendance) { build(:attendance, clock_in_time: '2018-07-29 20:05:00', user: build(:user)) }

    it 'is invalid.' do
      is_expected.to be_invalid
    end
  end

  context 'with ununiqueness date' do
    let!(:attendance) { create(:attendance, user: user) }
    let(:duplicated_attendance) { build(:attendance, user: user) }
    let(:user) { build(:user) }

    it 'is invalid.' do
      expect(duplicated_attendance).to be_invalid
    end
  end
end

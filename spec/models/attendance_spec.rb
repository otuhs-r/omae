require 'rails_helper'

describe Attendance do
  describe 'validation' do
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

  describe 'working hours' do
    context 'clock in <= work stat && work_end <= clcok out' do
      let(:attendance) { build(:attendance, user: build(:user)) }

      it 'calculates working hours correctly.' do
        expect(attendance.working_hours).to eq '08:10'
      end

      it 'calculates extra working hours correctly.' do
        expect(attendance.extra_working_hours).to eq '00:10'
      end
    end

    context 'clock in <= work start && clock out <= work end' do
      let(:attendance) { build(:attendance, clock_out_time: '2018-07-29 16:00:00', user: build(:user)) }

      it 'calculates working hours correctly.' do
        expect(attendance.working_hours).to eq '06:05'
      end

      it 'calculates extra working hours correctly.' do
        expect(attendance.extra_working_hours).to eq '00:05'
      end
    end

    context 'clock in <= work start && clock out <= rest end' do
      let(:attendance) { build(:attendance, clock_out_time: '2018-07-29 12:30:00', user: build(:user)) }

      it 'calculates working hours correctly.' do
        expect(attendance.working_hours).to eq '03:05'
      end

      it 'calculates extra working hours correctly.' do
        expect(attendance.extra_working_hours).to eq '00:05'
      end
    end

    context 'clock in <= work start && clock out <= rest start' do
      let(:attendance) { build(:attendance, clock_out_time: '2018-07-29 11:00:00', user: build(:user)) }

      it 'calculates working hours correctly.' do
        expect(attendance.working_hours).to eq '02:05'
      end

      it 'calculates extra working hours correctly.' do
        expect(attendance.extra_working_hours).to eq '00:05'
      end
    end

    context 'clock in, out <= work start' do
      let(:attendance) { build(:attendance, clock_in_time: '2018-07-29 05:00:00', clock_out_time: '2018-07-29 08:00:00', user: build(:user)) }

      it 'calculates working hours correctly.' do
        expect(attendance.working_hours).to eq '03:00'
      end

      it 'calculates extra working hours correctly.' do
        expect(attendance.extra_working_hours).to eq '03:00'
      end
    end

    context 'work start <= clock in && work end <= clock out' do
      let(:attendance) { build(:attendance, clock_in_time: '2018-07-29 10:00:00', user: build(:user)) }

      it 'calculates working hours correctly.' do
        expect(attendance.working_hours).to eq '07:05'
      end

      it 'calculates extra working hours correctly.' do
        expect(attendance.extra_working_hours).to eq '00:05'
      end
    end

    context 'work start <= clock in && clock out <= work end' do
      let(:attendance) { build(:attendance, clock_in_time: '2018-07-29 10:00:00', clock_out_time: '2018-07-29 17:00:00', user: build(:user)) }

      it 'calculates working hours correctly.' do
        expect(attendance.working_hours).to eq '06:00'
      end

      it 'calculates extra working hours correctly.' do
        expect(attendance.extra_working_hours).to eq '00:00'
      end
    end

    context 'work start <= clock in && clock out <= rest end' do
      let(:attendance) { build(:attendance, clock_in_time: '2018-07-29 10:00:00', clock_out_time: '2018-07-29 12:30:00', user: build(:user)) }

      it 'calculates working hours correctly.' do
        expect(attendance.working_hours).to eq '02:00'
      end

      it 'calculates extra working hours correctly.' do
        expect(attendance.extra_working_hours).to eq '00:00'
      end
    end

    context 'work start <= clock in && clock out <= rest start' do
      let(:attendance) { build(:attendance, clock_in_time: '2018-07-29 10:00:00', clock_out_time: '2018-07-29 11:00:00', user: build(:user)) }

      it 'calculates working hours correctly.' do
        expect(attendance.working_hours).to eq '01:00'
      end

      it 'calculates extra working hours correctly.' do
        expect(attendance.extra_working_hours).to eq '00:00'
      end
    end

    context 'rest start <= clock in && work end <= clock out' do
      let(:attendance) { build(:attendance, clock_in_time: '2018-07-29 12:30:00', user: build(:user)) }

      it 'calculates working hours correctly.' do
        expect(attendance.working_hours).to eq '05:05'
      end

      it 'calculates extra working hours correctly.' do
        expect(attendance.extra_working_hours).to eq '00:05'
      end
    end

    context 'rest start <= clock in && clock out <= work end' do
      let(:attendance) { build(:attendance, clock_in_time: '2018-07-29 12:30:00', clock_out_time: '2018-07-29 17:00:00', user: build(:user)) }

      it 'calculates working hours correctly.' do
        expect(attendance.working_hours).to eq '04:00'
      end

      it 'calculates extra working hours correctly.' do
        expect(attendance.extra_working_hours).to eq '00:00'
      end
    end

    context 'rest start <= clock in && clock out <= rest end' do
      let(:attendance) { build(:attendance, clock_in_time: '2018-07-29 12:30:00', clock_out_time: '2018-07-29 12:45:00', user: build(:user)) }

      it 'calculates working hours correctly.' do
        expect(attendance.working_hours).to eq '00:00'
      end

      it 'calculates extra working hours correctly.' do
        expect(attendance.extra_working_hours).to eq '00:00'
      end
    end

    context 'rest end <= clock in && work end <= clock out' do
      let(:attendance) { build(:attendance, clock_in_time: '2018-07-29 14:00:00', user: build(:user)) }

      it 'calculates working hours correctly.' do
        expect(attendance.working_hours).to eq '04:05'
      end

      it 'calculates extra working hours correctly.' do
        expect(attendance.extra_working_hours).to eq '00:05'
      end
    end

    context 'rest end <= clock in && clock out <= work end' do
      let(:attendance) { build(:attendance, clock_in_time: '2018-07-29 14:00:00', clock_out_time: '2018-07-29 17:00:00', user: build(:user)) }

      it 'calculates working hours correctly.' do
        expect(attendance.working_hours).to eq '03:00'
      end

      it 'calculates extra working hours correctly.' do
        expect(attendance.extra_working_hours).to eq '00:00'
      end
    end

    context 'work end <= clock in, out' do
      let(:attendance) { build(:attendance, clock_in_time: '2018-07-29 19:00:00', clock_out_time: '2018-07-29 23:00:00', user: build(:user)) }

      it 'calculates working hours correctly.' do
        expect(attendance.working_hours).to eq '04:00'
      end

      it 'calculates extra working hours correctly.' do
        expect(attendance.extra_working_hours).to eq '04:00'
      end
    end
  end
end

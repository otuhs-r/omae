require 'rails_helper'

describe User do
  describe 'validation' do
    let(:user) { build(:user) }
    subject { user }

    it 'is valid with all of valid params.' do
      is_expected.to be_valid
    end

    it 'is invalid without a user name.' do
      user.user_name = nil
      is_expected.to be_invalid
    end

    it 'is invalid without a email.' do
      user.email = nil
      is_expected.to be_invalid
    end

    it 'is invalid without a work start time.' do
      user.work_start_time = nil
      is_expected.to be_invalid
    end

    it 'is invalid without a work end time.' do
      user.work_end_time = nil
      is_expected.to be_invalid
    end

    it 'is invalid without a rest start time.' do
      user.rest_start_time = nil
      is_expected.to be_invalid
    end

    it 'is invalid without a rest end time.' do
      user.rest_end_time = nil
      is_expected.to be_invalid
    end

    it 'is invalid with a too long user name.' do
      user.user_name = 'a' * 11
      is_expected.to be_invalid
    end

    it 'is invalid with a work start time later than work end time.' do
      user.work_start_time = '2018-1-1 20:00:00'
      is_expected.to be_invalid
    end

    it 'is invalid with a rest start time later than rest end time.' do
      user.rest_start_time = '2018-1-1 15:00:00'
      is_expected.to be_invalid
    end

    it 'is invalid with a rest start time earlier than work start time.' do
      user.rest_start_time = '2018-1-1 05:00:00'
      is_expected.to be_invalid
    end

    it 'is invalid with a rest end time later than work end time.' do
      user.rest_end_time = '2018-1-1 20:00:00'
      is_expected.to be_invalid
    end
  end

  describe 'working hours' do
    context 'no attendances' do
      let(:user) { build(:user) }

      it 'returns working hours valued zero.' do
        expect(user.working_hours).to eq '00:00'
      end

      it 'returns extra working hours valued zero.' do
        expect(user.extra_working_hours).to eq '00:00'
      end
    end

    context 'two attendances' do
      let(:user) { build(:user) }
      let!(:attendance1) { create(:attendance, user: user) }
      let!(:attendance2) { create(:attendance, date: '2018-07-30', user: user) }

      it 'sammrizes all working hours.' do
        expect(user.working_hours).to eq '16:20'
      end

      it 'sammrizes all extra working hours.' do
        expect(user.extra_working_hours).to eq '00:20'
      end
    end
  end
end

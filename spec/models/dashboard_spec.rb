require 'rails_helper'

describe Dashboard do
  include ApplicationHelper

  describe 'working hours' do
    context 'no attendances' do
      let(:dashboard) { Dashboard.new([]) }

      it 'returns working hours valued zero.' do
        expect(convert_to_hh_mm_from_sec(dashboard.all_working_seconds)).to eq '00:00'
      end

      it 'returns extra working hours valued zero.' do
        expect(convert_to_hh_mm_from_sec(dashboard.all_extra_working_seconds)).to eq '00:00'
      end

      it 'returns all zero as average of extra working hours by day of week.' do
        expect(dashboard.average_extra_working_hours_by_day_of_week).to eq(
          '日' => 0.0, '月' => 0.0, '火' => 0.0, '水' => 0.0, '木' => 0.0, '金' => 0.0, '土' => 0.0
        )
      end
    end

    context 'two attendances' do
      let(:user) { build(:user) }
      let!(:attendance1) { create(:attendance, user: user) }
      let!(:attendance2) { create(:attendance, date: '2018-07-30', user: user) }
      let(:dashboard) { Dashboard.new([attendance1, attendance2]) }

      it 'sammrizes all working hours.' do
        expect(convert_to_hh_mm_from_sec(dashboard.all_working_seconds)).to eq '16:20'
      end

      it 'sammrizes all extra working hours.' do
        expect(convert_to_hh_mm_from_sec(dashboard.all_extra_working_seconds)).to eq '00:20'
      end

      it 'returns average of extra working hours by day of week correctly.' do
        expect(dashboard.average_extra_working_hours_by_day_of_week).to eq(
          '日' => 0.17, '月' => 0.17, '火' => 0.0, '水' => 0.0, '木' => 0.0, '金' => 0.0, '土' => 0.0
        )
      end
    end

    context 'many attendances' do
      let(:user) { build(:user) }
      let!(:attendance1) { create(:attendance, user: user) }
      let!(:attendance2) { create(:attendance, date: '2018-07-30', user: user) }
      let!(:attendance3) { create(:attendance, date: '2018-07-23', user: user) }
      let!(:attendance4) { create(:attendance, date: '2018-07-16', user: user) }
      let!(:attendance5) { create(:attendance, date: '2018-07-9', user: user) }
      let(:dashboard) { Dashboard.new([attendance1, attendance2, attendance3, attendance4, attendance5]) }

      it 'returns average of extra working hours by day of week correctly.' do
        expect(dashboard.average_extra_working_hours_by_day_of_week).to eq(
          '日' => 0.17, '月' => 0.17, '火' => 0.0, '水' => 0.0, '木' => 0.0, '金' => 0.0, '土' => 0.0
        )
      end

      it 'returns all working hours group by day' do
        expect(dashboard.all_working_hours_group_by_day).to eq([['07-09', 8.17],
                                                                ['07-16', 8.17],
                                                                ['07-23', 8.17],
                                                                ['07-29', 8.17],
                                                                ['07-30', 8.17]])
      end

      it 'returns all working hours group by week' do
        expect(dashboard.all_working_hours_group_by_week).to eq(
          [['07-08~', 8.17], ['07-15~', 8.17], ['07-22~', 8.17], ['07-29~', 16.33]]
        )
      end

      it 'returns all working hours group by month' do
        expect(dashboard.all_working_hours_group_by_month).to eq([['07月', 40.83]])
      end
    end
  end
end

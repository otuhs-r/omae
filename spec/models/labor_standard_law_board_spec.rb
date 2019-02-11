require 'rails_helper'

describe LaborStandardLawBoard do
  include ApplicationHelper

  describe 'labor standard law' do
    context 'attendances exist' do
      before(:each) do
        user = build(:user)
        3.times { create(:attendance_apr, user: user) }
        5.times { create(:attendance_may, user: user) }
        10.times { create(:attendance_jun, user: user) }
      end

      after(:each) do
        DatabaseCleaner.clean
        FactoryBot.reload
      end

      let(:lsl_board) { LaborStandardLawBoard.new }

      it 'extra_working_hours_group_by_month' do
        travel_to(Time.zone.local(2018, 6, 30, 23, 0, 0)) do
          expect(lsl_board.extra_working_hours_group_by_month).to eq(
            [['07月', 0.00], ['08月', 0.00], ['09月', 0.00], ['10月', 0.00], ['11月', 0.00], ['12月', 0.00],
             ['01月', 0.00], ['02月', 0.00], ['03月', 0.00], ['04月', 30.00], ['05月', 50.00], ['06月', 100.00]]
          )
        end
      end

      it 'extra_working_seconds_of_this_month' do
        travel_to(Time.zone.local(2018, 6, 30, 23, 0, 0)) do
          expect(convert_to_hh_mm_from_sec(lsl_board.extra_working_seconds_of_this_month)).to eq '100:00'
        end
      end

      it 'extra_working_seconds_of_this_year' do
        travel_to(Time.zone.local(2018, 6, 30, 23, 0, 0)) do
          expect(convert_to_hh_mm_from_sec(lsl_board.extra_working_seconds_of_this_year)).to eq '180:00'
        end
      end

      it 'count_more_than_45hours' do
        travel_to(Time.zone.local(2018, 6, 30, 23, 0, 0)) do
          expect(lsl_board.count_more_than_45hours).to eq 2
        end
      end

      it 'averages_of_extra_working_seconds' do
        travel_to(Time.zone.local(2018, 6, 30, 23, 0, 0)) do
          expect(lsl_board.averages_of_extra_working_seconds).to eq(
            [['2ヶ月', 270000.0], ['3ヶ月', 216000.0], ['4ヶ月', 162000.0], ['5ヶ月', 129600.0], ['6ヶ月', 108000.0]]
          )
        end
      end
    end

    context 'attendances do not exist' do
      let(:lsl_board) { LaborStandardLawBoard.new }

      it 'extra_working_hours_group_by_month' do
        travel_to(Time.zone.local(2018, 6, 30, 23, 0, 0)) do
          expect(lsl_board.extra_working_hours_group_by_month).to eq(
            [['07月', 0.00], ['08月', 0.00], ['09月', 0.00], ['10月', 0.00], ['11月', 0.00], ['12月', 0.00],
             ['01月', 0.00], ['02月', 0.00], ['03月', 0.00], ['04月', 0.00], ['05月', 0.00], ['06月', 0.00]]
          )
        end
      end

      it 'extra_working_seconds_of_this_month' do
        travel_to(Time.zone.local(2018, 6, 30, 23, 0, 0)) do
          expect(convert_to_hh_mm_from_sec(lsl_board.extra_working_seconds_of_this_month)).to eq '00:00'
        end
      end

      it 'extra_working_seconds_of_this_year' do
        travel_to(Time.zone.local(2018, 6, 30, 23, 0, 0)) do
          expect(convert_to_hh_mm_from_sec(lsl_board.extra_working_seconds_of_this_year)).to eq '00:00'
        end
      end

      it 'count_more_than_45hours' do
        travel_to(Time.zone.local(2018, 6, 30, 23, 0, 0)) do
          expect(lsl_board.count_more_than_45hours).to eq 0
        end
      end

      it 'averages_of_extra_working_seconds' do
        travel_to(Time.zone.local(2018, 6, 30, 23, 0, 0)) do
          expect(lsl_board.averages_of_extra_working_seconds).to eq(
            [['2ヶ月', 0.0], ['3ヶ月', 0.0], ['4ヶ月', 0.0], ['5ヶ月', 0.0], ['6ヶ月', 0.0]]
          )
        end
      end
    end
  end
end

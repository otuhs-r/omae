require 'rails_helper'

RSpec.describe Api::AttendancesController, type: :controller do
  describe 'POST #create' do
    login_user

    before do
      post 'create', params: { user_id: subject.current_user.id, start_date: Time.current - 1.day, end_date: Time.current }, xhr: true
    end

    it 'returns success status.' do
      expect(response.status).to eq 200
    end

    it 'displays :dashboard template' do
      expect(response).to render_template :create
    end

    context 'when current user has no attendances' do
      it 'has zero.' do
        expect(assigns(:all_working_seconds)).to eq 0
        expect(assigns(:all_extra_working_seconds)).to eq 0
        expect(assigns(:extra_working_rate)).to eq 0
      end
    end
  end

  describe 'GET #by_day_of_week' do
    login_user

    context 'dates exists in params' do
      before do
        get 'by_day_of_week', params: { user_id: subject.current_user.id, start_date: Time.current - 1.day, end_date: Time.current }, xhr: true
      end

      it 'returns success status.' do
        expect(response.status).to eq 200
      end

      context 'when current user has no attendances' do
        it 'has zero.' do
          expect(JSON.parse(response.body)[0]).to eq(
            'data' => { 'Sun' => 0.0, 'Mon' => 0.0, 'Tue' => 0.0, 'Wed' => 0.0, 'Thu' => 0.0, 'Fri' => 0.0, 'Sat' => 0.0 }
          )
        end
      end
    end

    context 'dates does not exist in params' do
      before do
        get 'by_day_of_week', params: { user_id: subject.current_user.id }, xhr: true
      end

      it 'returns success status.' do
        expect(response.status).to eq 200
      end

      it 'assigns dates' do
        expect(assigns(:start_date)).to eq Time.current.beginning_of_month
        expect(assigns(:end_date)).to eq Time.current.at_end_of_day
      end

      context 'when current user has no attendances' do
        it 'has zero.' do
          expect(JSON.parse(response.body)[0]).to eq(
            'data' => { 'Sun' => 0.0, 'Mon' => 0.0, 'Tue' => 0.0, 'Wed' => 0.0, 'Thu' => 0.0, 'Fri' => 0.0, 'Sat' => 0.0 }
          )
        end
      end
    end
  end
end

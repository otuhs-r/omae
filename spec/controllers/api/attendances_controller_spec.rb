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
        expect(assigns(:dashboard).all_working_seconds).to eq 0
        expect(assigns(:dashboard).all_extra_working_seconds).to eq 0
        expect(assigns(:dashboard).average_extra_working_seconds).to eq 0
        expect(assigns(:dashboard).extra_working_rate).to eq 0
      end
    end
  end
end

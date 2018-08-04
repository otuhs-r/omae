require 'rails_helper'

describe UsersController, type: :controller do
  describe 'GET #dashboard' do
    context 'with authentication' do
      login_user

      before do
        get 'dashboard'
      end

      it 'returns success status.' do
        expect(response.status).to eq 200
      end

      it 'displays :index template' do
        expect(response).to render_template :dashboard
      end

      context 'when current user has no attendances' do
        it 'assigns @sum_working_hours.' do
          expect(assigns(:sum_working_hours)).to eq '00:00'
        end

        it 'assigns @sum_extra_working_hours.' do
          expect(assigns(:sum_extra_working_hours)).to eq '00:00'
        end
      end
    end
  end

  describe 'GET #show' do
    context 'with authentication' do
      login_user
      it 'returns success status' do
        get 'show'
        expect(response.status).to eq 200
      end

      it 'dispays :show template' do
        get 'show'
        expect(response).to render_template :show
      end

      it 'has expected data.' do
        get 'show'
        expect(assigns(:user_name)).to eq subject.current_user.user_name
        expect(assigns(:email)).to eq subject.current_user.email
        expect(assigns(:work_start_time)).to eq subject.current_user.work_start_time
        expect(assigns(:work_end_time)).to eq subject.current_user.work_end_time
        expect(assigns(:rest_start_time)).to eq subject.current_user.rest_start_time
        expect(assigns(:rest_end_time)).to eq subject.current_user.rest_end_time
      end
    end
  end
end

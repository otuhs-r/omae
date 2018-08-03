require 'rails_helper'

RSpec.describe AttendancesController, type: :controller do
  describe 'GET #index' do
    login_user

    before do
      get :index, params: { user_id: subject.current_user.id }
    end

    it 'returns a success response.' do
      expect(response.status).to eq 200
    end

    it 'displays :index template.' do
      expect(response).to render_template :index
    end

    context 'when current user has no attendances' do
      let!(:attendance) { create(:attendance, user: build(:user)) }

      it 'counts zero.' do
        expect(assigns(:attendances).count).to eq 0
      end
    end

    context 'when current user has two attendances' do
      let!(:attendance1) { create(:attendance, user: subject.current_user) }
      let!(:attendance2) { create(:attendance, user: subject.current_user, date: date2) }
      let(:date2) { '2018-07-30' }

      it 'counts two.' do
        expect(assigns(:attendances).count).to eq 2
      end

      it 'has expected data.' do
        expect(assigns(:attendances).first.date.to_s(:date)).to eq '2018-07-29'
        expect(assigns(:attendances).first.clock_in_time.to_s(:time)).to eq '08:55'
        expect(assigns(:attendances).first.clock_out_time.to_s(:time)).to eq '18:05'
      end
    end
  end

  describe 'GET #new' do
    login_user

    before do
      get :new, params: { user_id: subject.current_user.id, id: 1 }
    end

    it 'returns a success response.' do
      expect(response.status).to eq 200
    end

    it 'assigns new @attendance.' do
      expect(assigns(:attendance)).to be_a_new Attendance
    end

    it 'displays :new template.' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    login_user
    let(:attendance) { create(:attendance, user: subject.current_user) }

    before do
      get :edit, params: { user_id: subject.current_user.id, id: attendance.id }
    end

    it 'returns a success response.' do
      expect(response.status).to eq 200
    end

    it 'assigns @attendance.' do
      expect(assigns(:attendance)).to eq attendance
    end

    it 'displays :edit template.' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    login_user

    context 'with valid params' do
      it 'creates a new Attendance.' do
        expect do
          post :create, params: { user_id: subject.current_user.id, attendance: attributes_for(:attendance) }
        end.to change(Attendance, :count).by(1)
      end

      it 'redirects to the created attendance.' do
        post :create, params: { user_id: subject.current_user.id, attendance: attributes_for(:attendance) }
        expect(response).to redirect_to(user_attendances_path(subject.current_user.id))
      end
    end

    context 'with invalid params' do
      before do
        post :create, params: { user_id: subject.current_user.id, attendance: attributes_for(:attendance, clock_in_time: '2018-07-29 18:55') }
      end

      it 'do not create a new Attendance.' do
        expect do
          post :create, params: { user_id: subject.current_user.id, attendance: attributes_for(:attendance, clock_in_time: '2018-07-29 18:55') }
        end.to change(Attendance, :count).by(0)
      end

      it 'returns a success response.' do
        expect(response.status).to eq 200
      end

      it 'displays :new template.' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'PUT #update' do
    login_user
    let!(:attendance) { create(:attendance, user: subject.current_user) }

    context 'with valid params' do
      it 'updates the requested attendance.' do
        expect do
          patch :update, params: { user_id: subject.current_user.id,
                                   id: attendance.id,
                                   attendance: attributes_for(:attendance, clock_out_time: '2018-07-29 20:05:00') }
        end.to change(Attendance, :count).by(0)

        attendance.reload
        expect(attendance.clock_in_time.to_s(:time)).to eq '08:55'
        expect(attendance.clock_out_time.to_s(:time)).to eq '20:05'
      end

      it 'redirects to attendances.' do
        patch :update, params: { user_id: subject.current_user.id,
                                 id: attendance.id,
                                 attendance: attributes_for(:attendance, clock_out_time: '2018-07-29 20:05:00') }
        expect(response).to redirect_to(user_attendances_path(subject.current_user.id))
      end
    end

    context 'with invalid params' do
      before do
        patch :update, params: { user_id: subject.current_user.id,
                                 id: attendance.id,
                                 attendance: attributes_for(:attendance, clock_out_time: '2018-07-29 08:05:00') }
      end

      it 'returns a success respons.' do
        expect(response.status).to eq 200
      end

      it 'does not update the requested attendance.' do
        attendance.reload
        expect(attendance.clock_in_time.to_s(:time)).to eq '08:55'
        expect(attendance.clock_out_time.to_s(:time)).to eq '18:05'
      end

      it 'displays :edit template.' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    login_user
    let!(:attendance) { create(:attendance, user: subject.current_user) }

    it 'destroys the requested attendance.' do
      expect do
        delete :destroy, params: { user_id: subject.current_user.id, id: attendance.id }
      end.to change(Attendance, :count).by(-1)
    end

    it 'redirects to the attendances list' do
      delete :destroy, params: { user_id: subject.current_user.id, id: attendance.id }
      expect(response).to redirect_to(user_attendances_path(subject.current_user.id))
    end
  end
end

require 'rails_helper'

RSpec.describe AttendancesController, type: :controller do
  describe 'GET #dashboard' do
    login_user

    before do
      get 'dashboard'
    end

    it 'returns success status.' do
      expect(response.status).to eq 200
    end

    it 'displays :dashboard template' do
      expect(response).to render_template :dashboard
    end

    context 'when current user has no attendances' do
      it 'has zero.' do
        expect(assigns(:all_working_seconds)).to eq 0
        expect(assigns(:all_extra_working_seconds)).to eq 0
        expect(assigns(:extra_working_rate)).to eq 0
      end
    end
  end

  describe 'POST #clock_in_just_now' do
    login_user

    context 'when an attendance has already been recorded' do
      let!(:attendance) { create(:attendance, user: subject.current_user) }

      it 'does not create a attendance.' do
        travel_to('2018-7-29 18:00'.to_time) do
          expect do
            post :clock_in_just_now, params: { user_id: subject.current_user.id }
          end.to change(Attendance, :count).by(0)
        end
      end

      it 'returns a redirection response.' do
        travel_to('2018-7-29 18:00'.to_time) do
          post :clock_in_just_now, params: { user_id: subject.current_user.id }
          expect(response.status).to eq 302
        end
      end
    end

    context 'when an attendance has NOT been recorded' do
      it 'creates a new attemdance.' do
        expect do
          post :clock_in_just_now, params: { user_id: subject.current_user.id }
        end.to change(Attendance, :count).by(1)
      end

      it 'records current time as clock in time.' do
        travel_to('2018-9-7 9:00'.to_time) do
          post :clock_in_just_now, params: { user_id: subject.current_user.id }
          expect(Attendance.last.date).to eq Time.zone.now.to_date
          expect(Attendance.last.clock_in_time).to eq Time.zone.now
        end
      end
    end
  end

  describe 'POST #clock_out_just_now' do
    login_user

    context 'when an attendance has already been recorded' do
      let!(:attendance) { create(:attendance, user: subject.current_user) }

      it 'does not create a attendance.' do
        travel_to('2018-7-29 18:00'.to_time) do
          expect do
            post :clock_out_just_now, params: { user_id: subject.current_user.id }
          end.to change(Attendance, :count).by(0)
        end
      end

      it 'returns a redirection response.' do
        travel_to('2018-7-29 18:00'.to_time) do
          post :clock_out_just_now, params: { user_id: subject.current_user.id }
          expect(response.status).to eq 302
        end
      end

      it 'changes clock out time.' do
        travel_to('2018-7-29 18:00'.to_time) do
          post :clock_out_just_now, params: { user_id: subject.current_user.id }
          expect(Attendance.find_by(date: Time.zone.now.to_date).clock_out_time).to eq Time.zone.now
        end
      end
    end

    context 'when an attendance has NOT been recorded' do
      it 'creates a new attendance.' do
        expect do
          post :clock_out_just_now, params: { user_id: subject.current_user.id }
        end.to change(Attendance, :count).by(1)
      end

      it 'records current time as clock out time.' do
        travel_to('2018-9-7 18:00'.to_time) do
          post :clock_out_just_now, params: { user_id: subject.current_user.id }
          expect(Attendance.last.date).to eq Time.zone.now.to_date
          expect(Attendance.last.clock_out_time).to eq Time.zone.now
        end
      end
    end
  end

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

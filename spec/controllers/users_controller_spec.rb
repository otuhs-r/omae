require 'rails_helper'

describe UsersController, type: :controller do
  describe 'GET #index' do
    context 'with authentication' do
      login
      it 'redirects to root.' do
        get 'index'
        expect(response.status).to eq 302
      end

      it 'returns success status.' do
        get 'index'
        expect(response.status).to eq 200
      end

      it 'displays :index template' do
        get 'index'
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET #show' do
    context 'with authentication' do
      login
      it 'returns success status' do
        get 'show'
        expect(response.status).to eq 200
      end

      it 'dispays :show template' do
        get 'show'
        expect(response).to render_template :show
      end
    end
  end
end

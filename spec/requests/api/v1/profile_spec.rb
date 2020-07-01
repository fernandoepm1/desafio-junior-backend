require 'rails_helper'

describe 'Profile', type: :request do
  let(:current_user) { create(:user) }
  let(:new_user_params) { attributes_for(:user) }
  let(:invalid_headers) {
    {
      "Content-Type": "application/json",
      "Authorization": "Batata"
    }
  }
  let(:valid_headers) {
    {
      "Content-Type": "application/json",
      "Authorization": "#{current_user.token}"
    }
  }

  describe 'GET profile#show' do
    context 'without authorization header' do
      before { get '/api/v1/profile' }

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with an invalid authorization header' do
      before { get '/api/v1/profile', headers: invalid_headers }

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      before { get '/api/v1/profile', headers: valid_headers }

      it 'returns http status 200' do
        expect(response).to have_http_status(:success)
      end

      it 'returns profile info for current user' do
        expect(response.body.user.name).to eq(current_user.name)
        expect(response.body.user.email).to eq(current_user.email)
      end
    end
  end

  describe 'PUT profile#update' do
    context 'without authorization header' do
      before { put '/api/v1/profile', params: { user: new_user_params } }

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with an invalid authorization header' do
      before do
        put '/api/v1/profile',
          params: { user: new_user_params },
          headers: invalid_headers
      end

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      context 'but with invalid params' do
      end

      context 'and with valid params' do
      end
    end
  end

  describe 'PATCH profile#update' do
    context 'without authorization header' do
      before { patch '/api/v1/profile', params: { user: new_user_params } }

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with an invalid authorization header' do
      before do
        put '/api/v1/profile',
          params: { user: new_user_params },
          headers: invalid_headers
      end

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      context 'but with invalid params' do
        # pending
      end

      context 'and with valid params' do
        # pending
      end
    end
  end
end

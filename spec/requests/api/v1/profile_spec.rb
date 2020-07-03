require 'rails_helper'

describe 'Profile', type: :request do
  let!(:current_user) { create(:user) }
  let(:user_token) { current_user.token }
  let(:valid_user_params) { { id: current_user.id, user: attributes_for(:user) } }
  let(:invalid_user_params) { { user: attributes_for(:invalid_user) } }

  describe 'GET profile#show' do
    context 'without authorization header' do
      before { get '/api/v1/profile' }

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'renders an authorization error' do
        expect(json['error']).to_not be_empty
        expect(json['error']['message']).to match(/Missing Authorization token/)
      end
    end

    context 'with an invalid authorization header' do
      before do
        get '/api/v1/profile', headers: { 'Authorization': 'Pringles' }
      end

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'renders an authorization error' do
        expect(json['error']).to_not be_empty
        expect(json['error']['message']).to match(/Invalid token provided/)
      end
    end

    context 'with a valid authorization header' do
      before do
        get '/api/v1/profile', headers: { 'Authorization': "#{user_token}" }
      end

      it 'returns http status 200' do
        expect(response).to have_http_status(:success)
      end

      it 'returns profile info for current user' do
        expect(json['name']).to eq(current_user.name)
        expect(json['email']).to eq(current_user.email)
      end
    end
  end

  describe 'PUT profile#update' do
    context 'without authorization header' do
      before do
        put '/api/v1/profile', params: valid_user_params
      end

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'renders an authorization error' do
        expect(json['error']).to_not be_empty
        expect(json['error']['message']).to match(/Missing Authorization token/)
      end
    end

    context 'with an invalid authorization header' do
      before do
        put '/api/v1/profile', params: valid_user_params,
          headers: { 'Authorization' => 'Rapadura' }
      end

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'renders an authorization error' do
        expect(json['error']).to_not be_empty
        expect(json['error']['message']).to match(/Invalid token provided/)
      end
    end

    context 'with a valid authorization header' do
      context 'but with invalid params' do
        before do
          put '/api/v1/profile',
            params: invalid_user_params,
            headers: { 'Authorization': "#{user_token}" }
        end

        it 'returns http status 422' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns a validation error' do
          expect(json['error']).to_not be_empty
          expect(json['error']['message']).to match(/Validation failed/)
        end
      end

      context 'and with valid params' do
        before do
          put '/api/v1/profile',
            params: valid_user_params,
            headers: { 'Authorization': "#{user_token}" }

          current_user.reload
        end

        it 'returns http status 204' do
          expect(response).to have_http_status(:no_content)
        end

        it 'updates profile with given params' do
          expect(current_user.name).to eq(valid_user_params[:user][:name])
          expect(current_user.email).to eq(valid_user_params[:user][:email])
        end
      end
    end
  end

  describe 'PATCH profile#update' do
    context 'without authorization header' do
      before { patch '/api/v1/profile', params: valid_user_params }

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'renders an authorization error' do
        expect(json['error']).to_not be_empty
        expect(json['error']['message']).to match(/Missing Authorization token/)
      end
    end

    context 'with an invalid authorization header' do
      before do
        put '/api/v1/profile',
          params: valid_user_params,
          headers: { 'Authorization': 'Pizza' }
      end

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'renders an authorization error' do
        expect(json['error']).to_not be_empty
        expect(json['error']['message']).to match(/Invalid token provided/)
      end
    end

    context 'with a valid authorization header' do
      context 'but with invalid params' do
        before do
          patch '/api/v1/profile',
            params: invalid_user_params,
            headers: { 'Authorization': "#{user_token}" }
        end

        it 'returns http status 422' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns a validation error' do
          expect(json['error']).to_not be_empty
        end
      end

      context 'and with valid params' do
        before do
          patch '/api/v1/profile',
            params: valid_user_params,
            headers: { 'Authorization': "#{user_token}" }

          current_user.reload
        end

        it 'returns http status 204' do
          expect(response).to have_http_status(:no_content)
        end

        it 'updates profile with given params' do
          expect(current_user.name).to eq(valid_user_params[:user][:name])
          expect(current_user.email).to eq(valid_user_params[:user][:email])
        end
      end
    end
  end
end
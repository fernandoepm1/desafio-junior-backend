require 'rails_helper'

describe 'Messages', type: :request do
  let!(:current_user) { create(:user) }
  let(:user_token) { current_user.token }
  let!(:sent_messages) { create_list(:message, 5, from: current_user.id) }
  let!(:received_messages) { create_list(:message, 5, to: current_user.id) }
  let(:first_message) { current_user.messages.first }
  let(:valid_message_params) {
    { message: attributes_for(:api_message).merge!(receiver_email: create(:user).email) }
  }
  let(:invalid_message_params) { { message: attributes_for(:invalid_message) } }

  describe 'GET messages#index' do
    context 'without authorization header' do
      before { get '/api/v1/messages' }

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'renders an authorization error' do
        expect(json['error']).to_not be_empty
        expect(json['error']['message']).to match(/Missing Authorization token/)
      end
    end

    context 'with an invalid authorization header' do
      before { get '/api/v1/messages', headers: { 'Authorization': 'Potato' } }

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
        get '/api/v1/messages', headers: { 'Authorization': "#{user_token}" }
      end

      it 'returns http status 200' do
        expect(response).to have_http_status(:success)
      end

      it 'returns all messages received by current user' do
        expect(json.length).to eq(received_messages.size)
      end
    end
  end

  describe 'POST messages#create' do
    context 'without authorization header' do
      before { post '/api/v1/messages', params: valid_message_params }

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
        post '/api/v1/messages', params: valid_message_params, headers: { "Authorization": "42" }
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
          post '/api/v1/messages', params: invalid_message_params,
            headers: { 'Authorization': "#{user_token}" }
        end

        it 'returns http status 422' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not create a new message in the database' do
          expect {
            post '/api/v1/messages', params: valid_message_params,
            headers: { 'Authorization': 'Wafer' }
           }.to change(Message, :count).by(0)
        end

        it 'returns a validation error' do
          expect(json['error']).to_not be_empty
          expect(json['error']['message']).to match(/Validation failed/)
        end
      end

      context 'and with valid params' do
        before do
          post '/api/v1/messages', params: valid_message_params,
            headers: { 'Authorization': "#{user_token}" }
        end

        it 'returns http status 201' do
          expect(response).to have_http_status(:created)
        end

        it 'creates a new message in the database' do
          expect {
            post '/api/v1/messages', params: valid_message_params,
            headers: { 'Authorization': "#{user_token}" }
           }.to change(Message, :count).by(+1)
        end

        it 'creates a new message with the given params' do
          created_message = Message.last

          expect(created_message.receiver.email).to eq(valid_message_params[:message][:receiver_email])
          expect(created_message.title).to eq(valid_message_params[:message][:title])
          expect(created_message.content).to eq(valid_message_params[:message][:content])
        end
      end
    end
  end

  describe 'GET messages#show' do
    context 'without authorization header' do
      before { get "/api/v1/messages/#{first_message.id}" }

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
        get "/api/v1/messages/#{first_message.id}",
          headers: { "Authorization": "Strogonoff" }
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
      context 'but the record does not exist' do
        before do
          get "/api/v1/messages/#{id = 0}", headers: { 'Authorization': "#{user_token}" }
        end

        it 'returns http status 404' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns an error' do
          expect(json['error']).to_not be_empty
          expect(json['error']['message']).to match(/Couldn't find Message/)
        end
      end

      context 'and the record exists' do
        before do
          get "/api/v1/messages/#{first_message.id}",
            headers: { 'Authorization': "#{user_token}" }
        end

        it 'returns http status 200' do
          expect(response).to have_http_status(:success)
        end

        it 'returns a single message' do
          message_ids = json.keys.select { |k| k == 'id' }
          expect(message_ids.size).to eq(1)
        end

        it 'returns the first message sent to current user' do
          expect(json['id']).to eq(first_message.id)
          expect(json['title']).to eq(first_message.title)
          expect(json['content']).to eq(first_message.content)
        end
      end
    end
  end

  describe 'GET messages#sent' do
    context 'without authorization header' do
      before { get '/api/v1/messages/sent' }

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
        get '/api/v1/messages/sent', headers: { 'Authorization': 'Pamonha' }
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
        get '/api/v1/messages/sent', headers: { 'Authorization': "#{user_token}" }
      end

      it 'returns http status 200' do
        expect(response).to have_http_status(:success)
      end

      it 'returns all messages sent by current user' do
        expect(json).to_not be_empty
        expect(json.size).to eq(current_user.messages_sent.size)
      end
    end
  end
end
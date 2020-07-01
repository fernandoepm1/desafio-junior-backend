require 'rails_helper'

describe 'Messages', type: :request do
  let(:current_user) { create(:user) }
  let(:sent_messages) { create_list(:message, 69, from: current_user) }
  let(:received_messages) { create_list(:message, 69, to: current_user) }
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

  describe 'GET messages#index' do
    context 'without authorization header' do
      before { get '/api/v1/messages' }

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with an invalid authorization header' do
      before { get '/api/v1/messages', headers: invalid_headers }

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      before { get '/api/v1/messages', headers: valid_headers }

      it 'returns http status 200' do
        expect(response).to have_http_status(:success)
      end

      it 'returns all messages received by current user' do
        expect(response.body.size).to_be eq(current_user.messages.size)
      end
    end
  end

  describe 'POST messages#create' do
    context 'without authorization header' do
      before { post '/api/v1/messages', params: { message: '' } }

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with an invalid authorization header' do
      before do
        post '/api/v1/messages',
          params: { message: '' },
          headers: invalid_headers
      end

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      context 'but with invalid params' do
        before do
          post '/api/v1/messages',
            params: { message: attributes_for(:invalid_message) },
            headers: valid_headers
        end

        it 'returns http status 301' do
          expect(response).to have_http_status(:unproccessable_entity)
        end
      end

      context 'and with valid params' do
        before do |request|
          post '/api/v1/messages',
            params: { message: attributes_for(:message) },
            headers: valid_headers
        end

        it 'returns http status 201' do
          expect(response).to have_http_status(:created)
        end

        it 'creates a new message in the database' do
          expect(request).to change { Message.count }.by(1)
        end

        it 'create a new message with the given params' do
          created_message = Message.last

          expect(created_message.title).to_be eq(valid_params.title)
          expect(created_message.content).to_be eq(valid_params.content)
        end
      end
    end
  end

  describe 'GET messages#show' do
    context 'without authorization header' do
      before { get '/api/v1/messages/1' }

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with an invalid authorization header' do
      before { get '/api/v1/messages/1' }

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      before { get '/api/v1/messages/1' }
      let(:first_message) { current_user.messages.first }

      it 'returns http status 200' do
        expect(response).to have_http_status(:success)
      end

      it 'returns a single message' do
        expect(response.body.size).to_be eq(1)
      end

      it 'returns the first message sent to current user' do
        expect(response.body.title).to_be eq(first_message.title)
        expect(response.body.content).to_be eq(first_message.content)
      end
    end
  end

  describe 'GET messages#sent' do
    context 'without authorization header' do
      before { get '/api/v1/messages/sent' }

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with an invalid authorization header' do
      before { get '/api/v1/messages/sent', headers: invalid_headers }

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      before { get '/api/v1/messages/sent', headers: valid_headers }

      it 'returns http status 200' do
        expect(response).to have_http_status(:success)
      end

      it 'returns all messages sent by current user' do
        expect(response.body.size).to eq(current_user.sent_messages.size)
      end
    end
  end
end

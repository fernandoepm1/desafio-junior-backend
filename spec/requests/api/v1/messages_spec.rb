require 'rails_helper'

describe 'Messages', type: :request do
  let!(:current_user) { create(:user) }
  let(:sent_messages) { create_list(:message, 69, from: current_user) }
  let(:received_messages) { create_list(:message, 69, to: current_user) }
  let(:first_message) { current_user.messages.first }
  let(:valid_message_params) { attributes_for(:message) }
  let(:invalid_message_params) { attributes_for(:invalid_message) }

  describe 'GET messages#index' do
    context 'without authorization header' do
      before { get '/api/v1/messages' }

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with an invalid authorization header' do
      before { get '/api/v1/messages', headers: { "Authorization": "Potato" } }

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      before do
        get '/api/v1/messages',
          headers: { "Authorization": "#{current_user.token}" }
      end

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
          headers: { "Authorization": "42" }
      end

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      context 'but with invalid params' do
        before do |request|
          post '/api/v1/messages',
            params: { message: invalid_message_params },
            headers: {
              "Content-Type": "application/json",
              "Authorization": "#{current_user.token}"
            }
        end

        it 'returns http status 422' do
          expect(response).to have_http_status(:unproccessable_entity)
        end

        it 'does not create a new message in the database' do
          expect { request }.to_not change(Message, :count).by(+1)
        end

        it 'returns a validation error' do
          expect(json['errors']).to_not be_empty
          expect(json['errors']).to match(//) #=> Ver erro
        end
      end

      context 'and with valid params' do
        before do |request|
          post '/api/v1/messages',
            params: { message: valid_message_params },
            headers: {
              "Content-Type": "application/json",
              "Authorization": "#{current_user.token}"
            }
        end

        it 'returns http status 201' do
          expect(response).to have_http_status(:created)
        end

        it 'creates a new message in the database' do
          expect { request }.to change(Message, :count).by(+1)
        end

        it 'creates a new message with the given params' do
          expect(Message.last).to have_attributes valid_message_params[:message]
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
    end

    context 'with an invalid authorization header' do
      before do
        get "/api/v1/messages/#{first_message.id}",
          headers: { "Authorization": "Strogonoff" }
      end

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      context 'but the record does not exist' do
        before do
          get "/api/v1/messages/#{id = 0}",
            headers: { "Authorization": "#{current_user.token}" }
        end

        it 'returns http status 404' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns an error' do
          expect(json['errors']).to_not be_empty
        end
      end

      context 'and the record exists' do
        before do
          get "/api/v1/messages/#{first_message.id}",
            headers: { "Authorization": "#{current_user.token}" }
        end

        it 'returns http status 200' do
          expect(response).to have_http_status(:success)
        end

        it 'returns a single message' do
          expect(json.size).to_be eq(1)
        end

        it 'returns the first message sent to current user' do
          expect(json['id']).to_be eq(first_message.id)
          expect(json['title']).to_be eq(first_message.title)
          expect(json['content']).to_be eq(first_message.content)
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
    end

    context 'with an invalid authorization header' do
      before do
        get '/api/v1/messages/sent', headers: { "Authorization": "Pamonha" }
      end

      it 'returns http status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      before do
        get '/api/v1/messages/sent',
          headers: { "Authorization": "#{current_user.token}" }
      end

      it 'returns http status 200' do
        expect(response).to have_http_status(:success)
      end

      it 'returns all messages sent by current user' do
        expect(json).to_not be_empty
        expect(json.size).to eq(current_user.sent_messages.size)
      end
    end
  end
end
class Api::V1::MessagesController < Api::V1::ApiController
  before_action :set_message, only: :show

  # GET /api/v1/messages
  def index
    @messages = Message.sent_to(current_user).ordered
    json_renderer(@messages)
  end

  # POST /api/v1/messages
  def create
    set_message_receiver if message_params[:receiver_email].present?
    @message = Message.create!(@final_message_params)
    json_renderer(@message, :created)
  end

  # GET /api/v1/messages/:id
  def show
    json_renderer(@message)
  end

  # GET /api/v1/messages/sent
  def sent
    @sent_messages = Message.sent_from(current_user).ordered
    json_renderer(@sent_messages)
  end

  private

  def set_message
    @message = current_user.messages.find(params[:id])
  end

  def set_message_receiver
    receiver = User.find_by(email: message_params[:receiver_email])

    @final_message_params = message_params.except('receiver_email')
      .merge!(from: current_user.id, to: receiver.id)
  end

  def message_params
    params.require(:message).permit(
      :receiver_email,
      :title,
      :content
    )
  end
end

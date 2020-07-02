class Api::V1::ProfileSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :sent_messages, :received_messages

  def sent_messages
    Message.sent_from(object).size
  end

  def received_messages
    object.messages.size
  end
end

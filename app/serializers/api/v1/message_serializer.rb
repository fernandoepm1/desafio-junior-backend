class Api::V1::MessageSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :to

  def to
    Api::V1::SimpleProfileSerializer.new(object.receiver)
  end
end

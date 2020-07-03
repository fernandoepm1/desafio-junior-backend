class Api::V1::MessageSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :from, :to

  def from
    Api::V1::SimpleProfileSerializer.new(object.sender)
  end

  def to
    Api::V1::SimpleProfileSerializer.new(object.receiver)
  end
end

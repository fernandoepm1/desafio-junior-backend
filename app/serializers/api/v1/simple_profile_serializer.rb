class Api::V1::SimpleProfileSerializer < ActiveModel::Serializer
  attributes :id, :name, :email
end

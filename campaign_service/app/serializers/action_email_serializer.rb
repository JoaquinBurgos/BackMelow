class ActionEmailSerializer < ActiveModel::Serializer
  attributes :id, :subject, :body
end
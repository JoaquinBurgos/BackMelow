class CampaignSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :customer_group_id, :first_node_id
  has_many :nodes
  has_many :conditions
end

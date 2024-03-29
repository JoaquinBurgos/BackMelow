class NodeSerializer < ActiveModel::Serializer
  attributes :id, :campaign_id, :next_node_id, :action_type, :action_id
  belongs_to :campaign
  attribute :action do
    action = object.action
    case object.action_type
    when 'ActionEmail'
      ActionEmailSerializer.new(action).as_json
    when 'ActionWait'
      ActionWaitSerializer.new(action).as_json
    else
      nil
    end
  end
end
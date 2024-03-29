class Node < ApplicationRecord
  belongs_to :campaign
  belongs_to :next_node, class_name: 'Node', optional: true
  has_one :previous_node, class_name: 'Node', foreign_key: 'next_node_id'
  belongs_to :action, polymorphic: true, optional: true
end

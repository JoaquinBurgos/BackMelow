class Campaign < ApplicationRecord
    belongs_to :first_node, class_name: 'Node', optional: true
    validates :name, presence: true
    has_many :nodes
    has_many :campaign_conditions
    has_many :conditions, through: :campaign_conditions
end

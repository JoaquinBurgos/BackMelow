class Campaign < ApplicationRecord
    belongs_to :first_node, class_name: 'Node', optional: true
    validates :name, presence: true
    has_many :nodes, dependent: :destroy
    has_many :conditions, dependent: :destroy
    has_many :user_campaign_progress, dependent: :destroy
end

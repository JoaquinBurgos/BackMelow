class User < ApplicationRecord
    has_many :user_campaign_progresses
    has_many :campaigns, through: :user_campaign_progresses
    has_many :user_activities
end

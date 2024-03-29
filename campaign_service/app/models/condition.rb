class Condition < ApplicationRecord
    has_many :campaign_conditions
    has_many :campaigns, through: :campaign_conditions
end

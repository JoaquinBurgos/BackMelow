class CampaignCondition < ApplicationRecord
  belongs_to :campaign
  belongs_to :condition
end

class UserCampaignProgress < ApplicationRecord
  belongs_to :user
  belongs_to :campaign
  belongs_to :node, optional: true
end

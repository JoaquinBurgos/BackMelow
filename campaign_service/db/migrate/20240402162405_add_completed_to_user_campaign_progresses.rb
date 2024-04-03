class AddCompletedToUserCampaignProgresses < ActiveRecord::Migration[6.0]
  def change
    add_column :user_campaign_progresses, :completed, :boolean
  end
end

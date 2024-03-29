class CreateUserCampaignProgresses < ActiveRecord::Migration[6.0]
  def change
    create_table :user_campaign_progresses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :campaign, null: false, foreign_key: true
      t.references :node, null: false, foreign_key: true
      t.datetime :last_updated_at

      t.timestamps
    end
  end
end

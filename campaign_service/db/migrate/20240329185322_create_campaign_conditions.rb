class CreateCampaignConditions < ActiveRecord::Migration[6.0]
  def change
    create_table :campaign_conditions do |t|
      t.belongs_to :campaign, null: false, foreign_key: true
      t.belongs_to :condition, null: false, foreign_key: true

      t.timestamps
    end
  end
end

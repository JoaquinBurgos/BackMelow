class CreateCampaigns < ActiveRecord::Migration[6.0]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.text :description
      t.bigint :customer_group_id

      t.timestamps
    end
  end
end

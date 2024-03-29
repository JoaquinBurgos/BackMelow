class AddFirstNodeToCampaigns < ActiveRecord::Migration[6.0]
  def change
    add_column :campaigns, :first_node_id, :integer
    add_index :campaigns, :first_node_id
  end
end

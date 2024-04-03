class ChangeConditionsToBelongToCampaignDirectly < ActiveRecord::Migration[6.0]
  def change
    # Solo elimina la tabla si estás seguro de que no se necesita.
    drop_table :campaign_conditions

    # Añadir campaign_id a la tabla conditions.
    add_reference :conditions, :campaign, null: false, index: true, foreign_key: true
  end
end

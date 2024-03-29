class CreateConditions < ActiveRecord::Migration[6.0]
  def change
    create_table :conditions do |t|
      t.string :event_type
      t.string :criteria_key
      t.string :criteria_value

      t.timestamps
    end
  end
end

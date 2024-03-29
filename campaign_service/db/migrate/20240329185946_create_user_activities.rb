class CreateUserActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :user_activities do |t|
      t.integer :user_id
      t.string :event_type
      t.jsonb :data

      t.timestamps
    end
  end
end

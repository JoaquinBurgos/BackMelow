class CreateActionWaits < ActiveRecord::Migration[6.0]
  def change
    create_table :action_waits do |t|
      t.integer :duration

      t.timestamps
    end
  end
end

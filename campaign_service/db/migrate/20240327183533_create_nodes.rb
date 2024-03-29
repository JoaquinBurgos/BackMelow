class CreateNodes < ActiveRecord::Migration[6.0]
  def change
    create_table :nodes do |t|
      t.references :campaign, null: false, foreign_key: true
      t.references :next_node, foreign_key: { to_table: :nodes }, optional: true
      t.references :action, polymorphic: true, null: false

      t.timestamps
    end
  end
end

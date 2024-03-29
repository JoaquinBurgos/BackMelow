class CreateActionEmails < ActiveRecord::Migration[6.0]
  def change
    create_table :action_emails do |t|
      t.string :subject
      t.text :body

      t.timestamps
    end
  end
end

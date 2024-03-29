class ChangeUserIdToReferenceInUserActivities < ActiveRecord::Migration[6.0]
  def change
    remove_column :user_activities, :user_id, :integer if column_exists?(:user_activities, :user_id)
    add_reference :user_activities, :user, foreign_key: true
  end
end

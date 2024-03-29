require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it "has many user activities" do
      user = create(:user)
      create(:user_activity, user: user)
      create(:user_activity, user: user, event_type: 'logout')

      expect(user.user_activities.length).to eq(2)
      expect(user.user_activities.first.event_type).to eq('login')
      expect(user.user_activities.second.event_type).to eq('logout')
    end
  end
end

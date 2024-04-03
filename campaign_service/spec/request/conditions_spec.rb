require 'rails_helper'

RSpec.describe "Conditions", type: :request do
  let!(:campaign) { create(:campaign) }
  let!(:condition) { create(:condition, campaign: campaign) }

  describe "POST /campaigns/:campaign_id/conditions" do
    let(:valid_attributes) { { event_type: 'EventType', criteria_key: 'Key1', criteria_value: 'Value1' } }

    context "with valid parameters" do
      it "creates a new Condition" do
        expect {
          post campaign_conditions_path(campaign), params: { condition: valid_attributes }
        }.to change(Condition, :count).by(1)

        expect(response).to have_http_status(:created)
        campaign.reload  
        expect(campaign.conditions.exists?(event_type: 'EventType', criteria_key: 'Key1', criteria_value: 'Value1')).to be true
      end
    end
  end

  describe "PUT /campaigns/:campaign_id/conditions/:id" do
    let(:new_attributes) { { event_type: 'UpdatedEventType', criteria_key: 'UpdatedKey', criteria_value: 'UpdatedValue' } }

    context "with valid parameters" do
      it "updates the requested condition" do
        put campaign_condition_path(campaign, condition), params: { condition: new_attributes }
        condition.reload

        expect(condition.event_type).to eq('UpdatedEventType')
        expect(condition.criteria_key).to eq('UpdatedKey')
        expect(condition.criteria_value).to eq('UpdatedValue')
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "DELETE /campaigns/:campaign_id/conditions/:id" do
    it "destroys the requested condition" do
      expect {
        delete campaign_condition_path(campaign, condition)
      }.to change(Condition, :count).by(-1)

      expect(response).to have_http_status(:no_content)
      campaign.reload  
      expect(campaign.conditions).not_to include(condition)
    end
  end
end

# spec/requests/campaigns_spec.rb
require 'rails_helper'

RSpec.describe "Campaigns", type: :request do
  describe 'POST /campaigns' do
    let(:valid_attributes) { { name: 'New Campaign', description: 'Description of new campaign', customer_group_id: 1 } }
  
    context 'when the request is valid' do
      before do
        post campaigns_path, params: { campaign: valid_attributes }
      end
  
      it 'creates a new campaign' do
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq('New Campaign')
        # Verifica otros atributos relevantes...
      end
    end
  
    context 'when the request is invalid' do
      before { post campaigns_path, params: { campaign: { name: '' } } }
  
      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to include("can't be blank")
      end
    end
  end
  describe "GET /campaigns/:id" do
    let!(:campaign) { create(:campaign) }
    let!(:action_email1) { create(:action_email, subject: "First Email Subject", body: "First email body") }
    let!(:action_email2) { create(:action_email, subject: "Second Email Subject", body: "Second email body") }
    let!(:action_wait) { create(:action_wait, duration: 15) }
    let!(:node1) { create(:node, campaign: campaign, action: action_email1) }
    let!(:node2) { create(:node, campaign: campaign, action: action_email2) }
    let!(:node3) { create(:node, campaign: campaign, action: action_wait) }

    before do
      get campaign_path(campaign)
    end

    it "returns the campaign with nodes and actions of correct types and details" do
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(campaign.id)
      expect(json_response['nodes'].length).to eq(3)

      email_nodes = json_response['nodes'].select { |node| node['action_type'] == 'ActionEmail' }
      wait_nodes = json_response['nodes'].select { |node| node['action_type'] == 'ActionWait' }

      expect(email_nodes.count).to eq(2)
      expect(wait_nodes.count).to eq(1)

      # Verificar los subjects de los ActionEmails
      expect(email_nodes[0]['action']['subject']).to eq("First Email Subject")
      expect(email_nodes[1]['action']['subject']).to eq("Second Email Subject")

      # Verificar la duración del ActionWait
      expect(wait_nodes[0]['action']['duration']).to eq(15)
    end
  end
end


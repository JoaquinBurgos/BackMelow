require 'rails_helper'
require 'timecop'

RSpec.describe CampaignMonitorWorker, type: :worker do
  let!(:user) { create(:user) }
  let!(:campaign) { create(:campaign) }
  let!(:condition) { create(:condition, campaign: campaign) }
  let!(:action_email) { create(:action_email) }
  let!(:action_wait) { create(:action_wait, duration: 3) } # Duración en minutos para la espera.
  let!(:node1) { create(:node, campaign: campaign, action: action_email) }
  let!(:node2) { create(:node, campaign: campaign, action: action_wait) }
  let!(:node3) { create(:node, campaign: campaign, action: action_email) }

  before do
    node1.update(next_node_id: node2.id)
    node2.update(next_node_id: node3.id)
    campaign.update(first_node: node1)
    
    allow(Campaign).to receive(:includes).with(:conditions).and_return(Campaign.where(id: campaign.id))
    allow_any_instance_of(CampaignMonitorWorker).to receive(:all_conditions_met?).and_return(true)
  end

  it 'does not advance past the wait node until the wait duration has passed' do
    # Primera iteración: avanza al primer nodo (action_email).
    CampaignMonitorWorker.new.perform
    user_progress = UserCampaignProgress.find_by(user: user, campaign: campaign)
    expect(user_progress.node).to eq(node2)

    # Segunda iteración: intenta avanzar al segundo nodo (action_wait) y debería quedarse ahí.
    CampaignMonitorWorker.new.perform
    user_progress.reload
    expect(user_progress.node).to eq(node2)

    # No avanzar al tercer nodo aún porque no ha pasado el tiempo de espera.
    expect(user_progress.node).not_to eq(node3)

    # Viajar en el tiempo para superar el período de espera.
    Timecop.travel(2.minutes.from_now) do
      # Tercera iteración después del tiempo de espera: debería seguir en node2 hasta que se ejecute nuevamente.
      CampaignMonitorWorker.new.perform
      user_progress.reload
      expect(user_progress.node).to eq(node2)

      # Cuarta iteración: ahora debería avanzar al tercer nodo.
    end
    Timecop.travel(3.minutes.from_now) do
			CampaignMonitorWorker.new.perform
			user_progress.reload
			expect(user_progress.node).to eq(node3)
			expect(user_progress.completed).to eq(nil)
    end
		CampaignMonitorWorker.new.perform
		user_progress.reload
		expect(user_progress.completed).to eq(true)
  end
end

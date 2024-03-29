require 'rails_helper'

RSpec.describe "Nodes", type: :request do
  describe "Adding nodes to a campaign" do
    let!(:campaign) { create(:campaign) }
    
    it "adds nodes correctly and navigates through them starting from the first node" do
      # Crear Nodo 1 (Email)
      post "/campaigns/#{campaign.id}/nodes", params: {
        node: {
          action_type: 'ActionEmail',
          action: {
            subject: 'Email 1 Subject',
            body: 'Email 1 Body'
          }
        }
      }
      expect(response).to have_http_status(:created)
      node1_id = JSON.parse(response.body)["id"]
      
      # Crear Nodo 2 (Email)
      post "/campaigns/#{campaign.id}/nodes", params: {
        node: {
          action_type: 'ActionEmail',
          action: {
            subject: 'Email 2 Subject',
            body: 'Email 2 Body'
          },
          parent_node_id: node1_id
        }
      }
      expect(response).to have_http_status(:created)
      node2_id = JSON.parse(response.body)["id"]

      # Crear Nodo 3 (Wait)
      post "/campaigns/#{campaign.id}/nodes", params: {
        node: {
          action_type: 'ActionWait',
          action: {
            duration: 5
          },
          parent_node_id: node2_id
        }
      }
      expect(response).to have_http_status(:created)
      node3_id = JSON.parse(response.body)["id"]
      
      # Verificar los valores de las acciones para cada nodo creado
      [node1_id, node2_id, node3_id].each_with_index do |node_id, index|
        get "/campaigns/#{campaign.id}/nodes/#{node_id}"
        json_response = JSON.parse(response.body)
        case index
        when 0, 1 # Nodo 1 y Nodo 2 son de tipo Email
          expect(json_response.dig('action', 'subject')).to eq("Email #{index + 1} Subject")
        when 2 # Nodo 3 es de tipo Wait
          expect(json_response.dig('action', 'duration')).to eq(5)
        end
      end
      
      # Navegar desde el primer nodo al último
      current_node_id = campaign.reload.first_node_id
      expected_node_ids = [node1_id, node2_id, node3_id]
			get "/campaigns/#{campaign.id}"
        json_response = JSON.parse(response.body)
      expected_node_ids.each do |expected_node_id|
        get "/campaigns/#{campaign.id}/nodes/#{current_node_id}"
        json_response = JSON.parse(response.body)
        expect(json_response["id"]).to eq(expected_node_id)
        current_node_id = json_response["next_node_id"]
      end
      
      # El último nodo no debería tener un next_node_id
      expect(current_node_id).to be_nil
    end
  end
	describe "POST /campaigns/:campaign_id/nodes" do
    let(:campaign) { create(:campaign) }
		let(:action_email) { create(:action_email) }
		let(:action_wait) { create(:action_wait) }
    let!(:parent_node) { create(:node, campaign: campaign, action: action_email) }
    let!(:following_node) { create(:node, campaign: campaign, next_node_id: nil, action: action_wait) }

    before do
      # Configurar inicialmente el parent_node para que apunte al following_node
      parent_node.update!(next_node_id: following_node.id)

      # La petición POST para insertar el nuevo nodo entre parent_node y following_node
      post "/campaigns/#{campaign.id}/nodes", params: {
        node: {
          action_type: 'ActionEmail',
          action: {
            subject: 'Email Subject',
            body: 'Email Body'
          },
          parent_node_id: parent_node.id
        }
      }
    end

    it "inserts the new node between parent_node and following_node" do
      parent_node.reload
      following_node.reload
			json_response = JSON.parse(response.body)
      new_node_id = json_response['id'] 
   		new_node = Node.find(new_node_id)
      expect(parent_node.next_node_id).to eq(new_node.id)
      expect(new_node.next_node_id).to eq(following_node.id)
    end
  end
	describe "DELETE /campaigns/:campaign_id/nodes/:id" do
    let!(:campaign) { create(:campaign) }
		let!(:action_email) { create(:action_email) }
    let!(:node) { create(:node, campaign: campaign, action: action_email) }

    it "deletes the node and sets first_node_id to nil for the campaign" do
      expect(campaign.nodes.count).to eq(1) # Asegura que hay un nodo antes de eliminar

      delete campaign_node_path(campaign_id: campaign.id, id: node.id)

      expect(response).to have_http_status(:ok)
      campaign.reload
      expect(campaign.first_node_id).to be_nil
      expect(campaign.nodes.count).to eq(0)
    end
  end
	describe "DELETE /campaigns/:campaign_id/nodes/:id (with three nodes)" do
    let!(:campaign) { create(:campaign) }
		let!(:action_email) { create(:action_email) }
		let!(:action_email2) { create(:action_email) }
		let!(:action_wait) { create(:action_wait) }
    let!(:first_node) { create(:node, campaign: campaign, action: action_email) }
    let!(:second_node) { create(:node, campaign: campaign, action: action_email2) }
    let!(:third_node) { create(:node, campaign: campaign, action: action_wait) }

    before do
      campaign.update(first_node_id: first_node.id)
      first_node.update!(next_node_id: second_node.id)
      second_node.update!(next_node_id: third_node.id)
    end

    it "deletes the first node and updates the campaign to start from the second node" do
      delete campaign_node_path(campaign_id: campaign.id, id: first_node.id)

      expect(response).to have_http_status(:ok)
      campaign.reload
      expect(campaign.first_node_id).to eq(second_node.id)
      # Asegurarse de que se puede recorrer desde el nuevo first_node hasta el último
      current_node = campaign.nodes.find(campaign.first_node_id)
      expect(current_node).to eq(second_node)
      expect(current_node.next_node_id).to eq(third_node.id)
    end
  end
	describe "POST /campaigns/:campaign_id/nodes" do
    # Prueba para insertar un nodo en una campaña vacía
    context "when adding a node to an empty campaign" do
      let!(:campaign) { create(:campaign) }
      
      it "creates the node as the first node of the campaign" do
        expect {
          post campaign_nodes_path(campaign_id: campaign.id), params: { 
            node: { 
              action_type: "ActionEmail", 
              action: { subject: "Welcome!", body: "This is a welcome email." }
            } 
          }
        }.to change(Node, :count).by(1)
        
        expect(campaign.reload.first_node_id).not_to be_nil
        new_node = Node.last
        expect(new_node.action_type).to eq("ActionEmail")
        # Verificar otros atributos según sea necesario
      end
    end

    # Prueba para añadir un nuevo nodo en una campaña que ya tiene un nodo
    context "when adding a node to a campaign with an existing node" do
      let!(:campaign) { create(:campaign) }
			let!(:action_email) { create(:action_email) }
      let!(:existing_node) { create(:node, campaign: campaign, action: action_email) }
			
      it "adds the new node and updates the campaign's first node if it was nil" do
				campaign.update(first_node_id: existing_node.id)
        post campaign_nodes_path(campaign_id: campaign.id), params: { 
          node: { 
            action_type: "ActionEmail", 
            action: { subject: "Follow-up", body: "This is a follow-up email." },
          } 
        }
				responde = JSON.parse(response.body)
        expect(campaign.first_node_id).to eq(existing_node.id)
        new_node = Node.find(responde['id'])
        expect(new_node).not_to be_nil
        expect(new_node.reload.next_node_id).to eq(existing_node.id)
      end
    end
  end
	describe "Creating and updating a Node" do
		let!(:campaign) { create(:campaign) }
	
		it "creates a node and then updates it, ensuring the old action is deleted" do
			# Paso 1: Crear el nodo
			post "/campaigns/#{campaign.id}/nodes", params: {
				node: {
					action_type: "ActionEmail",
					action: { subject: "Hello", body: "Initial body" }
				}
			}
			
			expect(response).to have_http_status(:created)
			node_response = JSON.parse(response.body)
			original_action_id = node_response.dig('action', 'id') # Guarda la ID de la acción original
	
			# Asume que has almacenado las acciones de forma que puedas consultarlas directamente
			# Esto podría ser ActionEmail.find(original_action_id) o un modelo Action genérico, dependiendo de tu implementación
			original_action = ActionEmail.find_by(id: original_action_id)
			expect(original_action).not_to be_nil
	
			# Paso 2: Actualizar el nodo
			new_subject = "Updated subject"
			patch "/campaigns/#{campaign.id}/nodes/#{node_response['id']}", params: {
				node: {
					action_type: "ActionEmail",
					action: { subject: new_subject, body: "Updated body" }
				}
			}
	
			expect(response).to have_http_status(:ok)
	
			# Verifica que la acción original ha sido eliminada
			# Cambia 'ActionEmail' por tu modelo de acción si es necesario
			expect(ActionEmail.exists?(original_action_id)).to be_falsey
		end
	end
end

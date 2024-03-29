# Crear una campaña
campaign = Campaign.create(name: "My Campaign", description: "Campaign Description", customer_group_id: 1)

# Crear acciones
action_email1 = ActionEmail.create(subject: "Email 1 Subject", body: "Email 1 Body")
action_email2 = ActionEmail.create(subject: "Email 2 Subject", body: "Email 2 Body")
action_wait = ActionWait.create(duration: 5)

# Crear nodos asociados a la campaña y acciones
node1 = Node.create(action: action_email1, campaign: campaign)
node2 = Node.create(action: action_email2, campaign: campaign, next_node: node2)
node3 = Node.create(action: action_wait, campaign: campaign, next_node: nil)

# Asegurarse de que el primer nodo de la campaña se establezca correctamente
campaign.update(first_node_id: node1.id)

# Establecer `next_node_id` para crear una secuencia de nodos
node1.update(next_node: node2)
node2.update(next_node: node3)

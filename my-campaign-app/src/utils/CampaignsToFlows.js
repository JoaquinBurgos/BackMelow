export const orderNodes = (nodes, firstNodeId) => {
    let orderedNodes = [];
    let currentId = firstNodeId;

    while (currentId != null) {
        const currentNode = nodes.find(node => node.id === currentId);
        if (!currentNode) break;

        orderedNodes.push(currentNode);
        currentId = currentNode.next_node_id;
    }

    return orderedNodes;
};

export const transformCampaignToFlowElements = (campaign) => {
    const orderedNodes = orderNodes(campaign.nodes, campaign.first_node_id);
    let nodes = [];
    let edges = [];
    let last_node_id = null;
    // Define colores para cada tipo de acción
    const actionTypeColors = {
        'ActionEmail': 'lightblue',
        'ActionWait': 'lightgreen',
        // Añade colores para los nodos especiales
        'Trigger': 'lightcoral',
        'AddNode': 'lightyellow',
    };

    // Nodo inicial para editar la condición de trigger
    nodes.push({
        id: 'trigger',
        type: 'default', // Este tipo puede ser personalizado para diferenciar los nodos especiales
        data: { label: 'Editar Trigger' },
        position: { x: 250, y: 0 }, // Este nodo siempre estará al principio
        style: {
            background: actionTypeColors['Trigger'],
            borderColor: '#333',
            borderWidth: 2,
            borderStyle: 'solid',
            color: '#000',
        },
    });

    let yOffset = 100; // Comienza a posicionar los siguientes nodos más abajo

    orderedNodes.forEach((node, index) => {
        // Transforma el nodo de campaña en un nodo de React Flow
        nodes.push({
            id: node.id.toString(),
            type: 'default',
            data: { label: `${node.action_type === 'ActionEmail' ? node.action.subject : 'Espera: ' + node.action.duration + 's'}` },
            position: { x: 250, y: yOffset + index * 100 },
            style: {
                background: actionTypeColors[node.action_type],
                borderColor: '#333',
                borderWidth: 2,
                borderStyle: 'solid',
                color: '#000',
            },
        });
        last_node_id = node.id.toString();
        if (node.next_node_id) {
            edges.push({
                id: `e${node.id}-${node.next_node_id}`,
                source: node.id.toString(),
                target: node.next_node_id.toString(),
                animated: true,
                style: { stroke: '#000' },
            });
        }
    });

    if (orderedNodes.length > 0) {
        // Conecta el trigger con el primer nodo
        edges.push({
            id: 'eTrigger-firstNode',
            source: 'trigger',
            target: orderedNodes[0].id.toString(),
            animated: true,
            style: { stroke: '#ff0066' }, // Color de ejemplo para este edge especial
        });

        // Conecta el último nodo con el nodo de añadir
        const lastNodeId = orderedNodes[orderedNodes.length - 1].id.toString();
        edges.push({
            id: `e${lastNodeId}-addNode`,
            source: lastNodeId,
            target: 'addNode',
            animated: true,
            style: { stroke: '#ffcc00' }, // Color de ejemplo para este edge especial
        });
    }

    // Añade el nodo final para añadir nuevos nodos
    const lastNodePosition = orderedNodes.length > 0 ? yOffset + orderedNodes.length * 100 : 100;
    nodes.push({
        id: 'addNode',
        type: 'default',
        data: { label: 'Añadir Nodo' },
        position: { x: 250, y: lastNodePosition },
        style: {
            background: actionTypeColors['AddNode'],
            borderColor: '#333',
            borderWidth: 2,
            borderStyle: 'solid',
            color: '#000',
        },
    });

    return { nodes, edges, last_node_id};
};
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
    const actionTypeColors = {
        'ActionEmail': 'lightblue',
        'ActionWait': 'lightgreen',
        'Trigger': '#EEADD1',
        'AddNode': '#CB803D',
    };

    nodes.push({
        id: 'trigger',
        label: 'Condition Manager',
        type: 'default', 
        data: { label: 'Campaign Rules' },
        position: { x: 250, y: 0 }, 
        style: {
            background: actionTypeColors['Trigger'],
            borderColor: '#333',
            borderWidth: 2,
            borderStyle: 'solid',
            color: '#000',
        },
    });

    let yOffset = 100; 

    orderedNodes.forEach((node, index) => {
        nodes.push({
            id: node.id.toString(),
            type: 'default',
            action: node.action,
            data:{
                label: (
                  <div style={{
                    overflow: 'hidden', 
                    textOverflow: 'ellipsis', 
                  }}>
                    {node.action_type === 'ActionEmail'
                      ? 'Send Email: ' + node.action.subject
                      : 'Wait: ' + node.action.duration + 'm'}
                  </div>
                )
              },
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
        edges.push({
            id: 'eTrigger-firstNode',
            source: 'trigger',
            target: orderedNodes[0].id.toString(),
            animated: true,
            style: { stroke: '#ff0066' }, 
        });

        const lastNodeId = orderedNodes[orderedNodes.length - 1].id.toString();
        edges.push({
            id: `e${lastNodeId}-addNode`,
            source: lastNodeId,
            target: 'addNode',
            animated: true,
            style: { stroke: '#ffcc00' }, 
        });
    }

    const lastNodePosition = orderedNodes.length > 0 ? yOffset + orderedNodes.length * 100 : 100;
    nodes.push({
        id: 'addNode',
        type: 'default',
        label: 'Node Creator',
        data: { label: 'Add Node' },
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
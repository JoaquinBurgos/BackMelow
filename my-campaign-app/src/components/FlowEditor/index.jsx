import React, { useState } from 'react';
import { Card } from 'antd';
import ReactFlow from 'react-flow-renderer';
import { transformCampaignToFlowElements } from '../../utils/CampaignsToFlows';
import NodeDetail from '../NodeDetail';
const NodeFlowEditor = ({ campaign, onNodeCreated }) => {
    const { nodes, edges, last_node_id } = transformCampaignToFlowElements(campaign);
    const [selectedNode, setSelectedNode] = useState(null);
    const onNodeClick = (event, element) => {
        console.log('Element clicked:', element);
        setSelectedNode(element);
    };
    return (
        <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh', gap: '20px' }}>
            <div style={{ width: '500px', height: '500px', background: '#e5e5e5' }}>
                <ReactFlow
                    nodes={nodes}
                    edges={edges}
                    fitView
                    style={{ width: '100%', height: '100%' }}
                    onNodeClick={onNodeClick}
                />
            </div>
            <Card
                title="Editor de Nodos"
                style={{ width: 300, height: '500px' }} // Ajusta la altura para alinearla con el área de ReactFlow si es necesario
            >
                {selectedNode ? (
                    <NodeDetail node={selectedNode} onNodeCreated={onNodeCreated} last_node_id={last_node_id} setSelectedNode={setSelectedNode}/>
                ) : (
                    <p>Elige algún nodo que quieras editar.</p>
                )}
            </Card>
        </div>
    );
};

export default NodeFlowEditor;
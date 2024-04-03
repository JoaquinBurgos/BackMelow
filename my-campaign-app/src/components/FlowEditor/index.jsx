import React, { useState } from 'react';
import { Card } from 'antd';
import ReactFlow from 'react-flow-renderer';
import { transformCampaignToFlowElements } from '../../utils/CampaignsToFlows';
import NodeDetail from '../NodeDetail';
import styles from './index.module.scss';

const NodeFlowEditor = ({ campaign, onResourceCreated }) => {
    const { nodes, edges, last_node_id } = transformCampaignToFlowElements(campaign);
    const [selectedNode, setSelectedNode] = useState(null);
    const onNodeClick = (event, element) => {
        console.log('Element clicked:', element);
        setSelectedNode(element);
    };

    return (
        <div className={styles.nodeFlowContainer}>
            <div className={styles.flowWrapper}>
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
                className={styles.editorCard}
            >
                {selectedNode ? (
                    <NodeDetail node={selectedNode} onResourceCreated={onResourceCreated} last_node_id={last_node_id} setSelectedNode={setSelectedNode} conditions={campaign.conditions}/>
                ) : (
                    <p>Elige algún nodo que quieras editar.</p>
                )}
            </Card>
        </div>
    );
};

export default NodeFlowEditor;

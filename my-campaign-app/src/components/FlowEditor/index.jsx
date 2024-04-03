import React, { useState, useEffect } from 'react';
import { UserOutlined } from '@ant-design/icons';
import { Card } from 'antd';
import ReactFlow from 'react-flow-renderer';
import { transformCampaignToFlowElements } from '../../utils/CampaignsToFlows';
import NodeDetail from '../NodeDetail';
import styles from './index.module.scss';

const NodeFlowEditor = ({ campaign, onResourceCreated }) => {
    const { nodes, edges, last_node_id } = transformCampaignToFlowElements(campaign);
    const [selectedNode, setSelectedNode] = useState(null);
    const [userCount, setUserCount] = useState(0);
    const onNodeClick = (event, element) => {
        console.log('Element clicked:', element);
        setSelectedNode(element);
    };

    useEffect(() => {
        console.log(selectedNode)
        if (selectedNode) {
            const count = campaign.user_campaign_progress.filter(progress => progress.node_id === parseInt(selectedNode.id)).length;
            setUserCount(count);
        }
    }, [selectedNode, campaign.user_campaign_progress]);

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
                title={
                    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                        <span>Node Editor</span>
                        {selectedNode && (
                            <div style={{ display: 'flex', alignItems: 'center' }}>
                                <UserOutlined style={{ marginRight: '5px' }} />
                                <span>{userCount}</span>
                            </div>
                        )}
                    </div>
                }
                className={styles.editorCard}
            >
                {selectedNode ? (
                    <NodeDetail node={selectedNode} onResourceCreated={onResourceCreated} last_node_id={last_node_id} setSelectedNode={setSelectedNode} conditions={campaign.conditions} />
                ) : (
                    <p>Elige algún nodo que quieras editar.</p>
                )}
            </Card>
        </div>
    );
};

export default NodeFlowEditor;

import React, { useState, useEffect } from 'react';
import { Card, Button, Divider } from 'antd';
import _ from 'lodash';
import { useParams } from 'react-router-dom';
import AddNodeForm from './addNodeForm'; 
import API from '../../services/Api';
import styles from './index.module.scss';
import CampaignConditions from './CampaignConditions'; 
const NodeDetail = ({ node, onResourceCreated, last_node_id, setSelectedNode,conditions }) => {
    let { campaignId } = useParams();
    const [showForm, setShowForm] = useState(false);
    const isNodeIdNumeric = node.id && !isNaN(Number(node.id));

    useEffect(() => {
        setShowForm(false);
    }, [node]);

    if (!node) {
        return <p>Selecciona un nodo para ver los detalles.</p>;
    }
    const onCancel = () => {
        setShowForm(false);
    };
    const handleSubmit = (values) => {
        const parent_node_id = node.id === 'addNode' ? last_node_id : node.id;

        const actionProps = values.actionType === 'ActionEmail' ? _.pick(values, ['subject', 'body']) : { duration: values.duration };
        const new_node = {
            node: {
                action_type: values.actionType,
                action: actionProps,
                parent_node_id: parseInt(parent_node_id, 10)
            }
        };
        console.log('Nuevo nodo:', new_node);
        API.post(`/campaigns/${parseInt(campaignId, 10)}/nodes`, new_node)
            .then(res => {
                console.log('Node created:', res.data);
                onResourceCreated();
                setShowForm(false); 
            })
            .catch(err => console.error(err));
    };

    const handleDeleteNode = () => {
        API.delete(`/campaigns/${campaignId}/nodes/${node.id}`)
            .then(() => {
                console.log('Nodo eliminado correctamente');
                onResourceCreated(); 
                setSelectedNode(null); 
            })
            .catch(err => {
                console.error(err);
                console.log('Hubo un error al intentar eliminar el nodo');
            });
    };
    return (
        <Card className={styles.nodeDetail}>
            <p className={styles.title}><strong>Type:</strong> {node.action ? (node.action?.subject? 'Mailer' : 'Wait'): node.label}</p>
            {node.action ? (node.action?.subject? <p className={styles.subject}><strong>Subject:</strong> {node.action?.subject}</p> :<p><strong>Waiting time: </strong>{node.action?.duration} minutes</p>) : null}
            {node.action?.body? <p className={styles.body}><strong>Body:</strong> {node.action?.body}</p>: null}
            {node.id === 'trigger' && <CampaignConditions conditions={conditions} onResourceCreated={onResourceCreated}/>}
            {node.id === 'addNode' || showForm ? (
                <AddNodeForm onSubmit={handleSubmit} onCancel={onCancel} />
            ) : (
                <>
                    <Button type="primary" style={{ marginRight: '10px'}} onClick={() => setShowForm(true)}>Insert Next Node</Button>
                    {isNodeIdNumeric && (
                        <Button danger onClick={handleDeleteNode}>
                            Delete Node
                        </Button>
                    )}
                </>
            )}
        </Card>
    );
};

export default NodeDetail;

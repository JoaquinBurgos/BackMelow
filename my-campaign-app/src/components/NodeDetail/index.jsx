import React, { useState } from 'react';
import { Card, Button } from 'antd';
import _ from 'lodash';
import { useParams } from 'react-router-dom';
import AddNodeForm from './addNodeForm'; // Asegúrate de ajustar la ruta de importación según la estructura de tu proyecto
import API from '../../services/Api';

const NodeDetail = ({ node, onNodeCreated, last_node_id, setSelectedNode }) => {
    let { campaignId } = useParams();
    const [showForm, setShowForm] = useState(false);
    console.log('Node:', node);
    const isNodeIdNumeric = node.id && !isNaN(Number(node.id));
    if (!node) {
        return <p>Selecciona un nodo para ver los detalles.</p>;
    }

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
                onNodeCreated();
                setShowForm(false); // Oculta el formulario después de crear el nodo
            })
            .catch(err => console.error(err));
    };

    const handleDeleteNode = () => {
        API.delete(`/campaigns/${campaignId}/nodes/${node.id}`)
            .then(() => {
                console.log('Nodo eliminado correctamente');
                onNodeCreated(); // Actualiza la UI para reflejar la eliminación del nodo
                setSelectedNode(null); // Deselecciona el nodo eliminado
            })
            .catch(err => {
                console.error(err);
                console.log('Hubo un error al intentar eliminar el nodo');
            });
    };
    return (
        <Card title="Detalles del Nodo" style={{ width: 300 }}>
            {node.id === 'addNode' || showForm ? (
                <AddNodeForm onSubmit={handleSubmit} />
            ) : (
                <>
                    <p><strong>Tipo:</strong> {node.data.label}</p>
                    {/* Añade más detalles del nodo aquí */}
                    <Button type="primary" onClick={() => setShowForm(true)}>Insertar Nodo</Button>
                    {isNodeIdNumeric && (
                        <Button danger onClick={handleDeleteNode}>
                            Eliminar Nodo
                        </Button>
                    )}
                </>
            )}
        </Card>
    );
};

export default NodeDetail;

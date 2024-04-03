import React, { useState } from 'react';
import { List, Button, Typography, Popconfirm, Divider } from 'antd';
import { DeleteOutlined } from '@ant-design/icons';
import { useParams } from 'react-router-dom';
import AddConditionForm from './addConditionForm';
import API from '../../../services/Api';

const { Text } = Typography;

const NodeConditions = ({ conditions, onResourceCreated, onResourceDeleted }) => {
  const [open, setOpen] = useState(false);
  let { campaignId } = useParams();

  const onCreate = (values) => {
    setOpen(false);
    const condition = { event_type: values.event_type, criteria_key: values.event_type, criteria_value: values.value };
    API.post(`/campaigns/${campaignId}/conditions`, { condition: condition })
      .then(response => {
        console.log('Condition created:', response.data);
        onResourceCreated();
      })
      .catch(error => {
        console.error('Error creating condition:', error);
      });
  };

  const deleteCondition = (conditionId) => {
    API.delete(`/campaigns/${campaignId}/conditions/${conditionId}`)
      .then(() => {
        console.log('Condition deleted');
        onResourceCreated();
      })
      .catch(error => {
        console.error('Error deleting condition:', error);
      });
  };

  return (
    <>
      <List
        dataSource={conditions}
        renderItem={condition => (
          <List.Item
            key={condition.id}
            actions={[
              <Popconfirm
                title="Are you sure you want to delete this condition?"
                onConfirm={() => deleteCondition(condition.id)}
                okText="Sí"
                cancelText="No"
              >
                <Button type="danger" icon={<DeleteOutlined />}>Eliminar</Button>
              </Popconfirm>
            ]}
          >
            <List.Item.Meta
              title={`Condition Type: ${condition.event_type === 'last_login' ? 'Last Login' : condition.event_type === 'page_visit' ? 'Page Visit' : 'Time since account creation'}`}
              description={`${condition.event_type === 'page_visit' ? 'Url:' : 'Time: '} ${condition.criteria_value} ${condition.event_type === 'page_visit' ? '' : 'days'}`}
            />
          </List.Item>
        )}
      />
      <AddConditionForm
        open={open}
        onCreate={onCreate}
        onCancel={() => setOpen(false)}
      />
      <Divider />
      <Button type="primary" style={{ marginRight: '10px', marginBottom: '10px' }} onClick={() => setOpen(true)}>Add Condition</Button>
    </>
  );
};

export default NodeConditions;

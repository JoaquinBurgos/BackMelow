import React, { useEffect, useState } from 'react';
import { Card, Row, Col, Typography, Divider, Button, Popconfirm } from 'antd';
import { useNavigate } from 'react-router-dom';
import { PlusOutlined, DeleteOutlined, EyeOutlined } from '@ant-design/icons';
import API from '../../services/Api';
import AddCampaignModal from './AddCampaign';
import styles from './index.module.scss';

const { Title } = Typography;

const CampaignList = () => {
  const [campaigns, setCampaigns] = useState([]);
  const [isModalVisible, setIsModalVisible] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    fetchCampaigns();
  }, []);

  const fetchCampaigns = () => {
    API.get('/campaigns')
      .then(res => setCampaigns(res.data))
      .catch(err => console.error(err));
  };

  const handleNavigate = (campaignId, event) => {
    event.stopPropagation();
    navigate(`/campaigns/${campaignId}`);
  };

  const handleDeleteCampaign = (campaignId, event) => {
    event.stopPropagation();
    API.delete(`/campaigns/${campaignId}`)
      .then(() => fetchCampaigns())
      .catch(err => console.error(err));
  };

  const showModal = () => {
    setIsModalVisible(true);
  };

  const handleCreate = (values) => {
    API.post('/campaigns', values)
      .then(() => {
        fetchCampaigns();
        setIsModalVisible(false);
      })
      .catch(err => console.error(err));
  };

  return (
    <div className={styles.campaignListContainer}>
      <Title level={2}>Campaigns</Title>
      <Divider className={styles.divider}/>
      <Row gutter={[16, 16]}>
        {campaigns.map((item) => (
          <Col key={item.id} xs={24} sm={12} md={8} xl={4}>
            <Card
              className={styles.campaignCard}
              bordered={false}
              actions={[
                <EyeOutlined key="view" onClick={(e) => handleNavigate(item.id, e)} />,
                <Popconfirm
                  title="Are you sure you want to delete this campaign?"
                  onConfirm={(e) => handleDeleteCampaign(item.id, e)}
                  onCancel={(e) => e.stopPropagation()}
                  okText="Yes"
                  cancelText="No"
                >
                  <DeleteOutlined key="delete" onClick={(e) => e.stopPropagation()} />
                </Popconfirm>
              ]}
            >
              <Card.Meta title={item.name} description={item.description} />
            </Card>
          </Col>
        ))}
        <Col style={{ display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
          <Button className={styles.addButton} onClick={showModal}>
            <PlusOutlined />
          </Button>
        </Col>
      </Row>
      <AddCampaignModal
        isVisible={isModalVisible}
        onCreate={handleCreate}
        onCancel={() => setIsModalVisible(false)}
      />
    </div>
  );
};

export default CampaignList;

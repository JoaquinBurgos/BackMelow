import React, { useEffect, useState } from 'react';
import { Card, Row, Col, Typography, Divider, Button } from 'antd';
import { useNavigate } from 'react-router-dom';
import { PlusOutlined } from '@ant-design/icons';
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

  const handleCardClick = (campaignId) => {
    navigate(`/campaigns/${campaignId}`);
  };

  const showModal = () => {
    setIsModalVisible(true);
  };

  const handleCreate = (values) => {
    API.post('/campaigns', values)
      .then(() => {
        // Recarga la lista de campañas desde el servidor después de crear una nueva.
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
          <Col key={item.id} xs={24} sm={12} md={8} xl={4} style={{ marginBottom: 16 }}>
            <Card
              className={styles.campaignCard}
              onClick={() => handleCardClick(item.id)}
              hoverable
              title={item.name}
              bordered={false}
            >
              {item.description}
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

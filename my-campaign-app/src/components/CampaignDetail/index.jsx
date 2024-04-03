import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Typography, Spin, Divider, Button } from 'antd';
import { LeftOutlined } from '@ant-design/icons';
import NodeFlowEditor from '../FlowEditor';
import styles from './index.module.scss';
import API from '../../services/Api';

const { Title } = Typography;

const CampaignDetail = () => {
  const { campaignId } = useParams();
  const [campaign, setCampaign] = useState(null);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  const fetchCampaign = () => {
    API.get(`/campaigns/${campaignId}`)
      .then(res => {
        setCampaign(res.data);
        setLoading(false);
      })
      .catch(err => {
        console.error(err);
        setLoading(false);
      });
  };
  console.log(campaign)
  useEffect(() => {
    fetchCampaign();
  }, [campaignId]);

  const handleResourceCreation = () => {
    fetchCampaign(); 
  };

  const goBack = () => navigate(-1);

  if (loading) {
    return <Spin size="large" />;
  }

  return (
    <div className={styles.campaignDetailContainer}>
      <div onClick={goBack} className={styles.goBackButton}>
        <LeftOutlined /> Return to the list
      </div>
      {campaign && (
        <>
          <Title level={2}>{campaign.name}</Title>
          <Divider className={styles.divider}/>
          <p>{campaign.description}</p>
          <NodeFlowEditor campaign={campaign} onResourceCreated={handleResourceCreation}/>
        </>
      )}
    </div>
  );
};

export default CampaignDetail;

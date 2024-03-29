// Dentro de src/components/CampaignDetail.js

import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import axios from 'axios';
import { Typography, Spin } from 'antd';
import NodeFlowEditor from '../FlowEditor';
import API from '../../services/Api';

const { Title } = Typography;

const CampaignDetail = () => {
  const { campaignId } = useParams();
  const [campaign, setCampaign] = useState(null);
  const [loading, setLoading] = useState(true);

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

  useEffect(() => {
    fetchCampaign();
  }, [campaignId]);

  const handleNodeCreation = () => {
    fetchCampaign(); 
  };

  if (loading) {
    return <Spin size="large" />;
  }

  return (
    <div>
      {campaign && (
        <>
          <Title level={2}>{campaign.name}</Title>
          <p>{campaign.description}</p>
          <NodeFlowEditor campaign={campaign} onNodeCreated={handleNodeCreation}/>
        </>
      )}
    </div>
  );
};

export default CampaignDetail;

// src/components/CampaignList.js
import React, { useEffect, useState } from 'react';
import { List, Typography } from 'antd';
import API from '../../services/Api';
const { Title } = Typography;

const CampaignList = () => {
  const [campaigns, setCampaigns] = useState([]);

  useEffect(() => {
    API.get('/campaigns')
      .then(res => setCampaigns(res.data))
      .catch(err => console.error(err));
  }, []);
  console.log(campaigns);
  return (
    <div>
      <Title level={2}>Campaigns</Title>
      <List
        itemLayout="horizontal"
        dataSource={campaigns}
        renderItem={item => (
          <List.Item>
            <List.Item.Meta
              title={<a href={`/campaigns/${item.id}`}>{item.name}</a>}
              description={item.description}
            />
          </List.Item>
        )}
      />
    </div>
  );
};

export default CampaignList;

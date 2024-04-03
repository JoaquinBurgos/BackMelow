import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import CampaignList from './components/CampaignList';
import CampaignDetail from './components/CampaignDetail';

function App() {
  return (
    <Router>
      <div>
        <Routes>
          <Route path="/campaigns/:campaignId" element={<CampaignDetail />} />
          <Route path="/" element={<CampaignList />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;

import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import CampaignList from './components/CampaignList';
import CampaignDetail from './components/CampaignDetail';
// Importarás aquí los demás componentes a medida que los crees.

function App() {
  return (
    <Router>
      <div>
        <Routes>
          <Route path="/campaigns/:campaignId" element={<CampaignDetail />} />
          <Route path="/" element={<CampaignList />} />
          {/* Puedes añadir más rutas según sea necesario */}
        </Routes>
      </div>
    </Router>
  );
}

export default App;

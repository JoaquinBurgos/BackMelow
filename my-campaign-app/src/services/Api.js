// src/services/api.js
import axios from 'axios';

const API = axios.create({
  baseURL: 'http://localhost:3001', // Asegúrate de cambiar esto por la URL base de tu backend
});

export default API;

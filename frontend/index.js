const express = require('express');
const axios = require('axios');
const app = express();
const PORT = 80;

// SRE: The backend service URL should be configurable, not hardcoded.
// We will inject this via a Kubernetes ConfigMap or Env Var.
const BACKEND_URL = process.env.BACKEND_API_URL || 'http://localhost:8080';

app.get('/', async (req, res) => {
    let backendData = {};
    try {
        // Call the backend service
        const response = await axios.get(`${BACKEND_URL}/api/data`);
        backendData = response.data;
    } catch (error) {
        console.error('Error fetching data from backend:', error.message);
        backendData = { error: 'Could not reach backend' };
    }

    res.send(`
        <h1>Frontend Service</h1>
        <p>Data from backend: <pre>${JSON.stringify(backendData, null, 2)}</pre></p>
    `);
});

// SRE: Health check endpoint
app.get('/healthz', (req, res) => {
    res.status(200).send('OK');
});

app.listen(PORT, () => {
    console.log(`Frontend service listening on port ${PORT}`);
    console.log(`Configured backend URL: ${BACKEND_URL}`);
});
const express = require('express');
const cors    = require('cors');
const fetch   = require('node-fetch');
const path    = require('path');

const app  = express();
const PORT = process.env.PORT || 3737;

app.use(cors());
app.use(express.json());

// ── Painel HTML estático ──────────────────────────────────────
app.use(express.static(path.join(__dirname, 'public')));

// ── Healthcheck ───────────────────────────────────────────────
app.get('/health', (req, res) => res.json({ status: 'ok' }));

// ── Proxy para a API do Zendesk ───────────────────────────────
app.get('/zd/:zdpath(*)', async (req, res) => {
  const { subdomain, email, token } = req.headers;

  if (!subdomain || !email || !token) {
    return res.status(400).json({ error: 'Headers subdomain, email e token são obrigatórios.' });
  }

  const zdPath = req.params.zdpath;

  // Repassa a query string EXATAMENTE como chegou, sem recodificar
  // Isso preserva datas como "2026-03-20T03:00:00.000Z" corretamente
  const rawQuery = req.url.includes('?') ? req.url.slice(req.url.indexOf('?')) : '';
  const zdURL = `https://${subdomain}.zendesk.com/${zdPath}${rawQuery}`;

  const creds = Buffer.from(`${email}/token:${token}`).toString('base64');

  console.log(`[proxy] GET ${zdURL}`);

  try {
    const zdRes = await fetch(zdURL, {
      headers: {
        'Authorization': `Basic ${creds}`,
        'Content-Type':  'application/json',
        'Accept':        'application/json',
      },
    });

    const data = await zdRes.json();

    if (!zdRes.ok) {
      console.error(`[proxy] Zendesk ${zdRes.status}:`, JSON.stringify(data));
      return res.status(zdRes.status).json(data);
    }

    res.json(data);
  } catch (err) {
    console.error('[proxy] Erro:', err.message);
    res.status(500).json({ error: err.message });
  }
});

app.listen(PORT, () => {
  console.log('');
  console.log('  ✅  Proxy Zendesk rodando!');
  console.log(`  🌐  Painel em: http://localhost:${PORT}`);
  console.log(`  💓  Health:   http://localhost:${PORT}/health`);
  console.log('');
});

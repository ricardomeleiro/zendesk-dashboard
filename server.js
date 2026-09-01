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

// ── Healthcheck & Config ──────────────────────────────────────
app.get('/health', (req, res) => res.json({ status: 'ok' }));

app.get('/config', (req, res) => {
  const envSubdomain = process.env.ZENDESK_SUBDOMAIN || process.env.SUBDOMAIN || '';
  const envToken     = process.env.ZENDESK_OAUTH_TOKEN || process.env.ZENDESK_TOKEN || process.env.OAUTH_TOKEN || '';

  res.json({
    hasEnvConfig: Boolean(envSubdomain && envToken),
    subdomain: envSubdomain
  });
});

// ── Proxy para a API do Zendesk (OAuth Bearer Token) ─────────
app.get('/zd/:zdpath(*)', async (req, res) => {
  const subdomain = req.headers.subdomain || process.env.ZENDESK_SUBDOMAIN || process.env.SUBDOMAIN;
  const token     = req.headers.token     || process.env.ZENDESK_OAUTH_TOKEN || process.env.ZENDESK_TOKEN || process.env.OAUTH_TOKEN;

  if (!subdomain || !token) {
    return res.status(400).json({ error: 'Subdomínio e Token OAuth não foram fornecidos via header ou ENV.' });
  }

  const zdPath = req.params.zdpath;

  // Repassa a query string EXATAMENTE como chegou, sem recodificar
  const rawQuery = req.url.includes('?') ? req.url.slice(req.url.indexOf('?')) : '';
  const zdURL = `https://${subdomain}.zendesk.com/${zdPath}${rawQuery}`;

  console.log(`[proxy] GET ${zdURL}`);

  try {
    const zdRes = await fetch(zdURL, {
      headers: {
        'Authorization': `Bearer ${token}`,
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

/**
 * Vercel 서버리스 함수: 펀치리스트 Google Apps Script 프록시
 *
 * 기본 엔드포인트: /api/punchlist
 * - GET  /api/punchlist?action=getAll
 * - GET  /api/punchlist?action=getById&id=PL-2025-001
 * - POST /api/punchlist (body: { action: 'create' | 'update' | 'delete' | 'addComment', ... })
 */

const { URL } = require('url');

const fetchFn = (...args) => {
  if (typeof fetch !== 'undefined') {
    return fetch(...args);
  }
  return import('node-fetch').then(({ default: nodeFetch }) => nodeFetch(...args));
};

const PUNCHLIST_SCRIPT_URL =
  process.env.PUNCHLIST_SCRIPT_URL ||
  'https://script.google.com/macros/s/AKfycbxarys6e5oeI8jt7PHeO11H2LfMW0-P2lhX-NMApVX9-Ir97jnIlgtnElu70LZnUqRa/exec';

module.exports = async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  res.setHeader('Access-Control-Allow-Methods', 'GET,POST,OPTIONS');

  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  const method = req.method.toUpperCase();
  const targetUrl = new URL(PUNCHLIST_SCRIPT_URL);

  if (method === 'GET') {
    Object.entries(req.query || {}).forEach(([key, value]) => {
      targetUrl.searchParams.set(key, value);
    });
  }

  const fetchOptions = { method };

  if (method === 'POST') {
    fetchOptions.headers = {
      'Content-Type': 'application/json'
    };

    let payload = {};

    if (req.body && typeof req.body === 'object') {
      payload = { ...req.body };
    } else {
      payload = await new Promise((resolve, reject) => {
        let raw = '';
        req.on('data', chunk => {
          raw += chunk;
        });
        req.on('end', () => {
          if (!raw) {
            resolve({});
            return;
          }
          try {
            resolve(JSON.parse(raw));
          } catch (error) {
            reject(error);
          }
        });
        req.on('error', reject);
      }).catch(error => {
        console.error('Failed to parse request body:', error);
        return {};
      });
    }

    fetchOptions.body = JSON.stringify(payload);
  }

  try {
    const response = await fetchFn(targetUrl.toString(), fetchOptions);
    const text = await response.text();

    let parsed;
    try {
      parsed = text ? JSON.parse(text) : {};
    } catch (parseError) {
      parsed = { raw: text };
    }

    res.status(response.status).json(parsed);
  } catch (error) {
    console.error('punchlist proxy error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to contact Google Apps Script.',
      message: error.message
    });
  }
};

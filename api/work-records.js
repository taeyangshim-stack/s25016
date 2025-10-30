/**
 * Vercel 서버리스 함수: Google Apps Script 근무기록 프록시
 *
 * 엔드포인트: /api/work-records
 * - GET  /api/work-records?action=getAllRecords
 * - GET  /api/work-records?action=getEmployees
 * - GET  /api/work-records?action=getLocations
 * - POST /api/work-records?action=update   (body: record payload)
 * - POST /api/work-records?action=delete   (body: { timestamp, rowNumber })
 */

const { URL } = require('url');

const fetchFn = (...args) => {
  if (typeof fetch !== 'undefined') {
    return fetch(...args);
  }
  return import('node-fetch').then(({ default: nodeFetch }) => nodeFetch(...args));
};

const GOOGLE_SCRIPT_URL =
  process.env.GOOGLE_SCRIPT_URL ||
  'https://script.google.com/macros/s/AKfycbygAg88Vk2cJwhkDUJQPn2OO18J9IhzvF0l85otx4khWGh8y4XxAJhpQlOZnVvATxQ/exec';

module.exports = async (req, res) => {
  // 공통 CORS 헤더
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  res.setHeader('Access-Control-Allow-Methods', 'GET,POST,OPTIONS');

  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  const method = req.method.toUpperCase();
  const url = new URL(GOOGLE_SCRIPT_URL);

  // action 우선 추출 (query 우선, body 보조)
  const queryAction = req.query.action;
  const bodyAction = req.body && typeof req.body === 'object' ? req.body.action : undefined;
  const action =
    queryAction ||
    bodyAction ||
    (method === 'GET' ? 'getAllRecords' : undefined);

  if (!action) {
    res.status(400).json({ error: 'Missing action parameter.' });
    return;
  }

  url.searchParams.set('action', action);

  // GET 요청 시 기타 쿼리 파라미터 전달
  if (method === 'GET') {
    Object.entries(req.query || {}).forEach(([key, value]) => {
      if (key !== 'action') {
        url.searchParams.set(key, value);
      }
    });
  }

  const fetchOptions = {
    method,
    headers: {}
  };

  if (method === 'POST') {
    fetchOptions.headers['Content-Type'] = 'application/json';
    let payload = {};

    if (req.body && typeof req.body === 'object') {
      payload = Array.isArray(req.body) ? req.body : { ...req.body };
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

    if (!Array.isArray(payload)) {
      delete payload.action;
    }

    fetchOptions.body = JSON.stringify(payload);
  }

  try {
    const response = await fetchFn(url.toString(), fetchOptions);
    const text = await response.text();

    let parsed;
    try {
      parsed = text ? JSON.parse(text) : {};
    } catch (parseError) {
      parsed = { raw: text };
    }

    if (!response.ok) {
      res.status(response.status).json({
        error: 'Upstream request failed.',
        status: response.status,
        payload: parsed
      });
      return;
    }

    res.status(200).json(parsed);
  } catch (error) {
    console.error('work-records proxy error:', error);
    res.status(500).json({
      error: 'Failed to contact Google Apps Script.',
      message: error.message
    });
  }
};

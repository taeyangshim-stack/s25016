/**
 * Vercel 서버리스 함수: 지출결의서 Notion API 프록시
 *
 * 엔드포인트: /api/notion-expense
 * - GET  /api/notion-expense?action=getAll
 * - GET  /api/notion-expense?action=getById&id=xxx
 * - GET  /api/notion-expense?action=getByTrip&tripId=xxx
 * - POST /api/notion-expense (body: { action: 'create' | 'update' | 'delete', ... })
 *
 * 환경변수:
 * - NOTION_API_KEY: Notion Integration Token
 * - NOTION_EXPENSE_DATABASE_ID: 지출결의서 데이터베이스 ID
 */

const { Client } = require('@notionhq/client');

const notion = new Client({
  auth: process.env.NOTION_API_KEY
});

const DATABASE_ID = process.env.NOTION_EXPENSE_DATABASE_ID;

// Notion 페이지를 지출결의서 객체로 변환
function pageToExpense(page) {
  const props = page.properties;

  const getText = (prop) => {
    if (!prop) return '';
    if (prop.type === 'title') {
      return (prop.title || []).map(t => t.plain_text || '').join('');
    }
    if (prop.type === 'rich_text') {
      return (prop.rich_text || []).map(t => {
        if (t.href) {
          return `[${t.plain_text}](${t.href})`;
        }
        return t.plain_text || '';
      }).join('');
    }
    return '';
  };

  const getSelect = (prop) => prop?.select?.name || '';
  const getNumber = (prop) => prop?.number || 0;
  const getDate = (prop) => prop?.date?.start || '';
  const getRelation = (prop) => {
    if (!prop || prop.type !== 'relation') return [];
    return (prop.relation || []).map(r => r.id);
  };
  const getFiles = (prop) => {
    if (!prop || prop.type !== 'files') return [];
    return (prop.files || []).map(f => ({
      name: f.name,
      url: f.file?.url || f.external?.url || ''
    }));
  };

  return {
    id: page.id,
    createdTime: page.created_time,
    lastEditedTime: page.last_edited_time,
    // 기본 정보
    title: getText(props['제목']),
    tripIds: getRelation(props['출장신청서']),
    documentNumber: getText(props['문서번호']),
    requestNumber: getText(props['신청번호']),
    draftDate: getDate(props['기안일']),
    drafter: getSelect(props['기안자']),
    status: getSelect(props['상태']),
    // 지출 합계
    totalToll: getNumber(props['총교통비']),
    totalFuel: getNumber(props['총유류비']),
    totalAllowance: getNumber(props['총출장비']),
    totalMeal: getNumber(props['총식대']),
    grandTotal: getNumber(props['총합계']),
    // 일별 지출 내역
    expenseDetail: getText(props['지출내역']),
    // 유류비 계산 정보
    fuelPrice: getNumber(props['유류단가']),
    fuelEfficiency: getNumber(props['연비']),
    fuelPriceSource: getText(props['유류단가출처']),
    // 첨부 및 비고
    receipts: getFiles(props['영수증첨부']),
    remarks: getText(props['비고']),
    // 회계 정보
    voucherNumber: getText(props['전표번호']),
    voucherType: getSelect(props['전표유형']),
    postingDate: getDate(props['기표일자']),
    accountCode: getText(props['계정과목']),
    costCenter: getText(props['코스트센터'])
  };
}

// 지출결의서 객체를 Notion 속성으로 변환
function expenseToProperties(data) {
  const properties = {};

  if (data.title !== undefined) {
    properties['제목'] = { title: [{ text: { content: data.title } }] };
  }
  if (data.tripIds !== undefined) {
    properties['출장신청서'] = {
      relation: data.tripIds.map(id => ({ id }))
    };
  }
  if (data.documentNumber !== undefined) {
    properties['문서번호'] = { rich_text: [{ text: { content: data.documentNumber } }] };
  }
  if (data.requestNumber !== undefined) {
    properties['신청번호'] = { rich_text: [{ text: { content: data.requestNumber } }] };
  }
  if (data.draftDate !== undefined) {
    properties['기안일'] = { date: { start: data.draftDate } };
  }
  if (data.drafter !== undefined) {
    properties['기안자'] = { select: { name: data.drafter } };
  }
  if (data.status !== undefined) {
    properties['상태'] = { select: { name: data.status } };
  }
  if (data.totalToll !== undefined) {
    properties['총교통비'] = { number: data.totalToll };
  }
  if (data.totalFuel !== undefined) {
    properties['총유류비'] = { number: data.totalFuel };
  }
  if (data.totalAllowance !== undefined) {
    properties['총출장비'] = { number: data.totalAllowance };
  }
  if (data.totalMeal !== undefined) {
    properties['총식대'] = { number: data.totalMeal };
  }
  if (data.expenseDetail !== undefined) {
    properties['지출내역'] = { rich_text: [{ text: { content: data.expenseDetail } }] };
  }
  if (data.fuelPrice !== undefined) {
    properties['유류단가'] = { number: data.fuelPrice };
  }
  if (data.fuelEfficiency !== undefined) {
    properties['연비'] = { number: data.fuelEfficiency };
  }
  if (data.fuelPriceSource !== undefined) {
    properties['유류단가출처'] = { rich_text: [{ text: { content: data.fuelPriceSource } }] };
  }
  if (data.remarks !== undefined) {
    properties['비고'] = { rich_text: [{ text: { content: data.remarks } }] };
  }
  if (data.voucherNumber !== undefined) {
    properties['전표번호'] = { rich_text: [{ text: { content: data.voucherNumber } }] };
  }
  if (data.voucherType !== undefined) {
    properties['전표유형'] = { select: { name: data.voucherType } };
  }
  if (data.postingDate !== undefined) {
    properties['기표일자'] = { date: { start: data.postingDate } };
  }
  if (data.accountCode !== undefined) {
    properties['계정과목'] = { rich_text: [{ text: { content: data.accountCode } }] };
  }
  if (data.costCenter !== undefined) {
    properties['코스트센터'] = { rich_text: [{ text: { content: data.costCenter } }] };
  }

  return properties;
}

// 전체 목록 조회
async function getAll(filter = {}) {
  const queryOptions = {
    database_id: DATABASE_ID,
    sorts: [{ property: '기안일', direction: 'descending' }]
  };

  // 상태 필터
  if (filter.status) {
    queryOptions.filter = {
      property: '상태',
      select: { equals: filter.status }
    };
  }

  const response = await notion.databases.query(queryOptions);
  return response.results.map(pageToExpense);
}

// 단건 조회
async function getById(pageId) {
  const page = await notion.pages.retrieve({ page_id: pageId });
  return pageToExpense(page);
}

// 출장신청서별 조회
async function getByTrip(tripId) {
  const queryOptions = {
    database_id: DATABASE_ID,
    filter: {
      property: '출장신청서',
      relation: { contains: tripId }
    },
    sorts: [{ property: '기안일', direction: 'descending' }]
  };

  const response = await notion.databases.query(queryOptions);
  return response.results.map(pageToExpense);
}

// 생성
async function create(data) {
  const response = await notion.pages.create({
    parent: { database_id: DATABASE_ID },
    properties: expenseToProperties(data)
  });
  return pageToExpense(response);
}

// 수정
async function update(pageId, data) {
  const response = await notion.pages.update({
    page_id: pageId,
    properties: expenseToProperties(data)
  });
  return pageToExpense(response);
}

// 삭제 (아카이브)
async function archive(pageId) {
  const response = await notion.pages.update({
    page_id: pageId,
    archived: true
  });
  return { success: true, id: pageId };
}

module.exports = async (req, res) => {
  // CORS 헤더
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  res.setHeader('Access-Control-Allow-Methods', 'GET,POST,OPTIONS');

  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  // 환경변수 확인
  if (!process.env.NOTION_API_KEY || !DATABASE_ID) {
    res.status(500).json({
      success: false,
      error: 'Notion API configuration missing',
      message: 'NOTION_API_KEY 또는 NOTION_EXPENSE_DATABASE_ID가 설정되지 않았습니다.'
    });
    return;
  }

  try {
    const method = req.method.toUpperCase();

    if (method === 'GET') {
      const { action, id, tripId, status } = req.query;

      switch (action) {
        case 'getById':
          if (!id) {
            res.status(400).json({ success: false, error: 'id parameter required' });
            return;
          }
          const expense = await getById(id);
          res.status(200).json({ success: true, data: expense });
          break;

        case 'getByTrip':
          if (!tripId) {
            res.status(400).json({ success: false, error: 'tripId parameter required' });
            return;
          }
          const tripExpenses = await getByTrip(tripId);
          res.status(200).json({ success: true, data: tripExpenses });
          break;

        case 'getByStatus':
          const filtered = await getAll({ status });
          res.status(200).json({ success: true, data: filtered });
          break;

        case 'getAll':
        default:
          const all = await getAll();
          res.status(200).json({ success: true, data: all });
          break;
      }
    } else if (method === 'POST') {
      // Body 파싱
      let payload = {};
      if (req.body && typeof req.body === 'object') {
        payload = req.body;
      } else {
        payload = await new Promise((resolve, reject) => {
          let raw = '';
          req.on('data', chunk => { raw += chunk; });
          req.on('end', () => {
            try {
              resolve(raw ? JSON.parse(raw) : {});
            } catch (e) {
              reject(e);
            }
          });
          req.on('error', reject);
        });
      }

      const { action, id, data } = payload;

      switch (action) {
        case 'create':
          const created = await create(data);
          res.status(201).json({ success: true, data: created });
          break;

        case 'update':
          if (!id) {
            res.status(400).json({ success: false, error: 'id required for update' });
            return;
          }
          const updated = await update(id, data);
          res.status(200).json({ success: true, data: updated });
          break;

        case 'delete':
          if (!id) {
            res.status(400).json({ success: false, error: 'id required for delete' });
            return;
          }
          const deleted = await archive(id);
          res.status(200).json({ success: true, data: deleted });
          break;

        default:
          res.status(400).json({ success: false, error: 'Invalid action' });
      }
    } else {
      res.status(405).json({ success: false, error: 'Method not allowed' });
    }
  } catch (error) {
    console.error('notion-expense error:', error);
    res.status(500).json({
      success: false,
      error: 'Notion API request failed',
      message: error.message
    });
  }
};

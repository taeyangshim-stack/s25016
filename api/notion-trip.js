/**
 * Vercel 서버리스 함수: 출장신청서 Notion API 프록시
 *
 * 엔드포인트: /api/notion-trip
 * - GET  /api/notion-trip?action=getAll
 * - GET  /api/notion-trip?action=getById&id=xxx
 * - GET  /api/notion-trip?action=getByStatus&status=승인
 * - POST /api/notion-trip (body: { action: 'create' | 'update' | 'delete', ... })
 *
 * 환경변수:
 * - NOTION_API_KEY: Notion Integration Token
 * - NOTION_TRIP_DATABASE_ID: 출장신청서 데이터베이스 ID
 */

const { Client } = require('@notionhq/client');

const notion = new Client({
  auth: process.env.NOTION_API_KEY
});

const DATABASE_ID = process.env.NOTION_TRIP_DATABASE_ID;

// Notion 페이지를 출장신청서 객체로 변환
function pageToTrip(page) {
  const props = page.properties;

  const getText = (prop) => {
    if (!prop) return '';
    if (prop.type === 'title') {
      // 모든 title 블록 연결
      return (prop.title || []).map(t => t.plain_text || '').join('');
    }
    if (prop.type === 'rich_text') {
      // 모든 rich_text 블록 연결 (링크 포함)
      return (prop.rich_text || []).map(t => {
        // 링크가 있으면 마크다운 형식으로 변환
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
  const getCheckbox = (prop) => prop?.checkbox || false;
  const getDate = (prop) => prop?.date?.start || '';

  return {
    id: page.id,
    createdTime: page.created_time,
    lastEditedTime: page.last_edited_time,
    // 기본 정보
    title: getText(props['제목']),
    requestNumber: getText(props['신청번호']),
    applicant: getSelect(props['신청자']),
    department: getText(props['기안부서']),
    // 출장 정보
    tripType: getSelect(props['출장유형']),
    tripCategory: getSelect(props['구분']),
    destination: getSelect(props['목적지']),
    destinationDetail: getText(props['목적지상세']),
    startDate: getDate(props['출발일']),
    endDate: getDate(props['복귀일']),
    purpose: getText(props['출장목적']),
    schedule: getText(props['상세일정']),
    // 비용
    totalCost: getNumber(props['예상비용']),
    accommodationCost: getNumber(props['숙박비']),
    transportCost: getNumber(props['교통비']),
    mealCost: getNumber(props['식비']),
    otherCost: getNumber(props['기타비용']),
    // 상태
    status: getSelect(props['상태']),
    priority: getSelect(props['우선순위']),
    hasVacancy: getCheckbox(props['인력공백']),
    // 연관
    punchlistId: getText(props['펀치리스트ID']),
    remarks: getText(props['비고'])
  };
}

// 출장신청서 객체를 Notion 속성으로 변환
function tripToProperties(data) {
  const properties = {};

  if (data.title !== undefined) {
    properties['제목'] = { title: [{ text: { content: data.title } }] };
  }
  if (data.requestNumber !== undefined) {
    properties['신청번호'] = { rich_text: [{ text: { content: data.requestNumber } }] };
  }
  if (data.applicant !== undefined) {
    properties['신청자'] = { select: { name: data.applicant } };
  }
  if (data.department !== undefined) {
    properties['기안부서'] = { rich_text: [{ text: { content: data.department } }] };
  }
  if (data.tripType !== undefined) {
    properties['출장유형'] = { select: { name: data.tripType } };
  }
  if (data.tripCategory !== undefined) {
    properties['구분'] = { select: { name: data.tripCategory } };
  }
  if (data.destination !== undefined) {
    properties['목적지'] = { select: { name: data.destination } };
  }
  if (data.destinationDetail !== undefined) {
    properties['목적지상세'] = { rich_text: [{ text: { content: data.destinationDetail } }] };
  }
  if (data.startDate !== undefined) {
    properties['출발일'] = { date: { start: data.startDate } };
  }
  if (data.endDate !== undefined) {
    properties['복귀일'] = { date: { start: data.endDate } };
  }
  if (data.purpose !== undefined) {
    properties['출장목적'] = { rich_text: [{ text: { content: data.purpose } }] };
  }
  if (data.schedule !== undefined) {
    properties['상세일정'] = { rich_text: [{ text: { content: data.schedule } }] };
  }
  if (data.totalCost !== undefined) {
    properties['예상비용'] = { number: data.totalCost };
  }
  if (data.accommodationCost !== undefined) {
    properties['숙박비'] = { number: data.accommodationCost };
  }
  if (data.transportCost !== undefined) {
    properties['교통비'] = { number: data.transportCost };
  }
  if (data.mealCost !== undefined) {
    properties['식비'] = { number: data.mealCost };
  }
  if (data.otherCost !== undefined) {
    properties['기타비용'] = { number: data.otherCost };
  }
  if (data.status !== undefined) {
    properties['상태'] = { select: { name: data.status } };
  }
  if (data.priority !== undefined) {
    properties['우선순위'] = { select: { name: data.priority } };
  }
  if (data.hasVacancy !== undefined) {
    properties['인력공백'] = { checkbox: data.hasVacancy };
  }
  if (data.punchlistId !== undefined) {
    properties['펀치리스트ID'] = { rich_text: [{ text: { content: data.punchlistId } }] };
  }
  if (data.remarks !== undefined) {
    properties['비고'] = { rich_text: [{ text: { content: data.remarks } }] };
  }

  return properties;
}

// 전체 목록 조회
async function getAll(filter = {}) {
  const queryOptions = {
    database_id: DATABASE_ID,
    sorts: [{ property: '출발일', direction: 'descending' }]
  };

  // 상태 필터
  if (filter.status) {
    queryOptions.filter = {
      property: '상태',
      select: { equals: filter.status }
    };
  }

  const response = await notion.databases.query(queryOptions);
  return response.results.map(pageToTrip);
}

// 단건 조회
async function getById(pageId) {
  const page = await notion.pages.retrieve({ page_id: pageId });
  return pageToTrip(page);
}

// 생성
async function create(data) {
  const response = await notion.pages.create({
    parent: { database_id: DATABASE_ID },
    properties: tripToProperties(data)
  });
  return pageToTrip(response);
}

// 수정
async function update(pageId, data) {
  const response = await notion.pages.update({
    page_id: pageId,
    properties: tripToProperties(data)
  });
  return pageToTrip(response);
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
      message: 'NOTION_API_KEY 또는 NOTION_TRIP_DATABASE_ID가 설정되지 않았습니다.'
    });
    return;
  }

  try {
    const method = req.method.toUpperCase();

    if (method === 'GET') {
      const { action, id, status } = req.query;

      switch (action) {
        case 'getById':
          if (!id) {
            res.status(400).json({ success: false, error: 'id parameter required' });
            return;
          }
          const trip = await getById(id);
          res.status(200).json({ success: true, data: trip });
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
    console.error('notion-trip error:', error);
    res.status(500).json({
      success: false,
      error: 'Notion API request failed',
      message: error.message
    });
  }
};

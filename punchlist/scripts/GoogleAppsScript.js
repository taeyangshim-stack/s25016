/**
 * S25016 펀치리스트 관리 시스템 (확장성 지원)
 * Google Apps Script for Google Sheets Integration
 *
 * 설정 방법:
 * 1. Google Sheets 생성
 * 2. 확장 프로그램 > Apps Script 열기
 * 3. 이 코드 붙여넣기
 * 4. SHEET_ID를 실제 시트 ID로 변경
 * 5. setupSheet() 함수 실행 (초기화)
 * 6. 배포 > 새 배포 > 웹 앱으로 배포
 * 7. 액세스 권한: "모든 사용자"
 * 8. 배포 URL을 punchlist.js의 SCRIPT_URL에 설정
 */

// 스프레드시트 설정
const SHEET_NAME = 'PunchList';
const SHEET_ID = 'YOUR_SHEET_ID'; // Google Sheets ID로 변경

// CORS 허용 헤더 추가 함수
function createCORSResponse(data) {
  const output = ContentService.createTextOutput(JSON.stringify(data))
    .setMimeType(ContentService.MimeType.JSON);

  return output;
}

// 메인 함수 - HTTP 요청 처리
function doPost(e) {
  try {
    const params = JSON.parse(e.postData.contents);
    const action = params.action;

    let result;
    switch(action) {
      case 'create':
        result = createIssue(params.data);
        break;
      case 'update':
        result = updateIssue(params.data);
        break;
      case 'delete':
        result = deleteIssue(params.id);
        break;
      case 'getAll':
        result = getAllIssues();
        break;
      case 'getById':
        result = getIssueById(params.id);
        break;
      case 'addComment':
        result = addComment(params.id, params.comment);
        break;
      default:
        result = ContentService.createTextOutput(
          JSON.stringify({ success: false, error: 'Invalid action' })
        ).setMimeType(ContentService.MimeType.JSON);
    }

    return result;
  } catch(error) {
    return ContentService.createTextOutput(
      JSON.stringify({ success: false, error: error.toString() })
    ).setMimeType(ContentService.MimeType.JSON);
  }
}

function doGet(e) {
  const action = e.parameter.action;

  if (action === 'getAll') {
    return getAllIssues();
  } else if (action === 'getById') {
    return getIssueById(e.parameter.id);
  }

  return ContentService.createTextOutput(
    JSON.stringify({ success: false, error: 'Invalid action' })
  ).setMimeType(ContentService.MimeType.JSON);
}

// 이슈 생성
function createIssue(data) {
  const ss = SpreadsheetApp.openById(SHEET_ID);
  const sheet = ss.getSheetByName(SHEET_NAME);

  // ID 자동 생성 (PL-YYYY-NNN)
  const lastRow = sheet.getLastRow();
  const year = new Date().getFullYear();
  const num = String(lastRow).padStart(3, '0');
  const id = `PL-${year}-${num}`;

  const timestamp = new Date().toISOString();

  const row = [
    id,
    data.title,
    data.category,
    data.subcategory,
    data.priority,
    data.status || '신규',
    data.description,
    data.cause || '',
    data.action_plan || '',
    data.action_result || '',
    data.owner,
    data.collaborators || '',
    data.approver || '',
    data.request_date,
    data.target_date,
    data.complete_date || '',
    JSON.stringify(data.attachments || []),
    JSON.stringify(data.comments || []),
    timestamp,
    timestamp,
    // 확장성 필드
    JSON.stringify(data.customFields || {}),  // customFields 추가
    data.templateId || ''  // templateId 추가
  ];

  sheet.appendRow(row);

  // 이메일 알림 발송
  sendEmailNotification('create', { id, ...data });

  return ContentService.createTextOutput(
    JSON.stringify({ success: true, id: id })
  ).setMimeType(ContentService.MimeType.JSON);
}

// 이슈 수정
function updateIssue(data) {
  const ss = SpreadsheetApp.openById(SHEET_ID);
  const sheet = ss.getSheetByName(SHEET_NAME);
  const values = sheet.getDataRange().getValues();

  for (let i = 1; i < values.length; i++) {
    if (values[i][0] === data.id) {
      const timestamp = new Date().toISOString();

      sheet.getRange(i + 1, 2).setValue(data.title);
      sheet.getRange(i + 1, 3).setValue(data.category);
      sheet.getRange(i + 1, 4).setValue(data.subcategory);
      sheet.getRange(i + 1, 5).setValue(data.priority);
      sheet.getRange(i + 1, 6).setValue(data.status);
      sheet.getRange(i + 1, 7).setValue(data.description);
      sheet.getRange(i + 1, 8).setValue(data.cause);
      sheet.getRange(i + 1, 9).setValue(data.action_plan);
      sheet.getRange(i + 1, 10).setValue(data.action_result);
      sheet.getRange(i + 1, 11).setValue(data.owner);
      sheet.getRange(i + 1, 12).setValue(data.collaborators);
      sheet.getRange(i + 1, 13).setValue(data.approver);
      sheet.getRange(i + 1, 14).setValue(data.request_date);
      sheet.getRange(i + 1, 15).setValue(data.target_date);
      sheet.getRange(i + 1, 16).setValue(data.complete_date);
      sheet.getRange(i + 1, 17).setValue(JSON.stringify(data.attachments || []));
      sheet.getRange(i + 1, 18).setValue(JSON.stringify(data.comments || []));
      sheet.getRange(i + 1, 20).setValue(timestamp);
      // 확장성 필드 업데이트
      sheet.getRange(i + 1, 21).setValue(JSON.stringify(data.customFields || {}));
      sheet.getRange(i + 1, 22).setValue(data.templateId || '');

      // 이메일 알림 발송
      sendEmailNotification('update', data);

      return ContentService.createTextOutput(
        JSON.stringify({ success: true })
      ).setMimeType(ContentService.MimeType.JSON);
    }
  }

  return ContentService.createTextOutput(
    JSON.stringify({ success: false, error: 'Issue not found' })
  ).setMimeType(ContentService.MimeType.JSON);
}

// 이슈 삭제
function deleteIssue(id) {
  const ss = SpreadsheetApp.openById(SHEET_ID);
  const sheet = ss.getSheetByName(SHEET_NAME);
  const values = sheet.getDataRange().getValues();

  for (let i = 1; i < values.length; i++) {
    if (values[i][0] === id) {
      sheet.deleteRow(i + 1);

      return ContentService.createTextOutput(
        JSON.stringify({ success: true })
      ).setMimeType(ContentService.MimeType.JSON);
    }
  }

  return ContentService.createTextOutput(
    JSON.stringify({ success: false, error: 'Issue not found' })
  ).setMimeType(ContentService.MimeType.JSON);
}

// 전체 이슈 조회
function getAllIssues() {
  const ss = SpreadsheetApp.openById(SHEET_ID);
  const sheet = ss.getSheetByName(SHEET_NAME);
  const values = sheet.getDataRange().getValues();

  const issues = [];

  for (let i = 1; i < values.length; i++) {
    const row = values[i];

    issues.push({
      id: row[0],
      title: row[1],
      category: row[2],
      subcategory: row[3],
      priority: row[4],
      status: row[5],
      description: row[6],
      cause: row[7],
      action_plan: row[8],
      action_result: row[9],
      owner: row[10],
      collaborators: row[11],
      approver: row[12],
      request_date: row[13],
      target_date: row[14],
      complete_date: row[15],
      attachments: safeJSONParse(row[16], []),
      comments: safeJSONParse(row[17], []),
      created_at: row[18],
      updated_at: row[19],
      // 확장성 필드
      customFields: safeJSONParse(row[20], {}),
      templateId: row[21] || ''
    });
  }

  return ContentService.createTextOutput(
    JSON.stringify({ success: true, data: issues })
  ).setMimeType(ContentService.MimeType.JSON);
}

// ID로 이슈 조회
function getIssueById(id) {
  const ss = SpreadsheetApp.openById(SHEET_ID);
  const sheet = ss.getSheetByName(SHEET_NAME);
  const values = sheet.getDataRange().getValues();

  for (let i = 1; i < values.length; i++) {
    if (values[i][0] === id) {
      const row = values[i];

      const issue = {
        id: row[0],
        title: row[1],
        category: row[2],
        subcategory: row[3],
        priority: row[4],
        status: row[5],
        description: row[6],
        cause: row[7],
        action_plan: row[8],
        action_result: row[9],
        owner: row[10],
        collaborators: row[11],
        approver: row[12],
        request_date: row[13],
        target_date: row[14],
        complete_date: row[15],
        attachments: safeJSONParse(row[16], []),
        comments: safeJSONParse(row[17], []),
        created_at: row[18],
        updated_at: row[19],
        // 확장성 필드
        customFields: safeJSONParse(row[20], {}),
        templateId: row[21] || ''
      };

      return ContentService.createTextOutput(
        JSON.stringify({ success: true, data: issue })
      ).setMimeType(ContentService.MimeType.JSON);
    }
  }

  return ContentService.createTextOutput(
    JSON.stringify({ success: false, error: 'Issue not found' })
  ).setMimeType(ContentService.MimeType.JSON);
}

// 댓글 추가
function addComment(issueId, comment) {
  const ss = SpreadsheetApp.openById(SHEET_ID);
  const sheet = ss.getSheetByName(SHEET_NAME);
  const values = sheet.getDataRange().getValues();

  for (let i = 1; i < values.length; i++) {
    if (values[i][0] === issueId) {
      const comments = safeJSONParse(values[i][17], []);
      comments.push({
        author: comment.author,
        text: comment.text,
        timestamp: new Date().toISOString()
      });

      sheet.getRange(i + 1, 18).setValue(JSON.stringify(comments));
      sheet.getRange(i + 1, 20).setValue(new Date().toISOString());

      return ContentService.createTextOutput(
        JSON.stringify({ success: true })
      ).setMimeType(ContentService.MimeType.JSON);
    }
  }

  return ContentService.createTextOutput(
    JSON.stringify({ success: false, error: 'Issue not found' })
  ).setMimeType(ContentService.MimeType.JSON);
}

// 안전한 JSON 파싱 (에러 방지)
function safeJSONParse(str, defaultValue) {
  try {
    if (!str || str === '') {
      return defaultValue;
    }
    return JSON.parse(str);
  } catch(e) {
    Logger.log('JSON parse error: ' + e.toString());
    return defaultValue;
  }
}

// 이메일 알림 발송
function sendEmailNotification(action, data) {
  // 담당자 이메일 설정 (실제 이메일로 변경 필요)
  const emails = {
    '심태양': 'simsun@kakao.com'
  };

  const ownerEmail = emails[data.owner];
  if (!ownerEmail) return;

  let subject, body;

  if (action === 'create') {
    // 템플릿 정보 추가
    const templateInfo = data.templateId ? `\n템플릿: ${data.templateId}` : '';

    subject = `[S25016 펀치리스트] 새 이슈 등록: ${data.title}`;
    body = `
새로운 이슈가 등록되었습니다.

이슈 ID: ${data.id}
제목: ${data.title}
분류: ${data.category} > ${data.subcategory}
우선순위: ${data.priority}
담당자: ${data.owner}${templateInfo}
요청일: ${data.request_date}
목표일: ${data.target_date}

[문제 상황]
${data.description}

---
펀치리스트 확인: http://localhost:8000/punchlist/index.html
이슈 상세: http://localhost:8000/punchlist/pages/detail.html?id=${data.id}
    `;
  } else if (action === 'update') {
    subject = `[S25016 펀치리스트] 이슈 업데이트: ${data.title}`;
    body = `
이슈가 업데이트되었습니다.

이슈 ID: ${data.id}
제목: ${data.title}
상태: ${data.status}
우선순위: ${data.priority}

${data.action_result ? '[조치 결과]\n' + data.action_result : ''}

---
이슈 상세: http://localhost:8000/punchlist/pages/detail.html?id=${data.id}
    `;
  }

  try {
    MailApp.sendEmail(ownerEmail, subject, body);
    Logger.log('Email sent to: ' + ownerEmail);
  } catch(e) {
    Logger.log('Email send failed: ' + e.toString());
  }
}

// 초기 시트 설정 (한 번만 실행)
function setupSheet() {
  const ss = SpreadsheetApp.openById(SHEET_ID);
  let sheet = ss.getSheetByName(SHEET_NAME);

  if (!sheet) {
    sheet = ss.insertSheet(SHEET_NAME);
  }

  const headers = [
    'ID', '제목', '분류', '세부분류', '우선순위', '상태',
    '문제상황', '원인분석', '조치계획', '조치결과',
    '담당자', '협의자', '승인자',
    '요청일', '목표일', '완료일',
    '첨부파일', '댓글',
    '생성일시', '수정일시',
    // 확장성 컬럼
    'customFields', 'templateId'
  ];

  sheet.getRange(1, 1, 1, headers.length).setValues([headers]);
  sheet.getRange(1, 1, 1, headers.length).setFontWeight('bold');
  sheet.getRange(1, 1, 1, headers.length).setBackground('#4a5568');
  sheet.getRange(1, 1, 1, headers.length).setFontColor('#ffffff');
  sheet.setFrozenRows(1);

  // 컬럼 너비 자동 조정
  sheet.autoResizeColumns(1, headers.length);

  Logger.log('Sheet initialized with headers');
  Logger.log('Total columns: ' + headers.length);
}

// 마이그레이션: 기존 시트에 확장성 컬럼 추가
function migrateToExtensibility() {
  const ss = SpreadsheetApp.openById(SHEET_ID);
  const sheet = ss.getSheetByName(SHEET_NAME);

  if (!sheet) {
    Logger.log('Sheet not found. Run setupSheet() first.');
    return;
  }

  const lastCol = sheet.getLastColumn();

  // 현재 컬럼 수 확인
  if (lastCol < 22) {
    // customFields 컬럼 추가 (21번째)
    if (lastCol < 21) {
      sheet.getRange(1, 21).setValue('customFields');
      sheet.getRange(1, 21).setFontWeight('bold');
      sheet.getRange(1, 21).setBackground('#4a5568');
      sheet.getRange(1, 21).setFontColor('#ffffff');

      // 기존 데이터에 빈 객체 추가
      const lastRow = sheet.getLastRow();
      if (lastRow > 1) {
        for (let i = 2; i <= lastRow; i++) {
          sheet.getRange(i, 21).setValue('{}');
        }
      }

      Logger.log('Added customFields column');
    }

    // templateId 컬럼 추가 (22번째)
    if (lastCol < 22) {
      sheet.getRange(1, 22).setValue('templateId');
      sheet.getRange(1, 22).setFontWeight('bold');
      sheet.getRange(1, 22).setBackground('#4a5568');
      sheet.getRange(1, 22).setFontColor('#ffffff');

      // 기존 데이터에 빈 문자열 추가
      const lastRow = sheet.getLastRow();
      if (lastRow > 1) {
        for (let i = 2; i <= lastRow; i++) {
          sheet.getRange(i, 22).setValue('');
        }
      }

      Logger.log('Added templateId column');
    }

    Logger.log('Migration completed');
  } else {
    Logger.log('Sheet already has extensibility columns');
  }
}

// 통계 생성 (대시보드용)
function generateStats() {
  const ss = SpreadsheetApp.openById(SHEET_ID);
  const sheet = ss.getSheetByName(SHEET_NAME);
  const values = sheet.getDataRange().getValues();

  const stats = {
    total: 0,
    byStatus: {},
    byCategory: {},
    byPriority: {},
    byTemplate: {},
    overdue: 0
  };

  const today = new Date();

  for (let i = 1; i < values.length; i++) {
    stats.total++;

    const status = values[i][5];
    const category = values[i][2];
    const priority = values[i][4];
    const targetDate = new Date(values[i][14]);
    const templateId = values[i][21];

    // 상태별
    stats.byStatus[status] = (stats.byStatus[status] || 0) + 1;

    // 분류별
    stats.byCategory[category] = (stats.byCategory[category] || 0) + 1;

    // 우선순위별
    stats.byPriority[priority] = (stats.byPriority[priority] || 0) + 1;

    // 템플릿별
    if (templateId) {
      stats.byTemplate[templateId] = (stats.byTemplate[templateId] || 0) + 1;
    }

    // 지연 건수
    if (status !== '완료' && targetDate < today) {
      stats.overdue++;
    }
  }

  Logger.log('Statistics:');
  Logger.log(JSON.stringify(stats, null, 2));

  return stats;
}

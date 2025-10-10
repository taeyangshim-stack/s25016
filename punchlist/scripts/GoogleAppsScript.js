/**
 * S25016 펀치리스트 관리 시스템
 * Google Apps Script for Google Sheets Integration
 *
 * 설정 방법:
 * 1. Google Sheets 생성
 * 2. 확장 프로그램 > Apps Script 열기
 * 3. 이 코드 붙여넣기
 * 4. 배포 > 새 배포 > 웹 앱으로 배포
 * 5. 액세스 권한: "모든 사용자"
 * 6. 배포 URL을 punchlist.js의 SCRIPT_URL에 설정
 */

// 스프레드시트 설정
const SHEET_NAME = 'PunchList';
const SHEET_ID = 'YOUR_SHEET_ID'; // Google Sheets ID로 변경

// 메인 함수 - HTTP 요청 처리
function doPost(e) {
  try {
    const params = JSON.parse(e.postData.contents);
    const action = params.action;

    switch(action) {
      case 'create':
        return createIssue(params.data);
      case 'update':
        return updateIssue(params.data);
      case 'delete':
        return deleteIssue(params.id);
      case 'getAll':
        return getAllIssues();
      case 'getById':
        return getIssueById(params.id);
      case 'addComment':
        return addComment(params.id, params.comment);
      default:
        return ContentService.createTextOutput(
          JSON.stringify({ success: false, error: 'Invalid action' })
        ).setMimeType(ContentService.MimeType.JSON);
    }
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
    timestamp
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
    issues.push({
      id: values[i][0],
      title: values[i][1],
      category: values[i][2],
      subcategory: values[i][3],
      priority: values[i][4],
      status: values[i][5],
      description: values[i][6],
      cause: values[i][7],
      action_plan: values[i][8],
      action_result: values[i][9],
      owner: values[i][10],
      collaborators: values[i][11],
      approver: values[i][12],
      request_date: values[i][13],
      target_date: values[i][14],
      complete_date: values[i][15],
      attachments: JSON.parse(values[i][16] || '[]'),
      comments: JSON.parse(values[i][17] || '[]'),
      created_at: values[i][18],
      updated_at: values[i][19]
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
      const issue = {
        id: values[i][0],
        title: values[i][1],
        category: values[i][2],
        subcategory: values[i][3],
        priority: values[i][4],
        status: values[i][5],
        description: values[i][6],
        cause: values[i][7],
        action_plan: values[i][8],
        action_result: values[i][9],
        owner: values[i][10],
        collaborators: values[i][11],
        approver: values[i][12],
        request_date: values[i][13],
        target_date: values[i][14],
        complete_date: values[i][15],
        attachments: JSON.parse(values[i][16] || '[]'),
        comments: JSON.parse(values[i][17] || '[]'),
        created_at: values[i][18],
        updated_at: values[i][19]
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
      const comments = JSON.parse(values[i][17] || '[]');
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

// 이메일 알림 발송
function sendEmailNotification(action, data) {
  // 담당자 이메일 설정 (실제 이메일로 변경 필요)
  const emails = {
    '심태양': 'taeyangshim@example.com',
    '김철수': 'chulsookim@example.com',
    '박영희': 'youngheepark@example.com'
  };

  const ownerEmail = emails[data.owner];
  if (!ownerEmail) return;

  let subject, body;

  if (action === 'create') {
    subject = `[S25016] 새 이슈 등록: ${data.title}`;
    body = `
      새로운 이슈가 등록되었습니다.

      이슈 ID: ${data.id}
      제목: ${data.title}
      분류: ${data.category} > ${data.subcategory}
      우선순위: ${data.priority}
      담당자: ${data.owner}
      목표일: ${data.target_date}

      ${data.description}
    `;
  } else if (action === 'update') {
    subject = `[S25016] 이슈 업데이트: ${data.title}`;
    body = `
      이슈가 업데이트되었습니다.

      이슈 ID: ${data.id}
      제목: ${data.title}
      상태: ${data.status}

      ${data.action_result}
    `;
  }

  try {
    MailApp.sendEmail(ownerEmail, subject, body);
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

    const headers = [
      'ID', '제목', '분류', '세부분류', '우선순위', '상태',
      '문제상황', '원인분석', '조치계획', '조치결과',
      '담당자', '협의자', '승인자',
      '요청일', '목표일', '완료일',
      '첨부파일', '댓글',
      '생성일시', '수정일시'
    ];

    sheet.getRange(1, 1, 1, headers.length).setValues([headers]);
    sheet.getRange(1, 1, 1, headers.length).setFontWeight('bold');
    sheet.setFrozenRows(1);

    Logger.log('Sheet setup completed');
  }
}

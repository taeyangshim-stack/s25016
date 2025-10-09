/**
 * S25016 근무관리 시스템 - Google Apps Script
 *
 * 이 스크립트를 Google Sheets의 Apps Script 에디터에 복사하여 사용하세요.
 *
 * 기능:
 * 1. 웹 앱으로 배포하여 POST 요청 수신
 * 2. Google Sheets에 출입 기록 자동 저장
 * 3. 이메일 자동 발송
 */

// ========================================
// 설정 영역 - 사용자가 수정해야 하는 부분
// ========================================

const CONFIG = {
  // 이메일 수신자 (쉼표로 구분)
  EMAIL_RECIPIENTS: 'your-email@example.com',

  // 참조(CC) 수신자 (선택사항)
  EMAIL_CC: '',

  // 발신자 이름
  EMAIL_FROM_NAME: 'S25016 근무관리 시스템',

  // 시트 이름
  SHEET_NAME: '출입기록',

  // 메일 발송 여부 (true/false)
  SEND_EMAIL: true
};

// ========================================
// 메인 함수
// ========================================

/**
 * 웹 앱 POST 요청 처리
 */
function doPost(e) {
  try {
    // JSON 데이터 파싱
    const data = JSON.parse(e.postData.contents);

    // 스프레드시트 가져오기
    const sheet = getOrCreateSheet();

    // 데이터 저장
    saveRecord(sheet, data);

    // 이메일 발송
    if (CONFIG.SEND_EMAIL) {
      sendEmail(data);
    }

    return ContentService
      .createTextOutput(JSON.stringify({
        status: 'success',
        message: '기록이 저장되었습니다.'
      }))
      .setMimeType(ContentService.MimeType.JSON);

  } catch (error) {
    Logger.log('Error: ' + error.toString());

    return ContentService
      .createTextOutput(JSON.stringify({
        status: 'error',
        message: error.toString()
      }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}

/**
 * 웹 앱 GET 요청 처리 (테스트용)
 */
function doGet(e) {
  return ContentService
    .createTextOutput('S25016 근무관리 시스템이 정상 작동 중입니다.')
    .setMimeType(ContentService.MimeType.TEXT);
}

// ========================================
// 스프레드시트 관련 함수
// ========================================

/**
 * 시트 가져오기 또는 생성
 */
function getOrCreateSheet() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  let sheet = ss.getSheetByName(CONFIG.SHEET_NAME);

  // 시트가 없으면 새로 생성
  if (!sheet) {
    sheet = ss.insertSheet(CONFIG.SHEET_NAME);

    // 헤더 행 추가
    const headers = [
      '타임스탬프',
      '날짜',
      '인원',
      '위치',
      '입실시간',
      '퇴실시간',
      '근무시간',
      '작업내용',
      '비고'
    ];

    sheet.getRange(1, 1, 1, headers.length).setValues([headers]);

    // 헤더 스타일 지정
    const headerRange = sheet.getRange(1, 1, 1, headers.length);
    headerRange.setBackground('#667eea');
    headerRange.setFontColor('#ffffff');
    headerRange.setFontWeight('bold');
    headerRange.setHorizontalAlignment('center');

    // 열 너비 자동 조정
    sheet.autoResizeColumns(1, headers.length);
  }

  return sheet;
}

/**
 * 기록 저장
 */
function saveRecord(sheet, data) {
  // 근무 시간 계산
  const workHours = calculateWorkHours(data.checkIn, data.checkOut);

  // 데이터 행 추가
  const row = [
    new Date(data.timestamp),
    data.date,
    data.name,
    data.location,
    data.checkIn,
    data.checkOut,
    workHours,
    data.workType,
    data.notes
  ];

  sheet.appendRow(row);

  // 마지막 행에 서식 적용
  const lastRow = sheet.getLastRow();
  const range = sheet.getRange(lastRow, 1, 1, row.length);

  // 교대로 배경색 지정
  if (lastRow % 2 === 0) {
    range.setBackground('#f8f9fa');
  }

  // 테두리 추가
  range.setBorder(true, true, true, true, false, false);

  Logger.log('Record saved: ' + JSON.stringify(data));
}

/**
 * 근무 시간 계산
 */
function calculateWorkHours(checkIn, checkOut) {
  if (checkIn === '-' || checkOut === '-') {
    return '-';
  }

  try {
    const [inHour, inMin] = checkIn.split(':').map(Number);
    const [outHour, outMin] = checkOut.split(':').map(Number);

    const inMinutes = inHour * 60 + inMin;
    const outMinutes = outHour * 60 + outMin;

    const diffMinutes = outMinutes - inMinutes;

    if (diffMinutes < 0) {
      return '-';
    }

    const hours = Math.floor(diffMinutes / 60);
    const minutes = diffMinutes % 60;

    return `${hours}시간 ${minutes}분`;

  } catch (error) {
    Logger.log('Work hours calculation error: ' + error.toString());
    return '-';
  }
}

// ========================================
// 이메일 관련 함수
// ========================================

/**
 * 이메일 발송
 */
function sendEmail(data) {
  try {
    const subject = `[S25016] ${data.date} 출입 기록 - ${data.name}`;
    const body = createEmailBody(data);

    const options = {
      name: CONFIG.EMAIL_FROM_NAME,
      htmlBody: body
    };

    if (CONFIG.EMAIL_CC) {
      options.cc = CONFIG.EMAIL_CC;
    }

    MailApp.sendEmail(CONFIG.EMAIL_RECIPIENTS, subject, '', options);

    Logger.log('Email sent to: ' + CONFIG.EMAIL_RECIPIENTS);

  } catch (error) {
    Logger.log('Email sending error: ' + error.toString());
  }
}

/**
 * 이메일 본문 생성
 */
function createEmailBody(data) {
  const workHours = calculateWorkHours(data.checkIn, data.checkOut);

  const html = `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; border-radius: 10px 10px 0 0; text-align: center; }
        .header h1 { margin: 0; font-size: 24px; }
        .content { background: #f8f9fa; padding: 30px; border-radius: 0 0 10px 10px; }
        .info-table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; }
        .info-table th { background: #667eea; color: white; padding: 12px; text-align: left; font-weight: 600; }
        .info-table td { padding: 12px; border-bottom: 1px solid #e0e0e0; }
        .info-table tr:last-child td { border-bottom: none; }
        .label { font-weight: bold; color: #666; width: 120px; }
        .value { color: #333; }
        .footer { text-align: center; margin-top: 20px; padding-top: 20px; border-top: 2px solid #e0e0e0; color: #999; font-size: 12px; }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>🏭 출입 기록 알림</h1>
        </div>
        <div class="content">
          <table class="info-table">
            <tr>
              <td class="label">📅 날짜</td>
              <td class="value">${data.date}</td>
            </tr>
            <tr>
              <td class="label">👤 인원</td>
              <td class="value">${data.name}</td>
            </tr>
            <tr>
              <td class="label">🏭 위치</td>
              <td class="value">${data.location}</td>
            </tr>
            <tr>
              <td class="label">⏰ 입실 시간</td>
              <td class="value">${data.checkIn}</td>
            </tr>
            <tr>
              <td class="label">🏠 퇴실 시간</td>
              <td class="value">${data.checkOut}</td>
            </tr>
            <tr>
              <td class="label">⏱️ 근무 시간</td>
              <td class="value">${workHours}</td>
            </tr>
            <tr>
              <td class="label">📋 작업 내용</td>
              <td class="value">${data.workType}</td>
            </tr>
            <tr>
              <td class="label">📝 비고</td>
              <td class="value">${data.notes}</td>
            </tr>
          </table>
          <div class="footer">
            🤖 S25016 근무관리 시스템에서 자동 발송되었습니다.
          </div>
        </div>
      </div>
    </body>
    </html>
  `;

  return html;
}

// ========================================
// 유틸리티 함수
// ========================================

/**
 * 테스트 함수 - 샘플 데이터로 테스트
 */
function testSaveRecord() {
  const testData = {
    date: '2024-10-09',
    name: '심태양',
    location: '34bay A라인',
    checkIn: '08:00',
    checkOut: '17:00',
    workType: 'ROBOT↔UI 테스트',
    notes: '테스트 데이터입니다.',
    timestamp: new Date().toISOString()
  };

  const sheet = getOrCreateSheet();
  saveRecord(sheet, testData);

  if (CONFIG.SEND_EMAIL) {
    sendEmail(testData);
  }

  Logger.log('Test completed!');
}

/**
 * 전체 기록 조회 (GET 요청용)
 */
function getAllRecords() {
  try {
    const sheet = getOrCreateSheet();
    const data = sheet.getDataRange().getValues();

    // 헤더 제외
    const headers = data[0];
    const records = data.slice(1).map(row => {
      const record = {};
      headers.forEach((header, index) => {
        record[header] = row[index];
      });
      return record;
    });

    return ContentService
      .createTextOutput(JSON.stringify(records))
      .setMimeType(ContentService.MimeType.JSON);

  } catch (error) {
    return ContentService
      .createTextOutput(JSON.stringify({ error: error.toString() }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}

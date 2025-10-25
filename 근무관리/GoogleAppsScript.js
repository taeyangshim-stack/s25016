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
  EMAIL_RECIPIENTS: 'simsun@kakao.com',

  // 참조(CC) 수신자 (선택사항)
  EMAIL_CC: '',

  // 발신자 이름
  EMAIL_FROM_NAME: 'S25016 근무관리 시스템',

  // 시트 이름
  SHEET_NAME: '출입기록',
  SHEET_NAME_EMPLOYEES: '인원목록',
  SHEET_NAME_LOCATIONS: '장소목록',

  // 메일 발송 여부 (true/false)
  SEND_EMAIL: true
};

// ========================================
// 공통 응답/헬퍼 함수
// ========================================

function createJsonResponse(payload) {
  return ContentService
    .createTextOutput(JSON.stringify(payload))
    .setMimeType(ContentService.MimeType.JSON);
}

function createTextResponse(text, mimeType) {
  return ContentService
    .createTextOutput(text)
    .setMimeType(mimeType);
}

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
    const action = e.parameter.action;

    if (action === 'update') {
      // 수정 요청
      const success = updateRecord(data);
      return createJsonResponse({
        status: success ? 'success' : 'error',
        message: success ? '기록이 수정되었습니다.' : '기록을 찾을 수 없습니다.'
      });

    } else if (action === 'delete') {
      // 삭제 요청
      const success = deleteRecord(data);
      return createJsonResponse({
        status: success ? 'success' : 'error',
        message: success ? '기록이 삭제되었습니다.' : '기록을 찾을 수 없습니다.'
      });

    } else if (action === 'bulkCreate') {
        const results = bulkCreateRecords(data);
        const successCount = results.filter(r => r.status === 'success').length;
        return createJsonResponse({
            status: 'success',
            message: `${successCount}개의 기록이 성공적으로 추가되었습니다.`
        });

    } else if (action === 'bulkUpdate') {
        const results = bulkUpdateRecords(data);
        const successCount = results.filter(r => r.status === 'success').length;
        return createJsonResponse({
            status: 'success',
            message: `${successCount}개의 기록이 성공적으로 수정되었습니다.`
        });

    } else if (action === 'bulkDelete') {
        const results = bulkDeleteRecords(data);
        const successCount = results.filter(r => r.status === 'success').length;
        return createJsonResponse({
            status: 'success',
            message: `${successCount}개의 기록이 성공적으로 삭제되었습니다.`
        });

    } else {
      // 기존 저장 로직 (새 기록 추가)
      const sheet = getOrCreateSheet();
      saveRecord(sheet, data);

      if (CONFIG.SEND_EMAIL) {
        sendEmail(data);
      }

      return createJsonResponse({
        status: 'success',
        message: '기록이 저장되었습니다.'
      });
    }

  } catch (error) {
    Logger.log('Error: ' + error.toString());

    return createJsonResponse({
      status: 'error',
      message: error.toString()
    });
  }
}

/**
 * 웹 앱 GET 요청 처리
 */
function doGet(e) {
  const action = e.parameter.action;

  if (action === 'getEmployees') {
    return getEmployees();
  } else if (action === 'getLocations') {
    return getLocations();
  } else if (action === 'getAllRecords') {
    return getAllRecords();
  }

  return createTextResponse(
    'S25016 근무관리 시스템이 정상 작동 중입니다.',
    ContentService.MimeType.TEXT
  );
}

/**
 * 웹 앱 OPTIONS 요청 처리 (CORS 프리플라이트)
 */
function doOptions() {
  return createTextResponse('', ContentService.MimeType.TEXT);
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
// 일괄 처리 함수
// ========================================

/**
 * 여러 기록 일괄 생성
 */
function bulkCreateRecords(records) {
  const sheet = getOrCreateSheet();
  const results = [];

  records.forEach(data => {
    try {
      saveRecord(sheet, data);
      results.push({ status: 'success', data: data });
    } catch (error) {
      Logger.log('Bulk create error for record: ' + JSON.stringify(data) + ' | Error: ' + error.toString());
      results.push({ status: 'error', data: data, error: error.toString() });
    }
  });

  return results;
}

/**
 * 여러 기록 일괄 수정
 */
function bulkUpdateRecords(records) {
  const sheet = getOrCreateSheet();
  const results = [];

  records.forEach(updatedData => {
    try {
      const rowNumber = parseInt(updatedData.rowNumber, 10);
      if (!isNaN(rowNumber) && rowNumber > 1 && rowNumber <= sheet.getLastRow()) {
        const success = applyUpdateToRow(sheet, rowNumber, updatedData);
        results.push({ status: success ? 'success' : 'error', data: updatedData });
      } else {
        results.push({ status: 'error', data: updatedData, message: '유효하지 않은 행 번호입니다.' });
      }
    } catch (error) {
      Logger.log('Bulk update error for record: ' + JSON.stringify(updatedData) + ' | Error: ' + error.toString());
      results.push({ status: 'error', data: updatedData, error: error.toString() });
    }
  });

  return results;
}

/**
 * 여러 기록 일괄 삭제
 */
function bulkDeleteRecords(records) {
  const sheet = getOrCreateSheet();
  const results = [];
  
  // 행 번호를 내림차순으로 정렬하여 삭제 시 인덱스가 꼬이는 것을 방지
  const sortedRecords = records.sort((a, b) => parseInt(b.rowNumber, 10) - parseInt(a.rowNumber, 10));

  sortedRecords.forEach(deleteData => {
    try {
      const rowNumber = parseInt(deleteData.rowNumber, 10);
      // 행 번호 유효성 검사를 getLastRow() 호출 전에 수행
      if (!isNaN(rowNumber) && rowNumber > 1) {
        sheet.deleteRow(rowNumber);
        results.push({ status: 'success', data: deleteData });
        Logger.log('Record deleted by row number: ' + rowNumber);
      } else {
         results.push({ status: 'error', data: deleteData, message: '유효하지 않은 행 번호입니다.' });
      }
    } catch (error) {
      Logger.log('Bulk delete error for record: ' + JSON.stringify(deleteData) + ' | Error: ' + error.toString());
      results.push({ status: 'error', data: deleteData, error: error.toString() });
    }
  });

  return results;
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
    const records = data.slice(1).map((row, rowIndex) => {
      const record = {};
      headers.forEach((header, columnIndex) => {
        let value = row[columnIndex];

        // 타임스탬프는 ISO 문자열로 변환
        if (header === '타임스탬프' && value instanceof Date) {
          value = value.toISOString();
        }
        // 날짜는 YYYY-MM-DD 형식으로 변환
        else if (header === '날짜' && value instanceof Date) {
          const year = value.getFullYear();
          const month = String(value.getMonth() + 1).padStart(2, '0');
          const day = String(value.getDate()).padStart(2, '0');
          value = `${year}-${month}-${day}`;
        }
        // 입실시간, 퇴실시간은 Date 객체면 HH:MM 형식으로 변환
        else if ((header === '입실시간' || header === '퇴실시간') && value instanceof Date) {
          // 1899-12-30 기준일이면 시간만 추출
          const hours = String(value.getHours()).padStart(2, '0');
          const minutes = String(value.getMinutes()).padStart(2, '0');
          value = `${hours}:${minutes}`;
        }
        // 빈 값은 '-'로 변환
        else if (value === '' || value === null || value === undefined) {
          value = header === '타임스탬프' ? '' : '-';
        }

        record[header] = value;
      });
      record.rowNumber = rowIndex + 2; // 헤더 제외 실제 시트 행 번호
      return record;
    });

    return createJsonResponse(records);

  } catch (error) {
    return createJsonResponse({ error: error.toString() });
  }
}

/**
 * 기록 업데이트 (POST 요청용)
 */
function updateRecord(updatedData) {
  try {
    const sheet = getOrCreateSheet();
    const data = sheet.getDataRange().getValues();
    const rowNumber = parseInt(updatedData.rowNumber, 10);

    if (!isNaN(rowNumber) && rowNumber > 1 && rowNumber <= sheet.getLastRow()) {
      Logger.log('Update request by row number: ' + rowNumber);
      return applyUpdateToRow(sheet, rowNumber, updatedData);
    }

    const timestamp = updatedData.timestamp;
    const targetTime = new Date(timestamp).getTime();

    Logger.log('Update request for timestamp: ' + timestamp);
    Logger.log('Target time (ms): ' + targetTime);

    // 타임스탬프로 행 찾기
    for (let i = 1; i < data.length; i++) {
      const rowTimestamp = data[i][0];

      // Date 객체를 밀리초로 변환하여 비교
      let rowTime;
      if (rowTimestamp instanceof Date) {
        rowTime = rowTimestamp.getTime();
      } else {
        rowTime = new Date(rowTimestamp).getTime();
      }

      Logger.log(`Row ${i}: ${rowTime}`);

      // 밀리초 단위로 비교 (1초 오차 허용)
      if (Math.abs(rowTime - targetTime) < 1000) {
        Logger.log('Match found at row: ' + (i + 1));

        return applyUpdateToRow(sheet, i + 1, updatedData);
      }
    }

    Logger.log('Record not found for timestamp: ' + timestamp);
    return false;

  } catch (error) {
    Logger.log('Update error: ' + error.toString());
    return false;
  }
}

/**
 * 기록 삭제 (POST 요청용)
 */
function deleteRecord(deleteData) {
  try {
    const sheet = getOrCreateSheet();
    const data = sheet.getDataRange().getValues();
    const rowNumber = parseInt(deleteData.rowNumber, 10);

    if (!isNaN(rowNumber) && rowNumber > 1 && rowNumber <= sheet.getLastRow()) {
      sheet.deleteRow(rowNumber);
      Logger.log('Record deleted by row number: ' + rowNumber);
      return true;
    }

    const timestamp = deleteData.timestamp;
    const targetTime = new Date(timestamp).getTime();

    Logger.log('Delete request for timestamp: ' + timestamp);

    // 타임스탬프로 행 찾기
    for (let i = 1; i < data.length; i++) {
      const rowTimestamp = data[i][0];

      // Date 객체를 밀리초로 변환하여 비교
      let rowTime;
      if (rowTimestamp instanceof Date) {
        rowTime = rowTimestamp.getTime();
      } else {
        rowTime = new Date(rowTimestamp).getTime();
      }

      // 밀리초 단위로 비교 (1초 오차 허용)
      if (Math.abs(rowTime - targetTime) < 1000) {
        sheet.deleteRow(i + 1);
        Logger.log('Record deleted successfully');
        return true;
      }
    }

    Logger.log('Record not found for timestamp: ' + timestamp);
    return false;

  } catch (error) {
    Logger.log('Delete error: ' + error.toString());
    return false;
  }
}

// ========================================
// 인원/장소 관리 함수
// ========================================

/**
 * 지정한 행에 수정 데이터 반영
 */
function applyUpdateToRow(sheet, rowNumber, updatedData) {
  sheet.getRange(rowNumber, 2).setValue(updatedData.date);
  sheet.getRange(rowNumber, 3).setValue(updatedData.name);
  sheet.getRange(rowNumber, 4).setValue(updatedData.location);
  sheet.getRange(rowNumber, 5).setValue(updatedData.checkIn);
  sheet.getRange(rowNumber, 6).setValue(updatedData.checkOut);

  const workHours = calculateWorkHours(updatedData.checkIn, updatedData.checkOut);
  sheet.getRange(rowNumber, 7).setValue(workHours);

  sheet.getRange(rowNumber, 8).setValue(updatedData.workType);
  sheet.getRange(rowNumber, 9).setValue(updatedData.notes);

  Logger.log('Record updated successfully at row: ' + rowNumber);
  return true;
}

/**
 * 인원 목록 가져오기
 */
function getEmployees() {
  try {
    const ss = SpreadsheetApp.getActiveSpreadsheet();
    let sheet = ss.getSheetByName(CONFIG.SHEET_NAME_EMPLOYEES);

    // 시트가 없으면 생성
    if (!sheet) {
      sheet = ss.insertSheet(CONFIG.SHEET_NAME_EMPLOYEES);

      // 헤더 추가
      sheet.getRange('A1').setValue('이름');
      sheet.getRange('A1').setBackground('#667eea');
      sheet.getRange('A1').setFontColor('#ffffff');
      sheet.getRange('A1').setFontWeight('bold');

      // 기본 인원 추가
      const defaultEmployees = ['심태양', '김철수', '이영희', '박민수'];
      defaultEmployees.forEach((name, index) => {
        sheet.getRange(index + 2, 1).setValue(name);
      });

      Logger.log('인원목록 시트가 생성되었습니다.');
    }

    // 데이터 읽기 (헤더 제외)
    const data = sheet.getRange('A:A').getValues();
    const employees = data
      .flat()
      .filter(name => name && name !== '이름')
      .map(name => name.toString().trim());

    return createJsonResponse(employees);

  } catch (error) {
    Logger.log('getEmployees error: ' + error.toString());

    return createJsonResponse({
      error: error.toString(),
      fallback: ['심태양', '김철수', '이영희', '박민수']
    });
  }
}

/**
 * 장소 목록 가져오기
 */
function getLocations() {
  try {
    const ss = SpreadsheetApp.getActiveSpreadsheet();
    let sheet = ss.getSheetByName(CONFIG.SHEET_NAME_LOCATIONS);

    // 시트가 없으면 생성
    if (!sheet) {
      sheet = ss.insertSheet(CONFIG.SHEET_NAME_LOCATIONS);

      // 헤더 추가
      sheet.getRange('A1').setValue('장소');
      sheet.getRange('A1').setBackground('#667eea');
      sheet.getRange('A1').setFontColor('#ffffff');
      sheet.getRange('A1').setFontWeight('bold');

      // 기본 장소 추가
      const defaultLocations = [
        '34bay A라인',
        '34bay B라인',
        '35bay A라인',
        '35bay B라인',
        '사무실',
        '회의실'
      ];
      defaultLocations.forEach((loc, index) => {
        sheet.getRange(index + 2, 1).setValue(loc);
      });

      Logger.log('장소목록 시트가 생성되었습니다.');
    }

    // 데이터 읽기 (헤더 제외)
    const data = sheet.getRange('A:A').getValues();
    const locations = data
      .flat()
      .filter(loc => loc && loc !== '장소')
      .map(loc => loc.toString().trim());

    return createJsonResponse(locations);

  } catch (error) {
    Logger.log('getLocations error: ' + error.toString());

    return createJsonResponse({
      error: error.toString(),
      fallback: ['34bay A라인', '34bay B라인', '35bay A라인', '35bay B라인', '사무실', '회의실']
    });
  }
}

/**
 * 테스트 함수 - 인원/장소 목록 조회 테스트
 */
function testGetSettings() {
  Logger.log('=== 인원 목록 테스트 ===');
  const employees = getEmployees();
  Logger.log(employees.getContent());

  Logger.log('\n=== 장소 목록 테스트 ===');
  const locations = getLocations();
  Logger.log(locations.getContent());
}

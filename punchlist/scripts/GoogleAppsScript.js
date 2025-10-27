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
const SHEET_ID = '1EqBPn9XrA_5PTg5ks4bgFIjwiojMFDZCYaOkFJINAmE'; // Google Sheets ID로 변경

// 부가 시트 이름
const SHEET_NAME_OWNERS = 'PunchListOwners';
const SHEET_NAME_CATEGORIES = 'PunchListCategories';

// 기본 담당자 목록
const DEFAULT_OWNERS = [
  { name: '심태양', role: '담당자', department: '생산기술팀', phone: '', email: 'simsun@kakao.com' },
  { name: '김철수', role: '담당자', department: '생산1팀', phone: '', email: '' },
  { name: '박영희', role: '담당자', department: '품질팀', phone: '', email: '' },
  { name: '이영수', role: '관리자', department: '생산기술팀', phone: '', email: '' },
  { name: '최민수', role: '담당자', department: '유지보수팀', phone: '', email: '' }
];

// 기본 분류 구성 (config/categories.json과 동기화)
const DEFAULT_CATEGORY_CONFIG = {
  version: '1.0',
  lastUpdated: '2024-10-10',
  description: 'S25016 프로젝트 이슈 분류 체계',
  categories: [
    {
      id: 'mechanical',
      name: '기계',
      icon: '🔧',
      color: '#3b82f6',
      description: '기계 및 구조물 관련 이슈',
      subcategories: [
        {
          id: 'structure',
          name: '구조물',
          description: '프레임, 베이스 등 구조물 관련',
          keywords: ['프레임', '베이스', '구조', '용접']
        },
        {
          id: 'frame',
          name: '프레임',
          description: '기계 프레임 및 하우징',
          keywords: ['프레임', '하우징', '커버']
        },
        {
          id: 'transport',
          name: '이송장치',
          description: '컨베이어, 리프터 등 이송 관련',
          keywords: ['컨베이어', '리프터', '이송', '반송']
        },
        {
          id: 'custom',
          name: '기타',
          description: '기타 기계 관련 이슈',
          allowCustomInput: true
        }
      ]
    },
    {
      id: 'electrical',
      name: '전기',
      icon: '⚡',
      color: '#f59e0b',
      description: '전기 및 전원 관련 이슈',
      subcategories: [
        {
          id: 'wiring',
          name: '배선',
          description: '전기 배선 및 케이블 관련',
          keywords: ['배선', '케이블', '전선', '결선']
        },
        {
          id: 'sensor',
          name: '센서',
          description: '각종 센서 및 스위치',
          keywords: ['센서', '스위치', '감지', '검출']
        },
        {
          id: 'motor',
          name: '모터',
          description: '서보모터, 스테핑모터 등',
          keywords: ['모터', '서보', '스테핑', '구동']
        },
        {
          id: 'power',
          name: '전원',
          description: '전원공급장치, UPS 등',
          keywords: ['전원', '파워', 'UPS', '배전']
        },
        {
          id: 'custom',
          name: '기타',
          description: '기타 전기 관련 이슈',
          allowCustomInput: true
        }
      ]
    },
    {
      id: 'control',
      name: '제어',
      icon: '💻',
      color: '#10b981',
      description: '제어 및 소프트웨어 관련 이슈',
      subcategories: [
        {
          id: 'robot',
          name: '로봇',
          description: '로봇 제어 및 프로그램',
          keywords: ['로봇', 'ABB', '제어', '티칭', '프로그램']
        },
        {
          id: 'ui_hmi',
          name: 'UI/HMI',
          description: '사용자 인터페이스 및 HMI',
          keywords: ['UI', 'HMI', '화면', '인터페이스', '터치스크린']
        },
        {
          id: 'measurement',
          name: '계측',
          description: '측정 및 검증 관련',
          keywords: ['계측', '측정', '검증', 'Hexagon', '정밀도']
        },
        {
          id: 'plc',
          name: 'PLC',
          description: 'PLC 프로그램 및 로직',
          keywords: ['PLC', '래더', '로직', '시퀀스']
        },
        {
          id: 'devicenet',
          name: 'DeviceNet',
          description: 'DeviceNet 통신 관련',
          keywords: ['DeviceNet', '통신', 'Lincoln', '용접기']
        },
        {
          id: 'custom',
          name: '기타',
          description: '기타 제어 관련 이슈',
          allowCustomInput: true
        }
      ]
    }
  ],
  customCategories: []
};

// CORS 허용 헤더 추가 함수
// Google Apps Script 웹 앱은 "모든 사용자" 배포 시 자동으로 CORS를 지원합니다.
// 배포 설정: Execute as "Me" + Who has access "Anyone"
function createCORSResponse(data) {
  const output = ContentService.createTextOutput(JSON.stringify(data))
    .setMimeType(ContentService.MimeType.JSON);

  return output;
}

function generateTimestamp() {
  return new Date().toISOString();
}

function generateOwnerId() {
  return 'OWNER-' + Utilities.getUuid().split('-')[0].toUpperCase();
}

function generateCategoryId(name) {
  if (name) {
    return name.toString().trim().toLowerCase().replace(/\s+/g, '-');
  }
  return 'category-' + Utilities.getUuid().split('-')[0];
}

function generateCommentId() {
  return 'C-' + Utilities.getUuid();
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
      case 'bulkCreate':
        result = bulkCreateIssues(params.issues || []);
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
      case 'updateComment':
        result = updateComment(params.id, params.comment);
        break;
      case 'deleteComment':
        result = deleteComment(params.id, params.commentId);
        break;
      case 'saveOwners':
        result = saveOwnersData(params.owners || []);
        break;
      case 'saveCategories':
        result = saveCategoriesData(params);
        break;
      default:
        return createCORSResponse({ success: false, error: 'Invalid action' });
    }

    return createCORSResponse(result);
  } catch(error) {
    return createCORSResponse({ success: false, error: error.toString() });
  }
}

function doGet(e) {
  const action = e.parameter.action;

  if (action === 'getAll') {
    return createCORSResponse(getAllIssues());
  } else if (action === 'getById') {
    return createCORSResponse(getIssueById(e.parameter.id));
  } else if (action === 'getOwners') {
    return createCORSResponse({ success: true, data: getOwnersData() });
  } else if (action === 'getCategories') {
    return createCORSResponse({ success: true, data: getCategoriesConfig() });
  } else if (action === 'getEmployees') {
    return createCORSResponse(getEmployees());
  } else if (action === 'getLocations') {
    return createCORSResponse(getLocations());
  }

  return createCORSResponse({ success: false, error: 'Invalid action' });
}

function doOptions() {
  return createCORSResponse({ success: true });
}

// -----------------------------
// 담당자 / 분류 관리 헬퍼 함수
// -----------------------------

function getOrCreateOwnersSheet() {
  const ss = SpreadsheetApp.openById(SHEET_ID);
  let sheet = ss.getSheetByName(SHEET_NAME_OWNERS);

  if (!sheet) {
    sheet = ss.insertSheet(SHEET_NAME_OWNERS);
    initializeOwnersSheet(sheet);
  }

  return sheet;
}

function initializeOwnersSheet(sheet) {
  const headers = ['id', 'name', 'role', 'department', 'phone', 'email', 'created_at', 'updated_at'];
  sheet.getRange(1, 1, 1, headers.length).setValues([headers]);
  sheet.getRange(1, 1, 1, headers.length).setFontWeight('bold');
  sheet.getRange(1, 1, 1, headers.length).setBackground('#2563eb');
  sheet.getRange(1, 1, 1, headers.length).setFontColor('#ffffff');
  sheet.setFrozenRows(1);

  const now = generateTimestamp();
  const rows = DEFAULT_OWNERS.map(owner => [
    generateOwnerId(),
    owner.name,
    owner.role || '담당자',
    owner.department || '',
    owner.phone || '',
    owner.email || '',
    now,
    now
  ]);

  if (rows.length > 0) {
    sheet.getRange(2, 1, rows.length, headers.length).setValues(rows);
  }
}

function readOwnersFromSheet(sheet) {
  const values = sheet.getDataRange().getValues();
  const owners = [];

  for (let i = 1; i < values.length; i++) {
    const row = values[i];
    if (!row[0] || !row[1]) {
      continue;
    }
    owners.push({
      id: row[0],
      name: row[1],
      role: row[2] || '담당자',
      department: row[3] || '',
      phone: row[4] || '',
      email: row[5] || '',
      created_at: row[6] || '',
      updated_at: row[7] || ''
    });
  }

  return owners;
}

function writeOwnersToSheet(sheet, owners) {
  const headersCount = 8;
  const lastRow = sheet.getLastRow();

  if (lastRow > 1) {
    sheet.deleteRows(2, lastRow - 1);
  }

  if (owners.length === 0) {
    return;
  }

  sheet.insertRowsAfter(1, owners.length);
  const rows = owners.map(owner => [
    owner.id,
    owner.name,
    owner.role || '담당자',
    owner.department || '',
    owner.phone || '',
    owner.email || '',
    owner.created_at,
    owner.updated_at
  ]);

  sheet.getRange(2, 1, rows.length, headersCount).setValues(rows);
}

function getOwnersData() {
  const sheet = getOrCreateOwnersSheet();
  let owners = readOwnersFromSheet(sheet);

  if (owners.length === 0) {
    const now = generateTimestamp();
    owners = DEFAULT_OWNERS.map(owner => ({
      id: generateOwnerId(),
      name: owner.name,
      role: owner.role || '담당자',
      department: owner.department || '',
      phone: owner.phone || '',
      email: owner.email || '',
      created_at: now,
      updated_at: now
    }));
    writeOwnersToSheet(sheet, owners);
  }

  return owners;
}

function saveOwnersData(ownersPayload) {
  try {
    const sheet = getOrCreateOwnersSheet();
    const existing = {};
    readOwnersFromSheet(sheet).forEach(owner => {
      existing[owner.id] = owner;
    });

    const now = generateTimestamp();
    const sanitized = (ownersPayload || [])
      .filter(item => item && item.name)
      .map(item => {
        const existingOwner = item.id ? existing[item.id] : null;
        const id = item.id || generateOwnerId();
        return {
          id: id,
          name: item.name,
          role: item.role || '담당자',
          department: item.department || '',
          phone: item.phone || '',
          email: item.email || '',
          created_at: existingOwner ? existingOwner.created_at : (item.created_at || now),
          updated_at: now
        };
      });

    writeOwnersToSheet(sheet, sanitized);

    return { success: true, data: sanitized };
  } catch (error) {
    Logger.log('saveOwnersData error: ' + error.toString());
    return { success: false, error: error.toString() };
  }
}

function getOrCreateCategoriesSheet() {
  const ss = SpreadsheetApp.openById(SHEET_ID);
  let sheet = ss.getSheetByName(SHEET_NAME_CATEGORIES);

  if (!sheet) {
    sheet = ss.insertSheet(SHEET_NAME_CATEGORIES);
    initializeCategoriesSheet(sheet);
  }

  return sheet;
}

function initializeCategoriesSheet(sheet) {
  const headers = ['id', 'name', 'icon', 'color', 'description', 'subcategories', 'created_at', 'updated_at'];
  sheet.getRange(1, 1, 1, headers.length).setValues([headers]);
  sheet.getRange(1, 1, 1, headers.length).setFontWeight('bold');
  sheet.getRange(1, 1, 1, headers.length).setBackground('#047857');
  sheet.getRange(1, 1, 1, headers.length).setFontColor('#ffffff');
  sheet.setFrozenRows(1);

  const now = generateTimestamp();
  const seeded = DEFAULT_CATEGORY_CONFIG.categories.map(category => ({
    id: category.id || generateCategoryId(category.name),
    name: category.name,
    icon: category.icon || '',
    color: category.color || '',
    description: category.description || '',
    subcategories: category.subcategories || [],
    created_at: now,
    updated_at: now
  }));

  if (seeded.length > 0) {
    sheet.getRange(2, 1, seeded.length, headers.length).setValues(
      seeded.map(category => [
        category.id,
        category.name,
        category.icon,
        category.color,
        category.description,
        JSON.stringify(category.subcategories || []),
        category.created_at,
        category.updated_at
      ])
    );
  }
}

function readCategoriesFromSheet(sheet) {
  const values = sheet.getDataRange().getValues();
  const categories = [];

  for (let i = 1; i < values.length; i++) {
    const row = values[i];
    if (!row[0] || !row[1]) {
      continue;
    }

    categories.push({
      id: row[0],
      name: row[1],
      icon: row[2] || '',
      color: row[3] || '',
      description: row[4] || '',
      subcategories: safeJSONParse(row[5], []),
      created_at: row[6] || '',
      updated_at: row[7] || ''
    });
  }

  return categories;
}

function writeCategoriesToSheet(sheet, categories) {
  const headersCount = 8;
  const lastRow = sheet.getLastRow();

  if (lastRow > 1) {
    sheet.deleteRows(2, lastRow - 1);
  }

  if (categories.length === 0) {
    return;
  }

  sheet.insertRowsAfter(1, categories.length);
  const rows = categories.map(category => [
    category.id,
    category.name,
    category.icon || '',
    category.color || '',
    category.description || '',
    JSON.stringify(category.subcategories || []),
    category.created_at,
    category.updated_at
  ]);

  sheet.getRange(2, 1, rows.length, headersCount).setValues(rows);
}

function getCategoriesConfig() {
  const sheet = getOrCreateCategoriesSheet();
  let categories = readCategoriesFromSheet(sheet);

  if (categories.length === 0) {
    const now = generateTimestamp();
    categories = DEFAULT_CATEGORY_CONFIG.categories.map(category => ({
      id: category.id || generateCategoryId(category.name),
      name: category.name,
      icon: category.icon || '',
      color: category.color || '',
      description: category.description || '',
      subcategories: category.subcategories || [],
      created_at: now,
      updated_at: now
    }));
    writeCategoriesToSheet(sheet, categories);
  }

  const lastUpdated = categories.reduce((latest, category) => {
    if (!category.updated_at) {
      return latest;
    }
    if (!latest) {
      return category.updated_at;
    }
    return category.updated_at > latest ? category.updated_at : latest;
  }, '');

  return {
    version: DEFAULT_CATEGORY_CONFIG.version,
    lastUpdated: lastUpdated || DEFAULT_CATEGORY_CONFIG.lastUpdated,
    description: DEFAULT_CATEGORY_CONFIG.description,
    categories: categories.map(category => ({
      id: category.id,
      name: category.name,
      icon: category.icon,
      color: category.color,
      description: category.description,
      subcategories: category.subcategories,
      created_at: category.created_at,
      updated_at: category.updated_at
    })),
    customCategories: DEFAULT_CATEGORY_CONFIG.customCategories || []
  };
}

function saveCategoriesData(configPayload) {
  try {
    const sheet = getOrCreateCategoriesSheet();
    const existingMap = {};
    readCategoriesFromSheet(sheet).forEach(category => {
      existingMap[category.id] = category;
    });

    const now = generateTimestamp();
    const categoriesInput = (configPayload && configPayload.categories) ? configPayload.categories : [];
    const sanitized = categoriesInput
      .filter(category => category && category.name)
      .map(category => {
        const id = category.id || generateCategoryId(category.name);
        const existing = existingMap[id];
        const subcategories = (category.subcategories || []).map(sub => ({
          id: sub.id || generateCategoryId(sub.name),
          name: sub.name,
          description: sub.description || '',
          keywords: sub.keywords || [],
          allowCustomInput: !!sub.allowCustomInput
        }));

        return {
          id: id,
          name: category.name,
          icon: category.icon || '',
          color: category.color || '',
          description: category.description || '',
          subcategories: subcategories,
          created_at: existing ? existing.created_at : (category.created_at || now),
          updated_at: now
        };
      });

    writeCategoriesToSheet(sheet, sanitized);

    const config = {
      version: configPayload && configPayload.version ? configPayload.version : DEFAULT_CATEGORY_CONFIG.version,
      lastUpdated: now,
      description: (configPayload && configPayload.description) ? configPayload.description : DEFAULT_CATEGORY_CONFIG.description,
      categories: sanitized.map(category => ({
        id: category.id,
        name: category.name,
        icon: category.icon,
        color: category.color,
        description: category.description,
        subcategories: category.subcategories,
        created_at: category.created_at,
        updated_at: category.updated_at
      })),
      customCategories: configPayload && configPayload.customCategories ? configPayload.customCategories : []
    };

    return { success: true, data: config };
  } catch (error) {
    Logger.log('saveCategoriesData error: ' + error.toString());
    return { success: false, error: error.toString() };
  }
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
    JSON.stringify(normalizeCommentsData(data.comments || [])),
    timestamp,
    timestamp,
    // 확장성 필드
    JSON.stringify(data.customFields || {}),  // customFields 추가
    data.templateId || ''  // templateId 추가
  ];

  sheet.appendRow(row);

  // 이메일 알림 발송
  sendEmailNotification('create', { id, ...data });

  return { success: true, id: id };
}

// 이슈 일괄 생성
function bulkCreateIssues(issuesData) {
  if (!Array.isArray(issuesData) || issuesData.length === 0) {
    return { success: false, error: '등록할 이슈 데이터가 없습니다.' };
  }

  const ss = SpreadsheetApp.openById(SHEET_ID);
  const sheet = ss.getSheetByName(SHEET_NAME);
  const year = new Date().getFullYear();
  const timestamp = new Date().toISOString();

  const createdIssues = [];
  const failedIssues = [];

  try {
    // 일괄 처리를 위해 현재 lastRow 가져오기
    let currentLastRow = sheet.getLastRow();

    issuesData.forEach((data, index) => {
      try {
        // ID 자동 생성 (PL-YYYY-NNN)
        const num = String(currentLastRow + index).padStart(3, '0');
        const id = `PL-${year}-${num}`;

        const row = [
          id,
          data.title || '',
          data.category || '',
          data.subcategory || '',
          data.priority || '보통',
          data.status || '신규',
          data.description || '',
          data.cause || '',
          data.action_plan || '',
          data.action_result || '',
          data.owner || '',
          data.collaborators || '',
          data.approver || '',
          data.request_date || '',
          data.target_date || '',
          data.complete_date || '',
          JSON.stringify(data.attachments || []),
          JSON.stringify(normalizeCommentsData(data.comments || [])),
          timestamp,
          timestamp,
          JSON.stringify(data.customFields || {}),
          data.templateId || ''
        ];

        sheet.appendRow(row);
        createdIssues.push({ id, title: data.title });

        // 이메일 알림 발송 (선택적)
        if (data.owner) {
          try {
            sendEmailNotification('create', { id, ...data });
          } catch(emailError) {
            Logger.log(`Email notification failed for ${id}: ${emailError.toString()}`);
          }
        }
      } catch(rowError) {
        failedIssues.push({
          index: index + 1,
          title: data.title || '제목 없음',
          error: rowError.toString()
        });
      }
    });

    return {
      success: true,
      created: createdIssues.length,
      failed: failedIssues.length,
      createdIssues: createdIssues,
      failedIssues: failedIssues,
      message: `총 ${issuesData.length}건 중 ${createdIssues.length}건 성공, ${failedIssues.length}건 실패`
    };
  } catch(error) {
    return {
      success: false,
      error: error.toString(),
      created: createdIssues.length,
      createdIssues: createdIssues
    };
  }
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
      sheet.getRange(i + 1, 18).setValue(JSON.stringify(normalizeCommentsData(data.comments || [])));
      sheet.getRange(i + 1, 20).setValue(timestamp);
      // 확장성 필드 업데이트
      sheet.getRange(i + 1, 21).setValue(JSON.stringify(data.customFields || {}));
      sheet.getRange(i + 1, 22).setValue(data.templateId || '');

      // 이메일 알림 발송
      sendEmailNotification('update', data);

      return { success: true };
    }
  }

  return { success: false, error: 'Issue not found' };
}

// 이슈 삭제
function deleteIssue(id) {
  const ss = SpreadsheetApp.openById(SHEET_ID);
  const sheet = ss.getSheetByName(SHEET_NAME);
  const values = sheet.getDataRange().getValues();

  for (let i = 1; i < values.length; i++) {
    if (values[i][0] === id) {
      sheet.deleteRow(i + 1);

      return { success: true };
    }
  }

  return { success: false, error: 'Issue not found' };
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
      comments: normalizeCommentsData(safeJSONParse(row[17], [])),
      created_at: row[18],
      updated_at: row[19],
      // 확장성 필드
      customFields: safeJSONParse(row[20], {}),
      templateId: row[21] || ''
    });
  }

  return { success: true, data: issues };
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
      comments: normalizeCommentsData(safeJSONParse(row[17], [])),
      created_at: row[18],
      updated_at: row[19],
      // 확장성 필드
      customFields: safeJSONParse(row[20], {}),
      templateId: row[21] || ''
      };

      return { success: true, data: issue };
    }
  }

  return { success: false, error: 'Issue not found' };
}

// 댓글 추가
function addComment(issueId, comment) {
  const ss = SpreadsheetApp.openById(SHEET_ID);
  const sheet = ss.getSheetByName(SHEET_NAME);
  const values = sheet.getDataRange().getValues();
  const author = comment && comment.author ? String(comment.author).trim() : '';
  const text = comment && comment.text ? String(comment.text).trim() : '';

  if (!author || !text) {
    return { success: false, error: '작성자와 내용을 입력해주세요.' };
  }

  for (let i = 1; i < values.length; i++) {
    if (values[i][0] === issueId) {
      let comments = normalizeCommentsData(safeJSONParse(values[i][17], []));
      const now = generateTimestamp();
      const newComment = {
        id: generateCommentId(),
        author,
        text,
        created_at: now,
        updated_at: now,
        is_deleted: false
      };
      comments.push(newComment);

      sheet.getRange(i + 1, 18).setValue(JSON.stringify(comments));
      sheet.getRange(i + 1, 20).setValue(now);

      return { success: true, comment: newComment };
    }
  }

  return { success: false, error: 'Issue not found' };
}

function updateComment(issueId, comment) {
  if (!comment || !comment.id) {
    return { success: false, error: '댓글 ID가 필요합니다.' };
  }

  const text = comment.text ? String(comment.text).trim() : '';
  if (!text) {
    return { success: false, error: '내용을 입력해주세요.' };
  }

  const ss = SpreadsheetApp.openById(SHEET_ID);
  const sheet = ss.getSheetByName(SHEET_NAME);
  const values = sheet.getDataRange().getValues();

  for (let i = 1; i < values.length; i++) {
    if (values[i][0] === issueId) {
      const comments = normalizeCommentsData(safeJSONParse(values[i][17], []));
      const index = comments.findIndex(item => item.id === comment.id);
      if (index === -1) {
        return { success: false, error: '댓글을 찾을 수 없습니다.' };
      }

      const now = generateTimestamp();
      comments[index] = {
        ...comments[index],
        text,
        updated_at: now
      };

      sheet.getRange(i + 1, 18).setValue(JSON.stringify(comments));
      sheet.getRange(i + 1, 20).setValue(now);

      return { success: true, comment: comments[index] };
    }
  }

  return { success: false, error: 'Issue not found' };
}

function deleteComment(issueId, commentId) {
  if (!commentId) {
    return { success: false, error: '댓글 ID가 필요합니다.' };
  }

  const ss = SpreadsheetApp.openById(SHEET_ID);
  const sheet = ss.getSheetByName(SHEET_NAME);
  const values = sheet.getDataRange().getValues();

  for (let i = 1; i < values.length; i++) {
    if (values[i][0] === issueId) {
      const comments = normalizeCommentsData(safeJSONParse(values[i][17], []));
      const index = comments.findIndex(item => item.id === commentId);
      if (index === -1) {
        return { success: false, error: '댓글을 찾을 수 없습니다.' };
      }

      const now = generateTimestamp();
      comments[index] = {
        ...comments[index],
        is_deleted: true,
        updated_at: now
      };

      sheet.getRange(i + 1, 18).setValue(JSON.stringify(comments));
      sheet.getRange(i + 1, 20).setValue(now);

      return { success: true, comment: comments[index] };
    }
  }

  return { success: false, error: 'Issue not found' };
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

function normalizeCommentsData(comments) {
  if (!Array.isArray(comments)) {
    return [];
  }

  const now = generateTimestamp();

  return comments
    .map((comment, index) => {
      if (!comment || typeof comment !== 'object') {
        return null;
      }

      const baseId = comment.id || comment.comment_id || comment.uuid;
      const fallbackSource = comment.created_at || comment.timestamp || comment.updated_at || now;
      const fallbackId = typeof fallbackSource === 'string'
        ? fallbackSource.replace(/[^0-9A-Za-z]/g, '')
        : `${index + 1}`;

      const id = baseId || `C-${fallbackId}-${index + 1}`;
      const createdAt = comment.created_at || comment.timestamp || now;
      const updatedAt = comment.updated_at || createdAt;

      return {
        id: id,
        author: comment.author ? String(comment.author) : '',
        text: comment.text ? String(comment.text) : '',
        created_at: createdAt,
        updated_at: updatedAt,
        is_deleted: comment.is_deleted === true
      };
    })
    .filter(Boolean);
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
펀치리스트 확인: https://s2501602.vercel.app/punchlist/index.html
이슈 상세: https://s2501602.vercel.app/punchlist/pages/detail.html?id=${data.id}
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
이슈 상세: https://s2501602.vercel.app/punchlist/pages/detail.html?id=${data.id}
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

// Work Management 관련 함수
// 직원 목록 조회
function getEmployees() {
  // 기본 직원 목록 (필요시 별도 시트에서 읽도록 확장 가능)
  const employeeList = [
    '심태양',
    '김철수',
    '박영희',
    '이영수',
    '최민수'
  ];

  return employeeList;
}

// 위치 목록 조회
function getLocations() {
  // 기본 위치 목록 (필요시 별도 시트에서 읽도록 확장 가능)
  const locationList = [
    '34bay A라인',
    '34bay B라인',
    '사무실',
    '회의실',
    '현장'
  ];

  return locationList;
}

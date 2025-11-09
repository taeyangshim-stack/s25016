/**
 * S25016 펀치리스트 클라이언트 스크립트
 */

// Google Apps Script URL → Vercel 프록시를 기본값으로 사용
const DIRECT_SCRIPT_FALLBACK =
  (typeof window !== 'undefined' && window.PUNCHLIST_DIRECT_URL)
    ? window.PUNCHLIST_DIRECT_URL
    : 'https://script.google.com/macros/s/AKfycbxarys6e5oeI8jt7PHeO11H2LfMW0-P2lhX-NMApVX9-Ir97jnIlgtnElu70LZnUqRa/exec';

const RAW_SCRIPT_URL = (typeof window !== 'undefined' && window.PUNCHLIST_API_URL)
  ? window.PUNCHLIST_API_URL
  : '/api/punchlist';

// Mock 모드 (테스트 전용)
const USE_MOCK_DATA = RAW_SCRIPT_URL === 'mock'
  || (typeof window !== 'undefined'
    && window.location
    && ['localhost', '127.0.0.1'].includes(window.location.hostname)
    && window.location.port === '8000'
    && RAW_SCRIPT_URL === '/api/punchlist');

// 실제 요청에 사용할 URL
const SCRIPT_URL = USE_MOCK_DATA ? '' : RAW_SCRIPT_URL;

// 기본 분류 맵 (API 실패 시 폴백)
const DEFAULT_CATEGORY_MAP = {
  '기계': ['구조물', '프레임', '이송장치', '기타'],
  '전기': ['배선', '센서', '모터', '전원', '기타'],
  '제어': ['로봇', 'UI/HMI', '계측', 'PLC', 'DeviceNet', '기타']
};

let CATEGORIES = { ...DEFAULT_CATEGORY_MAP };

// 우선순위 옵션
const PRIORITIES = ['긴급', '높음', '보통', '낮음'];

// 라인 분류 옵션
const LINE_TYPES = ['A라인', 'B라인', 'A/B라인'];

// 상태 옵션
const STATUSES = ['신규', '진행중', '보류', '완료', '검증중'];

const IMAGE_URL_REGEX = /\.(png|jpe?g|gif|webp|svg)$/i;

function generateCommentId() {
  if (typeof crypto !== 'undefined' && crypto.randomUUID) {
    return `C-${crypto.randomUUID()}`;
  }
  const randomPart = Math.random().toString(36).slice(2, 10).toUpperCase();
  const timePart = Date.now().toString(36).toUpperCase();
  return `C-${timePart}-${randomPart}`;
}

function isImageAttachment(attachment = {}) {
  if (!attachment) return false;
  if (attachment.type) {
    return attachment.type === 'image';
  }
  if (attachment.url) {
    const cleanUrl = attachment.url.split('?')[0];
    return IMAGE_URL_REGEX.test(cleanUrl);
  }
  return false;
}

function normalizeIssue(issue) {
  if (!issue || typeof issue !== 'object') {
    return issue;
  }

  const cloned = { ...issue };
  const customFields = cloned.customFields || {};
  const attachments = Array.isArray(cloned.attachments) ? cloned.attachments : [];

  const imageEntries = attachments
    .filter(isImageAttachment)
    .map(att => ({
      url: att.url || '',
      caption: att.caption || '',
      public_id: att.public_id || '',
      fileName: att.fileName || att.name || ''
    }));

  if (Array.isArray(cloned.images) && cloned.images.length > 0 && imageEntries.length === 0) {
    cloned.images = cloned.images.map(img => ({
      url: img.url || '',
      caption: img.caption || '',
      public_id: img.public_id || '',
      fileName: img.fileName || ''
    }));
  } else {
    cloned.images = imageEntries;
  }

  cloned.line_classification = cloned.line_classification || customFields.line_classification || '';
  const changeLog = Array.isArray(customFields.change_log) ? customFields.change_log : [];
  cloned.customFields = {
    ...customFields,
    line_classification: cloned.line_classification,
    change_log: changeLog
  };
  cloned.change_log = changeLog;
  cloned.comments = normalizeComments(cloned.comments);

  return cloned;
}

function normalizeComments(comments) {
  if (!Array.isArray(comments)) {
    return [];
  }
  return comments
    .map((comment, index) => normalizeComment(comment, index))
    .filter(Boolean);
}

function normalizeComment(comment, index = 0) {
  if (!comment || typeof comment !== 'object') {
    return null;
  }

  const now = new Date().toISOString();
  const cloned = { ...comment };
  const baseId = cloned.id || cloned.comment_id || cloned.uuid;
  const fallbackSource = cloned.created_at || cloned.timestamp || cloned.updated_at || now;
  const fallbackId = typeof fallbackSource === 'string'
    ? fallbackSource.replace(/[^0-9A-Za-z]/g, '')
    : `${Date.now()}`;
  cloned.id = baseId || `C-${fallbackId || (index + 1)}-${index + 1}`;
  cloned.author = (cloned.author || '').toString();
  cloned.text = (cloned.text || '').toString();
  const created = cloned.created_at || cloned.timestamp || now;
  cloned.created_at = created;
  cloned.updated_at = cloned.updated_at || created;
  cloned.is_deleted = Boolean(cloned.is_deleted);

  return cloned;
}

// 기본 담당자 디렉터리 (API 실패 시 폴백)
const DEFAULT_OWNER_DIRECTORY = [
  { id: 'owner-default-1', name: '심태양', role: '담당자', department: '생산기술팀', phone: '', email: 'simsun@kakao.com' },
  { id: 'owner-default-2', name: '김철수', role: '담당자', department: '생산1팀', phone: '', email: '' },
  { id: 'owner-default-3', name: '박영희', role: '담당자', department: '품질팀', phone: '', email: '' },
  { id: 'owner-default-4', name: '이영수', role: '관리자', department: '생산기술팀', phone: '', email: '' },
  { id: 'owner-default-5', name: '최민수', role: '담당자', department: '유지보수팀', phone: '', email: '' }
];

let ownerDirectoryCache = null;
let ownerDirectoryPromise = null;
let OWNERS = DEFAULT_OWNER_DIRECTORY.map(owner => owner.name);

let categoryConfigCache = null;
let categoryConfigPromise = null;

// Mock 데이터
const MOCK_ISSUES = [
  {
    id: 'PL-2025-001',
    title: 'B라인 용접기 DeviceNet 통신 끊김',
    category: '제어',
    subcategory: 'DeviceNet',
    priority: '긴급',
    status: '진행중',
    description: 'B라인 2호기 용접기 DeviceNet 통신이 불안정하여 생산 라인 정지\n에러 코드: E-9999\n발생 빈도: 10분마다 1-2회',
    cause: 'DeviceNet 허브 케이블 접촉 불량으로 판단됨',
    action_plan: '1. 케이블 교체\n2. 통신 파라미터 재설정\n3. ABB 엔지니어 지원 요청',
    action_result: '케이블 교체 후 정상 작동 확인',
    owner: '심태양',
    collaborators: '김철수, 박영희',
    approver: '이영수',
    request_date: '2025-01-15',
    target_date: '2025-01-20',
    complete_date: '',
    attachments: [],
    comments: [
      {
        id: 'C-PL-2025-001-01',
        author: '심태양',
        text: 'DeviceNet 허브는 금일 교체 예정입니다.',
        created_at: '2025-01-15T10:45:00Z',
        updated_at: '2025-01-15T10:45:00Z',
        is_deleted: false
      },
      {
        id: 'C-PL-2025-001-02',
        author: '김철수',
        text: '예비 허브 재고 확인 완료했습니다.',
        created_at: '2025-01-15T11:10:00Z',
        updated_at: '2025-01-15T11:10:00Z',
        is_deleted: false
      }
    ],
    images: [
      {
        url: 'https://placehold.co/600x400/dc2626/white?text=DeviceNet+Error',
        caption: 'DeviceNet 에러 화면'
      },
      {
        url: 'https://placehold.co/600x400/3b82f6/white?text=Cable+Damage',
        caption: '손상된 케이블'
      }
    ],
    created_at: '2025-01-15T09:00:00Z',
    updated_at: '2025-01-15T14:30:00Z',
    customFields: {
      line_classification: 'B라인',
      change_log: [
        {
          timestamp: '2025-01-15T10:30:00Z',
          author: '시스템',
          action: 'update',
          summary: '상태: 신규 → 진행중',
          changes: [
            { field: 'status', label: '상태', before: '신규', after: '진행중' }
          ]
        }
      ],
      customer_impact: '심각',
      downtime_hours: 4,
      production_loss: 200,
      equipment_model: 'Lincoln Power Wave S500'
    },
    templateId: 'emergency'
  },
  {
    id: 'PL-2025-002',
    title: 'A라인 로봇 상하축 간섭 문제',
    category: '제어',
    subcategory: '로봇',
    priority: '높음',
    status: '보류',
    description: 'A라인 갠트리 로봇 상하축이 지그와 간섭 발생\n안전센서 작동으로 긴급 정지',
    cause: '티칭 포인트 설정 오류로 추정',
    action_plan: '1. 로봇 티칭 재확인\n2. 안전 영역 재설정\n3. ABB 엔지니어 현장 지원',
    action_result: '',
    owner: '심태양',
    collaborators: '김철수',
    approver: '이영수',
    request_date: '2025-01-16',
    target_date: '2025-01-18',
    complete_date: '',
    attachments: [],
    comments: [
      {
        id: 'C-PL-2025-002-01',
        author: '심태양',
        text: 'ABB 쪽에 현장 지원 요청 전달했습니다.',
        created_at: '2025-01-16T09:05:00Z',
        updated_at: '2025-01-16T09:05:00Z',
        is_deleted: false
      }
    ],
    images: [
      {
        url: 'https://placehold.co/600x400/f59e0b/white?text=Robot+Interference',
        caption: '로봇 간섭 발생 위치'
      },
      {
        url: 'https://placehold.co/600x400/10b981/white?text=Safety+Zone',
        caption: '안전 영역 설정 화면'
      },
      {
        url: 'https://placehold.co/600x400/6b7280/white?text=Teaching+Point',
        caption: '티칭 포인트 좌표'
      }
    ],
    created_at: '2025-01-16T08:30:00Z',
    updated_at: '2025-01-16T10:00:00Z',
    customFields: {
      line_classification: 'A라인',
      change_log: [
        {
          timestamp: '2025-01-16T09:30:00Z',
          author: '시스템',
          action: 'update',
          summary: '우선순위: 긴급 → 높음',
          changes: [
            { field: 'priority', label: '우선순위', before: '긴급', after: '높음' }
          ]
        }
      ],
      vendor_name: 'ABB Korea',
      vendor_contact: '김엔지니어 (010-1234-5678)',
      risk_level: '상'
    },
    templateId: 'vendor-issue'
  },
  {
    id: 'PL-2025-003',
    title: 'A라인 로봇 월간점검',
    category: '기계',
    subcategory: '이송장치',
    priority: '보통',
    status: '신규',
    description: 'IRB 6700 로봇 정기 월간 점검\n- 정밀 진동 측정\n- 베어링 상태 점검\n- 윤활유 보충\n- 소프트웨어 백업',
    cause: '',
    action_plan: '',
    action_result: '',
    owner: '박영희',
    collaborators: '',
    approver: '이영수',
    request_date: '2025-01-17',
    target_date: '2025-01-19',
    complete_date: '',
    attachments: [],
    comments: [
      {
        id: 'C-PL-2025-003-01',
        author: '박영희',
        text: '점검 체크리스트 공유 부탁드립니다.',
        created_at: '2025-01-17T08:00:00Z',
        updated_at: '2025-01-17T08:00:00Z',
        is_deleted: false
      }
    ],
    created_at: '2025-01-17T07:00:00Z',
    updated_at: '2025-01-17T07:00:00Z',
    customFields: {
      line_classification: 'A라인',
      change_log: [],
      equipment_serial: 'ABB-IRB6700-2024-001',
      equipment_model: 'ABB IRB 6700-200/2.60',
      manufacturer: 'ABB'
    },
    templateId: 'inspection'
  },
  {
    id: 'PL-2025-004',
    title: '용접 비드 불량 (기공 발생)',
    category: '제어',
    subcategory: '로봇',
    priority: '높음',
    status: '완료',
    description: 'A라인 1호기 하부 용접부에 기공 발생\n발생 수량: 15개 / 100개',
    cause: 'DeviceNet 가스 유량 파라미터 설정 오류\n가스 유량이 15 L/min으로 낮게 설정됨 (정상: 20 L/min)',
    action_plan: '【임시 조치】\n1. 불량품 15개 격리\n2. 가스 유량 수동 조정 (15 → 20 L/min)\n3. 재작업 실시\n\n【항구 대책】\n1. DeviceNet 가스 유량 파라미터 수정\n2. 용접 조건 표준서 개정\n3. 작업자 재교육',
    action_result: '가스 유량 파라미터 수정 완료\n재작업 15개 완료 후 검사 합격\n표준서 개정 및 작업자 교육 완료',
    owner: '김철수',
    collaborators: '심태양',
    approver: '최민수',
    request_date: '2025-01-10',
    target_date: '2025-01-13',
    complete_date: '2025-01-14',
    attachments: [],
    comments: [
      {
        id: 'C-PL-2025-004-01',
        author: '김철수',
        text: '재작업 후 품질검사 완료. 결과 공유드립니다.',
        created_at: '2025-01-14T16:10:00Z',
        updated_at: '2025-01-14T16:10:00Z',
        is_deleted: false
      }
    ],
    images: [
      {
        url: 'https://placehold.co/600x400/dc2626/white?text=Weld+Defect',
        caption: '용접 기공 불량 (확대)'
      },
      {
        url: 'https://placehold.co/600x400/f59e0b/white?text=Before+Repair',
        caption: '수정 전'
      },
      {
        url: 'https://placehold.co/600x400/10b981/white?text=After+Repair',
        caption: '수정 후'
      },
      {
        url: 'https://placehold.co/600x400/3b82f6/white?text=Gas+Flow+Setting',
        caption: 'DeviceNet 가스 유량 파라미터'
      }
    ],
    created_at: '2025-01-10T10:00:00Z',
    updated_at: '2025-01-14T16:00:00Z',
    customFields: {
      line_classification: 'A라인',
      change_log: [
        {
          timestamp: '2025-01-13T18:00:00Z',
          author: '시스템',
          action: 'update',
          summary: '상태: 진행중 → 완료',
          changes: [
            { field: 'status', label: '상태', before: '진행중', after: '완료' },
            { field: 'complete_date', label: '완료일', before: '', after: '2025-01-14' }
          ]
        }
      ],
      defect_rate: 15,
      inspection_result: '합격',
      production_loss: 15,
      customer_impact: '중간'
    },
    templateId: 'quality-issue'
  },
  {
    id: 'PL-2025-005',
    title: 'B라인 센서 교체 필요',
    category: '전기',
    subcategory: '센서',
    priority: '보통',
    status: '신규',
    description: 'B라인 안전 센서 노후화로 오작동 빈번\n교체 권장',
    cause: '',
    action_plan: '',
    action_result: '',
    owner: '최민수',
    collaborators: '',
    approver: '이영수',
    request_date: '2025-01-18',
    target_date: '2025-01-25',
    complete_date: '',
    attachments: [],
    comments: [],
    created_at: '2025-01-18T09:00:00Z',
    updated_at: '2025-01-18T09:00:00Z',
    customFields: {
      line_classification: 'B라인',
      change_log: []
    },
    templateId: ''
  }
];

MOCK_ISSUES.forEach((issue, index) => {
  MOCK_ISSUES[index] = normalizeIssue(issue);
});

function cloneOwnerDirectory(list) {
  return (list || []).map(owner => ({
    id: owner.id || '',
    name: owner.name || '',
    role: owner.role || '담당자',
    department: owner.department || '',
    phone: owner.phone || '',
    email: owner.email || '',
    created_at: owner.created_at || '',
    updated_at: owner.updated_at || ''
  }));
}

function updateOwnerCache(newOwners) {
  ownerDirectoryCache = cloneOwnerDirectory(newOwners);
  OWNERS = ownerDirectoryCache.map(owner => owner.name || '').filter(Boolean);
}

function getOwnerDirectorySnapshot() {
  if (ownerDirectoryCache && ownerDirectoryCache.length > 0) {
    return cloneOwnerDirectory(ownerDirectoryCache);
  }
  return cloneOwnerDirectory(DEFAULT_OWNER_DIRECTORY);
}

function getOwnerNamesSnapshot() {
  if (OWNERS && OWNERS.length > 0) {
    return [...OWNERS];
  }
  return DEFAULT_OWNER_DIRECTORY.map(owner => owner.name);
}

function buildCategoryMapFromConfig(config) {
  if (!config || !Array.isArray(config.categories)) {
    return { ...DEFAULT_CATEGORY_MAP };
  }

  const map = {};
  config.categories.forEach(category => {
    if (!category || !category.name) {
      return;
    }

    map[category.name] = (category.subcategories || [])
      .map(sub => sub.name)
      .filter(Boolean);
  });

  return map;
}

function cloneCategoryConfig(config) {
  if (!config) {
    return null;
  }

  return {
    version: config.version,
    lastUpdated: config.lastUpdated,
    description: config.description,
    categories: (config.categories || []).map(category => ({
      id: category.id,
      name: category.name,
      icon: category.icon,
      color: category.color,
      description: category.description,
      subcategories: (category.subcategories || []).map(sub => ({
        id: sub.id,
        name: sub.name,
        description: sub.description,
        keywords: Array.isArray(sub.keywords) ? [...sub.keywords] : [],
        allowCustomInput: !!sub.allowCustomInput
      })),
      created_at: category.created_at,
      updated_at: category.updated_at
    })),
    customCategories: Array.isArray(config.customCategories)
      ? config.customCategories.map(item => ({ ...item }))
      : []
  };
}

function updateCategoryCache(config) {
  const baseDescription = 'S25016 프로젝트 이슈 분류 체계';
  const sanitized =
    config && typeof config === 'object'
      ? cloneCategoryConfig({
          ...config,
          description: config.description || baseDescription
        })
      : null;

  if (sanitized) {
    categoryConfigCache = sanitized;
  } else {
    categoryConfigCache = cloneCategoryConfig({
      version: '1.0',
      lastUpdated: '',
      description: baseDescription,
      categories: [],
      customCategories: []
    });
  }

  CATEGORIES = buildCategoryMapFromConfig(categoryConfigCache);
}

function getCategoryConfigSnapshot() {
  if (categoryConfigCache) {
    return cloneCategoryConfig(categoryConfigCache);
  }

  const fallback = {
    version: '1.0',
    lastUpdated: '',
    description: 'S25016 프로젝트 이슈 분류 체계',
    categories: Object.entries(DEFAULT_CATEGORY_MAP).map(([name, subs], index) => ({
      id: `default-${index + 1}`,
      name,
      icon: '',
      color: '',
      description: '',
      subcategories: subs.map((subName, subIndex) => ({
        id: `default-${index + 1}-${subIndex + 1}`,
        name: subName,
        description: '',
        keywords: [],
        allowCustomInput: subName === '기타'
      })),
      created_at: '',
      updated_at: ''
    })),
    customCategories: []
  };

  return cloneCategoryConfig(fallback);
}

async function fetchDefaultCategoryConfigFromStatic() {
  try {
    const response = await fetch('/punchlist/config/categories.json', { cache: 'no-store' });
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }
    return await response.json();
  } catch (error) {
    console.warn('정적 분류 구성 로드 실패:', error);
    return getCategoryConfigSnapshot();
  }
}

async function ensureOwnersLoaded(forceRefresh = false) {
  if (forceRefresh) {
    ownerDirectoryCache = null;
    ownerDirectoryPromise = null;
  }

  if (ownerDirectoryCache && !forceRefresh) {
    return getOwnerDirectorySnapshot();
  }

  if (USE_MOCK_DATA) {
    updateOwnerCache(DEFAULT_OWNER_DIRECTORY);
    return getOwnerDirectorySnapshot();
  }

  if (!ownerDirectoryPromise) {
    ownerDirectoryPromise = (async () => {
      try {
        const response = await fetch(`${SCRIPT_URL}?action=getOwners`, {
          method: 'GET',
          cache: 'no-store'
        });
        if (!response.ok) {
          throw new Error(`HTTP ${response.status}`);
        }
        const result = await response.json();
        if (!result.success || !Array.isArray(result.data)) {
          throw new Error(result.error || '담당자 목록 응답이 올바르지 않습니다.');
        }
        updateOwnerCache(result.data);
      } catch (error) {
        console.error('담당자 목록 로드 실패:', error);
        if (!ownerDirectoryCache) {
          updateOwnerCache(DEFAULT_OWNER_DIRECTORY);
        }
      }
      const snapshot = getOwnerDirectorySnapshot();
      ownerDirectoryPromise = null;
      return snapshot;
    })();
  }

  return ownerDirectoryPromise;
}

async function reloadOwnerDirectory() {
  return ensureOwnersLoaded(true);
}

async function saveOwnerDirectory(owners) {
  const payload = (owners || []).map(owner => ({
    id: owner.id,
    name: owner.name,
    role: owner.role || '담당자',
    department: owner.department || '',
    phone: owner.phone || '',
    email: owner.email || '',
    created_at: owner.created_at,
    updated_at: owner.updated_at
  }));

  if (USE_MOCK_DATA) {
    updateOwnerCache(payload);
    return getOwnerDirectorySnapshot();
  }

  const response = await fetch(SCRIPT_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      action: 'saveOwners',
      owners: payload
    })
  });

  const result = await response.json();

  if (!response.ok || !result.success) {
    throw new Error(result.error || `HTTP ${response.status}`);
  }

  updateOwnerCache(result.data);
  return getOwnerDirectorySnapshot();
}

async function ensureCategoriesLoaded(forceRefresh = false) {
  if (forceRefresh) {
    categoryConfigCache = null;
    categoryConfigPromise = null;
  }

  if (categoryConfigCache && !forceRefresh) {
    return getCategoryConfigSnapshot();
  }

  if (USE_MOCK_DATA) {
    const fallback = await fetchDefaultCategoryConfigFromStatic();
    updateCategoryCache(fallback);
    return getCategoryConfigSnapshot();
  }

  if (!categoryConfigPromise) {
    categoryConfigPromise = (async () => {
      try {
        const response = await fetch(`${SCRIPT_URL}?action=getCategories`, {
          method: 'GET',
          cache: 'no-store'
        });
        if (!response.ok) {
          throw new Error(`HTTP ${response.status}`);
        }
        const result = await response.json();
        if (!result.success || !result.data) {
          throw new Error(result.error || '분류 구성 응답이 올바르지 않습니다.');
        }
        updateCategoryCache(result.data);
      } catch (error) {
        console.error('분류 구성 로드 실패:', error);
        const fallback = await fetchDefaultCategoryConfigFromStatic();
        updateCategoryCache(fallback);
      }
      const snapshot = getCategoryConfigSnapshot();
      categoryConfigPromise = null;
      return snapshot;
    })();
  }

  return categoryConfigPromise;
}

async function reloadCategoryConfig() {
  return ensureCategoriesLoaded(true);
}

async function saveCategoryConfig(config) {
  const payload = {
    version: config && config.version ? config.version : '1.0',
    description: config && config.description ? config.description : 'S25016 프로젝트 이슈 분류 체계',
    categories: (config && Array.isArray(config.categories)) ? config.categories.map(category => ({
      id: category.id,
      name: category.name,
      icon: category.icon || '',
      color: category.color || '',
      description: category.description || '',
      subcategories: (category.subcategories || []).map(sub => ({
        id: sub.id,
        name: sub.name,
        description: sub.description || '',
        keywords: Array.isArray(sub.keywords) ? sub.keywords : [],
        allowCustomInput: !!sub.allowCustomInput
      })),
      created_at: category.created_at,
      updated_at: category.updated_at
    })) : [],
    customCategories: (config && Array.isArray(config.customCategories)) ? config.customCategories : []
  };

  if (USE_MOCK_DATA) {
    updateCategoryCache(payload);
    return getCategoryConfigSnapshot();
  }

  const response = await fetch(SCRIPT_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      action: 'saveCategories',
      version: payload.version,
      description: payload.description,
      categories: payload.categories,
      customCategories: payload.customCategories
    })
  });

  const result = await response.json();

  if (!response.ok || !result.success) {
    throw new Error(result.error || `HTTP ${response.status}`);
  }

  updateCategoryCache(result.data);
  return getCategoryConfigSnapshot();
}

function getCategoryMapSnapshot() {
  const entries = Object.entries(CATEGORIES).map(([key, list]) => [key, [...list]]);
  return Object.fromEntries(entries);
}

// 전체 이슈 로드
async function loadAllIssues() {
  // Mock 모드
  if (USE_MOCK_DATA) {
    console.log('🔧 Mock 모드: 테스트 데이터 사용 중');
    return new Promise(resolve => {
      setTimeout(() => resolve([...MOCK_ISSUES].map(normalizeIssue)), 300);
    });
  }

  const primaryResult = await requestIssueList(SCRIPT_URL);
  if (primaryResult) {
    return primaryResult;
  }

  if (SCRIPT_URL !== DIRECT_SCRIPT_FALLBACK) {
    const fallbackResult = await requestIssueList(DIRECT_SCRIPT_FALLBACK);
    if (fallbackResult) {
      return fallbackResult;
    }
  }

  console.warn('⚠️ API 응답이 없어 Mock 데이터로 대체합니다. backend 설정 또는 Google Apps Script 권한을 확인하세요.');
  return [...MOCK_ISSUES].map(normalizeIssue);
}

async function requestIssueList(baseUrl) {
  if (!baseUrl) {
    return null;
  }

  try {
    const separator = baseUrl.includes('?') ? '&' : '?';
    const response = await fetch(`${baseUrl}${separator}action=getAll`, {
      method: 'GET',
      cache: 'no-store'
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    const result = await response.json();
    if (!result.success || !Array.isArray(result.data)) {
      throw new Error(result.error || '응답 형식이 올바르지 않습니다.');
    }

    return result.data.map(normalizeIssue);
  } catch (error) {
    console.error(`[PunchListAPI] 이슈 로드 실패 (${baseUrl}):`, error);
    return null;
  }
}

// ID로 이슈 로드
async function loadIssueById(id) {
  // Mock 모드
  if (USE_MOCK_DATA) {
    console.log('🔧 Mock 모드: 테스트 데이터 사용 중');
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        const issue = MOCK_ISSUES.find(i => i.id === id);
        if (issue) {
          resolve(normalizeIssue({...issue}));
        } else {
          reject(new Error('Issue not found'));
        }
      }, 300);
    });
  }

  // 실제 API 호출
  try {
    const response = await fetch(`${SCRIPT_URL}?action=getById&id=${id}`, {
      method: 'GET'
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    const result = await response.json();

    if (result.success) {
      return normalizeIssue(result.data);
    } else {
      throw new Error(result.error);
    }
  } catch (error) {
    console.error('이슈 로드 실패:', error);
    const fallback = MOCK_ISSUES.find(issue => issue.id === id);
    if (fallback) {
      console.warn('⚠️ API 응답이 없어 Mock 데이터로 대체합니다. 로컬 개발 중이면 backend 설정을 확인하세요.');
      return normalizeIssue({ ...fallback });
    }
    throw error;
  }
}

// 이슈 생성
async function createIssue(issueData) {
  // Mock 모드
  if (USE_MOCK_DATA) {
    console.log('🔧 Mock 모드: 이슈 생성 시뮬레이션');
    return new Promise(resolve => {
      setTimeout(() => {
        const attachments = Array.isArray(issueData.attachments) ? issueData.attachments : [];
        const newIssue = {
          id: `PL-2025-${String(MOCK_ISSUES.length + 1).padStart(3, '0')}`,
          ...issueData,
          attachments,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString()
        };
        MOCK_ISSUES.push(normalizeIssue(newIssue));
        console.log('✅ Mock 이슈 생성:', newIssue.id);
        resolve({ success: true, id: newIssue.id });
      }, 500);
    });
  }

  // 실제 API 호출
  try {
    const response = await fetch(SCRIPT_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        action: 'create',
        data: issueData
      })
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    const result = await response.json();

    if (!result.success) {
      throw new Error(result.error || '이슈 생성에 실패했습니다.');
    }

    return result;
  } catch (error) {
    console.error('이슈 생성 실패:', error);
    throw error;
  }
}

// 이슈 수정
async function updateIssue(issueData) {
  // Mock 모드
  if (USE_MOCK_DATA) {
    console.log('🔧 Mock 모드: 이슈 수정 시뮬레이션');
    return new Promise(resolve => {
      setTimeout(() => {
        const index = MOCK_ISSUES.findIndex(i => i.id === issueData.id);
        if (index !== -1) {
          const attachments = Array.isArray(issueData.attachments) ? issueData.attachments : MOCK_ISSUES[index].attachments || [];
          MOCK_ISSUES[index] = normalizeIssue({
            ...MOCK_ISSUES[index],
            ...issueData,
            attachments,
            updated_at: new Date().toISOString()
          });
          console.log('✅ Mock 이슈 수정:', issueData.id);
        }
        resolve({ success: true });
      }, 500);
    });
  }

  // 실제 API 호출
  try {
    const response = await fetch(SCRIPT_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        action: 'update',
        data: issueData
      })
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    const result = await response.json();

    if (!result.success) {
      throw new Error(result.error || '이슈 수정에 실패했습니다.');
    }

    return result;
  } catch (error) {
    console.error('이슈 수정 실패:', error);
    throw error;
  }
}

// 이슈 삭제
async function deleteIssue(id) {
  // Mock 모드
  if (USE_MOCK_DATA) {
    console.log('🔧 Mock 모드: 이슈 삭제 시뮬레이션');
    return new Promise(resolve => {
      setTimeout(() => {
        const index = MOCK_ISSUES.findIndex(i => i.id === id);
        if (index !== -1) {
          MOCK_ISSUES.splice(index, 1);
          console.log('✅ Mock 이슈 삭제:', id);
        }
        resolve({ success: true });
      }, 500);
    });
  }

  // 실제 API 호출
  try {
    const response = await fetch(SCRIPT_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        action: 'delete',
        id: id
      })
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    const result = await response.json();

    if (!result.success) {
      throw new Error(result.error || '이슈 삭제에 실패했습니다.');
    }

    return result;
  } catch (error) {
    console.error('이슈 삭제 실패:', error);
    throw error;
  }
}

// 댓글 추가
async function addComment(issueId, authorOrPayload, maybeText) {
  const payload = typeof authorOrPayload === 'object'
    ? { ...authorOrPayload }
    : { author: authorOrPayload, text: maybeText };

  if (!payload || !payload.author || !payload.text) {
    throw new Error('작성자와 내용을 입력해 주세요.');
  }

  if (USE_MOCK_DATA) {
    const issue = MOCK_ISSUES.find(i => i.id === issueId);
    if (!issue) {
      throw new Error('해당 이슈를 찾을 수 없습니다.');
    }
    const now = new Date().toISOString();
    const newComment = normalizeComment({
      id: generateCommentId(),
      author: payload.author,
      text: payload.text,
      created_at: now,
      updated_at: now,
      is_deleted: false
    });
    issue.comments = normalizeComments([...issue.comments, newComment]);
    return { success: true, comment: newComment };
  }

  try {
    const response = await fetch(SCRIPT_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        action: 'addComment',
        id: issueId,
        comment: {
          author: payload.author,
          text: payload.text
        }
      })
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    const result = await response.json();

    if (!result.success) {
      throw new Error(result.error || '댓글 추가에 실패했습니다.');
    }

    const comment = normalizeComment(result.comment);
    return { success: true, comment };
  } catch (error) {
    console.error('댓글 추가 실패:', error);
    throw error;
  }
}

async function updateComment(issueId, commentId, text) {
  if (!text) {
    throw new Error('내용을 입력해 주세요.');
  }

  if (USE_MOCK_DATA) {
    const issue = MOCK_ISSUES.find(i => i.id === issueId);
    if (!issue) {
      throw new Error('해당 이슈를 찾을 수 없습니다.');
    }
    const idx = issue.comments.findIndex(comment => comment.id === commentId);
    if (idx === -1) {
      throw new Error('댓글을 찾을 수 없습니다.');
    }
    const updated = {
      ...issue.comments[idx],
      text,
      updated_at: new Date().toISOString()
    };
    issue.comments.splice(idx, 1, normalizeComment(updated));
    return { success: true, comment: issue.comments[idx] };
  }

  try {
    const response = await fetch(SCRIPT_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        action: 'updateComment',
        id: issueId,
        comment: {
          id: commentId,
          text
        }
      })
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    const result = await response.json();
    if (!result.success) {
      throw new Error(result.error || '댓글 수정에 실패했습니다.');
    }

    const comment = normalizeComment(result.comment);
    return { success: true, comment };
  } catch (error) {
    console.error('댓글 수정 실패:', error);
    throw error;
  }
}

async function deleteComment(issueId, commentId) {
  if (USE_MOCK_DATA) {
    const issue = MOCK_ISSUES.find(i => i.id === issueId);
    if (!issue) {
      throw new Error('해당 이슈를 찾을 수 없습니다.');
    }
    const idx = issue.comments.findIndex(comment => comment.id === commentId);
    if (idx === -1) {
      throw new Error('댓글을 찾을 수 없습니다.');
    }
    const updated = {
      ...issue.comments[idx],
      is_deleted: true,
      updated_at: new Date().toISOString()
    };
    issue.comments.splice(idx, 1, normalizeComment(updated));
    return { success: true, comment: issue.comments[idx] };
  }

  try {
    const response = await fetch(SCRIPT_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        action: 'deleteComment',
        id: issueId,
        commentId
      })
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    const result = await response.json();
    if (!result.success) {
      throw new Error(result.error || '댓글 삭제에 실패했습니다.');
    }

    const comment = normalizeComment(result.comment);
    return { success: true, comment };
  } catch (error) {
    console.error('댓글 삭제 실패:', error);
    throw error;
  }
}

// 날짜 포맷팅
function formatDate(dateString) {
  if (!dateString) return '-';

  const date = new Date(dateString);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');

  return `${year}-${month}-${day}`;
}

// 날짜/시간 포맷팅
function formatDateTime(dateString) {
  if (!dateString) return '-';

  const date = new Date(dateString);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');

  return `${year}-${month}-${day} ${hours}:${minutes}`;
}

// 우선순위 색상
function getPriorityColor(priority) {
  const colors = {
    '긴급': '#dc2626',
    '높음': '#f59e0b',
    '보통': '#3b82f6',
    '낮음': '#6b7280'
  };

  return colors[priority] || '#6b7280';
}

// 상태 색상
function getStatusColor(status) {
  const colors = {
    '신규': '#3b82f6',
    '진행중': '#f59e0b',
    '보류': '#6b7280',
    '완료': '#10b981',
    '검증중': '#8b5cf6'
  };

  return colors[status] || '#6b7280';
}

// 상태 배지 HTML
function getStatusBadge(status) {
  const color = getStatusColor(status);
  return `<span class="badge" style="background: ${color};">${status}</span>`;
}

// 우선순위 배지 HTML
function getPriorityBadge(priority) {
  const color = getPriorityColor(priority);
  return `<span class="badge" style="background: ${color};">${priority}</span>`;
}

// 필터링
function filterIssues(issues, filters) {
  let filtered = [...issues];

  // 라인 분류 필터
  if (filters.line && filters.line !== 'all') {
    filtered = filtered.filter(issue => (issue.line_classification || '') === filters.line);
  }

  // 분류 필터
  if (filters.category && filters.category !== 'all') {
    filtered = filtered.filter(issue => issue.category === filters.category);
  }

  // 세부분류 필터
  if (filters.subcategory && filters.subcategory !== 'all') {
    filtered = filtered.filter(issue => issue.subcategory === filters.subcategory);
  }

  // 상태 필터
  if (filters.status && filters.status !== 'all') {
    filtered = filtered.filter(issue => issue.status === filters.status);
  }

  // 우선순위 필터
  if (filters.priority && filters.priority !== 'all') {
    filtered = filtered.filter(issue => issue.priority === filters.priority);
  }

  // 담당자 필터
  if (filters.owner && filters.owner !== 'all') {
    filtered = filtered.filter(issue => issue.owner === filters.owner);
  }

  // 검색어 필터
  if (filters.search) {
    const search = filters.search.toLowerCase();
    filtered = filtered.filter(issue =>
      issue.title.toLowerCase().includes(search) ||
      issue.description.toLowerCase().includes(search) ||
      issue.id.toLowerCase().includes(search)
    );
  }

  return filtered;
}

// 정렬
function sortIssues(issues, sortBy, sortOrder = 'asc', options = {}) {
  const sorted = [...issues];
  const { excludeColumn, excludeValue } = options;

  sorted.sort((a, b) => {
    if (excludeColumn && excludeValue) {
      const aExcluded = a[excludeColumn] === excludeValue;
      const bExcluded = b[excludeColumn] === excludeValue;
      if (aExcluded && !bExcluded) return 1;
      if (!aExcluded && bExcluded) return -1;
    }

    let aVal = a[sortBy];
    let bVal = b[sortBy];

    // 날짜 정렬
    if (sortBy.includes('date')) {
      aVal = new Date(aVal || '9999-12-31');
      bVal = new Date(bVal || '9999-12-31');
    }

    // 우선순위 정렬
    if (sortBy === 'priority') {
      const priorityOrder = { '긴급': 0, '높음': 1, '보통': 2, '낮음': 3 };
      aVal = priorityOrder[aVal] || 999;
      bVal = priorityOrder[bVal] || 999;
    }

    if (aVal < bVal) return sortOrder === 'asc' ? -1 : 1;
    if (aVal > bVal) return sortOrder === 'asc' ? 1 : -1;
    return 0;
  });

  return sorted;
}

function isRecentlyUpdated(issue, hours = 72) {
  if (!issue) return false;
  const timestamp = issue.updated_at || issue.updatedAt || '';
  if (!timestamp) return false;

  const updatedAt = new Date(timestamp);
  if (Number.isNaN(updatedAt.getTime())) {
    return false;
  }

  const thresholdMs = hours * 60 * 60 * 1000;
  return (Date.now() - updatedAt.getTime()) <= thresholdMs;
}

function getLineBadge(line) {
  if (!line) return '';
  // 가독성 개선: 라인별 색상 뱃지 클래스 사용
  const lineClass = line.replace(/\//g, '_'); // "A/B라인" -> "A_B라인"
  return `<span class="line-badge badge-${lineClass}">${line}</span>`;
}

// 통계 계산
function calculateStats(issues) {
  const stats = {
    total: issues.length,
    byStatus: {},
    byCategory: {},
    byPriority: {},
    byOwner: {},
    overdue: 0
  };

  const today = new Date();

  issues.forEach(issue => {
    // 상태별
    stats.byStatus[issue.status] = (stats.byStatus[issue.status] || 0) + 1;

    // 분류별
    const categoryKey = `${issue.category}-${issue.subcategory}`;
    stats.byCategory[categoryKey] = (stats.byCategory[categoryKey] || 0) + 1;

    // 우선순위별
    stats.byPriority[issue.priority] = (stats.byPriority[issue.priority] || 0) + 1;

    // 담당자별
    stats.byOwner[issue.owner] = (stats.byOwner[issue.owner] || 0) + 1;

    // 지연 건수
    if (issue.target_date && issue.status !== '완료') {
      const targetDate = new Date(issue.target_date);
      if (targetDate < today) {
        stats.overdue++;
      }
    }
  });

  return stats;
}

// LocalStorage에 저장
function saveToLocalStorage(key, data) {
  try {
    localStorage.setItem(key, JSON.stringify(data));
  } catch (error) {
    console.error('LocalStorage 저장 실패:', error);
  }
}

// LocalStorage에서 로드
function loadFromLocalStorage(key) {
  try {
    const data = localStorage.getItem(key);
    return data ? JSON.parse(data) : null;
  } catch (error) {
    console.error('LocalStorage 로드 실패:', error);
    return null;
  }
}

// 지연 여부 확인
function isOverdue(issue) {
  if (!issue.target_date || issue.status === '완료') {
    return false;
  }

  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const targetDate = new Date(issue.target_date);
  targetDate.setHours(0, 0, 0, 0);

  return targetDate < today;
}

const PunchListAPIExports = {
  loadAllIssues,
  loadIssueById,
  createIssue,
  updateIssue,
  deleteIssue,
  addComment,
  updateComment,
  deleteComment,
  formatDate,
  formatDateTime,
  getPriorityColor,
  getStatusColor,
  getStatusBadge,
  getPriorityBadge,
  getLineBadge,
  filterIssues,
  sortIssues,
  calculateStats,
  saveToLocalStorage,
  loadFromLocalStorage,
  isOverdue,
  isRecentlyUpdated,
  ensureOwnersLoaded,
  reloadOwnerDirectory,
  saveOwnerDirectory,
  getOwnerDirectory: () => getOwnerDirectorySnapshot(),
  getOwnerNames: () => getOwnerNamesSnapshot(),
  ensureCategoriesLoaded,
  reloadCategoryConfig,
  saveCategoryConfig,
  getCategoryConfig: () => getCategoryConfigSnapshot(),
  getCategoryMap: () => getCategoryMapSnapshot(),
  PRIORITIES,
  STATUSES,
  LINE_TYPES
};

Object.defineProperty(PunchListAPIExports, 'CATEGORIES', {
  get() {
    return getCategoryMapSnapshot();
  }
});

Object.defineProperty(PunchListAPIExports, 'OWNERS', {
  get() {
    return getOwnerNamesSnapshot();
  }
});

window.PunchListAPI = PunchListAPIExports;
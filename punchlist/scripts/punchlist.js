/**
 * S25016 펀치리스트 클라이언트 스크립트
 */

// Google Apps Script URL → Vercel 프록시를 기본값으로 사용
const RAW_SCRIPT_URL = (typeof window !== 'undefined' && window.PUNCHLIST_API_URL)
  ? window.PUNCHLIST_API_URL
  : '/api/punchlist';

// Mock 모드 (테스트 전용)
const USE_MOCK_DATA = RAW_SCRIPT_URL === 'mock';

// 실제 요청에 사용할 URL
const SCRIPT_URL = USE_MOCK_DATA ? '' : RAW_SCRIPT_URL;

// 분류 옵션
const CATEGORIES = {
  '기계': ['구조물', '프레임', '이송장치', '기타'],
  '전기': ['배선', '센서', '모터', '전원', '기타'],
  '제어': ['로봇', 'UI/HMI', '계측', 'PLC', 'DeviceNet', '기타']
};

// 우선순위 옵션
const PRIORITIES = ['긴급', '높음', '보통', '낮음'];

// 상태 옵션
const STATUSES = ['신규', '진행중', '보류', '완료', '검증중'];

// 담당자 옵션 (실제 프로젝트에 맞게 수정)
const OWNERS = ['심태양', '김철수', '박영희', '이영수', '최민수'];

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
    comments: [],
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
    comments: [],
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
    comments: [],
    created_at: '2025-01-17T07:00:00Z',
    updated_at: '2025-01-17T07:00:00Z',
    customFields: {
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
    comments: [],
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
    customFields: {},
    templateId: ''
  }
];

// 전체 이슈 로드
async function loadAllIssues() {
  // Mock 모드
  if (USE_MOCK_DATA) {
    console.log('🔧 Mock 모드: 테스트 데이터 사용 중');
    return new Promise(resolve => {
      setTimeout(() => resolve([...MOCK_ISSUES]), 300);
    });
  }

  // 실제 API 호출
  try {
    const response = await fetch(`${SCRIPT_URL}?action=getAll`, {
      method: 'GET'
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    const result = await response.json();

    if (result.success) {
      return result.data;
    } else {
      throw new Error(result.error);
    }
  } catch (error) {
    console.error('이슈 로드 실패:', error);
    throw error;
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
          resolve({...issue});
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
      return result.data;
    } else {
      throw new Error(result.error);
    }
  } catch (error) {
    console.error('이슈 로드 실패:', error);
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
        const newIssue = {
          id: `PL-2025-${String(MOCK_ISSUES.length + 1).padStart(3, '0')}`,
          ...issueData,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString()
        };
        MOCK_ISSUES.push(newIssue);
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
          MOCK_ISSUES[index] = {
            ...MOCK_ISSUES[index],
            ...issueData,
            updated_at: new Date().toISOString()
          };
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
async function addComment(issueId, author, text) {
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
          author: author,
          text: text
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

    return result;
  } catch (error) {
    console.error('댓글 추가 실패:', error);
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
function sortIssues(issues, sortBy, sortOrder = 'asc') {
  const sorted = [...issues];

  sorted.sort((a, b) => {
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

// 전역 export
window.PunchListAPI = {
  loadAllIssues,
  loadIssueById,
  createIssue,
  updateIssue,
  deleteIssue,
  addComment,
  formatDate,
  formatDateTime,
  getPriorityColor,
  getStatusColor,
  getStatusBadge,
  getPriorityBadge,
  filterIssues,
  sortIssues,
  calculateStats,
  saveToLocalStorage,
  loadFromLocalStorage,
  isOverdue,
  CATEGORIES,
  PRIORITIES,
  STATUSES,
  OWNERS
};

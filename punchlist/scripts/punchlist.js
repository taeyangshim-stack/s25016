/**
 * S25016 펀치리스트 클라이언트 스크립트
 */

// Google Apps Script URL (배포 후 업데이트 필요)
const SCRIPT_URL = 'YOUR_GOOGLE_APPS_SCRIPT_URL';

// 분류 옵션
const CATEGORIES = {
  '기계': ['구조물', '프레임', '이송장치', '기타'],
  '전기': ['배선', '센서', '모터', '전원', '기타'],
  '제어': ['로봇', 'UI/HMI', '계측', 'PLC', '기타']
};

// 우선순위 옵션
const PRIORITIES = ['긴급', '높음', '보통', '낮음'];

// 상태 옵션
const STATUSES = ['신규', '진행중', '보류', '완료', '검증중'];

// 담당자 옵션 (실제 프로젝트에 맞게 수정)
const OWNERS = ['심태양', '김철수', '박영희', '이영수', '최민수'];

// 전체 이슈 로드
async function loadAllIssues() {
  try {
    const response = await fetch(`${SCRIPT_URL}?action=getAll`, {
      method: 'GET',
      mode: 'cors'
    });

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
  try {
    const response = await fetch(`${SCRIPT_URL}?action=getById&id=${id}`, {
      method: 'GET',
      mode: 'cors'
    });

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
  try {
    const response = await fetch(SCRIPT_URL, {
      method: 'POST',
      mode: 'no-cors',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        action: 'create',
        data: issueData
      })
    });

    // no-cors 모드에서는 응답을 읽을 수 없으므로 성공으로 간주
    return { success: true };
  } catch (error) {
    console.error('이슈 생성 실패:', error);
    throw error;
  }
}

// 이슈 수정
async function updateIssue(issueData) {
  try {
    const response = await fetch(SCRIPT_URL, {
      method: 'POST',
      mode: 'no-cors',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        action: 'update',
        data: issueData
      })
    });

    return { success: true };
  } catch (error) {
    console.error('이슈 수정 실패:', error);
    throw error;
  }
}

// 이슈 삭제
async function deleteIssue(id) {
  try {
    const response = await fetch(SCRIPT_URL, {
      method: 'POST',
      mode: 'no-cors',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        action: 'delete',
        id: id
      })
    });

    return { success: true };
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
      mode: 'no-cors',
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

    return { success: true };
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
  CATEGORIES,
  PRIORITIES,
  STATUSES,
  OWNERS
};

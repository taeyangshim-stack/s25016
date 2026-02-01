/**
 * 지출결의서 API 클라이언트 모듈
 *
 * Notion API와 통신하는 함수들을 제공합니다.
 */

const EXPENSE_API_BASE = '/api/notion-expense';

// API 호출 헬퍼
async function callExpenseAPI(params) {
  try {
    const url = new URL(EXPENSE_API_BASE, window.location.origin);
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined && params[key] !== null) {
        url.searchParams.append(key, params[key]);
      }
    });

    const response = await fetch(url);
    const result = await response.json();

    if (!result.success) {
      throw new Error(result.message || result.error || 'API 요청 실패');
    }

    return result.data;
  } catch (error) {
    console.error('Expense API Error:', error);
    throw error;
  }
}

// POST 요청 헬퍼
async function postExpenseAPI(action, payload) {
  try {
    const response = await fetch(EXPENSE_API_BASE, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ action, ...payload })
    });

    const result = await response.json();

    if (!result.success) {
      throw new Error(result.message || result.error || 'API 요청 실패');
    }

    return result.data;
  } catch (error) {
    console.error('Expense API Error:', error);
    throw error;
  }
}

// 전체 지결 조회
async function getAllExpenses() {
  return await callExpenseAPI({ action: 'getAll' });
}

// 상태별 조회
async function getExpensesByStatus(status) {
  return await callExpenseAPI({ action: 'getByStatus', status });
}

// 단건 조회
async function getExpenseById(id) {
  return await callExpenseAPI({ action: 'getById', id });
}

// 출장신청서별 지결 조회
async function getExpensesByTrip(tripId) {
  return await callExpenseAPI({ action: 'getByTrip', tripId });
}

// 지결 생성
async function createExpense(data) {
  return await postExpenseAPI('create', { data });
}

// 지결 수정
async function updateExpense(id, data) {
  return await postExpenseAPI('update', { id, data });
}

// 지결 삭제
async function deleteExpense(id) {
  return await postExpenseAPI('delete', { id });
}

// 유틸리티: 일별 지출 JSON 파싱
function parseExpenseDetail(jsonString) {
  try {
    const data = JSON.parse(jsonString);
    return Array.isArray(data) ? data : [];
  } catch (e) {
    console.error('JSON 파싱 실패:', e);
    return [];
  }
}

// 유틸리티: 일별 지출 JSON 생성
function createExpenseDetail(dailyExpenses) {
  return JSON.stringify(dailyExpenses, null, 2);
}

// 유틸리티: 합계 계산
function calculateTotals(dailyExpenses) {
  const totals = {
    toll: 0,
    fuel: 0,
    allowance: 0,
    meal: 0
  };

  dailyExpenses.forEach(day => {
    totals.toll += day.toll || 0;
    totals.fuel += day.fuel || 0;
    totals.allowance += day.allowance || 0;
    totals.meal += day.meal || 0;
  });

  totals.grand = totals.toll + totals.fuel + totals.allowance + totals.meal;

  return totals;
}

// 유틸리티: 유류비 계산
function calculateFuelCost(distance, fuelPrice, fuelEfficiency = 9) {
  return Math.round((distance * fuelPrice) / fuelEfficiency);
}

// 유틸리티: 상태 색상
function getStatusColor(status) {
  const colors = {
    '작성중': '#f59e0b',
    '제출': '#3b82f6',
    '승인': '#10b981',
    '반려': '#ef4444'
  };
  return colors[status] || '#6b7280';
}

// 유틸리티: 상태 이모지
function getStatusEmoji(status) {
  const emojis = {
    '작성중': '🟡',
    '제출': '🔵',
    '승인': '🟢',
    '반려': '🔴'
  };
  return emojis[status] || '⚪';
}

// 유틸리티: 숫자 포맷 (천단위 콤마)
function formatNumber(num) {
  return new Intl.NumberFormat('ko-KR').format(num);
}

// 유틸리티: 날짜 포맷
function formatDate(dateString) {
  if (!dateString) return '';
  const date = new Date(dateString);
  return date.toLocaleDateString('ko-KR', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit'
  }).replace(/\. /g, '-').replace('.', '');
}

// 유틸리티: 짧은 날짜 포맷 (MM/DD)
function formatShortDate(dateString) {
  if (!dateString) return '';
  const date = new Date(dateString);
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${month}/${day}`;
}

// 유틸리티: 문서번호 자동 생성
function generateDocumentNumber(drafter, date) {
  const dateStr = date.replace(/-/g, '');
  const seq = String(Math.floor(Math.random() * 1000)).padStart(3, '0');
  return `에스피시스템스-개발팀-${dateStr}-${seq}`;
}

// 유틸리티: 신청번호 자동 생성
function generateRequestNumber() {
  const year = new Date().getFullYear();
  const seq = String(Math.floor(Math.random() * 1000)).padStart(3, '0');
  return `EXP-${year}-${seq}`;
}

// 내보내기
if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    getAllExpenses,
    getExpensesByStatus,
    getExpenseById,
    getExpensesByTrip,
    createExpense,
    updateExpense,
    deleteExpense,
    parseExpenseDetail,
    createExpenseDetail,
    calculateTotals,
    calculateFuelCost,
    getStatusColor,
    getStatusEmoji,
    formatNumber,
    formatDate,
    formatShortDate,
    generateDocumentNumber,
    generateRequestNumber
  };
}

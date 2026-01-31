/**
 * 출장신청서 클라이언트 API 모듈
 *
 * 사용법:
 *   const api = new BusinessTripAPI();
 *   const trips = await api.getAll();
 *   const trip = await api.create({ title: '...', ... });
 */

(function (global) {
  'use strict';

  const API_BASE = '/api/notion-trip';

  // Mock 데이터 (API 미연결 시 사용)
  const MOCK_DATA = [
    {
      id: 'mock-1',
      title: '삼성중공업 거재조선소 자동용접시스템 성능 문제 대응 및 양산 정상화 지원 18차연장',
      requestNumber: 'BT-2026-001',
      applicant: '심태양',
      department: '개발팀',
      tripType: '시운전',
      tripCategory: '국내출장',
      destination: '거제',
      destinationDetail: '삼성중공업 거제 조선소',
      startDate: '2026-01-26',
      endDate: '2026-01-31',
      purpose: '3주 완료 계획 - 2주차 현장 안정화 및 잔여 PL 집중 조치',
      schedule: JSON.stringify([
        { date: '2026-01-25', time: '00:00', location: '삼성중공업 거제 조선소', content: '이동' },
        { date: '2026-01-26', time: '00:00', location: '삼성중공업 거제 조선소', content: '시운전 대응' },
        { date: '2026-01-27', time: '00:00', location: '삼성중공업 거제 조선소', content: '시운전 대응' }
      ]),
      totalCost: 0,
      accommodationCost: 0,
      transportCost: 0,
      mealCost: 0,
      otherCost: 0,
      status: '승인',
      priority: '긴급',
      hasVacancy: true,
      punchlistId: 'PL-2026-200',
      remarks: '',
      createdTime: '2026-01-26T00:00:00Z',
      lastEditedTime: '2026-01-26T00:00:00Z'
    }
  ];

  class BusinessTripAPI {
    constructor(options = {}) {
      this.baseUrl = options.baseUrl || API_BASE;
      this.useMock = options.useMock || false;
      this.mockData = [...MOCK_DATA];
    }

    // HTTP 요청 헬퍼
    async _fetch(url, options = {}) {
      try {
        const response = await fetch(url, {
          headers: { 'Content-Type': 'application/json' },
          ...options
        });

        const data = await response.json();

        if (!response.ok) {
          throw new Error(data.message || data.error || 'Request failed');
        }

        return data;
      } catch (error) {
        console.error('API Error:', error);
        throw error;
      }
    }

    // 전체 목록 조회
    async getAll() {
      if (this.useMock) {
        return { success: true, data: this.mockData };
      }
      return this._fetch(`${this.baseUrl}?action=getAll`);
    }

    // 상태별 조회
    async getByStatus(status) {
      if (this.useMock) {
        const filtered = this.mockData.filter(t => t.status === status);
        return { success: true, data: filtered };
      }
      return this._fetch(`${this.baseUrl}?action=getByStatus&status=${encodeURIComponent(status)}`);
    }

    // 단건 조회
    async getById(id) {
      if (this.useMock) {
        const trip = this.mockData.find(t => t.id === id);
        return trip
          ? { success: true, data: trip }
          : { success: false, error: 'Not found' };
      }
      return this._fetch(`${this.baseUrl}?action=getById&id=${encodeURIComponent(id)}`);
    }

    // 생성
    async create(tripData) {
      if (this.useMock) {
        const newTrip = {
          id: 'mock-' + Date.now(),
          ...tripData,
          createdTime: new Date().toISOString(),
          lastEditedTime: new Date().toISOString()
        };
        this.mockData.unshift(newTrip);
        return { success: true, data: newTrip };
      }
      return this._fetch(this.baseUrl, {
        method: 'POST',
        body: JSON.stringify({ action: 'create', data: tripData })
      });
    }

    // 수정
    async update(id, tripData) {
      if (this.useMock) {
        const index = this.mockData.findIndex(t => t.id === id);
        if (index === -1) {
          return { success: false, error: 'Not found' };
        }
        this.mockData[index] = {
          ...this.mockData[index],
          ...tripData,
          lastEditedTime: new Date().toISOString()
        };
        return { success: true, data: this.mockData[index] };
      }
      return this._fetch(this.baseUrl, {
        method: 'POST',
        body: JSON.stringify({ action: 'update', id, data: tripData })
      });
    }

    // 삭제
    async delete(id) {
      if (this.useMock) {
        const index = this.mockData.findIndex(t => t.id === id);
        if (index === -1) {
          return { success: false, error: 'Not found' };
        }
        this.mockData.splice(index, 1);
        return { success: true, data: { id } };
      }
      return this._fetch(this.baseUrl, {
        method: 'POST',
        body: JSON.stringify({ action: 'delete', id })
      });
    }

    // 상태 변경
    async updateStatus(id, status) {
      return this.update(id, { status });
    }
  }

  // 유틸리티 함수들
  const BusinessTripUtils = {
    // 날짜 포맷
    formatDate(dateStr, format = 'YYYY-MM-DD') {
      if (!dateStr) return '';
      const date = new Date(dateStr);
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0');
      const day = String(date.getDate()).padStart(2, '0');
      const weekdays = ['일', '월', '화', '수', '목', '금', '토'];
      const weekday = weekdays[date.getDay()];

      return format
        .replace('YYYY', year)
        .replace('MM', month)
        .replace('DD', day)
        .replace('ddd', weekday);
    },

    // 출장 기간 계산 (일수)
    calculateDays(startDate, endDate) {
      if (!startDate || !endDate) return 0;
      const start = new Date(startDate);
      const end = new Date(endDate);
      const diff = end - start;
      return Math.ceil(diff / (1000 * 60 * 60 * 24)) + 1;
    },

    // 상태 색상
    getStatusColor(status) {
      const colors = {
        '작성중': '#6b7280',
        '신청완료': '#3b82f6',
        '승인': '#10b981',
        '반려': '#ef4444',
        '완료': '#8b5cf6'
      };
      return colors[status] || '#6b7280';
    },

    // 우선순위 색상
    getPriorityColor(priority) {
      const colors = {
        '긴급': '#ef4444',
        '높음': '#f59e0b',
        '보통': '#3b82f6',
        '낮음': '#6b7280'
      };
      return colors[priority] || '#6b7280';
    },

    // 출장유형 색상
    getTripTypeColor(type) {
      const colors = {
        '시운전': '#10b981',
        '회의': '#3b82f6',
        '교육': '#8b5cf6',
        '점검': '#f59e0b',
        '기술지원': '#ec4899',
        '기타': '#6b7280'
      };
      return colors[type] || '#6b7280';
    },

    // 신청번호 생성
    generateRequestNumber() {
      const now = new Date();
      const year = now.getFullYear();
      const seq = String(Math.floor(Math.random() * 1000)).padStart(3, '0');
      return `BT-${year}-${seq}`;
    },

    // 금액 포맷
    formatCurrency(amount) {
      if (typeof amount !== 'number') return '0';
      return amount.toLocaleString('ko-KR') + '원';
    },

    // 상세일정 파싱
    parseSchedule(scheduleStr) {
      if (!scheduleStr) return [];
      try {
        return JSON.parse(scheduleStr);
      } catch {
        return [];
      }
    },

    // 상세일정 직렬화
    stringifySchedule(scheduleArr) {
      return JSON.stringify(scheduleArr || []);
    }
  };

  // 전역 객체로 내보내기
  global.BusinessTripAPI = BusinessTripAPI;
  global.BusinessTripUtils = BusinessTripUtils;

})(typeof window !== 'undefined' ? window : this);

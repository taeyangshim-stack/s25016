# 근무관리 시스템

## 개요

출입 기록 입력, 조회, 수정 시스템
- Google Sheets 연동
- 실시간 동기화
- 성능 최적화 적용

## 폴더 구조

```
work-management/
├── index.html              # 대시보드
├── pages/
│   ├── input.html          # 기록 입력
│   ├── query.html          # 기록 조회/수정
│   └── settings.html       # 설정
├── scripts/
│   └── GoogleAppsScript.js # Apps Script 백엔드
├── tests/
│   ├── test-api.html       # API 연결 테스트
│   └── test-query.html     # 조회 기능 테스트
└── docs/
    ├── troubleshooting.md       # 문제 해결
    ├── performance.md           # 성능 최적화
    └── debugging-edit.md        # 디버깅 가이드
```

## 주요 기능

- ✅ 출입 기록 입력
- ✅ 기록 조회 및 필터링
- ✅ 기록 수정/삭제
- ✅ Google Sheets 동기화
- ✅ Optimistic UI Update (50배 성능 개선)

## 사용법

### 로컬 서버 실행
```bash
python3 -m http.server 8000
```

브라우저: http://localhost:8000/projects/work-management/

### 경로 수정 필요 (TODO)
- [ ] pages/*.html 내부 링크 수정
- [ ] shared CSS/JS 경로 추가
- [ ] GoogleAppsScript.js 경로 수정

## 개발 이력

- 2025-10-10: 성능 최적화 (Optimistic UI)
- 2025-10-09: 수정/삭제 기능 구현
- 2025-10-08: Google Sheets 연동

# 🔧 시스템 분리 정리 (펀치리스트 vs 근퇴관리)

## 📊 시스템 구조

S25016 프로젝트는 **두 개의 독립적인 시스템**으로 구성됩니다:

### 1️⃣ 펀치리스트 시스템 (Punchlist)

**위치**: `/home/qwe/works/s25016/punchlist/`

**용도**: 프로젝트 이슈 관리 (Issue Tracking)

**Google Sheets**:
- Sheet ID: `1EqBPn9XrA_5PTg5ks4bgFIjwiojMFDZCYaOkFJINAmE`
- 시트명: `PunchList`, `PunchListOwners`, `PunchListCategories`

**Apps Script**:
- 로컬 파일: `punchlist/scripts/GoogleAppsScript.js`
- 배포 URL: `https://script.google.com/macros/s/AKfycbygAg88Vk2cJwhkDUJQPn2OO18J9IhzvF0l85otx4khWGh8y4XxAJhpQlOZnVvATxQ/exec`

**주요 기능**:
- ✅ 이슈 등록/수정/삭제 (PL-YYYY-NNN)
- ✅ 담당자 관리 (`getOwners`)
- ✅ 분류 관리 (`getCategories`)
- ✅ 댓글 관리
- ✅ 이메일 알림

---

### 2️⃣ 근퇴관리 시스템 (Work Management)

**위치**: `/home/qwe/works/s25016/projects/work-management/`

**용도**: 직원 출입 기록 관리

**Google Sheets**:
- 별도의 Google Sheets 사용 (SpreadsheetApp.getActiveSpreadsheet())
- 시트명: `출입기록`, `인원목록`, `장소목록`

**Apps Script**:
- 로컬 파일: `projects/work-management/scripts/GoogleAppsScript.js`
- 배포 URL: (별도 배포 필요)

**주요 기능**:
- ✅ 출입 기록 등록/수정/삭제
- ✅ 일괄 등록/수정/삭제 (`bulkCreate`, `bulkUpdate`, `bulkDelete`)
- ✅ 직원 목록 조회 (`getEmployees`)
- ✅ 장소 목록 조회 (`getLocations`)
- ✅ 근무시간 자동 계산
- ✅ 이메일 알림

---

## ⚠️ 발생한 문제

### 원인
CORS 에러를 해결하는 과정에서 **펀치리스트 스크립트**에 **근퇴관리 전용 함수**를 잘못 추가했습니다:
- `getEmployees()` ← 근퇴관리 전용 (펀치리스트에는 불필요)
- `getLocations()` ← 근퇴관리 전용 (펀치리스트에는 불필요)
- `bulkCreate` / `bulkCreateIssues()` ← 펀치리스트에는 불필요 (근퇴관리만 필요)

### 영향
- 펀치리스트와 근퇴관리 기능이 섞임
- 근퇴관리 페이지에서 펀치리스트 URL을 호출하면서 혼란 발생
- 불필요한 일괄등록 기능이 펀치리스트에 추가됨

---

## ✅ 해결 방법

### 1️⃣ 펀치리스트 GoogleAppsScript.js - 원복 완료 ✅

#### 제거한 부분 (잘못 추가했던 근퇴관리 기능):
```javascript
// doGet() 함수에서 제거
} else if (action === 'getEmployees') {
  return createCORSResponse(getEmployees());
} else if (action === 'getLocations') {
  return createCORSResponse(getLocations());
}

// doPost() 함수에서 제거
case 'bulkCreate':
  result = bulkCreateIssues(params.issues || []);
  break;

// 함수 전체 제거
function getEmployees() { ... }
function getLocations() { ... }
function bulkCreateIssues(issuesData) { ... }
```

#### 결과:
- ✅ 펀치리스트는 원래 기능만 유지 (단일 이슈 등록/수정/삭제)
- ✅ 근퇴관리 전용 기능 모두 제거
- ✅ 깔끔하게 원복 완료

---

### 2️⃣ 근퇴관리 GoogleAppsScript.js - 유지

**이미 올바르게 구현되어 있음 (수정 불필요)**:
- ✅ `getEmployees()` (Line 643-688)
- ✅ `getLocations()` (Line 693-745)
- ✅ 일괄 처리 함수들

---

## 🚀 배포 가이드

### 펀치리스트 시스템

1. **Google Sheets 접속**:
   ```
   https://docs.google.com/spreadsheets/d/1EqBPn9XrA_5PTg5ks4bgFIjwiojMFDZCYaOkFJINAmE/edit
   ```

2. **Apps Script 에디터**:
   - `확장 프로그램` → `Apps Script`

3. **코드 업데이트**:
   - `/home/qwe/works/s25016/punchlist/scripts/GoogleAppsScript.js` 복사
   - 전체 선택 (Ctrl+A) → 붙여넣기 → 저장 (Ctrl+S)

4. **재배포**:
   - `배포` → `배포 관리`
   - 활성 배포 편집 → `새 버전` 선택 → `배포`

5. **테스트 URL**:
   ```
   https://script.google.com/macros/s/AKfycbygAg88Vk2cJwhkDUJQPn2OO18J9IhzvF0l85otx4khWGh8y4XxAJhpQlOZnVvATxQ/exec?action=getAll
   ```

---

### 근퇴관리 시스템

1. **Google Sheets 접속**:
   - 근퇴관리 전용 스프레드시트 열기

2. **Apps Script 에디터**:
   - `확장 프로그램` → `Apps Script`

3. **코드 확인**:
   - `/home/qwe/works/s25016/projects/work-management/scripts/GoogleAppsScript.js`
   - 이미 올바르게 구현되어 있음

4. **배포** (처음이거나 변경 시):
   - `배포` → `새 배포`
   - 유형: `웹 앱`
   - Execute as: `Me`
   - Who has access: `Anyone`
   - `배포` 클릭

5. **배포 URL 업데이트**:
   - 새 URL을 복사
   - `bulk-management.html`의 `SCRIPT_URL` 업데이트

6. **테스트 URL**:
   ```
   https://script.google.com/macros/s/[YOUR_DEPLOYMENT_ID]/exec?action=getEmployees
   ```

---

## 📋 각 시스템의 액션 목록

### 펀치리스트 지원 액션

#### GET 요청:
- `getAll` - 전체 이슈 조회
- `getById` - 특정 이슈 조회
- `getOwners` - 담당자 목록 조회
- `getCategories` - 분류 목록 조회

#### POST 요청:
- `create` - 이슈 생성
- `update` - 이슈 수정
- `delete` - 이슈 삭제
- `addComment` - 댓글 추가
- `updateComment` - 댓글 수정
- `deleteComment` - 댓글 삭제
- `saveOwners` - 담당자 목록 저장
- `saveCategories` - 분류 목록 저장

---

### 근퇴관리 지원 액션

#### GET 요청:
- `getEmployees` - 직원 목록 조회
- `getLocations` - 장소 목록 조회
- `getAllRecords` - 전체 기록 조회

#### POST 요청:
- (기본) - 출입 기록 생성
- `bulkCreate` - 기록 일괄 생성
- `bulkUpdate` - 기록 일괄 수정
- `bulkDelete` - 기록 일괄 삭제
- `update` - 기록 수정
- `delete` - 기록 삭제

---

## 🔍 원복 작업 완료 상태

### 펀치리스트
- ✅ 불필요한 `bulkCreate` 액션 제거 완료
- ✅ 불필요한 `getEmployees`, `getLocations` 제거 완료
- ✅ 원래 기능만 유지 (단일 이슈 등록/수정/삭제)
- ⏳ Google Apps Script 재배포 필요

### 근퇴관리
- ✅ `getEmployees`, `getLocations` 이미 올바르게 구현됨
- ✅ 일괄 처리 기능 (`bulkCreate`, `bulkUpdate`, `bulkDelete`) 완비
- ⏳ 올바른 배포 URL 사용 확인 필요 (펀치리스트 URL이 아닌 근퇴관리 URL)

---

## 📝 체크리스트

### 펀치리스트 시스템
- [x] 불필요한 근퇴관리 함수 제거 (`getEmployees`, `getLocations`)
- [x] 불필요한 일괄등록 기능 제거 (`bulkCreate`, `bulkCreateIssues`)
- [x] 원래 기능만 유지 확인
- [ ] Google Apps Script 재배포
- [ ] 브라우저 테스트 (`getAll` 액션)

### 근퇴관리 시스템
- [x] 스크립트 코드 확인 (이미 올바름)
- [ ] 근퇴관리 전용 Google Sheets 확인
- [ ] Apps Script 배포 확인 (펀치리스트와 다른 시트)
- [ ] bulk-management.html의 SCRIPT_URL이 근퇴관리 URL인지 확인
- [ ] 브라우저 테스트 (`getEmployees` 액션)
- [ ] 일괄등록 기능 테스트 (`bulkCreate`)

---

## 🎯 다음 단계

### 1. 펀치리스트 재배포 (원복 완료)
```
1. Google Sheets (1EqBPn9XrA...AmE) → Apps Script 에디터
2. 원복된 코드 붙여넣기 (punchlist/scripts/GoogleAppsScript.js)
3. 배포 관리 → 새 버전 배포
4. 테스트: ...exec?action=getAll
```

**제거된 기능**: `bulkCreate`, `getEmployees`, `getLocations`

### 2. 근퇴관리 시스템 확인 및 배포
```
1. 근퇴관리 전용 Google Sheets 열기 (펀치리스트와 다름!)
2. Apps Script 에디터 열기
3. work-management/scripts/GoogleAppsScript.js 코드 확인
4. 배포 (또는 기존 배포 확인)
5. bulk-management.html의 SCRIPT_URL 업데이트
6. 테스트: ...exec?action=getEmployees
```

**필요한 기능**: `bulkCreate`, `getEmployees`, `getLocations`

---

## 💡 핵심 정리

| 항목 | 펀치리스트 | 근퇴관리 |
|------|-----------|---------|
| **Google Sheets** | 1EqBPn9XrA...AmE | 별도 시트 |
| **Script 파일** | punchlist/scripts/ | work-management/scripts/ |
| **데이터 타입** | 이슈 (PL-YYYY-NNN) | 출입 기록 |
| **getEmployees** | ❌ 없음 | ✅ 있음 |
| **getLocations** | ❌ 없음 | ✅ 있음 |
| **getOwners** | ✅ 있음 | ❌ 없음 |
| **getCategories** | ✅ 있음 | ❌ 없음 |
| **bulkCreate** | ❌ 없음 | ✅ 기록 일괄등록 |

---

**⚠️ 중요:**
- **펀치리스트**: 단일 이슈만 등록 (일괄 등록 기능 없음)
- **근퇴관리**: 단일 + 일괄 등록 모두 지원
- 각 시스템은 완전히 별도의 Google Sheets와 Apps Script를 사용합니다!

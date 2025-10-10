# Google Apps Script 재배포 후 확인 사항

## ❓ URL을 다시 넣어야 하나요?

### 답변: **상황에 따라 다릅니다**

---

## 🔍 재배포 방법에 따른 URL 변경 여부

### ✅ **방법 1: 기존 배포 수정 (권장)**
```
Apps Script → 배포 → 배포 관리 → 기존 배포의 ✏️(수정) 클릭 → 새 버전 선택 → 배포
```

**결과:**
- ✅ URL 변경 없음
- ✅ 코드 수정 필요 없음
- ✅ 즉시 반영

**현재 URL 그대로 사용:**
```
https://script.google.com/macros/s/AKfycbygAg88Vk2cJwhkDUJQPn2OO18J9IhzvF0l85otx4khWGh8y4XxAJhpQlOZnVvATxQ/exec
```

---

### ⚠️ **방법 2: 새 배포 (비추천)**
```
Apps Script → 배포 → 새 배포
```

**결과:**
- ❌ URL 변경됨
- ❌ 모든 HTML 파일의 SCRIPT_URL 수정 필요
- ❌ 추가 작업 발생

---

## 📋 재배포 후 확인 체크리스트

### 1단계: Apps Script에서 확인

**코드 업데이트 확인:**
```javascript
// doGet 함수에 getAllRecords가 있는지 확인
function doGet(e) {
  const action = e.parameter.action;

  if (action === 'getEmployees') {
    return getEmployees();
  } else if (action === 'getLocations') {
    return getLocations();
  } else if (action === 'getAllRecords') {  // ← 이 부분이 있어야 함!
    return getAllRecords();
  }
  ...
}
```

**확인 방법:**
1. Apps Script 편집기 열기
2. Ctrl+F로 "getAllRecords" 검색
3. doGet 함수 안에 있는지 확인

---

### 2단계: 배포 URL 확인

**1. Apps Script → 배포 → 배포 관리**

**2. 현재 배포된 URL 확인:**
```
웹 앱 URL: https://script.google.com/macros/s/...../exec
```

**3. 입력.html과 조회.html의 URL과 비교:**

**입력.html (348번째 줄):**
```javascript
const SCRIPT_URL = 'https://script.google.com/macros/s/AKfycbygAg88Vk2cJwhkDUJQPn2OO18J9IhzvF0l85otx4khWGh8y4XxAJhpQlOZnVvATxQ/exec';
```

**조회.html (493번째 줄):**
```javascript
const SCRIPT_URL = 'https://script.google.com/macros/s/AKfycbygAg88Vk2cJwhkDUJQPn2OO18J9IhzvF0l85otx4khWGh8y4XxAJhpQlOZnVvATxQ/exec';
```

**4. URL이 다르면:**
- 입력.html과 조회.html의 SCRIPT_URL을 새 URL로 수정
- Git 커밋 및 푸시

---

### 3단계: API 테스트

**브라우저에서 직접 테스트:**

**테스트 1: 인원 목록**
```
https://script.google.com/macros/s/AKfycbygAg88Vk2cJwhkDUJQPn2OO18J9IhzvF0l85otx4khWGh8y4XxAJhpQlOZnVvATxQ/exec?action=getEmployees
```
**예상 결과:** `["심태양","김철수","이영희","박민수"]`

**테스트 2: 장소 목록**
```
https://script.google.com/macros/s/AKfycbygAg88Vk2cJwhkDUJQPn2OO18J9IhzvF0l85otx4khWGh8y4XxAJhpQlOZnVvATxQ/exec?action=getLocations
```
**예상 결과:** `["34bay A라인","34bay B라인",...]`

**테스트 3: 전체 기록 (NEW!)**
```
https://script.google.com/macros/s/AKfycbygAg88Vk2cJwhkDUJQPn2OO18J9IhzvF0l85otx4khWGh8y4XxAJhpQlOZnVvATxQ/exec?action=getAllRecords
```
**예상 결과:**
```json
[
  {
    "타임스탬프": "2024-10-09T12:00:00Z",
    "날짜": "2024-10-09",
    "인원": "심태양",
    "위치": "34bay A라인",
    "입실시간": "08:00",
    "퇴실시간": "17:00",
    "근무시간": "9시간 0분",
    "작업내용": "ROBOT↔UI 테스트",
    "비고": "테스트"
  }
]
```

---

## 🚨 문제 해결

### 문제 1: "S25016 근무관리 시스템이 정상 작동 중입니다." 만 표시됨

**원인:**
- `getAllRecords` API가 doGet에 추가되지 않음
- 코드를 수정했지만 재배포하지 않음

**해결:**
1. GoogleAppsScript.js 전체 복사
2. Apps Script 편집기에 붙여넣기
3. **배포 → 배포 관리 → 수정 → 새 버전 → 배포**

---

### 문제 2: "Cannot read properties of undefined" 에러

**원인:**
- Google Sheets의 헤더 이름과 코드의 키 이름이 다름

**확인:**
Google Sheets "출입기록" 시트의 첫 번째 행:
```
타임스탬프 | 날짜 | 인원 | 위치 | 입실시간 | 퇴실시간 | 근무시간 | 작업내용 | 비고
```

조회.html의 데이터 변환 코드:
```javascript
const records = data.map(row => ({
    timestamp: row['타임스탬프'],    // ← 헤더 이름과 정확히 일치해야 함
    date: row['날짜'],
    name: row['인원'],
    location: row['위치'],
    checkIn: row['입실시간'],
    checkOut: row['퇴실시간'],
    workType: row['작업내용'],
    notes: row['비고']
}));
```

---

### 문제 3: 조회.html에서 "기록이 없습니다" 표시

**확인 순서:**

**1. F12 → Console 확인:**
```
✅ Google Sheets에서 N개 기록 로드 완료  ← 이 메시지가 있어야 함
```

**2. Console에 에러가 있다면:**
- 빨간색 에러 메시지 확인
- 에러 내용 복사하여 문제 파악

**3. Network 탭 확인:**
- F12 → Network 탭
- 페이지 새로고침
- `exec?action=getAllRecords` 요청 확인
- Status Code: 200이어야 함
- Response 탭에서 응답 데이터 확인

---

## ✅ 정상 작동 확인 방법

### 조회 페이지 (조회.html) 열기

1. **페이지 로드 시 콘솔 확인:**
```
✅ Google Sheets에서 인원/장소 목록 로드 완료
✅ Google Sheets에서 5개 기록 로드 완료  ← 실제 개수
```

2. **테이블에 데이터 표시:**
- 날짜, 인원, 위치, 입실/퇴실 시간 등이 표시됨
- "총 N건" 표시

3. **필터 기능 테스트:**
- 날짜 범위 선택 → 검색 → 결과 필터링됨
- 인원 선택 → 검색 → 해당 인원만 표시됨

---

## 📝 빠른 재배포 가이드

### 재배포가 필요한 경우

✅ GoogleAppsScript.js 파일을 수정했을 때
✅ 새로운 API 함수를 추가했을 때 (예: getAllRecords)
✅ 기존 함수의 로직을 변경했을 때

### 재배포 절차 (5분 소요)

```
1. Apps Script 편집기 열기
   Google Sheets → 확장 프로그램 → Apps Script

2. 코드 전체 교체
   - 기존 코드 전체 선택 (Ctrl+A)
   - 삭제
   - GoogleAppsScript.js 내용 복사하여 붙여넣기
   - Ctrl+S로 저장

3. 재배포
   - 배포 → 배포 관리
   - 기존 배포 옆 ✏️(수정) 클릭
   - **새 버전** 선택
   - 설명 입력: "getAllRecords API 추가"
   - 배포 클릭

4. 완료!
   - URL 변경 없음
   - 즉시 반영됨
```

---

## 🎯 현재 확인해야 할 사항

**1. Apps Script 코드에 `getAllRecords`가 있는지?**
```bash
# 로컬 파일 확인
grep -n "getAllRecords" 근무관리/GoogleAppsScript.js
```
예상 결과: 87번째 줄, 347번째 줄 등에 나타나야 함

**2. 재배포를 했는지?**
- 배포 → 배포 관리에서 배포 날짜 확인
- 최근 버전이 오늘 날짜여야 함

**3. URL 테스트**
브라우저에서 아래 URL 접속:
```
https://script.google.com/macros/s/AKfycbygAg88Vk2cJwhkDUJQPn2OO18J9IhzvF0l85otx4khWGh8y4XxAJhpQlOZnVvATxQ/exec?action=getAllRecords
```

**정상:** JSON 배열 반환
**비정상:** "S25016 근무관리 시스템이 정상 작동 중입니다." 또는 에러

---

## 📞 추가 도움이 필요하다면

위 단계를 모두 확인한 후:

1. **브라우저 콘솔 스크린샷**
   - F12 → Console 탭
   - 에러 메시지 캡처

2. **Network 탭 스크린샷**
   - F12 → Network 탭
   - getAllRecords 요청의 Response 확인

3. **Google Sheets 스크린샷**
   - "출입기록" 시트의 헤더 (첫 번째 행)
   - 실제 데이터 몇 행

이 정보가 있으면 정확한 문제 파악 가능합니다!

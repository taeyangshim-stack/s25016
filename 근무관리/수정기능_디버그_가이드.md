# 수정 기능 디버그 가이드

## 📋 현재 상황

- ✅ **입실시간 표시 문제 해결됨** (1899-12-30 이슈 수정)
- ✅ **조회 기능 정상 작동** (Google Sheets에서 데이터 로드)
- ❌ **수정 기능이 작동하지 않음** (저장 후 변경사항이 Google Sheets에 반영되지 않음)

---

## 🔍 문제 진단 절차

### 1단계: 브라우저 콘솔 로그 확인

**실행 순서:**

1. **조회 페이지 열기**
   ```
   http://localhost:8000/근무관리/조회.html
   ```

2. **F12 → Console 탭 열기**

3. **수정 테스트:**
   - 아무 기록이나 "수정" 버튼 클릭
   - 데이터 수정 (예: 입실시간을 08:00 → 09:00으로 변경)
   - "저장" 클릭

4. **Console에 다음 로그가 나타나는지 확인:**

```
✏️ 수정 요청 시작
Index: 0
원본 Record: {timestamp: "2024-10-09T01:30:00.000Z", date: "2024-10-09", ...}
수정할 데이터: {timestamp: "2024-10-09T01:30:00.000Z", date: "2024-10-09", ...}
전송할 URL: https://script.google.com/macros/s/.../exec?action=update
전송 데이터: {"timestamp":"2024-10-09T01:30:00.000Z",...}
📡 Fetch 요청 전송 중...
✅ Fetch 요청 완료
Response type: opaque
Response status: 0
📥 데이터 재로드 중...
✅ Google Sheets에서 4개 기록 로드 완료
✅ 수정 프로세스 완료
```

**예상 결과:**
- ✅ 모든 로그가 순서대로 나타남 → **클라이언트는 정상 작동**
- ❌ 로그 중간에 에러 발생 → **클라이언트 문제**

---

### 2단계: Apps Script 실행 로그 확인

**실행 순서:**

1. **Google Sheets 열기**
   - S25016 근무관리 스프레드시트

2. **Apps Script 편집기 열기**
   ```
   확장 프로그램 → Apps Script
   ```

3. **실행 로그 보기**
   - 왼쪽 메뉴에서 **"실행"** (시계 아이콘) 클릭
   - 또는 상단 메뉴: **보기 → 실행**

4. **최근 doPost 실행 확인**
   - "doPost" 함수가 최근에 실행되었는지 확인
   - 실행 항목 클릭 → 상세 로그 보기

5. **로그 내용 확인:**

**정상 케이스:**
```
Update request for timestamp: 2024-10-09T01:30:00.000Z
Target time (ms): 1728439800000
Row 1: 1728439800000
Match found at row: 2
Record updated successfully
```

**실패 케이스:**
```
Update request for timestamp: 2024-10-09T01:30:00.000Z
Target time (ms): 1728439800000
Row 1: 1728443400000
Row 2: 1728447000000
Row 3: 1728450600000
Record not found for timestamp: 2024-10-09T01:30:00.000Z
```

---

### 3단계: 배포 상태 확인

**확인 사항:**

1. **배포 날짜 확인**
   - Apps Script → 배포 → 배포 관리
   - **최근 버전 날짜가 오늘(2025-10-09)인지 확인**

2. **코드 확인**
   - Apps Script 편집기에서 Ctrl+F로 "updateRecord" 검색
   - 함수가 존재하는지 확인

3. **doPost 함수 확인**
   ```javascript
   function doPost(e) {
     try {
       const data = JSON.parse(e.postData.contents);
       const action = e.parameter.action;

       if (action === 'update') {  // ← 이 부분이 있어야 함!
         const success = updateRecord(data.timestamp, data);
         return ContentService.createTextOutput(JSON.stringify({
           status: success ? 'success' : 'error',
           message: success ? '기록이 수정되었습니다.' : '기록을 찾을 수 없습니다.'
         })).setMimeType(ContentService.MimeType.JSON);
       }
       ...
   ```

---

## 🚨 예상되는 문제 시나리오

### 시나리오 1: 배포를 안 했거나 오래된 배포

**증상:**
- 브라우저 콘솔: 정상 로그
- Apps Script 실행 로그: doPost 실행 없음 또는 오래된 버전

**해결:**
```
1. Apps Script 편집기 열기
2. 배포 → 배포 관리 → ✏️(수정) 클릭
3. 새 버전 선택
4. 배포 클릭
```

---

### 시나리오 2: 타임스탬프 불일치

**증상:**
- Apps Script 로그: "Record not found for timestamp: ..."
- 타임스탬프가 일치하지 않음

**원인:**
- 조회.html에서 보내는 timestamp와 Google Sheets의 타임스탬프가 다름

**해결:**
1. F12 → Console에서 "수정할 데이터" 로그 확인:
   ```
   수정할 데이터: {timestamp: "2024-10-09T01:30:00.000Z", ...}
   ```

2. Apps Script 로그에서 각 Row의 시간 확인:
   ```
   Row 1: 1728439800000  (2024-10-09T01:30:00.000Z)
   Row 2: 1728443400000  (2024-10-09T02:30:00.000Z)
   ```

3. 타임스탬프가 1초 이상 차이나면 매칭 실패

**디버깅:**
- Google Sheets "출입기록" 시트의 "타임스탬프" 열 확인
- 브라우저 콘솔의 timestamp와 비교

---

### 시나리오 3: no-cors 모드 문제

**증상:**
- 브라우저 콘솔: "Response type: opaque", "Response status: 0"
- 실제 응답을 읽을 수 없음

**현재 상황:**
- `mode: 'no-cors'`로 설정되어 있어 응답을 읽을 수 없음
- 하지만 요청 자체는 전송됨
- Apps Script 로그에서 실제 결과 확인 가능

**임시 해결책:**
- Apps Script 실행 로그에서 실제 성공/실패 여부 확인

**근본 해결책 (선택사항):**
- Apps Script에서 CORS 헤더 설정
- 하지만 현재는 로그로 충분히 진단 가능

---

### 시나리오 4: 권한 문제

**증상:**
- Apps Script 로그: "Exception: You do not have permission to call SpreadsheetApp.getActiveSpreadsheet"

**해결:**
```
1. Apps Script 편집기에서 아무 함수나 실행 (예: getAllRecords)
2. 권한 승인 팝업 → "권한 검토" 클릭
3. 계정 선택 → "허용" 클릭
```

---

## 📝 디버그 체크리스트

수정 기능이 작동하지 않을 때 다음을 순서대로 확인:

- [ ] **1. 로컬 서버가 실행 중인가?**
  ```bash
  curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/근무관리/조회.html
  # 예상: 200
  ```

- [ ] **2. 브라우저 캐시를 지웠는가?**
  ```
  F12 → Application → Local Storage → 삭제
  Ctrl+Shift+R (강력 새로고침)
  ```

- [ ] **3. 브라우저 콘솔에 에러가 없는가?**
  ```
  F12 → Console → 빨간색 에러 메시지 확인
  ```

- [ ] **4. Apps Script가 오늘 재배포되었는가?**
  ```
  배포 → 배포 관리 → 배포 날짜 확인
  ```

- [ ] **5. Apps Script 실행 로그에 doPost가 있는가?**
  ```
  보기 → 실행 → doPost 함수 확인
  ```

- [ ] **6. updateRecord 함수가 존재하는가?**
  ```
  Apps Script 에디터 → Ctrl+F → "updateRecord" 검색
  ```

- [ ] **7. 타임스탬프가 매칭되는가?**
  ```
  브라우저 콘솔의 timestamp와 Apps Script 로그의 Row 시간 비교
  ```

---

## 🎯 즉시 확인해야 할 3가지

### 1. 브라우저 콘솔 로그
```
F12 → Console → "수정" 클릭 → "저장" 클릭
전체 로그 복사하여 확인
```

### 2. Apps Script 실행 로그
```
Apps Script → 보기 → 실행
doPost 함수가 최근에 실행되었는지 확인
로그 내용 확인 (Match found? Record not found?)
```

### 3. 배포 날짜
```
Apps Script → 배포 → 배포 관리
최근 버전이 오늘 날짜인지 확인
```

---

## 💡 다음 단계

위 3가지를 확인한 후:

1. **문제가 해결되지 않으면:**
   - 브라우저 콘솔 로그 전체 캡처
   - Apps Script 실행 로그 캡처
   - Google Sheets 타임스탬프 열 캡처

2. **문제가 해결되면:**
   - 삭제 기능도 동일하게 테스트
   - 정상 작동 확인

---

## 🔧 긴급 해결 방법

**만약 계속 작동하지 않으면:**

### 방법 1: Apps Script 완전 재배포
```
1. Apps Script 코드 전체 복사 (백업)
2. 새 프로젝트 생성
3. 코드 붙여넣기
4. 새 배포 생성
5. 조회.html의 SCRIPT_URL 업데이트
```

### 방법 2: 브라우저에서 직접 API 테스트
```
브라우저 주소창에 입력:
https://script.google.com/macros/s/AKfycbygAg88Vk2cJwhkDUJQPn2OO18J9IhzvF0l85otx4khWGh8y4XxAJhpQlOZnVvATxQ/exec?action=getAllRecords

정상: JSON 배열 반환
비정상: "S25016 근무관리 시스템이 정상 작동 중입니다." 또는 에러
```

---

## 📞 추가 지원

위 단계를 모두 확인한 후에도 문제가 해결되지 않으면:

1. **로그 수집:**
   - 브라우저 Console 전체 캡처
   - Apps Script 실행 로그 캡처
   - Network 탭에서 exec 요청의 Headers/Payload 캡처

2. **데이터 확인:**
   - Google Sheets "출입기록" 시트의 첫 3행 캡처
   - 타임스탬프 형식 확인

3. **환경 정보:**
   - 브라우저 종류 및 버전
   - Google 계정 권한 상태

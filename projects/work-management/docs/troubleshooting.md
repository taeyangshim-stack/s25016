# 인원/장소 업데이트가 안 되는 문제 해결 가이드

## 🔍 문제 진단 순서

### 1단계: Google Sheets 확인

**확인할 사항:**
- [ ] Google Sheets에 "인원목록", "장소목록" 시트가 존재하는가?
- [ ] 각 시트의 A열에 데이터가 올바르게 입력되었는가?

**시트 구조:**
```
인원목록 시트:
A열
----
심태양
김철수
이영희
박민수
홍길동  ← 새로 추가한 이름

장소목록 시트:
A열
----------
34bay A라인
34bay B라인
35bay A라인
35bay B라인
사무실
회의실
```

**확인 방법:**
1. Google Sheets 열기
2. 하단 탭에서 "인원목록", "장소목록" 시트 확인
3. A열에 데이터가 제대로 입력되었는지 확인

---

### 2단계: Google Apps Script 확인

**확인할 사항:**
- [ ] GoogleAppsScript.js 코드를 Apps Script에 복사했는가?
- [ ] `getEmployees()` 함수가 존재하는가?
- [ ] `getLocations()` 함수가 존재하는가?
- [ ] `doGet(e)` 함수가 action 파라미터를 처리하는가?

**확인 방법:**
1. Google Sheets → 확장 프로그램 → Apps Script
2. 코드에서 다음 함수들이 있는지 확인:
   ```javascript
   function getEmployees() { ... }
   function getLocations() { ... }
   function doGet(e) {
     const action = e.parameter.action;
     if (action === 'getEmployees') {
       return getEmployees();
     } else if (action === 'getLocations') {
       return getLocations();
     }
     ...
   }
   ```

**문제가 있다면:**
- `/home/qwe/works/s25016/근무관리/GoogleAppsScript.js` 파일의 전체 내용을 복사
- Apps Script 편집기에 붙여넣기 (기존 코드 전체 교체)
- Ctrl+S로 저장

---

### 3단계: 웹 앱 재배포 확인

**확인할 사항:**
- [ ] Apps Script 수정 후 재배포했는가?
- [ ] 새 버전으로 배포했는가?

**재배포 방법:**
1. Apps Script 편집기 → 배포 → 배포 관리
2. 기존 배포 옆의 ✏️(수정) 아이콘 클릭
3. **새 버전** 선택 (중요!)
4. 설명 입력 (예: "인원/장소 API 추가")
5. 배포 버튼 클릭

**주의:**
- 반드시 **새 버전**을 선택해야 합니다
- 기존 버전은 코드가 업데이트되지 않습니다

---

### 4단계: API 연결 테스트

**테스트 페이지 사용:**
1. `근무관리/테스트_API연결.html` 열기
2. "전체 진단 실행" 버튼 클릭
3. 각 섹션의 결과 확인

**개별 테스트:**
- ✅ URL 접근 테스트: 웹 앱이 정상적으로 응답하는가?
- ✅ 인원 목록 가져오기: API가 인원 목록을 반환하는가?
- ✅ 장소 목록 가져오기: API가 장소 목록을 반환하는가?

**브라우저 콘솔 확인:**
1. 입력.html 페이지 열기
2. F12 누르기 → Console 탭
3. 다음 메시지 확인:
   ```
   ✅ Google Sheets에서 인원/장소 목록 로드 완료
   ```

**에러가 보인다면:**
- 에러 메시지 복사
- 해당 내용으로 문제 해결

---

### 5단계: 브라우저 캐시 삭제

**문제:**
- 브라우저가 이전 데이터를 캐시하고 있을 수 있습니다

**해결 방법:**

**방법 1: 테스트 페이지 사용**
1. `테스트_API연결.html` 열기
2. "모든 캐시 삭제" 버튼 클릭
3. 입력.html 페이지 새로고침

**방법 2: 브라우저 콘솔 사용**
1. 입력.html 페이지에서 F12 누르기
2. Console 탭에서 다음 입력:
   ```javascript
   localStorage.removeItem('workManagement_employees');
   localStorage.removeItem('workManagement_locations');
   location.reload();
   ```

**방법 3: 하드 리프레시**
- Windows: Ctrl + F5
- Mac: Cmd + Shift + R

---

### 6단계: URL 확인

**확인할 사항:**
- [ ] 입력.html과 조회.html의 SCRIPT_URL이 올바른가?

**확인 방법:**
1. 입력.html 파일 열기
2. 342-348번 줄 확인:
   ```javascript
   const SCRIPT_URL = 'https://script.google.com/macros/s/...';
   ```
3. 이 URL이 Google Apps Script의 웹 앱 URL과 일치하는지 확인

**웹 앱 URL 찾기:**
1. Apps Script 편집기 → 배포 → 배포 관리
2. 배포된 웹 앱의 URL 복사
3. 형식: `https://script.google.com/macros/s/.../exec`

---

## 🎯 가장 흔한 원인과 해결책

### ❌ 문제 1: "인원목록이나 장소목록 시트가 없습니다"

**원인:**
- Google Sheets에 시트를 만들지 않음
- 시트 이름이 다름 ("인원목록" ≠ "인원 목록")

**해결:**
1. Google Sheets 하단에서 + 버튼으로 새 시트 추가
2. 시트 이름을 정확히 "인원목록", "장소목록"으로 설정
3. A1 셀에 헤더 입력하지 않고 A1부터 바로 데이터 입력
   (또는 A1="이름", A2부터 데이터 입력)

---

### ❌ 문제 2: "API를 호출했는데 이전 데이터가 나옵니다"

**원인:**
- Apps Script 수정 후 **새 버전으로 재배포하지 않음**

**해결:**
1. Apps Script 편집기 → 배포 → 배포 관리
2. ✏️(수정) → **새 버전** 선택 → 배포
3. 테스트 페이지에서 "모든 캐시 삭제" 후 재시도

---

### ❌ 문제 3: "CORS 에러가 발생합니다"

**에러 메시지:**
```
Access to fetch at '...' from origin '...' has been blocked by CORS policy
```

**원인:**
- 웹 앱 액세스 권한이 잘못 설정됨

**해결:**
1. Apps Script 편집기 → 배포 → 배포 관리
2. ✏️(수정) 클릭
3. "액세스 권한" 부분 확인:
   - "다음 사용자가 실행": **나**
   - "액세스 권한이 있는 사용자": **모든 사용자(익명 포함)**
4. 배포

---

### ❌ 문제 4: "LocalStorage에는 있는데 select 박스에 안 나타남"

**원인:**
- 페이지 로드 시 동적 생성 로직 문제
- JavaScript 에러 발생

**해결:**
1. F12 → Console 탭에서 에러 확인
2. 페이지 새로고침 (Ctrl+F5)
3. 브라우저 캐시 삭제 후 재시도

---

## 📞 추가 도움이 필요하다면

**진단 결과를 확인하세요:**
1. `테스트_API연결.html` 페이지 열기
2. "전체 진단 실행" 실행
3. 각 섹션의 결과를 스크린샷 또는 복사

**확인할 로그:**
- 브라우저 Console (F12 → Console 탭)
- Apps Script 로그 (Apps Script 편집기 → 실행 → 로그)

**체크리스트:**
```
□ Google Sheets에 "인원목록", "장소목록" 시트 존재
□ 각 시트에 데이터 입력 완료
□ GoogleAppsScript.js 코드 전체 복사 완료
□ Apps Script에서 새 버전으로 재배포 완료
□ 웹 앱 URL 확인 및 입력.html에 설정 완료
□ 브라우저 캐시 삭제 완료
□ 테스트 페이지에서 API 연결 성공 확인
```

---

## 🚀 빠른 해결 체크리스트 (순서대로)

1. ✅ Google Sheets에 시트 만들고 데이터 입력
2. ✅ GoogleAppsScript.js 전체 복사 → Apps Script에 붙여넣기
3. ✅ Apps Script 저장 (Ctrl+S)
4. ✅ 배포 → 배포 관리 → 수정 → **새 버전** → 배포
5. ✅ 테스트 페이지에서 "모든 캐시 삭제"
6. ✅ 입력.html 새로고침 (Ctrl+F5)
7. ✅ F12 → Console에서 "✅ Google Sheets에서 인원/장소 목록 로드 완료" 확인

모든 단계를 정확히 따라했는데도 안 된다면:
- 테스트 페이지의 결과를 확인
- 브라우저 콘솔의 에러 메시지 확인

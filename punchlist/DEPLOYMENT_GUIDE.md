# 📦 Google Apps Script 웹 앱 재배포 가이드

## CORS 에러 해결을 위한 재배포 절차

펀치리스트 일괄등록 시 발생하는 CORS 에러를 해결하기 위해 Google Apps Script를 업데이트하고 재배포해야 합니다.

---

## 🔧 수정된 내용

### 1. bulkCreate 액션 추가
- **파일**: `punchlist/scripts/GoogleAppsScript.js`
- **변경사항**:
  - `doPost()` 함수에 `case 'bulkCreate'` 추가 (line 200-202)
  - `bulkCreateIssues()` 함수 신규 구현 (line 664-749)

### 2. 일괄 등록 기능
- 여러 개의 이슈를 한 번에 등록
- 성공/실패 건수 추적
- 자동 ID 생성 (PL-YYYY-NNN)
- 선택적 이메일 알림

---

## 📋 재배포 단계

### Step 1: Google Apps Script 에디터 열기

1. **Google Sheets 접속**
   ```
   https://docs.google.com/spreadsheets/d/1EqBPn9XrA_5PTg5ks4bgFIjwiojMFDZCYaOkFJINAmE/edit
   ```

2. **Apps Script 에디터 열기**
   - 상단 메뉴: `확장 프로그램` → `Apps Script`

---

### Step 2: 코드 업데이트

1. **기존 코드 전체 선택** (Ctrl+A / Cmd+A)

2. **새 코드로 교체**
   - 로컬에서 수정한 `GoogleAppsScript.js` 파일 내용을 복사
   - Apps Script 에디터에 붙여넣기

3. **주요 변경사항 확인**
   ```javascript
   // Line 200-202: bulkCreate 케이스 추가
   case 'bulkCreate':
     result = bulkCreateIssues(params.issues || []);
     break;

   // Line 664-749: bulkCreateIssues 함수 추가
   function bulkCreateIssues(issuesData) {
     // ... 일괄 등록 로직
   }
   ```

4. **저장** (Ctrl+S / Cmd+S)

---

### Step 3: 웹 앱 재배포

#### 3-1. 새 배포 만들기

1. **배포 메뉴 열기**
   - 우측 상단: `배포` 버튼 클릭
   - `새 배포` 선택

2. **배포 유형 선택**
   - `유형 선택` 클릭
   - `웹 앱` 선택

3. **배포 설정**
   ```
   ✅ 설명: "v2 - bulkCreate 액션 추가 (CORS 에러 수정)"
   ✅ Execute as: Me (본인 계정)
   ✅ Who has access: Anyone (모든 사용자)
   ```

   **⚠️ 중요: "Anyone" 설정이 CORS 허용의 핵심입니다!**

4. **배포 실행**
   - `배포` 버튼 클릭
   - 권한 승인 필요 시: `액세스 권한 검토` → `고급` → `안전하지 않은 페이지로 이동` → `허용`

5. **배포 URL 복사**
   ```
   예시: https://script.google.com/macros/s/AKfycby.../exec
   ```

---

#### 3-2. 기존 배포 업데이트 (대안)

기존 배포를 유지하면서 업데이트하는 방법:

1. **배포 메뉴 열기**
   - `배포` → `배포 관리`

2. **활성 배포 확인**
   - 현재 사용 중인 배포 찾기
   - 웹 앱 URL 확인

3. **새 버전 배포**
   - 우측 연필 아이콘(편집) 클릭
   - `새 버전` 선택
   - `배포` 클릭

4. **배포 설정 재확인**
   ```
   ✅ Execute as: Me
   ✅ Who has access: Anyone
   ```

---

### Step 4: 프론트엔드 URL 업데이트 (필요 시)

**새 배포를 생성한 경우에만 필요합니다.**

기존 배포를 업데이트한 경우, URL이 동일하므로 이 단계는 건너뜁니다.

1. **punchlist.js 파일 열기**
   ```
   /home/qwe/works/s25016/punchlist/scripts/punchlist.js
   ```

2. **SCRIPT_URL 변수 업데이트**
   ```javascript
   const SCRIPT_URL = 'https://script.google.com/macros/s/AKfycby.../exec';
   ```

3. **저장 및 Git 커밋**
   ```bash
   git add punchlist/scripts/punchlist.js
   git commit -m "fix: Update Google Apps Script URL for bulkCreate"
   git push origin master
   ```

---

## ✅ 테스트

### 1. 웹 앱 엔드포인트 테스트

브라우저에서 직접 접속:
```
https://script.google.com/macros/s/YOUR_DEPLOYMENT_ID/exec?action=getAll
```

**예상 결과**: JSON 형식의 이슈 목록 반환

---

### 2. 일괄등록 기능 테스트

1. **펀치리스트 페이지 접속**
   ```
   https://s2501602.vercel.app/punchlist/
   ```

2. **일괄등록 메뉴 선택**

3. **테스트 데이터 입력**
   ```
   제목: 테스트 이슈 1
   분류: 제어
   우선순위: 보통
   담당자: 심태양
   ```

4. **등록 실행**

5. **성공 메시지 확인**
   ```
   ✅ 총 1건 중 1건 성공, 0건 실패
   ```

---

## 🔍 문제 해결

### CORS 에러가 계속 발생하는 경우

#### 원인 1: 배포 설정 오류
**해결책**:
- `Who has access` 설정이 "Anyone"인지 재확인
- 배포 관리에서 활성 배포 상태 확인

#### 원인 2: 이전 배포 URL 사용
**해결책**:
- 최신 배포 URL을 사용하고 있는지 확인
- 브라우저 캐시 삭제 (Ctrl+Shift+R)

#### 원인 3: 스크립트 권한 부족
**해결책**:
- Apps Script 에디터에서 `실행` → `setupSheet` 함수 실행
- 권한 승인 팝업에서 모든 권한 허용

---

### bulkCreate 액션이 작동하지 않는 경우

#### 원인 1: 함수 미배포
**해결책**:
- Apps Script 코드를 저장했는지 확인
- 재배포(새 버전)를 실행했는지 확인

#### 원인 2: 요청 형식 오류
**해결책**:
- POST 요청에 올바른 파라미터 전달 확인:
  ```javascript
  {
    "action": "bulkCreate",
    "issues": [
      { "title": "...", "category": "...", ... },
      { "title": "...", "category": "...", ... }
    ]
  }
  ```

#### 원인 3: 시트 권한 문제
**해결책**:
- Google Sheets 접근 권한 확인
- SHEET_ID가 올바른지 확인

---

## 📞 지원

문제가 계속되면:
1. Apps Script 로그 확인: `실행` → `실행 로그`
2. 브라우저 개발자도구 Console 확인 (F12)
3. 담당자에게 문의: 심태양 (simsun@kakao.com)

---

## 📝 배포 이력

| 버전 | 날짜 | 변경사항 | 배포자 |
|------|------|----------|--------|
| v1.0 | 2024-10-xx | 초기 배포 | - |
| v2.0 | 2024-10-27 | bulkCreate 액션 추가, CORS 에러 수정 | 심태양 |

---

## 🔐 보안 참고사항

- **"Anyone" 접근 설정**: 웹 앱이 인증 없이 접근 가능하지만, Vercel 도메인에서만 사용
- **데이터 검증**: bulkCreateIssues 함수에서 입력 데이터 검증 수행
- **이메일 알림**: 담당자 이메일은 코드 내부에서 관리 (외부 노출 없음)

---

**✅ 재배포 완료 후 CORS 에러가 해결되어야 합니다!**

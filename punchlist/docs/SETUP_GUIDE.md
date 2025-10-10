# S25016 펀치리스트 Google Sheets 설정 가이드

## 개요

펀치리스트 시스템이 작동하려면 Google Sheets를 데이터베이스로 사용하기 위한 초기 설정이 필요합니다.
이 가이드를 따라 약 10-15분 안에 설정을 완료할 수 있습니다.

## 📋 준비물

- Google 계정 (Gmail)
- 인터넷 브라우저 (Chrome 권장)
- 텍스트 에디터 (VS Code, 메모장 등)

---

## 1단계: Google Sheets 생성

### 1-1. 새 스프레드시트 생성

1. 브라우저에서 https://sheets.google.com 접속
2. **+ 새로 만들기** 또는 **빈 스프레드시트** 클릭
3. 시트 이름을 **"S25016_펀치리스트"**로 변경

### 1-2. 시트 ID 복사

1. 브라우저 주소창의 URL을 확인합니다:
   ```
   https://docs.google.com/spreadsheets/d/[SHEET_ID]/edit#gid=0
   ```

2. `[SHEET_ID]` 부분을 복사합니다 (예시):
   ```
   1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p7q8r9s0t1u2v3w4x5y6z
   ```

3. 메모장에 임시로 저장해둡니다.

**💡 팁**: SHEET_ID는 `/d/` 다음부터 `/edit` 전까지의 긴 문자열입니다.

---

## 2단계: Google Apps Script 설정

### 2-1. Apps Script 에디터 열기

1. Google Sheets 메뉴에서 **확장 프로그램 > Apps Script** 클릭
2. 새 탭에서 Apps Script 에디터가 열립니다
3. 기본으로 생성된 `myFunction()` 코드를 모두 삭제합니다

### 2-2. 백엔드 코드 붙여넣기

1. 로컬 파일 `/home/qwe/works/s25016/punchlist/scripts/GoogleAppsScript.js` 열기
2. 전체 코드를 복사합니다 (320줄)
3. Apps Script 에디터에 붙여넣기
4. 프로젝트 이름을 **"S25016_펀치리스트_백엔드"**로 변경

### 2-3. SHEET_ID 업데이트

코드 18번째 줄을 찾아서:

```javascript
// 변경 전
const SHEET_ID = 'YOUR_SHEET_ID';

// 변경 후 (1-2에서 복사한 실제 ID 입력)
const SHEET_ID = '1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p7q8r9s0t1u2v3w4x5y6z';
```

**중요**: 작은따옴표(`'`) 안에 SHEET_ID를 정확히 입력하세요.

### 2-4. 저장

- **Ctrl+S** (Windows) 또는 **Cmd+S** (Mac)
- 또는 상단 디스크 아이콘 클릭

---

## 3단계: 시트 초기화 (헤더 생성)

### 3-1. setupSheet 함수 실행

1. Apps Script 에디터 상단의 함수 선택 드롭다운 클릭
2. **setupSheet** 선택
3. **실행** 버튼 (▶️) 클릭

### 3-2. 권한 승인

**첫 실행 시 권한 요청 팝업이 나타납니다:**

1. **권한 검토** 클릭
2. 본인 Google 계정 선택
3. **고급** 클릭 (경고 메시지가 나타나면)
4. **S25016_펀치리스트_백엔드(안전하지 않음)로 이동** 클릭
5. **허용** 클릭

**💡 왜 "안전하지 않음"이 표시되나요?**
- Google이 직접 검증하지 않은 Apps Script이기 때문입니다
- 본인이 작성한 코드이므로 안전합니다

### 3-3. 실행 결과 확인

1. **실행 로그** 확인 (하단 로그 창):
   ```
   Sheet initialized with headers
   ```

2. Google Sheets 탭으로 돌아가서 새로고침
3. 1행에 헤더가 생성되었는지 확인:
   ```
   ID | 제목 | 분류 | 세부분류 | 우선순위 | 상태 | ...
   ```

---

## 4단계: 웹 앱 배포

### 4-1. 새 배포 시작

1. Apps Script 에디터 우측 상단 **배포 > 새 배포** 클릭
2. **유형 선택** 옆 톱니바퀴 아이콘 클릭
3. **웹 앱** 선택

### 4-2. 배포 설정

다음과 같이 설정합니다:

| 항목 | 값 |
|------|-----|
| **설명** | v1 - 펀치리스트 백엔드 |
| **다음 계정으로 실행** | 나 (본인 이메일) |
| **액세스 권한** | **모든 사용자** |

**중요**: "모든 사용자"를 선택해야 클라이언트에서 접근 가능합니다.

### 4-3. 배포 실행

1. **배포** 버튼 클릭
2. 권한 승인 (3-2와 동일한 과정)
3. 배포 완료 메시지 확인

### 4-4. 웹 앱 URL 복사

배포가 완료되면 **웹 앱 URL**이 표시됩니다:

```
https://script.google.com/macros/s/AKfycbz.../exec
```

**이 URL을 복사하여 메모장에 저장하세요!** (매우 중요)

---

## 5단계: 클라이언트 설정

### 5-1. punchlist.js 파일 수정

1. 로컬 파일 열기:
   ```
   /home/qwe/works/s25016/punchlist/scripts/punchlist.js
   ```

2. 6번째 줄 수정:

```javascript
// 변경 전
const SCRIPT_URL = 'YOUR_GOOGLE_APPS_SCRIPT_URL';

// 변경 후 (4-4에서 복사한 실제 URL 입력)
const SCRIPT_URL = 'https://script.google.com/macros/s/AKfycbz.../exec';
```

3. 파일 저장

---

## 6단계: 테스트

### 6-1. 로컬 서버 실행

터미널에서:

```bash
cd /home/qwe/works/s25016
python3 -m http.server 8000
```

### 6-2. 첫 이슈 등록

1. 브라우저에서 http://localhost:8000/punchlist/pages/create.html 접속
2. 폼 작성:
   - **제목**: "펀치리스트 시스템 테스트"
   - **분류**: 제어
   - **세부분류**: PLC
   - **우선순위**: 보통
   - **문제 상황**: "Google Sheets 연동 테스트입니다."
   - **담당자**: 심태양
   - **요청일/목표일**: 자동으로 설정됨
3. **이슈 등록** 버튼 클릭

### 6-3. 결과 확인

**성공 시:**
- "✅ 이슈가 성공적으로 등록되었습니다!" 알림 표시
- 대시보드로 자동 리다이렉트

**Google Sheets 확인:**
1. Google Sheets 탭으로 이동
2. 새로고침
3. 2행에 방금 등록한 이슈 데이터 확인:
   ```
   PL-2024-001 | 펀치리스트 시스템 테스트 | 제어 | PLC | ...
   ```

### 6-4. 대시보드 확인

1. http://localhost:8000/punchlist/index.html 접속
2. 통계 카드에 **전체 이슈: 1** 표시 확인
3. 테이블에 방금 등록한 이슈 표시 확인

---

## ✅ 설정 완료!

축하합니다! 펀치리스트 시스템이 정상적으로 작동합니다.

### 다음 단계

- [사용 가이드](../README.md) 읽기
- 실제 프로젝트 이슈 등록 시작
- 팀원들과 Google Sheets 공유

---

## 🔧 문제 해결

### 문제 1: "이슈 등록에 실패했습니다" 오류

**원인**: SCRIPT_URL이 올바르지 않음

**해결**:
1. `punchlist/scripts/punchlist.js` 파일의 SCRIPT_URL 확인
2. Apps Script 배포 URL과 정확히 일치하는지 확인
3. URL 끝이 `/exec`로 끝나는지 확인
4. 따옴표 안에 공백이 없는지 확인

### 문제 2: "이슈를 불러오는 데 실패했습니다" 오류

**원인**: Google Apps Script 배포 권한 설정 문제

**해결**:
1. Apps Script 에디터 > **배포 > 배포 관리** 클릭
2. 현재 배포 옆 ⋮ 메뉴 > **수정** 클릭
3. **액세스 권한**이 **모든 사용자**인지 확인
4. **버전** > **새 버전** 생성 후 재배포

### 문제 3: Google Sheets에 데이터가 저장되지 않음

**원인**: SHEET_ID가 올바르지 않음

**해결**:
1. Google Sheets URL에서 SHEET_ID 다시 복사
2. Apps Script 에디터에서 `SHEET_ID` 상수 업데이트
3. 저장 후 재배포

### 문제 4: 권한 승인 팝업이 계속 나타남

**원인**: 브라우저 쿠키/캐시 문제

**해결**:
1. 브라우저 캐시 삭제
2. 시크릿 모드로 시도
3. 다른 브라우저로 시도

---

## 📞 추가 지원

설정 중 문제가 발생하면:

1. **실행 로그 확인**: Apps Script 에디터 > 하단 로그 창
2. **브라우저 콘솔 확인**: F12 > Console 탭
3. **README.md** 참고
4. **이슈 등록**: 펀치리스트 시스템으로 문제 보고

---

## 📚 참고 자료

- [Google Apps Script 공식 문서](https://developers.google.com/apps-script)
- [Google Sheets API 가이드](https://developers.google.com/sheets/api)
- [프로젝트 README](../README.md)

---

**작성일**: 2024-10-10
**버전**: 1.0
**작성자**: S25016 프로젝트 팀

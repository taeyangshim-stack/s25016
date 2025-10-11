# 📊 펀치리스트 구글 시트 연동 가이드

## 현재 상태

- ✅ 구글 시트 생성 완료: `1EqBPn9XrA_5PTg5ks4bgFIjwiojMFDZCYaOkFJINAmE`
- ✅ GoogleAppsScript.js에 SHEET_ID 설정 완료
- ⏳ Apps Script 배포 필요
- ⏳ 배포 URL을 punchlist.js에 설정 필요

## 단계별 설정 방법

### 1단계: Apps Script 열기

1. 구글 시트 열기: https://docs.google.com/spreadsheets/d/1EqBPn9XrA_5PTg5ks4bgFIjwiojMFDZCYaOkFJINAmE/edit
2. 상단 메뉴에서 **확장 프로그램** > **Apps Script** 클릭
3. 새 프로젝트가 열립니다

### 2단계: 코드 붙여넣기

1. Apps Script 편집기에서 기본 코드를 **모두 삭제**
2. `/home/qwe/works/s25016/punchlist/scripts/GoogleAppsScript.js` 파일의 **전체 내용**을 복사
3. Apps Script 편집기에 **붙여넣기**
4. **Ctrl+S** (또는 💾 저장 아이콘) 클릭하여 저장
5. 프로젝트 이름을 "S25016 펀치리스트"로 변경 (선택사항)

### 3단계: 시트 초기화 (최초 1회만)

1. Apps Script 편집기 상단에서 함수 선택 드롭다운 클릭
2. **setupSheet** 함수 선택
3. **▶ 실행** 버튼 클릭
4. 권한 요청 팝업이 나타나면:
   - **권한 검토** 클릭
   - 본인 구글 계정 선택
   - **고급** 클릭 (안전하지 않은 앱 경고가 나올 수 있음)
   - **S25016 펀치리스트(안전하지 않음)로 이동** 클릭
   - **허용** 클릭
5. 실행이 완료되면 구글 시트에 헤더가 생성됩니다

**헤더 확인**:
- ID, 제목, 분류, 세부분류, 우선순위, 상태
- 문제상황, 원인분석, 조치계획, 조치결과
- 담당자, 협의자, 승인자
- 요청일, 목표일, 완료일
- 첨부파일, 댓글
- 생성일시, 수정일시
- customFields, templateId

### 4단계: Apps Script 배포 (중요!)

1. Apps Script 편집기 우측 상단 **배포** 버튼 클릭
2. **새 배포** 선택
3. ⚙️ **유형 선택** 클릭 → **웹 앱** 선택
4. **설명**: "S25016 펀치리스트 API v1" (또는 원하는 설명)
5. **다음 계정으로 실행**: **나** 선택
6. ⚠️ **중요! 액세스 권한**: **모든 사용자** 선택
   - ❌ "본인만" 선택 시 → Vercel에서 접근 불가
   - ✅ "모든 사용자" 선택 → Vercel에서 접근 가능
7. **배포** 버튼 클릭
8. **웹 앱 URL**이 표시됩니다 → **복사** 버튼 클릭

**배포 URL 예시**:
```
https://script.google.com/macros/s/AKfycbxXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/exec
```

### 5단계: punchlist.js에 배포 URL 설정

1. `/home/qwe/works/s25016/punchlist/scripts/punchlist.js` 파일 열기
2. 6번째 줄 수정:
   ```javascript
   // 변경 전
   const SCRIPT_URL = 'YOUR_GOOGLE_APPS_SCRIPT_URL';

   // 변경 후 (복사한 배포 URL 붙여넣기)
   const SCRIPT_URL = 'https://script.google.com/macros/s/AKfycbxXXXX.../exec';
   ```
3. 저장 후 Git 커밋 & 푸시

### 6단계: 테스트

1. 로컬 서버 실행:
   ```bash
   python3 -m http.server 8000
   ```

2. 브라우저에서 접속:
   ```
   http://localhost:8000/punchlist/pages/list.html
   ```

3. 개발자 도구(F12) → Console 확인:
   - Mock 모드: `🔧 Mock 모드: 테스트 데이터 사용 중`
   - 실제 모드: `✅ 이슈 로드 성공` (또는 에러 메시지)

4. 새 이슈 등록 테스트:
   ```
   http://localhost:8000/punchlist/pages/create.html
   ```
   - 이슈 생성 후 구글 시트에서 데이터 확인

### 7단계: Vercel 배포

1. Git 커밋 & 푸시:
   ```bash
   git add punchlist/scripts/GoogleAppsScript.js
   git add punchlist/scripts/punchlist.js
   git commit -m "feat: 펀치리스트 구글 시트 연동 설정 완료"
   git push origin master
   ```

2. Vercel 자동 배포 (1-2분 소요)

3. Vercel 배포 후 테스트:
   ```
   https://s2501602.vercel.app/punchlist/pages/list.html
   ```

## 📌 중요 체크리스트

- [ ] Apps Script 편집기에서 코드 붙여넣기 완료
- [ ] setupSheet() 함수 실행하여 헤더 생성 완료
- [ ] Apps Script 배포 시 **"모든 사용자"** 액세스 권한 선택
- [ ] 배포 URL을 punchlist.js의 SCRIPT_URL에 설정
- [ ] 로컬에서 테스트 (Mock 모드 → 실제 모드 전환 확인)
- [ ] 구글 시트에서 데이터 확인
- [ ] Git 커밋 & 푸시
- [ ] Vercel 배포 후 테스트

## 🔧 문제 해결

### Mock 모드에서 벗어나지 않는 경우

**원인**: `SCRIPT_URL`이 제대로 설정되지 않음

**해결**:
```javascript
// punchlist.js 6번째 줄 확인
const SCRIPT_URL = 'YOUR_GOOGLE_APPS_SCRIPT_URL'; // ❌ 잘못된 설정

// 올바른 설정 예시
const SCRIPT_URL = 'https://script.google.com/macros/s/AKfycbxXXXX.../exec'; // ✅
```

### CORS 에러 발생 시

**원인**: Apps Script 배포 시 액세스 권한이 "본인만"으로 설정됨

**해결**:
1. Apps Script 편집기 → **배포** → **배포 관리**
2. 기존 배포의 ✏️ 편집 아이콘 클릭
3. **액세스 권한**을 **"모든 사용자"**로 변경
4. **버전 업데이트** (새 버전 만들기)
5. **배포** 클릭
6. 새 배포 URL을 punchlist.js에 업데이트

### 데이터가 시트에 저장되지 않는 경우

**원인 1**: SHEET_ID가 잘못됨
```javascript
// GoogleAppsScript.js 18번째 줄 확인
const SHEET_ID = '1EqBPn9XrA_5PTg5ks4bgFIjwiojMFDZCYaOkFJINAmE'; // ✅ 올바른 ID
```

**원인 2**: 시트 이름이 다름
```javascript
// GoogleAppsScript.js 17번째 줄 확인
const SHEET_NAME = 'PunchList'; // 구글 시트 탭 이름과 일치해야 함
```

시트 탭 이름을 "PunchList"로 변경하거나, 코드를 현재 탭 이름으로 수정

### 이메일 알림이 오지 않는 경우

**원인**: 이메일 주소가 설정되지 않음

**해결**:
```javascript
// GoogleAppsScript.js 333-335번째 줄 수정
const emails = {
  '심태양': 'simsun@kakao.com',  // 실제 이메일로 변경
  '김철수': 'kim@example.com',
  '박영희': 'park@example.com'
};
```

## 📚 참고 자료

- [Google Apps Script 공식 문서](https://developers.google.com/apps-script)
- [Apps Script 웹 앱 배포 가이드](https://developers.google.com/apps-script/guides/web)
- `/home/qwe/works/s25016/punchlist/docs/VERCEL_DEPLOYMENT_GUIDE.md` (Vercel CORS 문제 해결)

## 🎯 다음 단계

배포 URL을 알려주시면:
1. punchlist.js 파일을 자동으로 업데이트
2. Git 커밋 & 푸시
3. Vercel 배포 확인

까지 도와드리겠습니다!

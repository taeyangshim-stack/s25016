# Vercel 배포 가이드 - Google Sheets 연동 해결

## 문제 상황

로컬(localhost)에서는 Google Sheets 연동이 잘 되지만, Vercel로 배포하면 접근이 안 되는 문제가 발생합니다.

**원인**: CORS(Cross-Origin Resource Sharing) 정책 때문입니다.

## 해결 방법

### 1. Google Apps Script 재배포 (필수)

Google Apps Script를 **웹 앱으로 재배포**할 때 다음 설정을 확인하세요:

#### Apps Script 편집기에서:

1. **배포 > 새 배포** 클릭
2. **유형 선택**: 웹 앱
3. **중요! 다음 설정 확인**:
   - **다음 계정으로 실행**: 나
   - **액세스 권한**: **모든 사용자** (중요!)
4. **배포** 클릭
5. 새로운 배포 URL 복사

#### 왜 "모든 사용자"로 설정해야 하나요?

- "나만" 또는 "Google 계정이 있는 사용자"로 설정하면 Vercel 서버에서 접근할 수 없습니다
- "모든 사용자"로 설정하면 Vercel 도메인에서도 접근 가능합니다

### 2. 배포 URL 업데이트

`punchlist/scripts/punchlist.js` 파일에서:

```javascript
// 이 URL을 Google Apps Script 배포 URL로 변경
const SCRIPT_URL = 'YOUR_GOOGLE_APPS_SCRIPT_URL';
```

를 다음과 같이 변경:

```javascript
const SCRIPT_URL = 'https://script.google.com/macros/s/YOUR_DEPLOYMENT_ID/exec';
```

### 3. Google Apps Script 코드 확인

`GoogleAppsScript.js`의 `doGet()` 및 `doPost()` 함수가 올바르게 구현되어 있는지 확인:

```javascript
function doGet(e) {
  const action = e.parameter.action;

  if (action === 'getAll') {
    return getAllIssues();
  } else if (action === 'getById') {
    return getIssueById(e.parameter.id);
  }

  return ContentService.createTextOutput(
    JSON.stringify({ success: false, error: 'Invalid action' })
  ).setMimeType(ContentService.MimeType.JSON);
}

function doPost(e) {
  try {
    const params = JSON.parse(e.postData.contents);
    const action = params.action;

    let result;
    switch(action) {
      case 'create':
        result = createIssue(params.data);
        break;
      case 'update':
        result = updateIssue(params.data);
        break;
      case 'delete':
        result = deleteIssue(params.id);
        break;
      // ... 기타 액션
      default:
        result = ContentService.createTextOutput(
          JSON.stringify({ success: false, error: 'Invalid action' })
        ).setMimeType(ContentService.MimeType.JSON);
    }

    return result;
  } catch(error) {
    return ContentService.createTextOutput(
      JSON.stringify({ success: false, error: error.toString() })
    ).setMimeType(ContentService.MimeType.JSON);
  }
}
```

### 4. Vercel 환경 변수 설정 (선택사항)

더 안전한 방법으로, Vercel 환경 변수를 사용할 수 있습니다:

#### Vercel 대시보드에서:

1. 프로젝트 선택
2. **Settings** > **Environment Variables**
3. 새 변수 추가:
   - Name: `VITE_GOOGLE_SCRIPT_URL`
   - Value: `https://script.google.com/macros/s/YOUR_DEPLOYMENT_ID/exec`
   - Environments: Production, Preview, Development 모두 체크

#### punchlist.js 수정:

```javascript
// 환경 변수 사용 (Vite 환경)
const SCRIPT_URL = import.meta.env.VITE_GOOGLE_SCRIPT_URL || 'YOUR_GOOGLE_APPS_SCRIPT_URL';
```

**참고**: 현재 프로젝트는 순수 HTML/JS이므로 Vite를 사용하지 않습니다. 환경 변수 대신 코드에 직접 URL을 입력하세요.

## 테스트 방법

### 1. 로컬에서 테스트

```bash
# 로컬 서버 실행
python -m http.server 8000

# 브라우저에서 확인
http://localhost:8000/punchlist/index.html
```

브라우저 개발자 도구(F12) > Console 탭에서 에러 확인

### 2. Vercel에서 테스트

```bash
# Git에 커밋 및 푸시
git add .
git commit -m "fix: Google Sheets URL 업데이트"
git push origin master
```

Vercel이 자동으로 배포하면:
- https://YOUR_PROJECT.vercel.app/punchlist/index.html 접속
- 개발자 도구 > Console 탭에서 에러 확인

## 일반적인 에러 및 해결

### 에러 1: "CORS policy error"

```
Access to fetch at 'https://script.google.com/...' from origin 'https://your-project.vercel.app'
has been blocked by CORS policy
```

**해결**:
- Google Apps Script 재배포 시 "모든 사용자" 권한으로 설정
- 배포 후 새 URL로 업데이트

### 에러 2: "Failed to fetch"

```
TypeError: Failed to fetch
```

**해결**:
- SCRIPT_URL이 올바른지 확인
- Google Sheets ID가 올바른지 확인
- Apps Script에서 `setupSheet()` 함수를 실행했는지 확인

### 에러 3: "Authorization required"

```
{ success: false, error: "Authorization required" }
```

**해결**:
- Apps Script 배포 설정에서 "액세스 권한"을 "모든 사용자"로 변경
- 재배포 필요

## 체크리스트

배포 전 다음 항목을 확인하세요:

- [ ] Google Sheets ID가 `GoogleAppsScript.js`에 설정됨
- [ ] `setupSheet()` 함수 실행됨 (시트 헤더 생성)
- [ ] Google Apps Script가 "웹 앱"으로 배포됨
- [ ] 배포 권한이 "모든 사용자"로 설정됨
- [ ] 배포 URL이 `punchlist.js`의 `SCRIPT_URL`에 설정됨
- [ ] `SCRIPT_URL`이 `'YOUR_GOOGLE_APPS_SCRIPT_URL'`이 아님 (실제 URL로 변경)
- [ ] Git에 커밋 및 푸시됨
- [ ] Vercel에서 자동 배포 완료

## 보안 주의사항

### Google Sheets 보안

**Q**: "모든 사용자" 권한은 안전한가요?

**A**: 다음 방법으로 보안을 강화할 수 있습니다:

1. **시트 자체는 비공개**로 유지 (Apps Script만 공개)
2. **Apps Script에서 API 키 검증** 추가 (선택사항)

#### API 키 검증 예시 (선택사항):

```javascript
// GoogleAppsScript.js 상단에 추가
const API_KEY = 'YOUR_SECRET_API_KEY'; // 안전한 곳에 보관

function doPost(e) {
  // API 키 검증
  const params = JSON.parse(e.postData.contents);
  if (params.apiKey !== API_KEY) {
    return ContentService.createTextOutput(
      JSON.stringify({ success: false, error: 'Invalid API Key' })
    ).setMimeType(ContentService.MimeType.JSON);
  }

  // 나머지 코드...
}
```

```javascript
// punchlist.js에서 API 키 포함
const response = await fetch(SCRIPT_URL, {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    action: 'create',
    apiKey: 'YOUR_SECRET_API_KEY', // 환경 변수로 관리 권장
    data: issueData
  })
});
```

## 추가 리소스

- [Google Apps Script Web Apps 문서](https://developers.google.com/apps-script/guides/web)
- [Vercel 배포 문서](https://vercel.com/docs)
- [CORS 이해하기](https://developer.mozilla.org/ko/docs/Web/HTTP/CORS)

## 문제 해결 지원

문제가 계속되면 다음 정보를 확인하세요:

1. 브라우저 개발자 도구 > Console 탭 전체 로그
2. Network 탭에서 실패한 요청의 Headers 및 Response
3. Google Apps Script > 실행 로그 확인

위 정보를 바탕으로 문제를 진단할 수 있습니다.

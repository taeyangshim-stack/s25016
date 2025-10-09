# Projects 폴더

이 폴더는 S25016 프로젝트의 모든 개별 프로젝트를 관리합니다.

## 📂 프로젝트 목록

### 현재 프로젝트

1. **work-management** - 근무관리 시스템
   - 경로: `/projects/work-management/`
   - 설명: 출입 기록 입력, 조회, 수정 시스템
   - Google Sheets 연동

2. **robot-vertical-axis** - 상하축 이슈
   - 경로: `/projects/robot-vertical-axis/`
   - 설명: 갠트리 로봇 간섭 문제 해결 프로젝트
   - ROBOT↔UI 테스트 결과 관리

3. **devicenet** - DeviceNet 통신
   - 경로: `/projects/devicenet/`
   - 설명: Lincoln Electric Power Wave 용접기 DeviceNet 인터페이스
   - 158개 신호 관리

4. **error-handling** - 에러 핸들링
   - 경로: `/projects/error-handling/`
   - 설명: 로봇 에러 핸들링 절차 및 디파인 자료

5. **hexagon** - Hexagon 측정
   - 경로: `/projects/hexagon/`
   - 설명: 로봇 정밀도 검증 프로젝트
   - 측정 결과 및 일정 관리

## 🚀 새 프로젝트 추가하기

### 방법 1: 자동 생성 스크립트 (추천)

```bash
./scripts/create-new-project.sh <project-name> "<프로젝트 제목>" "<설명>"
```

**예시:**
```bash
./scripts/create-new-project.sh quality-control "품질관리" "품질 검사 및 관리 시스템"
```

**자동 생성되는 폴더 구조:**
```
projects/quality-control/
├── index.html          # 메인 페이지 (템플릿 기반)
├── pages/              # 추가 페이지
├── scripts/            # JavaScript
├── styles/             # CSS
├── docs/               # 문서
├── tests/              # 테스트
├── assets/             # 자산
└── README.md           # 프로젝트 설명
```

### 방법 2: 수동 생성

```bash
# 1. 폴더 생성
mkdir -p projects/new-project/{pages,scripts,styles,docs,tests,assets}

# 2. 템플릿 복사
cp shared/templates/project-template.html projects/new-project/index.html

# 3. README 작성
vim projects/new-project/README.md

# 4. 템플릿 변수 치환
# {{PROJECT_TITLE}}, {{PROJECT_DESCRIPTION}} 등 수정
```

## 📋 프로젝트 구조 표준

모든 프로젝트는 다음 구조를 따라야 합니다:

```
project-name/
├── index.html              # ✅ 필수: 메인 페이지
├── README.md               # ✅ 필수: 프로젝트 설명
├── pages/                  # ⭕ 선택: 추가 페이지
│   ├── input.html
│   ├── query.html
│   └── settings.html
├── scripts/                # ⭕ 선택: JavaScript
│   ├── main.js
│   └── api-client.js
├── styles/                 # ⭕ 선택: 프로젝트 전용 CSS
│   └── custom.css
├── docs/                   # ⭕ 선택: 프로젝트 문서
│   ├── guide.md
│   └── api.md
├── tests/                  # ⭕ 선택: 테스트 파일
│   └── test-api.html
└── assets/                 # ⭕ 선택: 이미지, 데이터
    ├── images/
    └── data/
```

## 🎨 공통 자산 사용

모든 프로젝트는 `/shared/` 폴더의 공통 자산을 사용해야 합니다:

### HTML 헤더

```html
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>프로젝트 제목 - S25016</title>

    <!-- ✅ 필수: 공통 스타일 -->
    <link rel="stylesheet" href="/shared/styles/variables.css">
    <link rel="stylesheet" href="/shared/styles/reset.css">
    <link rel="stylesheet" href="/shared/styles/components.css">

    <!-- ⭕ 선택: 프로젝트 전용 스타일 -->
    <link rel="stylesheet" href="styles/custom.css">
</head>
```

### JavaScript

```html
<script src="/shared/scripts/utils.js"></script>
<script>
    const utils = window.S25016Utils;

    // 유틸리티 함수 사용
    const today = utils.getTodayDate();
    utils.saveToStorage('key', 'value');
</script>
```

## 📝 네이밍 컨벤션

### 프로젝트명
- **형식**: kebab-case
- **예시**: `work-management`, `quality-control`, `robot-vertical-axis`
- **규칙**:
  - 소문자만 사용
  - 단어 구분은 하이픈(-)
  - 날짜 포함 금지
  - 3단어 이하 권장

### 파일명
- **HTML**: `kebab-case.html`
  - 예: `input.html`, `query-results.html`
- **JavaScript**: `camelCase.js`
  - 예: `apiClient.js`, `utils.js`
- **CSS**: `kebab-case.css`
  - 예: `main.css`, `custom-styles.css`
- **문서**: `kebab-case.md`
  - 예: `user-guide.md`, `api-reference.md`

## 🔗 통합 대시보드 연동

새 프로젝트 생성 후 메인 대시보드에 추가:

### 1. index.html 수정

```html
<!-- /index.html -->
<div class="projects-grid">
    <!-- 기존 프로젝트 카드들 -->

    <!-- 새 프로젝트 카드 추가 -->
    <a href="/projects/new-project/" class="project-card">
        <div class="project-icon">🚀</div>
        <h3>프로젝트 제목</h3>
        <p>프로젝트 설명</p>
        <span class="badge badge-info">진행 중</span>
    </a>
</div>
```

### 2. Vercel 라우팅 추가 (선택사항)

```json
// vercel.json
{
  "rewrites": [
    {
      "source": "/new-project",
      "destination": "/projects/new-project/index.html"
    }
  ]
}
```

## 📊 프로젝트 라이프사이클

### 1. 기획 단계
- [ ] 프로젝트명 결정
- [ ] 요구사항 정의
- [ ] 폴더 구조 설계

### 2. 개발 단계
- [ ] 프로젝트 생성 (스크립트 또는 수동)
- [ ] README.md 작성
- [ ] index.html 개발
- [ ] 추가 페이지 개발
- [ ] 테스트 작성

### 3. 통합 단계
- [ ] 공통 스타일 적용
- [ ] 통합 대시보드 연동
- [ ] 로컬 테스트
- [ ] Git 커밋

### 4. 배포 단계
- [ ] Vercel 설정 (필요 시)
- [ ] 프로덕션 배포
- [ ] 팀원 공유

### 5. 유지보수 단계
- [ ] 버그 수정
- [ ] 기능 추가
- [ ] 문서 업데이트

## 🛠️ 개발 가이드

### 로컬 서버 실행

```bash
# 프로젝트 루트에서
python3 -m http.server 8000

# 브라우저에서 접속
http://localhost:8000/projects/project-name/
```

### 디버깅

```javascript
// utils.js 디버깅
const utils = window.S25016Utils;
console.log(utils);

// LocalStorage 확인
console.log(localStorage);

// 공통 스타일 적용 확인
console.log(getComputedStyle(document.documentElement).getPropertyValue('--color-primary'));
```

### 코드 품질

```bash
# HTML 검증
# https://validator.w3.org/

# CSS 검증
# https://jigsaw.w3.org/css-validator/

# JavaScript 린트
# 브라우저 콘솔에서 에러 확인
```

## 📚 참고 자료

- [Shared 폴더 가이드](/shared/README.md)
- [리팩토링 계획서](/REFACTORING_PLAN.md)
- [CLAUDE.md](/docs/development/CLAUDE.md)
- [AGENTS.md](/docs/development/AGENTS.md)

## 🤝 기여 가이드

프로젝트 추가 시:

1. **이슈 생성**: 프로젝트 필요성 논의
2. **브랜치 생성**: `feature/project-name`
3. **프로젝트 개발**: 표준 구조 따르기
4. **Pull Request**: 리뷰 요청
5. **머지**: 승인 후 master에 머지

## 💬 문의

- 담당: SP 심태양
- 프로젝트: S25016
- 위치: 34bay 자동용접 A라인/B라인

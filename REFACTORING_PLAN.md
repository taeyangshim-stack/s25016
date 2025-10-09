# S25016 프로젝트 리팩토링 계획서

## 📋 목차
1. [현재 구조 분석](#현재-구조-분석)
2. [문제점 및 개선 필요사항](#문제점-및-개선-필요사항)
3. [새로운 폴더 구조 제안](#새로운-폴더-구조-제안)
4. [리팩토링 단계별 계획](#리팩토링-단계별-계획)
5. [마이그레이션 전략](#마이그레이션-전략)
6. [확장성 고려사항](#확장성-고려사항)

---

## 📊 현재 구조 분석

### 루트 레벨 (혼재된 구조)
```
s25016/
├── index.html                         # 통합 대시보드
├── 상하축이슈_대시보드.html            # 개별 대시보드 (루트에 위치)
├── 250917_상하축이슈/                 # 날짜 기반 폴더명
├── 251003_용접기_디바이스넷/          # 날짜 기반 폴더명
├── 251004_에러핸들링/                 # 날짜 기반 폴더명
├── hexagon/                          # 프로젝트명 폴더
├── 근무관리/                          # 기능명 폴더
├── api/                              # API 폴더
├── cloudinary-uploader/              # 유틸리티 폴더
├── AGENTS.md                         # 루트 문서
├── CLAUDE.md                         # 루트 문서
├── README.md                         # 루트 문서
├── VERCEL_DEPLOYMENT.md              # 루트 문서
└── vercel.json                       # 배포 설정
```

### 근무관리 폴더 (문서와 코드 혼재)
```
근무관리/
├── index.html                        # 대시보드
├── 입력.html                          # 기능 페이지
├── 조회.html                          # 기능 페이지
├── 설정.html                          # 기능 페이지
├── GoogleAppsScript.js               # 백엔드 코드
├── 테스트_API연결.html                # 테스트 파일
├── 테스트_조회기능.html               # 테스트 파일
├── 문제해결_가이드.md                 # 문서
├── 수정기능_디버그_가이드.md          # 문서
├── 성능최적화_보고서.md               # 문서
└── ... (17개 파일)
```

---

## ⚠️ 문제점 및 개선 필요사항

### 1. **폴더명 불일치 (Naming Convention)**

**문제:**
- 날짜 기반: `250917_상하축이슈`, `251003_용접기_디바이스넷`
- 프로젝트명: `hexagon`
- 기능명: `근무관리`
- **일관성 없음**

**영향:**
- 폴더 목적을 파악하기 어려움
- 확장 시 어떤 규칙을 따를지 불명확

### 2. **문서와 코드 혼재**

**문제:**
- `근무관리/` 폴더: HTML, JS, MD 파일 모두 같은 위치
- 테스트 파일이 프로덕션 파일과 혼재
- 가이드 문서가 코드와 같은 레벨

**영향:**
- 파일 찾기 어려움
- 배포 시 불필요한 파일 포함 가능성
- 유지보수 어려움

### 3. **루트 레벨에 개별 대시보드**

**문제:**
- `상하축이슈_대시보드.html`이 루트에 위치
- `250917_상하축이슈/` 폴더와 분리됨

**영향:**
- 관련 파일들이 분산되어 있음
- 프로젝트 구조 이해 어려움

### 4. **확장성 부족**

**문제:**
- 새 프로젝트 추가 시 어디에 둘지 불명확
- 공통 자산(CSS, JS, 이미지) 관리 방법 없음
- 백엔드/프론트엔드 구분 없음

**영향:**
- 프로젝트 추가 시마다 구조가 달라짐
- 코드 재사용 어려움

### 5. **날짜 기반 폴더명의 한계**

**문제:**
- `250917_상하축이슈`: 날짜가 폴더명에 포함
- 프로젝트가 언제 시작했는지는 중요하지 않음
- 검색 시 프로젝트명으로 찾기 어려움

**영향:**
- 직관성 저하
- 프로젝트 수명이 길어지면 날짜가 무의미해짐

---

## 🎯 새로운 폴더 구조 제안

### 설계 원칙

1. **도메인 기반 분류**: 프로젝트를 도메인(기능 영역)으로 분류
2. **일관된 Naming Convention**: 모든 폴더명은 영어 또는 한글로 통일
3. **관심사의 분리 (Separation of Concerns)**:
   - 코드 (HTML, JS, CSS)
   - 문서 (MD, PDF, PPTX)
   - 테스트
   - 자산 (이미지, 데이터)
4. **확장 가능성**: 새 프로젝트 추가가 쉬워야 함
5. **Vercel 배포 친화적**: 정적 파일 배포에 최적화

---

### 제안 A: 기능 중심 구조 (Function-Oriented)

```
s25016/
├── docs/                           # 📚 모든 문서 통합
│   ├── project/                   # 프로젝트 문서
│   │   ├── robot-vertical-axis/   # 상하축 이슈
│   │   │   ├── 01_analysis/       # 문제점 분석
│   │   │   ├── 02_solution/       # 대책 수립
│   │   │   ├── 03_schedule/       # 일정 관리
│   │   │   ├── 04_progress/       # 작업 진행
│   │   │   └── 05_references/     # 문서 자료
│   │   ├── devicenet/             # DeviceNet 통신
│   │   │   ├── specifications/    # 사양서
│   │   │   └── checklists/        # 체크리스트
│   │   ├── error-handling/        # 에러 핸들링
│   │   │   └── define-materials/  # 디파인 자료
│   │   └── hexagon/               # Hexagon 측정
│   │       └── reports/           # 보고서
│   ├── guides/                    # 가이드 문서
│   │   ├── deployment/            # 배포 가이드
│   │   ├── development/           # 개발 가이드
│   │   └── troubleshooting/       # 문제 해결
│   └── archive/                   # 아카이브 (날짜별)
│       ├── 2025-09/
│       └── 2025-10/
│
├── apps/                          # 🚀 웹 애플리케이션
│   ├── dashboard/                 # 통합 대시보드
│   │   ├── index.html
│   │   ├── assets/
│   │   │   ├── css/
│   │   │   ├── js/
│   │   │   └── images/
│   │   └── components/            # 재사용 컴포넌트
│   │
│   ├── work-management/           # 근무관리 시스템
│   │   ├── index.html             # 대시보드
│   │   ├── pages/                 # 페이지들
│   │   │   ├── input.html         # 입력
│   │   │   ├── query.html         # 조회
│   │   │   └── settings.html      # 설정
│   │   ├── scripts/               # JavaScript
│   │   │   ├── GoogleAppsScript.js
│   │   │   └── utils.js
│   │   ├── styles/                # CSS
│   │   │   └── main.css
│   │   ├── tests/                 # 테스트
│   │   │   ├── test-api.html
│   │   │   └── test-query.html
│   │   └── docs/                  # 앱별 문서
│   │       ├── 문제해결_가이드.md
│   │       ├── 성능최적화_보고서.md
│   │       └── 수정기능_디버그_가이드.md
│   │
│   ├── robot-vertical-axis/       # 상하축 이슈 대시보드
│   │   └── index.html
│   │
│   ├── devicenet/                 # DeviceNet 대시보드
│   │   ├── index.html
│   │   ├── signals-table.html
│   │   └── progress-dashboard.html
│   │
│   ├── hexagon/                   # Hexagon 측정
│   │   ├── index.html
│   │   ├── robot-accuracy.html
│   │   ├── schedule.html
│   │   └── punchlist.html
│   │
│   └── error-handling/            # 에러 핸들링
│       └── index.html
│
├── shared/                        # 🔧 공통 자산
│   ├── styles/                    # 공통 CSS
│   │   ├── variables.css          # CSS 변수
│   │   ├── reset.css              # 리셋
│   │   └── components.css         # 공통 컴포넌트
│   ├── scripts/                   # 공통 JS
│   │   ├── api-client.js          # API 클라이언트
│   │   ├── utils.js               # 유틸리티
│   │   └── constants.js           # 상수
│   ├── components/                # HTML 컴포넌트
│   │   ├── header.html
│   │   ├── footer.html
│   │   └── nav.html
│   └── assets/                    # 이미지, 폰트
│       ├── images/
│       ├── fonts/
│       └── icons/
│
├── api/                           # 🌐 API 엔드포인트
│   └── cloudinary/                # Cloudinary 업로더
│       └── upload.js
│
├── tests/                         # 🧪 통합 테스트
│   ├── e2e/                       # End-to-End
│   ├── integration/               # 통합 테스트
│   └── fixtures/                  # 테스트 데이터
│
├── config/                        # ⚙️ 설정 파일
│   ├── vercel.json                # Vercel 배포
│   └── .gitignore
│
├── scripts/                       # 📜 유틸리티 스크립트
│   ├── migrate-structure.sh       # 리팩토링 스크립트
│   └── build.sh                   # 빌드 스크립트
│
├── .claude/                       # Claude Code 설정
│   └── settings.local.json
│
├── index.html                     # 🏠 루트 대시보드 (Vercel 진입점)
├── README.md                      # 프로젝트 README
├── CLAUDE.md                      # Claude 가이드
└── AGENTS.md                      # 개발 가이드

```

---

### 제안 B: 프로젝트 중심 구조 (Project-Oriented) - 추천 ⭐

```
s25016/
├── projects/                      # 🎯 프로젝트별 모듈
│   ├── robot-vertical-axis/       # 상하축 이슈
│   │   ├── dashboard.html         # 개별 대시보드
│   │   ├── assets/
│   │   │   ├── css/
│   │   │   └── js/
│   │   └── docs/                  # 프로젝트 전용 문서
│   │       ├── analysis/          # 01_문제점분석
│   │       ├── solution/          # 02_대책수립
│   │       ├── schedule/          # 03_일정관리
│   │       ├── progress/          # 04_작업진행
│   │       └── references/        # 05_문서자료
│   │
│   ├── devicenet/                 # DeviceNet 통신
│   │   ├── dashboard.html
│   │   ├── signals-table.html
│   │   ├── docs/
│   │   │   ├── specifications/
│   │   │   │   └── Y50031_DeviceNetInterface.pdf
│   │   │   ├── checklists/
│   │   │   └── progress/
│   │   └── assets/
│   │
│   ├── error-handling/            # 에러 핸들링
│   │   ├── dashboard.html
│   │   └── docs/
│   │       ├── procedures/
│   │       └── define-materials/
│   │
│   ├── hexagon/                   # Hexagon 측정
│   │   ├── index.html
│   │   ├── robot-accuracy.html
│   │   ├── schedule.html
│   │   ├── punchlist.html
│   │   ├── data/
│   │   └── docs/
│   │
│   └── work-management/           # 근무관리 시스템
│       ├── index.html             # 대시보드
│       ├── pages/
│       │   ├── input.html
│       │   ├── query.html
│       │   └── settings.html
│       ├── scripts/
│       │   ├── GoogleAppsScript.js
│       │   ├── api-client.js
│       │   └── utils.js
│       ├── styles/
│       │   └── main.css
│       ├── tests/
│       │   ├── test-api.html
│       │   └── test-query.html
│       └── docs/
│           ├── troubleshooting.md
│           ├── performance-optimization.md
│           └── debugging-guide.md
│
├── shared/                        # 🔧 공통 자산 (제안 A와 동일)
│   ├── styles/
│   ├── scripts/
│   ├── components/
│   └── assets/
│
├── api/                           # 🌐 API (제안 A와 동일)
│   └── cloudinary/
│
├── docs/                          # 📚 프로젝트 공통 문서
│   ├── deployment/                # 배포 가이드
│   │   ├── VERCEL_DEPLOYMENT.md
│   │   └── VERCEL_DEPLOYMENT_GUIDE.md
│   ├── development/               # 개발 가이드
│   │   ├── CLAUDE.md
│   │   └── AGENTS.md
│   ├── archive/                   # 아카이브
│   │   └── 2025-10/
│   └── meetings/                  # 회의록
│
├── scripts/                       # 📜 유틸리티 스크립트
│   ├── migrate-structure.sh
│   └── build.sh
│
├── config/                        # ⚙️ 설정
│   ├── vercel.json
│   └── .gitignore
│
├── index.html                     # 🏠 통합 대시보드 (Vercel 진입점)
├── README.md
└── package.json

```

---

## 🎯 권장 구조: 제안 B (프로젝트 중심)

### 선택 이유

1. **도메인 명확성**
   - 각 프로젝트가 독립된 폴더
   - 프로젝트 추가 시 `projects/` 아래에만 추가

2. **문서-코드 관계 명확**
   - 프로젝트별 문서가 해당 프로젝트 폴더 내에 위치
   - 관련 파일을 한곳에서 관리

3. **확장성**
   - 새 프로젝트 추가: `projects/new-project/` 생성
   - 공통 자산: `shared/` 폴더 활용

4. **Vercel 배포 친화적**
   - 루트에 `index.html` 유지
   - 프로젝트별 라우팅 가능 (`/projects/hexagon/`)

5. **유지보수 용이**
   - 프로젝트별 독립성 보장
   - 하나의 프로젝트 수정이 다른 프로젝트에 영향 없음

---

## 📝 리팩토링 단계별 계획

### Phase 1: 준비 및 백업 (1일)

**목표**: 안전한 리팩토링을 위한 준비

**작업:**
1. ✅ 현재 구조 분석 완료
2. ✅ 리팩토링 계획서 작성
3. ⬜ Git 브랜치 생성: `refactor/project-structure`
4. ⬜ 전체 프로젝트 백업 (압축)
5. ⬜ 파일 이동 매핑 테이블 작성

**Output:**
- `REFACTORING_PLAN.md` (이 문서)
- `MIGRATION_MAP.md` (파일 이동 매핑)
- `s25016_backup_YYYYMMDD.tar.gz` (백업)

---

### Phase 2: 새 폴더 구조 생성 (0.5일)

**목표**: 빈 폴더 구조 생성 및 README 작성

**작업:**
1. ⬜ `projects/` 폴더 생성
2. ⬜ 각 프로젝트 폴더 생성
3. ⬜ `shared/`, `api/`, `docs/` 폴더 생성
4. ⬜ 각 폴더에 README.md 작성 (폴더 목적 설명)

**스크립트:**
```bash
scripts/create-structure.sh
```

**Output:**
- 새 폴더 구조 (빈 상태)
- 각 폴더별 README.md

---

### Phase 3: 파일 이동 - 프로젝트별 (2일)

**목표**: 기존 파일을 새 구조로 이동

#### 3.1 근무관리 시스템 마이그레이션

**이동:**
```
근무관리/index.html          → projects/work-management/index.html
근무관리/입력.html            → projects/work-management/pages/input.html
근무관리/조회.html            → projects/work-management/pages/query.html
근무관리/설정.html            → projects/work-management/pages/settings.html
근무관리/GoogleAppsScript.js → projects/work-management/scripts/GoogleAppsScript.js
근무관리/테스트_*.html       → projects/work-management/tests/
근무관리/*.md                → projects/work-management/docs/
```

**작업:**
1. ⬜ HTML 파일 이동
2. ⬜ 내부 경로 수정 (상대 경로 → 새 경로)
3. ⬜ 테스트 실행 (로컬 서버)
4. ⬜ 문서 이동

#### 3.2 상하축 이슈 마이그레이션

**이동:**
```
250917_상하축이슈/           → projects/robot-vertical-axis/docs/
상하축이슈_대시보드.html      → projects/robot-vertical-axis/dashboard.html
```

#### 3.3 DeviceNet 마이그레이션

**이동:**
```
251003_용접기_디바이스넷/    → projects/devicenet/docs/
```

#### 3.4 Hexagon 마이그레이션

**이동:**
```
hexagon/                     → projects/hexagon/
```

#### 3.5 에러 핸들링 마이그레이션

**이동:**
```
251004_에러핸들링/           → projects/error-handling/docs/
```

---

### Phase 4: 공통 자산 분리 (1일)

**목표**: 중복 CSS/JS를 공통 폴더로 추출

**작업:**
1. ⬜ 공통 CSS 패턴 분석
2. ⬜ `shared/styles/` 생성
   - `variables.css` (색상, 폰트 변수)
   - `reset.css` (브라우저 리셋)
   - `components.css` (버튼, 카드 등)
3. ⬜ 공통 JS 유틸리티 추출
   - `shared/scripts/utils.js`
   - `shared/scripts/api-client.js`
4. ⬜ 각 프로젝트에서 공통 자산 import

**예시:**
```html
<!-- 기존 -->
<style>
  .btn { background: #667eea; ... }
</style>

<!-- 새 구조 -->
<link rel="stylesheet" href="/shared/styles/components.css">
```

---

### Phase 5: 문서 정리 (0.5일)

**목표**: 문서 중앙화 및 업데이트

**작업:**
1. ⬜ `docs/` 폴더 정리
   - CLAUDE.md → docs/development/CLAUDE.md
   - AGENTS.md → docs/development/AGENTS.md
   - VERCEL_DEPLOYMENT.md → docs/deployment/
2. ⬜ README.md 업데이트 (새 구조 반영)
3. ⬜ 각 프로젝트 README.md 작성
4. ⬜ 아카이브 폴더로 구 문서 이동

---

### Phase 6: 경로 수정 및 테스트 (1일)

**목표**: 모든 링크 및 경로 수정

**작업:**
1. ⬜ HTML 파일 내부 링크 수정
   - `href="../조회.html"` → `href="/projects/work-management/pages/query.html"`
2. ⬜ JavaScript 경로 수정
   - `import './utils.js'` → `import '/shared/scripts/utils.js'`
3. ⬜ CSS 경로 수정
4. ⬜ 통합 대시보드 (index.html) 링크 업데이트
5. ⬜ 모든 페이지 로컬 테스트
6. ⬜ 브라우저 콘솔 에러 체크

**테스트 체크리스트:**
- [ ] 모든 대시보드 페이지 로드
- [ ] 내부 링크 작동
- [ ] CSS 스타일 적용
- [ ] JavaScript 실행
- [ ] API 호출 (근무관리 시스템)

---

### Phase 7: Vercel 설정 업데이트 (0.5일)

**목표**: 배포 설정 수정

**작업:**
1. ⬜ `vercel.json` 업데이트
   - 라우팅 규칙 추가
   - 리다이렉트 설정
2. ⬜ `.vercelignore` 업데이트
   - 테스트 파일 제외
   - 문서 파일 제외
3. ⬜ 배포 테스트 (프리뷰)

**vercel.json 예시:**
```json
{
  "rewrites": [
    { "source": "/work-management", "destination": "/projects/work-management/index.html" },
    { "source": "/hexagon", "destination": "/projects/hexagon/index.html" }
  ]
}
```

---

### Phase 8: 구 폴더 제거 및 정리 (0.5일)

**목표**: 마이그레이션 완료 후 정리

**작업:**
1. ⬜ 구 폴더 삭제 전 최종 백업
2. ⬜ 빈 폴더 제거
3. ⬜ 불필요한 파일 제거
   - `*.Zone.Identifier`
   - 중복 파일
   - 임시 파일
4. ⬜ Git 커밋 및 푸시
5. ⬜ 배포 확인

---

### Phase 9: 문서화 및 배포 (0.5일)

**목표**: 최종 문서화 및 배포

**작업:**
1. ⬜ CHANGELOG.md 작성
2. ⬜ README.md 최종 업데이트
3. ⬜ CLAUDE.md 새 구조 반영
4. ⬜ 마이그레이션 가이드 작성
5. ⬜ 프로덕션 배포
6. ⬜ 팀원에게 변경사항 공유

---

## 🔄 마이그레이션 전략

### 안전한 마이그레이션 원칙

1. **점진적 마이그레이션**
   - 한 번에 하나의 프로젝트씩
   - 각 단계마다 테스트

2. **브랜치 전략**
   ```
   master (현재 구조, 프로덕션)
     ↓
   refactor/project-structure (리팩토링 작업)
     ↓
   refactor/test (테스트 및 검증)
     ↓
   master (병합 후 배포)
   ```

3. **롤백 계획**
   - 백업 파일 유지 (최소 1주일)
   - Git 태그: `v1.0-before-refactor`
   - 문제 발생 시 즉시 롤백 가능

4. **병렬 운영**
   - 리팩토링 중에도 기존 구조 유지
   - 새 구조 테스트 완료 후 전환

---

## 🚀 확장성 고려사항

### 1. 새 프로젝트 추가 프로세스

**단계:**
```bash
# 1. 프로젝트 폴더 생성
mkdir -p projects/new-project/{pages,scripts,styles,docs,tests}

# 2. README.md 작성
echo "# New Project" > projects/new-project/README.md

# 3. index.html 생성 (템플릿 사용)
cp shared/templates/project-template.html projects/new-project/index.html

# 4. 통합 대시보드에 링크 추가
# (index.html 수정)

# 5. Vercel 라우팅 추가
# (vercel.json 수정)
```

### 2. 공통 컴포넌트 시스템

**목표**: 재사용 가능한 UI 컴포넌트

**예시:**
```html
<!-- shared/components/card.html -->
<div class="card">
  <div class="card-header">{{title}}</div>
  <div class="card-body">{{content}}</div>
</div>
```

**사용:**
```javascript
// shared/scripts/components.js
function loadComponent(name, data) {
  fetch(`/shared/components/${name}.html`)
    .then(res => res.text())
    .then(html => {
      return html.replace(/{{(\w+)}}/g, (_, key) => data[key]);
    });
}
```

### 3. 버전 관리 전략

**디렉토리별 버전:**
```
projects/work-management/
├── v1/                    # 현재 프로덕션
├── v2/                    # 개발 중
└── index.html             # → v1로 라우팅
```

### 4. 다국어 지원 (향후)

**구조:**
```
shared/
└── i18n/
    ├── ko.json            # 한국어
    └── en.json            # 영어
```

### 5. API 모듈화

**현재:**
```javascript
// GoogleAppsScript.js (단일 파일)
```

**향후:**
```
api/
├── google-sheets/
│   ├── work-management.js
│   ├── hexagon.js
│   └── common.js
└── cloudinary/
    └── upload.js
```

---

## 📊 리팩토링 타임라인

| Phase | 작업 | 예상 시간 | 담당 |
|-------|------|----------|------|
| 1 | 준비 및 백업 | 1일 | 개발자 |
| 2 | 새 폴더 구조 생성 | 0.5일 | 개발자 |
| 3 | 파일 이동 | 2일 | 개발자 |
| 4 | 공통 자산 분리 | 1일 | 개발자 |
| 5 | 문서 정리 | 0.5일 | 개발자 |
| 6 | 경로 수정 및 테스트 | 1일 | 개발자 + QA |
| 7 | Vercel 설정 | 0.5일 | 개발자 |
| 8 | 구 폴더 제거 | 0.5일 | 개발자 |
| 9 | 문서화 및 배포 | 0.5일 | 개발자 |
| **총합** | | **7.5일** | |

**실제 소요 예상**: 9-10일 (버퍼 포함)

---

## ✅ 성공 기준

### 리팩토링 완료 체크리스트

- [ ] 모든 페이지가 로컬에서 정상 작동
- [ ] 모든 페이지가 Vercel에서 정상 작동
- [ ] 브라우저 콘솔 에러 없음
- [ ] 모든 링크 작동
- [ ] Google Sheets API 연동 정상
- [ ] 근무관리 시스템 CRUD 정상
- [ ] README.md 업데이트 완료
- [ ] CLAUDE.md 업데이트 완료
- [ ] Git 히스토리 정리 완료
- [ ] 팀원 승인 완료

---

## 🎯 다음 단계

### 즉시 실행

1. **사용자 승인 요청**
   - 이 계획서 검토
   - 제안 A vs 제안 B 선택
   - 타임라인 확인

2. **Phase 1 시작**
   - Git 브랜치 생성
   - 백업 생성
   - 파일 이동 매핑 작성

3. **자동화 스크립트 작성**
   - `scripts/migrate.sh`: 파일 이동 자동화
   - `scripts/update-paths.sh`: 경로 수정 자동화
   - `scripts/test-all.sh`: 전체 테스트 자동화

---

## 💬 질문 및 검토 사항

### 사용자에게 확인 필요:

1. **구조 선택**
   - [ ] 제안 A (기능 중심)
   - [ ] 제안 B (프로젝트 중심) ⭐ 추천

2. **폴더명 언어**
   - [ ] 영어 (robot-vertical-axis, work-management)
   - [ ] 한글 (상하축이슈, 근무관리)
   - [ ] 혼용 (현재 상태 유지)

3. **마이그레이션 타이밍**
   - [ ] 즉시 시작
   - [ ] 다음 주 시작
   - [ ] 추후 계획

4. **우선순위 프로젝트**
   - [ ] 근무관리 시스템 먼저
   - [ ] 전체 동시 진행
   - [ ] 단계별 진행

---

**작성 일시**: 2025-10-10
**작성자**: Claude Code
**버전**: 1.0
**상태**: 검토 대기

이 계획에 대한 피드백을 주시면 즉시 리팩토링을 시작하겠습니다! 🚀

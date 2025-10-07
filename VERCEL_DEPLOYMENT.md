# 🚀 S25016 프로젝트 Vercel 배포 가이드

## 프로젝트 개요

S25016 통합 대시보드 + Cloudinary 업로더를 Vercel에 배포하는 가이드입니다.

---

## 📁 프로젝트 구조

```
s25016/
├── api/                              # Vercel 서버리스 함수
│   ├── upload.js                     # 파일 업로드 API
│   ├── files.js                      # 파일 목록 조회 API
│   └── folders.js                    # 폴더 목록 조회 API
├── cloudinary-uploader/              # Cloudinary 업로더
│   ├── dashboard.html                # 로컬 개발용 대시보드
│   ├── dashboard-vercel.html         # Vercel 배포용 대시보드
│   ├── uploader.js                   # CLI 업로더
│   └── server.js                     # 로컬 개발 서버 (Vercel 제외)
├── 250917_상하축이슈/                # 로봇 프로젝트 문서
├── 251003_용접기_디바이스넷/          # DeviceNet 문서
├── hexagon/                          # Hexagon 측정 프로젝트
├── index.html                        # 메인 대시보드
├── 상하축이슈_대시보드.html           # 로봇 전용 대시보드
├── vercel.json                       # Vercel 배포 설정
├── package.json                      # 의존성 관리
├── .gitignore                        # Git 제외 파일
└── .vercelignore                     # Vercel 제외 파일
```

---

## 🔧 배포 준비

### 1. 의존성 설치

```bash
cd /home/qwe/works/s25016
npm install
```

설치되는 패키지:
- `cloudinary` - Cloudinary SDK
- `formidable` - 파일 업로드 파싱

### 2. Vercel CLI 설치 (필요 시)

```bash
npm install -g vercel
```

---

## 🌐 Vercel 배포

### 방법 1: GitHub 자동 배포 (권장)

#### Step 1: GitHub 저장소에 푸시

```bash
cd /home/qwe/works/s25016

# 변경사항 확인
git status

# 모든 파일 추가
git add .

# 커밋
git commit -m "feat: Vercel 배포를 위한 프로젝트 정리 및 Cloudinary API 추가"

# 푸시
git push origin master
```

#### Step 2: Vercel에서 프로젝트 가져오기

1. https://vercel.com 로그인
2. "New Project" 클릭
3. GitHub 저장소 선택 (`s25016`)
4. Import 클릭

#### Step 3: 환경 변수 설정

Vercel 프로젝트 설정에서 다음 환경 변수 추가:

```
CLOUDINARY_CLOUD_NAME=dmmjpofcc
CLOUDINARY_API_KEY=763721125922284
CLOUDINARY_API_SECRET=vU-nSXa-XQcdh27uyqejE6YBdxA
CLOUDINARY_UPLOAD_FOLDER=s25016
```

**설정 방법:**
- Vercel Dashboard → Project Settings → Environment Variables
- 각 변수를 `Production`, `Preview`, `Development` 모두에 체크

#### Step 4: 배포

- 자동으로 배포가 시작됩니다
- 완료되면 URL이 생성됩니다 (예: `https://s25016.vercel.app`)

---

### 방법 2: Vercel CLI로 직접 배포

```bash
cd /home/qwe/works/s25016

# Vercel 로그인
vercel login

# 배포 (첫 배포)
vercel

# 프로덕션 배포
vercel --prod
```

배포 중 질문:
- **Set up and deploy?** → Yes
- **Which scope?** → 본인 계정 선택
- **Link to existing project?** → No
- **Project name?** → s25016 (또는 원하는 이름)
- **Directory?** → ./ (엔터)
- **Override settings?** → No

**환경 변수 추가:**

```bash
vercel env add CLOUDINARY_CLOUD_NAME
vercel env add CLOUDINARY_API_KEY
vercel env add CLOUDINARY_API_SECRET
vercel env add CLOUDINARY_UPLOAD_FOLDER
```

각 명령 실행 시 값 입력 후 `Production`, `Preview`, `Development` 선택.

---

## 📋 배포 후 확인

### 접속 URL

배포가 완료되면 다음 URL로 접속 가능:

- **메인 대시보드**: `https://your-project.vercel.app/`
- **Cloudinary 업로더**: `https://your-project.vercel.app/cloudinary`
- **Hexagon**: `https://your-project.vercel.app/hexagon`
- **DeviceNet**: `https://your-project.vercel.app/devicenet`
- **로봇 대시보드**: `https://your-project.vercel.app/robot-dashboard`

### API 엔드포인트

- **파일 업로드**: `POST https://your-project.vercel.app/api/upload`
- **파일 목록**: `GET https://your-project.vercel.app/api/files?folder=s25016`
- **폴더 목록**: `GET https://your-project.vercel.app/api/folders`

---

## 🧪 로컬 테스트

Vercel 배포 전 로컬에서 테스트:

```bash
# Vercel 개발 서버 실행
vercel dev
```

브라우저에서 `http://localhost:3000` 접속

**로컬 개발 시 필요:**
- `.env` 파일이 프로젝트 루트에 있어야 함
- 또는 환경 변수를 수동으로 설정

---

## 🔐 환경 변수 관리

### Vercel Secret 사용 (보안 강화)

```bash
# Secret 생성
vercel secrets add cloudinary_cloud_name dmmjpofcc
vercel secrets add cloudinary_api_key 763721125922284
vercel secrets add cloudinary_api_secret vU-nSXa-XQcdh27uyqejE6YBdxA

# Secret은 @이름 형식으로 참조됨
```

`vercel.json`에 이미 설정되어 있음:

```json
"env": {
  "CLOUDINARY_CLOUD_NAME": "@cloudinary_cloud_name",
  "CLOUDINARY_API_KEY": "@cloudinary_api_key",
  "CLOUDINARY_API_SECRET": "@cloudinary_api_secret"
}
```

---

## 🎯 Cloudinary 대시보드 사용 (배포 후)

### Vercel 배포 버전 사용

1. `https://your-project.vercel.app/cloudinary` 접속
2. 파일 드래그 앤 드롭 또는 클릭하여 선택
3. 폴더명 입력 (기본: `s25016`)
4. "🚀 업로드 시작" 클릭
5. 완료 후 URL 복사/다운로드

**주의:** 서버리스 함수는 실행 시간 제한이 있습니다 (무료: 10초, Pro: 60초).
대용량 파일이나 많은 파일 업로드 시 타임아웃이 발생할 수 있습니다.

---

## 📊 로컬 vs Vercel 비교

| 기능 | 로컬 개발 | Vercel 배포 |
|------|----------|------------|
| **실행 방법** | `npm run server` | 자동 배포 |
| **URL** | `http://localhost:3000` | `https://*.vercel.app` |
| **환경 변수** | `.env` 파일 | Vercel 설정 |
| **API** | Express 서버 | 서버리스 함수 |
| **업로드 제한** | 설정 가능 | 10초 (무료) / 60초 (Pro) |
| **파일 크기** | 10MB (설정 가능) | 4.5MB (Body limit) |

---

## 🐛 문제 해결

### 배포 실패

```bash
# 로그 확인
vercel logs your-project-url

# 재배포
vercel --prod --force
```

### 환경 변수 오류

```bash
# 환경 변수 확인
vercel env ls

# 환경 변수 삭제
vercel env rm CLOUDINARY_CLOUD_NAME

# 다시 추가
vercel env add CLOUDINARY_CLOUD_NAME
```

### API 호출 실패

- Vercel Dashboard → Deployments → 해당 배포 클릭 → Functions 탭 확인
- 함수 로그에서 오류 메시지 확인

### CORS 오류

API 함수에 CORS 헤더가 이미 설정되어 있음.
만약 문제가 있다면 `api/*.js` 파일의 CORS 설정 확인.

### 파일 업로드 실패

- 환경 변수 확인 (Cloudinary 키)
- 파일 크기 확인 (4.5MB 이하)
- Cloudinary 계정 용량 확인

---

## 📈 배포 후 작업

### 1. 커스텀 도메인 설정 (선택)

Vercel Dashboard → Project Settings → Domains에서 설정

### 2. 모니터링

- Vercel Analytics 활성화
- Cloudinary Dashboard에서 사용량 모니터링

### 3. CI/CD 파이프라인

GitHub에 푸시할 때마다 자동으로 배포됩니다:
- `master` 브랜치 → Production
- 다른 브랜치 → Preview

---

## 🔄 업데이트 배포

### GitHub 자동 배포 사용 시

```bash
# 코드 수정 후
git add .
git commit -m "feat: 기능 추가"
git push origin master

# Vercel이 자동으로 배포
```

### CLI 사용 시

```bash
vercel --prod
```

---

## 📌 중요 참고사항

### 보안

⚠️ **절대 Git에 커밋하지 말 것:**
- `.env` 파일
- API 키가 포함된 설정 파일
- `.gitignore`에 추가되어 있는지 확인

### 제한사항

**Vercel 무료 플랜:**
- 서버리스 함수 실행 시간: 10초
- 요청 Body 크기: 4.5MB
- 대역폭: 100GB/월
- 배포 횟수: 무제한

**Cloudinary 무료 플랜:**
- 저장 공간: 25GB
- 월별 대역폭: 25GB
- 파일당 크기: 10MB

---

## 🎓 추가 학습 자료

- [Vercel 공식 문서](https://vercel.com/docs)
- [Cloudinary 문서](https://cloudinary.com/documentation)
- [Serverless Functions 가이드](https://vercel.com/docs/functions/serverless-functions)

---

## 📞 담당

- **프로젝트:** S25016
- **담당자:** SP 심태양
- **위치:** 34bay 자동용접 A라인/B라인

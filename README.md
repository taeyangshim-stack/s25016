# S25016 프로젝트 통합 대시보드

로봇 시스템 개발 · DeviceNet 통신 · 정밀 측정 솔루션

---

## 🎯 프로젝트 개요

S25016 프로젝트는 다음 4개 주요 영역을 통합 관리합니다:

1. **DeviceNet 통신**: Lincoln Electric Power Wave 용접기 (158개 신호)
2. **로봇 상하축 이슈**: 갠트리 로봇 간섭 문제 해결
3. **Hexagon 측정**: 로봇 정밀도 검증 프로젝트
4. **Cloudinary 업로더**: 파일 관리 시스템

---

## 🚀 빠른 시작

### 로컬 개발

```bash
# 프로젝트 클론
git clone <repository-url>
cd s25016

# 의존성 설치
npm install

# 로컬 서버 실행 (정적 파일)
python3 -m http.server 8000

# 또는 Cloudinary 업로더 서버 실행
cd cloudinary-uploader
npm install
npm run server
```

### Vercel 배포

```bash
# 배포
vercel

# 프로덕션 배포
vercel --prod
```

자세한 내용은 [VERCEL_DEPLOYMENT.md](VERCEL_DEPLOYMENT.md) 참고

---

## 📁 프로젝트 구조

```
s25016/
├── api/                              # Vercel 서버리스 함수
│   ├── upload.js                     # Cloudinary 업로드 API
│   ├── files.js                      # 파일 목록 조회 API
│   └── folders.js                    # 폴더 목록 조회 API
├── cloudinary-uploader/              # Cloudinary 업로더
│   ├── dashboard.html                # 로컬 개발용
│   ├── dashboard-vercel.html         # Vercel 배포용
│   ├── uploader.js                   # CLI 업로더
│   └── server.js                     # 로컬 개발 서버
├── 250917_상하축이슈/                # 로봇 프로젝트
│   ├── 01_문제점분석/
│   ├── 02_대책수립/
│   ├── 03_일정관리/
│   ├── 04_작업진행/
│   ├── 05_문서자료/
│   └── 99_공유폴더/
├── 251003_용접기_디바이스넷/          # DeviceNet 문서
│   ├── DeviceNet_Signals_Table.html
│   └── Y50031_DeviceNetInterfaceSpecification-21.pdf
├── hexagon/                          # Hexagon 측정
│   ├── index.html
│   ├── robot-accuracy.html
│   ├── schedule.html
│   └── punchlist.html
├── index.html                        # 메인 대시보드
├── 상하축이슈_대시보드.html           # 로봇 전용 대시보드
├── vercel.json                       # Vercel 설정
├── package.json                      # 의존성
└── README.md                         # 이 파일
```

---

## 🌐 주요 페이지

### 로컬 개발 (http://localhost:8000)

- **메인**: `/` - 통합 대시보드
- **Cloudinary**: `/cloudinary-uploader/dashboard.html` - 파일 업로더
- **Hexagon**: `/hexagon/` - 정밀 측정
- **DeviceNet**: `/251003_용접기_디바이스넷/DeviceNet_Signals_Table.html`
- **로봇**: `/상하축이슈_대시보드.html`

### Vercel 배포 (https://your-project.vercel.app)

- **메인**: `/`
- **Cloudinary**: `/cloudinary`
- **Hexagon**: `/hexagon`
- **DeviceNet**: `/devicenet`
- **로봇**: `/robot-dashboard`

---

## 📚 문서

- **[VERCEL_DEPLOYMENT.md](VERCEL_DEPLOYMENT.md)** - Vercel 배포 가이드
- **[VERCEL_DEPLOYMENT_GUIDE.md](VERCEL_DEPLOYMENT_GUIDE.md)** - 기존 배포 가이드
- **[AGENTS.md](AGENTS.md)** - 개발 가이드라인
- **[CLAUDE.md](CLAUDE.md)** - 프로젝트 컨텍스트
- **[cloudinary-uploader/README.md](cloudinary-uploader/README.md)** - CLI 업로더 가이드
- **[cloudinary-uploader/DASHBOARD_GUIDE.md](cloudinary-uploader/DASHBOARD_GUIDE.md)** - 대시보드 가이드

---

## 🔧 주요 기능

### 1. Cloudinary 업로더

**CLI 사용:**
```bash
cd cloudinary-uploader
node uploader.js ./files --folder=s25016/documents --urls --copy
```

**웹 대시보드:**
- 드래그 앤 드롭 업로드
- 폴더 지정
- 실시간 진행 상황
- URL 복사/다운로드

### 2. DeviceNet 신호 테이블

- 158개 신호 체계적 정리
- 10개 섹션 분류
- 실시간 I/O Assembly
- 용접 시퀀스 상태 (14 states)

### 3. 로봇 상하축 이슈 관리

- ROBOT↔UI 테스트 결과 (31개 항목)
- 문제 분석 및 대책 수립
- 일정 관리 및 진행 상황

### 4. Hexagon 정밀 측정

- 로봇 정확도 분석
- 프로젝트 일정표
- 펀치리스트 관리

---

## 🔐 환경 변수

### 로컬 개발

`cloudinary-uploader/.env` 파일 생성:

```env
CLOUDINARY_CLOUD_NAME=dmmjpofcc
CLOUDINARY_API_KEY=763721125922284
CLOUDINARY_API_SECRET=vU-nSXa-XQcdh27uyqejE6YBdxA
CLOUDINARY_UPLOAD_FOLDER=s25016
```

### Vercel 배포

Vercel Dashboard에서 환경 변수 설정:
- `CLOUDINARY_CLOUD_NAME`
- `CLOUDINARY_API_KEY`
- `CLOUDINARY_API_SECRET`
- `CLOUDINARY_UPLOAD_FOLDER`

---

## 🛠️ 개발

### 로컬 Cloudinary 업로더 서버

```bash
cd cloudinary-uploader
npm install
npm run server
```

`http://localhost:3000` 접속

### Vercel 개발 서버

```bash
npm install
vercel dev
```

`http://localhost:3000` 접속

---

## 📊 기술 스택

### 프론트엔드
- HTML5, CSS3, JavaScript (Vanilla)
- Chart.js (통계 시각화)
- Responsive Design

### 백엔드
- Vercel Serverless Functions (Node.js)
- Express (로컬 개발)
- Cloudinary SDK

### 배포
- Vercel (자동 CI/CD)
- GitHub Integration

---

## 🧪 테스트

### ROBOT↔UI 테스트 현황

**최근 테스트 (2024.10.03-10.04):**
- 총 31개 항목
- ✅ 완료: 13개
- ⚠️ 개선 필요: 11개
- ⏸️ 보류: 7개
- 📅 다음 일정: 2024.10.11 (UI 개선 및 에러 핸들링)

---

## 🐛 문제 해결

### Cloudinary 업로드 실패
- API 키 확인
- 파일 크기 확인 (10MB 이하)
- 환경 변수 설정 확인

### Vercel 배포 실패
- `vercel logs` 명령으로 로그 확인
- 환경 변수 설정 확인
- `.vercelignore` 파일 확인

### 로컬 서버 실행 오류
- `npm install` 재실행
- Node.js 버전 확인 (18.x 이상)
- 포트 충돌 확인 (`lsof -i :3000`)

---

## 📝 커밋 규칙

Conventional Commits 사용:

- `feat:` - 새로운 기능
- `fix:` - 버그 수정
- `docs:` - 문서 수정
- `style:` - 코드 포맷팅
- `refactor:` - 리팩토링
- `test:` - 테스트 추가

예시:
```bash
git commit -m "feat: Cloudinary 업로더 대시보드 추가"
git commit -m "fix: DeviceNet 신호 테이블 오타 수정"
git commit -m "docs: Vercel 배포 가이드 업데이트"
```

---

## 🎯 향후 계획

- [ ] 업로드 이력 저장 (DB 연동)
- [ ] 사용자 인증 시스템
- [ ] 이미지 미리보기 및 편집
- [ ] 대용량 파일 청크 업로드
- [ ] 실시간 협업 기능
- [ ] 모바일 앱 개발

---

## 📞 담당

- **프로젝트:** S25016
- **담당자:** SP 심태양
- **위치:** 34bay 자동용접 A라인/B라인

---

## 📄 라이선스

MIT License

---

## 🙏 참고

- [Vercel 공식 문서](https://vercel.com/docs)
- [Cloudinary 문서](https://cloudinary.com/documentation)
- [Lincoln Electric Power Wave](https://www.lincolnelectric.com/)

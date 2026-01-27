<p align="center">
  <h1 align="center">S25016 프로젝트</h1>
  <p align="center">
    <strong>로봇 시스템 개발 · DeviceNet 통신 · 정밀 측정 솔루션</strong>
  </p>
  <p align="center">
    <img src="https://img.shields.io/badge/Version-v1.8.5-blue" alt="Version">
    <img src="https://img.shields.io/badge/Vercel-Deployed-black?logo=vercel" alt="Vercel">
    <img src="https://img.shields.io/badge/Node.js-18.x-339933?logo=node.js" alt="Node.js">
    <img src="https://img.shields.io/badge/Python-3.x-3776AB?logo=python" alt="Python">
    <img src="https://img.shields.io/badge/ABB_RAPID-v3.1.1-red" alt="RAPID">
    <img src="https://img.shields.io/badge/License-MIT-blue" alt="License">
  </p>
</p>

> **34bay 자동용접 A라인/B라인** | ABB SpGantry 1200 갠트리 로봇 시스템 통합 관리 플랫폼

---

## 📑 목차

- [프로젝트 개요](#-프로젝트-개요)
- [프로젝트 하이라이트](#-프로젝트-하이라이트)
- [주요 기능](#-주요-기능)
- [기술 스택](#-기술-스택)
- [프로젝트 구조](#-프로젝트-구조)
- [빠른 시작](#-빠른-시작)
- [API 엔드포인트](#-api-엔드포인트)
- [환경 변수 설정](#-환경-변수-설정)
- [배포](#-배포)
- [유틸리티 스크립트](#-유틸리티-스크립트)
- [트러블슈팅](#-트러블슈팅)
- [문서](#-문서)
- [담당자](#-담당자)
- [라이선스](#-라이선스)

---

## 🎯 프로젝트 개요

**S25016**은 ABB 갠트리 로봇 시스템 개발을 위한 통합 관리 플랫폼입니다.

### 4개 핵심 영역

| 영역 | 설명 |
|------|------|
| **🔌 DeviceNet 통신** | Lincoln Electric Power Wave 용접기 연동 (158개 신호) |
| **🤖 로봇 상하축 이슈** | 갠트리 로봇 Y-Z-R축 동기화 및 간섭 해결 |
| **📐 Hexagon 측정** | CMM 정밀 측정을 통한 로봇 정확도 검증 |
| **☁️ 파일 관리** | Cloudinary 기반 문서/이미지 통합 관리 |

---

## 🌟 프로젝트 하이라이트

### 최신 성과 (v1.8.5_260104)

- ✅ **Robot1/Robot2 TCP 좌표 일치 성공**
  - 모든 R 각도에서 **0.15mm 이내** 정밀도 달성
  - 690mm~976mm 오차 문제 완전 해결
  - 수학적 좌표 변환 공식 검증 완료

- 📊 **744개 로봇 이벤트 로그 자동 분석**
  - 3개 로봇 유닛 통합 모니터링
  - 61개 알람 유형 자동 분류 및 트렌드 분석
  - 실시간 이슈 추적 시스템

- 🔌 **158개 DeviceNet 신호 체계적 관리**
  - Lincoln Electric Power Wave 용접기 완전 연동
  - 10개 섹션, 14단계 용접 시퀀스 상태 관리
  - 실시간 신호 모니터링 대시보드

- 📋 **3주 완료 계획 실시간 추적**
  - 담당자별 진행 현황 시각화
  - 간트 차트 자동 생성
  - Google Sheets 연동으로 협업 강화

- 🤖 **ABB RAPID 코드 자동 검증**
  - 인코딩 오류 자동 감지 및 수정
  - 버전 관리 시스템 (현재 v3.1.1)
  - 백업 비교 및 변경 이력 추적

---

## ✨ 주요 기능

### 📊 통합 대시보드
6개 탭으로 구성된 웹 기반 대시보드
- **개요**: 프로젝트 현황, 타임라인, 바로가기
- **펀치리스트**: 이슈 추적 (기계/전기/제어)
- **이벤트 로그**: 로봇 알람 분석 (61개 유형)
- **근태 관리**: 출퇴근 기록 및 통계
- **문서 관리**: 기술 문서, 보고서, 가이드
- **모션 뷰어**: 3D 용접 경로 시각화

### ☁️ Cloudinary 업로더
- 드래그 앤 드롭 웹 업로드
- CLI 배치 업로드 지원
- 폴더 구조 관리
- URL 자동 복사

### 🤖 ABB RAPID 코드 관리
- 버전 관리 (현재 v3.1.1)
- 인코딩 검증 및 자동 수정
- 백업 비교 및 분석
- TCP 좌표계 검증

### 📋 펀치리스트 시스템
- 3주 완료 계획 관리
- 담당자별 진행 현황
- Google Sheets 연동
- 간트 차트 시각화

### 📈 이벤트 로그 분석
- 3개 로봇 유닛 로그 통합 (744개 파일)
- 61개 알람 유형 자동 분류
- 발생 빈도 분석 및 트렌드

### 🔌 DeviceNet 신호 테이블
- 158개 신호 체계적 정리
- 10개 섹션 분류
- 14단계 용접 시퀀스 상태

---

## 🛠 기술 스택

| 영역 | 기술 |
|------|------|
| **Frontend** | HTML5, CSS3, JavaScript (Vanilla), Chart.js |
| **Backend** | Node.js 18.x, Vercel Serverless Functions, Express |
| **Storage** | Cloudinary (파일), Google Sheets (데이터), JSON |
| **Automation** | Python 3 (로그 분석, RAPID 검증) |
| **Deployment** | Vercel (자동 CI/CD), GitHub Integration |
| **Robot** | ABB RAPID (v3.1.1), RobotStudio |

---

## 📁 프로젝트 구조

```
s25016/
├── api/                              # Vercel 서버리스 함수
│   ├── upload.js                     # Cloudinary 업로드
│   ├── files.js                      # 파일 목록 조회
│   ├── folders.js                    # 폴더 목록 조회
│   ├── punchlist.js                  # 펀치리스트 CRUD
│   └── work-records.js               # 근태 기록
│
├── cloudinary-uploader/              # 파일 업로드 도구
│   ├── uploader.js                   # CLI 업로더
│   ├── server.js                     # 로컬 개발 서버
│   └── dashboard.html                # 웹 대시보드
│
├── RAPID/                            # ABB 로봇 코드
│   ├── SpGantry_*/                   # 로봇 백업들
│   ├── PlanB_ToolControl2/           # 툴 제어 모듈
│   └── scripts/                      # 검증 스크립트
│       ├── validate_and_fix_rapid.py
│       ├── check_version.py
│       └── update_version.py
│
├── B_Line_EventMessage/              # 이벤트 로그 분석
│   ├── log_analyzer.py               # 로그 통계
│   ├── alarm_analyzer.py             # 알람 패턴 추출
│   └── analysis/                     # 분석 결과 (JSON)
│
├── punchlist/                        # 펀치리스트 앱
│   ├── index.html                    # 메인 페이지
│   ├── 3week-plan/                   # 3주 완료 계획
│   └── pages/                        # 서브 페이지
│
├── projects/                         # 서브 프로젝트
│   ├── devicenet/                    # DeviceNet 통신
│   ├── hexagon/                      # 정밀 측정
│   ├── work-management/              # 근태 관리
│   └── robot-backup/                 # 백업 비교
│
├── 250917_상하축이슈/                # 상하축 이슈 워크스페이스
│   ├── 01_문제점분석/
│   ├── 02_대책수립/
│   ├── 03_일정관리/
│   ├── 04_작업진행/
│   ├── 05_문서자료/
│   └── 99_공유폴더/
│
├── scripts/                          # 유틸리티 스크립트
├── index.html                        # 메인 대시보드
├── vercel.json                       # Vercel 설정
├── package.json                      # 의존성
└── AGENTS.md                         # 개발 가이드라인
```

---

## 🚀 빠른 시작

### 1. 의존성 설치

```bash
git clone <repository-url>
cd s25016
npm install
```

### 2. 로컬 서버 실행

**방법 A: 정적 파일 서버 (간단)**
```bash
python3 -m http.server 8000
# http://localhost:8000 접속
```

**방법 B: Vercel 개발 서버 (API 포함)**
```bash
vercel dev
# http://localhost:3000 접속
```

**방법 C: Cloudinary 업로더 서버**
```bash
cd cloudinary-uploader
npm install
npm run server
# http://localhost:3000 접속
```

---

## 📡 API 엔드포인트

| 엔드포인트 | 메서드 | 설명 |
|------------|--------|------|
| `/api/upload` | POST | Cloudinary 파일 업로드 |
| `/api/files?folder=` | GET | 폴더별 파일 목록 조회 |
| `/api/folders` | GET | Cloudinary 폴더 목록 |
| `/api/punchlist` | GET/POST | 펀치리스트 CRUD |
| `/api/work-records` | GET/POST | 근태 기록 관리 |

### 사용 예시

```javascript
// 파일 업로드
const formData = new FormData();
formData.append('file', fileInput.files[0]);
formData.append('folder', 's25016/documents');

const response = await fetch('/api/upload', {
  method: 'POST',
  body: formData
});
```

---

## ⚙️ 환경 변수 설정

> ⚠️ **주의**: 실제 API 키는 절대 Git에 커밋하지 마세요!

### 로컬 개발

`cloudinary-uploader/.env` 파일 생성:

```env
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
CLOUDINARY_UPLOAD_FOLDER=s25016
```

### Vercel 배포

Vercel Dashboard → Project Settings → Environment Variables에서 설정

---

## 🌐 배포

### Vercel 자동 배포

```bash
# 프로덕션 배포
vercel --prod

# 프리뷰 배포
vercel
```

GitHub `master` 브랜치 푸시 시 자동 배포됩니다.

### 주요 라우트

| URL | 페이지 |
|-----|--------|
| `/` | 메인 대시보드 |
| `/hexagon` | Hexagon 측정 |
| `/devicenet` | DeviceNet 신호 테이블 |
| `/punchlist` | 펀치리스트 |
| `/cloudinary` | 파일 업로더 |
| `/robot-dashboard` | 로봇 대시보드 |

---

## 🔧 유틸리티 스크립트

### Cloudinary CLI 업로더

```bash
cd cloudinary-uploader

# 디렉토리 업로드
node uploader.js ./images --folder=s25016/photos

# 특정 확장자만
node uploader.js ./files --ext=.pdf,.html

# 결과 저장
node uploader.js ./docs --save=results.json
```

### RAPID 코드 검증

```bash
cd RAPID/scripts

# 전체 검증
python3 validate_and_fix_rapid.py .

# 자동 수정
python3 validate_and_fix_rapid.py --fix ../SpGantry_*/

# 버전 확인
python3 check_version.py
```

### 이벤트 로그 분석

```bash
cd B_Line_EventMessage

# 로그 통계
python3 log_analyzer.py

# 알람 분석
python3 alarm_analyzer.py
```

---

## 🔍 트러블슈팅

### 자주 발생하는 문제와 해결 방법

#### 1. Cloudinary 업로드 실패

**증상**: 파일 업로드 시 401 Unauthorized 오류

**해결**:
```bash
# .env 파일 확인
cd cloudinary-uploader
cat .env

# 환경 변수가 올바른지 확인
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
```

#### 2. RAPID 인코딩 오류

**증상**: RobotStudio에서 한글이 깨지거나 로드 실패

**해결**:
```bash
cd RAPID/scripts

# 인코딩 검증 및 자동 수정
python3 validate_and_fix_rapid.py --fix ../SpGantry_*/

# 결과 확인
python3 check_version.py
```

#### 3. Vercel 배포 실패

**증상**: `vercel --prod` 실행 시 빌드 오류

**해결**:
```bash
# vercel.json 설정 확인
cat vercel.json

# Node.js 버전 확인 (18.x 이상 필요)
node --version

# 로컬에서 먼저 테스트
vercel dev
```

#### 4. 로컬 서버 포트 충돌

**증상**: `Address already in use` 오류

**해결**:
```bash
# 포트 사용 중인 프로세스 확인
lsof -i :8000
lsof -i :3000

# 프로세스 종료
kill -9 <PID>

# 또는 다른 포트 사용
python3 -m http.server 8080
```

#### 5. Git 인코딩 문제

**증상**: 한글 파일명이 깨져서 표시됨

**해결**:
```bash
# Git 설정 변경
git config core.quotepath false

# 확인
git status
```

---

## 📚 문서

| 문서 | 설명 |
|------|------|
| [AGENTS.md](AGENTS.md) | 개발 가이드라인, 코드 스타일 |
| [VERCEL_DEPLOYMENT.md](VERCEL_DEPLOYMENT.md) | Vercel 배포 가이드 |
| [cloudinary-uploader/README.md](cloudinary-uploader/README.md) | CLI 업로더 사용법 |
| [punchlist/README.md](punchlist/README.md) | 펀치리스트 시스템 |
| [B_Line_EventMessage/README.md](B_Line_EventMessage/README.md) | 로그 분석 도구 |
| [RAPID/VERSION_POLICY.md](RAPID/VERSION_POLICY.md) | RAPID 버전 정책 |

---

## 👤 담당자

| 항목 | 정보 |
|------|------|
| **프로젝트** | S25016 |
| **담당자** | SP 심태양 |
| **위치** | 34bay 자동용접 A라인/B라인 |

---

## 📄 라이선스

MIT License

---

<p align="center">
  <sub>Built with ❤️ for manufacturing automation</sub>
</p>

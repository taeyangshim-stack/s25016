# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**S25016 프로젝트 통합 대시보드** - 로봇 시스템 개발, DeviceNet 통신, 정밀 측정 솔루션

주요 영역:
1. **DeviceNet 통신**: Lincoln Electric Power Wave 용접기 인터페이스 (158개 신호)
2. **로봇 상하축 이슈**: 갠트리 로봇 간섭 문제 해결
3. **Hexagon 측정**: 로봇 정밀도 검증
4. **Punchlist**: 작업 항목 관리 시스템
5. **Cloudinary 업로더**: 파일 관리 시스템

## Common Commands

```bash
# 로컬 정적 서버 (포트 8000)
python3 -m http.server 8000

# Cloudinary 업로더 로컬 서버 (포트 3000)
cd cloudinary-uploader && npm install && npm run server

# Vercel 개발 서버
npm install && vercel dev

# Vercel 배포
vercel --prod
```

## Architecture

### 디렉토리 구조

```
s25016/
├── api/                          # Vercel 서버리스 함수
│   ├── upload.js                 # Cloudinary 업로드
│   ├── files.js                  # 파일 목록 조회
│   ├── folders.js                # 폴더 목록 조회
│   ├── punchlist.js              # Punchlist CRUD
│   └── work-records.js           # 작업기록 관리
├── projects/                     # 프로젝트별 모듈
│   ├── hexagon/                  # Hexagon 측정 대시보드
│   ├── work-management/          # 작업관리 시스템
│   ├── devicenet/                # DeviceNet 문서
│   └── robot-backup/             # 로봇 백업 비교
├── punchlist/                    # Punchlist 앱 (Google Sheets 연동)
├── cloudinary-uploader/          # 파일 업로더
├── 250917_상하축이슈/            # 로봇 상하축 프로젝트 (레거시)
│   ├── 01_문제점분석/
│   ├── 02_대책수립/
│   ├── 03_일정관리/
│   ├── 04_작업진행/
│   ├── 05_문서자료/
│   └── 99_공유폴더/              # 대용량 파일, 공유 자료
├── 251003_용접기_디바이스넷/     # DeviceNet 원본 문서
├── shared/                       # 공유 CSS/JS 모듈
├── RAPID/                        # ABB RAPID 코드 분석
└── index.html                    # 메인 대시보드
```

### URL 라우팅 (Vercel)

| 경로 | 대상 |
|------|------|
| `/` | 메인 대시보드 |
| `/hexagon` | Hexagon 측정 |
| `/devicenet` | DeviceNet 신호 테이블 |
| `/punchlist` | Punchlist 관리 |
| `/cloudinary` | 파일 업로더 |
| `/robot-dashboard` | 로봇 이슈 대시보드 |
| `/planc` | Plan C RAPID 분석 |

### 기술 스택

- **프론트엔드**: Vanilla HTML/CSS/JS, Chart.js
- **백엔드**: Vercel Serverless Functions (Node.js)
- **외부 서비스**: Cloudinary (파일), Google Sheets (Punchlist 데이터)
- **배포**: Vercel (master 브랜치 자동 배포)

## Development Workflow

### 문서/대시보드 수정
1. HTML 파일 직접 편집
2. `python3 -m http.server 8000`으로 로컬 확인
3. Git 커밋 후 푸시 → Vercel 자동 배포

### 파일명 규칙
- 문서: `YYMMDD_작성자_제목.확장자`
- 한글 디렉토리명 유지 (링크 호환성)

### 커밋 메시지
```
feat(scope): 새로운 기능
fix(scope): 버그 수정
docs(scope): 문서 수정
```

## Important Notes

- HTML 파일은 standalone (외부 의존성 최소화)
- 모든 문서는 UTF-8 인코딩
- `99_공유폴더/`에 대용량 파일 저장
- 환경 변수는 Vercel Dashboard에서 설정 (CLOUDINARY_* 등)
- `AGENTS.md` 참조: 상세 코딩 스타일 및 테스트 가이드라인

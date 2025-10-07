# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**S25016 프로젝트 통합 대시보드** - 로봇 시스템 개발, DeviceNet 통신, 정밀 측정 솔루션

이 프로젝트는 다음 3개의 주요 영역을 통합 관리합니다:

1. **DeviceNet 통신**: Lincoln Electric Power Wave 용접기 DeviceNet 인터페이스 (158개 신호)
2. **로봇 상하축 이슈**: 갠트리 로봇 간섭 문제 해결 (시운전 단계 긴급 대응)
3. **Hexagon 측정**: 로봇 정밀도 검증 프로젝트

## Project Structure

```
s25016/
├── index.html                    # 통합 대시보드 (메인)
├── 상하축이슈_대시보드.html        # 로봇 이슈 전용 대시보드
├── 250917_상하축이슈/            # 로봇 상하축 프로젝트
│   ├── 01_문제점분석/
│   ├── 02_대책수립/
│   ├── 03_일정관리/
│   ├── 04_작업진행/              # ROBOT↔UI 테스트 결과
│   ├── 05_문서자료/
│   └── 99_공유폴더/
├── 251003_용접기_디바이스넷/      # DeviceNet 문서
│   ├── DeviceNet_Signals_Table.html
│   └── Y50031_DeviceNetInterfaceSpecification-21.pdf
├── 251004_에러핸들링/             # 에러 처리 자료
├── hexagon/                      # Hexagon 측정 프로젝트
│   ├── index.html
│   ├── robot-accuracy.html
│   ├── schedule.html
│   └── punchlist.html
├── AGENTS.md                     # 개발 가이드라인
└── vercel.json                   # Vercel 배포 설정
```

## Common Commands

### 로컬 개발 서버 실행
```bash
# 간단한 HTTP 서버 (포트 8000)
python3 -m http.server 8000

# 또는
python -m http.server 8000
```

브라우저에서 http://localhost:8000 접속

### Git 작업
```bash
# 변경사항 확인
git status
git diff

# 커밋
git add .
git commit -m "feat: 설명"

# 푸시
git push origin master
```

## Key Documents

### ROBOT↔UI 테스트
- **통합 결과**: `250917_상하축이슈/04_작업진행/251004_에이전트_ROBOT-UI_테스트_통합결과.html`
- **고객 발송**: `250917_상하축이슈/04_작업진행/251004_고객발송_테스트결과.html`
- **메신저 보고**: `250917_상하축이슈/04_작업진행/251004_테스트결과_메신저보고.txt`

### 최근 테스트 현황 (2024.10.03-10.04)
- 총 31개 항목
- ✅ 완료: 13개
- ⚠️ 개선 필요: 11개
- ⏸️ 보류: 7개
- 📅 다음 일정: 2024.10.11 (UI 개선 및 에러 핸들링)

### DeviceNet
- **신호 테이블**: `251003_용접기_디바이스넷/DeviceNet_Signals_Table.html`
- **원본 사양서**: `251003_용접기_디바이스넷/Y50031_DeviceNetInterfaceSpecification-21.pdf` (76 pages)

## Development Workflow

### 문서 수정 시
1. 해당 HTML 파일 직접 편집
2. 브라우저에서 http://localhost:8000 으로 확인
3. Git 커밋 및 푸시
4. Vercel 자동 배포 (master 브랜치)

### 테스트 결과 업데이트 시
1. 기존 파일 백업 (타임스탬프 포함)
2. HTML 테이블 업데이트
3. 통계 수치 업데이트
4. 대시보드 타임라인 업데이트

### 커밋 메시지 규칙
- `feat:` - 새로운 기능 추가
- `fix:` - 버그 수정
- `docs:` - 문서 수정
- `style:` - 코드 포맷팅
- `refactor:` - 리팩토링
- `test:` - 테스트 추가

## Deployment

**Vercel 자동 배포**
- URL: https://s25016.vercel.app (예시)
- 트리거: master 브랜치 푸시 시 자동 배포
- 설정: vercel.json

## Important Notes

- 파일명 규칙: `YYMMDD_작성자_제목.확장자`
- 수정 시 원본 백업 필수
- HTML 파일은 standalone (외부 의존성 최소화)
- 모든 문서는 UTF-8 인코딩
- 향후 일정은 "예정", "검토 중" 등 유연한 표현 사용

## Contact

- 담당: SP 심태양
- 프로젝트: S25016
- 위치: 34bay 자동용접 A라인/B라인

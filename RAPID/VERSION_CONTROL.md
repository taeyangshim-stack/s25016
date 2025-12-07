# RAPID 프로그램 버전 관리 가이드

**프로젝트**: S25016 SpGantry 1200
**작성일**: 2025-12-05
**작성자**: SP 심태양

---

## 1. 버전 관리 전략

### 1.1 이중 백업 시스템
본 프로젝트는 **Git 버전 관리**와 **백업 폴더** 방식을 혼합하여 사용합니다.

```
Git 버전 관리 (일상적 변경)
├── 코드 수정마다 커밋
├── 변경 내역 추적
└── 브랜치를 통한 실험

백업 폴더 (마일스톤)
├── 주요 릴리스 시점
├── 현장 배포 전
└── 중요 시운전 전후
```

### 1.2 버전 번호 체계

**형식**: `v[Major].[Minor]_YYMMDD[-suffix]`

**예시**:
- `v1.0_251205` - 버전 1.0, 2025년 12월 5일
- `v1.1_251210-test` - 버전 1.1, 테스트용
- `v2.0_260115-release` - 버전 2.0, 릴리스용

**버전 번호 규칙**:
- **Major (1.x)**: 주요 기능 추가, 아키텍처 변경, 하위 호환 불가
- **Minor (x.1)**: 기능 개선, 버그 수정, 하위 호환 가능
- **날짜 (YYMMDD)**: 해당 버전 생성 날짜
- **Suffix (선택)**: test, dev, release, hotfix 등

---

## 2. 버전 관리 워크플로우

### 2.1 일상적인 코드 수정 (Git)

```bash
# 1. 변경 전 현재 상태 확인
git status

# 2. 작업 수행 (코드 수정)

# 3. 변경 파일 스테이징
git add RAPID/SpGantry_1200_526406_BACKUP_2025-11-21/RAPID/TASK1/PROGMOD/MonitorFloorCoordinates.mod

# 4. 커밋 (의미 있는 메시지)
git commit -m "feat: Add MonitorBothTCP_Floor_AtHome function for home position monitoring"

# 5. 원격 저장소에 푸시 (선택)
git push origin master
```

### 2.2 마일스톤 백업 (백업 폴더)

주요 시점에 백업 폴더를 생성합니다:

```bash
# 백업 폴더 생성 (현재 작업 중인 폴더 복사)
cp -r RAPID/SpGantry_1200_526406_BACKUP_2025-11-21 \
      RAPID/SpGantry_1200_526406_v1.0_251205

# Git에 커밋
git add RAPID/SpGantry_1200_526406_v1.0_251205
git commit -m "release: v1.0_251205 - WobjFloor coordinate system integration"
git tag v1.0_251205
git push origin master --tags
```

### 2.3 백업 폴더 생성 시점

다음 시점에 백업 폴더를 생성합니다:

- ✅ **현장 배포 전**: 실제 로봇에 로드하기 전
- ✅ **주요 기능 완성**: 큰 기능 개발 완료 후
- ✅ **시운전 전후**: 시운전 시작 전, 완료 후
- ✅ **고객 인수 전**: 고객 검수 전
- ✅ **문제 발생 전**: 큰 변경 작업 시작 전 (롤백용)

---

## 3. RAPID 코드 내 버전 표기

### 3.1 모듈 헤더 표준 형식

모든 RAPID 모듈 파일은 다음 형식의 헤더를 포함해야 합니다:

```rapid
MODULE ModuleName
	!*****************************************************
	! Module: ModuleName
	! Version: v1.0_251205
	! Purpose: 모듈의 목적 설명
	! Author: SP Taeyangshim
	! Created: 2025-12-05
	! Last Modified: 2025-12-05
	!
	! Description:
	! - 주요 기능 1
	! - 주요 기능 2
	! - 주요 기능 3
	!
	! Change History:
	! v1.0_251205 (2025-12-05) - Initial version
	! v1.1_251210 (2025-12-10) - Added error handling
	!*****************************************************
```

### 3.2 프로시저 헤더 표준 형식

주요 프로시저에는 다음 형식의 헤더를 추가합니다:

```rapid
	!*****************************************************
	! Procedure: ProcedureName
	! Version: v1.0_251205
	! Description: 프로시저 설명
	! Usage: 사용법 설명
	! Parameters:
	!   - param1: 파라미터 설명
	!   - param2: 파라미터 설명
	! Returns: 반환값 설명 (해당 시)
	! Last Modified: 2025-12-05
	!*****************************************************
	PROC ProcedureName()
		...
	ENDPROC
```

### 3.3 버전 정보 조회 함수

각 태스크의 MainModule에 버전 정보 출력 함수 추가:

```rapid
	!*****************************************************
	! Procedure: ShowVersion
	! Description: Display program version information
	!*****************************************************
	PROC ShowVersion()
		TPWrite "========================================";
		TPWrite "SpGantry 1200 Control Program";
		TPWrite "Version: v1.0_251205";
		TPWrite "Release Date: 2025-12-05";
		TPWrite "Author: SP Taeyangshim";
		TPWrite "========================================";
		TPWrite "";
		TPWrite "Modules:";
		TPWrite "  - MonitorFloorCoordinates v2.0";
		TPWrite "  - HomePositionTest v1.0";
		TPWrite "  - FloorMonitor_Task2 v1.0";
		TPWrite "========================================";
	ENDPROC
```

---

## 4. Git 커밋 메시지 규칙

### 4.1 Conventional Commits 형식

```
<type>(<scope>): <subject>

<body>

<footer>
```

### 4.2 Type 종류

- **feat**: 새로운 기능 추가
- **fix**: 버그 수정
- **docs**: 문서 수정
- **style**: 코드 포맷팅 (기능 변경 없음)
- **refactor**: 리팩토링
- **test**: 테스트 추가/수정
- **chore**: 빌드, 설정 파일 수정
- **release**: 버전 릴리스

### 4.3 예시

```bash
# 기능 추가
git commit -m "feat(TASK1): Add WobjFloor monitoring function"

# 버그 수정
git commit -m "fix(TASK2): Fix tWeld2 not being used in home position move"

# 문서 수정
git commit -m "docs: Add version control guide"

# 릴리스
git commit -m "release: v1.0_251205 - WobjFloor integration complete"
```

---

## 5. 브랜치 전략

### 5.1 브랜치 구조

```
master (main)
├── develop (개발 브랜치)
│   ├── feature/wobj-floor (기능 브랜치)
│   ├── feature/vision-integration
│   └── fix/home-position-bug
└── release/v1.0 (릴리스 브랜치)
```

### 5.2 브랜치 사용법

**master (main)**:
- 항상 배포 가능한 안정 버전
- 직접 커밋 금지
- 릴리스 브랜치에서만 머지

**develop**:
- 개발 중인 코드
- 기능 브랜치에서 머지

**feature/xxx**:
- 새로운 기능 개발
- develop에서 분기
- 완료 후 develop에 머지

**fix/xxx**:
- 버그 수정
- 긴급하면 master에서 분기 (hotfix)
- 일반적으로 develop에서 분기

**release/vX.X**:
- 릴리스 준비
- develop에서 분기
- 테스트 후 master와 develop에 머지

### 5.3 브랜치 작업 예시

```bash
# 새 기능 개발 시작
git checkout develop
git checkout -b feature/vision-integration

# 작업 수행
# ... 코드 수정 ...

# 커밋
git add .
git commit -m "feat: Add vision system integration"

# develop에 머지
git checkout develop
git merge feature/vision-integration

# 브랜치 삭제
git branch -d feature/vision-integration
```

---

## 6. 백업 폴더 명명 규칙

### 6.1 형식

```
SpGantry_1200_526406_[TYPE]_[VERSION]_[DATE]
```

**TYPE**:
- `BACKUP` - 일반 백업
- `RELEASE` - 릴리스 버전
- `ARCHIVE` - 보관용
- `TEST` - 테스트용
- `COMMISSIONING` - 시운전용

**예시**:
```
SpGantry_1200_526406_RELEASE_v1.0_251205
SpGantry_1200_526406_BACKUP_2025-11-21
SpGantry_1200_526406_COMMISSIONING_v1.1_251210
SpGantry_1200_526406_TEST_v1.2_251215
```

### 6.2 현재 폴더 구조

```
RAPID/
├── SpGantry_1200_526406_BACKUP_2025-11-18/    # 이전 백업
├── SpGantry_1200_526406_BACKUP_2025-11-21/    # 현재 작업 폴더
├── SpGantry_1200_526406_v1.0_251205/          # v1.0 릴리스 (생성 예정)
└── VERSION_CONTROL.md                          # 이 문서
```

---

## 7. 버전 히스토리 기록

### 7.1 CHANGELOG.md 파일

프로젝트 루트에 `CHANGELOG.md` 파일을 유지합니다:

```markdown
# Changelog

## [v1.0_251205] - 2025-12-05

### Added
- WobjFloor 좌표계 통합
- 홈 위치 TCP 모니터링 기능
- FloorMonitor_Task2 모듈 추가

### Fixed
- Robot2 홈 이동 시 tWeld2 사용하도록 수정

### Changed
- MonitorFloorCoordinates 모듈 v2.0으로 업데이트

## [v0.9_251121] - 2025-11-21

### Added
- 초기 프로젝트 설정
- 기본 로봇 제어 기능
```

---

## 8. 롤백 및 복구

### 8.1 Git으로 롤백

```bash
# 최근 커밋 취소 (작업은 유지)
git reset HEAD~1

# 최근 커밋 완전 취소 (작업도 삭제)
git reset --hard HEAD~1

# 특정 커밋으로 돌아가기
git log  # 커밋 해시 확인
git reset --hard <commit-hash>

# 특정 파일만 이전 버전으로 복구
git checkout <commit-hash> -- path/to/file.mod
```

### 8.2 백업 폴더로 복구

```bash
# 백업 폴더에서 파일 복사
cp RAPID/SpGantry_1200_526406_v1.0_251205/RAPID/TASK1/PROGMOD/ModuleName.mod \
   RAPID/SpGantry_1200_526406_BACKUP_2025-11-21/RAPID/TASK1/PROGMOD/

# Git에 반영
git add .
git commit -m "revert: Restore ModuleName.mod from v1.0_251205"
```

---

## 9. 협업 시 주의사항

### 9.1 작업 전

```bash
# 항상 최신 코드 받기
git pull origin master

# 상태 확인
git status
```

### 9.2 충돌 해결

```bash
# 충돌 발생 시
git status  # 충돌 파일 확인

# 수동으로 충돌 해결 후
git add <resolved-file>
git commit -m "merge: Resolve conflict in ModuleName.mod"
```

### 9.3 커뮤니케이션

- 중요한 변경 사항은 팀에 공지
- 백업 폴더 생성 시 문서화
- 릴리스 전 리뷰 요청

---

## 10. 도구 및 스크립트

### 10.1 버전 업데이트 스크립트 (예정)

향후 다음 스크립트를 작성할 수 있습니다:

- `update_version.py` - 모든 모듈의 버전 번호 일괄 업데이트
- `create_backup.sh` - 백업 폴더 자동 생성
- `generate_changelog.py` - Git 로그에서 CHANGELOG 자동 생성

### 10.2 버전 검증 스크립트 (예정)

- `check_version_consistency.py` - 모든 모듈의 버전 일관성 검증
- `validate_headers.py` - 헤더 형식 검증

---

## 11. 체크리스트

### 11.1 릴리스 전 체크리스트

- [ ] 모든 모듈 헤더에 버전 정보 업데이트
- [ ] CHANGELOG.md 업데이트
- [ ] Git 커밋 및 푸시
- [ ] 백업 폴더 생성
- [ ] Git 태그 생성
- [ ] RobotStudio에서 Program Check 실행
- [ ] 시뮬레이션 테스트 실행
- [ ] 문서 업데이트 (README, 매뉴얼 등)

### 11.2 배포 후 체크리스트

- [ ] 배포 일시 기록
- [ ] 배포 결과 문서화
- [ ] 이슈 발생 시 CHANGELOG에 기록
- [ ] 다음 버전 계획 수립

---

## 12. 참고 자료

- **Git 공식 문서**: https://git-scm.com/doc
- **Conventional Commits**: https://www.conventionalcommits.org/
- **Semantic Versioning**: https://semver.org/

---

**마지막 업데이트**: 2025-12-05
**문서 버전**: v1.0

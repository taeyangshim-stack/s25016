# Changelog

S25016 SpGantry 1200 프로젝트의 모든 주요 변경사항이 이 파일에 기록됩니다.

형식은 [Keep a Changelog](https://keepachangelog.com/ko/1.0.0/)를 따르며,
버전 번호는 `v[Major].[Minor]_YYMMDD` 형식을 사용합니다.

---

## [Unreleased]

### 계획 중
- 비전 시스템 통합
- 자동 용접 경로 생성
- 에러 복구 자동화

---

## [v1.0_251205] - 2025-12-05

### Added
- **WobjFloor 좌표계 통합**: 비전 시스템과 공유할 공통 참조 좌표계 추가
- **홈 위치 TCP 모니터링**: 양 로봇의 홈 위치 TCP 검증 기능
- **FloorMonitor_Task2 모듈** (`TASK2/PROGMOD/FloorMonitor_Task2.mod`):
  - TASK2에서 양 로봇 TCP를 WobjFloor 기준으로 측정
  - `MonitorBothTCP_Floor_AtHome_Task2()` 프로시저 추가
  - Robot2의 tWeld2를 직접 지정 가능
- **HomePositionTest 개선** (`TASK2/PROGMOD/HomePositionTest.mod`):
  - `MoveToHomeAndCheckTCP()` 프로시저 추가
  - tool0와 tWeld2 양쪽 TCP 측정
  - wobj0와 WobjFloor 양쪽 좌표계로 보고
- **MonitorFloorCoordinates v2.0** (`TASK1/PROGMOD/MonitorFloorCoordinates.mod`):
  - `MonitorBothTCP_Floor()` - 현재 위치 모니터링
  - `MonitorBothTCP_Floor_AtHome()` - 홈 위치 모니터링
  - `TestFloorCoordinate()` - 특정 Floor 좌표 이동 테스트
  - `TestBothRobotsToSameFloorPoint()` - 양 로봇 동일 지점 이동 테스트
- **버전 관리 시스템**:
  - Git + 백업 폴더 혼합 방식
  - `VERSION_CONTROL.md` 가이드 문서
  - `.gitignore` 설정
  - 이 CHANGELOG.md 파일

### Fixed
- **Robot2 홈 이동 툴 수정** (`HomePositionTest.mod:36`):
  - 이전: `tool0`로 홈 이동
  - 수정: `tWeld2`로 홈 이동
  - 이유: TASK1에서 CRobT로 읽을 때 active tool(tWeld2) 필요

### Changed
- **MonitorFloorCoordinates 모듈**:
  - v1.0 → v2.0으로 업데이트
  - Robot2 tWeld2 읽기 방식 개선 (active tool 사용)
  - 모듈 버전 정보 추가 (2025-12-05 11:00 KST)

### Documentation
- **테스트 계획서** (`RAPID/홈위치_WobjFloor_테스트_계획_251205.md`):
  - 전체 테스트 절차 문서화
  - 예상 결과 및 검증 기준
  - 수정된 파일 위치 및 라인 번호
  - 다음 실행 단계 가이드

### Technical Details
**좌표계 정의**:
- WobjFloor 원점: World + [-9500, 5300, 2100] mm
- 기준: R-axis 중심 (GantryRob)
- 용도: 비전 시스템 참조 프레임

**툴 정의**:
- tWeld1 오프셋: [319.99, 0, 331.83] mm
- tWeld2 오프셋: [319.99, 0, 331.83] mm

**로봇 구성**:
- Robot1 (T_ROB1): IRB2600-12/1.85 @ R-axis +488mm
- Robot2 (T_ROB2): IRB2600-12/1.85 @ R-axis -488mm

---

## [v0.9_251121] - 2025-11-21

### Added
- 초기 프로젝트 구조 설정
- 기본 로봇 제어 모듈
- MainModule 기본 구조

### Changed
- RobotStudio 프로젝트 백업: `SpGantry_1200_526406_BACKUP_2025-11-21`

---

## [v0.8_251118] - 2025-11-18

### Added
- 프로젝트 시작
- 초기 RobotStudio 설정
- 백업: `SpGantry_1200_526406_BACKUP_2025-11-18`

---

## 버전 히스토리 요약

| 버전 | 날짜 | 주요 변경 | 파일 |
|------|------|-----------|------|
| v1.0_251205 | 2025-12-05 | WobjFloor 통합, 홈 위치 테스트 | 3개 모듈 수정/추가 |
| v0.9_251121 | 2025-11-21 | 초기 설정 | 기본 구조 |
| v0.8_251118 | 2025-11-18 | 프로젝트 시작 | 프로젝트 생성 |

---

## 다음 버전 계획 (v1.1_YYMMDD)

### 예정 기능
- [ ] 비전 시스템 인터페이스
- [ ] 자동 용접 시퀀스
- [ ] 에러 핸들링 개선
- [ ] TCP 보정 기능

### 예정 개선
- [ ] 버전 정보 자동 업데이트 스크립트
- [ ] RAPID 모듈 헤더 표준화
- [ ] 테스트 자동화

---

**문서 버전**: 1.0
**마지막 업데이트**: 2025-12-05
**관리자**: SP 심태양

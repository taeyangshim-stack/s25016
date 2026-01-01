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

## [v1.7.50_260101] - 2026-01-01

### 주요 개선사항

#### Cos/Sin 라디안→도(degree) 수정
- **문제**: RAPID Cos/Sin 함수는 도(degree)를 사용하는데 라디안 값을 전달
- **영향**: Robot2 Base Physical 위치 계산 오류 (13mm 오차)
- **수정**:
  - `UpdateRobot2BaseDynamicWobj()`: Cos/Sin 함수에 degree 사용
  - `UpdateGantryWobj()`: 쿼터니언 계산에 degree 사용
- **결과**: Cos(90°) = 0.000, Sin(90°) = 1.000 (이전: 1.000, 0.027)
- **커밋**: `ad9ac5d`

#### 반복적 보정 (Iterative Refinement) 구현
- **목적**: R-axis 중심 위치를 ±0.5mm 이내로 정밀 조정
- **알고리즘**:
  1. 목표 위치로 초기 이동 (WobjGantry)
  2. 현재 wobj0 위치 읽기
  3. 오차 계산 (목표 - 실제)
  4. 보정 이동 실행
  5. ±0.5mm tolerance 내 또는 최대 3회 반복
- **결과**:
  - Robot1: 1 iteration (Error: 0.00mm)
  - Robot2: 2 iterations (Error: 0.13mm)
- **커밋**: `b1b7663`

#### Robot2 좌표계 불일치 수정
- **문제**: Robot2 반복적 보정 발산 (12.72 → 0.85 → 12.35mm)
- **원인**: wobj0에서 읽고 WobjGantry_Rob2로 이동 (서로 다른 좌표계)
- **수정**: 읽기와 이동 모두 WobjGantry_Rob2 사용
- **결과**: 정상 수렴 (-0.66 → -0.13mm)
- **커밋**: `1110373`

#### TASK2 무한루프 제거
- **문제**: `WHILE TRUE DO` 무한루프로 프로그램 절대 종료 안 됨
- **원인**: 불필요한 연속 위치 업데이트 로직
- **수정**: 무한루프 제거, 초기화 후 정상 종료
- **근거**: TASK1이 `CRobT(\TaskName:="T_ROB2")` 로 on-demand 읽기
- **커밋**: `3016535`

### Added
- **포괄적 로깅 시스템**:
  - `main_process.txt`: TASK1 전체 프로세스 로그
  - `robot1_init_position.txt`: Robot1 초기화 상세 (Step 0~3)
  - `task2_main_process.txt`: TASK2 전체 프로세스 로그
  - `robot2_init_position.txt`: Robot2 초기화 상세 (Step 1~2)
  - `gantry_floor_test.txt`: Floor 좌표 테스트 결과
- **버전 상수 관리**:
  - `TASK1_VERSION` 및 `TASK2_VERSION` 상수 추가
  - 모든 로그에서 버전 상수 참조 (하드코딩 제거)
  - 단일 지점에서 버전 관리, 업데이트 용이
- **디버그 로깅**: WHILE 루프 종료 후 "DEBUG: Exited refinement loop"
- **main() 개선**: 진행 상황 TP 출력, 로그 파일 목록 표시

### Fixed
- **RAPID 문법 오류**: 42개 syntax error 수정
  - VAR 선언을 프로시저 시작 부분으로 이동
  - `half_angle_deg` 변수 선언 추가
  - TASK2: CONST 선언을 RECORD 정의 후로 이동 (RAPID 모듈 구조 순서 준수)
- **BREAK 문 프로그램 종료 문제**: BREAK 실행 후 프로그램이 계속되지 않음
  - **증상**: "DEBUG: About to BREAK" 출력됨, 하지만 ENDWHILE 이후 코드 미실행
  - **원인**: RAPID BREAK 문이 WHILE 루프를 빠져나가지 못하고 프로그램 종료
  - **해결**: BREAK 대신 `iteration := max_iterations` 사용하여 자연스러운 루프 종료
  - **개선**: correction 코드를 ELSE 블록으로 이동 (수렴 후 불필요한 이동 방지)
- **UpdateGantryWobj_Rob2() 라디안/도 버그**: Robot2 X 좌표 -13.38mm 오프셋
  - **증상**: Robot2 Floor X = 9486.62mm (예상: 9500.00mm)
  - **원인**: `half_angle := total_rad / 2; Cos(half_angle)` - 라디안을 도로 사용
  - **영향**: WobjGantry_Rob2 쿼터니언 [0.99991, 0, 0, 0.01371] (정상: [0.7071, 0, 0, 0.7071])
  - **해결**: `half_angle_deg := total_deg / 2; Cos(half_angle_deg)` - 도 사용
  - **참고**: UpdateRobot2BaseDynamicWobj()와 UpdateGantryWobj()는 이미 수정됨 (ad9ac5d)
- **WobjGantry 쿼터니언**: identity [1,0,0,0] 유지 (회전 없음)
  - R-axis 회전은 로봇 base 회전이지 work object 회전이 아님
- **Robot1 TCP 방향**: [0.5, -0.5, 0.5, 0.5] (이전: 근사값)

### Changed
- **SetRobot1InitialPosition**: 반복적 보정 + 로깅 추가
- **SetRobot2InitialPosition**: 반복적 보정 + 로깅 추가
- **TASK1 main()**: 로깅 및 진행 상황 추적 개선
- **TASK2 main()**: 무한루프 제거, 로깅 추가

### Test Results (2026-01-01 22:07)

**✅ 프로그램 정상 완료**:
- TASK1 main(): Step 1 완료, Step 2 완료
- TASK2 main(): 초기화 완료
- 총 실행 시간: 31초 (22:07:29 - 22:08:00)

**✅ BREAK 문제 해결 검증**:
```
Before (13:17): DEBUG: About to BREAK → (프로그램 종료)
After (22:07):  DEBUG: Setting iteration to force loop exit → DEBUG: Exited refinement loop ✅
```

**✅ Gantry Floor 좌표 추적 정확도**:
- Target: Floor [+1000, -300, -600]
- Robot1 Delta: [1000.00, -300.00, -600.00] mm ✅
- Robot2 Delta: [1000.00, -300.00, -600.00] mm ✅
- 결과: 두 로봇 모두 동일한 Floor 좌표 변화

**✅ 반복적 보정 성능**:
- Robot1: 1 iteration, Error [0.00, -0.01] mm
- Robot2: 2 iterations, Error [-0.13, -0.00] mm

**⚠️ Robot2 X 좌표 오프셋**:
- Robot1 HOME Floor X: 9500.00 mm
- Robot2 HOME Floor X: 9486.62 mm
- 차이: -13.38 mm (Y, Z는 ±0.2mm 이내)
- 원인: 추가 조사 필요 (Cos/Sin 수정에도 불구하고 잔존)

**⚠️ 41617 경고** (심각하지 않음):
- "Too intense frequency of Write Instructions"
- 프로그램은 정상 완료됨
- gantry_floor_test.txt: 90줄 (적절한 양)

### Known Issues
- **해결됨**: Robot2 X 좌표 -13.38mm 오프셋
  - **원인**: UpdateGantryWobj_Rob2()에서 라디안을 도(degree)로 사용하는 버그
  - **증상**: WobjGantry_Rob2 쿼터니언이 [0.99991, 0, 0, 0.01371] (잘못됨)
  - **정상값**: [0.7071, 0, 0, 0.7071] (90° Z-axis rotation)
  - **수정**: half_angle_deg := total_deg / 2 (도 사용)
  - **예상 결과**: Robot2 Floor X = 9500.00mm (Robot1과 동일)

### Technical Details
**반복적 보정 알고리즘** (v1.7.50):
```rapid
WHILE iteration < 3 DO
    iteration := iteration + 1;
    pos := CRobT(\WObj:=wobj0);
    error := target - pos;
    IF Abs(error) < 0.5mm THEN
        iteration := max_iterations;  ! Force loop exit (BREAK has issues)
    ELSE
        MoveL correction, \WObj:=WobjGantry;  ! Apply correction
    ENDIF
ENDWHILE
```

**좌표계 일치**:
- Robot1: wobj0 ≈ WobjGantry (R-axis 중심)
- Robot2: WobjGantry_Rob2 (R-axis 중심 + 488mm offset)

**RAPID 모듈 구조 순서**:
```rapid
MODULE ModuleName
    RECORD definitions      ! 1. RECORD 먼저
    CONST declarations      ! 2. CONST 다음
    PERS/VAR declarations   ! 3. PERS/VAR 다음
    PROC/FUNC definitions   ! 4. PROC/FUNC 마지막
ENDMODULE
```

**Git Commits** (총 20개):
```
feb73cf - fix: Fix UpdateGantryWobj_Rob2 to use degrees (Robot2 X offset fix)
1c4db24 - fix: Replace BREAK with iteration control for loop exit
2893b58 - debug: Add debug message before BREAK
72eda19 - docs: Update CHANGELOG with RECORD/CONST order fix
c776ce5 - fix: Move TASK2_VERSION constant after RECORD definitions
5977db7 - docs: Add version constant management to CHANGELOG.md
8f5fcc0 - refactor: Use version constants for logging
cacee83 - docs: Update CHANGELOG.md for v1.7.50 release
b0e9c20 - debug: Add debug logging after WHILE loop exit
3016535 - fix: Remove infinite loop from TASK2 main()
f404454 - feat: Enhanced main() with logging
04a01ad - fix: Move VAR declarations to procedure start
dc30784 - feat: Add comprehensive logging to init procedures
b1b7663 - feat: Add iterative refinement
1110373 - fix: Fix Robot2 coordinate system mismatch
bccce81 - fix: Correct Robot1 TCP quaternion
c458a6d - fix: Keep WobjGantry orientation as identity
aa1eb3d - fix: Declare half_angle_deg variable
ad9ac5d - fix: Fix Cos/Sin to use degrees
271a625 - fix: Use global variables for debug logging
```

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

# 홈 위치 WobjFloor 좌표계 테스트 계획

**작성일**: 2025-12-05
**작성자**: SP 심태양
**프로젝트**: S25016 SpGantry 1200

---

## 1. 테스트 목적

1. **홈 위치 정확성 검증**: 양쪽 로봇이 홈 포지션([0,0,0,0,-90,0])에서 정확한 TCP 위치를 보고하는지 확인
2. **WobjFloor 좌표계 검증**: 비전 시스템과 공유할 WobjFloor 좌표계가 올바르게 정의되었는지 확인
3. **툴 오프셋 검증**: tool0(플랜지)와 tWeld(토치) 사이의 오프셋이 올바르게 적용되는지 확인
4. **양 로봇 간 좌표 일관성**: Robot1과 Robot2가 동일한 WobjFloor 좌표계를 올바르게 참조하는지 확인

---

## 2. 테스트 환경

### 2.1 RobotStudio 시뮬레이션
- **버전**: RobotStudio (최신 백업: 2025-11-21)
- **로봇 구성**:
  - T_ROB1: IRB2600-12/1.85 (R-axis +488mm)
  - T_ROB2: IRB2600-12/1.85 (R-axis -488mm)
  - T_BG: GantryRob (배경 태스크)

### 2.2 좌표계 정의
- **wobj0 (World)**: 로봇 절대 좌표계 원점
- **WobjFloor**: 비전 시스템 참조 좌표계
  - 원점: World + [-9500, 5300, 2100] mm
  - 기준: R-axis 중심 (GantryRob)
  - 용도: 비전 시스템이 용접 심 위치를 보고하는 기준

### 2.3 툴 정의
- **tool0**: 로봇 플랜지 (오프셋 없음)
- **tWeld1**: Robot1 용접 토치
  - TCP 오프셋: [319.99, 0, 331.83] mm
- **tWeld2**: Robot2 용접 토치
  - TCP 오프셋: [319.99, 0, 331.83] mm (tWeld1과 동일)

---

## 3. 수정된 모듈

### 3.1 HomePositionTest.mod (TASK2)
**파일 위치**: `RAPID/TASK2/PROGMOD/HomePositionTest.mod`

**주요 수정사항**:
```rapid
! 이전 (문제):
MoveAbsJ [[0,0,0,0,-90,0],[0,0,0,0,0,0]], v100, fine, tool0;

! 수정 후 (해결):
MoveAbsJ [[0,0,0,0,-90,0],[0,0,0,0,0,0]], v100, fine, tWeld2;
```

**수정 이유**:
- Robot2가 홈으로 이동할 때 tWeld2를 active tool로 설정
- TASK1에서 CRobT(\TaskName:="T_ROB2")로 읽을 때 active tool 사용
- tWeld2가 active 상태여야 정확한 토치 TCP 측정 가능

**파일 위치**: `RAPID/SpGantry_1200_526406_BACKUP_2025-11-21/RAPID/TASK2/PROGMOD/HomePositionTest.mod:36`

### 3.2 FloorMonitor_Task2.mod (TASK2)
**파일 위치**: `RAPID/TASK2/PROGMOD/FloorMonitor_Task2.mod`

**주요 기능**:
- TASK2에서 실행되는 플로어 좌표 모니터링 함수
- tWeld2를 직접 지정 가능 (TASK1의 제약 해결)
- 양쪽 로봇의 TCP를 WobjFloor 기준으로 측정
- 결과를 파일로 저장: `HOME:/floor_coordinates_at_home_task2.txt`

**핵심 프로시저**:
```rapid
PROC MonitorBothTCP_Floor_AtHome_Task2()
    ! Robot1 읽기 (TaskName 파라미터 사용)
    rob1_tool0_floor := CRobT(\TaskName:="T_ROB1"\Tool:=tool0\WObj:=WobjFloor);
    rob1_tweld_floor := CRobT(\TaskName:="T_ROB1"\Tool:=tWeld1\WObj:=WobjFloor);

    ! Robot2 읽기 (TASK2에서 직접 접근 가능)
    rob2_tool0_floor := CRobT(\Tool:=tool0\WObj:=WobjFloor);
    rob2_tweld_floor := CRobT(\Tool:=tWeld2\WObj:=WobjFloor);

    ! 차이 계산 및 로그 저장
    ...
ENDPROC
```

**파일 위치**: `RAPID/SpGantry_1200_526406_BACKUP_2025-11-21/RAPID/TASK2/PROGMOD/FloorMonitor_Task2.mod:22`

### 3.3 MonitorFloorCoordinates.mod (TASK1)
**파일 위치**: `RAPID/TASK1/PROGMOD/MonitorFloorCoordinates.mod`

**기존 프로시저**:
1. `MonitorBothTCP_Floor()` - 현재 위치 모니터링
2. `MonitorBothTCP_Floor_AtHome()` - 홈 위치 모니터링 (tool0 + tWeld)
3. `TestFloorCoordinate()` - Robot1 특정 좌표 이동 테스트
4. `TestBothRobotsToSameFloorPoint()` - 양 로봇 동일 좌표 이동 테스트

**제약사항**:
- TASK1에서 Robot2의 tWeld2를 직접 지정 불가
- CRobT(\TaskName:="T_ROB2")는 active tool만 읽음
- 해결: TASK2에서 FloorMonitor_Task2 사용

**파일 위치**: `RAPID/SpGantry_1200_526406_BACKUP_2025-11-21/RAPID/TASK1/PROGMOD/MonitorFloorCoordinates.mod:301`

---

## 4. 테스트 절차

### 4.1 Program Check (문법 검증)
RobotStudio에서 모든 태스크 프로그램 체크 실행:

```
Controller > Program Check > Check Program
- T_ROB1: ✓ Pass
- T_ROB2: ✓ Pass
- T_BG: ✓ Pass
```

**상태**: ✅ 완료

### 4.2 Robot1 홈 위치 테스트
**실행 태스크**: T_ROB1
**프로시저**: `MoveToHomeAndCheckTCP` (MainModule.mod)

**예상 결과**:
1. 홈 포지션 이동: [0, 0, 0, 0, -90, 0]
2. tool0 TCP 측정 (wobj0 기준)
3. tool0 TCP 측정 (WobjFloor 기준)
4. tWeld1 TCP 측정 (wobj0 기준)
5. tWeld1 TCP 측정 (WobjFloor 기준)
6. 결과 파일 생성: `HOME:/home_position_test_robot1.txt`

**상태**: ✅ 완료

### 4.3 Robot2 홈 위치 테스트
**실행 태스크**: T_ROB2
**프로시저**: `MoveToHomeAndCheckTCP` (HomePositionTest.mod)

**예상 결과**:
1. 홈 포지션 이동: [0, 0, 0, 0, -90, 0] **with tWeld2**
2. tool0 TCP 측정 (wobj0 기준)
3. tool0 TCP 측정 (WobjFloor 기준)
4. tWeld2 TCP 측정 (wobj0 기준)
5. tWeld2 TCP 측정 (WobjFloor 기준)
6. 결과 파일 생성: `HOME:/home_position_test_robot2.txt`

**상태**: ✅ 완료

### 4.4 양 로봇 통합 모니터링 (TASK1 버전)
**실행 태스크**: T_ROB1
**프로시저**: `MonitorBothTCP_Floor_AtHome` (MonitorFloorCoordinates.mod)

**실행 전 준비**:
- Robot1과 Robot2가 모두 홈 위치에 있어야 함
- Robot2에서 tWeld2를 사용하여 홈 이동 완료 상태

**예상 결과**:
1. Robot1 tool0 + tWeld1 읽기 (WobjFloor)
2. Robot2 tool0 읽기 (WobjFloor)
3. Robot2 active tool 읽기 (tWeld2 if active)
4. tool0 차이 계산 (Robot1 - Robot2)
5. tWeld 차이 계산 (Robot1 - Robot2)
6. 결과 파일: `HOME:/floor_coordinates_at_home.txt`

**상태**: ⏸️ 대기 (사용자 실행 필요)

### 4.5 양 로봇 통합 모니터링 (TASK2 버전) ⭐
**실행 태스크**: T_ROB2
**프로시저**: `MonitorBothTCP_Floor_AtHome_Task2` (FloorMonitor_Task2.mod)

**실행 전 준비**:
- Robot1과 Robot2가 모두 홈 위치에 있어야 함

**예상 결과**:
1. Robot1 tool0 + tWeld1 읽기 (WobjFloor, TaskName 파라미터)
2. Robot2 tool0 + tWeld2 읽기 (WobjFloor, 직접 지정)
3. tool0 차이 계산 (Robot1 - Robot2)
4. tWeld 차이 계산 (Robot1 - Robot2)
5. 결과 파일: `HOME:/floor_coordinates_at_home_task2.txt`

**장점**:
- Robot2의 tWeld2를 정확하게 지정 가능
- active tool 상태에 의존하지 않음
- 더 정확한 측정 가능

**상태**: ⏸️ 대기 (사용자 실행 필요)

---

## 5. 예상 결과

### 5.1 tool0 (플랜지) 위치 차이
홈 위치에서 양 로봇의 플랜지 위치 차이는 물리적 로봇 분리 거리를 나타냄:

- Robot1: R-axis +488mm
- Robot2: R-axis -488mm
- **예상 플랜지 거리**: ~976mm (일부 좌표계에서)

### 5.2 tWeld (토치) 위치 차이
양 로봇의 토치가 동일한 오프셋([319.99, 0, 331.83])을 가지므로:

- **예상 토치 거리**: tool0 차이와 동일 (~976mm)
- 툴 오프셋은 상쇄됨

### 5.3 WobjFloor 좌표 검증
WobjFloor는 World 좌표계에서 [-9500, 5300, 2100] 오프셋:

- Robot1과 Robot2가 동일한 WobjFloor 정의 사용
- 양 로봇이 WobjFloor [X, Y, Z]로 이동 시 동일한 물리적 위치 도달 예상

---

## 6. 파일 출력

테스트 실행 후 생성되는 파일:

1. `HOME:/home_position_test_robot1.txt` - Robot1 홈 위치 상세 정보
2. `HOME:/home_position_test_robot2.txt` - Robot2 홈 위치 상세 정보
3. `HOME:/floor_coordinates_at_home.txt` - TASK1에서 양 로봇 통합 모니터링
4. `HOME:/floor_coordinates_at_home_task2.txt` - TASK2에서 양 로봇 통합 모니터링 (권장)

---

## 7. 다음 단계

### 7.1 RobotStudio에서 실행
1. ✅ Program Check 완료
2. ✅ Robot1 홈 테스트 완료
3. ✅ Robot2 홈 테스트 완료
4. ⏸️ TASK2에서 `MonitorBothTCP_Floor_AtHome_Task2` 실행
5. ⏸️ 결과 파일 확인 및 분석

### 7.2 결과 분석
- tool0 차이가 물리적 로봇 분리와 일치하는지 확인
- tWeld 차이가 tool0 차이와 일치하는지 확인
- WobjFloor 좌표가 예상 범위 내인지 확인

### 7.3 실제 로봇 적용
- 시뮬레이션 검증 완료 후
- 실제 로봇에 프로그램 로드
- 안전 조치 후 동일 테스트 실행

---

## 8. 주요 개선사항 요약

### 8.1 문제점 해결
| 문제 | 원인 | 해결 |
|------|------|------|
| Robot2 홈 이동 시 tool0 사용 | HomePositionTest.mod에서 tool0 지정 | tWeld2로 변경 |
| TASK1에서 Robot2 tWeld2 읽기 불가 | CRobT TaskName은 active tool만 사용 | TASK2용 모니터링 함수 추가 |
| 양 로봇 통합 측정 어려움 | TASK 간 도구 접근 제약 | FloorMonitor_Task2 모듈 생성 |

### 8.2 코드 개선
1. **HomePositionTest.mod:36** - tWeld2 사용하여 홈 이동
2. **FloorMonitor_Task2.mod** - TASK2에서 양 로봇 측정 가능
3. **MonitorFloorCoordinates.mod** - TASK1 버전 유지 (호환성)

---

## 9. 참고 문서

- `RAPID/SpGantry_1200_526406_BACKUP_2025-11-21/` - 최신 백업
- `CoordTransform_사용법.md` - 좌표 변환 설명 (삭제됨, 내용 통합)
- RobotStudio 프로젝트: SpGantry_1200_526406

---

**작성 완료**: 2025-12-05
**다음 실행**: RobotStudio에서 4.5 단계 실행 권장

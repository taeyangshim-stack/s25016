# PlanB RAPID 개발 (v2.2.0)

> **버전**: v2.2.0 | **날짜**: 2026-02-03 | **상태**: 구현 완료

## 1. 개요

### 목표
상위시스템에서 Edge 4점(edgeStart/End) 수신 → 갠트리+로봇이 용접 위치로 자동 이동

### PlanA vs PlanB 비교

| 항목 | PlanA (참고) | PlanB (개발) |
|------|-------------|-------------|
| TASK 구조 | 3 TASK (Robot1, Robot2, Gantry) | 2 TASK (Robot1+Gantry, Robot2) |
| 갠트리 제어 | TASK7 별도 | TASK1 외부축 직접 제어 |
| 좌표 변환 | fnCoordToJoint() | FloorToPhysical() |
| 이동 명령 | MoveJgJ (MultiMove) | MoveAbsJ + extax |

---

## 2. 아키텍처

```
┌─────────────────────────────────────────────────────────────┐
│                    상위시스템 (PC SDK)                        │
│  nCmdInput=210 → Edge 4점 전송 → nCmdMatch 확인              │
└────────────────────────┬────────────────────────────────────┘
                         │
         ┌───────────────┴───────────────┐
         ▼                               ▼
┌─────────────────────┐       ┌─────────────────────┐
│     TASK1           │       │     TASK2           │
│  Robot1 + Gantry    │◄─────►│     Robot2          │
├─────────────────────┤  PERS ├─────────────────────┤
│ • CommandLoop()     │ 변수  │ • Robot2_CommandLoop│
│ • CalcCenterFromEdges│ 공유  │ • Robot2_WeldSequence│
│ • DefineWeldLine()  │       │ • Robot2_EdgeWeldSeq│
│ • FloorToPhysical() │       │                     │
│ • MoveGantryToWeld  │       │                     │
└─────────────────────┘       └─────────────────────┘
```

### 좌표계
- **Floor 좌표**: 작업장 바닥 기준 (mm)
  - HOME = [9500, 5300, 2100, 0]
- **Physical 좌표**: 갠트리 모터 위치 (mm, deg)
  - HOME = [0, 0, 0, 0]

### 변환 공식
```
Physical_X = HOME_GANTRY_X + (Floor_X - 9500)   // X: 덧셈
Physical_Y = HOME_GANTRY_Y - (Floor_Y - 5300)   // Y: 뺄셈 (반전)
Physical_Z = HOME_GANTRY_Z - (Floor_Z - 2100)   // Z: 뺄셈 (반전)
Physical_R = HOME_GANTRY_R - nAngleRzStore      // R: 뺄셈
```

---

## 3. 데이터 구조 (v2.2.0)

### RECORD 정의

#### edgedata - Edge 포인트 데이터
```rapid
RECORD edgedata
    pos EdgePos;           ! X, Y, Z coordinates (Floor)
    num Height;            ! Part edge height (mm)
    num Breadth;           ! Part edge width (mm)
    num HoleSize;          ! Reference hole diameter (mm)
    num Thickness;         ! Material thickness (mm)
    num AngleHeight;       ! Angle measurement point height (mm)
    num AngleWidth;        ! Angle measurement point width (mm)
ENDRECORD
```

#### targetdata - 용접 타겟 데이터
```rapid
RECORD targetdata
    robtarget position;    ! TCP position and orientation
    num cpm;               ! Arc current mode/preset
    num schedule;          ! Weld schedule number
    num voltage;           ! Arc voltage (V)
    num wfs;               ! Wire feed speed (m/min)
    num Current;           ! Weld current (A)
    num WeaveShape;        ! Weave pattern shape (0-5)
    num WeaveType;         ! Weave type (1-5)
    num WeaveLength;       ! Weave cycle length (mm)
    num WeaveWidth;        ! Weave width (mm)
    num WeaveDwellLeft;    ! Dwell time left side (s)
    num WeaveDwellRight;   ! Dwell time right side (s)
    num TrackType;         ! Seam tracking type (0-3)
    num TrackGainY;        ! Tracking Y gain
    num TrackGainZ;        ! Tracking Z gain
ENDRECORD
```

#### corrorder - 보정 데이터
```rapid
RECORD corrorder
    num X_StartOffset;     ! X offset before arc start (mm)
    num X_Depth;           ! X penetration depth (mm)
    num X_ReturnLength;    ! X return distance (mm)
    num Y_StartOffset;     ! Y offset (mm)
    num Y_Depth;           ! Y penetration depth (mm)
    num Y_ReturnLength;    ! Y return distance (mm)
    num Z_StartOffset;     ! Z offset (mm)
    num Z_Depth;           ! Z penetration depth (mm)
    num Z_ReturnLength;    ! Z return distance (mm)
    num RY_Torch;          ! Torch angle RY (deg)
ENDRECORD
```

### Edge 데이터 배열
```rapid
PERS edgedata edgeStart{2};  ! {1}=Robot1 side, {2}=Robot2 side
PERS edgedata edgeEnd{2};
```

---

## 4. 커맨드 인터페이스 (v2.1.0)

### 변수
```rapid
PERS num nCmdInput := 0;    ! 상위시스템 → 로봇 (명령 ID)
PERS num nCmdOutput := 0;   ! 로봇 → 상위시스템 (응답)
PERS num nCmdMatch := 0;    ! 핸드쉐이크 (1=OK, -1=NG, 0=대기)
```

### 핸드쉐이크 프로토콜
```
1. 상위시스템: nCmdInput = CMD_ID 설정
2. 로봇: nCmdOutput = CMD_ID 응답
3. 상위시스템: nCmdMatch = 1 (일치) 또는 -1 (불일치)
4. 로봇: 명령 실행
5. 로봇: bMotionFinish = TRUE
6. 상위시스템: nCmdInput = 0 (리셋)
```

### 커맨드 ID 테이블

| 시리즈 | ID | 상수명 | 설명 |
|--------|-----|--------|------|
| **100** | 101 | CMD_MOVE_TO_WORLDHOME | 월드 홈 이동 |
| | 102 | CMD_MOVE_TO_MEASUREMENTHOME | 측정 홈 이동 |
| | 105 | CMD_MOVE_TO_TEACHING_R1 | Robot1 티칭 위치 |
| | 106 | CMD_MOVE_TO_TEACHING_R2 | Robot2 티칭 위치 |
| | 108 | CMD_MOVE_ABS_GANTRY | 갠트리 절대좌표 이동 |
| | 109 | CMD_MOVE_INC_GANTRY | 갠트리 상대좌표 이동 |
| | 110 | CMD_MOVE_TO_ZHOME | Z축 홈 이동 |
| | 112 | CMD_MOVE_TO_WARMUP | 웜업 위치 이동 |
| **200** | 200 | CMD_WELD | 용접 실행 |
| | 201 | CMD_WELD_MOTION | 용접 모션만 (아크 없음) |
| | 202 | CMD_WELD_CORR | 용접 + 보정 |
| | 203 | CMD_WELD_MOTION_CORR | 모션 + 보정 |
| | 210 | **CMD_EDGE_WELD** | **Edge 기반 용접 (v2.0.0)** |
| **300** | 301 | CMD_CAMERA_DOOR_OPEN | 카메라 도어 열기 |
| | 302 | CMD_CAMERA_DOOR_CLOSE | 카메라 도어 닫기 |
| | 303 | CMD_CAMERA_BLOW_ON | 카메라 블로우 ON |
| | 304 | CMD_CAMERA_BLOW_OFF | 카메라 블로우 OFF |
| **500** | 501 | CMD_WIRE_CUT | 와이어 커팅 |
| | 502 | CMD_WIRE_CLEAN | 와이어 클리닝 |
| | 511 | CMD_ROB1_WIRE_CUT | Robot1 와이어 커팅 |
| | 512 | CMD_ROB2_WIRE_CUT | Robot2 와이어 커팅 |
| **600** | 601 | CMD_HOLE_CHECK | 홀 검사 |
| | 602 | CMD_LDS_CHECK | LDS 검사 |
| **900** | 900 | CMD_TEST_MENU | 테스트 메뉴 |
| | 901 | CMD_TEST_SINGLE | 단일 테스트 |
| | 902 | CMD_TEST_ROTATION | 회전 테스트 |
| | 903 | CMD_TEST_MODE2 | Mode2 테스트 |

---

## 5. 핵심 함수

### MainModule.mod (TASK1)

| 함수명 | 행 | 설명 |
|--------|-----|------|
| `CalcCenterFromEdges()` | 3206 | Edge 4점에서 중심선 계산 |
| `DefineWeldLine()` | 3238 | R축 각도 계산, bRobSwap 결정 |
| `FloorToPhysical()` | 3285 | Floor → Physical 좌표 변환 |
| `MoveGantryToWeldPosition()` | 3322 | 갠트리를 용접 위치로 이동 |
| `TestEdgeToWeld()` | 3383 | Edge → Weld 통합 테스트 |
| `rInit()` | 3433 | 커맨드 인터페이스 초기화 |
| `rCheckCmdMatch()` | 3457 | 커맨드 핸드쉐이크 확인 |
| `CommandLoop()` | 3473 | 메인 커맨드 처리 루프 |

### Rob2_MainModule.mod (TASK2)

| 함수명 | 행 | 설명 |
|--------|-----|------|
| `Robot2_WeldSequence()` | 3146 | Robot2 용접 시퀀스 |
| `Robot2_EdgeWeldSequence()` | 3175 | Robot2 Edge 기반 용접 |
| `Robot2_CommandLoop()` | 3239 | Robot2 커맨드 모니터링 |

---

## 6. 사용 방법

### Edge 기반 용접 실행

1. **상위시스템에서 Edge 포인트 설정**
```
EDGE_START1_X := 5000; EDGE_START1_Y := 5100; EDGE_START1_Z := 500;
EDGE_START2_X := 5000; EDGE_START2_Y := 4900; EDGE_START2_Z := 500;
EDGE_END1_X := 5500;   EDGE_END1_Y := 5100;   EDGE_END1_Z := 500;
EDGE_END2_X := 5500;   EDGE_END2_Y := 4900;   EDGE_END2_Z := 500;
```

2. **커맨드 전송**
```
nCmdInput := 210;  // CMD_EDGE_WELD
```

3. **핸드쉐이크 확인**
```
WaitUntil nCmdOutput = 210;
nCmdMatch := 1;
```

4. **완료 대기**
```
WaitUntil bMotionFinish = TRUE;
nCmdInput := 0;
```

### 테스트 실행 (로봇에서 직접)
```rapid
! TestEdgeToWeld 호출
TestEdgeToWeld;
```

---

## 7. 변경 이력

| 버전 | 날짜 | 내용 |
|------|------|------|
| v2.2.0 | 2026-02-03 | PlanA 데이터 구조 추가 (edgedata, targetdata, corrorder) |
| v2.1.0 | 2026-02-03 | PlanA 스타일 커맨드 인터페이스 (nCmdInput/nCmdOutput) |
| v2.0.0 | 2026-02-01 | Edge 기반 용접 시퀀스, Home/Limit 설정 |
| v1.9.x | 2026-01-xx | 용접 프레임워크 기본 구조 |

---

## 8. 수정된 파일 목록

| 파일 | 경로 | 버전 |
|------|------|------|
| ConfigModule.mod | `TASK1/PROGMOD/ConfigModule.mod` | v2.2.0 |
| MainModule.mod | `TASK1/PROGMOD/MainModule.mod` | v2.1.0 |
| Rob2_MainModule.mod | `TASK2/PROGMOD/Rob2_MainModule.mod` | v2.1.0 |

---

## 9. 참고 파일 (PlanA)

- `Head_Data.mod` - edgedata, Home/Limit 값
- `Head_Function.mod` - fnCoordToJoint, CalcNormalVector
- `Head_MoveControl.mod` - rDefineWobjWeldLine, rMoveStep
- `Head_MainModule.mod` - 커맨드 루프 구조

# PlanA vs PlanB 상위 시스템 인터페이스 변수 비교

**생성일**: 2026-02-06
**목적**: PlanA UI와 PlanB RAPID 코드 간의 변수 호환성 검증

---

## 1. 요약

| 항목 | PlanA Head_Data | PlanB ConfigModule | PlanB Head_Data (TASK4) |
|------|:---:|:---:|:---:|
| 총 PERS 변수 | ~180+ | ~112 | ~20 |
| RECORD 정의 | 7개 | 4개 | 4개 |
| CMD 상수 | 31개 | 31개 | 31개 |
| TASK PERS (welddata, weavedata, trackdata) | 120+ | 0 | 0 |

---

## 2. 핵심 인터페이스 변수 (상위 시스템 필수)

### 2.1 명령 인터페이스

| 변수명 | 타입 | PlanA | PlanB ConfigModule | PlanB Head_Data | 상태 |
|--------|------|:---:|:---:|:---:|:---:|
| nCmdInput | num | ✅ | ✅ | ✅ | ✓ OK |
| nCmdOutput | num | ✅ | ✅ | ✅ | ✓ OK |
| nCmdMatch | num | ✅ | ✅ | ✅ | ✓ OK |
| Command | num | ✅ | ❌ | ❌ | ⚠️ 누락 |

### 2.2 Enable/Mode 플래그

| 변수명 | 타입 | PlanA | PlanB ConfigModule | PlanB Head_Data | 상태 |
|--------|------|:---:|:---:|:---:|:---:|
| bEnableWeldSkip | bool | ✅ | ✅ | ✅ | ✓ OK |
| bEnableStartEndPointCorr | bool | ✅ | ✅ | ✅ | ✓ OK |
| bEnableManualMacro | bool | ✅ | ✅ | ✅ | ✓ OK |
| bWeldOutputDisable | bool | ✅ | ❌ | ✅ | ⚠️ ConfigModule에 없음 |
| bRobSwap | bool | ✅ | ❌ | ❌ | ⚠️ 누락 (로봇 스왑) |
| bWireTouch1 | bool | ✅ | ❌ | ❌ | ⚠️ 누락 |
| bWireTouch2 | bool | ✅ | ❌ | ❌ | ⚠️ 누락 |

### 2.3 동작 상태 신호

| 변수명 | 타입 | PlanA | PlanB ConfigModule | PlanB Head_Data | 상태 |
|--------|------|:---:|:---:|:---:|:---:|
| bMotionWorking | bool | ❌ | ✅ | ✅ | PlanB 추가 |
| bMotionFinish | bool | ❌ | ✅ | ✅ | PlanB 추가 |
| bMoveHome_Head | bool | ✅ | ❌ | ❌ | ⚠️ 누락 |
| bMoveGantry | bool | ✅ | ❌ | ❌ | ⚠️ 누락 |

### 2.4 T_Head 디스패치 프로토콜 (v1.9.39 신규)

| 변수명 | 타입 | PlanA | PlanB ConfigModule | PlanB Head_Data | 상태 |
|--------|------|:---:|:---:|:---:|:---:|
| stCommand | string | ❌ | ❌ | ✅ | PlanB v1.9.39 추가 |
| stReact{2} | string[] | ❌ | ❌ | ✅ | PlanB v1.9.39 추가 |

---

## 3. 용접 매크로 버퍼

### 3.1 torchmotion 버퍼 (PlanA/PlanB 공통)

| 변수명 | PlanA | PlanB ConfigModule | PlanB Head_Data | 상태 |
|--------|:---:|:---:|:---:|:---:|
| macroStartBuffer1{10} | ✅ | ✅ | ✅ | ✓ OK |
| macroStartBuffer2{10} | ✅ | ✅ | ✅ | ✓ OK |
| macroEndBuffer1{10} | ✅ | ✅ | ✅ | ✓ OK |
| macroEndBuffer2{10} | ✅ | ✅ | ✅ | ✓ OK |
| nWeldPassCount | ❌ | ✅ | ✅ | PlanB 추가 |

### 3.2 PlanA 추가 매크로 배열 (PlanB에 없음)

| 변수명 | 설명 | PlanA | PlanB | 중요도 |
|--------|------|:---:|:---:|:---:|
| macroAutoStartA{2,10} | 자동 매크로 시작 A | ✅ | ❌ | 🟡 중간 |
| macroAutoStartB{2,10} | 자동 매크로 시작 B | ✅ | ❌ | 🟡 중간 |
| macroAutoEndA{2,10} | 자동 매크로 종료 A | ✅ | ❌ | 🟡 중간 |
| macroAutoEndB{2,10} | 자동 매크로 종료 B | ✅ | ❌ | 🟡 중간 |
| macroManualStartA{2,10} | 수동 매크로 시작 A | ✅ | ❌ | 🟡 중간 |
| macroManualStartB{2,10} | 수동 매크로 시작 B | ✅ | ❌ | 🟡 중간 |
| macroManualEndA{2,10} | 수동 매크로 종료 A | ✅ | ❌ | 🟡 중간 |
| macroManualEndB{2,10} | 수동 매크로 종료 B | ✅ | ❌ | 🟡 중간 |

---

## 4. 에지/포지션 데이터

### 4.1 에지 데이터 (공통)

| 변수명 | PlanA | PlanB ConfigModule | PlanB Head_Data | 상태 |
|--------|:---:|:---:|:---:|:---:|
| edgeStart{2} | ✅ | ✅ | ✅ | ✓ OK |
| edgeEnd{2} | ✅ | ✅ | ✅ | ✓ OK |

### 4.2 포지션 데이터 (PlanA 고유)

| 변수명 | 타입 | PlanA | PlanB | 중요도 |
|--------|------|:---:|:---:|:---:|
| posStart | pos | ✅ | ❌ | 🟢 낮음 (edgeStart로 대체) |
| posEnd | pos | ✅ | ❌ | 🟢 낮음 (edgeEnd로 대체) |
| posStartLast | pos | ✅ | ❌ | 🟡 중간 |
| posEndLast | pos | ✅ | ❌ | 🟡 중간 |
| nStartThick | num | ✅ | ❌ | 🟡 중간 |
| nEndThick | num | ✅ | ❌ | 🟡 중간 |
| BreakPoints{10} | breakpoint | ✅ | ❌ | 🟡 중간 |

---

## 5. 기계 형상/리밋

### 5.1 기계 리밋 (PlanA vs PlanB 변수명 차이)

| PlanA 변수명 | PlanB 변수명 | 상태 |
|--------------|--------------|:---:|
| nLimitX_Negative | LIMIT_X_NEG | ✓ 이름 다름 |
| nLimitX_Positive | LIMIT_X_POS | ✓ 이름 다름 |
| nLimitY_Negative | LIMIT_Y_NEG | ✓ 이름 다름 |
| nLimitY_Positive | LIMIT_Y_POS | ✓ 이름 다름 |
| nLimitZ_Negative | LIMIT_Z_NEG | ✓ 이름 다름 |
| nLimitZ_Positive | LIMIT_Z_POS | ✓ 이름 다름 |
| nLimitR_Negative | LIMIT_R_NEG | ✓ 이름 다름 |
| nLimitR_Positive | LIMIT_R_POS | ✓ 이름 다름 |

### 5.2 홈 위치 (PlanA vs PlanB 변수명 차이)

| PlanA 변수명 | PlanB 변수명 | 상태 |
|--------------|--------------|:---:|
| nHomeGantryX | HOME_GANTRY_X | ⚠️ 값 다름 (-9500 vs 0) |
| nHomeGantryY | HOME_GANTRY_Y | ⚠️ 값 다름 (5300 vs 0) |
| nHomeGantryZ | HOME_GANTRY_Z | ⚠️ 값 다름 (2100 vs 0) |
| nHomeGantryR | HOME_GANTRY_R | ✓ OK |

### 5.3 로봇 높이 파라미터

| 변수명 | PlanA | PlanB | 중요도 |
|--------|:---:|:---:|:---:|
| nRobHeightMin | ✅ | ❌ | 🔴 높음 |
| nRobCorrSpaceHeight | ✅ | ❌ | 🔴 높음 |
| nRobWorkSpaceHeight | ✅ | ❌ | 🔴 높음 |
| nRobWeldSpaceHeight | ✅ | ✅ (ROB_WELD_SPACE_HEIGHT) | ✓ 이름 다름 |

---

## 6. 갠트리 이동

| 변수명 | 타입 | PlanA | PlanB | 상태 |
|--------|------|:---:|:---:|:---:|
| extGantryPos | extjoint | ✅ | ✅ | ✓ OK |
| nGantrySpeed | num | ✅ | ❌ | ⚠️ 누락 |
| nCurrentGantryHeight | num | ✅ | ❌ | ⚠️ 누락 |
| nTargetGantryHeight | num | ✅ | ❌ | ⚠️ 누락 |
| nCalculatedGantryHeight | num | ✅ | ❌ | ⚠️ 누락 |
| nGantrySafetyHeight | num | ✅ | ❌ | ⚠️ 누락 |

---

## 7. 용접 스텝 제어

| 변수명 | PlanA | PlanB ConfigModule | 상태 |
|--------|:---:|:---:|:---:|
| nMotionStep | ✅ | ✅ | ✓ OK |
| nMotionTotalStep{2} | ✅ | ✅ | ✓ OK |
| nMotionStepCount{2} | ✅ | ✅ | ✓ OK |
| nRunningStep{2} | ✅ | ✅ | ✓ OK |
| nMotionStartStepLast{2} | ✅ | ❌ | ⚠️ 누락 |
| nMotionEndStepLast{2} | ✅ | ❌ | ⚠️ 누락 |
| nLengthWeldLine | ✅ | ❌ | ⚠️ 누락 |
| nOffsetLength | ✅ | ❌ | ⚠️ 누락 |
| nOffsetLengthBuffer | ✅ | ❌ | ⚠️ 누락 |

---

## 8. 에러 플래그

| 변수명 | 타입 | PlanA | PlanB | 상태 |
|--------|------|:---:|:---:|:---:|
| bTouchError{4,2} | bool 배열 | ✅ | ❌ | ⚠️ 누락 |
| bArcError | bool | ✅ | ❌ | ⚠️ 누락 (bArcR1Error 등으로 대체?) |
| bEntryR1Error | bool | ❌ | ✅ | PlanB 추가 |
| bEntryR2Error | bool | ❌ | ✅ | PlanB 추가 |
| bTouchR1Error | bool | ❌ | ✅ | PlanB 추가 |
| bTouchR2Error | bool | ❌ | ✅ | PlanB 추가 |
| bArcR1Error | bool | ❌ | ✅ | PlanB 추가 |
| bArcR2Error | bool | ❌ | ✅ | PlanB 추가 |

---

## 9. 시간 측정

| 변수명 | PlanA | PlanB | 상태 |
|--------|:---:|:---:|:---:|
| nclockWeldTime{2} | ✅ | ✅ | ✓ OK |
| nclockCycleTime | ✅ | ✅ | ✓ OK |

---

## 10. 툴/좌표계 데이터 (PlanA 고유)

| 변수명 | 타입 | PlanA | PlanB | 중요도 |
|--------|------|:---:|:---:|:---:|
| tWeld | tooldata | ✅ | ❌ | 🔴 높음 - MainModule에 있음 |
| tWeld1 | tooldata | ✅ | ❌ | 🔴 높음 |
| tWeld2 | tooldata | ✅ | ❌ | 🔴 높음 |
| WobjFloor | wobjdata | ✅ | ❌ | 🔴 높음 - MainModule에 있음 |
| wobjWeldLine | wobjdata | ✅ | ❌ | 🟡 중간 |
| wobjWeldLine1 | wobjdata | ✅ | ❌ | 🟡 중간 |
| wobjWeldLine2 | wobjdata | ✅ | ❌ | 🟡 중간 |
| wobjRotCtr1 | wobjdata | ✅ | ❌ | 🟡 중간 |
| wobjRotCtr2 | wobjdata | ✅ | ❌ | 🟡 중간 |

---

## 11. 매크로 문자열

| 변수명 | PlanA | PlanB | 상태 |
|--------|:---:|:---:|:---:|
| stMacro{2} | ✅ | ✅ | ✓ OK |
| nMacro100{2} | ✅ | ❌ | ⚠️ 누락 |
| nMacro010{2} | ✅ | ❌ | ⚠️ 누락 |
| nMacro001{2} | ✅ | ❌ | ⚠️ 누락 |
| nMacro{2} | ✅ | ❌ | ⚠️ 누락 |

---

## 12. RECORD 정의 비교

### 12.1 공통 RECORD

| RECORD | 필드 수 | PlanA | PlanB | 상태 |
|--------|:---:|:---:|:---:|:---:|
| torchmotion | 22 | ✅ | ✅ | ✓ OK |
| edgedata | 7 | ✅ | ✅ | ✓ OK |
| corrorder | 10 | ✅ | ✅ | ✓ OK |
| targetdata | 16~17 | ✅ | ✅ | ⚠️ 필드 차이 확인 필요 |

### 12.2 PlanA 고유 RECORD

| RECORD | 필드 수 | 설명 | 중요도 |
|--------|:---:|------|:---:|
| breakpoint | 2 | 브레이크포인트 (pos, num Angle) | 🟡 중간 |
| monRobs | 5 | 로봇 모니터링 | 🟢 낮음 |
| jointgroup | 3 | 조인트 그룹 (ROB1, ROB2, Gantry) | 🔴 높음 |
| pointgroup | 3 | 포인트 그룹 | 🔴 높음 |

---

## 13. CMD 상수 비교

### 13.1 Movement (100 series)

| 상수명 | 값 | PlanA | PlanB | 상태 |
|--------|:---:|:---:|:---:|:---:|
| CMD_MOVE_TO_WORLDHOME | 101 | ✅ | ✅ | ✓ OK |
| CMD_MOVE_TO_MeasurementHOME | 102 | ✅ | ✅ (MEASUREMENTHOME) | ✓ 이름 다름 |
| CMD_MOVE_TO_TEACHING_All | 104 | ✅ | ❌ | ⚠️ 누락 |
| CMD_MOVE_TO_TEACHING_R1 | 105 | ✅ | ✅ | ✓ OK |
| CMD_MOVE_TO_TEACHING_R2 | 106 | ✅ | ✅ | ✓ OK |
| CMD_MOVE_JOINTS | 107 | ✅ | ❌ | ⚠️ 누락 |
| CMD_MOVE_ABS_GANTRY | 108 | ✅ | ✅ | ✓ OK |
| CMD_MOVE_INC_GANTRY | 109 | ✅ | ✅ | ✓ OK |
| CMD_MOVE_TO_ZHOME | 110 | ✅ | ✅ | ✓ OK |
| CMD_MOVE_TO_nWarmUp | 112 | ✅ | ✅ (WARMUP) | ✓ 이름 다름 |

### 13.2 Camera (300 series) - PlanA 추가 명령

| 상수명 | 값 | PlanA | PlanB | 상태 |
|--------|:---:|:---:|:---:|:---:|
| CMD_CAMERA1_DOOR_OPEN | 311 | ✅ | ❌ | ⚠️ 누락 |
| CMD_CAMERA1_DOOR_CLOSE | 312 | ✅ | ❌ | ⚠️ 누락 |
| CMD_CAMERA2_DOOR_OPEN | 321 | ✅ | ❌ | ⚠️ 누락 |
| CMD_CAMERA2_DOOR_CLOSE | 322 | ✅ | ❌ | ⚠️ 누락 |
| CMD_CAMERA1_BLOW_ON | 313 | ✅ | ❌ | ⚠️ 누락 |
| CMD_CAMERA2_BLOW_ON | 323 | ✅ | ❌ | ⚠️ 누락 |
| CMD_CAMERA1_BLOW_OFF | 314 | ✅ | ❌ | ⚠️ 누락 |
| CMD_CAMERA2_BLOW_OFF | 324 | ✅ | ❌ | ⚠️ 누락 |

### 13.3 Wire (500 series) - PlanA 추가 명령

| 상수명 | 값 | PlanA | PlanB | 상태 |
|--------|:---:|:---:|:---:|:---:|
| CMD_WIRE_BULLSEYE_CHECK | 505 | ✅ | ❌ | ⚠️ 누락 |
| CMD_WIRE_BULLSEYE_UPDATE | 506 | ✅ | ❌ | ⚠️ 누락 |
| CMD_WIRE_ReplacementMode | 507 | ✅ | ❌ | ⚠️ 누락 |

---

## 14. TASK PERS 용접 데이터 (PlanA 고유 - 대량)

### 14.1 welddata 배열 (40개 스텝)

```rapid
! PlanA에만 있음
TASK PERS welddata wdArray{40};
TASK PERS welddata wd1 ~ wd40;  ! 40개 개별 변수
```

### 14.2 weavedata 배열 (40개 스텝)

```rapid
! PlanA에만 있음
TASK PERS weavedata weave1 ~ weave40;  ! 40개 개별 변수
```

### 14.3 trackdata 배열 (40개 스텝)

```rapid
! PlanA에만 있음
TASK PERS trackdata track0 ~ track40;  ! 41개 개별 변수
```

### 14.4 targetdata 배열

```rapid
! PlanA에만 있음
PERS targetdata Welds1{40};  ! Robot1 용접 포지션
PERS targetdata Welds2{40};  ! Robot2 용접 포지션
PERS targetdata WeldsG{40};  ! Gantry 용접 포지션
```

---

## 15. 조인트/로봇타겟 데이터 (PlanA 고유 - 대량)

| 변수명 | 타입 | 설명 | 중요도 |
|--------|------|------|:---:|
| jHomeJoint | jointtarget | 홈 조인트 | 🔴 높음 |
| jgHomeJoint | jointgroup | 홈 조인트 그룹 (3축) | 🔴 높음 |
| jWeldPos{40} | jointtarget[] | 용접 조인트 포지션 | 🔴 높음 |
| pTargetWeldArray{30} | robtarget[] | 타겟 용접 배열 | 🔴 높음 |
| pWeldPosR1{40} | robtarget[] | Robot1 용접 포지션 | 🔴 높음 |
| pWeldPosR2{40} | robtarget[] | Robot2 용접 포지션 | 🔴 높음 |
| jWireCutRdy10~70 | jointtarget | 와이어컷 레디 포지션 | 🟡 중간 |
| jNozzleClean10~80 | jointtarget | 노즐 클리닝 포지션 | 🟡 중간 |
| jTeachPose10~40 | jointtarget | 티칭 포즈 | 🟡 중간 |

---

## 16. 카메라/검사 데이터 (PlanA 고유)

| 변수명 | 타입 | PlanA | PlanB | 중요도 |
|--------|------|:---:|:---:|:---:|
| Camera_Door | num | ✅ | ❌ | 🟡 중간 |
| Camera_Tilt | num | ✅ | ❌ | 🟡 중간 |
| nCameraRotationAngle | num | ✅ | ❌ | 🟡 중간 |

---

## 17. 누락 변수 우선순위 분류

### 17.1 🔴 HIGH (상위 시스템 UI 필수)

1. **bRobSwap** - 로봇 스왑 여부
2. **nRobHeightMin** - 로봇 최소 높이
3. **nRobCorrSpaceHeight** - 보정 공간 높이
4. **nRobWorkSpaceHeight** - 작업 공간 높이
5. **jointgroup, pointgroup RECORD** - 3축 동기 이동용
6. **jgHomeJoint** - 3축 홈 포지션
7. **pWeldPosR1{40}, pWeldPosR2{40}** - 용접 포지션 배열

### 17.2 🟡 MEDIUM (기능 완성용)

1. **macroAutoStartA/B, macroManualStartA/B** - 매크로 선택 기능
2. **nMacro100, nMacro010, nMacro001, nMacro** - 매크로 파싱
3. **posStartLast, posEndLast** - 이전 포지션 저장
4. **nMotionStartStepLast, nMotionEndStepLast** - 이전 스텝 저장
5. **nGantrySpeed** - 갠트리 속도
6. **nLengthWeldLine** - 용접선 길이
7. **BreakPoints{10}** - 브레이크포인트

### 17.3 🟢 LOW (선택적)

1. **Command** - nCmdInput으로 대체 가능
2. **posStart, posEnd** - edgeStart/edgeEnd로 대체
3. **Camera_Door, Camera_Tilt** - 카메라 옵션

---

## 18. 권장 조치

### Phase 1: 즉시 필요 (UI 호환성)

```rapid
! ConfigModule.mod에 추가
PERS bool bRobSwap := FALSE;
PERS bool bWeldOutputDisable := TRUE;
PERS bool bMoveGantry := FALSE;
PERS num nRobHeightMin := 1100;
PERS num nRobCorrSpaceHeight := 1680;
PERS num nRobWorkSpaceHeight := 1680;
```

### Phase 2: 매크로 기능 확장

```rapid
! ConfigModule.mod에 추가
PERS torchmotion macroAutoStartA{2,10};
PERS torchmotion macroAutoStartB{2,10};
PERS torchmotion macroAutoEndA{2,10};
PERS torchmotion macroAutoEndB{2,10};
PERS num nMacro100{2} := [0,0];
PERS num nMacro010{2} := [0,0];
PERS num nMacro001{2} := [0,0];
PERS num nMacro{2} := [0,0];
```

### Phase 3: 명령 상수 추가

```rapid
! ConfigModule.mod에 추가
CONST num CMD_MOVE_TO_TEACHING_All := 104;
CONST num CMD_MOVE_JOINTS := 107;
CONST num CMD_CAMERA1_DOOR_OPEN := 311;
CONST num CMD_CAMERA1_DOOR_CLOSE := 312;
! ... (Camera1/2 시리즈)
CONST num CMD_WIRE_BULLSEYE_CHECK := 505;
CONST num CMD_WIRE_BULLSEYE_UPDATE := 506;
CONST num CMD_WIRE_ReplacementMode := 507;
```

---

## 19. 호환성 매트릭스

| 기능 | PlanA UI 지원 | PlanB 현재 | 조치 필요 |
|------|:---:|:---:|:---:|
| 기본 명령 (101-112, 200-210) | ✅ | ✅ | 없음 |
| 갠트리 이동 | ✅ | ✅ | 없음 |
| 에지 기반 용접 | ✅ | ✅ | 없음 |
| 매크로 버퍼 | ✅ | ✅ | 없음 |
| 다중 패스 용접 | ✅ | ✅ | 없음 |
| 로봇 스왑 | ✅ | ❌ | bRobSwap 추가 |
| 카메라 개별 제어 | ✅ | ❌ | CMD 추가 |
| 와이어 불스아이 | ✅ | ❌ | CMD 추가 |
| TASK PERS welddata | ✅ | ❌ | 설계 결정 필요 |

---

## 20. 결론

**PlanB가 PlanA UI와 호환되려면:**

1. ✅ **핵심 인터페이스 (80%)**: nCmdInput/Output/Match, macroBuffer, edgeData 등 → 이미 호환
2. ⚠️ **누락 변수 (15%)**: bRobSwap, 로봇 높이 파라미터, 추가 CMD 상수 → 추가 필요
3. ❓ **설계 차이 (5%)**: TASK PERS welddata/weavedata/trackdata (40개 스텝) → 설계 결정 필요

**PlanA의 40-step welddata/weavedata/trackdata 배열**은 torchmotion macroBuffer{10}과 다른 접근 방식입니다:
- PlanA: 각 스텝마다 개별 welddata 변수 (wd1~wd40)
- PlanB: macroStartBuffer1{pass}로 패스별 파라미터 관리

이 설계 차이는 상위 시스템 UI가 어떤 방식을 사용하는지에 따라 결정해야 합니다.

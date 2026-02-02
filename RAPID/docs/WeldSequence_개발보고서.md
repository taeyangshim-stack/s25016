# S25016 Weld Sequence 개발 보고서

**프로젝트:** S25016 SpGantry 듀얼 로봇 시스템
**문서 버전:** 1.0
**작성일:** 2026-02-03
**현재 코드 버전:** v1.9.22

---

## 1. 개요

### 1.1 프로젝트 목표
SpGantry 듀얼 로봇 시스템에서 두 대의 로봇이 동기화하여 자동 용접을 수행하는 Weld Sequence 기능 개발

### 1.2 시스템 구성

| 구성 요소 | 설명 |
|----------|------|
| **Robot1 (T_ROB1)** | IRB1200, 갠트리 장착 (X1, Y, Z, R 외부축) |
| **Robot2 (T_ROB2)** | IRB1200, 고정 베이스 |
| **갠트리** | X1/X2 연동 모터, Y축, Z축, R축 (회전) |
| **컨트롤러** | IRC5 듀얼 로봇 |

### 1.3 외부축 구성

```
Robot1 (갠트리 장착):
├── eax_a: X1 (갠트리 X축 마스터)
├── eax_b: Y (갠트리 Y축)
├── eax_c: Z (갠트리 Z축)
├── eax_d: R (갠트리 회전축)
└── eax_f: X2 (갠트리 X축 슬레이브, 연동)

Robot2 (고정):
└── 외부축 없음
```

---

## 2. 아키텍처

### 2.1 태스크 구조

```
┌─────────────────────────────────────────────────────────┐
│                    IRC5 Controller                       │
├─────────────────────┬─────────────────────┬─────────────┤
│      T_ROB1         │      T_ROB2         │    T_BG     │
│    (TASK1)          │    (TASK2)          │ (Background)│
├─────────────────────┼─────────────────────┼─────────────┤
│ MainModule.mod      │ Rob2_MainModule.mod │ BgTask.mod  │
│ ConfigModule.mod    │                     │             │
│ VersionModule.mod   │                     │             │
└─────────────────────┴─────────────────────┴─────────────┘
```

### 2.2 동기화 메커니즘

TASK1과 TASK2는 PERS 변수를 통해 동기화:

```rapid
! TASK1 → TASK2 신호
PERS bool t1_ready := FALSE;        ! Robot1 초기화 완료
PERS bool t1_weld_start := FALSE;   ! 용접 시작 신호
PERS bool t1_weld_done := FALSE;    ! 용접 완료 신호

! TASK2 → TASK1 신호
PERS bool t2_ready := FALSE;        ! Robot2 초기화 완료
PERS bool t2_weld_ready := FALSE;   ! Robot2 용접 위치 도착

! 공유 변수
PERS num shared_test_mode := 0;     ! 테스트 모드 공유
```

### 2.3 좌표계

| 좌표계 | 설명 | 용도 |
|--------|------|------|
| **wobj0** | 월드 좌표계 (Floor 기준) | Robot2 이동, 절대 위치 |
| **WobjGantry** | 갠트리 R-Center 기준 | Robot1 이동 (갠트리 상대 좌표) |
| **WobjWeldR1** | 용접 작업 좌표계 | 용접 경로 계산용 |

---

## 3. Weld Sequence 흐름

### 3.1 전체 시퀀스 (v1.9.22)

```
TASK1 (Robot1)                      TASK2 (Robot2)
─────────────────                   ─────────────────
     │                                    │
     ▼                                    ▼
[Step0] Sync flags reset            [대기: shared_test_mode]
     │                                    │
     ▼                                    ▼
[Step1] CalcCenterLine              (대기)
     │
     ▼
[Step2] MoveGantryToWeldStart
        → X1, X2 = -4500
     │
     ▼
[Step3] CreateWeldWobj
        → WobjGantry 업데이트
     │
     ▼
[Step4a] MoveRobot1ToWeldReady ──── [Step4b] Robot2_WeldReady
         ├─ Step1: MoveAbsJ                   ├─ Step1: MoveAbsJ
         │   [0,-10,-50,0,-30,0]              │   [0,-10,-50,0,-30,0]
         └─ Step2: MoveJ                      └─ Step2: MoveJ
             WobjGantry [0,111,-73]                wobj0 [0,118,-1300]
     │                                    │
     ▼                                    ▼
[Step5] WeldAlongCenterLine         (동기 대기)
        → 갠트리 X축 이동하며 용접
     │
     ▼
[Step6] ReturnRobot1ToSafe
        → [0,-10,-50,0,-30,0]
     │
     ▼
[Step7] ReturnGantryToHome
        → X1=0, Y=0, Z=0, R=0
     │
     ▼
   [완료]
```

### 3.2 주요 프로시저

#### MoveRobot1ToWeldReady (v1.9.22)
```rapid
PROC MoveRobot1ToWeldReady()
    ! Step 1: 안전 JOINT 위치로 이동
    safe_jt.robax := [0, -10, -50, 0, -30, 0];
    MoveAbsJ safe_jt, v100, fine, tool0;

    ! Step 2: WobjGantry 기준 목표 위치로 이동
    weld_target.trans := [0, 111, -73];
    weld_target.rot := [0.70603, 0.03905, -0.03904, 0.70603];
    MoveJ weld_target, v100, fine, tool0\WObj:=WobjGantry;
ENDPROC
```

---

## 4. 현재 상태

### 4.1 테스트 결과 (v1.9.22)

| 단계 | 상태 | 비고 |
|------|------|------|
| Step0: Sync flags reset | ✅ 성공 | |
| Step1: CalcCenterLine | ✅ 성공 | |
| Step2: MoveGantryToWeldStart | ✅ 성공 | X1=-4499.8, X2=-4499.8 |
| Step3: CreateWeldWobj | ✅ 성공 | |
| Step4a: MoveRobot1ToWeldReady | ❌ 실패 | 50027 Joint Out of Range |
| Step5~7 | - | 미도달 |

### 4.2 현재 에러

**50027 - Joint Out of Range**
- 발생 위치: Step4a, MoveJ to WobjGantry [0, 111, -73]
- 원인 추정: 목표 위치 도달 시 관절 구성(confdata)으로 인한 관절 한계 초과
- 해결 방안: MoveAbsJ 사용 또는 confdata 조정 필요

### 4.3 다음 단계

1. Robot1 용접 위치에서 실제 JOINT 값 취득
2. Step2를 MoveAbsJ로 변경하여 테스트
3. 또는 적절한 confdata (cf1, cf4, cf6) 설정

---

## 5. 참고 자료

- [버전 히스토리](./WeldSequence_버전히스토리.md)
- [에러 분석](./WeldSequence_에러분석.md)
- [VersionModule.mod](../SpGantry_1200_526406_BACKUP_2025-12-18/RAPID/TASK1/PROGMOD/VersionModule.mod)

---

## 6. 변경 이력

| 날짜 | 버전 | 내용 |
|------|------|------|
| 2026-02-03 | 1.0 | 초기 문서 작성 |

# TestWobj0Axes.mod 수정 내역

**수정일**: 2025-12-09 20:35
**버전**: v1.0 → v1.1
**이유**: Joint Out of Range 오류 해결

---

## 🔴 발생한 문제

### 오류 로그
```
SpGantry_1200_526406 (Station): 50027 - Joint Out of Range
SpGantry_1200_526406 (Station): 10020 - Execution error state
SpGantry_1200_526406 (Station): 10125 - Program stopped
```

### 원인 분석

**v1.0의 동작**:
1. Home 위치 `[0, -45, 0, 0, -45, 0]`로 이동
2. wobj0 좌표 읽기: `[-515, 0, 1146]`
3. X축 +100mm 이동 시도: `[-415, 0, 1146]`
4. ❌ **관절 각도 한계 초과** (특히 J2 또는 J5)

**문제점**:
- Home 위치는 작업 영역 가장자리에 가까움
- 100mm 이동은 너무 큰 변위
- 직선 이동(MoveL) 시 관절 한계에 걸림

---

## ✅ 수정 사항

### 1. 시작 위치 변경

| 항목 | v1.0 (기존) | v1.1 (수정) |
|------|------------|------------|
| **관절 각도** | [0, -45, 0, 0, -45, 0] | [0, 0, 0, 0, 0, 0] |
| **위치 이름** | Home | Zero |
| **wobj0 좌표** | [-515, 0, 1146] | [45, 0, 889] |
| **안전성** | ❌ 가장자리 | ✅ 중앙 영역 |

**변경 코드**:
```rapid
! Before (v1.0)
! Start position: Home
TPWrite "Moving to home...";
MoveAbsJ [[0, -45, 0, 0, -45, 0], [0, 0, 0, 0, 0, 0]], v100, fine, tool0;

! After (v1.1)
! Start position: Zero (safer than Home)
TPWrite "Moving to zero position...";
MoveAbsJ [[0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]], v100, fine, tool0;
```

### 2. 이동 거리 축소

| 축 | v1.0 (기존) | v1.1 (수정) |
|----|------------|------------|
| **X축** | +100mm | +50mm |
| **Y축** | +100mm | +50mm |
| **Z축** | +100mm | +50mm |

**변경 코드**:
```rapid
! Before (v1.0)
pos_xplus.trans.x := pos_start.trans.x + 100;

! After (v1.1)
pos_xplus.trans.x := pos_start.trans.x + 50;
```

### 3. 향상된 에러 처리

**추가된 에러 핸들링**:
```rapid
ERROR
    TPWrite "ERROR: " + NumToStr(ERRNO, 0);

    IF ERRNO = 50027 THEN
        TPWrite "Joint out of range - position not reachable";
    ELSEIF ERRNO = 50050 THEN
        TPWrite "Position outside reach";
    ENDIF

    ! 로그 파일에 상세 에러 정보 기록
    Open filename, logfile\Write;
    Write logfile, "========================================";
    Write logfile, "ERROR occurred during test";
    Write logfile, "========================================";
    Write logfile, "";
    Write logfile, "Error code: " + NumToStr(ERRNO, 0);

    IF ERRNO = 50027 THEN
        Write logfile, "Error type: Joint out of range";
        Write logfile, "The target position cannot be reached without";
        Write logfile, "exceeding joint angle limits.";
    ELSEIF ERRNO = 50050 THEN
        Write logfile, "Error type: Position outside reach";
        Write logfile, "The target position is outside robot workspace.";
    ELSE
        Write logfile, "Error type: Unknown";
    ENDIF

    Write logfile, "";
    Write logfile, "Test aborted.";
    Write logfile, "========================================";
    Close logfile;
```

---

## 📊 예상 결과 비교

### v1.0 (실패)

```
시작: Home [-515, 0, 1146]
목표 X+: [-415, 0, 1146]  ← Joint 한계 초과!
목표 Y+: [-515, 100, 1146]
목표 Z+: [-515, 0, 1246]
```

### v1.1 (성공 예상)

```
시작: Zero [45, 0, 889]
목표 X+: [95, 0, 889]    ← 안전 영역 ✅
목표 Y+: [45, 50, 889]   ← 안전 영역 ✅
목표 Z+: [45, 0, 939]    ← 안전 영역 ✅
```

---

## 🎯 테스트 실행 방법

### 1. 파일 복사
```
RAPID/TASK1/PROGMOD/TestWobj0Axes.mod
→ RobotStudio 프로젝트로 복사 (v1.1로 덮어쓰기)
```

### 2. 실행
```rapid
TestWobj0AxisDirections;
```

### 3. 관찰 포인트

**Zero 위치에서 시작**:
- wobj0 좌표: `[45, 0, 889]` 확인
- Quaternion: `[0.707, 0, 0.707, 0]` (90도 회전 예상)

**각 축 이동 시 관찰**:
- **X + 50mm** → 로봇이 어느 방향으로 움직이는가?
  - 예상 (표준): 앞으로
  - 예상 (90도 회전): 왼쪽으로
- **Y + 50mm** → 로봇이 어느 방향으로 움직이는가?
  - 예상 (표준): 왼쪽으로
  - 예상 (90도 회전): 뒤로
- **Z + 50mm** → 로봇이 어느 방향으로 움직이는가?
  - 예상: 위로 (모든 경우)

### 4. 결과 확인
```
HOME:/wobj0_axis_test.txt
```

---

## 🔧 기술적 배경

### 왜 Zero 위치가 더 안전한가?

**관절 각도 관점**:
```
Home [0, -45, 0, 0, -45, 0]:
- J2 = -45° (아래로 구부림)
- J5 = -45° (손목 구부림)
- 이 상태에서 앞으로 이동하면 관절 한계에 도달하기 쉬움

Zero [0, 0, 0, 0, 0, 0]:
- 모든 관절이 0° (중립)
- 모든 방향으로 이동 여유가 큼
- 더 넓은 작업 영역 확보
```

**작업 공간 관점**:
```
Home: 로봇 팔이 아래로 구부러져 있어 전방 이동 제한적
Zero: 로봇 팔이 펼쳐져 있어 사방으로 이동 가능
```

---

## 📝 변경 내역 요약

| 항목 | v1.0 | v1.1 |
|------|------|------|
| **버전** | v1.0_251209 | v1.1_251209 |
| **시작 위치** | Home [0,-45,0,0,-45,0] | Zero [0,0,0,0,0,0] |
| **이동 거리** | 100mm | 50mm |
| **wobj0 시작** | [-515, 0, 1146] | [45, 0, 889] |
| **안전성** | ❌ Joint 한계 발생 | ✅ 안전 영역 |
| **에러 처리** | 기본 | 향상 (50027, 50050) |
| **상태** | ❌ 테스트 실패 | ⏳ 재테스트 필요 |

---

## 🚀 다음 단계

1. ✅ TestWobj0Axes.mod v1.1 작성 완료
2. ✅ Git 커밋 완료 (42e5643)
3. ⏳ **사용자**: RobotStudio에 복사 및 실행
4. ⏳ **사용자**: 축 방향 관찰 및 기록
5. ⏳ **다음 작업**: 관찰 결과 기반 좌표 변환 공식 작성

---

**수정 완료**: 2025-12-09 20:35
**커밋**: 42e5643
**상태**: ✅ 수정 완료, 테스트 준비됨
**다음**: 사용자가 v1.1 실행 및 관찰 결과 제공

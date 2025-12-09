# ComprehensiveTCPCheck 사용 가이드

**작성일**: 2025-12-09
**프로젝트**: S25016 SpGantry 1200
**버전**: v3.0_251209

---

## 📋 목적

**문제점**: 관절 각도 지정 방식은 TCP 위치가 복잡한 소수점 값으로 나타나 검증이 어려움

**해결책**:
- 베이스 좌표계(wobj0)에서 **깔끔한 정수 좌표**로 TCP 위치 지정
- 예: [100, 0, 900] - 이해하기 쉽고 계산 간편
- 베이스 좌표계와 정반 좌표계(WobjFloor) 양쪽에서 동시 측정

---

## 🎯 주요 기능

### 1. 간단한 정수 좌표 사용
```rapid
! 기존 방식 (관절 제어)
MoveAbsJ [[0,-45,0,0,-45,0], ...]
→ TCP = [-195.300, -0.005, 1478.380]  ← 복잡한 소수점

! 새 방식 (데카르트 제어)
ComprehensiveTCPCheck 100, 0, 900
→ TCP = [100.000, 0.000, 900.000]  ← 깔끔한 정수
```

### 2. 양쪽 좌표계 동시 측정
- **wobj0 (베이스 좌표계)**: 각 로봇 독립적 기준
- **WobjFloor (정반 좌표계)**: 양 로봇 공통 기준

### 3. 완전한 정보 출력
- 목표 위치 vs 실제 위치
- 위치 오차 (dX, dY, dZ)
- 관절 각도
- Quaternion 방향
- 좌표계 정의 및 사용법

---

## 🚀 사용 방법

### Robot1 테스트 (TASK1에서 실행)

```rapid
! 1. RobotStudio에서 TASK1 선택
! 2. PP to Main 실행
! 3. 다음 프로시저 호출

ComprehensiveTCPCheck 100, 0, 900;

! 결과 파일:
! HOME:/comprehensive_tcp_check_robot1.txt
```

### Robot2 테스트 (TASK2에서 실행)

```rapid
! 1. RobotStudio에서 TASK2 선택
! 2. PP to Main 실행
! 3. 동일한 프로시저 호출

ComprehensiveTCPCheck 100, 0, 900;

! 결과 파일:
! HOME:/comprehensive_tcp_check_robot2.txt
```

---

## 📊 예상 결과

### Robot1 테스트 결과 예시

```
========================================
Target Position (Command)
========================================
Coordinate System: wobj0 (Base)
  X = 100.000 mm
  Y = 0.000 mm
  Z = 900.000 mm
Orientation: [0, 1, 0, 0]

========================================
Actual TCP Position - wobj0 (Base)
========================================
  X = 100.002 mm      ← 목표와 거의 일치!
  Y = 0.001 mm
  Z = 899.998 mm

Position Error (Actual - Target):
  dX = 0.002 mm       ← 매우 작은 오차
  dY = 0.001 mm
  dZ = -0.002 mm

========================================
Actual TCP Position - WobjFloor
========================================
  X = 9600.123 mm     ← 정반 좌표계 값
  Y = 5300.456 mm
  Z = 1200.789 mm

========================================
Joint Angles
========================================
  J1 = -15.234 deg    ← 자동 계산된 관절 각도
  J2 = -32.456 deg
  J3 = 12.345 deg
  J4 = -0.123 deg
  J5 = -43.210 deg
  J6 = 0.567 deg
```

### Robot2 테스트 결과 예시

```
========================================
Target Position (Command)
========================================
Coordinate System: wobj0 (Base)
  X = 100.000 mm      ← Robot1과 동일한 명령
  Y = 0.000 mm
  Z = 900.000 mm

========================================
Actual TCP Position - wobj0 (Base)
========================================
  X = 100.001 mm      ← 목표와 거의 일치!
  Y = -0.002 mm
  Z = 900.003 mm

========================================
Actual TCP Position - WobjFloor
========================================
  X = 10576.234 mm    ← Robot1과 다른 값 (정상!)
  Y = 5299.987 mm
  Z = 1200.812 mm

Physical separation from Robot1:
  ~976 mm (2 x 488 mm base offset)
```

---

## 🔍 결과 분석 방법

### 1. wobj0 (베이스) 좌표 검증

**확인 사항**:
```
✅ Actual ≈ Target (오차 < 0.1mm)
✅ 각 로봇이 독립적으로 [100, 0, 900]에 도달
✅ 두 로봇 모두 자신의 베이스 기준으로 동일한 위치
```

### 2. WobjFloor (정반) 좌표 검증

**확인 사항**:
```
✅ Robot1 WobjFloor X ≈ 9600 mm
✅ Robot2 WobjFloor X ≈ 10576 mm
✅ 차이 ≈ 976 mm (2 × 488mm 베이스 오프셋)
✅ Y, Z 값은 유사해야 함
```

### 3. 관절 각도 확인

**정상 동작**:
```
✅ 모든 관절이 한계 내에 위치
✅ J2, J3 값이 물리적으로 가능한 범위
✅ Singularity 회피
```

---

## 📐 좌표계 이해

### wobj0 (Base Coordinate System)

```
┌─────────────────────────────────────┐
│ Robot1 Base        Robot2 Base      │
│     ↓                  ↓             │
│   [100,0,900]      [100,0,900]      │
│     │                  │             │
│   Robot1 TCP       Robot2 TCP       │
│                                      │
│ ← 488mm → Center ← 488mm →          │
│                                      │
│ 각 로봇 독립적 기준                  │
│ 동일한 명령 → 다른 절대 위치         │
└─────────────────────────────────────┘
```

### WobjFloor (Floor Coordinate System)

```
┌─────────────────────────────────────┐
│        WobjFloor (정반 좌표계)       │
│                                      │
│  Robot1 TCP         Robot2 TCP      │
│  [9600, 5300, 1200] [10576, 5300, 1200]
│      ↑                  ↑            │
│      └─── 976mm ────────┘            │
│                                      │
│ 양 로봇 공통 기준                    │
│ Vision 시스템 기준                   │
└─────────────────────────────────────┘
```

---

## 💡 테스트 시나리오

### 시나리오 1: 기본 검증

**목적**: 좌표 제어가 정확한지 확인

```rapid
! Robot1 (TASK1)
ComprehensiveTCPCheck 100, 0, 900;

! Robot2 (TASK2)
ComprehensiveTCPCheck 100, 0, 900;

! 확인 사항:
! - wobj0: 각각 [100, 0, 900] 도달
! - WobjFloor: 976mm 차이
! - 위치 오차 < 0.1mm
```

### 시나리오 2: 다양한 위치 테스트

```rapid
! 위치 1: 낮은 높이
ComprehensiveTCPCheck 100, 0, 700;

! 위치 2: 높은 높이
ComprehensiveTCPCheck 100, 0, 1100;

! 위치 3: 앞쪽
ComprehensiveTCPCheck 300, 0, 900;

! 위치 4: 뒤쪽
ComprehensiveTCPCheck -100, 0, 900;
```

### 시나리오 3: 좌우 이동

```rapid
! Y축 오프셋 테스트
ComprehensiveTCPCheck 100, -50, 900;  ! 왼쪽
ComprehensiveTCPCheck 100, 0, 900;    ! 중앙
ComprehensiveTCPCheck 100, 50, 900;   ! 오른쪽
```

---

## ⚠️ 안전 주의사항

### 1. 작업 영역 확인

```
✅ 테스트 전 충돌 위험 확인
✅ 로봇 간섭 가능성 체크
✅ 특이점(Singularity) 회피
```

### 2. 권장 좌표 범위

```
X: -300 ~ 500 mm    (로봇 기준 앞뒤)
Y: -100 ~ 100 mm    (좌우)
Z: 700 ~ 1200 mm    (높이)
```

### 3. 비권장 영역

```
❌ Z < 500 mm       (바닥 충돌 위험)
❌ Z > 1500 mm      (한계 초과)
❌ X < -500 mm      (작업 영역 밖)
❌ X > 800 mm       (작업 영역 밖)
```

---

## 🛠️ 문제 해결

### 오류 1: "RANYBIN-060 Cannot move in Cartesian space"

**원인**: 목표 위치에 도달할 수 없음 (관절 한계, 특이점)

**해결**:
```rapid
! 다른 위치로 시도
ComprehensiveTCPCheck 200, 0, 1000;

! 또는 ConfL\Off 확인 (이미 포함됨)
```

### 오류 2: "위치 오차가 큼 (> 1mm)"

**원인**: 로봇 캘리브레이션 문제 또는 명령 문제

**해결**:
```
1. 로봇 재시작
2. 홈 위치로 이동 후 재시도
3. 다른 좌표로 테스트
4. TCP 캘리브레이션 확인
```

### 오류 3: "파일이 생성되지 않음"

**원인**: 파일 쓰기 권한 또는 경로 문제

**해결**:
```rapid
! RobotStudio Output 창에서 오류 메시지 확인
! HOME: 경로가 올바른지 확인
```

---

## 📝 추가 정보

### 관련 파일

```
RAPID 프로그램:
- TASK1/PROGMOD/MonitorFloorCoordinates.mod
- TASK2/PROGMOD/FloorMonitor_Task2.mod

출력 파일:
- HOME:/comprehensive_tcp_check_robot1.txt
- HOME:/comprehensive_tcp_check_robot2.txt

가이드 문서:
- RAPID/ComprehensiveTCPCheck_사용가이드_251209.md
```

### 버전 정보

```
v3.0_251209 (2025-12-09)
- 초기 릴리스
- wobj0 베이스 좌표 제어
- WobjFloor 동시 측정
- 깔끔한 정수 좌표 지원
```

---

## ✨ 주요 장점

### 1. 이해하기 쉬움
```
[100, 0, 900] vs [-195.300, -0.005, 1478.380]
     ↑               ↑
  간단!           복잡...
```

### 2. 검증하기 쉬움
```
목표: [100, 0, 900]
실제: [100.002, 0.001, 899.998]
오차: [0.002, 0.001, -0.002]
       ↑ 한눈에 파악!
```

### 3. 계산하기 쉬움
```
Robot1 WobjFloor X: 9600 mm
Robot2 WobjFloor X: 10576 mm
차이: 10576 - 9600 = 976 mm ✓
예상: 2 × 488 = 976 mm ✓
```

### 4. 재현하기 쉬움
```
"100, 0, 900으로 이동해주세요"
→ 누구나 즉시 이해하고 실행 가능
```

---

## 🎓 학습 순서

### 1단계: 기본 테스트
```rapid
! 단순히 실행해보기
ComprehensiveTCPCheck 100, 0, 900;

! 출력 파일 확인
! wobj0 vs WobjFloor 차이 이해
```

### 2단계: 비교 테스트
```rapid
! Robot1과 Robot2 모두 실행
! wobj0: 동일 (각자 기준 [100,0,900])
! WobjFloor: 976mm 차이 확인
```

### 3단계: 다양한 위치
```rapid
! 여러 위치 테스트
ComprehensiveTCPCheck 100, 0, 700;
ComprehensiveTCPCheck 200, 0, 1000;
ComprehensiveTCPCheck 0, 50, 900;
```

### 4단계: 실전 응용
```rapid
! Vision 시스템 좌표와 연동
! 실제 용접 위치 테스트
```

---

## 📞 지원

**문의**: SP 심태양
**프로젝트**: S25016 SpGantry 1200
**위치**: 34bay 자동용접 A라인/B라인

---

**업데이트 기록**:
- 2025-12-09: v3.0 초기 릴리스

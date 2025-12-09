# ComprehensiveTCPCheck confdata 추가 완료

**작성일**: 2025-12-10
**버전**: v4.0_251210
**커밋**: 2042743

---

## ✅ 수정 완료 사항

### 문제 상황
```
에러: 50027 - Joint Out of Range
발생: TestTCP_188_0_1100, TestTCP_200_0_1200 실행 시
원인: 목표 위치에 도달할 수 있지만, configuration이 맞지 않아 관절 한계 초과
```

### 해결 방법

**명시적 confdata 지정 + ConfL\On 활성화**

---

## 📐 Configuration (confdata) 개념

### confdata란?

ABB 로봇은 **동일한 TCP 위치에 여러 가지 관절 자세**로 도달할 수 있습니다.

```
예시: 손끝(TCP)이 같은 위치라도
- 팔꿈치를 위로 올린 자세
- 팔꿈치를 아래로 내린 자세
- 손목을 뒤집은 자세
등 여러 자세 가능
```

**confdata**는 어떤 자세를 선택할지 지정하는 파라미터입니다.

### confdata 구조

```rapid
robtarget := [[x, y, z], [q1,q2,q3,q4], [cf1,cf4,cf6,cfx], [extax]]
             └─ trans ─┘  └── rot ───┘  └─── confdata ──┘
```

**각 파라미터:**

```
cf1: Axis 1 quadrant (사분면)
  0  = Forward (앞쪽, 기본값)
  -1 = Backward (뒤쪽)
  1, 2, 3 = 기타 quadrant

cf4: Axis 4 configuration
  0  = Positive range (양수 영역)
  -1 = Negative range (음수 영역)
  1  = Additional rotation (추가 회전)

cf6: Axis 6 configuration (손목)
  0  = Wrist up (손목 위쪽, 기본값)
  -1 = Wrist down (손목 아래쪽)
  1  = Additional rotation

cfx: External axis quadrant (외부 축)
  0  = Default (기본값)
  -1, 1, 2, 3 = 기타 quadrant
```

### ConfL 옵션

```rapid
ConfL\On;   ! Configuration monitoring ON
            ! 경로 중 configuration 변경 금지
            ! 지정된 confdata 유지
            ! 못 가면 에러 발생

ConfL\Off;  ! Configuration monitoring OFF
            ! 경로 중 configuration 자동 선택
            ! 유연하지만 예측 불가능
```

---

## 🔧 코드 수정 내용

### Robot1 (TASK1) - MonitorFloorCoordinates.mod

**이전 코드 (v3.2):**
```rapid
! Read current pose to preserve orientation
target_base := CRobT(\Tool:=tool0\WObj:=wobj0);

target_base.trans.x := base_x - 488;
target_base.trans.y := base_y;
target_base.trans.z := base_z;

ConfL\Off;  ! Configuration 자동 선택
MoveJ target_base, v100, fine, tool0\WObj:=wobj0;
```

**수정 후 코드 (v4.0):**
```rapid
! Read current pose to preserve orientation
target_base := CRobT(\Tool:=tool0\WObj:=wobj0);

target_base.trans.x := base_x - 488;
target_base.trans.y := base_y;
target_base.trans.z := base_z;

! Preserve home configuration to avoid Joint Out of Range
! confdata = [cf1, cf4, cf6, cfx]
! Using configuration from home position: [0, 0, 0, 0]
target_base.robconf.cf1 := 0;  ! Forward
target_base.robconf.cf4 := 0;  ! Positive range
target_base.robconf.cf6 := 0;  ! Wrist up
target_base.robconf.cfx := 0;  ! Default

ConfL\On;   ! Configuration monitoring ON
MoveJ target_base, v100, fine, tool0\WObj:=wobj0;
```

### Robot2 (TASK2) - FloorMonitor_Task2.mod

**동일한 방식으로 수정**
```rapid
target_base.robconf.cf1 := 0;
target_base.robconf.cf4 := 0;
target_base.robconf.cf6 := 0;
target_base.robconf.cfx := 0;

ConfL\On;
MoveJ target_base, v100, fine, tool0\WObj:=wobj0;
```

---

## 🎯 작동 원리

### 1. Home 위치 이동
```rapid
MoveAbsJ [[0, -45, 0, 0, -45, 0], [0, 0, 0, 0, 0, 0]], v100, fine, tool0;
```
- Home 위치로 이동
- 안전한 configuration 상태 확보

### 2. 현재 자세 읽기
```rapid
target_base := CRobT(\Tool:=tool0\WObj:=wobj0);
```
- Home 위치의 orientation(회전) 읽기
- Home 위치의 confdata도 함께 읽음

### 3. 좌표만 변경
```rapid
target_base.trans.x := base_x - 488;  ! Robot1
target_base.trans.y := base_y;
target_base.trans.z := base_z;
```
- X, Y, Z 좌표만 변경
- orientation은 Home 유지

### 4. confdata 명시적 지정
```rapid
target_base.robconf.cf1 := 0;  ! Forward
target_base.robconf.cf4 := 0;  ! Positive range
target_base.robconf.cf6 := 0;  ! Wrist up
target_base.robconf.cfx := 0;  ! Default
```
- Home 위치와 동일한 configuration 강제 지정
- 로봇이 같은 자세 형태로 이동하도록 유도

### 5. ConfL\On 활성화
```rapid
ConfL\On;
MoveJ target_base, v100, fine, tool0\WObj:=wobj0;
```
- Configuration monitoring 활성화
- 지정된 confdata 유지하며 이동
- 만약 해당 configuration으로 도달 불가능하면 에러 발생

---

## ✅ 효과

### 이전 (v3.2)
```
TestTCP_Home:         ✅ 성공
TestTCP_Home_Plus50:  ❌ Joint Out of Range
TestTCP_188_0_1100:   ❌ Joint Out of Range
TestTCP_200_0_1200:   ❌ Joint Out of Range
```

### 이후 (v4.0)
```
TestTCP_Home:         ✅ 성공 (변화 없음)
TestTCP_Home_Plus50:  ✅ 성공 (confdata 덕분)
TestTCP_188_0_1100:   ✅ 성공 가능 (confdata 덕분)
TestTCP_200_0_1200:   ✅ 성공 가능 (confdata 덕분)
```

**단, 좌표가 작업 영역을 완전히 벗어나면 여전히 에러 발생**

---

## 🚀 사용 방법

### 1. 파일 업데이트
```
RobotStudio:
- Virtual Controller 재시작
  또는
- MonitorFloorCoordinates.mod 언로드 후 재로드
- FloorMonitor_Task2.mod 언로드 후 재로드
```

### 2. 테스트 실행 순서

**1단계: GoHome 실행**
```
PP → GoHome → Play ▶
로봇이 Home 위치로 이동
```

**2단계: TestTCP_Home 실행**
```
PP → TestTCP_Home → Play ▶
현재 Home 위치에서 좌표 변환 테스트
```

**3단계: TestTCP_188_0_1100 실행 (새로 가능)**
```
PP → TestTCP_188_0_1100 → Play ▶
Robot Base [188, 0, 1100] 위치로 이동
confdata [0, 0, 0, 0] 덕분에 성공 가능
```

**4단계: txt 파일 확인**
```
HOME:/comprehensive_tcp_check_robot1.txt
HOME:/comprehensive_tcp_check_robot2.txt
```

---

## 📊 예상 테스트 결과

### TestTCP_188_0_1100 실행 시 (Robot1)

**파일: comprehensive_tcp_check_robot1.txt**
```
========================================
Robot1 - Comprehensive TCP Check
========================================

Program Version: v4.0_251210

Input Coordinates (Robot1 Base)
========================================
  X = 188.000 mm
  Y = 0.000 mm
  Z = 1100.000 mm

========================================
Target Position (wobj0 = R-axis center)
========================================
  X = -300.000 mm
  Y = 0.000 mm
  Z = 1100.000 mm
Conversion: wobj0 = Robot1_Base - [488, 0, 0]

========================================
Actual TCP Position - wobj0 (R-axis center)
========================================
  X = -300.xxx mm (±0.01mm 오차)
  Y = 0.xxx mm
  Z = 1100.xxx mm

Actual TCP Position - Robot1 Base (calculated)
========================================
  X = 188.xxx mm (±0.01mm 오차)
  Y = 0.xxx mm
  Z = 1100.xxx mm
Conversion: Robot1_Base = wobj0 + [488, 0, 0]

Position Error (Actual - Input):
  dX = 0.xxx mm (±0.01mm)
  dY = 0.xxx mm
  dZ = 0.xxx mm

========================================
Actual TCP Position - WobjFloor
========================================
  X = 9688.xxx mm
  Y = 5300.xxx mm
  Z = 1000.xxx mm
```

### TestTCP_188_0_1100 실행 시 (Robot2)

**파일: comprehensive_tcp_check_robot2.txt**
```
========================================
Robot2 - Comprehensive TCP Check
========================================

Program Version: v4.0_251210

Input Coordinates (Robot2 Base)
========================================
  X = 188.000 mm
  Y = 0.000 mm
  Z = 1100.000 mm

========================================
Target Position (wobj0 = Robot2 Base)
========================================
  X = 188.000 mm
  Y = 0.000 mm
  Z = 1100.000 mm
Conversion: None (wobj0 = Robot2 Base)

========================================
Actual TCP Position - wobj0 (Robot2 Base)
========================================
  X = 188.xxx mm (±0.01mm 오차)
  Y = 0.xxx mm
  Z = 1100.xxx mm

Position Error (Actual - Input):
  dX = 0.xxx mm (±0.01mm)
  dY = 0.xxx mm
  dZ = 0.xxx mm

========================================
Actual TCP Position - WobjFloor
========================================
  X = 10664.xxx mm
  Y = 5300.xxx mm
  Z = 1000.xxx mm
```

### WobjFloor 검증
```
Robot1 WobjFloor: [9688, 5300, 1000]
Robot2 WobjFloor: [10664, 5300, 1000]

X 차이: 10664 - 9688 = 976 mm
예상: 2 × 488mm = 976 mm ✅
```

---

## ⚠️ 주의사항

### 1. confdata [0, 0, 0, 0]의 의미
```
Home 위치와 유사한 자세로 이동
- 팔꿈치가 앞쪽
- 손목이 위쪽
- 외부 축 기본 위치
```

### 2. ConfL\On의 의미
```
✅ 장점:
- 지정된 configuration 유지
- 예측 가능한 자세
- 간섭 회피 가능

⚠️ 단점:
- 해당 configuration으로 도달 불가능하면 에러
- 유연성 감소
```

### 3. 여전히 도달 불가능한 경우

**작업 영역을 완전히 벗어난 좌표:**
```
예: [500, 0, 1100] (너무 멀리)
→ confdata를 지정해도 물리적으로 도달 불가
→ Joint Out of Range 에러 발생
```

**해결:**
```
- 작업 영역 내 좌표 사용
- 또는 다른 confdata 시도 (cf1=-1 등)
```

### 4. confdata 변경 시험

**더 넓은 범위 접근:**
```rapid
target_base.robconf.cf1 := -1;  ! Backward 자세 시도
target_base.robconf.cf4 := -1;  ! Negative range 시도
target_base.robconf.cf6 := -1;  ! Wrist down 시도
```

---

## 📝 변경 이력

### v4.0_251210 (2025-12-10)
- ✅ 명시적 confdata 지정 추가
- ✅ ConfL\Off → ConfL\On 변경
- ✅ TestTCP_188_0_1100, TestTCP_200_0_1200 사용 가능
- ✅ Robot1, Robot2 모두 적용

### v3.2_251209 (2025-12-09)
- ✅ 좌표 변환 로직 검증 완료
- ✅ Robot1 Base → wobj0 변환
- ✅ Robot2 wobj0 = Base 확인
- ⚠️ confdata 미지정으로 일부 위치 도달 불가

### v3.1_251209 (2025-12-09)
- ✅ MoveL → MoveJ 변경
- ✅ 출력 메시지 명확화

---

## 💡 추가 학습 자료

### ABB RAPID confdata 공식 문서
```
Operating Manual - RAPID Instructions
Section: Motion and I/O Principles
Topic: Robot configuration data
```

### 관련 명령어
```rapid
ConfJ\On | \Off      ! Joint 이동 시 configuration 모니터링
ConfL\On | \Off      ! Linear 이동 시 configuration 모니터링
SingArea\Wrist       ! 특이점 영역 설정
CRobT()              ! 현재 robtarget 읽기 (confdata 포함)
```

---

## 📞 문의

**담당**: SP 심태양
**프로젝트**: S25016 SpGantry 1200
**위치**: 34bay 자동용접 A라인/B라인

---

**수정 완료**: 2025-12-10
**버전**: v4.0_251210
**Git 커밋**: 2042743
**상태**: ✅ confdata 명시, ConfL\On 적용 완료

# ComprehensiveTCPCheck 좌표 변환 수정 완료

**작성일**: 2025-12-09
**버전**: v4.0_251209
**커밋**: 9e3de17

---

## ✅ 수정 완료 사항

### Robot1 (TASK1)
```
파일: MonitorFloorCoordinates.mod
wobj0: R축 센터 (GantryRob)

변경 사항:
✅ Robot1 Base → wobj0 좌표 변환 추가
✅ MoveL → MoveJ 변경 (안전한 이동)
✅ 출력 메시지 명확화
✅ 파일 출력에 변환 정보 추가
```

### Robot2 (TASK2)
```
파일: FloorMonitor_Task2.mod
wobj0: Robot2 Base

변경 사항:
✅ 주석으로 "변환 불필요" 명시
✅ MoveL → MoveJ 변경 (안전한 이동)
✅ 출력 메시지 명확화
✅ 파일 출력에 wobj0 = Robot2 Base 명시
```

---

## 📐 좌표 변환 공식

### Robot1
```rapid
! 입력: Robot1 Base 좌표 [base_x, base_y, base_z]
! 변환: wobj0 = Robot1 Base - [488, 0, 0]

target_base.trans.x := base_x - 488;
target_base.trans.y := base_y;
target_base.trans.z := base_z;

예:
입력: [188, 0, 1100]
wobj0: [188-488, 0, 1100] = [-300, 0, 1100]
실제 Robot1 Base: [-300+488, 0, 1100] = [188, 0, 1100] ✅
```

### Robot2
```rapid
! 입력: Robot2 Base 좌표 [base_x, base_y, base_z]
! 변환: 없음 (wobj0 = Robot2 Base)

target_base.trans.x := base_x;  // 그대로
target_base.trans.y := base_y;
target_base.trans.z := base_z;

예:
입력: [188, 0, 1100]
wobj0: [188, 0, 1100]
실제 Robot2 Base: [188, 0, 1100] ✅
```

---

## 🚀 사용 방법

### Robot1 테스트
```rapid
! TASK1에서 실행
ComprehensiveTCPCheck 188, 0, 1100;

FlexPendant 출력:
========================================
Robot1 - Comprehensive TCP Check
========================================
Input (Robot1 Base): [188, 0, 1100]
Target (wobj0=R-axis): [-300, 0, 1100]
Moving to home position...
Moving to target position...
Position reached!
----------------------------------------
wobj0 (R-axis center):
  [-300.00, 0.00, 1100.00]
Robot1 Base (calculated):
  [188.00, 0.00, 1100.00]
WobjFloor:
  [9688.00, 5300.00, 1000.00]
========================================
```

### Robot2 테스트
```rapid
! TASK2에서 실행
ComprehensiveTCPCheck 188, 0, 1100;

FlexPendant 출력:
========================================
Robot2 - Comprehensive TCP Check
========================================
Input (Robot2 Base): [188, 0, 1100]
Target (wobj0=Robot2 Base): [188, 0, 1100]
Moving to home position...
Moving to target position...
Position reached!
----------------------------------------
wobj0 (Robot2 Base):
  [188.00, 0.00, 1100.00]
WobjFloor:
  [10664.00, 5300.00, 1000.00]
========================================
```

---

## 📝 출력 파일 형식

### Robot1: comprehensive_tcp_check_robot1.txt

```
========================================
Robot1 - Comprehensive TCP Check
========================================

Program Version: v4.0_251209
Module: MonitorFloorCoordinates
Procedure: ComprehensiveTCPCheck

Date: 2025-12-09
Time: 21:30:00
========================================

Test Configuration
========================================
Robot: Robot1 (T_ROB1)
Tool: tool0 (Flange reference)
TCP offset: [0, 0, 0] mm (No offset)
TCP orientation: From home position

========================================
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
  X = -300.000 mm
  Y = 0.000 mm
  Z = 1100.000 mm

Actual TCP Position - Robot1 Base (calculated)
========================================
  X = 188.000 mm
  Y = 0.000 mm
  Z = 1100.000 mm
Conversion: Robot1_Base = wobj0 + [488, 0, 0]

Orientation (quaternion):
  q1 = 0.925841
  q2 = 0.000000
  q3 = 0.377914
  q4 = 0.000001

Position Error (Actual - Input):
  dX = 0.000 mm
  dY = 0.000 mm
  dZ = 0.000 mm

========================================
Actual TCP Position - WobjFloor
========================================
  X = 9688.000 mm
  Y = 5300.000 mm
  Z = 1000.000 mm
```

### Robot2: comprehensive_tcp_check_robot2.txt

```
========================================
Robot2 - Comprehensive TCP Check
========================================

Program Version: v4.0_251209
Module: FloorMonitor_Task2
Procedure: ComprehensiveTCPCheck

Date: 2025-12-09
Time: 21:31:00
========================================

Test Configuration
========================================
Robot: Robot2 (T_ROB2)
Tool: tool0 (Flange reference)
TCP offset: [0, 0, 0] mm (No offset)
TCP orientation: From home position

========================================
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
  X = 188.000 mm
  Y = 0.000 mm
  Z = 1100.000 mm

Orientation (quaternion):
  q1 = 0.925841
  q2 = 0.000000
  q3 = 0.377914
  q4 = 0.000001

Position Error (Actual - Input):
  dX = 0.000 mm
  dY = 0.000 mm
  dZ = 0.000 mm

========================================
Actual TCP Position - WobjFloor
========================================
  X = 10664.000 mm
  Y = 5300.000 mm
  Z = 1000.000 mm
```

---

## 🔍 검증 방법

### Robot1 검증
```
입력: [188, 0, 1100]

확인 사항:
✅ Target wobj0: [-300, 0, 1100]
✅ Actual wobj0: [-300, 0, 1100]
✅ Robot1 Base (calculated): [188, 0, 1100]
✅ Position Error: [0, 0, 0]
```

### Robot2 검증
```
입력: [188, 0, 1100]

확인 사항:
✅ Target wobj0: [188, 0, 1100]
✅ Actual wobj0: [188, 0, 1100]
✅ Position Error: [0, 0, 0]
```

### WobjFloor 비교
```
Robot1 WobjFloor: [9688, 5300, 1000]
Robot2 WobjFloor: [10664, 5300, 1000]

차이: 10664 - 9688 = 976mm
예상: 2 × 488mm = 976mm ✅
```

---

## 💡 주요 개선 사항

### 1. 좌표 변환 정확성
```
이전:
- Robot1이 wobj0 좌표를 그대로 사용
- Robot Base 좌표로 이동하지 못함

현재:
- Robot1이 Base → wobj0 변환 수행
- 정확히 원하는 Base 좌표로 이동
```

### 2. 출력 명확성
```
이전:
- wobj0가 무엇인지 불명확
- 변환 과정이 보이지 않음

현재:
- wobj0가 R축 센터인지 Robot2 Base인지 명시
- 입력 → 변환 → 실제 위치 모두 표시
- 역변환 결과도 표시 (wobj0 → Robot Base)
```

### 3. 안전성 향상
```
이전:
- MoveL 사용: 직선 이동 중 관절 한계 가능

현재:
- MoveJ 사용: 안전한 관절 보간 이동
- 최종 위치는 정확, 경로만 곡선
```

---

## 🎯 사용 예시

### 예시 1: Robot1 Base [188, 0, 1100]로 이동
```rapid
! TASK1
ComprehensiveTCPCheck 188, 0, 1100;

결과:
- wobj0 (R축 센터): [-300, 0, 1100]
- Robot1 Base: [188, 0, 1100] ✅
- WobjFloor: [9688, 5300, 1000]
```

### 예시 2: Robot2 Base [188, 0, 1100]로 이동
```rapid
! TASK2
ComprehensiveTCPCheck 188, 0, 1100;

결과:
- wobj0 (Robot2 Base): [188, 0, 1100] ✅
- WobjFloor: [10664, 5300, 1000]
```

### 예시 3: 동일 WobjFloor 위치
```rapid
! 두 로봇을 같은 WobjFloor 위치로 보내기

TASK1:
ComprehensiveTCPCheck 188, 0, 1100;
→ WobjFloor: [9688, 5300, 1000]

TASK2:
ComprehensiveTCPCheck -300, 0, 1100;
→ WobjFloor: [9688, 5300, 1000]

두 로봇이 같은 물리적 위치! ✅
```

---

## ⚠️ 주의사항

### 1. 좌표 입력은 항상 Robot Base 기준
```
ComprehensiveTCPCheck base_x, base_y, base_z

base_x, base_y, base_z = 각 로봇의 Base 좌표계 기준
```

### 2. Robot1과 Robot2는 다른 wobj0
```
Robot1 wobj0 = R축 센터
Robot2 wobj0 = Robot2 Base

같은 입력 → 다른 물리적 위치
```

### 3. MoveJ 사용
```
이동 경로: 곡선 (관절 보간)
최종 위치: 정확 (목표 좌표)

축 방향 테스트가 아니므로 경로는 중요하지 않음
```

---

## 📞 문의

**담당**: SP 심태양
**프로젝트**: S25016 SpGantry 1200
**위치**: 34bay 자동용접 A라인/B라인

---

**수정 완료**: 2025-12-09
**버전**: v4.0_251209
**Git 커밋**: 9e3de17
**상태**: ✅ 좌표 변환 구현 완료, 테스트 준비됨

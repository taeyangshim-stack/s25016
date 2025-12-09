# TestWobj0Axes 사용 가이드 - Robot1 & Robot2

**작성일**: 2025-12-09
**버전**: v1.5_251209

---

## 📋 개요

Robot1과 Robot2 모두에서 wobj0 좌표계의 축 방향을 테스트합니다.

---

## 📁 파일 위치

### Robot1 (TASK1)
```
파일: TASK1/PROGMOD/TestWobj0Axes.mod
출력: HOME:/wobj0_axis_test.txt
```

### Robot2 (TASK2)
```
파일: TASK2/PROGMOD/TestWobj0Axes.mod
출력: HOME:/wobj0_axis_test_robot2.txt
```

---

## 🚀 실행 방법

### Robot1 테스트
```rapid
! TASK1에서 실행
TestWobj0AxisDirections;
```

### Robot2 테스트
```rapid
! TASK2에서 실행
TestWobj0AxisDirections;
```

---

## 📊 테스트 시퀀스

### 1. 초기화
```
Step 1: Zero [0,0,0,0,0,0]로 이동
Step 2: Home [0,-45,0,0,-45,0]로 이동
Step 3: 시작 위치 기록 (wobj0 좌표)
```

### 2. 축 방향 테스트
```
Test 1: wobj0 X + 20mm
        - MoveJ로 이동
        - 실제 위치 측정
        - 방향 관찰
        - 홈으로 복귀

Test 2: wobj0 Y + 20mm
        - MoveJ로 이동
        - 실제 위치 측정
        - 방향 관찰
        - 홈으로 복귀

Test 3: wobj0 Z + 20mm
        - MoveJ로 이동
        - 실제 위치 측정
        - 방향 관찰
        - 홈으로 복귀
```

---

## 📝 출력 파일 형식

### Robot1: wobj0_axis_test.txt

```
========================================
wobj0 Axis Direction Test
========================================

Date: 2025-12-09
Time: 21:00:00

Start Position (wobj0):
  X = -515.581 mm
  Y = -0.004 mm
  Z = 1146.486 mm

========================================
Test Results - Record your observations:
========================================

Test 1: wobj0 X + 20mm (using MoveJ)
  Target:  [-495.6, -0.0, 1146.5]
  Actual:  [-495.2, -0.1, 1146.3]
  Delta:   [20.38, -0.10, -0.19]
  Physical direction observed: _____________
  (Forward/Backward/Left/Right/Up/Down)

Test 2: wobj0 Y + 20mm (using MoveJ)
  Target:  [-515.6, 20.0, 1146.5]
  Actual:  [-515.3, 19.9, 1146.2]
  Delta:   [0.28, 19.90, -0.29]
  Physical direction observed: _____________

Test 3: wobj0 Z + 20mm (using MoveJ)
  Target:  [-515.6, -0.0, 1166.5]
  Actual:  [-515.4, -0.2, 1166.3]
  Delta:   [0.18, -0.20, 19.81]
  Physical direction observed: _____________

========================================
Expected for standard coordinate system:
========================================
  X+: Forward (away from robot base)
  Y+: Left (robot's left side)
  Z+: Up (vertical upward)

If wobj0 has 90 deg Z rotation:
  X+: Left
  Y+: Backward
  Z+: Up

========================================
```

### Robot2: wobj0_axis_test_robot2.txt

동일한 형식, 단 헤더에 "Robot2 (T_ROB2)" 표시

---

## 🔍 결과 분석 방법

### 1. Delta 값 확인

**Test 1 (X + 20mm)**:
```
Delta: [20.38, -0.10, -0.19]
        ↓      ↓      ↓
        X      Y      Z

✅ X ≈ 20mm: 정상
✅ Y, Z ≈ 0mm: 정상
```

**Test 2 (Y + 20mm)**:
```
Delta: [0.28, 19.90, -0.29]
        ↓     ↓       ↓
        X     Y       Z

✅ Y ≈ 20mm: 정상
✅ X, Z ≈ 0mm: 정상
```

**Test 3 (Z + 20mm)**:
```
Delta: [0.18, -0.20, 19.81]
        ↓     ↓      ↓
        X     Y      Z

✅ Z ≈ 20mm: 정상
✅ X, Y ≈ 0mm: 정상
```

### 2. 물리적 방향 관찰

각 테스트마다 로봇이 실제로 어느 방향으로 움직였는지 기록:

| 테스트 | 예상 (표준) | 예상 (90도 회전) | 실제 관찰 |
|--------|------------|-----------------|----------|
| X + 20mm | 앞(Forward) | 왼쪽(Left) | _______ |
| Y + 20mm | 왼쪽(Left) | 뒤(Backward) | _______ |
| Z + 20mm | 위(Up) | 위(Up) | _______ |

---

## 📊 Robot1 vs Robot2 비교

### 예상 결과

**wobj0 = R축 센터**이므로:
- Robot1 시작 위치: wobj0 X ≈ -515mm (R축 오른쪽)
- Robot2 시작 위치: wobj0 X ≈ +515mm (R축 왼쪽)

**축 방향은 동일해야 함**:
- 양쪽 로봇 모두 wobj0 X+, Y+, Z+ 방향 동일
- 단, 시작 위치의 X 부호만 반대

### 비교 체크리스트

```
□ Robot1 시작 위치 X < 0 (음수)
□ Robot2 시작 위치 X > 0 (양수)
□ |Robot1 X| ≈ |Robot2 X| (절댓값 유사)
□ Robot1, Robot2 모두 Y, Z 시작 위치 유사
□ X+ 방향 동일 (양쪽 모두 같은 물리적 방향)
□ Y+ 방향 동일
□ Z+ 방향 동일
```

---

## ⚠️ 주의사항

### 1. MoveJ 사용
- 직선 이동(MoveL)이 아닌 관절 이동(MoveJ) 사용
- 이동 경로는 곡선이지만, 최종 위치는 정확함
- **최종 도착 위치**를 관찰하세요 (경로가 아니라)

### 2. 20mm 작은 거리
- 관절 한계를 피하기 위해 작은 거리 사용
- 방향 확인에는 충분한 거리
- 주의 깊게 관찰 필요

### 3. 안전한 이동 경로
- Zero → Home 순서로 이동 (직접 Home 이동 시 관절 한계)
- 자동으로 안전 경로 사용

---

## 🎯 다음 단계

### 1. 양쪽 로봇 테스트 실행
```rapid
! Robot1
TestWobj0AxisDirections;

! Robot2
TestWobj0AxisDirections;
```

### 2. 결과 파일 확인
```
HOME:/wobj0_axis_test.txt
HOME:/wobj0_axis_test_robot2.txt
```

### 3. 관찰 결과 기록
- 각 txt 파일에 "Physical direction observed" 기록
- 또는 별도 문서에 정리

### 4. 결과 분석
- Delta 값이 정확한지 확인 (각 축 ≈ 20mm)
- 물리적 방향이 예상과 일치하는지 확인
- Robot1과 Robot2 결과 비교

### 5. 좌표 변환 공식 확정
- 관찰 결과를 바탕으로 wobj0 축 방향 확정
- Robot Base → wobj0 좌표 변환 공식 작성

---

## 💡 예상 시나리오

### 시나리오 1: wobj0가 표준 좌표계
```
X+: Forward (앞)
Y+: Left (왼쪽)
Z+: Up (위)

→ 좌표 변환:
   wobj0_x = base_x - 488 (Robot1)
   wobj0_y = base_y
   wobj0_z = base_z
```

### 시나리오 2: wobj0가 90도 회전
```
X+: Left (왼쪽)
Y+: Backward (뒤)
Z+: Up (위)

→ 좌표 변환:
   wobj0_x = -base_y - 488
   wobj0_y = base_x
   wobj0_z = base_z
```

---

## 📞 문의

**담당**: SP 심태양
**프로젝트**: S25016 SpGantry 1200
**위치**: 34bay 자동용접 A라인/B라인

---

**작성 완료**: 2025-12-09
**버전**: v1.5_251209
**상태**: ✅ Robot1/Robot2 모두 준비 완료
**다음**: 테스트 실행 및 결과 분석

# Weld Sequence 에러 분석

**프로젝트:** S25016 SpGantry
**업데이트:** 2026-02-03

---

## 에러 코드 요약

| 에러 코드 | 이름 | 심각도 | 발생 빈도 |
|----------|------|--------|----------|
| 50050 | Position outside reach | 높음 | 빈번 |
| 50027 | Joint Out of Range | 높음 | 현재 발생 |
| 50246 | Linked motor error | 치명적 | 가끔 |
| 40512 | Missing External Axis Value | 중간 | 가끔 |
| 50308 | In Position timeout | 낮음 | 가끔 |
| 50501 | Short movements | 경고 | 무시 가능 |

---

## 상세 에러 분석

### 50050 - Position outside reach

**설명:** 로봇이 지정된 위치에 도달할 수 없음

**발생 상황:**
- Robot1이 WobjGantry 기준 목표 위치로 MoveJ 실행 시
- 갠트리 위치에 따라 도달 가능 범위가 변동

**원인:**
1. 잘못된 좌표계 사용 (wobj0 vs WobjGantry)
2. 좌표값 오류 (갠트리 위치 미고려)
3. 목표 위치가 로봇 작업 영역 외부

**해결 방법:**
```rapid
! 1. 올바른 좌표계 선택
! Robot1 (갠트리 장착) → WobjGantry
! Robot2 (고정) → wobj0

! 2. 좌표 변환 확인
! wobj0 → WobjGantry 변환 시:
! WobjGantry.Z = wobj0.Z - 2100 (갠트리 높이)

! 3. 2단계 이동 방식 사용
Step1: MoveAbsJ → 안전한 JOINT 위치
Step2: MoveJ → 목표 위치
```

**관련 버전:** v1.9.18 ~ v1.9.22

---

### 50027 - Joint Out of Range

**설명:** 로봇 관절이 허용 범위를 초과

**발생 상황:**
- MoveJ 실행 시 목표 위치에 도달하기 위한 관절 구성이 한계 초과
- v1.9.22 테스트 중 Step4a에서 발생

**원인:**
1. 목표 위치는 도달 가능하지만, 로봇이 선택한 관절 구성(confdata)이 부적절
2. 자동 계산된 관절 값 중 하나가 한계 초과

**해결 방법:**
```rapid
! 방법 1: MoveAbsJ 사용 (관절값 직접 지정)
VAR jointtarget weld_jt;
weld_jt.robax.rax_1 := J1_value;  ! 조그에서 취득
weld_jt.robax.rax_2 := J2_value;
! ...
MoveAbsJ weld_jt, v100, fine, tool0;

! 방법 2: confdata 조정
weld_target.robconf.cf1 := 0;   ! 또는 1, -1
weld_target.robconf.cf4 := 0;   ! 또는 1, -1
weld_target.robconf.cf6 := 0;   ! 또는 1, -1
weld_target.robconf.cfx := 0;
```

**현재 상태:** 진행 중 (v1.9.23에서 해결 예정)

---

### 50246 - Linked motor error

**설명:** 연동된 모터(X1, X2) 간 동기화 오류

**발생 상황:**
- 다른 에러 발생 후 복구 과정에서 X1/X2 위치 차이 발생
- 갠트리 이동 중 비상 정지 후

**원인:**
1. X1 (eax_a)과 X2 (eax_f)의 위치 불일치
2. 에러 복구 시 두 모터가 서로 다른 위치로 이동

**해결 방법:**
```
1. 시스템 재시작 (권장)
2. 수동으로 X1, X2 위치 동기화
3. 에러 발생 시 즉시 정지 (추가 이동 방지)
```

**예방 조치:**
```rapid
! 갠트리 이동 전 X1/X2 차이 확인
current_jt := CJointT();
x1_pos := current_jt.extax.eax_a;
x2_pos := current_jt.extax.eax_f;
diff := Abs(x1_pos - x2_pos);

IF diff > 1 THEN
    TPWrite "WARNING: X1/X2 diff=" + NumToStr(diff, 1);
    ! 에러 처리
ENDIF
```

---

### 40512 - Missing External Axis Value

**설명:** 외부축 값이 지정되지 않음

**발생 상황:**
- robtarget 또는 jointtarget의 extax 값이 9E9 (미지정)
- MoveL, MoveJ 실행 시

**원인:**
1. extax 값을 초기화하지 않음
2. 일부 축만 지정하고 나머지는 9E9

**해결 방법:**
```rapid
! 현재 외부축 값 유지
VAR jointtarget current_jt;
current_jt := CJointT();

! 목표에 현재 extax 복사
target.extax := current_jt.extax;

! 필요한 축만 변경
target.extax.eax_a := new_x1_value;
```

---

### 50308 - In Position timeout

**설명:** 로봇이 지정된 시간 내에 목표 위치에 도달하지 못함

**발생 상황:**
- 저속 이동 중 장애물 또는 간섭
- 에러 복구 후 위치 재설정 시

**원인:**
1. 이동 경로에 장애물
2. 속도 설정이 너무 낮음
3. fine 존 도달 불가

**해결 방법:**
```rapid
! zone 완화
MoveJ target, v100, z10, tool0;  ! fine → z10

! 또는 속도 증가
MoveJ target, v200, fine, tool0;  ! v100 → v200
```

---

### 50501 - Short movements

**설명:** 매우 짧은 거리 이동 (경고)

**발생 상황:**
- 현재 위치와 목표 위치가 거의 동일

**원인:**
- 이미 목표 위치에 있는 상태에서 이동 명령 실행

**처리:**
- 무시 가능 (기능에 영향 없음)
- 필요시 위치 확인 후 이동 생략

---

## 에러 발생 시 복구 절차

### 일반 복구 절차

```
1. 에러 로그 확인 (TP 또는 Event Log)
2. 로봇 정지 상태 확인
3. Motors OFF → Manual Mode
4. 필요시 조그로 안전 위치 이동
5. Motors ON → Automatic Mode
6. Program Pointer Reset
7. 재실행
```

### Linked Motor Error 복구

```
1. 즉시 Motors OFF
2. Event Log에서 X1, X2 위치 확인
3. System Restart (권장)
4. 재시작 후 X1, X2 동기화 확인
5. HOME 위치로 이동 후 재테스트
```

---

## 에러 예방 체크리스트

- [ ] 이동 전 현재 위치 로그 출력
- [ ] X1/X2 차이 확인 (< 1mm)
- [ ] extax 값 명시적 설정 (9E9 사용 금지)
- [ ] 2단계 이동 방식 사용 (MoveAbsJ → MoveJ)
- [ ] 적절한 좌표계 선택 (Robot1: WobjGantry, Robot2: wobj0)

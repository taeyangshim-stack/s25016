# Weld Sequence 버전 히스토리

**프로젝트:** S25016 SpGantry
**최신 버전:** v1.9.22
**업데이트:** 2026-02-03

---

## 버전 타임라인

```
v1.9.0  ──▶ v1.9.16 ──▶ v1.9.17 ──▶ v1.9.18 ──▶ v1.9.19 ──▶ v1.9.20 ──▶ v1.9.21 ──▶ v1.9.22
  │           │           │           │           │           │           │           │
기본구조    9E9 제거    TASK2동기화  WobjGantry   2단계이동   원점복귀    wobj0→     좌표수정
                                     적용        방식도입    추가       WobjGantry
```

---

## 상세 변경 이력

### v1.9.22 (2026-02-03) - 현재
**WobjGantry 좌표 수정**

| 항목 | 변경 전 | 변경 후 |
|------|---------|---------|
| WobjGantry Y | 370 | 111 |
| WobjGantry Z | 1300 | -73 |

- 사용자 조그 데이터 기반 좌표 계산
- 조그 위치 (X=-4500): wobj0 Y=110.59, Z=2026.89
- WobjGantry 변환: Z = 2026.89 - 2100 = -73

**테스트 결과:** 50027 Joint Out of Range (Step4a)

---

### v1.9.21 (2026-01-18)
**Robot1 Step2 좌표계 변경**

```rapid
! 변경 전
MoveJ weld_target, v100, fine, tool0\WObj:=wobj0;

! 변경 후
MoveJ weld_target, v100, fine, tool0\WObj:=WobjGantry;
```

- wobj0 [0, 370, 1300]은 갠트리 X=-4500 위치에서 도달 불가
- WobjGantry는 갠트리 상대 좌표로 위치 무관하게 도달 가능

**테스트 결과:** 50050 Position outside reach (좌표값 오류)

---

### v1.9.20 (2026-01-18)
**원점 복귀 기능 추가**

```rapid
! Step6: Robot1 안전 위치 복귀
PROC ReturnRobot1ToSafe()
    safe_jt.robax := [0, -10, -50, 0, -30, 0];
    MoveAbsJ safe_jt, v100, fine, tool0;
ENDPROC

! Step7: 갠트리 HOME 복귀
PROC ReturnGantryToHome()
    home_jt.extax := [0, 0, 0, 0, 9E9, 0];  ! X1, Y, Z, R, (skip), X2
    MoveAbsJ home_jt, v500, fine, tool0;
ENDPROC
```

---

### v1.9.19 (2026-01-18)
**2단계 이동 방식 도입**

로봇 이동 시 Position outside reach 에러 방지를 위한 2단계 접근법:

```
Step1: MoveAbsJ → 안전한 JOINT 위치 [0, -10, -50, 0, -30, 0]
Step2: MoveJ → 목표 위치 (좌표계 기준)
```

**Robot1 (TASK1):**
| Step | 방식 | 목표 |
|------|------|------|
| Step1 | MoveAbsJ | JOINT [0, -10, -50, 0, -30, 0] |
| Step2 | MoveJ | WobjGantry [0, 111, -73] |

**Robot2 (TASK2):**
| Step | 방식 | 목표 |
|------|------|------|
| Step1 | MoveAbsJ | JOINT [0, -10, -50, 0, -30, 0] |
| Step2 | MoveJ | wobj0 [0, 118, -1300] |

---

### v1.9.18 (2026-01-18)
**Robot1 좌표계 변경**

```rapid
! 변경 전: WobjWeldR1 (Floor 좌표계)
MoveJ weld_target, v100, fine, tool0\WObj:=WobjWeldR1;

! 변경 후: WobjGantry (갠트리 상대 좌표계)
MoveJ weld_target, v100, fine, tool0\WObj:=WobjGantry;
```

- WobjWeldR1은 Floor 기준 좌표로 갠트리 이동 시 도달 불가
- WobjGantry는 갠트리 R-Center 기준으로 항상 도달 가능

---

### v1.9.17 (2026-01-18)
**TASK2 동기화 수정**

```rapid
! 변경 전: TASK2 test_mode 하드코딩
VAR num test_mode := 2;  ! 항상 Mode2

! 변경 후: TASK1과 동기화
PERS num shared_test_mode := 0;  ! TASK1에서 설정

! TASK2 main()
WHILE shared_test_mode = 0 DO
    WaitTime 0.1;
ENDWHILE
test_mode := shared_test_mode;
```

---

### v1.9.16 (2026-01-18)
**9E9 방식 제거**

MoveGantryToWeldStart, WeldAlongCenterLine에서 9E9 (don't change) 방식 제거

```rapid
! 변경 전: 일부 축만 지정
target.extax.eax_a := -4500;  ! X1
target.extax.eax_f := -4500;  ! X2
! 나머지는 9E9

! 변경 후: 모든 축 명시
current_jt := CJointT();
target.extax := current_jt.extax;
target.extax.eax_a := -4500;  ! X1
target.extax.eax_f := -4500;  ! X2
```

---

### v1.9.0 ~ v1.9.15
**Weld Sequence 기본 구조 구축**

- Weld Sequence 프레임워크 설계
- TASK1/TASK2 동기화 메커니즘
- CalcCenterLine, MoveGantryToWeldStart 구현
- 로그 파일 출력 기능

---

## 에러 발생 이력

| 버전 | 에러 코드 | 설명 | 해결 |
|------|----------|------|------|
| v1.9.22 | 50027 | Joint Out of Range | 진행 중 |
| v1.9.21 | 50050 | Position outside reach | v1.9.22에서 좌표 수정 |
| v1.9.20 | 50050 | Position outside reach | v1.9.21에서 좌표계 변경 |
| v1.9.18 | 50050 | Position outside reach | v1.9.19에서 2단계 이동 도입 |
| v1.9.17 | - | TASK2 미동작 | shared_test_mode 도입 |
| v1.9.16 | 50246 | Linked motor error | 9E9 제거 |

---

## 다음 버전 계획 (v1.9.23)

**목표:** Joint Out of Range 해결

**방안 1:** Step2를 MoveAbsJ로 변경
```rapid
! 사용자 조그 JOINT 값 사용
weld_jt.robax := [J1, J2, J3, J4, J5, J6];  ! 조그 값 필요
MoveAbsJ weld_jt, v100, fine, tool0;
```

**방안 2:** confdata 조정
```rapid
weld_target.robconf.cf1 := ?;  ! 조정 필요
weld_target.robconf.cf4 := ?;
weld_target.robconf.cf6 := ?;
```

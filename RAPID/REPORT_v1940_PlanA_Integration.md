# S25016 PlanA-PlanB 변수 통합 보고서

> **버전**: v1.9.40
> **일시**: 2026-02-06
> **작성자**: Claude Opus 4.5
> **Git Commit**: `33330a3`

---

## 1. 개요

### 1.1 프로젝트 정보
| 항목 | 내용 |
|------|------|
| 프로젝트명 | S25016 SpGantry 1200 |
| 대상 버전 | v1.9.39 → v1.9.40 |
| 작업 일시 | 2026-02-06 |
| 작업 유형 | 대규모 변수 통합 |

### 1.2 작업 목적
PlanA 상위 시스템 UI와 **100% 호환**되도록 PlanB RAPID 코드의 변수 구조를 통합

### 1.3 배경
- PlanA: 기존 상위 시스템 (UI, 명령 인터페이스)
- PlanB: 새로 개발된 RAPID 코드 (갠트리 로봇 제어)
- **문제**: PlanA UI가 기대하는 변수명/구조와 PlanB 구현이 불일치
- **해결**: PlanB 코드에 PlanA 호환 변수 추가 및 네이밍 통일

---

## 2. 변경 범위 요약

### 2.1 정량적 요약

| 구분 | 변경 수 | 비고 |
|------|:-------:|------|
| 변수명 변경 | 16개 | PlanA 네이밍 규칙 적용 |
| 새 PERS 변수 | ~50개 | 플래그, 파라미터, 포지션 등 |
| 새 CMD 상수 | 13개 | 명령 코드 추가 |
| 새 RECORD | 4개 | 데이터 구조체 |
| 40-step 데이터 | 121개 | welddata, weavedata, trackdata |
| Auto/Manual 매크로 | 8개 | 용접 매크로 배열 |
| **총계** | **~200개** | |

### 2.2 Git 변경 통계
```
6 files changed, 1532 insertions(+), 19 deletions(-)
```

---

## 3. 수정 파일 목록

### 3.1 RAPID 모듈

| 파일명 | 경로 | 변경 유형 |
|--------|------|----------|
| ConfigModule.mod | TASK1/PROGMOD/ | 대규모 수정 |
| ConfigModule.mod.backup_v1939 | TASK1/PROGMOD/ | 신규 (백업) |
| VersionModule.mod | TASK1/PROGMOD/ | 버전 업데이트 |
| Head_Data.mod | TASK4/PROGMOD/ | CMD 상수 동기화 |
| Head_Data.mod | TASK8/PROGMOD/ | CMD 상수 동기화 |

### 3.2 시스템 설정

| 파일명 | 경로 | 변경 유형 |
|--------|------|----------|
| SYS.cfg | SYSPAR/ | T_Head task 추가 |

---

## 4. 기술 상세

### 4.1 새 RECORD 정의 (4개)

#### breakpoint
```rapid
RECORD breakpoint
    pos Position;      ! X, Y, Z 좌표
    num Angle;         ! 각도
ENDRECORD
```
**용도**: 용접 경로의 꺾임점 정의

#### jointgroup
```rapid
RECORD jointgroup
    jointtarget Joint1;    ! 로봇1 조인트
    jointtarget Joint2;    ! 로봇2 조인트
    jointtarget JointG;    ! 갠트리 조인트
ENDRECORD
```
**용도**: 3개 축(ROB1, ROB2, 갠트리) 동기 조인트 목표

#### pointgroup
```rapid
RECORD pointgroup
    robtarget Point1;    ! 로봇1 위치
    robtarget Point2;    ! 로봇2 위치
    robtarget PointG;    ! 갠트리 위치
ENDRECORD
```
**용도**: 3개 축 동기 카르테시안 목표

#### monRobs
```rapid
RECORD monRobs
    extjoint monExt;       ! 외부축 상태
    robjoint monJoint1;    ! 로봇1 조인트 상태
    robjoint monJoint2;    ! 로봇2 조인트 상태
    pose monPose1;         ! 로봇1 포즈
    pose monPose2;         ! 로봇2 포즈
ENDRECORD
```
**용도**: 모니터링용 로봇 상태 구조체

---

### 4.2 새 CMD 상수 (13개)

#### Movement 계열 (2개)
| 상수명 | 값 | 설명 |
|--------|:--:|------|
| `CMD_MOVE_TO_TEACHING_All` | 104 | 전체 티칭 위치 이동 |
| `CMD_MOVE_JOINTS` | 107 | 조인트 직접 이동 |

#### Camera 개별 제어 (8개)
| 상수명 | 값 | 설명 |
|--------|:--:|------|
| `CMD_CAMERA1_DOOR_OPEN` | 311 | 카메라1 도어 열기 |
| `CMD_CAMERA1_DOOR_CLOSE` | 312 | 카메라1 도어 닫기 |
| `CMD_CAMERA1_BLOW_ON` | 313 | 카메라1 에어블로우 ON |
| `CMD_CAMERA1_BLOW_OFF` | 314 | 카메라1 에어블로우 OFF |
| `CMD_CAMERA2_DOOR_OPEN` | 321 | 카메라2 도어 열기 |
| `CMD_CAMERA2_DOOR_CLOSE` | 322 | 카메라2 도어 닫기 |
| `CMD_CAMERA2_BLOW_ON` | 323 | 카메라2 에어블로우 ON |
| `CMD_CAMERA2_BLOW_OFF` | 324 | 카메라2 에어블로우 OFF |

#### Wire 계열 (3개)
| 상수명 | 값 | 설명 |
|--------|:--:|------|
| `CMD_WIRE_BULLSEYE_CHECK` | 505 | 불스아이 검사 |
| `CMD_WIRE_BULLSEYE_UPDATE` | 506 | 불스아이 업데이트 |
| `CMD_WIRE_ReplacementMode` | 507 | 와이어 교체 모드 |

---

### 4.3 40-Step 데이터 구조

#### welddata 배열 (wd1 ~ wd40)
```rapid
PERS welddata wd1 := [10,0,[5,0,36.5,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd2 := [10,0,[5,0,36.5,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd3 := [10,0,[5,0,36.5,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd4 := [10,0,[5,0,36.5,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
! wd5 ~ wd40: 초기값 0
```
**구조**: `[heat, speed, [9-params], [9-params]]`
- heat: 열 입력
- speed: 용접 속도
- 9-params: 용접 파라미터 배열

#### weavedata 배열 (weave1 ~ weave40)
```rapid
PERS weavedata weave1 := [1,2,2.5,1.7,0,0,0,0,0,0,0,0,0,0,0];
! weave5 ~ weave40: 초기값 0
```
**구조**: `[shape, type, length, width, dwellL, dwellR, bias, ...]` (15 params)
- shape: 위빙 형상 (1=삼각파)
- type: 위빙 타입
- length/width: 위빙 주기/폭

#### trackdata 배열 (track0 ~ track40)
```rapid
PERS trackdata track0 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track1 := [0,FALSE,50,[0,15,30,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
```
**구조**: `[type, enable, maxCorr, [9-params], [7-params]]`
- type: 트래킹 타입
- enable: 트래킹 활성화
- maxCorr: 최대 보정량

---

### 4.4 T_Head 통신 인터페이스

#### stCommand / stReact 프로토콜
```rapid
PERS string stCommand := "";      ! T_Head → TASK1/2 명령
PERS string stReact{2} := ["", ""];  ! TASK1/2 → T_Head 응답
```

**프로토콜 흐름**:
1. T_Head가 `stCommand` 설정 (예: "MoveHome")
2. TASK1이 `stReact{1}` = "Ready" 설정
3. TASK2가 `stReact{2}` = "Ready" 설정
4. T_Head가 양쪽 모두 "Ready" 확인
5. 명령 실행 후 "Ack" 응답

---

### 4.5 Auto/Manual 매크로 배열

```rapid
! Auto 매크로 (자동 생성)
PERS torchmotion macroAutoStartA{2,10};   ! A라인 시작 매크로
PERS torchmotion macroAutoStartB{2,10};   ! B라인 시작 매크로
PERS torchmotion macroAutoEndA{2,10};     ! A라인 종료 매크로
PERS torchmotion macroAutoEndB{2,10};     ! B라인 종료 매크로

! Manual 매크로 (수동 설정)
PERS torchmotion macroManualStartA{2,10};
PERS torchmotion macroManualStartB{2,10};
PERS torchmotion macroManualEndA{2,10};
PERS torchmotion macroManualEndB{2,10};
```

**배열 구조**: `{robot, pass}` = {2 robots, 10 passes}
- 로봇 1, 2 각각
- 최대 10개 용접 패스

---

## 5. 리스크 관리

### 5.1 백업 조치

| 조치 | 내용 |
|------|------|
| 파일 백업 | `ConfigModule.mod.backup_v1939` 생성 |
| Git 체크포인트 | Commit `33330a3` 생성 |
| 롤백 계획 | 3가지 방법 문서화 |

### 5.2 롤백 절차

#### 방법 1: Git Revert (권장)
```bash
git revert 33330a3
git push
```
- 변경 이력 보존
- 안전한 롤백

#### 방법 2: 백업 파일 복원
```bash
cd RAPID/SpGantry_1200_526406_BACKUP_2025-12-18/RAPID/TASK1/PROGMOD/
cp ConfigModule.mod.backup_v1939 ConfigModule.mod
```
- VersionModule.mod, Head_Data.mod 수동 복원 필요

#### 방법 3: Hard Reset (비상시)
```bash
git reset --hard 8abebbb
git push --force  # 위험! 팀 확인 필수
```

---

## 6. 검증 계획

### 6.1 컴파일 테스트
- [ ] RobotStudio 프로젝트 로드
- [ ] TASK1 모듈 컴파일 확인
- [ ] TASK2 모듈 컴파일 확인
- [ ] TASK4/TASK8 컴파일 확인
- [ ] 에러/경고 없음 확인

### 6.2 기능 테스트
- [ ] test_mode=9 (TestMenu) 실행
- [ ] test_mode=11 (T_Head 리스너) 실행
- [ ] PERS 변수 동기화 확인
- [ ] 기존 용접 시퀀스 테스트

### 6.3 통합 테스트
- [ ] PlanA UI에서 변수 읽기
- [ ] nCmdInput/nCmdOutput 명령 통신
- [ ] 40-step welddata 접근
- [ ] stCommand/stReact 프로토콜

---

## 7. 후속 작업 진행 계획

### Phase 1: 컴파일 검증 (즉시)

| 순번 | 작업 | 담당 | 상태 |
|:----:|------|------|:----:|
| 1 | RobotStudio 프로젝트 로드 | 개발자 | ⏳ |
| 2 | TASK1 모듈 컴파일 | 개발자 | ⏳ |
| 3 | TASK2 모듈 컴파일 | 개발자 | ⏳ |
| 4 | TASK4/TASK8 컴파일 | 개발자 | ⏳ |
| 5 | 에러/경고 수정 | 개발자 | ⏳ |

### Phase 2: 기능 검증

| 순번 | 작업 | 담당 | 상태 |
|:----:|------|------|:----:|
| 1 | test_mode=9 (TestMenu) | 테스터 | ⏳ |
| 2 | test_mode=11 (T_Head) | 테스터 | ⏳ |
| 3 | PERS 변수 동기화 확인 | 테스터 | ⏳ |
| 4 | 기존 용접 시퀀스 테스트 | 테스터 | ⏳ |

### Phase 3: 상위 시스템 연동

| 순번 | 작업 | 담당 | 상태 |
|:----:|------|------|:----:|
| 1 | PlanA UI 변수 읽기 | 시스템 | ⏳ |
| 2 | nCmdInput/nCmdOutput 통신 | 시스템 | ⏳ |
| 3 | 40-step welddata 접근 | 시스템 | ⏳ |
| 4 | stCommand/stReact 프로토콜 | 시스템 | ⏳ |

### Phase 4: 현장 배포

| 순번 | 작업 | 담당 | 상태 |
|:----:|------|------|:----:|
| 1 | 컨트롤러 코드 업로드 | 현장 | ⏳ |
| 2 | 안정화 테스트 | 현장 | ⏳ |
| 3 | 최종 승인 | PM | ⏳ |

---

## 8. 주의사항

### 8.1 MainModule.mod 잠재적 수정 필요

HOME 좌표 변경 시 아래 프로시저 검토 필요:
- `UpdateGantryWobj`
- `SetRobot1InitialPosition`
- `FloorToGantry`, `GantryToFloor`

### 8.2 이중 변수 방식 이해

| 변수 | 용도 | 좌표계 |
|------|------|--------|
| `HOME_GANTRY_X/Y/Z/R` | 내부 계산 | Gantry (0-origin) |
| `nHomeGantryX/Y/Z/R` | UI 인터페이스 | Floor (물리 좌표) |

상위 시스템은 `nHomeGantry*` 읽기/쓰기
내부 함수는 `HOME_GANTRY_*` 사용

---

## 9. 참조 문서

- [PLANA_PLANB_VARIABLE_COMPARISON.md](./PLANA_PLANB_VARIABLE_COMPARISON.md) - 변수 비교표
- [Plan File](~/.claude/plans/replicated-jingling-kahn.md) - 상세 구현 계획

---

## 10. 변경 이력

| 버전 | 일시 | 변경 내용 |
|------|------|----------|
| v1.9.40 | 2026-02-06 | PlanA-PlanB 변수 완전 통합 |
| v1.9.39 | 2026-02-06 | T_Head task 추가, stCommand/stReact 프로토콜 |
| v1.9.35 | 2026-02-04 | Full Weld Sequence with TASK1/TASK2 sync |

---

*보고서 작성: Claude Opus 4.5*
*Git Commit: `33330a3` feat(rapid): PlanA-PlanB variable integration (v1.9.40)*

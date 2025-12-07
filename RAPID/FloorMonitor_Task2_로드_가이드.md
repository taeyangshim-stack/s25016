# FloorMonitor_Task2 모듈 로드 가이드

**문제**: `MonitorBothTCP_Floor_AtHome_Task2` 프로시저가 RobotStudio에서 보이지 않음
**원인**: FloorMonitor_Task2.mod 모듈이 RobotStudio 프로젝트에 로드되지 않음
**해결**: 모듈을 RobotStudio에 로드

---

## 🔍 문제 확인

### 파일 존재 여부
```bash
파일 위치: RAPID/TASK2/PROGMOD/FloorMonitor_Task2.mod
파일 크기: 9.4KB
프로시저명: MonitorBothTCP_Floor_AtHome_Task2 (Line 27)
```

✅ 파일은 존재하지만 RobotStudio에 로드되지 않음

---

## 📋 해결 방법

### 방법 1: RobotStudio Program Modules에서 로드

#### 단계별 절차:

1. **RobotStudio 열기**
   - Controller 탭 선택

2. **Program Modules 이동**
   - Controller > RAPID > T_ROB2 (또는 T_ROB2) > Program Modules

3. **모듈 로드**
   ```
   Program Modules 우클릭
   → Load Module...
   → 파일 선택:
      RAPID/SpGantry_1200_526406_BACKUP_2025-11-21/RAPID/TASK2/PROGMOD/FloorMonitor_Task2.mod
   → Load
   ```

4. **확인**
   - Program Modules에 "FloorMonitor_Task2" 표시되는지 확인
   - 모듈 확장하여 프로시저 목록 확인:
     - `MonitorBothTCP_Floor_AtHome_Task2`

---

### 방법 2: RAPID Code에서 직접 추가

RobotStudio의 RAPID Editor에서:

1. **RAPID 탭 열기**
   - Controller > RAPID > T_ROB2

2. **새 모듈 추가**
   ```
   RAPID 탭에서 우클릭
   → New Module
   → Name: FloorMonitor_Task2
   → Module Type: Program Module
   → Create
   ```

3. **코드 복사**
   - 로컬 파일 `FloorMonitor_Task2.mod` 열기
   - 전체 내용 복사
   - RobotStudio의 FloorMonitor_Task2 모듈에 붙여넣기

4. **저장 및 적용**
   - Ctrl+S (저장)
   - Apply 버튼 클릭

---

### 방법 3: 파일 시스템에서 직접 복사 (Windows)

RobotStudio가 Windows에서 실행 중인 경우:

1. **가상 컨트롤러 경로 찾기**
   ```
   C:\Users\<사용자명>\Documents\RobotStudio\Systems\<시스템명>\
   HOME\TASK2\PROGMOD\
   ```

2. **파일 복사**
   ```
   FloorMonitor_Task2.mod 파일을
   → HOME\TASK2\PROGMOD\ 폴더에 복사
   ```

3. **RobotStudio에서 재로드**
   - Controller 재시작 또는
   - Program 재로드

---

## ✅ 로드 확인 방법

### 1. Program Modules에서 확인
```
Controller > RAPID > T_ROB2 > Program Modules
→ FloorMonitor_Task2 모듈이 보이는지 확인
```

### 2. 프로시저 실행 테스트
RAPID Test 창에서:
```rapid
%MonitorBothTCP_Floor_AtHome_Task2%
```

또는 Production Window에서:
```
PP to Main
→ Program Pointer를 MonitorBothTCP_Floor_AtHome_Task2로 이동
→ Start
```

---

## 🔧 대체 방법: TASK1에서 간접 호출 (비권장)

FloorMonitor_Task2 로드가 어려운 경우, TASK1에서 실행 가능:

```rapid
! TASK1에서 실행 (HomePositionTest 먼저 실행 필요)
MonitorBothTCP_Floor_AtHome
```

**단점**: Robot2의 active tool이 tWeld2여야 함

---

## 📊 현재 모듈 상태 (추정)

| TASK | 로드된 모듈 | 상태 |
|------|-------------|------|
| TASK1 | MonitorFloorCoordinates | ✅ 로드됨 |
| TASK1 | MainModule | ✅ 로드됨 |
| TASK2 | HomePositionTest | ✅ 로드됨 |
| TASK2 | FloorMonitor_Task2 | ❌ **로드 안됨** |
| TASK2 | MainModule | ✅ 로드됨 |

---

## 🎯 권장 절차

### 즉시 실행 (간단한 방법)

**옵션 A: TASK1에서 실행**
1. TASK2에서 먼저 실행:
   ```rapid
   %MoveToHomeAndCheckTCP%  ! tWeld2 active로 설정
   ```

2. 그 다음 TASK1에서 실행:
   ```rapid
   %MonitorBothTCP_Floor_AtHome%
   ```

**옵션 B: FloorMonitor_Task2 로드 후 실행**
1. 위의 "방법 1" 또는 "방법 2" 실행
2. TASK2에서 직접 실행:
   ```rapid
   %MonitorBothTCP_Floor_AtHome_Task2%
   ```

---

## 📝 로드 후 확인사항

### 1. 모듈 로드 확인
```
Controller > RAPID > T_ROB2 > Program Modules
→ FloorMonitor_Task2 ✅
```

### 2. 프로시저 확인
```
FloorMonitor_Task2 확장
→ MonitorBothTCP_Floor_AtHome_Task2 ✅
```

### 3. Program Check
```
Controller > Program Check
→ T_ROB2 Check ✅ (에러 없음)
```

---

## 🐛 문제 해결

### Q: "Load Module" 시 파일을 찾을 수 없음
**A**: 파일 경로 확인
- 전체 경로 사용
- 백슬래시(\\) 대신 슬래시(/) 사용
- 또는 방법 2(코드 복사)로 진행

### Q: 모듈 로드 후에도 프로시저가 안 보임
**A**: RobotStudio 재시작
```
Controller 재시작
또는 RobotStudio 프로그램 재시작
```

### Q: "Module already exists" 오류
**A**: 기존 모듈 삭제 후 재로드
```
Program Modules > FloorMonitor_Task2 우클릭
→ Delete Module
→ 다시 Load Module
```

---

## 📂 파일 위치 참조

### 로컬 Git 저장소
```
/home/qwe/works/s25016/RAPID/
SpGantry_1200_526406_BACKUP_2025-11-21/RAPID/TASK2/PROGMOD/
FloorMonitor_Task2.mod
```

### RobotStudio (Windows)
```
C:\Users\<사용자명>\Documents\RobotStudio\Systems\
<시스템명>\HOME\TASK2\PROGMOD\
```

---

## ✨ 요약

**문제**: FloorMonitor_Task2 모듈이 RobotStudio에 로드되지 않음

**해결**:
1. Program Modules에서 Load Module (권장)
2. 또는 RAPID Editor에서 코드 붙여넣기
3. 또는 TASK1 버전 사용 (임시 방편)

**확인**: Program Modules에서 FloorMonitor_Task2 모듈 표시 확인

---

**작성일**: 2025-12-05
**다음 단계**: 모듈 로드 후 `MonitorBothTCP_Floor_AtHome_Task2` 실행

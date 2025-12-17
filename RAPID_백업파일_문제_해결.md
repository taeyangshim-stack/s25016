# ⚠️ 백업 파일 로드 문제 해결

## 🔍 문제 발견

### RobotStudio Check 결과
```
✅ T_ROB1: No errors
❌ T_ROB2: 2 syntax errors
   - Task1SharedVariables(71,31): Expected identifier
   - Task1SharedVariables(87,30): Expected identifier
```

### 원인 분석

**TASK2에 잘못된 파일이 로드됨:**
- ❌ 로드된 파일: `task1_shared_variables.mod.backup_20251217_072554` (백업, 이전 버전)
- ✅ 로드해야 할 파일: `task1_shared_variables.mod` (최신 버전)

**백업 파일의 문제점:**
```rapid
Line 70: UpdateSharedGantryPosition();  ← 세미콜론 있음 (ERROR)
Line 86: UpdateSharedGantryPosition();  ← 세미콜론 있음 (ERROR)
```

**최신 파일 (정상):**
```rapid
Line 71: UpdateSharedGantryPosition;  ← 세미콜론 없음 ✓
Line 87: UpdateSharedGantryPosition;  ← 세미콜론 없음 ✓
```

---

## 🛠️ 해결 조치

### 1. 백업 파일 이동 (완료)
```bash
백업 파일 이동:
  TASK1/PROGMOD/*.backup* → RAPID/_BACKUPS/
  TASK2/PROGMOD/*.backup* → RAPID/_BACKUPS/

이동된 파일:
  - task1_shared_variables.mod.backup_20251217_072554
  - test_robot2_capabilities.mod.backup_20251217_072601
```

### 2. Git Commit (완료)
```
commit 2bda1f0
refactor: Move backup files to _BACKUPS folder to prevent confusion
```

### 3. 파일 재복사 (사용자 작업 필요)

⚠️ **중요**: 반드시 파일을 다시 복사하세요!

```bash
cp -r /home/qwe/works/s25016/RAPID/SpGantry_1200_526406_BACKUP_2025-11-21 \
      /mnt/c/Users/user/Documents/RobotStudio/Projects/SpSystem_20251117/Backups/
```

---

## 🔄 RobotStudio 작업 순서

### Step 1: 기존 모듈 언로드
TASK2에서 **task1_shared_variables** 모듈을 찾아서 언로드하세요.
- Program → T_ROB2 → task1_shared_variables (마우스 우클릭) → Unload

### Step 2: 올바른 파일 로드
**주의**: 백업 파일(.backup)이 아닌 **정상 파일**을 로드하세요!

```
로드할 파일 (TASK2):
❌ task1_shared_variables.mod.backup_20251217_072554  ← 로드하지 마세요!
✅ task1_shared_variables.mod                         ← 이 파일을 로드하세요!

위치:
C:\Users\user\...\TASK1\PROGMOD\task1_shared_variables.mod
```

### Step 3: Check Program 실행
```
예상 결과:
✅ T_ROB1: No errors
✅ T_ROB2: No errors  ← 이제 에러 없어야 함
✅ T_BG: No errors
```

---

## 📊 파일 비교

### 백업 파일 (OLD - 에러 발생)
```rapid
파일명: task1_shared_variables.mod.backup_20251217_072554
수정 시간: 2025-12-17 07:19 (오전)
크기: 3282 bytes

문제점:
- Line 70: UpdateSharedGantryPosition();  ← ()
- Line 86: UpdateSharedGantryPosition();  ← ()
- 한글 주석 포함
```

### 최신 파일 (NEW - 정상)
```rapid
파일명: task1_shared_variables.mod
수정 시간: 2025-12-17 14:16 (오후)
크기: 3256 bytes

개선점:
- Line 71: UpdateSharedGantryPosition;  ← () 제거 ✓
- Line 87: UpdateSharedGantryPosition;  ← () 제거 ✓
- 영문 주석
- PERS 초기화
```

---

## 📁 현재 파일 구조

```
RAPID/SpGantry_1200_526406_BACKUP_2025-11-21/RAPID/
├── TASK1/PROGMOD/
│   ├── task1_shared_variables.mod           ← 최신 버전 ✓
│   └── (백업 파일 없음)
│
├── TASK2/PROGMOD/
│   ├── test_robot2_capabilities.mod         ← 최신 버전 ✓
│   └── (백업 파일 없음)
│
└── _BACKUPS/                                 ← 백업 파일 보관
    ├── task1_shared_variables.mod.backup_20251217_072554
    └── test_robot2_capabilities.mod.backup_20251217_072601
```

---

## ✅ 검증 체크리스트

### 파일 복사 후:
- [ ] Windows에서 RAPID 폴더 확인
- [ ] _BACKUPS 폴더 존재 확인
- [ ] TASK1/PROGMOD/에 .backup 파일 없음 확인
- [ ] TASK2/PROGMOD/에 .backup 파일 없음 확인

### RobotStudio:
- [ ] T_ROB2에서 기존 task1_shared_variables 언로드
- [ ] 새 task1_shared_variables.mod 로드 (백업 아님!)
- [ ] Check Program → T_ROB1: No errors
- [ ] Check Program → T_ROB2: No errors

---

## 🎯 핵심 포인트

1. **백업 파일과 현재 파일 구분**
   - .backup으로 끝나는 파일은 로드하지 마세요
   - 항상 확장자가 .mod인 파일만 로드

2. **파일 로드 시 경로 확인**
   - TASK1 모듈: TASK1/PROGMOD/ 에서 로드
   - TASK2 모듈: TASK2/PROGMOD/ 에서 로드
   - 백업 파일: _BACKUPS/ 폴더 (로드하지 않음)

3. **파일 수정 시간 확인**
   - 최신 파일: 2025-12-17 14:16 (오후 2시)
   - 백업 파일: 2025-12-17 07:19 (오전 7시)

---

문서 작성: 2025-12-17 14:33
최종 commit: 2bda1f0

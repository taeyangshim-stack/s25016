# Unicode 문자 오류 수정

**발생 시간**: 2025-12-05 17:51
**해결 시간**: 2025-12-05 17:52
**프로젝트**: S25016 SpGantry 1200

---

## 🔴 발견된 오류

### Program Check 오류 메시지
```
SpGantry_1200_526406/RAPID/T_ROB2/FloorMonitor_Task2(18,60):
Unexpected unknown token(150): Unexpected unknown token.

SpGantry_1200_526406/RAPID/T_ROB2/FloorMonitor_Task2(18,61):
Unexpected unknown token(150): Unexpected unknown token.

SpGantry_1200_526406/RAPID/T_ROB2/FloorMonitor_Task2(18,62):
Syntax error(136): Unexpected num identifier ')'.
```

### 원인
**Line 18에 Unicode 화살표 문자 사용**

```rapid
! 문제 코드 (Line 18):
!                          - Fixed: Renamed procedure (33→24 chars)
                                                            ↑
                                                     Unicode 화살표
```

**ABB RAPID는 ASCII 문자만 지원**
- ❌ Unicode 화살표: `→` (U+2192)
- ✅ ASCII 화살표: `->` (하이픈 + 부등호)

---

## ✅ 수정 내용

### FloorMonitor_Task2.mod Line 18

**변경 전** (오류):
```rapid
!                          - Fixed: Renamed procedure (33→24 chars)
```

**변경 후** (정상):
```rapid
!                          - Fixed: Renamed procedure (33->24 chars)
```

---

## 📋 영향받은 파일

| 파일 | 위치 | 문제 | 상태 |
|------|------|------|------|
| FloorMonitor_Task2.mod | Line 18 | Unicode `→` | ✅ 수정 완료 |
| MonitorFloorCoordinates.mod | - | 없음 | ✅ 정상 |
| HomePositionTest.mod | - | 없음 | ✅ 정상 |

---

## 🔍 RAPID 코딩 규칙

### 허용되는 문자

**주석에서도 ASCII만 사용**:
```rapid
! 좋은 예 (ASCII):
! -> 화살표
! <= 작거나 같음
! >= 크거나 같음
! != 같지 않음

! 나쁜 예 (Unicode):
! → 화살표        ❌
! ≤ 작거나 같음   ❌
! ≥ 크거나 같음   ❌
! ≠ 같지 않음     ❌
```

### 안전한 특수 문자
```
허용: ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~
금지: Unicode 문자 (한글 주석 제외)
```

---

## 📝 수정 절차

### 1. 파일 수정
```bash
# Line 18: 33→24 를 33->24로 변경
vi FloorMonitor_Task2.mod
```

### 2. Windows로 복사
```bash
cp FloorMonitor_Task2.mod \
   /mnt/c/Users/user/Documents/RobotStudio/Projects/\
   SP_Gatry20251120/Backups/\
   SpGantry_1200_526406_BACKUP_2025-11-21/RAPID/TASK2/PROGMOD/
```

### 3. RobotStudio에서 재로드
```
Controller > RAPID > T_ROB2 > Program Modules
→ FloorMonitor_Task2 우클릭
→ Delete Module
→ Load Module... (새 파일)
```

### 4. Program Check
```
Controller > Program Check
→ T_ROB2: No errors ✅
```

---

## ✅ 검증 완료

### 복사된 파일 확인
```bash
파일 위치: C:\Users\user\Documents\RobotStudio\Projects\
          SP_Gatry20251120\Backups\
          SpGantry_1200_526406_BACKUP_2025-11-21\
          RAPID\TASK2\PROGMOD\FloorMonitor_Task2.mod

Line 18 내용:
!                          - Fixed: Renamed procedure (33->24 chars)
                                                            ↑
                                                     ASCII 화살표 ✅
```

---

## 🎯 다음 단계

### RobotStudio에서 실행

1. **모듈 재로드**:
   - FloorMonitor_Task2 삭제 후 재로드

2. **Program Check**:
   ```
   결과: T_ROB2: No errors 예상 ✅
   ```

3. **프로시저 실행**:
   ```rapid
   %MonitorFloorAtHome_Task2%
   ```

---

## 💡 교훈

### RAPID 코딩 시 주의사항

1. **주석도 ASCII 문자 사용**
   - Unicode 특수 문자 사용 금지
   - 한글 주석은 가능하지만 특수 문자 주의

2. **에디터 설정**
   - UTF-8 인코딩 사용 시 주의
   - 자동 변환 기능 비활성화

3. **검증**
   - 파일 저장 후 ASCII 문자 확인
   - Program Check로 사전 검증

---

## 📊 수정 이력

| 시간 | 문제 | 해결 |
|------|------|------|
| 17:46 | 프로시저 이름 33자 | 24자로 단축 ✅ |
| 17:51 | Unicode 화살표 `→` | ASCII `->` 변경 ✅ |

---

## 🔗 관련 문서

- `프로시저_이름_수정_251205.md` - 이름 길이 문제 해결
- `FloorMonitor_Task2_로드_가이드.md` - 모듈 로드 방법
- `VERSION_CONTROL.md` - 버전 관리 가이드

---

**수정 완료**: 2025-12-05 17:52
**상태**: ✅ Windows 복사 완료
**다음**: RobotStudio Program Check 재실행 필요

---

## 📝 체크리스트

- [x] Unicode 문자 확인 (Line 18)
- [x] ASCII 문자로 변경 (`→` → `->`)
- [x] 파일 저장
- [x] Windows로 복사
- [ ] RobotStudio 모듈 재로드
- [ ] Program Check 실행 (No errors 예상)
- [ ] 프로시저 실행 테스트

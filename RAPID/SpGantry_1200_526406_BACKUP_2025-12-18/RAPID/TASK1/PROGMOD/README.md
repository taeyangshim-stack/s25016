# RAPID Module Structure

## Overview

S25016 SpGantry 프로젝트의 RAPID 코드는 역할별로 모듈화되어 있습니다.

## Module Organization

```
RAPID/TASK1/PROGMOD/
├── MainModule.mod          # 메인 로직 및 프로시저
├── ConfigModule.mod        # 설정 변수 (NEW v1.8.52)
├── VersionModule.mod       # 버전 관리 (NEW v1.8.52)
└── README.md              # 이 문서
```

---

## 📦 Module Descriptions

### 1. **MainModule.mod**
**역할:** 주요 제어 로직 및 프로시저

**포함 내용:**
- `main()` - TASK1 메인 루틴
- `SetRobot1InitialPosition()` - Robot1 초기화
- `TestGantryMode2()` - Mode2 복합 이동 테스트
- `UpdateGantryWobj()` - WobjGantry 업데이트
- `UpdateRobot1FloorPosition()` - Robot1 Floor 좌표 계산
- `UpdateRobot2BaseDynamicWobj()` - Robot2 베이스 좌표 계산
- 기타 유틸리티 프로시저

**PERS 변수:**
- `robot1_floor_pos_t1` - Robot1 Floor 위치
- `robot2_init_complete` - Robot2 초기화 완료 플래그
- `mode2_r2_offset_x/y/z` - Robot2 TCP 오프셋 (TASK2 공유)

**수정 시기:**
- 제어 로직 변경
- 새로운 프로시저 추가
- 버그 수정

---

### 2. **ConfigModule.mod** ⭐ NEW
**역할:** 테스트 설정 및 파라미터 관리

**포함 내용:**
```rapid
! Robot1 TCP Offsets (mm)
MODE2_TCP_OFFSET_R1_X := 0;
MODE2_TCP_OFFSET_R1_Y := 100;
MODE2_TCP_OFFSET_R1_Z := 0;

! Robot2 TCP Offsets (mm)
MODE2_TCP_OFFSET_R2_X := 0;
MODE2_TCP_OFFSET_R2_Y := -100;
MODE2_TCP_OFFSET_R2_Z := 0;

! Test Positions
MODE2_NUM_POS := 3;
MODE2_POS_X{10} := [1200, 2600, -1500, ...];
MODE2_POS_Y{10} := [-400, -900, -600, ...];
MODE2_POS_Z{10} := [-500, -700, -300, ...];
MODE2_POS_R{10} := [30, -45, 60, ...];
```

**수정 방법 (RobotStudio):**
1. Program Data → ConfigModule 선택
2. 원하는 변수 더블클릭
3. 값 수정 → 프로그램 재실행

**수정 시기:**
- TCP 오프셋 변경
- 테스트 위치 추가/수정
- 테스트 개수 변경

---

### 3. **VersionModule.mod** ⭐ NEW
**역할:** 버전 정보 및 변경 이력 관리

**포함 내용:**
```rapid
! Task Versions
TASK1_VERSION := "v1.8.52";
TASK2_VERSION := "v1.8.39";

! Build Information
BUILD_DATE := "2026-01-09";
PROJECT_NAME := "S25016 SpGantry Dual Robot System";

! Component Versions
COORD_SYSTEM_VERSION := "v1.8.5";
MODE2_TEST_VERSION := "v1.8.52";

! Version History (최근 10개)
! v1.8.52 (2026-01-09) - TCP offset maintained
! v1.8.51 (2026-01-09) - PERS migration
! ...
```

**유틸리티 프로시저:**
- `PrintVersionInfo()` - 버전 정보 출력
- `LogVersionInfo(logfile)` - 로그 파일에 버전 기록
- `GetVersionString()` - 버전 문자열 반환

**수정 시기:**
- 새 버전 릴리스
- 주요 기능 추가/변경
- 빌드 정보 업데이트

---

## 🔄 Module Dependencies

```
MainModule.mod
    ↓ imports
    ├─ ConfigModule.mod    (설정 변수)
    └─ VersionModule.mod   (버전 상수)
```

**Import 순서:**
1. VersionModule (버전 상수 정의)
2. ConfigModule (설정 변수 정의)
3. MainModule (메인 로직, 위 모듈 참조)

---

## 📝 Best Practices

### 설정 변경 시
```
❌ 나쁜 방법: MainModule.mod 수정
✅ 좋은 방법: ConfigModule.mod 변수 수정
```

### 버전 업데이트 시
```
1. VersionModule.mod에서 버전 변경
2. Version History에 변경 내역 추가
3. BUILD_DATE 업데이트
4. Git 커밋 메시지에도 동일 내용 기록
```

### 새로운 설정 추가 시
```
1. ConfigModule.mod에 PERS 변수 추가
2. MainModule.mod에서 참조
3. README 업데이트
```

---

## 🎯 Quick Reference

### 버전 확인
```rapid
TPWrite TASK1_VERSION;              ! "v1.8.52"
TPWrite GetVersionString();         ! "v1.8.52 (2026-01-09)"
PrintVersionInfo();                 ! 전체 버전 정보 출력
```

### 설정 확인
```rapid
tcp_offset_y := MODE2_TCP_OFFSET_R1_Y;  ! 100
num_pos := MODE2_NUM_POS;               ! 3
```

### 로깅
```rapid
LogVersionInfo(logfile);  ! 로그 파일에 버전 기록
```

---

## 📚 Migration History

### v1.8.52 (2026-01-09)
- ✨ ConfigModule.mod 생성 (설정 분리)
- ✨ VersionModule.mod 생성 (버전 관리)
- ♻️ MainModule.mod 간소화
- 🔧 TCP 오프셋 유지 로직 수정

### v1.8.51 (2026-01-09)
- ♻️ config.txt → PERS 변수 마이그레이션
- 🗑️ 590줄 config 파싱 코드 제거
- 🐛 ReadStr hang 문제 해결

---

## 🆘 Troubleshooting

### 버전 불일치 오류
**증상:** "Undefined identifier: TASK1_VERSION"
**해결:** VersionModule.mod가 로드되었는지 확인

### 설정 변수 없음
**증상:** "Undefined identifier: MODE2_NUM_POS"
**해결:** ConfigModule.mod가 로드되었는지 확인

### 모듈 로드 순서 오류
**해결:**
1. VersionModule 먼저 로드
2. ConfigModule 로드
3. MainModule 마지막 로드

---

## 📞 Contact

프로젝트: S25016 SpGantry
담당: SP 심태양
버전: v1.8.52

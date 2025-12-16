# RAPID 코드 버전 관리 정책

## 개요
모든 RAPID 파일(.mod)은 반드시 버전 정보를 포함해야 합니다.

---

## 버전 번호 체계 (Semantic Versioning)

### 형식: `vMAJOR.MINOR.PATCH`

**MAJOR (주 버전):**
- 호환성이 깨지는 주요 변경
- 예: 프로시저 서명 변경, 전체 재구성

**MINOR (부 버전):**
- 기능 추가 (하위 호환성 유지)
- 예: 새 프로시저 추가, 새 기능 추가

**PATCH (패치 버전):**
- 버그 수정, 문서 업데이트
- 예: 문법 오류 수정, 주석 추가

---

## 파일 헤더 템플릿

### 필수 형식

```rapid
MODULE ModuleName
    !========================================
    ! ModuleName - TASK# (Robot#)
    !========================================
    ! Version History:
    ! v1.0.0 - YYYY-MM-DD - Initial version
    !                      - Description of initial features
    ! v1.1.0 - YYYY-MM-DD - Feature addition
    !                      - Detailed description
    !                      - Multiple lines allowed for clarity
    ! v1.1.1 - YYYY-MM-DD - Bug fix
    !                      - Description of fix
    !
    ! Current Version: v#.#.#
    ! Last Modified: YYYY-MM-DD
    ! Author: Team/Person Name
    !========================================

    ! Module code starts here
ENDMODULE
```

---

## 버전 업데이트 규칙

### 1. 변경 전 반드시 확인
- 현재 버전 번호 확인
- 변경 내용의 중요도 판단
- 적절한 버전 번호 증가

### 2. 버전 히스토리 작성
- **날짜**: YYYY-MM-DD 형식 (예: 2025-12-16)
- **설명**: 명확하고 구체적으로
- **들여쓰기**: 여러 줄 설명 시 정렬

### 3. Current Version 업데이트
```rapid
! Current Version: v3.1.1
! Last Modified: 2025-12-16
```

### 4. 파일 저장
- ASCII 인코딩 필수
- UTF-8 문자 금지

---

## 자동화 도구

### 1. 버전 검증 스크립트
```bash
python3 /home/qwe/works/s25016/RAPID/scripts/check_version.py <file.mod>
```

**기능:**
- 버전 정보 존재 여부 확인
- 버전 번호 형식 검증 (vX.Y.Z)
- Current Version과 최신 히스토리 일치 여부 확인
- 날짜 형식 검증

### 2. 버전 업데이트 도우미
```bash
python3 /home/qwe/works/s25016/RAPID/scripts/update_version.py <file.mod> --type [major|minor|patch] --message "변경 설명"
```

**기능:**
- 자동으로 버전 번호 증가
- 버전 히스토리 자동 추가
- Current Version 자동 업데이트
- 날짜 자동 입력

### 3. Git Pre-commit Hook
```bash
# .git/hooks/pre-commit
#!/bin/bash
# 모든 .mod 파일 버전 정보 검증
for file in $(git diff --cached --name-only | grep '\.mod$'); do
    python3 RAPID/scripts/check_version.py "$file"
    if [ $? -ne 0 ]; then
        echo "❌ 버전 정보 오류: $file"
        echo "수정: python3 RAPID/scripts/update_version.py $file --type patch --message \"Fix\""
        exit 1
    fi
done
```

---

## 버전 업데이트 예시

### 시나리오 1: 버그 수정 (PATCH)
```rapid
! v3.1.0 - 2025-12-16 - Add new feature X
! v3.1.1 - 2025-12-16 - Fix iodev comparison error
!                      - Remove invalid type comparison
!
! Current Version: v3.1.1
! Last Modified: 2025-12-16
```

### 시나리오 2: 기능 추가 (MINOR)
```rapid
! v3.1.1 - 2025-12-16 - Fix iodev error
! v3.2.0 - 2025-12-17 - Add collision detection
!                      - New procedure: CheckCollision
!                      - Integration with safety system
!
! Current Version: v3.2.0
! Last Modified: 2025-12-17
```

### 시나리오 3: 주요 변경 (MAJOR)
```rapid
! v3.2.0 - 2025-12-17 - Add collision detection
! v4.0.0 - 2025-12-18 - BREAKING CHANGE - New robot base frame
!                      - Changed all coordinate definitions
!                      - Updated all procedures for new frame
!                      - ⚠️ NOT compatible with v3.x
!
! Current Version: v4.0.0
! Last Modified: 2025-12-18
```

---

## 체크리스트

### 코드 수정 시
- [ ] 현재 버전 확인
- [ ] 변경 내용 분류 (MAJOR/MINOR/PATCH)
- [ ] 버전 번호 증가
- [ ] 버전 히스토리 추가
- [ ] Current Version 업데이트
- [ ] Last Modified 날짜 업데이트
- [ ] 버전 검증 스크립트 실행
- [ ] ASCII 인코딩 확인

### Git 커밋 전
- [ ] 모든 .mod 파일 버전 정보 확인
- [ ] 버전 검증 스크립트 통과
- [ ] 커밋 메시지에 버전 번호 포함

---

## 예외 사항

### 버전 증가 불필요
- 주석만 수정 (코드 변경 없음)
- 공백/들여쓰기 정리만
- README 수정

### 이 경우에도 Last Modified는 업데이트

---

## 도구 위치

**스크립트:**
- `/home/qwe/works/s25016/RAPID/scripts/check_version.py`
- `/home/qwe/works/s25016/RAPID/scripts/update_version.py`
- `/home/qwe/works/s25016/RAPID/scripts/validate_and_fix_rapid.py`

**정책 문서:**
- `/home/qwe/works/s25016/RAPID/VERSION_POLICY.md` (본 문서)

---

## 참고

**Semantic Versioning 공식 사이트:**
https://semver.org/

**현재 프로젝트 버전:**
- MainModule TASK1: v3.1.1
- MainModule TASK2: v3.1.1

**마지막 업데이트:** 2025-12-16
**작성자:** SP Team

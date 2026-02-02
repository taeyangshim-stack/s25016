# /git-push - Git 커밋 및 푸시

변경된 파일을 확인하고, 커밋 메시지를 생성한 후 원격 저장소에 푸시합니다.

## 실행 단계

### Step 1: 변경사항 확인
다음 명령어를 병렬로 실행:
```bash
git status
git diff --stat
git log --oneline -3
```

### Step 2: 변경 파일 분석
- 변경된 파일 목록 확인
- 새로 추가된 파일 (Untracked) 확인
- 삭제된 파일 확인

### Step 3: 커밋 메시지 생성
Conventional Commits 형식 사용:
```
<type>(<scope>): <subject>

<body>

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
```

**Type 종류:**
- `feat`: 새로운 기능
- `fix`: 버그 수정
- `docs`: 문서 수정
- `style`: 코드 포맷팅
- `refactor`: 리팩토링
- `test`: 테스트 추가
- `chore`: 빌드, 설정 변경

### Step 4: 스테이징 및 커밋
```bash
git add <specific-files>
git commit -m "<message>"
```

**주의:**
- `git add .` 또는 `git add -A` 사용 지양
- 민감한 파일 (.env, credentials 등) 제외
- 대용량 바이너리 파일 확인

### Step 5: 푸시
```bash
git push origin <current-branch>
```

### Step 6: 결과 확인
```bash
git status
git log --oneline -1
```

## 사용법

```bash
# 기본 사용 (변경사항 자동 분석)
/git-push

# 커밋 메시지 직접 지정
/git-push "feat: 새로운 기능 추가"

# 특정 파일만 커밋
/git-push --files "src/app.js,README.md"
```

## 인자 처리

- 인자 없음: 변경사항 분석 후 적절한 커밋 메시지 자동 생성
- 문자열 인자: 해당 문자열을 커밋 메시지로 사용
- `--files`: 특정 파일만 스테이징

## 안전 규칙

1. **절대 하지 말 것:**
   - `git push --force`
   - `git reset --hard`
   - main/master 브랜치에 직접 force push

2. **항상 확인:**
   - 민감한 정보 포함 여부
   - 대용량 파일 포함 여부
   - 현재 브랜치가 올바른지

3. **커밋 전 확인:**
   - pre-commit hook 실패 시 새 커밋 생성 (amend 사용 안 함)

# Vercel 배포 확인 방법

## 현재 프로젝트 정보
- **Vercel Project Name**: s25016_02
- **GitHub Repository**: taeyangshim-stack/s25015
- **Latest Commit**: 1300b43

## Vercel URL 확인 단계

### 1. Vercel 대시보드 접속
```
https://vercel.com/dashboard
```

### 2. 프로젝트 찾기
- 대시보드에서 `s25016_02` 프로젝트 클릭
- 또는 검색창에 "s25016" 입력

### 3. 배포 상태 확인
- **Deployments** 탭 클릭
- 최신 배포 상태 확인:
  - ✅ Ready (배포 성공)
  - ⏳ Building (빌드 중)
  - ❌ Error (배포 실패)

### 4. 프로젝트 URL 확인
- 프로젝트 페이지 상단에 표시된 URL 복사
- 일반적으로: `https://프로젝트명.vercel.app`

## 가능한 URL들

### 자동 생성 URL
```
https://s25016-02.vercel.app
https://s25016-02-git-master-taeyangshim-stack.vercel.app
```

### 라우트
```
/robot-review              → robot_system_review.html (통합 버전)
/robot-review-ko           → robot_system_review_ko.html (한글 전용)
/robot-review-en           → robot_system_review_en.html (영어 전용)
/robot_system_review.html  → 직접 접근
```

## 로컬 테스트

### HTTP 서버 실행
```bash
cd /home/qwe/works/s25016
python3 -m http.server 8000
```

### 로컬 URL
```
http://localhost:8000/robot_system_review.html
http://localhost:8000/robot-review  (rewrites 적용 안 됨)
```

## 문제 해결

### 404 에러 발생 시

#### 원인 1: GitHub 연동 문제
- Vercel 대시보드 → Settings → Git
- GitHub 저장소 연결 확인
- Repository: `taeyangshim-stack/s25015`
- Branch: `master`

#### 원인 2: 자동 배포 비활성화
- Settings → Git → Auto Deploy 확인
- Production Branch: `master` 설정

#### 원인 3: 빌드 실패
- Deployments 탭에서 최신 배포 로그 확인
- Error 메시지 확인

### 수동 재배포

#### 방법 1: Vercel CLI (추천)
```bash
cd /home/qwe/works/s25016
vercel --prod
```

#### 방법 2: Vercel 대시보드
- Deployments 탭
- 최신 배포 옆 "..." 메뉴 클릭
- "Redeploy" 선택

#### 방법 3: Git 강제 Push
```bash
git commit --allow-empty -m "trigger: rebuild"
git push origin master
```

## index.html 인증 문제

현재 index.html이 인증 토큰으로 보호되어 있습니다:
```
?auth=c49d872f-4bf0-4721-a5c6-5efb8fa9d8e1
```

### 인증 링크
```
https://your-domain.vercel.app/?auth=c49d872f-4bf0-4721-a5c6-5efb8fa9d8e1
```

### 로봇 리뷰 페이지 (인증 불필요)
```
https://your-domain.vercel.app/robot-review
```

## 다음 단계

1. **Vercel 대시보드 확인**: 정확한 URL 복사
2. **배포 상태 확인**: 성공/실패 여부
3. **로그 확인**: 에러 메시지 확인
4. **재배포**: 필요시 수동 재배포

## 문의
- Vercel 프로젝트: s25016_02
- GitHub: taeyangshim-stack/s25015
- 최신 커밋: 1300b43

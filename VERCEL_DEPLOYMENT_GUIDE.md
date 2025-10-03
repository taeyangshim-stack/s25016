# Vercel 배포 가이드

## 📋 준비 사항

✅ GitHub 저장소에 코드 푸시 완료
- Repository: `https://github.com/taeyangshim-stack/s25015.git`
- Branch: `master`
- 최신 커밋: 통합 대시보드 및 vercel.json 설정 완료

## 🚀 Vercel 배포 단계

### 1. Vercel 계정 생성 및 로그인

1. [Vercel](https://vercel.com) 접속
2. "Sign Up" 또는 "Continue with GitHub" 클릭
3. GitHub 계정으로 로그인 (권장)

### 2. 새 프로젝트 Import

1. Vercel 대시보드에서 **"Add New..."** → **"Project"** 클릭
2. **"Import Git Repository"** 섹션에서 GitHub 연동
3. `taeyangshim-stack/s25015` 저장소 선택
4. **"Import"** 버튼 클릭

### 3. 프로젝트 설정

**Configure Project** 화면에서:

```
Project Name: s25015-dashboard (또는 원하는 이름)
Framework Preset: Other (정적 HTML 사이트)
Root Directory: ./
Build Command: (비워두기 - 빌드 불필요)
Output Directory: (비워두기 - 정적 파일 직접 서빙)
```

**Environment Variables**: 없음 (필요시 추가)

### 4. 배포 시작

1. **"Deploy"** 버튼 클릭
2. 자동으로 빌드 및 배포 시작
3. 1-2분 후 배포 완료

## 🌐 배포 후 URL 구조

배포가 완료되면 다음과 같은 URL로 접근 가능합니다:

### 메인 페이지
- **`https://your-project.vercel.app/`** → 통합 대시보드 (index.html)

### 직접 접근 URL (vercel.json 설정)
- **`/hexagon`** → Hexagon 프로젝트 메인
- **`/devicenet`** → DeviceNet 신호 테이블
- **`/robot-dashboard`** → 로봇 상하축 이슈 대시보드

### 전체 파일 접근
모든 파일은 상대 경로로 접근 가능:
- `/251003_용접기_디바이스넷/DeviceNet_Signals_Table.html`
- `/상하축이슈_대시보드.html`
- `/hexagon/index.html`
- 기타 모든 프로젝트 파일

## 🔧 자동 배포 설정

Vercel은 GitHub와 연동되어 **자동 배포**가 활성화됩니다:

- **`master` 브랜치에 푸시** → 자동으로 프로덕션 배포
- **다른 브랜치에 푸시** → 프리뷰 배포 생성
- **Pull Request 생성** → PR 전용 프리뷰 URL 생성

## 📊 배포 확인

배포 완료 후:

1. Vercel 대시보드에서 **"Visit"** 버튼 클릭
2. 통합 대시보드가 정상적으로 표시되는지 확인
3. 각 탭(DeviceNet, 로봇, Hexagon, 문서) 동작 확인
4. 모든 링크가 정상 작동하는지 테스트

## 🎨 커스텀 도메인 설정 (선택사항)

1. Vercel 프로젝트 설정 → **"Domains"** 탭
2. **"Add Domain"** 클릭
3. 원하는 도메인 입력 (예: `s25015.yourdomain.com`)
4. DNS 설정 안내에 따라 도메인 연결

## 🔄 업데이트 방법

새로운 변경사항 배포:

```bash
# 로컬에서 변경 작업 수행
git add .
git commit -m "변경사항 설명"
git push origin master

# Vercel이 자동으로 감지하여 재배포
```

## 📱 Vercel CLI 사용 (선택사항)

로컬에서 직접 배포하려면:

```bash
# Vercel CLI 설치
npm i -g vercel

# 프로젝트 디렉토리에서 배포
cd /home/qwe/works/s25015
vercel

# 프로덕션 배포
vercel --prod
```

## 🛠️ 문제 해결

### 페이지가 404 오류를 표시하는 경우
- `vercel.json` 설정 확인
- GitHub에 최신 코드가 푸시되었는지 확인
- Vercel 대시보드에서 "Redeploy" 시도

### 한글 파일명 문제
- 한글 폴더/파일명은 URL 인코딩됨
- 브라우저에서 자동으로 처리되므로 정상 동작

### 배포가 실패하는 경우
- Vercel 대시보드의 "Deployment" 탭에서 로그 확인
- Build Command와 Output Directory 설정 재확인

## 📞 지원

- Vercel 문서: https://vercel.com/docs
- GitHub Repository: https://github.com/taeyangshim-stack/s25015

## ✅ 배포 체크리스트

- [ ] Vercel 계정 생성/로그인
- [ ] GitHub 저장소 연동
- [ ] 프로젝트 Import 및 설정
- [ ] 배포 완료 확인
- [ ] 메인 대시보드 접근 테스트
- [ ] DeviceNet 페이지 확인
- [ ] 로봇 대시보드 확인
- [ ] Hexagon 페이지 확인
- [ ] 모든 링크 동작 확인
- [ ] (선택) 커스텀 도메인 설정

---

**배포 준비 완료!** 위 단계를 따라 Vercel에서 프로젝트를 배포하세요.

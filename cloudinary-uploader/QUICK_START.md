# 빠른 시작 가이드

## 1. 설치

```bash
cd cloudinary-uploader
npm install
```

## 2. 환경 설정

`.env.example`을 `.env`로 복사 (이미 설정됨):

```env
CLOUDINARY_CLOUD_NAME=dmmjpofcc
CLOUDINARY_API_KEY=763721125922284
CLOUDINARY_API_SECRET=vU-nSXa-XQcdh27uyqejE6YBdxA
CLOUDINARY_UPLOAD_FOLDER=s25016
```

## 3. 사용 예제

### 기본 업로드 (폴더 자동 지정)

```bash
# 개별 파일
node uploader.js image1.jpg image2.png

# 디렉토리 전체
node uploader.js ./images
```

### 폴더 지정하기

```bash
# DeviceNet 문서를 devicenet 폴더에 업로드
node uploader.js ./251003_용접기_디바이스넷 --folder=s25016/devicenet

# 로봇 테스트 결과를 robot-test 폴더에 업로드
node uploader.js ./250917_상하축이슈/04_작업진행 --folder=s25016/robot-test
```

### URL 목록 저장 및 복사

```bash
# URL을 텍스트/마크다운 파일로 저장
node uploader.js ./images --urls

# 클립보드에 URL 복사 (xclip 필요)
node uploader.js ./images --copy

# 둘 다 사용
node uploader.js ./photos --folder=gallery --urls --copy
```

생성되는 파일:
- `upload-urls.txt` - URL만 줄바꿈으로 구분
- `upload-urls.md` - 마크다운 링크 형식

### 확장자 필터링

```bash
# 이미지만 업로드
node uploader.js ./files --ext=.jpg,.png,.gif

# PDF만 업로드
node uploader.js ./docs --ext=.pdf --folder=documents
```

### 전체 옵션 조합

```bash
node uploader.js ./photos \
  --folder=s25016/gallery \
  --ext=.jpg,.png \
  --urls \
  --copy \
  --save=results.json
```

## 4. 실전 예제

### S25016 프로젝트 문서 업로드

```bash
# DeviceNet 문서
node uploader.js ../251003_용접기_디바이스넷 \
  --folder=s25016/devicenet \
  --ext=.pdf,.html \
  --urls

# 로봇 테스트 결과
node uploader.js ../250917_상하축이슈/04_작업진행 \
  --folder=s25016/robot-test \
  --ext=.html,.md \
  --urls --copy

# Hexagon 문서
node uploader.js ../hexagon \
  --folder=s25016/hexagon \
  --urls
```

## 5. 결과 확인

업로드 완료 후:
- 콘솔에 각 파일의 URL 출력
- `--urls` 사용 시 `upload-urls.txt`, `upload-urls.md` 생성
- `--copy` 사용 시 클립보드에 URL 복사됨
- `--save` 사용 시 JSON 결과 파일 생성

## 6. 클립보드 복사 설정 (Linux)

```bash
sudo apt-get install xclip
```

## 7. 도움말

```bash
node uploader.js
```

# Cloudinary 다중 파일 업로더

S25016 프로젝트용 Cloudinary 파일 업로드 미들웨어

## 주요 기능

- ✅ 단일/다중 파일 업로드
- ✅ 디렉토리 전체 업로드
- ✅ 파일 확장자 필터링
- ✅ 업로드 결과 JSON 저장
- ✅ 진행 상황 실시간 표시
- ✅ 에러 핸들링

---

## 설치 방법

### 1. 의존성 설치

```bash
cd cloudinary-uploader
npm install
```

### 2. 환경 변수 설정

```bash
# .env.example을 .env로 복사
cp .env.example .env
```

`.env` 파일 편집:

```env
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
CLOUDINARY_UPLOAD_FOLDER=s25016
```

**API 정보 확인:**
https://console.cloudinary.com/app/c-0d19ea6923e569968433fdb1c721e3/home/dashboard

- Dashboard → Settings → API Keys

---

## 사용 방법

### 개별 파일 업로드

```bash
node uploader.js image1.jpg image2.png document.pdf
```

### 디렉토리 전체 업로드

```bash
node uploader.js ./images
```

### 폴더 지정

```bash
node uploader.js ./photos --folder=project/gallery
```

### 확장자 필터링

```bash
# 이미지만 업로드 (jpg, png)
node uploader.js ./files --ext=.jpg,.png

# PDF 문서만 업로드
node uploader.js ./docs --ext=.pdf
```

### 결과 저장

```bash
node uploader.js ./files --save=upload-results.json
```

### 조합 사용

```bash
node uploader.js ./images \
  --folder=s25016/photos \
  --ext=.jpg,.png,.gif \
  --save=results.json
```

---

## 프로그래밍 방식 사용

Node.js 코드에서 모듈로 사용:

```javascript
require('dotenv').config();
const { uploadFile, uploadMultiple, uploadDirectory } = require('./uploader');

// 단일 파일
const result = await uploadFile('./image.jpg', {
  folder: 's25016/test'
});

// 다중 파일
const results = await uploadMultiple([
  './file1.jpg',
  './file2.png',
  './document.pdf'
]);

// 디렉토리
const results = await uploadDirectory('./images', {
  folder: 's25016/gallery'
}, ['.jpg', '.png']);
```

---

## 출력 예제

```
🚀 총 3개 파일 업로드 시작...

📤 업로드 중: ./images/photo1.jpg
✅ 성공: photo1.jpg
   URL: https://res.cloudinary.com/.../photo1.jpg

📤 업로드 중: ./images/photo2.png
✅ 성공: photo2.png
   URL: https://res.cloudinary.com/.../photo2.png

📤 업로드 중: ./images/doc.pdf
✅ 성공: doc.pdf
   URL: https://res.cloudinary.com/.../doc.pdf

📊 업로드 완료!
   ✅ 성공: 3개
   ❌ 실패: 0개

💾 결과 저장: upload-results.json
```

---

## 결과 JSON 포맷

`upload-results.json` 예시:

```json
{
  "timestamp": "2024-10-07T14:30:00.000Z",
  "total": 3,
  "success": 3,
  "failed": 0,
  "results": [
    {
      "success": true,
      "file": "./images/photo1.jpg",
      "url": "https://res.cloudinary.com/.../photo1.jpg",
      "public_id": "s25016/photo1"
    },
    {
      "success": true,
      "file": "./images/photo2.png",
      "url": "https://res.cloudinary.com/.../photo2.png",
      "public_id": "s25016/photo2"
    }
  ]
}
```

---

## 실제 사용 예제

### S25016 프로젝트 문서 업로드

```bash
# DeviceNet 문서 업로드
node uploader.js ../251003_용접기_디바이스넷 \
  --folder=s25016/devicenet \
  --ext=.pdf,.html

# 로봇 테스트 결과 업로드
node uploader.js ../250917_상하축이슈/04_작업진행 \
  --folder=s25016/robot-test \
  --ext=.html,.md,.txt \
  --save=robot-upload-results.json

# Hexagon 문서 업로드
node uploader.js ../hexagon \
  --folder=s25016/hexagon \
  --ext=.html \
  --save=hexagon-results.json
```

---

## 주의사항

### 보안

- ⚠️ `.env` 파일은 **절대 Git에 커밋하지 마세요**
- ✅ `.gitignore`에 `.env` 추가 확인
- ✅ API 키는 안전하게 보관

### 파일 크기

- Cloudinary 무료 플랜: 10MB/파일
- 대용량 파일은 분할 업로드 권장

### 속도

- 순차 업로드 (병렬 처리 X)
- 대량 파일은 시간 소요 예상

---

## 문제 해결

### 인증 오류

```
Error: Must supply api_key
```

**해결:** `.env` 파일의 API 정보 확인

### 파일을 찾을 수 없음

```
❌ 디렉토리를 찾을 수 없습니다
```

**해결:** 파일/디렉토리 경로 확인 (절대 경로 또는 상대 경로)

### 업로드 실패

```
❌ 실패: image.jpg
   오류: File size too large
```

**해결:** 파일 크기 확인 (10MB 이하)

---

## npm 스크립트

`package.json`에 정의된 스크립트:

```bash
# 업로더 실행
npm run upload

# 테스트 실행
npm test
```

---

## 라이선스

MIT

---

## 담당

- **프로젝트:** S25016
- **담당자:** SP 심태양
- **위치:** 34bay 자동용접 A라인/B라인

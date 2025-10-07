# 📊 Cloudinary 업로드 대시보드 가이드

## 개요

브라우저에서 드래그 앤 드롭으로 쉽게 파일을 Cloudinary에 업로드할 수 있는 웹 대시보드입니다.

---

## 실행 방법

### 1. 의존성 설치

```bash
cd cloudinary-uploader
npm install
```

### 2. 환경 설정

`.env` 파일이 이미 설정되어 있어야 합니다:

```env
CLOUDINARY_CLOUD_NAME=dmmjpofcc
CLOUDINARY_API_KEY=763721125922284
CLOUDINARY_API_SECRET=vU-nSXa-XQcdh27uyqejE6YBdxA
CLOUDINARY_UPLOAD_FOLDER=s25016
```

### 3. 서버 실행

```bash
npm run server
```

또는 개발 모드 (자동 재시작):

```bash
npm run dev
```

### 4. 브라우저 접속

```
http://localhost:3000
```

---

## 주요 기능

### 1. 파일 선택

**방법 1: 드래그 앤 드롭**
- 파일을 업로드 영역으로 드래그

**방법 2: 클릭하여 선택**
- 업로드 영역 클릭 → 파일 선택 대화상자

### 2. 폴더 지정

- 상단 "📂 Cloudinary 폴더" 입력란에 원하는 폴더명 입력
- 예: `s25016/gallery`, `s25016/documents`
- 기본값: `s25016`

### 3. 확장자 필터 (선택사항)

- "🔍 확장자 필터" 입력란에 원하는 확장자 입력
- 예: `.jpg,.png,.gif` (쉼표로 구분)
- 비워두면 모든 파일 업로드 가능

### 4. 업로드 실행

- "🚀 업로드 시작" 버튼 클릭
- 진행 상황이 실시간으로 표시됨

### 5. 결과 확인

업로드 완료 후 다음 기능 사용 가능:

- **📋 URL 복사**: 모든 URL을 클립보드에 복사
- **💾 JSON 다운로드**: 상세 결과를 JSON 파일로 저장
- **📄 URL 목록 다운로드**: URL 목록을 텍스트 파일로 저장

---

## 화면 구성

### 📊 통계 카드

- **선택된 파일**: 현재 선택한 파일 수
- **업로드 완료**: 성공적으로 업로드된 파일 수
- **업로드 실패**: 실패한 파일 수
- **총 파일 크기**: 선택된 파일의 총 용량 (KB)

### 📋 파일 목록

선택된 파일들의 목록을 표시:
- 파일 아이콘
- 파일명
- 파일 크기
- 상태 (대기 중/완료/실패)

### 📈 진행 바

업로드 진행 상황을 백분율로 표시

### 📝 로그 영역

실시간 업로드 로그:
- 파일별 업로드 상태
- 성공/실패 메시지
- 업로드된 URL
- 최종 통계

---

## 실전 사용 예제

### 예제 1: 이미지 갤러리 업로드

1. 폴더: `s25016/gallery`
2. 확장자: `.jpg,.png,.gif`
3. 이미지 파일 드래그 앤 드롭
4. "🚀 업로드 시작" 클릭
5. 완료 후 "📋 URL 복사"

### 예제 2: 문서 업로드

1. 폴더: `s25016/documents`
2. 확장자: `.pdf,.docx`
3. 문서 파일 선택
4. 업로드 실행
5. "💾 JSON 다운로드"로 결과 저장

### 예제 3: DeviceNet 문서 업로드

1. 폴더: `s25016/devicenet`
2. 확장자: `.pdf,.html`
3. 251003_용접기_디바이스넷 폴더의 파일들 선택
4. 업로드
5. URL 목록 다운로드

---

## API 엔드포인트

### POST /upload

단일 파일 업로드

**요청:**
```
Content-Type: multipart/form-data

file: [파일]
folder: [폴더명]
```

**응답:**
```json
{
  "success": true,
  "file": "example.jpg",
  "url": "https://res.cloudinary.com/...",
  "public_id": "s25016/example"
}
```

### POST /upload-multiple

다중 파일 업로드

**요청:**
```
Content-Type: multipart/form-data

files: [파일1, 파일2, ...]
folder: [폴더명]
```

**응답:**
```json
{
  "total": 3,
  "success": 3,
  "failed": 0,
  "results": [...]
}
```

### GET /files?folder=s25016

업로드된 파일 목록 조회

**응답:**
```json
{
  "total": 10,
  "files": [
    {
      "public_id": "s25016/image1",
      "url": "https://res.cloudinary.com/...",
      "format": "jpg",
      "bytes": 123456,
      "created_at": "2024-10-07T..."
    }
  ]
}
```

### GET /folders

폴더 목록 조회

### DELETE /delete/:public_id

파일 삭제

---

## 문제 해결

### 서버 시작 실패

```bash
# 환경 변수 확인
cat .env

# 포트 충돌 확인
lsof -i :3000

# 다른 포트로 실행
PORT=8080 npm run server
```

### 업로드 실패

- API 키 확인
- 파일 크기 확인 (10MB 이하)
- 네트워크 연결 확인
- 브라우저 콘솔 로그 확인

### CORS 오류

서버가 `cors` 미들웨어를 사용하고 있으므로 문제없어야 함.
만약 발생 시 `server.js`의 CORS 설정 확인.

---

## 보안 주의사항

⚠️ **프로덕션 사용 시:**

1. `.env` 파일을 Git에 커밋하지 마세요
2. API 키를 환경 변수로 관리하세요
3. 파일 크기/타입 검증 강화
4. 인증/권한 시스템 추가
5. HTTPS 사용

---

## 향후 개선 사항

- [ ] 업로드 이력 저장 (DB)
- [ ] 폴더별 파일 브라우저
- [ ] 이미지 미리보기
- [ ] 대용량 파일 청크 업로드
- [ ] 사용자 인증
- [ ] 파일 편집/삭제 기능

---

## 담당

- **프로젝트:** S25016
- **담당자:** SP 심태양
- **위치:** 34bay 자동용접 A라인/B라인

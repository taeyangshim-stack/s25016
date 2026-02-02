# /sync-notion - Google Sheet → Notion 동기화

S25016 펀치리스트를 Google Sheet에서 Notion으로 동기화합니다.

## 환경 설정

```yaml
google_sheet:
  id: "1EqBPn9XrA_5PTg5ks4bgFIjwiojMFDZCYaOkFJINAmE"
  name: "S25016_펀치리스트"

notion:
  database_url: "https://www.notion.so/afb1b88f7ede418caa1a17399ac9f734"
  data_source_id: "66f9a158-d309-4dc9-95cc-88d8d4759cfd"
```

## 실행 단계

### Step 1: Google Sheet 읽기
Google Drive MCP로 시트 데이터 조회:
- `mcp__gdrive__getGoogleSheetContent`
- spreadsheetId: `1EqBPn9XrA_5PTg5ks4bgFIjwiojMFDZCYaOkFJINAmE`
- range: 인자에 따라 결정 (기본: `A1:V500`)

### Step 2: 데이터 파싱
Google Sheet 컬럼 구조:
```
ID, 제목, 분류, 세부분류, 우선순위, 상태, 문제상황, 원인분석,
조치계획, 조치결과, 담당자, 협의자, 승인자, 요청일, 목표일,
완료일, 첨부파일, 댓글, 생성일시, 수정일시, customFields, templateId
```

### Step 3: Notion 매핑 및 업데이트
필드 매핑:
- `ID` → `PunchlistID` (Title)
- `제목` → `항목명`
- `분류` → `분류` (Select)
- `상태` → `상태` (Status)
- `담당자` → `담당자`
- `목표일` → `목표일` (Date)
- `조치결과` → `비고`
- `customFields.line_classification` → `라인` (Multi-select)

### Step 4: 동기화 수행
1. `mcp__notion__notion-search`로 PunchlistID 검색
2. 존재하면 `mcp__notion__notion-update-page`로 업데이트
3. 없으면 `mcp__notion__notion-create-pages`로 생성

### Step 5: 결과 보고
- 업데이트된 항목 수
- 신규 생성 항목 수
- 실패한 항목 (있는 경우)

## 사용법

```bash
# 전체 동기화
/sync-notion

# 특정 ID만
/sync-notion PL-2025-092

# 특정 상태만
/sync-notion --status 진행중

# 최근 수정된 항목만
/sync-notion --recent
```

## 주의사항

1. Google Sheet가 **원본**입니다
2. Notion 데이터는 덮어쓰기됩니다
3. 동기화 전 Notion 중복 확인을 권장합니다

# Apps Script 로그 확인 가이드

## 📊 Apps Script 실행 로그 보기

### 방법 1: 실행 로그 (Executions)

1. **Google Sheets 열기**
   - S25016 근무관리 스프레드시트

2. **Apps Script 편집기 열기**
   ```
   확장 프로그램 → Apps Script
   ```

3. **실행 로그 확인**
   - 왼쪽 메뉴에서 **"실행"** (시계 아이콘) 클릭
   - 또는 상단 메뉴: **보기 → 실행**

4. **최근 실행 내역 확인**
   - 각 실행 항목 클릭하면 상세 로그 표시
   - 삭제 요청 시 "doPost" 함수 실행 내역 확인

### 방법 2: Logger 출력 보기

1. **Apps Script 편집기에서**
   - 상단 메뉴: **보기 → 로그** (Ctrl+Enter)

2. **테스트 함수 실행**
   ```javascript
   // 에디터에서 직접 실행 가능
   function testDelete() {
     const timestamp = "2024-10-09T12:00:00.000Z"; // 실제 타임스탬프
     const result = deleteRecord(timestamp);
     Logger.log("Delete result: " + result);
   }
   ```

---

## 🐛 현재 삭제 안되는 문제 진단

### 증상
- 브라우저 콘솔: "✅ 기록이 삭제되었습니다" 표시
- 실제 Google Sheets: 데이터 그대로 남아있음

### 가능한 원인

#### 원인 1: `mode: 'no-cors'` 문제
- `no-cors` 모드에서는 응답을 읽을 수 없음
- 서버에서 에러가 발생해도 클라이언트는 알 수 없음

#### 원인 2: 타임스탬프 불일치
- Google Sheets의 타임스탬프 형식과 전송된 타임스탬프가 다를 수 있음

#### 원인 3: CORS 에러
- Apps Script가 POST 요청을 차단했을 수 있음

---

## 🔍 즉시 확인할 사항

### 1. 브라우저 개발자 도구 → Network 탭

1. **F12** 누르기
2. **Network** 탭 선택
3. 조회 페이지에서 **"삭제"** 클릭
4. Network 탭에서 **exec** 요청 찾기
5. **클릭** → **Headers** 탭 확인
   - Request URL
   - Request Method (POST여야 함)
   - Status Code

6. **Payload** 탭 확인
   - 전송된 데이터 확인
   - timestamp 값 확인

### 2. Apps Script 배포 상태 확인

1. Apps Script 편집기 열기
2. **배포 → 배포 관리**
3. **최신 배포 날짜** 확인
   - 오늘 날짜여야 함
   - 버전 번호 확인

### 3. Google Sheets 권한 확인

1. Apps Script 편집기에서
2. **첫 실행 시 권한 승인** 필요
3. `deleteRow()` 함수는 **쓰기 권한** 필요

---

## 📝 실제 로그 예시

### 정상 삭제 시 로그:
```
Delete request for timestamp: 2024-10-09T01:30:00.000Z
Row 1: 1728439800000
Row 2: 1728439800000  ← Match!
Record deleted successfully
```

### 실패 시 로그:
```
Delete request for timestamp: 2024-10-09T01:30:00.000Z
Row 1: 1728439800000
Row 2: 1728443400000
Row 3: 1728447000000
Record not found for timestamp: 2024-10-09T01:30:00.000Z
```

---

## 🚨 문제 해결 체크리스트

- [ ] Apps Script 재배포 완료
- [ ] 배포 날짜가 오늘인지 확인
- [ ] F12 → Network → exec 요청 상태 확인
- [ ] Apps Script → 실행 로그에서 에러 확인
- [ ] Google Sheets에서 직접 행 삭제 가능한지 확인 (권한)

---

## 💡 다음 단계

위 정보를 확인한 후:

1. **Apps Script 실행 로그** 스크린샷
2. **Network 탭** 스크린샷 (exec 요청의 Headers, Payload)
3. **Google Sheets 타임스탬프** 컬럼 값 (첫 번째 데이터)

이 정보가 있으면 정확한 원인 파악 가능합니다!

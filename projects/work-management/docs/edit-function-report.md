# 조회 페이지 수정/삭제 기능 점검 보고서

## 📊 **현재 상태 분석**

### ✅ **정상 작동하는 부분**

1. **조회 기능**
   - ✅ Google Sheets에서 데이터 로드
   - ✅ 날짜, 인원, 장소 필터링
   - ✅ 테이블 표시

2. **수정 모달**
   - ✅ 모달 팝업 열기
   - ✅ 기존 데이터 자동 입력
   - ✅ 폼 입력 및 유효성 검사

---

### ⚠️ **문제가 있는 부분**

#### **문제 1: 수정 내용이 Google Sheets에 저장되지 않음**

**현재 동작:**
```javascript
// 조회.html 763-785번 줄
document.getElementById('editForm').addEventListener('submit', function(e) {
    e.preventDefault();

    const index = parseInt(document.getElementById('editIndex').value);

    // LocalStorage에만 저장
    allRecords[index] = { ...수정된 데이터 };
    localStorage.setItem('workRecords', JSON.stringify(allRecords));

    // ❌ Google Sheets에는 저장하지 않음!

    closeEditModal();
    loadRecords();  // Google Sheets에서 다시 로드 → 수정 내용 사라짐!
    applyFilter();
});
```

**증상:**
1. 수정 버튼 클릭 → 모달 열림 ✅
2. 데이터 수정 → 저장 클릭 ✅
3. "기록이 수정되었습니다" 메시지 ✅
4. **페이지 새로고침** → ❌ 수정 내용 사라짐

**원인:**
- `loadRecords()` 함수가 Google Sheets에서 데이터를 다시 가져옴
- LocalStorage의 수정 내용이 Google Sheets 데이터로 덮어씌워짐

---

#### **문제 2: 삭제 기능도 동일한 문제**

**현재 동작:**
```javascript
// 조회.html 788-800번 줄
function deleteRecord(index) {
    if (!confirm('정말 이 기록을 삭제하시겠습니까?')) {
        return;
    }

    // LocalStorage에서만 삭제
    allRecords.splice(index, 1);
    localStorage.setItem('workRecords', JSON.stringify(allRecords));

    // ❌ Google Sheets에서는 삭제하지 않음!

    loadRecords();  // Google Sheets에서 다시 로드 → 삭제한 데이터 다시 나타남!
    applyFilter();
}
```

---

## 🎯 **해결 방법 3가지**

### **방법 1: Google Sheets 쓰기 API 추가 (권장 ⭐)**

**장점:**
- ✅ 완전한 동기화
- ✅ 다른 기기에서도 수정 내용 확인 가능
- ✅ 데이터 영구 저장

**단점:**
- ⚠️ Google Apps Script 코드 추가 필요
- ⚠️ 구현 복잡도 중간

**구현 내용:**
1. GoogleAppsScript.js에 `updateRecord()`, `deleteRecord()` 함수 추가
2. 조회.html에서 수정/삭제 시 Google Sheets API 호출
3. 성공 후 화면 갱신

**예상 작업 시간:** 30분

---

### **방법 2: 임시 해결 (빠른 임시방편)**

**장점:**
- ✅ 즉시 구현 가능 (5분)
- ✅ 코드 수정 최소화

**단점:**
- ⚠️ 수정/삭제 기능 사실상 비활성화
- ⚠️ Google Sheets에서 직접 수정해야 함

**구현 내용:**
1. 수정/삭제 버튼 클릭 시 안내 메시지 표시
2. "Google Sheets에서 직접 수정해주세요" 안내

**코드:**
```javascript
function editRecord(index) {
    alert('⚠️ 현재 수정 기능은 Google Sheets에서 직접 하셔야 합니다.\n\n1. Google Sheets의 "출입기록" 시트 열기\n2. 해당 행 찾아서 수정\n3. 조회 페이지 새로고침');
}

function deleteRecord(index) {
    alert('⚠️ 현재 삭제 기능은 Google Sheets에서 직접 하셔야 합니다.\n\n1. Google Sheets의 "출입기록" 시트 열기\n2. 해당 행 마우스 우클릭 → 행 삭제\n3. 조회 페이지 새로고침');
}
```

---

### **방법 3: 읽기 전용으로 변경**

**장점:**
- ✅ 혼란 방지
- ✅ 명확한 사용자 경험

**단점:**
- ⚠️ 수정/삭제 기능 완전 제거

**구현 내용:**
1. 수정/삭제 버튼 제거
2. "Google Sheets에서 직접 관리" 안내 추가

---

## 📋 **권장 해결 방법: Google Sheets 쓰기 API 추가**

### **1단계: GoogleAppsScript.js에 함수 추가**

다음 함수들을 추가해야 합니다:

```javascript
/**
 * 기록 업데이트 (POST 요청)
 */
function updateRecord(timestamp, updatedData) {
  const sheet = getOrCreateSheet();
  const data = sheet.getDataRange().getValues();

  // 타임스탬프로 행 찾기
  for (let i = 1; i < data.length; i++) {
    if (data[i][0].toString() === timestamp) {
      // 해당 행 업데이트
      sheet.getRange(i + 1, 2).setValue(updatedData.date);
      sheet.getRange(i + 1, 3).setValue(updatedData.name);
      sheet.getRange(i + 1, 4).setValue(updatedData.location);
      sheet.getRange(i + 1, 5).setValue(updatedData.checkIn);
      sheet.getRange(i + 1, 6).setValue(updatedData.checkOut);

      // 근무시간 재계산
      const workHours = calculateWorkHours(updatedData.checkIn, updatedData.checkOut);
      sheet.getRange(i + 1, 7).setValue(workHours);

      sheet.getRange(i + 1, 8).setValue(updatedData.workType);
      sheet.getRange(i + 1, 9).setValue(updatedData.notes);

      return true;
    }
  }

  return false;
}

/**
 * 기록 삭제 (POST 요청)
 */
function deleteRecord(timestamp) {
  const sheet = getOrCreateSheet();
  const data = sheet.getDataRange().getValues();

  // 타임스탬프로 행 찾기
  for (let i = 1; i < data.length; i++) {
    if (data[i][0].toString() === timestamp) {
      sheet.deleteRow(i + 1);
      return true;
    }
  }

  return false;
}

/**
 * POST 요청 처리 (기존 doPost 수정)
 */
function doPost(e) {
  try {
    const data = JSON.parse(e.postData.contents);
    const action = e.parameter.action;

    if (action === 'update') {
      // 업데이트 요청
      const success = updateRecord(data.timestamp, data);
      return ContentService.createTextOutput(JSON.stringify({
        status: success ? 'success' : 'error',
        message: success ? '기록이 수정되었습니다.' : '기록을 찾을 수 없습니다.'
      })).setMimeType(ContentService.MimeType.JSON);

    } else if (action === 'delete') {
      // 삭제 요청
      const success = deleteRecord(data.timestamp);
      return ContentService.createTextOutput(JSON.stringify({
        status: success ? 'success' : 'error',
        message: success ? '기록이 삭제되었습니다.' : '기록을 찾을 수 없습니다.'
      })).setMimeType(ContentService.MimeType.JSON);

    } else {
      // 기존 저장 로직 (새 기록 추가)
      const sheet = getOrCreateSheet();
      saveRecord(sheet, data);

      if (CONFIG.SEND_EMAIL) {
        sendEmail(data);
      }

      return ContentService.createTextOutput(JSON.stringify({
        status: 'success',
        message: '기록이 저장되었습니다.'
      })).setMimeType(ContentService.MimeType.JSON);
    }

  } catch (error) {
    Logger.log('Error: ' + error.toString());
    return ContentService.createTextOutput(JSON.stringify({
      status: 'error',
      message: error.toString()
    })).setMimeType(ContentService.MimeType.JSON);
  }
}
```

### **2단계: 조회.html 수정**

수정 폼 제출 로직 변경:

```javascript
// 수정 폼 제출
document.getElementById('editForm').addEventListener('submit', async function(e) {
    e.preventDefault();

    const index = parseInt(document.getElementById('editIndex').value);
    const record = allRecords[index];

    const updatedData = {
        timestamp: record.timestamp,  // 기존 타임스탬프 유지 (식별용)
        date: document.getElementById('editDate').value,
        name: document.getElementById('editName').value,
        location: document.getElementById('editLocation').value,
        checkIn: document.getElementById('editCheckIn').value || '-',
        checkOut: document.getElementById('editCheckOut').value || '-',
        workType: document.getElementById('editWorkType').value || '-',
        notes: document.getElementById('editNotes').value || '-',
    };

    try {
        // Google Sheets에 업데이트 요청
        const response = await fetch(`${SCRIPT_URL}?action=update`, {
            method: 'POST',
            mode: 'no-cors',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(updatedData)
        });

        closeEditModal();

        // Google Sheets에서 최신 데이터 다시 로드
        await loadRecords();
        applyFilter();

        alert('✅ 기록이 수정되었습니다.');

    } catch (error) {
        console.error('수정 실패:', error);
        alert('❌ 수정에 실패했습니다: ' + error.message);
    }
});
```

삭제 함수 수정:

```javascript
async function deleteRecord(index) {
    if (!confirm('정말 이 기록을 삭제하시겠습니까?')) {
        return;
    }

    const record = allRecords[index];

    try {
        // Google Sheets에 삭제 요청
        const response = await fetch(`${SCRIPT_URL}?action=delete`, {
            method: 'POST',
            mode: 'no-cors',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                timestamp: record.timestamp
            })
        });

        // Google Sheets에서 최신 데이터 다시 로드
        await loadRecords();
        applyFilter();

        alert('✅ 기록이 삭제되었습니다.');

    } catch (error) {
        console.error('삭제 실패:', error);
        alert('❌ 삭제에 실패했습니다: ' + error.message);
    }
}
```

---

## 🎬 **구현 순서**

### **즉시 구현 (방법 1 - 완전한 해결)**

1. **GoogleAppsScript.js 수정**
   - `updateRecord()` 함수 추가
   - `deleteRecord()` 함수 추가
   - `doPost()` 함수 수정 (action 파라미터 처리)

2. **Apps Script 재배포**
   - 배포 → 배포 관리 → 수정 → 새 버전 → 배포

3. **조회.html 수정**
   - 수정 폼 제출 로직 변경
   - 삭제 함수 변경

4. **테스트**
   - 수정 → 저장 → 새로고침 → 수정 내용 유지 확인
   - 삭제 → 새로고침 → 삭제 유지 확인

---

## 📞 **사용자 선택지**

어떤 방법을 원하시나요?

1. **완전한 해결 (방법 1)** - 30분 소요
   - Google Sheets 쓰기 API 구현
   - 수정/삭제가 영구적으로 저장됨

2. **임시 해결 (방법 2)** - 5분 소요
   - 수정/삭제 버튼에 안내 메시지 추가
   - Google Sheets에서 직접 관리하도록 안내

3. **읽기 전용 (방법 3)** - 5분 소요
   - 수정/삭제 버튼 제거
   - 조회 전용으로 변경

---

## 💡 **추천**

**상황 1: 팀에서 자주 수정/삭제하는 경우**
→ **방법 1 (완전한 해결)** 추천

**상황 2: 수정/삭제가 거의 없고, 관리자만 하는 경우**
→ **방법 2 (임시 해결)** 또는 **방법 3 (읽기 전용)** 추천

**상황 3: 일단 빨리 동작하게 하고 싶은 경우**
→ **방법 2 (임시 해결)** 후 나중에 방법 1로 업그레이드

---

## 📊 **현재 기능 상태표**

| 기능 | 현재 상태 | 방법 1 | 방법 2 | 방법 3 |
|------|----------|--------|--------|--------|
| 조회 | ✅ 정상 | ✅ 유지 | ✅ 유지 | ✅ 유지 |
| 필터링 | ✅ 정상 | ✅ 유지 | ✅ 유지 | ✅ 유지 |
| 수정 | ⚠️ 임시만 | ✅ 영구 저장 | ❌ 비활성화 | ❌ 제거 |
| 삭제 | ⚠️ 임시만 | ✅ 영구 저장 | ❌ 비활성화 | ❌ 제거 |
| 동기화 | ✅ 조회만 | ✅ 완전 동기화 | ✅ 조회만 | ✅ 조회만 |

---

어떤 방법으로 진행하시겠습니까?

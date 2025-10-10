# 펀치리스트 확장 기능 사용 가이드

## 개요

펀치리스트 시스템의 확장 기능을 사용하여 프로젝트 특성에 맞게 시스템을 커스터마이징할 수 있습니다.

---

## 1. 새로운 분류 추가하기

### 방법 1: JSON 설정 파일 수정

**파일**: `/punchlist/config/categories.json`

```json
{
  "categories": [
    {
      "id": "safety",
      "name": "안전",
      "icon": "🛡️",
      "color": "#dc2626",
      "description": "안전 관련 이슈",
      "subcategories": [
        {
          "id": "accident",
          "name": "사고",
          "description": "안전사고 관련",
          "keywords": ["사고", "재해", "부상"]
        },
        {
          "id": "hazard",
          "name": "위험요소",
          "description": "잠재적 위험요소",
          "keywords": ["위험", "안전조치", "개선"]
        }
      ]
    }
  ]
}
```

**적용**: 파일 저장 후 페이지 새로고침

### 방법 2: 런타임 추가 (향후 관리자 기능)

```javascript
// 향후 구현 예정
await PunchListAdmin.addCategory({
  id: 'safety',
  name: '안전',
  icon: '🛡️',
  subcategories: [...]
});
```

---

## 2. 커스텀 필드 추가하기

### 예시: "외주 비용" 필드 추가

**파일**: `/punchlist/config/custom-fields.json`

```json
{
  "fields": [
    {
      "id": "vendor_cost",
      "name": "외주 비용",
      "type": "number",
      "unit": "원",
      "required": false,
      "validation": {
        "min": 0,
        "max": 50000000
      },
      "displayCondition": {
        "customFields.vendor_name": ["!= null"]
      },
      "placeholder": "예: 3000000",
      "helpText": "외주 작업 비용을 입력하세요"
    }
  ]
}
```

**필드 타입**:
- `text`: 단순 텍스트
- `number`: 숫자 (min/max 검증 가능)
- `select`: 드롭다운 선택
- `multiselect`: 다중 선택
- `boolean`: 체크박스
- `date`: 날짜 선택
- `datetime`: 날짜+시간
- `textarea`: 긴 텍스트
- `url`: URL 입력

**표시 조건 (displayCondition)**:
특정 조건에서만 필드 표시
```json
"displayCondition": {
  "priority": ["긴급", "높음"],
  "category": ["제어"]
}
```

---

## 3. 새로운 템플릿 만들기

### 예시: "DeviceNet 통신 이슈" 템플릿

**파일**: `/punchlist/templates/special-cases/devicenet-issue-template.json`

```json
{
  "templateId": "devicenet-issue",
  "name": "DeviceNet 통신 이슈",
  "description": "DeviceNet 통신 문제 발생 시 사용",
  "icon": "🔌",
  "version": "1.0",
  "defaultValues": {
    "category": "제어",
    "subcategory": "DeviceNet",
    "priority": "높음"
  },
  "requiredFields": [
    "title",
    "description",
    "owner",
    "customFields.equipment_model",
    "customFields.error_code"
  ],
  "customFields": {
    "equipment_model": {
      "enabled": true,
      "required": true
    },
    "error_code": {
      "enabled": true,
      "required": false
    }
  },
  "helpText": {
    "title": "DeviceNet 통신 문제의 구체적인 증상을 작성하세요",
    "description": "에러 코드, 발생 빈도, 영향 범위를 포함하세요"
  },
  "examples": [
    {
      "title": "B라인 2호기 DeviceNet 통신 끊김",
      "description": "DeviceNet 통신이 불안정하여 용접기 제어 불가\n에러 코드: E-9999\n발생 빈도: 10분마다 1-2회"
    }
  ]
}
```

**템플릿에 커스텀 필드 추가**:

먼저 `custom-fields.json`에 필드 정의:
```json
{
  "id": "error_code",
  "name": "에러 코드",
  "type": "text",
  "placeholder": "예: E-9999",
  "helpText": "시스템에서 표시된 에러 코드를 입력하세요"
}
```

그 다음 템플릿에서 활성화:
```json
{
  "customFields": {
    "error_code": {
      "enabled": true,
      "required": true
    }
  }
}
```

---

## 4. 실제 사용 예시

### 시나리오 1: 외주업체 이슈 등록

1. 이슈 등록 페이지 접속
2. **외주업체 이슈** 템플릿 선택
3. 자동으로 설정되는 항목:
   - 분류: 제어
   - 우선순위: 높음
   - 필수 입력 필드: 외주업체명, 담당자
4. 추가 정보 입력:
   ```
   제목: ABB 로봇 제어기 펌웨어 업데이트
   외주업체: ABB Korea
   담당자: 김엔지니어 (010-1234-5678)
   계약번호: ABB-2024-S25016
   방문 예정일: 2024-10-15
   ```
5. 이슈 등록 → 자동으로 이메일 발송

### 시나리오 2: 긴급 이슈 등록

1. **긴급 대응** 템플릿 선택
2. 자동 설정:
   - 우선순위: 긴급
   - 상태: 진행중
3. 필수 입력:
   ```
   제목: B라인 DeviceNet 통신 끊김
   고객 영향도: 심각
   가동중단 시간: 4시간
   생산 손실량: 200대
   ```
4. 자동 액션:
   - 이메일 + SMS 발송
   - Slack 알림 (설정된 경우)
   - 2시간마다 진행 상황 알림

### 시나리오 3: 정기 점검 등록

1. **정기 점검** 템플릿 선택
2. 점검 유형 선택: 월간점검
3. 입력:
   ```
   제목: A라인 로봇 월간점검
   장비 시리얼: ABB-IRB6700-2024-001
   장비 모델: ABB IRB 6700-200/2.60
   ```
4. 체크리스트 자동 생성:
   - [ ] 정밀 진동 측정
   - [ ] 베어링 상태 점검
   - [ ] 윤활유 보충
   - [ ] 소프트웨어 백업
5. 완료 시 자동으로 다음 점검 일정 등록

---

## 5. 고급 기능

### 5-1. 조건부 필드 표시

**케이스**: 외주업체를 선택했을 때만 "외주 담당자" 필드 표시

```json
{
  "id": "vendor_contact",
  "name": "외주 담당자",
  "type": "text",
  "displayCondition": {
    "customFields.vendor_name": ["ABB Korea", "Lincoln Electric", "Hexagon"]
  }
}
```

### 5-2. 동적 기본값

**케이스**: 긴급 이슈는 에스컬레이션 단계 자동 설정

```json
{
  "id": "escalation_level",
  "name": "에스컬레이션 단계",
  "type": "select",
  "options": ["없음", "1단계-팀장", "2단계-부장", "3단계-임원"],
  "defaultValue": "없음",
  "displayCondition": {
    "priority": ["긴급"]
  }
}
```

템플릿에서:
```json
{
  "defaultValues": {
    "priority": "긴급",
    "customFields.escalation_level": "1단계-팀장"
  }
}
```

### 5-3. 자동 액션

```json
{
  "autoActions": [
    {
      "trigger": "onCreate",
      "condition": "customFields.defect_rate > 5",
      "action": "escalate",
      "escalationLevel": "2단계-부장"
    },
    {
      "trigger": "statusChange",
      "condition": "status === '완료'",
      "action": "requireApproval",
      "approver": "project_manager"
    }
  ]
}
```

---

## 6. 관리 및 유지보수

### 6-1. 설정 백업

```bash
cd /home/qwe/works/s25016/punchlist
cp -r config config_backup_$(date +%Y%m%d)
cp -r templates templates_backup_$(date +%Y%m%d)
```

### 6-2. 설정 검증

```javascript
// 브라우저 콘솔에서 실행
await configLoader.loadCategories()  // 분류 체계 검증
await configLoader.loadCustomFields()  // 커스텀 필드 검증
await configLoader.loadAllTemplates()  // 템플릿 검증
```

### 6-3. 캐시 초기화

설정 파일 변경 후:

```javascript
// 브라우저 콘솔에서
configLoader.clearCache()
location.reload()
```

또는 페이지 강제 새로고침: `Ctrl+Shift+R` (Windows) / `Cmd+Shift+R` (Mac)

---

## 7. 모범 사례

### ✅ 추천

1. **명확한 필드 이름**
   ```json
   "name": "외주 담당자"  // Good
   "name": "담당자2"      // Bad
   ```

2. **도움말 텍스트 제공**
   ```json
   "helpText": "외주업체 엔지니어 이름과 연락처를 입력하세요 (예: 김엔지니어 010-1234-5678)"
   ```

3. **예시 제공**
   ```json
   "placeholder": "예: ABB-2024-S25016"
   ```

4. **검증 규칙 설정**
   ```json
   "validation": {
     "min": 0,
     "max": 100000000
   }
   ```

### ❌ 피해야 할 것

1. **너무 많은 필수 필드**: 사용자 부담 증가
2. **모호한 필드 이름**: "기타1", "항목2" 등
3. **검증 없는 숫자 필드**: 음수 입력 가능
4. **중복 필드**: 같은 정보를 여러 필드에서 수집

---

## 8. 문제 해결

### 문제: 새로 추가한 필드가 보이지 않음

**해결**:
1. JSON 파일 문법 오류 확인 (쉼표, 괄호)
2. 브라우저 캐시 초기화
3. 콘솔에서 에러 메시지 확인 (F12)

### 문제: 템플릿 선택해도 변화가 없음

**해결**:
1. 템플릿 파일명 확인: `{templateId}-template.json`
2. `templateId`와 파일명 일치 확인
3. JSON 구조 검증

### 문제: 커스텀 필드 값이 저장되지 않음

**해결**:
1. Google Sheets에 `customFields` 컬럼 추가 확인
2. Apps Script 코드에서 customFields 처리 로직 확인
3. 네트워크 탭에서 POST 요청 데이터 확인

---

## 9. 다음 단계

- [ ] 플러그인 시스템 사용법 (향후 문서)
- [ ] 워크플로우 자동화 (향후 문서)
- [ ] 관리자 대시보드 사용법 (향후 문서)

---

**작성일**: 2024-10-10
**버전**: 1.0
**작성자**: S25016 프로젝트 팀

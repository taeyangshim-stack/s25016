# 펀치리스트 시스템 확장성 설계

## 개요

실제 프로젝트 운영 중 다양한 특수 케이스와 요구사항이 발생할 수 있습니다.
이 문서는 펀치리스트 시스템의 확장 가능한 구조를 정의합니다.

---

## 1. 확장 가능한 분류 체계

### 1-1. 현재 구조의 한계

**고정된 분류**:
```javascript
const CATEGORIES = {
  '기계': ['구조물', '프레임', '이송장치', '기타'],
  '전기': ['배선', '센서', '모터', '전원', '기타'],
  '제어': ['로봇', 'UI/HMI', '계측', 'PLC', '기타']
};
```

**문제점**:
- 새로운 분류 추가 시 코드 수정 필요
- 프로젝트별로 다른 분류 체계 사용 불가
- 3단계 이상 계층 구조 불가능

### 1-2. 개선된 구조 (JSON 기반 설정)

**파일: `/punchlist/config/categories.json`**
```json
{
  "version": "1.0",
  "lastUpdated": "2024-10-10",
  "categories": [
    {
      "id": "mechanical",
      "name": "기계",
      "icon": "🔧",
      "color": "#3b82f6",
      "subcategories": [
        {
          "id": "structure",
          "name": "구조물",
          "description": "프레임, 베이스 등 구조물 관련"
        },
        {
          "id": "frame",
          "name": "프레임",
          "description": "기계 프레임 및 하우징"
        },
        {
          "id": "transport",
          "name": "이송장치",
          "description": "컨베이어, 리프터 등"
        },
        {
          "id": "custom",
          "name": "기타",
          "description": "기타 기계 관련 이슈",
          "allowCustomInput": true
        }
      ]
    },
    {
      "id": "electrical",
      "name": "전기",
      "icon": "⚡",
      "color": "#f59e0b",
      "subcategories": [
        {
          "id": "wiring",
          "name": "배선",
          "description": "전기 배선 및 케이블"
        },
        {
          "id": "sensor",
          "name": "센서",
          "description": "각종 센서류"
        },
        {
          "id": "motor",
          "name": "모터",
          "description": "서보모터, 스테핑모터 등"
        },
        {
          "id": "power",
          "name": "전원",
          "description": "전원공급장치, UPS 등"
        },
        {
          "id": "custom",
          "name": "기타",
          "allowCustomInput": true
        }
      ]
    },
    {
      "id": "control",
      "name": "제어",
      "icon": "💻",
      "color": "#10b981",
      "subcategories": [
        {
          "id": "robot",
          "name": "로봇",
          "description": "로봇 제어 관련"
        },
        {
          "id": "ui_hmi",
          "name": "UI/HMI",
          "description": "사용자 인터페이스"
        },
        {
          "id": "measurement",
          "name": "계측",
          "description": "측정 및 검증"
        },
        {
          "id": "plc",
          "name": "PLC",
          "description": "PLC 프로그램 및 로직"
        },
        {
          "id": "custom",
          "name": "기타",
          "allowCustomInput": true
        }
      ]
    }
  ],
  "customCategories": []
}
```

**장점**:
- ✅ 코드 수정 없이 분류 추가/수정 가능
- ✅ 아이콘, 색상 커스터마이징
- ✅ 설명(description) 추가로 사용자 가이드 제공
- ✅ customCategories로 런타임 추가 가능

---

## 2. 커스텀 필드 시스템

### 2-1. 특수 케이스 예시

프로젝트 운영 중 다음과 같은 추가 필드가 필요할 수 있습니다:

- **비용 관련**: 예상 비용, 실제 비용, 예산 코드
- **외주 관련**: 외주업체명, 계약번호, 담당 엔지니어
- **장비 관련**: 장비 시리얼번호, 제조사, 모델명
- **안전 관련**: 위험도 등급, 안전 조치사항
- **품질 관련**: 불량률, 검사 결과
- **긴급 대응**: 고객사 요청번호, 클레임 여부

### 2-2. 커스텀 필드 스키마

**파일: `/punchlist/config/custom-fields.json`**
```json
{
  "version": "1.0",
  "fields": [
    {
      "id": "estimated_cost",
      "name": "예상 비용",
      "type": "number",
      "unit": "원",
      "required": false,
      "defaultValue": 0,
      "validation": {
        "min": 0,
        "max": 100000000
      },
      "displayCondition": {
        "priority": ["긴급", "높음"]
      }
    },
    {
      "id": "vendor_name",
      "name": "외주업체",
      "type": "select",
      "options": [
        "ABB Korea",
        "Lincoln Electric",
        "Hexagon",
        "직접입력"
      ],
      "required": false,
      "allowCustomInput": true
    },
    {
      "id": "equipment_serial",
      "name": "장비 시리얼번호",
      "type": "text",
      "pattern": "^[A-Z0-9-]+$",
      "placeholder": "예: ABB-2024-001",
      "required": false
    },
    {
      "id": "risk_level",
      "name": "위험도",
      "type": "select",
      "options": ["상", "중", "하"],
      "required": false,
      "defaultValue": "하",
      "color": {
        "상": "#dc2626",
        "중": "#f59e0b",
        "하": "#10b981"
      }
    },
    {
      "id": "customer_request_no",
      "name": "고객 요청번호",
      "type": "text",
      "required": false,
      "displayCondition": {
        "category": ["제어"]
      }
    },
    {
      "id": "claim_flag",
      "name": "클레임 여부",
      "type": "boolean",
      "defaultValue": false,
      "required": false
    }
  ]
}
```

### 2-3. 필드 타입 지원

| 타입 | 설명 | 예시 |
|------|------|------|
| **text** | 단순 텍스트 입력 | 장비명, 시리얼번호 |
| **number** | 숫자 입력 (min/max) | 비용, 수량 |
| **select** | 드롭다운 선택 | 외주업체, 위험도 |
| **multiselect** | 다중 선택 | 관련 장비 목록 |
| **boolean** | 예/아니오 | 클레임 여부 |
| **date** | 날짜 선택 | 점검일 |
| **datetime** | 날짜+시간 | 발생 시각 |
| **textarea** | 긴 텍스트 | 상세 설명 |
| **file** | 파일 첨부 | 사진, 문서 |
| **url** | URL 입력 | 관련 링크 |

---

## 3. 템플릿 시스템

### 3-1. 특수 케이스별 템플릿

**파일: `/punchlist/templates/special-cases/`**

#### 외주업체 이슈 템플릿
**`vendor-issue-template.json`**
```json
{
  "templateId": "vendor-issue",
  "name": "외주업체 이슈",
  "description": "외주업체 관련 이슈를 등록할 때 사용",
  "icon": "🏢",
  "defaultValues": {
    "category": "제어",
    "priority": "높음"
  },
  "requiredFields": [
    "vendor_name",
    "contact_person",
    "contract_no"
  ],
  "customFields": [
    {
      "id": "vendor_name",
      "name": "외주업체명",
      "type": "select",
      "options": ["ABB Korea", "Lincoln Electric", "Hexagon"],
      "required": true
    },
    {
      "id": "contact_person",
      "name": "담당 엔지니어",
      "type": "text",
      "required": true
    },
    {
      "id": "contract_no",
      "name": "계약번호",
      "type": "text",
      "required": true
    },
    {
      "id": "visit_schedule",
      "name": "방문 예정일",
      "type": "date",
      "required": false
    }
  ],
  "autoActions": [
    {
      "trigger": "onCreate",
      "action": "sendEmail",
      "recipients": ["vendor_contact", "project_manager"]
    }
  ]
}
```

#### 긴급 대응 템플릿
**`emergency-template.json`**
```json
{
  "templateId": "emergency",
  "name": "긴급 대응",
  "description": "긴급 이슈 발생 시 사용",
  "icon": "🚨",
  "defaultValues": {
    "priority": "긴급",
    "status": "진행중"
  },
  "requiredFields": [
    "title",
    "description",
    "owner",
    "immediate_action"
  ],
  "customFields": [
    {
      "id": "immediate_action",
      "name": "즉시 조치사항",
      "type": "textarea",
      "required": true,
      "placeholder": "즉시 취한 조치를 기록하세요"
    },
    {
      "id": "escalation_level",
      "name": "에스컬레이션 단계",
      "type": "select",
      "options": ["1단계-팀장", "2단계-부장", "3단계-임원"],
      "required": true
    },
    {
      "id": "customer_impact",
      "name": "고객 영향도",
      "type": "select",
      "options": ["없음", "낮음", "중간", "높음", "심각"],
      "required": true
    }
  ],
  "autoActions": [
    {
      "trigger": "onCreate",
      "action": "sendSMS",
      "recipients": ["owner", "approver"]
    },
    {
      "trigger": "statusChange",
      "condition": "status === '완료'",
      "action": "requireApproval"
    }
  ]
}
```

#### 정기 점검 템플릿
**`inspection-template.json`**
```json
{
  "templateId": "inspection",
  "name": "정기 점검",
  "description": "정기 점검 항목 등록",
  "icon": "🔍",
  "defaultValues": {
    "priority": "보통",
    "status": "신규"
  },
  "customFields": [
    {
      "id": "inspection_type",
      "name": "점검 유형",
      "type": "select",
      "options": ["일일점검", "주간점검", "월간점검", "연간점검"],
      "required": true
    },
    {
      "id": "checklist_items",
      "name": "점검 항목",
      "type": "checklist",
      "items": [
        "전원 상태 확인",
        "센서 동작 확인",
        "모터 이상음 확인",
        "배선 연결 상태 확인",
        "안전장치 동작 확인"
      ]
    },
    {
      "id": "next_inspection_date",
      "name": "다음 점검일",
      "type": "date",
      "autoCalculate": {
        "based_on": "complete_date",
        "interval": "30 days"
      }
    }
  ]
}
```

### 3-2. 템플릿 선택 UI

이슈 생성 시 템플릿 선택 화면:

```
┌────────────────────────────────────────────────┐
│  새 이슈 등록 - 템플릿 선택                       │
├────────────────────────────────────────────────┤
│                                                │
│  📋 기본 템플릿                                 │
│     일반적인 이슈를 등록합니다                    │
│     [선택]                                      │
│                                                │
│  🏢 외주업체 이슈                                │
│     외주업체 관련 이슈 (담당자, 계약번호 포함)     │
│     [선택]                                      │
│                                                │
│  🚨 긴급 대응                                    │
│     긴급 이슈 (즉시 조치사항, 에스컬레이션)        │
│     [선택]                                      │
│                                                │
│  🔍 정기 점검                                    │
│     정기 점검 항목 (체크리스트 포함)               │
│     [선택]                                      │
│                                                │
└────────────────────────────────────────────────┘
```

---

## 4. 플러그인 시스템

### 4-1. 플러그인 구조

**파일: `/punchlist/plugins/README.md`**

플러그인으로 다음 기능 확장 가능:

- **데이터 소스**: Google Sheets 외 다른 백엔드 (Airtable, Firebase 등)
- **알림 채널**: 이메일 외 Slack, Teams, 카카오톡
- **데이터 변환**: CSV/Excel/PDF 내보내기
- **통계/리포트**: 커스텀 대시보드, 차트
- **워크플로우**: 승인 프로세스, 자동화 규칙

**플러그인 예시: Slack 알림**
```javascript
// /punchlist/plugins/slack-notification/plugin.json
{
  "pluginId": "slack-notification",
  "name": "Slack 알림",
  "version": "1.0.0",
  "description": "이슈 발생 시 Slack으로 알림을 전송합니다",
  "author": "S25016 Team",
  "main": "index.js",
  "config": {
    "webhookUrl": "https://hooks.slack.com/services/...",
    "channel": "#punchlist",
    "events": ["onCreate", "onUpdate", "onStatusChange"]
  }
}

// /punchlist/plugins/slack-notification/index.js
class SlackNotificationPlugin {
  constructor(config) {
    this.webhookUrl = config.webhookUrl;
    this.channel = config.channel;
  }

  async onCreate(issue) {
    const message = {
      text: `🆕 새 이슈: ${issue.title}`,
      attachments: [
        {
          color: this.getPriorityColor(issue.priority),
          fields: [
            { title: "분류", value: issue.category, short: true },
            { title: "우선순위", value: issue.priority, short: true },
            { title: "담당자", value: issue.owner, short: true }
          ]
        }
      ]
    };

    await fetch(this.webhookUrl, {
      method: 'POST',
      body: JSON.stringify(message)
    });
  }

  getPriorityColor(priority) {
    const colors = {
      '긴급': 'danger',
      '높음': 'warning',
      '보통': 'good',
      '낮음': '#cccccc'
    };
    return colors[priority] || 'good';
  }
}

module.exports = SlackNotificationPlugin;
```

### 4-2. 플러그인 등록

**파일: `/punchlist/config/plugins.json`**
```json
{
  "enabled": [
    {
      "pluginId": "slack-notification",
      "enabled": true,
      "config": {
        "webhookUrl": "https://hooks.slack.com/services/YOUR_WEBHOOK",
        "channel": "#s25016-punchlist",
        "events": ["onCreate", "onStatusChange"]
      }
    },
    {
      "pluginId": "pdf-export",
      "enabled": true,
      "config": {
        "template": "default",
        "includeComments": true,
        "includeAttachments": true
      }
    }
  ]
}
```

---

## 5. 동적 워크플로우

### 5-1. 워크플로우 정의

**파일: `/punchlist/config/workflows.json`**
```json
{
  "workflows": [
    {
      "id": "high-priority-approval",
      "name": "높은 우선순위 승인 프로세스",
      "trigger": {
        "event": "onCreate",
        "condition": "priority === '긴급' || priority === '높음'"
      },
      "steps": [
        {
          "step": 1,
          "action": "requireApproval",
          "approver": "project_manager",
          "timeout": "2 hours"
        },
        {
          "step": 2,
          "action": "notifyStakeholders",
          "recipients": ["owner", "collaborators"]
        },
        {
          "step": 3,
          "action": "scheduleFollowUp",
          "interval": "24 hours"
        }
      ]
    },
    {
      "id": "vendor-escalation",
      "name": "외주업체 에스컬레이션",
      "trigger": {
        "event": "onUpdate",
        "condition": "customFields.vendor_name && daysOpen > 7"
      },
      "steps": [
        {
          "step": 1,
          "action": "sendEmail",
          "template": "vendor-escalation",
          "recipients": ["vendor_manager", "project_manager"]
        },
        {
          "step": 2,
          "action": "updateStatus",
          "newStatus": "보류",
          "reason": "외주업체 대응 지연"
        }
      ]
    }
  ]
}
```

---

## 6. 데이터 마이그레이션 전략

### 6-1. 버전 관리

스키마 변경 시 자동 마이그레이션:

**파일: `/punchlist/migrations/001_add_custom_fields.js`**
```javascript
// Google Apps Script
function migrate_001_add_custom_fields() {
  const sheet = SpreadsheetApp.openById(SHEET_ID).getActiveSheet();
  const headers = sheet.getRange(1, 1, 1, sheet.getLastColumn()).getValues()[0];

  const newColumns = [
    'customFields',  // JSON 문자열로 저장
    'templateId',
    'pluginData'
  ];

  newColumns.forEach((col, index) => {
    if (!headers.includes(col)) {
      const newColIndex = headers.length + 1 + index;
      sheet.insertColumnAfter(headers.length);
      sheet.getRange(1, newColIndex).setValue(col);
    }
  });

  Logger.log('Migration 001 completed');
}
```

### 6-2. 스키마 버전 관리

**Google Sheets 시트에 추가**:
```
시트명: _metadata
컬럼: key | value
데이터:
  schema_version | 2.0
  last_migration | 001_add_custom_fields
  migration_date | 2024-10-10T10:00:00Z
```

---

## 7. 구현 우선순위

### Phase 1: 기본 확장성 (즉시 구현)
- [x] 커스텀 필드 시스템 (custom-fields.json)
- [x] 분류 체계 JSON 설정 (categories.json)
- [ ] Google Sheets 컬럼 추가 (customFields)

### Phase 2: 템플릿 시스템 (1주 내)
- [ ] 템플릿 정의 구조
- [ ] 외주업체 템플릿
- [ ] 긴급 대응 템플릿
- [ ] 템플릿 선택 UI

### Phase 3: 플러그인 시스템 (2주 내)
- [ ] 플러그인 인터페이스 정의
- [ ] Slack 알림 플러그인
- [ ] PDF 내보내기 플러그인

### Phase 4: 고급 기능 (1개월 내)
- [ ] 동적 워크플로우
- [ ] 데이터 마이그레이션 도구
- [ ] 관리자 설정 페이지

---

## 8. 사용 예시

### 예시 1: 외주업체 이슈 등록

```javascript
// 외주업체 템플릿으로 이슈 생성
const vendorIssue = {
  templateId: 'vendor-issue',
  title: 'ABB 로봇 제어기 펌웨어 업데이트 필요',
  category: '제어',
  subcategory: '로봇',
  priority: '높음',
  description: 'IRB 6700 로봇 제어기 펌웨어 버전 업데이트 필요',
  owner: '심태양',
  customFields: {
    vendor_name: 'ABB Korea',
    contact_person: '김엔지니어',
    contract_no: 'ABB-2024-S25016',
    visit_schedule: '2024-10-15'
  }
};

await PunchListAPI.createIssue(vendorIssue);
// → 자동으로 ABB 담당자와 PM에게 이메일 발송
```

### 예시 2: 긴급 이슈 등록

```javascript
const emergencyIssue = {
  templateId: 'emergency',
  title: 'B라인 용접기 DeviceNet 통신 끊김',
  category: '제어',
  priority: '긴급',
  description: '생산 라인 정지 상태',
  owner: '심태양',
  customFields: {
    immediate_action: '수동 모드로 전환, 예비 장비 투입',
    escalation_level: '2단계-부장',
    customer_impact: '심각'
  }
};

await PunchListAPI.createIssue(emergencyIssue);
// → SMS 알림 + Slack 알림 + 이메일 발송
// → 자동으로 상태: '진행중'으로 설정
```

---

## 9. 마이그레이션 가이드

기존 시스템에서 확장 시스템으로 마이그레이션:

### Step 1: 설정 파일 생성
```bash
cd /home/qwe/works/s25016/punchlist
mkdir -p config templates/special-cases plugins migrations
```

### Step 2: Google Sheets 컬럼 추가
```javascript
// Apps Script에서 실행
function addCustomFieldsColumn() {
  const sheet = SpreadsheetApp.openById(SHEET_ID).getActiveSheet();
  const lastCol = sheet.getLastColumn();
  sheet.getRange(1, lastCol + 1).setValue('customFields');
  sheet.getRange(1, lastCol + 2).setValue('templateId');
}
```

### Step 3: 클라이언트 코드 업데이트
```javascript
// punchlist.js에 추가
async function loadCategories() {
  const response = await fetch('/punchlist/config/categories.json');
  return await response.json();
}

async function loadCustomFields() {
  const response = await fetch('/punchlist/config/custom-fields.json');
  return await response.json();
}
```

---

## 10. 결론

이 확장성 설계를 통해:

✅ **유연성**: 코드 수정 없이 설정 파일로 확장
✅ **재사용성**: 템플릿으로 반복 작업 간소화
✅ **확장성**: 플러그인으로 무한 확장 가능
✅ **유지보수성**: JSON 설정으로 관리 용이
✅ **호환성**: 기존 데이터 유지하면서 점진적 개선

프로젝트 진행하면서 발생하는 특수 케이스를 유연하게 대응할 수 있습니다.

---

**작성일**: 2024-10-10
**버전**: 1.0
**작성자**: S25016 프로젝트 팀

/**
 * S25016 Gantt Chart Data
 * Auto-generated from gantt-legacy.html
 * This file contains all schedule data for the gantt chart renderer.
 *
 * @version 2.0.0 (2026-02-11) - gantt-legacy.html에서 데이터 추출
 *   - 7개 담당자, 27일, 170개 task bar
 *   - 20개 day-card, 84개 이슈명 매핑
 */
window.GANTT_DATA = {
  "meta": {
    "title": "S25016 3주 완료 계획 일정표 (Full)",
    "totalTasks": "총 53건",
    "ownerCount": "담당자 6명",
    "dateRange": "2026.01.19 ~ 2026.02.14 (27일)",
    "updated": "2/11",
    "baseUrl": "https://s2501602.vercel.app/punchlist/pages/detail.html"
  },
  "weeks": [
    {
      "label": "1주차 (29건) 1/19~1/25",
      "span": 7,
      "cssClass": "w1"
    },
    {
      "label": "2주차 (27건) 1/26~2/1",
      "span": 7,
      "cssClass": "w2"
    },
    {
      "label": "3주차 (31건) 2/2~2/7",
      "span": 6,
      "cssClass": "w3"
    },
    {
      "label": "4주차 (35건) 2/8~2/14",
      "span": 7,
      "cssClass": "w4"
    }
  ],
  "days": [
    {
      "date": "2026-01-19",
      "dayOfWeek": "월",
      "label": "1/19",
      "isWeekend": false,
      "weekStart": true
    },
    {
      "date": "2026-01-20",
      "dayOfWeek": "화",
      "label": "1/20",
      "isWeekend": false
    },
    {
      "date": "2026-01-21",
      "dayOfWeek": "수",
      "label": "1/21",
      "isWeekend": false
    },
    {
      "date": "2026-01-22",
      "dayOfWeek": "목",
      "label": "1/22",
      "isWeekend": false
    },
    {
      "date": "2026-01-23",
      "dayOfWeek": "금",
      "label": "1/23",
      "isWeekend": false
    },
    {
      "date": "2026-01-24",
      "dayOfWeek": "토",
      "label": "1/24",
      "isWeekend": true
    },
    {
      "date": "2026-01-25",
      "dayOfWeek": "일",
      "label": "1/25",
      "isWeekend": true
    },
    {
      "date": "2026-01-26",
      "dayOfWeek": "월",
      "label": "1/26",
      "isWeekend": false,
      "weekStart": true
    },
    {
      "date": "2026-01-27",
      "dayOfWeek": "화",
      "label": "1/27",
      "isWeekend": false
    },
    {
      "date": "2026-01-28",
      "dayOfWeek": "수",
      "label": "1/28",
      "isWeekend": false
    },
    {
      "date": "2026-01-29",
      "dayOfWeek": "목",
      "label": "1/29",
      "isWeekend": false
    },
    {
      "date": "2026-01-30",
      "dayOfWeek": "금",
      "label": "1/30",
      "isWeekend": false
    },
    {
      "date": "2026-01-31",
      "dayOfWeek": "토",
      "label": "1/31",
      "isWeekend": true
    },
    {
      "date": "2026-02-01",
      "dayOfWeek": "일",
      "label": "2/1",
      "isWeekend": true
    },
    {
      "date": "2026-02-02",
      "dayOfWeek": "월",
      "label": "2/2",
      "isWeekend": false,
      "weekStart": true
    },
    {
      "date": "2026-02-03",
      "dayOfWeek": "화",
      "label": "2/3",
      "isWeekend": false
    },
    {
      "date": "2026-02-04",
      "dayOfWeek": "수",
      "label": "2/4",
      "isWeekend": false
    },
    {
      "date": "2026-02-05",
      "dayOfWeek": "목",
      "label": "2/5",
      "isWeekend": false
    },
    {
      "date": "2026-02-06",
      "dayOfWeek": "금",
      "label": "2/6",
      "isWeekend": false
    },
    {
      "date": "2026-02-07",
      "dayOfWeek": "토",
      "label": "2/7",
      "isWeekend": true,
      "annotation": "✓9완료",
      "cellStyle": "completed-bg"
    },
    {
      "date": "2026-02-08",
      "dayOfWeek": "일",
      "label": "2/8",
      "isWeekend": true
    },
    {
      "date": "2026-02-09",
      "dayOfWeek": "월",
      "label": "2/9",
      "isWeekend": false,
      "weekStart": true,
      "annotation": "✓7배포"
    },
    {
      "date": "2026-02-10",
      "dayOfWeek": "화",
      "label": "2/10",
      "isWeekend": false,
      "annotation": "✓4컨펌",
      "cellStyle": "completed-bg"
    },
    {
      "date": "2026-02-11",
      "dayOfWeek": "수",
      "label": "2/11",
      "isWeekend": false,
      "annotation": "TODAY"
    },
    {
      "date": "2026-02-12",
      "dayOfWeek": "목",
      "label": "2/12",
      "isWeekend": false
    },
    {
      "date": "2026-02-13",
      "dayOfWeek": "금",
      "label": "2/13",
      "isWeekend": false
    },
    {
      "date": "2026-02-14",
      "dayOfWeek": "토",
      "label": "2/14",
      "isWeekend": true
    }
  ],
  "legends": [
    {
      "color": "#dc2626",
      "label": "긴급",
      "type": "urgent"
    },
    {
      "color": "#f59e0b",
      "label": "높음",
      "type": "high"
    },
    {
      "color": "#10b981",
      "label": "보통",
      "type": "normal"
    },
    {
      "color": "#6b7280",
      "label": "낮음",
      "type": "low"
    },
    {
      "color": "#3b82f6",
      "label": "검증중",
      "type": "verify"
    },
    {
      "color": "#059669",
      "label": "✓ 완료",
      "type": "completed"
    },
    {
      "type": "delayed",
      "label": "⚠ 지연"
    },
    {
      "type": "pending",
      "label": "? 미처리"
    }
  ],
  "filters": [
    {
      "label": "전체",
      "value": "all",
      "active": true
    },
    {
      "label": "긴급",
      "value": "urgent"
    },
    {
      "label": "높음",
      "value": "high"
    },
    {
      "label": "보통",
      "value": "normal"
    },
    {
      "label": "낮음",
      "value": "low"
    },
    {
      "label": "✓ 완료",
      "value": "completed",
      "cssClass": "filter-btn--completed"
    },
    {
      "label": "⚠ 지연",
      "value": "delayed",
      "cssClass": "filter-btn--delayed"
    },
    {
      "label": "? 미처리",
      "value": "pending",
      "cssClass": "filter-btn--pending"
    }
  ],
  "owners": [
    {
      "name": "박주한",
      "avatar": "박",
      "gradient": [
        "#00d4ff",
        "#0066ff"
      ],
      "taskCount": "8건 (UI/HMI)",
      "cells": [
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {
          "bars": [
            {
              "label": "193 수동티칭✓",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "PL-2026-193",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-193",
                "description": "A라인 수동 티칭 (노즐 클리너)",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 2/3 완료"
                  }
                ]
              }
            }
          ]
        },
        {},
        {
          "bars": [
            {
              "label": "089 돌림옵셋✓",
              "status": "completed",
              "tooltip": {
                "title": "PL-2025-089",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-089",
                "description": "돌림 오프셋 조정 (계속)"
              }
            }
          ]
        },
        {},
        {
          "bars": [
            {
              "label": "088 권한설정",
              "status": "completed-past",
              "tooltip": {
                "title": "PL-2025-088",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-088",
                "description": "권한 설정 기능 (계속)"
              }
            }
          ]
        },
        {},
        {},
        {
          "bars": [
            {
              "label": "096 용접선필터",
              "priority": "verify",
              "tooltip": {
                "title": "PL-2025-096",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-096",
                "description": "비정상 용접선 정보 필터링",
                "rows": [
                  {
                    "label": "상태",
                    "value": "2/2 진행예정"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "060 알람✓",
              "status": "completed",
              "tooltip": {
                "title": "PL-2025-060",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-060",
                "description": "시뮬레이션 vs 실제 상이한 알람",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 완료"
                  }
                ]
              }
            },
            {
              "label": "104 로그",
              "priority": "normal",
              "tooltip": {
                "title": "PL-2025-104",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-104",
                "description": "UI 조작 로그 기능"
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "157 터치옵셋",
              "priority": "normal",
              "tooltip": {
                "title": "PL-2025-157",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-157",
                "description": "터치 오프셋 일괄 변경 기능",
                "rows": [
                  {
                    "label": "대상",
                    "value": "A/B라인 공통"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "157 계속",
              "priority": "normal",
              "tooltip": {
                "title": "PL-2025-157",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-157",
                "description": "터치 오프셋 일괄 변경 기능 (계속)"
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "093 매뉴얼",
              "priority": "low",
              "tooltip": {
                "title": "PL-2025-093",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-093",
                "description": "사용자 매뉴얼 작성"
              }
            }
          ]
        },
        {
          "style": "background:rgba(5,150,105,0.15);",
          "bars": [
            {
              "label": "093 계속",
              "priority": "low",
              "tooltip": {
                "title": "PL-2025-093",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-093",
                "description": "사용자 매뉴얼 작성 (계속)"
              }
            },
            {
              "label": "217 리밋✓",
              "status": "completed",
              "fontSize": "0.55rem",
              "tooltip": {
                "title": "PL-2026-217",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-217",
                "description": "하드/소프트 리밋 Bypass 로직 오류",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 2/7 완료"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "084 알람✓배포",
              "status": "completed",
              "fontSize": "0.55rem",
              "tooltip": {
                "title": "PL-2025-084",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-084",
                "description": "PLC 알람 체크",
                "rows": [
                  {
                    "label": "상태",
                    "value": "📦 2/8 배포"
                  }
                ]
              }
            },
            {
              "label": "061 알람배포",
              "status": "completed",
              "fontSize": "0.55rem",
              "tooltip": {
                "title": "PL-2025-061",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-061",
                "description": "알람처리 (팬던트>UI>관제)",
                "rows": [
                  {
                    "label": "상태",
                    "value": "📦 2/8 배포"
                  }
                ]
              }
            },
            {
              "label": "067 알람배포",
              "status": "completed",
              "fontSize": "0.55rem",
              "tooltip": {
                "title": "PL-2025-067",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-067",
                "description": "공압/가스 알람처리(UI)",
                "rows": [
                  {
                    "label": "상태",
                    "value": "📦 2/8 배포"
                  }
                ]
              }
            },
            {
              "label": "196 팝업배포",
              "status": "completed",
              "fontSize": "0.55rem",
              "tooltip": {
                "title": "PL-2026-196",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-196",
                "description": "커스텀 팝업",
                "rows": [
                  {
                    "label": "상태",
                    "value": "📦 2/8 컨펌배포"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "15건",
              "priority": "normal",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "2/9(월) 15건",
                "description": "배포완료 7건 / 컨펌배포·테스트 8건",
                "rows": [
                  {
                    "label": "주요",
                    "value": "091,099,104,171,173,023,170,216,093 배포"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "23건",
              "priority": "normal",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "2/10(화) 23건",
                "description": "컨펌배포 6건 / 테스트 5건",
                "rows": [
                  {
                    "label": "주요",
                    "value": "065,091,099,104,171,173,023,096,170,216,093"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "20건",
              "priority": "normal",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "2/11(수) 20건",
                "description": "부분보완/컨펌배포 4건, 컨펌배포 8건, 테스트 5건 등",
                "rows": [
                  {
                    "label": "주요",
                    "value": "152,155,153,170 부분보완 / 020,169,200,115,175,195 컨펌배포"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "14건",
              "priority": "normal",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "2/12(목) 14건",
                "description": "컨펌배포 12건, 작성중 1건 등",
                "rows": [
                  {
                    "label": "주요",
                    "value": "065,091,099,104,020,169,200,215,115,175,195,216,100 컨펌배포"
                  }
                ]
              }
            }
          ]
        },
        {},
        {
          "bars": [
            {
              "label": "088 권한설정",
              "priority": "normal",
              "fontSize": "0.55rem",
              "style": "background:#9ca3af;",
              "tooltip": {
                "title": "PL-2025-088",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-088",
                "description": "작업자/관리자 권한 설정",
                "rows": [
                  {
                    "label": "상태",
                    "value": "Event (일정 마지막날)"
                  }
                ]
              }
            }
          ]
        }
      ]
    },
    {
      "name": "B라인 검증",
      "avatar": "B",
      "gradient": [
        "#2ed573",
        "#26de81"
      ],
      "taskCount": "14건 (박주한)",
      "cells": [
        {
          "style": "background:#f0fdf4;",
          "bars": [
            {
              "label": "#1 디지털트윈 ✓완료",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "PL-2025-106",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-106",
                "description": "디지털 트윈 Lag 이슈",
                "rows": [
                  {
                    "label": "원계획",
                    "value": "1/19"
                  },
                  {
                    "label": "상태",
                    "value": "✓ 완료 (2/2)"
                  }
                ]
              }
            },
            {
              "label": "#2 용접선필터",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "PL-2025-096 연계",
                "description": "비정상 용접선 정보 필터링",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/19 완료"
                  }
                ]
              }
            },
            {
              "label": "#7 동적리미트",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "PL-2025-062 연계",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-062",
                "description": "갠트리 수동 이동 시 동적 리미트",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/19 완료"
                  }
                ]
              }
            },
            {
              "label": "#8 Z홈선택",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "PL-2025-132",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-132",
                "description": "기본 Z홈 선택",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/19 완료"
                  }
                ]
              }
            },
            {
              "label": "#10 토크가시성",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "PL-2026-203",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-203",
                "description": "토크 축 가독/가시성 향상",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/19 완료"
                  }
                ]
              }
            },
            {
              "label": "#13 홀센서 → 2/10",
              "status": "completed-past",
              "fontSize": "0.65rem",
              "style": "opacity:0.4;",
              "tooltip": {
                "title": "PL-2025-155",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-155",
                "description": "홀센서 기반 원점 인식",
                "rows": [
                  {
                    "label": "상태",
                    "value": "2/10 컨펌완료, UI 배치 수정 잔여"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "#3 데드라인",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "PL-2026-204",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-204",
                "description": "명령 유형 별 기초 데드라인 구성",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/20 완료"
                  }
                ]
              }
            },
            {
              "label": "#4 상세에러",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "PL-2025-074 연계",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-074",
                "description": "명령에 대한 상세 에러 구성",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/21 완료 (에러세분화)"
                  }
                ]
              }
            },
            {
              "label": "#11 알람전달",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "PL-2025-061 연계",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-061",
                "description": "알람 전달",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/21 완료 (PLC알람)"
                  }
                ]
              }
            },
            {
              "label": "#14 커스텀팝업",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "PL-2025-022 연계",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-022",
                "description": "커스텀 팝업",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/21 완료"
                  }
                ]
              }
            }
          ]
        },
        {
          "style": "background:#ecfdf5;",
          "bars": [
            {
              "label": "커스텀팝업",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "PL-2025-022",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-022",
                "description": "커스텀 팝업 가독성 향상",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/21 배포완료"
                  }
                ]
              }
            },
            {
              "label": "에러세분화",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "PL-2025-074",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-074",
                "description": "에러내용 세분화",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/21 배포완료"
                  }
                ]
              }
            },
            {
              "label": "DB상하한",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "신규 항목",
                "description": "관제측 DB 상하한선 UI",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/21 완료"
                  }
                ]
              }
            },
            {
              "label": "데드라인",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "신규 항목",
                "description": "명령 유형 별 데드라인",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/21 완료"
                  }
                ]
              }
            },
            {
              "label": "브레이크",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "PL-2026-207",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-207",
                "description": "B라인 Control Off Speed Limit 수정",
                "rows": [
                  {
                    "label": "내용",
                    "value": "X1/X2축 설정 통일 (0.02/1 → 0.02/0.02)"
                  },
                  {
                    "label": "상태",
                    "value": "✓ 1/21 SP조치완료"
                  }
                ]
              }
            },
            {
              "label": "RAPID",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "PL-2025-069",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-069",
                "description": "RAPID 자동 상태 확인 에러",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/21 SP조치완료"
                  }
                ]
              }
            }
          ]
        },
        {
          "style": "background:#ecfdf5;position:relative;",
          "bars": [
            {
              "label": "터치에러",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "PL-2026-208",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-208",
                "description": "B라인 터치에러 핸들링",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/22 삼성컨펌완료"
                  }
                ]
              }
            },
            {
              "label": "노즐클리닝",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "PL-2025-116",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-116",
                "description": "노즐 클리닝 티칭",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/22 테스트완료 (A라인)"
                  }
                ]
              }
            },
            {
              "label": "067 ━━━━━━━━━━━━━━▶1/27",
              "fontSize": "0.55rem",
              "extraHtml": "<span style=\"background:#dc2626;color:#fff;padding:1px 3px;border-radius:2px;font-size:0.5rem;\">1/27</span>"
            },
            {
              "label": "061 ━━━━━━━━━━━━━━▶1/27",
              "fontSize": "0.55rem",
              "extraHtml": "<span style=\"background:#dc2626;color:#fff;padding:1px 3px;border-radius:2px;font-size:0.5rem;\">1/27</span>"
            },
            {
              "label": "096 ━━━━━━━━━━━━━━▶1/27",
              "fontSize": "0.55rem",
              "extraHtml": "<span style=\"background:#dc2626;color:#fff;padding:1px 3px;border-radius:2px;font-size:0.5rem;\">1/27</span>"
            }
          ]
        },
        {
          "style": "background:#ecfdf5;",
          "bars": [
            {
              "label": "스프레이",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "PL-2025-117",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-117",
                "description": "스프레이 티칭 기능",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/23 테스트완료 (A라인)"
                  }
                ]
              }
            }
          ]
        },
        {
          "style": "background:#ecfdf5;",
          "bars": [
            {
              "label": "불스아이",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "PL-2026-168",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-168",
                "description": "불스아이 결선",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/24 현장작업 완료"
                  }
                ]
              }
            },
            {
              "label": "BullsEye",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "PL-2025-142",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-142",
                "description": "B라인 BullsEye 설치",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/24 현장작업 완료"
                  }
                ]
              }
            },
            {
              "label": "절연처리",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "PL-2025-097",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-097",
                "description": "로봇 절연처리 (백그라이트)",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/24 현장작업 완료"
                  }
                ]
              }
            }
          ]
        },
        {},
        {
          "bars": [
            {
              "label": "윤활배관",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "PL-2026-202",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-202",
                "description": "A라인 윤활 배관 수정 작업",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/26 완료"
                  }
                ]
              }
            },
            {
              "label": "웜업UI✓",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "PL-2026-191",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-191",
                "description": "웜업 UI 가시성 개선",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 테스트완료→배포대기"
                  }
                ]
              }
            },
            {
              "label": "동시피딩✓",
              "status": "completed",
              "fontSize": "0.65rem",
              "tooltip": {
                "title": "PL-2025-150",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-150",
                "description": "와이어 동시 피딩 기능",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 테스트완료→배포대기"
                  }
                ]
              }
            }
          ]
        },
        {
          "style": "background:linear-gradient(135deg,rgba(59,130,246,0.15),#fef2f2);border:2px solid #3b82f6;",
          "bars": [
            {
              "label": "→2/2096 필터링",
              "fontSize": "0.55rem",
              "style": "opacity:0.5;",
              "extraHtml": "<span style=\"background:#6b7280;color:#fff;padding:1px 3px;border-radius:2px;font-size:0.5rem;\">→2/2</span>",
              "tooltip": {
                "title": "PL-2025-096",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-096",
                "description": "비정상 용접선 정보 필터링",
                "rows": [
                  {
                    "label": "상태",
                    "value": "📅 2/2 진행 예정"
                  }
                ]
              }
            }
          ]
        },
        {},
        {},
        {},
        {},
        {},
        {
          "bars": [
            {
              "label": "096 필터링",
              "priority": "verify",
              "tooltip": {
                "title": "PL-2025-096",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-096",
                "description": "비정상 용접선 정보 필터링",
                "rows": [
                  {
                    "label": "상태",
                    "value": "2/2 진행"
                  }
                ]
              }
            }
          ]
        },
        {},
        {},
        {},
        {},
        {
          "style": "background:rgba(5,150,105,0.15);",
          "bars": [
            {
              "label": "217 리밋✓",
              "status": "completed",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2026-217",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-217",
                "description": "하드/소프트 리밋 Bypass 로직 오류",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 2/7 완료"
                  }
                ]
              }
            },
            {
              "label": "138 터치에러✓",
              "status": "completed",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2025-138",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-138",
                "description": "B라인 터치 보정 에러 관리",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 2/7 완료"
                  }
                ]
              }
            },
            {
              "label": "178 필터링✓",
              "status": "completed",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2026-178",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-178",
                "description": "터치 보정 필터링 (병행처리)",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 2/7 완료"
                  }
                ]
              }
            },
            {
              "label": "198 따닥✓",
              "status": "completed",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2026-198",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-198",
                "description": "동일 위치 터치 에러 처리 (따닥)",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 2/7 완료"
                  }
                ]
              }
            },
            {
              "label": "199 드르륵✓",
              "status": "completed",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2026-199",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-199",
                "description": "끝점 터치 후 시작점 이동 에러 (드르륵)",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 2/7 완료"
                  }
                ]
              }
            },
            {
              "label": "208 핸들링✓",
              "status": "completed",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2026-208",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-208",
                "description": "B라인 터치에러 핸들링 (병행처리)",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 2/7 완료"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "039 LOW컨펌",
              "status": "completed",
              "fontSize": "0.55rem",
              "tooltip": {
                "title": "PL-2025-039",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-039",
                "description": "불스아이 스프레이 LOW 경고",
                "rows": [
                  {
                    "label": "상태",
                    "value": "📦 2/8 컨펌배포"
                  }
                ]
              }
            },
            {
              "label": "096 유효선컨펌",
              "priority": "verify",
              "fontSize": "0.55rem",
              "tooltip": {
                "title": "PL-2025-096",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-096",
                "description": "용접선 유효선 검사",
                "rows": [
                  {
                    "label": "상태",
                    "value": "📦 2/8 컨펌배포"
                  }
                ]
              }
            },
            {
              "label": "177 초기화컨펌",
              "status": "completed",
              "fontSize": "0.55rem",
              "tooltip": {
                "title": "PL-2026-177",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-177",
                "description": "터치/아크에러 후 로봇 초기화",
                "rows": [
                  {
                    "label": "상태",
                    "value": "📦 2/8 컨펌배포"
                  }
                ]
              }
            },
            {
              "label": "170 조깅테스트",
              "priority": "normal",
              "fontSize": "0.55rem",
              "tooltip": {
                "title": "PL-2026-170",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-170",
                "description": "갠트리 상대이동 조깅 기능",
                "rows": [
                  {
                    "label": "상태",
                    "value": "🧪 2/8 테스트"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "171 커팅테스트",
              "priority": "high",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2026-171",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-171",
                "description": "와이어 커팅 수동 티칭",
                "rows": [
                  {
                    "label": "상태",
                    "value": "🧪 테스트"
                  }
                ]
              }
            },
            {
              "label": "173 클리닝테스트",
              "priority": "normal",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2026-173",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-173",
                "description": "노즐 클리닝/스프레이 수동 티칭",
                "rows": [
                  {
                    "label": "상태",
                    "value": "🧪 테스트"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "171 커팅배포",
              "priority": "high",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2026-171",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-171",
                "description": "와이어 커팅 수동 티칭",
                "rows": [
                  {
                    "label": "상태",
                    "value": "📦 컨펌배포"
                  }
                ]
              }
            },
            {
              "label": "173 클리닝배포",
              "priority": "normal",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2026-173",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-173",
                "description": "노즐 클리닝/스프레이 수동 티칭",
                "rows": [
                  {
                    "label": "상태",
                    "value": "📦 컨펌배포"
                  }
                ]
              }
            },
            {
              "label": "155 홀센서✓컨펌",
              "priority": "verify",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2025-155",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-155",
                "description": "홀센서 기반 원점 인식",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 2/10 컨펌 완료"
                  },
                  {
                    "label": "잔여",
                    "value": "UI 배치 수정"
                  }
                ]
              }
            },
            {
              "label": "170 조깅✓컨펌",
              "priority": "verify",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2026-170",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-170",
                "description": "갠트리 상대이동 조깅 기능",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 2/10 컨펌"
                  },
                  {
                    "label": "잔여",
                    "value": "UI 부분보완"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "155 UI보완/배포",
              "priority": "high",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2025-155",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-155",
                "description": "홀센서 기반 원점 인식",
                "rows": [
                  {
                    "label": "상태",
                    "value": "2/11 부분보완 + 컨펌배포"
                  },
                  {
                    "label": "잔여",
                    "value": "UI 배치 수정 후 배포"
                  }
                ]
              }
            },
            {
              "label": "170 UI보완/배포",
              "priority": "high",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2026-170",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-170",
                "description": "갠트리 상대이동 조깅 기능",
                "rows": [
                  {
                    "label": "상태",
                    "value": "2/11 부분보완 + 컨펌배포"
                  },
                  {
                    "label": "이슈",
                    "value": "Y축 위치편차/리미트 → 본사지원필요"
                  }
                ]
              }
            }
          ]
        },
        {},
        {},
        {}
      ],
      "badges": {
        "completed": "9",
        "delayed": "3"
      },
      "sectionStyle": "background:rgba(46,213,115,0.05);border:1px solid rgba(46,213,115,0.3);"
    },
    {
      "name": "최광년",
      "avatar": "최",
      "gradient": [
        "#ffd93d",
        "#f39c12"
      ],
      "taskCount": "3건 (로봇 티칭)",
      "cells": [
        {},
        {},
        {},
        {
          "style": "background:#ecfdf5;",
          "bars": [
            {
              "label": "116 노즐✓",
              "status": "completed",
              "tooltip": {
                "title": "PL-2025-116",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-116",
                "description": "노즐 클리닝 티칭",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 완료"
                  }
                ]
              }
            }
          ]
        },
        {
          "style": "background:#ecfdf5;",
          "bars": [
            {
              "label": "117 스프레이✓",
              "status": "completed",
              "tooltip": {
                "title": "PL-2025-117",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-117",
                "description": "스프레이 티칭 기능",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 완료"
                  }
                ]
              }
            }
          ]
        },
        {},
        {},
        {
          "bars": [
            {
              "label": "188 쇼크센서 →1/27",
              "fontSize": "0.6rem",
              "style": "opacity:0.4;",
              "tooltip": {
                "title": "PL-2026-188",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-188",
                "description": "쇼크센서 기반 티칭 (CCLink IO)",
                "rows": [
                  {
                    "label": "상태",
                    "value": "📅 1/26→1/27 이동"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "115 앵글회피",
              "status": "completed-past",
              "style": "opacity:0.4;",
              "tooltip": {
                "title": "PL-2025-115",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-115",
                "description": "앵글 회피 로직"
              }
            },
            {
              "label": "188 쇼크센서 A✓",
              "status": "completed",
              "fontSize": "0.55rem",
              "tooltip": {
                "title": "PL-2026-188",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-188",
                "description": "CCLink IO CO_16_HeadShock 생성",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✅ A라인 적용완료"
                  }
                ]
              }
            }
          ]
        },
        {
          "style": "background:rgba(251,191,36,0.1);",
          "bars": [
            {
              "label": "B188 B라인적용",
              "status": "completed",
              "fontSize": "0.55rem",
              "extraHtml": "<span style=\"background:#dc2626;color:#fff;padding:1px 3px;border-radius:2px;font-size:0.5rem;\">B</span>",
              "tooltip": {
                "title": "PL-2026-188",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-188",
                "description": "CCLink IO CO_16_HeadShock - B라인 적용",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 완료"
                  }
                ]
              }
            }
          ]
        },
        {},
        {},
        {},
        {},
        {
          "bars": [
            {
              "label": "100 터치X_init → 2/11",
              "status": "completed-past",
              "style": "opacity:0.4;",
              "tooltip": {
                "title": "PL-2025-100",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-100",
                "description": "터치 모션 파라미터 X_init",
                "rows": [
                  {
                    "label": "상태",
                    "value": "2/5~2/10 테스트 → 2/11 테스트, 2/12 컨펌배포"
                  }
                ]
              }
            }
          ]
        },
        {},
        {
          "bars": [
            {
              "label": "153 십자레이저",
              "priority": "normal",
              "tooltip": {
                "title": "PL-2025-153",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-153",
                "description": "십자 레이저 기반 갠트리 원점",
                "rows": [
                  {
                    "label": "상태",
                    "value": "신규"
                  }
                ]
              }
            }
          ]
        },
        {},
        {},
        {},
        {
          "bars": [
            {
              "label": "169 한팔테스트",
              "priority": "high",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2026-169",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-169",
                "description": "B라인 한팔용접 (1xx 매크로)",
                "rows": [
                  {
                    "label": "상태",
                    "value": "🧪 테스트"
                  }
                ]
              }
            },
            {
              "label": "115 앵글테스트",
              "priority": "normal",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2025-115",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-115",
                "description": "B라인 앵글 회피 거리 향상",
                "rows": [
                  {
                    "label": "상태",
                    "value": "🧪 테스트"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "169 한팔배포",
              "priority": "high",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2026-169",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-169",
                "description": "B라인 한팔용접 (1xx 매크로)",
                "rows": [
                  {
                    "label": "상태",
                    "value": "📦 컨펌배포"
                  }
                ]
              }
            },
            {
              "label": "115 앵글테스트",
              "priority": "normal",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2025-115",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-115",
                "description": "B라인 앵글 회피 거리 향상",
                "rows": [
                  {
                    "label": "상태",
                    "value": "🧪 테스트"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "169 한팔배포",
              "priority": "high",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2026-169",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-169",
                "description": "B라인 한팔용접 (1xx 매크로)",
                "rows": [
                  {
                    "label": "상태",
                    "value": "📦 컨펌배포"
                  }
                ]
              }
            },
            {
              "label": "115 앵글배포",
              "priority": "normal",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2025-115",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-115",
                "description": "B라인 앵글 회피 거리 향상",
                "rows": [
                  {
                    "label": "상태",
                    "value": "📦 컨펌배포"
                  }
                ]
              }
            },
            {
              "label": "100 X_init테스트",
              "priority": "verify",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2025-100",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-100",
                "description": "터치 모션 파라미터 X_init",
                "rows": [
                  {
                    "label": "상태",
                    "value": "🧪 2/11 테스트"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "100 X_init배포",
              "priority": "normal",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2025-100",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-100",
                "description": "터치 모션 파라미터 X_init",
                "rows": [
                  {
                    "label": "상태",
                    "value": "📦 2/12 컨펌배포"
                  }
                ]
              }
            }
          ]
        },
        {},
        {
          "bars": [
            {
              "label": "111 형상보간",
              "priority": "normal",
              "fontSize": "0.55rem",
              "style": "background:#9ca3af;",
              "tooltip": {
                "title": "PL-2025-111",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-111",
                "description": "형상 보간 실패 에러 원인 파악 및 제거",
                "rows": [
                  {
                    "label": "상태",
                    "value": "Event (이벤트성)"
                  }
                ]
              }
            },
            {
              "label": "115 앵글회피",
              "priority": "normal",
              "fontSize": "0.55rem",
              "style": "background:#9ca3af;",
              "tooltip": {
                "title": "PL-2025-115",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-115",
                "description": "B라인 앵글 회피 거리 향상",
                "rows": [
                  {
                    "label": "상태",
                    "value": "Event (이벤트성)"
                  }
                ]
              }
            }
          ]
        },
        {}
      ]
    },
    {
      "name": "이상주",
      "avatar": "이",
      "gradient": [
        "#6bcb77",
        "#27ae60"
      ],
      "taskCount": "6건 (전기/배선)",
      "cells": [
        {},
        {},
        {},
        {},
        {
          "bars": [
            {
              "label": "083 조치✓2/4",
              "status": "completed",
              "tooltip": {
                "title": "PL-2025-083",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-083",
                "description": "X축 하드 리밋 결선 확인 (2/4 조치완료)"
              }
            }
          ]
        },
        {},
        {},
        {},
        {
          "bars": [
            {
              "label": "109 LAN [완료]",
              "status": "completed",
              "tooltip": {
                "title": "PL-2025-109",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-109",
                "description": "LAN 케이블 교체"
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "166 경광등 [완료]",
              "status": "completed",
              "tooltip": {
                "title": "PL-2026-166",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-166",
                "description": "경광등 설치"
              }
            }
          ]
        },
        {},
        {},
        {},
        {},
        {},
        {
          "bars": [
            {
              "label": "131 PC전원✓",
              "status": "completed",
              "tooltip": {
                "title": "PL-2025-131",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-131",
                "description": "PC 전원 OFF 문제",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 완료"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "167 명판✓",
              "status": "completed",
              "tooltip": {
                "title": "PL-2026-167",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-167",
                "description": "명판 부착",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 완료"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "168 결선",
              "priority": "normal",
              "tooltip": {
                "title": "PL-2026-168",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-168",
                "description": "불스아이 결선"
              }
            }
          ]
        },
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {}
      ]
    },
    {
      "name": "박기혁",
      "avatar": "박",
      "gradient": [
        "#a29bfe",
        "#6c5ce7"
      ],
      "taskCount": "4건 (기계 설비)",
      "cells": [
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {
          "bars": [
            {
              "label": "033 케이블 [보류]",
              "priority": "low",
              "style": "text-decoration:line-through;opacity:0.6;",
              "tooltip": {
                "title": "PL-2025-033",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-033",
                "description": "로봇 전원 케이블 타입 변경 [보류]"
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "034 릴피더기 [완료]",
              "status": "completed",
              "tooltip": {
                "title": "PL-2025-034",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-034",
                "description": "릴피더기 설치"
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "035 블스아이 [완료]",
              "status": "completed",
              "tooltip": {
                "title": "PL-2025-035",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-035",
                "description": "불스아이 설치"
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "036 거더상향 [보류]",
              "priority": "low",
              "style": "text-decoration:line-through;opacity:0.6;",
              "tooltip": {
                "title": "PL-2025-036",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-036",
                "description": "거더 상향 조정 [보류]"
              }
            }
          ]
        },
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {}
      ]
    },
    {
      "name": "제어팀",
      "avatar": "팀",
      "gradient": [
        "#ff6b6b",
        "#ee5a24"
      ],
      "taskCount": "25건 (로봇/UI/에러)",
      "cells": [
        {},
        {
          "bars": [
            {
              "label": "039 스프레이 →1/27",
              "fontSize": "0.6rem",
              "style": "opacity:0.4;",
              "tooltip": {
                "title": "PL-2025-039",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-039",
                "description": "불스아이 스프레이 LOW 경고 처리",
                "rows": [
                  {
                    "label": "상태",
                    "value": "📅 1/22→1/27 이동"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "139 B라인이상✓",
              "status": "completed",
              "tooltip": {
                "title": "PL-2025-139",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-139",
                "description": "B라인 로봇 동작 이상현상 대응",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/21 완료"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "165 부재두깨✓",
              "status": "completed",
              "tooltip": {
                "title": "PL-2026-165",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-165",
                "description": "용접 포인트 부재 두깨 반영",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 2/3 완료"
                  }
                ]
              }
            },
            {
              "label": "080 아크에러✓",
              "status": "completed",
              "tooltip": {
                "title": "PL-2025-080",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-080",
                "description": "아크 에러 시 RAPID 제어",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/22 완료"
                  }
                ]
              }
            },
            {
              "label": "084 PLC알람 →1/27",
              "fontSize": "0.6rem",
              "style": "opacity:0.4;",
              "tooltip": {
                "title": "PL-2025-084",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-084",
                "description": "PLC 알람 체크",
                "rows": [
                  {
                    "label": "상태",
                    "value": "📅 1/22→1/27 이동"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "099 UI로깅",
              "status": "pending",
              "tooltip": {
                "title": "PL-2025-099",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-099",
                "description": "UI 조작 로깅"
              }
            },
            {
              "label": "111 형상보간",
              "status": "completed-past",
              "style": "opacity:0.4;",
              "tooltip": {
                "title": "PL-2025-111",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-111",
                "description": "형상 보간 실패 에러"
              }
            },
            {
              "label": "105 통신단절 [완료]",
              "status": "completed",
              "tooltip": {
                "title": "PL-2025-105",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-105",
                "description": "로봇/UI 통신 단절 시 프리징"
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "124 디바이스넷 ✓",
              "status": "completed",
              "tooltip": {
                "title": "PL-2025-124",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-124",
                "description": "디바이스넷 통신 상실",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 완료"
                  }
                ]
              }
            },
            {
              "label": "143 용접범위 [완료]",
              "status": "completed",
              "tooltip": {
                "title": "PL-2025-143",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-143",
                "description": "용접 가능 범위 제한"
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "148 갠트리범위 [완료]",
              "status": "completed",
              "tooltip": {
                "title": "PL-2025-148",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-148",
                "description": "갠트리 이동 범위 변수화"
              }
            },
            {
              "label": "151 Z홈모드 [완료]",
              "status": "completed",
              "tooltip": {
                "title": "PL-2025-151",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-151",
                "description": "Z홈 기본 모드 적용"
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "157 터치옵셋✓",
              "status": "completed",
              "fontSize": "0.6rem",
              "tooltip": {
                "title": "PL-2025-157",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-157",
                "description": "터치 오프셋 일괄 변경",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✅ A라인 테스트완료"
                  }
                ]
              }
            },
            {
              "label": "196 팝업 →1/27",
              "fontSize": "0.6rem",
              "style": "opacity:0.4;",
              "tooltip": {
                "title": "PL-2026-196",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-196",
                "description": "커스텀 팝업 (프리징)",
                "rows": [
                  {
                    "label": "상태",
                    "value": "⚠ 1/26→1/27 이동"
                  }
                ]
              }
            },
            {
              "label": "092 수직 → 2/4",
              "status": "completed-past",
              "fontSize": "0.6rem",
              "style": "opacity:0.4;",
              "tooltip": {
                "title": "PL-2025-092",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-092",
                "description": "수직용접 터치 센싱 옵셋",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 2/4 완료"
                  }
                ]
              }
            }
          ]
        },
        {
          "style": "background:rgba(16,185,129,0.08);",
          "bars": [
            {
              "label": "196 팝업 ✓",
              "status": "completed",
              "fontSize": "0.55rem",
              "tooltip": {
                "title": "PL-2026-196",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-196",
                "description": "커스텀 팝업 (프리징) - UI스레드 처리",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✅ 배포대기/컨펌대기"
                  }
                ]
              }
            },
            {
              "label": "126 속도0% [완료]",
              "status": "completed",
              "fontSize": "0.55rem",
              "tooltip": {
                "title": "PL-2025-126",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-126",
                "description": "작업 취소/재개 시 속도 0%",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✅ 완료 (2/3 확인)"
                  }
                ]
              }
            },
            {
              "label": "154 rInit ✓",
              "status": "completed",
              "fontSize": "0.55rem",
              "tooltip": {
                "title": "PL-2025-154",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-154",
                "description": "명령 취소 시 리트라이 방지",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✅ 테스트완료 (A/B라인 공통)"
                  }
                ]
              }
            },
            {
              "label": "177 에러초기화 ✓",
              "status": "completed",
              "fontSize": "0.55rem",
              "tooltip": {
                "title": "PL-2026-177",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-177",
                "description": "터치/아크에러 후 로봇 초기화",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✅ 테스트완료 (A/B라인 공통)"
                  }
                ]
              }
            },
            {
              "label": "170 갠트리조깅 → 2/10",
              "status": "completed-past",
              "fontSize": "0.55rem",
              "style": "opacity:0.4;",
              "tooltip": {
                "title": "PL-2026-170",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-170",
                "description": "갠트리 상대 이동 조깅 기능",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 2/10 컨펌, 2/11 부분보완/컨펌배포"
                  }
                ]
              }
            },
            {
              "label": "092 터치옵셋 → 2/4",
              "status": "completed-past",
              "fontSize": "0.55rem",
              "style": "opacity:0.4;",
              "tooltip": {
                "title": "PL-2025-092",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-092",
                "description": "수직용접 터치 센싱 옵셋",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 2/4 완료"
                  }
                ]
              }
            },
            {
              "label": "020 수직CSV → 2/11",
              "status": "completed-past",
              "fontSize": "0.55rem",
              "style": "opacity:0.4;",
              "tooltip": {
                "title": "PL-2025-020",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-020",
                "description": "A라인 수직용접 CSV",
                "rows": [
                  {
                    "label": "상태",
                    "value": "2/5~2/10 테스트 → 2/11 컨펌배포대기"
                  }
                ]
              }
            },
            {
              "label": "PlanC점검 →B라인 28일 연기",
              "status": "pending",
              "fontSize": "0.5rem",
              "style": "background:#fef3c7;color:#92400e;border-color:#f59e0b;",
              "tooltip": {
                "title": "B라인 긴급 공지",
                "description": "긴급 PlanC 점검으로 B라인 작업 1/28 연기",
                "rows": [
                  {
                    "label": "연기항목",
                    "value": "084, 199, 179, 039, 156, 188"
                  }
                ]
              }
            }
          ]
        },
        {
          "style": "background:rgba(16,185,129,0.1);",
          "bars": [
            {
              "label": "✓ 157 터치옵셋(A)",
              "status": "completed",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2025-157",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-157",
                "description": "터치 오프셋 일괄 변경",
                "rows": [
                  {
                    "label": "A라인",
                    "value": "✅ 1/28 완료"
                  },
                  {
                    "label": "B라인",
                    "value": "⏳ 별도 일정 (미적용)"
                  }
                ]
              }
            },
            {
              "label": "✓ 106 통신",
              "status": "completed",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2025-106",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-106",
                "description": "UI와 관제 통신 주기 문제",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✅ 1/28 완료"
                  }
                ]
              }
            },
            {
              "label": "📐 209 레이저트래커 [완료]",
              "status": "completed",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2026-209",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-209",
                "description": "비젼 켈리브레이션 구 측정 (레이저트래커)",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✅ 완료"
                  },
                  {
                    "label": "담당",
                    "value": "심태양"
                  }
                ]
              }
            },
            {
              "label": "125 용접모드 → 2/14",
              "status": "completed-past",
              "fontSize": "0.5rem",
              "style": "opacity:0.4;",
              "tooltip": {
                "title": "PL-2025-125",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-125",
                "description": "용접기 용접 모드 상실",
                "rows": [
                  {
                    "label": "상태",
                    "value": "→ 2/14 이벤트성 이동"
                  }
                ]
              }
            },
            {
              "label": "✓ 180 매크로표시",
              "status": "completed",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2026-180",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-180",
                "description": "B라인 매크로 미선택 시 전체 용접 데이터 표시",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/20 완료"
                  }
                ]
              }
            },
            {
              "label": "B199 터치에러2 ✓",
              "status": "completed",
              "fontSize": "0.5rem",
              "extraHtml": "<span style=\"background:#10b981;color:#fff;padding:1px 3px;border-radius:2px;font-size:0.5rem;\">B</span>",
              "tooltip": {
                "title": "PL-2026-199",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-199",
                "description": "끝점 터치 후 시작점 이동 에러",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✅ 컨펌대기"
                  }
                ]
              }
            },
            {
              "label": "✓ 156 경광등",
              "status": "completed",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2025-156",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-156",
                "description": "경광등-UI-관제 동기화",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 2/3 완료"
                  }
                ]
              }
            },
            {
              "label": "✓ 067 알람처리",
              "status": "completed",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2025-067",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-067",
                "description": "공압/가스/냉각수 알람처리(UI)",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 1/29 테스트완료, 1/30 삼성검토요청"
                  }
                ]
              }
            },
            {
              "label": "100 X_init → 2/11",
              "status": "completed-past",
              "style": "opacity:0.4;",
              "tooltip": {
                "title": "PL-2025-100",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-100",
                "description": "터치 모션 X_init 적용",
                "rows": [
                  {
                    "label": "상태",
                    "value": "→ 2/11 테스트, 2/12 컨펌배포"
                  }
                ]
              }
            }
          ]
        },
        {
          "style": "background:rgba(16,185,129,0.1);",
          "bars": [
            {
              "label": "A067 피드백대기",
              "status": "pending",
              "fontSize": "0.5rem",
              "style": "background:#fef3c7;border-left:3px solid #f59e0b;",
              "extraHtml": "<span style=\"background:#2563eb;color:#fff;padding:1px 3px;border-radius:2px;font-size:0.5rem;\">A</span>",
              "tooltip": {
                "title": "PL-2025-067",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-067",
                "description": "공압/가스/냉각수 알람처리(UI)",
                "rows": [
                  {
                    "label": "상태",
                    "value": "⏳ 피드백대기 (알람우선순위 1/30 협의)"
                  }
                ]
              }
            },
            {
              "label": "A170 → 2/10컨펌",
              "status": "completed-past",
              "fontSize": "0.5rem",
              "style": "opacity:0.4;",
              "extraHtml": "<span style=\"background:#2563eb;color:#fff;padding:1px 3px;border-radius:2px;font-size:0.5rem;\">A</span>",
              "tooltip": {
                "title": "PL-2026-170",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-170",
                "description": "갠트리 조깅 기능",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 2/10 컨펌 완료"
                  }
                ]
              }
            },
            {
              "label": "A191 예외수정",
              "fontSize": "0.5rem",
              "style": "background:#fed7aa;border-left:3px solid #ea580c;",
              "extraHtml": "<span style=\"background:#2563eb;color:#fff;padding:1px 3px;border-radius:2px;font-size:0.5rem;\">A</span>",
              "tooltip": {
                "title": "PL-2026-191",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-191",
                "description": "웜업 타이머",
                "rows": [
                  {
                    "label": "상태",
                    "value": "⚠️ 예외수정필요 (창닫힘시 상태미반영)"
                  }
                ]
              }
            },
            {
              "label": "A신규 엑셀관리",
              "priority": "normal",
              "fontSize": "0.5rem",
              "extraHtml": "<span style=\"background:#2563eb;color:#fff;padding:1px 3px;border-radius:2px;font-size:0.5rem;\">A</span>",
              "tooltip": {
                "title": "신규 항목",
                "description": "터치/갠트리 오프셋 및 속도 엑셀 관리",
                "rows": [
                  {
                    "label": "상태",
                    "value": "🔧 A라인 신규 개발"
                  }
                ]
              }
            },
            {
              "label": "B125 미진행",
              "fontSize": "0.5rem",
              "style": "background:#e5e7eb;border-left:3px solid #6b7280;",
              "extraHtml": "<span style=\"background:#10b981;color:#fff;padding:1px 3px;border-radius:2px;font-size:0.5rem;\">B</span>",
              "tooltip": {
                "title": "PL-2025-125",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-125",
                "description": "B라인 노즐 클리너 커맨드 실행",
                "rows": [
                  {
                    "label": "상태",
                    "value": "⏸️ 미진행 (RAPID모션확인됨/속도이슈)"
                  }
                ]
              }
            },
            {
              "label": "B180 테스트",
              "priority": "verify",
              "fontSize": "0.5rem",
              "extraHtml": "<span style=\"background:#10b981;color:#fff;padding:1px 3px;border-radius:2px;font-size:0.5rem;\">B</span>",
              "tooltip": {
                "title": "PL-2026-180",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-180",
                "description": "B라인 매크로 미선택 시 전체 용접 데이터 표시",
                "rows": [
                  {
                    "label": "상태",
                    "value": "🧪 테스트"
                  }
                ]
              }
            },
            {
              "label": "B171 와이어커팅",
              "priority": "verify",
              "fontSize": "0.5rem",
              "extraHtml": "<span style=\"background:#10b981;color:#fff;padding:1px 3px;border-radius:2px;font-size:0.5rem;\">B</span>",
              "tooltip": {
                "title": "PL-2026-171",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-171",
                "description": "B라인 와이어 커팅 수동 티칭 (UI)",
                "rows": [
                  {
                    "label": "상태",
                    "value": "UI만 구성"
                  }
                ]
              }
            },
            {
              "label": "B173 노즐티칭",
              "priority": "verify",
              "fontSize": "0.5rem",
              "extraHtml": "<span style=\"background:#10b981;color:#fff;padding:1px 3px;border-radius:2px;font-size:0.5rem;\">B</span>",
              "tooltip": {
                "title": "PL-2026-173",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-173",
                "description": "B라인 노즐 클리닝 수동 티칭 (UI)",
                "rows": [
                  {
                    "label": "상태",
                    "value": "UI만 구성"
                  }
                ]
              }
            }
          ]
        },
        {
          "style": "background:rgba(234,179,8,0.1);border:2px solid #eab308;",
          "bars": [
            {
              "label": "🏢 170 → 2/10컨펌",
              "status": "completed-past",
              "fontSize": "0.5rem",
              "style": "opacity:0.4;",
              "tooltip": {
                "title": "PL-2026-170",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-170",
                "description": "갠트리 조깅 UI 개선안",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 2/10 컨펌 완료"
                  }
                ]
              }
            },
            {
              "label": "🏢 067 삼성검토중",
              "status": "pending",
              "fontSize": "0.5rem",
              "style": "background:#fef3c7;border-left:3px solid #f59e0b;",
              "tooltip": {
                "title": "PL-2025-067",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-067",
                "description": "공압/가스 알람 처리 기준",
                "rows": [
                  {
                    "label": "상태",
                    "value": "🏢 삼성 검토요청 (알람기준)"
                  },
                  {
                    "label": "데모",
                    "value": "데모 페이지"
                  }
                ]
              }
            },
            {
              "label": "169 한팔용접",
              "priority": "high",
              "tooltip": {
                "title": "PL-2026-169",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-169",
                "description": "B라인 한팔용접 (1xx)"
              }
            }
          ]
        },
        {
          "style": "background:rgba(16,185,129,0.15);",
          "bars": [
            {
              "label": "191 웜업✓",
              "status": "completed",
              "fontSize": "0.55rem",
              "tooltip": {
                "title": "PL-2026-191",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-191",
                "description": "웜업 UI 가시성 개선",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✅ A/B라인 컨펌완료"
                  }
                ]
              }
            },
            {
              "label": "173 티칭✓",
              "status": "completed",
              "fontSize": "0.55rem",
              "tooltip": {
                "title": "PL-2026-173",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-173",
                "description": "노즐 클리닝/스프레이 수동 티칭",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✅ A라인 스프레이/토치클리닝 컨펌완료"
                  }
                ]
              }
            },
            {
              "label": "172 B모션",
              "priority": "verify",
              "fontSize": "0.55rem",
              "tooltip": {
                "title": "PL-2026-172",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-172",
                "description": "노즐 클리닝/스프레이 기능",
                "rows": [
                  {
                    "label": "상태",
                    "value": "🔧 B라인 모션완료 (UI/관제 잔여)"
                  }
                ]
              }
            },
            {
              "label": "092 수직용접 → 2/4",
              "status": "completed-past",
              "fontSize": "0.55rem",
              "style": "opacity:0.4;",
              "tooltip": {
                "title": "PL-2025-092",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-092",
                "description": "A라인 수직용접 터치 옵셋",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 2/4 완료"
                  }
                ]
              }
            },
            {
              "label": "200 관제연결",
              "priority": "high",
              "fontSize": "0.55rem",
              "tooltip": {
                "title": "PL-2026-200",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-200",
                "description": "수직용접 관제 명령 및 노티 연결",
                "rows": [
                  {
                    "label": "상태",
                    "value": "🔧 계속 진행중"
                  }
                ]
              }
            }
          ]
        },
        {},
        {},
        {
          "bars": [
            {
              "label": "021 UI개선✓",
              "status": "completed",
              "tooltip": {
                "title": "PL-2025-021",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-021",
                "description": "사용자 편의성 UI 개선",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 완료"
                  }
                ]
              }
            },
            {
              "label": "055 드라이런✓",
              "status": "completed",
              "tooltip": {
                "title": "PL-2025-055",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-055",
                "description": "B라인 드라이런 속도 배율",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 완료"
                  }
                ]
              }
            },
            {
              "label": "065 용접조건",
              "priority": "normal",
              "tooltip": {
                "title": "PL-2025-065",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-065",
                "description": "실시간 용접 조건 변경"
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "091 수동용접",
              "priority": "normal",
              "tooltip": {
                "title": "PL-2025-091",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-091",
                "description": "수동 용접시 기능 추가"
              }
            },
            {
              "label": "121 TCP오프셋",
              "priority": "normal",
              "tooltip": {
                "title": "PL-2025-121",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-121",
                "description": "시작점 터치 TCP 오프셋"
              }
            },
            {
              "label": "092 수직옵셋✓",
              "status": "completed",
              "fontSize": "0.55rem",
              "tooltip": {
                "title": "PL-2025-092",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-092",
                "description": "A라인 수직용접 터치 센싱 옵셋",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 2/4 완료"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "126 속도0% →1/27",
              "fontSize": "0.6rem",
              "style": "opacity:0.4;",
              "tooltip": {
                "title": "PL-2025-126",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-126",
                "description": "작업 취소/재개 시 속도 0%",
                "rows": [
                  {
                    "label": "상태",
                    "value": "📅 2/4→1/27 앞당김"
                  }
                ]
              }
            },
            {
              "label": "138 터치보정",
              "priority": "normal",
              "tooltip": {
                "title": "PL-2025-138",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-138",
                "description": "B라인 터치 보정 에러"
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "141 SMB배터리",
              "priority": "normal",
              "tooltip": {
                "title": "PL-2025-141",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-141",
                "description": "SMB 배터리 관리"
              }
            },
            {
              "label": "147 X축범위",
              "priority": "normal",
              "tooltip": {
                "title": "PL-2025-147",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-147",
                "description": "계측 도중 X축 범위 확인"
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "153 십자레이저",
              "priority": "normal",
              "tooltip": {
                "title": "PL-2025-153",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-153",
                "description": "십자 레이저 갠트리 원점"
              }
            },
            {
              "label": "156 경광등 →1/27",
              "fontSize": "0.6rem",
              "style": "opacity:0.4;",
              "tooltip": {
                "title": "PL-2025-156",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-156",
                "description": "경광등-UI-관제 동기화",
                "rows": [
                  {
                    "label": "상태",
                    "value": "📅 2/7→1/27 앞당김"
                  }
                ]
              }
            },
            {
              "label": "170 갠트리조깅 →1/27",
              "fontSize": "0.6rem",
              "style": "opacity:0.4;",
              "tooltip": {
                "title": "PL-2026-170",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-170",
                "description": "갠트리 상대 이동 조깅 기능",
                "rows": [
                  {
                    "label": "상태",
                    "value": "📅 2/7→1/27 앞당김"
                  }
                ]
              }
            }
          ]
        },
        {},
        {},
        {},
        {
          "bars": [
            {
              "label": "020 수직용접 배포대기",
              "status": "pending",
              "fontSize": "0.5rem",
              "style": "background:#fef3c7;border-left:3px solid #f59e0b;",
              "tooltip": {
                "title": "PL-2025-020",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-020",
                "description": "A라인 수직용접",
                "rows": [
                  {
                    "label": "상태",
                    "value": "⏳ 2/11 컨펌배포 대기"
                  },
                  {
                    "label": "의존",
                    "value": "삼성 확인"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "020 수직용접 컨펌배포",
              "priority": "normal",
              "fontSize": "0.5rem",
              "tooltip": {
                "title": "PL-2025-020",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-020",
                "description": "A라인 수직용접",
                "rows": [
                  {
                    "label": "상태",
                    "value": "📦 2/12 컨펌배포"
                  }
                ]
              }
            }
          ]
        },
        {},
        {
          "bars": [
            {
              "label": "⚡125 용접모드 [이벤트]",
              "priority": "normal",
              "fontSize": "0.5rem",
              "style": "background:linear-gradient(135deg,#fef3c7,#fde68a);border-left:3px solid #f59e0b;color:#92400e;",
              "tooltip": {
                "title": "PL-2025-125",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-125",
                "description": "용접기 용접 모드 상실",
                "rows": [
                  {
                    "label": "상태",
                    "value": "⚡ 이벤트성 (발생시 대응)"
                  },
                  {
                    "label": "비고",
                    "value": "RAPID모션확인/속도이슈"
                  }
                ]
              }
            }
          ]
        }
      ],
      "badges": {
        "completed": "3",
        "delayed": "1"
      }
    },
    {
      "name": "기계팀",
      "avatar": "팀",
      "gradient": [
        "#74b9ff",
        "#0984e3"
      ],
      "taskCount": "11건 (구조물/악세서리)",
      "cells": [
        {},
        {},
        {},
        {},
        {},
        {
          "style": "background:#ecfdf5;",
          "bars": [
            {
              "label": "097 절연✓",
              "status": "completed",
              "tooltip": {
                "title": "PL-2025-097",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-097",
                "description": "로봇 절연처리 (백그라이트)",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 완료"
                  }
                ]
              }
            },
            {
              "label": "142 불스아이✓",
              "status": "completed",
              "tooltip": {
                "title": "PL-2025-142",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-142",
                "description": "B라인 BullsEye 설치",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 완료"
                  }
                ]
              }
            }
          ]
        },
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {
          "bars": [
            {
              "label": "008 스프레이✓",
              "status": "completed",
              "tooltip": {
                "title": "PL-2025-008",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-008",
                "description": "스프레이 설치",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 완료"
                  }
                ]
              }
            },
            {
              "label": "026 발판",
              "priority": "normal",
              "tooltip": {
                "title": "PL-2025-026",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-026",
                "description": "발판 설치"
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "027 차광막",
              "priority": "normal",
              "tooltip": {
                "title": "PL-2025-027",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-027",
                "description": "차광막 설치"
              }
            },
            {
              "label": "030 안전신고",
              "priority": "normal",
              "tooltip": {
                "title": "PL-2025-030",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-030",
                "description": "안전 신고"
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "032 토치케이블",
              "priority": "normal",
              "tooltip": {
                "title": "PL-2025-032",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-032",
                "description": "토치 케이블 정리"
              }
            },
            {
              "label": "040 레이저커튼✓",
              "status": "completed",
              "tooltip": {
                "title": "PL-2025-040",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-040",
                "description": "레이저 커튼 설치",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 완료"
                  }
                ]
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "097 백그라이트",
              "priority": "normal",
              "tooltip": {
                "title": "PL-2025-097",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-097",
                "description": "백그라이트 절연"
              }
            }
          ]
        },
        {
          "bars": [
            {
              "label": "103 호기명판✓",
              "status": "completed",
              "tooltip": {
                "title": "PL-2025-103",
                "titleLink": "https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-103",
                "description": "호기 명판 부착",
                "rows": [
                  {
                    "label": "상태",
                    "value": "✓ 완료"
                  }
                ]
              }
            }
          ]
        },
        {},
        {},
        {},
        {},
        {},
        {},
        {}
      ]
    }
  ],
  "dailySummary": [
    {
      "value": "8",
      "color": "#2ed573"
    },
    {
      "value": "19",
      "color": "#ff6b6b"
    },
    {
      "value": "5"
    },
    {
      "value": "4"
    },
    {
      "value": "6",
      "color": "#10b981"
    },
    {
      "value": "3",
      "color": "#10b981"
    },
    {
      "value": "-"
    },
    {
      "value": "5"
    },
    {
      "value": "8"
    },
    {
      "value": "8"
    },
    {
      "value": "6"
    },
    {
      "value": "5"
    },
    {
      "value": "1"
    },
    {
      "value": "-"
    },
    {
      "value": "5"
    },
    {
      "value": "5"
    },
    {
      "value": "5"
    },
    {
      "value": "4"
    },
    {
      "value": "5"
    },
    {
      "value": "9",
      "color": "#10b981"
    },
    {
      "value": "-"
    },
    {
      "cellStyle": "background:rgba(5,150,105,0.2);",
      "html": "15 ✓7배포",
      "value": "15 ✓7배포",
      "color": "#059669"
    },
    {
      "cellStyle": "background:rgba(5,150,105,0.2);",
      "html": "23 ✓4컨펌",
      "value": "23 ✓4컨펌",
      "color": "#059669"
    },
    {
      "cellStyle": "background:rgba(59,130,246,0.2);border:2px solid #3b82f6;",
      "html": "20 TODAY",
      "value": "20 TODAY",
      "color": "#3b82f6"
    },
    {
      "value": "14"
    },
    {
      "value": "-"
    },
    {
      "value": "-"
    }
  ],
  "dayCards": [
    {
      "heading": "1주차 상세 일정 (1/19~1/25) - 긴급 + 검증중 완료",
      "cards": [
        {
          "dayName": "월",
          "date": "1/19",
          "weekClass": "w1",
          "taskCount": "실적 반영",
          "contentHtml": "\n 완료 항목 \n<div style=\"margin:5px 0;padding:8px 10px;background:rgba(46,213,115,0.15);border-radius:6px;border-left:3px solid #2ed573;\">\n<strong style=\"color:#2ed573;\">✅ 완료</strong>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(46,213,115,0.1);\">\n<span class=\"task-owner\">안전</span>\n<div>A 테스트 완료</div>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(46,213,115,0.1);\">\n<span class=\"task-owner\">안전</span>\n<div>B 세팅 완료</div>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(46,213,115,0.1);\">\n<span class=\"task-owner\">안전</span>\n<div>메뉴얼 전달 완료</div>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(46,213,115,0.1);\">\n<span class=\"task-owner\">B라인</span>\n<div>1호기 캘리브레이션 완료 (피딩길이 1호기=3호기)</div>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(46,213,115,0.1);\">\n<span class=\"task-owner\">RAPID</span>\n<div>웜업 적용 완료 (UI 적용 대기 - 테스트버전 준비됨)</div>\n</div>\n 지연 항목 \n<div style=\"margin:10px 0 5px;padding:8px 10px;background:rgba(255,107,107,0.15);border-radius:6px;border-left:3px solid #ff6b6b;\">\n<strong style=\"color:#ff6b6b;\">❌ 지연 → 1/20 이동</strong>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(255,107,107,0.1);\">\n<span class=\"task-owner\">박주한</span>\n<div>B라인 UI 6건 (#1,#2,#7,#8,#10,#13) 미배포</div>\n</div>\n<div style=\"padding:5px 10px;color:#ff6b6b;font-size:0.8rem;\">\n                            사유: 화면전환 프리징 이슈 (X항목 검증완료, 대안 있으나 테스트 못함)\n                        </div>\n 확인중 항목 \n<div style=\"margin:10px 0 5px;padding:8px 10px;background:rgba(30,144,255,0.15);border-radius:6px;border-left:3px solid #1e90ff;\">\n<strong style=\"color:#1e90ff;\">🔍 확인중</strong>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(30,144,255,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-020\" style=\"color:#1e90ff;\" target=\"_blank\">PL-2025-020</a></span>\n<span class=\"task-owner\">A라인</span>\n<div>수직용접: nAngleBetweenParts 위치이동 오류 가능성</div>\n</div>\n<div style=\"padding:5px 10px;color:#1e90ff;font-size:0.8rem;\">\n                            12/09 버전 롤백 테스트도 용접불가 → 테스트 UI 신버전 제작 예정 (박주한)\n                        </div>\n",
          "headerStyle": "background:linear-gradient(135deg,rgba(46,213,115,0.3),rgba(255,165,2,0.3));"
        },
        {
          "dayName": "화",
          "date": "1/20",
          "weekClass": "w1",
          "taskCount": "1건 완료 + 4건 지연",
          "contentHtml": "\n 1/20 완료 \n<div style=\"margin:5px 0;padding:8px 10px;background:rgba(46,213,115,0.15);border-radius:6px;border-left:3px solid #2ed573;\">\n<strong style=\"color:#2ed573;\">✓ 1/20 완료</strong>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(46,213,115,0.1);\">\n<span class=\"task-id\" style=\"color:#2ed573;\">#3</span>\n<span class=\"task-owner\">제어팀</span>\n<div>명령 유형별 데드라인 구성</div>\n</div>\n 1/22 지연 \n<div style=\"margin:10px 0 5px;padding:8px 10px;background:rgba(255,107,107,0.15);border-radius:6px;border-left:3px solid #ff6b6b;\">\n<strong style=\"color:#ff6b6b;\">⚠ 1/22 지연 (4건)</strong>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(255,107,107,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-067\" style=\"color:#ff6b6b;\" target=\"_blank\">#5 PL-2025-067</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>공압/CO2/냉각수 유량범위 → 상하한치</div>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(255,107,107,0.1);\">\n<span class=\"task-id\" style=\"color:#ff6b6b;\">#6 신규</span>\n<span class=\"task-owner\">박주한</span>\n<div>DB 상하한선 수치 활용</div>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(255,107,107,0.1);\">\n<span class=\"task-id\" style=\"color:#ff6b6b;\">#9 신규</span>\n<span class=\"task-owner\">제어팀</span>\n<div>와이어 인칭 시그널 개별 제어 → 동시피딩</div>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(255,107,107,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-113\" style=\"color:#ff6b6b;\" target=\"_blank\">#12 PL-2025-113</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>웜업 UI 가시성 개선</div>\n</div>\n Plan C 적용 \n<div style=\"margin:10px 0 5px;padding:8px 10px;background:rgba(46,213,115,0.15);border-radius:6px;border-left:3px solid #2ed573;\">\n<strong style=\"color:#2ed573;\">Plan C 적용 완료</strong>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(46,213,115,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-174\" style=\"color:#2ed573;\" target=\"_blank\">PL-2026-174</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>B라인 전호기 Plan C 적용 ✓</div>\n</div>\n A라인 진행 \n<div style=\"margin:10px 0 5px;padding:8px 10px;background:rgba(30,144,255,0.15);border-radius:6px;border-left:3px solid #1e90ff;\">\n<strong style=\"color:#1e90ff;\">A라인 진행현황</strong>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(46,213,115,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-113\" style=\"color:#2ed573;\" target=\"_blank\">PL-2025-113</a></span>\n<span class=\"task-owner\">A라인</span>\n<div>웜업 적용 (타이머 표시 개선 잔여)</div>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(255,165,2,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-020\" style=\"color:#ffa502;\" target=\"_blank\">PL-2025-020</a></span>\n<span class=\"task-owner\">A라인</span>\n<div>수직용접 모션 테스트 성공</div>\n</div>\n 수직용접 테스트 결과 테이블 \n<div style=\"margin-top:10px;padding:10px;background:#fff;border:1px solid #e5e7eb;border-radius:8px;\">\n<div style=\"display:grid;grid-template-columns:1fr 1fr;gap:10px;font-size:0.75rem;\">\n<!-- X: -120 테이블 -->\n<div>\n<div style=\"background:#2563eb;color:#fff;padding:6px 8px;border-radius:6px 6px 0 0;font-weight:600;text-align:center;\">X: -120</div>\n<table style=\"width:100%;border-collapse:collapse;border:1px solid #e5e7eb;\">\n<tr style=\"background:#f9fafb;\">\n<th style=\"padding:4px 6px;border:1px solid #e5e7eb;text-align:left;\">위치</th>\n<th style=\"padding:4px 6px;border:1px solid #e5e7eb;text-align:center;\">Angle</th>\n<th style=\"padding:4px 6px;border:1px solid #e5e7eb;text-align:center;width:40px;\">Result</th>\n</tr>\n<tr><td style=\"padding:3px 6px;border:1px solid #e5e7eb;font-weight:500;\">Front</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;\">316°</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;color:#2ed573;\">✓</td></tr>\n<tr><td style=\"padding:3px 6px;border:1px solid #e5e7eb;\"></td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;\">0°</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;color:#2ed573;\">✓</td></tr>\n<tr><td style=\"padding:3px 6px;border:1px solid #e5e7eb;\"></td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;\">45°</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;color:#2ed573;\">✓</td></tr>\n<tr><td style=\"padding:3px 6px;border:1px solid #e5e7eb;\"></td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;\">90°</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;color:#2ed573;\">✓</td></tr>\n<tr><td style=\"padding:3px 6px;border:1px solid #e5e7eb;\"></td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;\">135°</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;color:#2ed573;\">✓</td></tr>\n<tr><td style=\"padding:3px 6px;border:1px solid #e5e7eb;\"></td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;\">136°</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;color:#2ed573;\">✓</td></tr>\n<tr><td style=\"padding:3px 6px;border:1px solid #e5e7eb;\"></td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;\">180°</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;color:#2ed573;\">✓</td></tr>\n<tr><td style=\"padding:3px 6px;border:1px solid #e5e7eb;font-weight:500;\">Back</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;\">225°</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;color:#2ed573;\">✓</td></tr>\n<tr><td style=\"padding:3px 6px;border:1px solid #e5e7eb;\"></td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;\">270°</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;color:#2ed573;\">✓</td></tr>\n<tr><td style=\"padding:3px 6px;border:1px solid #e5e7eb;\"></td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;\">315°</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;color:#2ed573;\">✓</td></tr>\n</table>\n<div style=\"background:#2ed573;color:#fff;padding:4px;text-align:center;border-radius:0 0 6px 6px;font-weight:600;\">10/10 PASS</div>\n</div>\n<!-- X: +120 테이블 -->\n<div>\n<div style=\"background:#dc2626;color:#fff;padding:6px 8px;border-radius:6px 6px 0 0;font-weight:600;text-align:center;\">X: +120</div>\n<table style=\"width:100%;border-collapse:collapse;border:1px solid #e5e7eb;\">\n<tr style=\"background:#f9fafb;\">\n<th style=\"padding:4px 6px;border:1px solid #e5e7eb;text-align:left;\">위치</th>\n<th style=\"padding:4px 6px;border:1px solid #e5e7eb;text-align:center;\">Angle</th>\n<th style=\"padding:4px 6px;border:1px solid #e5e7eb;text-align:center;width:40px;\">Result</th>\n</tr>\n<tr><td style=\"padding:3px 6px;border:1px solid #e5e7eb;\"></td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;\">315°</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;color:#2ed573;\">✓</td></tr>\n<tr><td style=\"padding:3px 6px;border:1px solid #e5e7eb;\"></td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;\">0°</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;color:#2ed573;\">✓</td></tr>\n<tr><td style=\"padding:3px 6px;border:1px solid #e5e7eb;font-weight:500;\">Front</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;\">45°</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;color:#2ed573;\">✓</td></tr>\n<tr><td style=\"padding:3px 6px;border:1px solid #e5e7eb;\"></td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;\">226°</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;color:#2ed573;\">✓</td></tr>\n<tr><td style=\"padding:3px 6px;border:1px solid #e5e7eb;\"></td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;\">270°</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;color:#2ed573;\">✓</td></tr>\n<tr><td style=\"padding:3px 6px;border:1px solid #e5e7eb;\"></td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;\">314°</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;color:#2ed573;\">✓</td></tr>\n<tr style=\"background:#fef2f2;\"><td style=\"padding:3px 6px;border:1px solid #e5e7eb;\"></td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;font-weight:600;color:#dc2626;\">46°</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;color:#dc2626;font-weight:bold;\">✗</td></tr>\n<tr><td style=\"padding:3px 6px;border:1px solid #e5e7eb;\"></td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;\">90°</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;color:#2ed573;\">✓</td></tr>\n<tr><td style=\"padding:3px 6px;border:1px solid #e5e7eb;font-weight:500;\">Back</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;\">135°</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;color:#2ed573;\">✓</td></tr>\n<tr><td style=\"padding:3px 6px;border:1px solid #e5e7eb;\"></td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;\">180°</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;color:#2ed573;\">✓</td></tr>\n<tr><td style=\"padding:3px 6px;border:1px solid #e5e7eb;\"></td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;\">225°</td><td style=\"padding:3px 6px;border:1px solid #e5e7eb;text-align:center;color:#2ed573;\">✓</td></tr>\n</table>\n<div style=\"background:#ffa502;color:#fff;padding:4px;text-align:center;border-radius:0 0 6px 6px;font-weight:600;\">10/11 (46° NG)</div>\n</div>\n</div>\n<div style=\"margin-top:8px;padding:8px;background:#fef2f2;border-radius:6px;font-size:0.75rem;color:#dc2626;border-left:3px solid #dc2626;\">\n<b>46° NG 원인:</b> X_shift 양수 + 46도 각 → 와이어 하네스-카메라 마찰로 쇼크센서 작동<br/>\n<b>조치:</b> 정자세 수행 가능 여부 확인 중\n                            </div>\n</div>\n",
          "headerStyle": "background:linear-gradient(135deg,rgba(46,213,115,0.3),rgba(30,144,255,0.2));"
        },
        {
          "dayName": "수",
          "date": "1/21",
          "weekClass": "w1",
          "taskCount": "완료 6건 + 기타 4건",
          "contentHtml": "\n B라인 완료 4건 \n<div style=\"margin:5px 0;padding:8px 10px;background:rgba(46,213,115,0.15);border-radius:6px;border-left:3px solid #2ed573;\">\n<strong style=\"color:#2ed573;\">✓ B라인 완료 (4건)</strong>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(46,213,115,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-022\" style=\"color:#2ed573;\" target=\"_blank\">PL-2025-022</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>커스텀 팝업 가독성 향상 (창 크기 확대)</div>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(46,213,115,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-074\" style=\"color:#2ed573;\" target=\"_blank\">PL-2025-074</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>에러내용 세분화 (카메라 커버, 용접 셋업 에러)</div>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(46,213,115,0.1);\">\n<span class=\"task-id\" style=\"color:#2ed573;\">신규</span>\n<span class=\"task-owner\">박주한</span>\n<div>관제측 DB 상하한선 UI (로직 적용완료, UI 가시성개선)</div>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(46,213,115,0.1);\">\n<span class=\"task-id\" style=\"color:#2ed573;\">신규</span>\n<span class=\"task-owner\">박주한</span>\n<div>명령 유형 별 데드라인</div>\n</div>\n SP 조치 2건 \n<div style=\"margin:10px 0 5px;padding:8px 10px;background:rgba(5,150,105,0.15);border-radius:6px;border-left:3px solid #059669;\">\n<strong style=\"color:#059669;\">✓ SP 조치 (2건)</strong>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(5,150,105,0.1);\">\n<span class=\"task-id\" style=\"color:#059669;\">신규</span>\n<span class=\"task-owner\">심태양</span>\n<div>B라인 Control Off Speed Limit 수정 (X1/X2축 0.02 통일)</div>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(5,150,105,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-069\" style=\"color:#059669;\" target=\"_blank\">PL-2025-069</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>RAPID 자동 상태 확인 에러 (통신끊김과 동시 발생, 통신자동연결과 같이 조치)</div>\n</div>\n 기타 진행 \n<div style=\"margin:10px 0 5px;padding:8px 10px;background:rgba(255,165,2,0.15);border-radius:6px;border-left:3px solid #ffa502;\">\n<strong style=\"color:#d97706;\">기타 진행</strong>\n</div>\n<div class=\"day-task-item urgent\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-113\" target=\"_blank\">PL-2025-113</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>Z축 과부하 에러 [검증중]</div>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(46,213,115,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-139\" style=\"color:#2ed573;\" target=\"_blank\">PL-2025-139</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>B라인 로봇 동작 이상현상 대응 ✓완료</div>\n</div>\n<div class=\"day-task-item high\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-083\" target=\"_blank\">PL-2025-083</a></span>\n<span class=\"task-owner\">이상주</span>\n<div>X축 하드 리밋 결선 [1/22확인, 1/23조치예정]</div>\n</div>\n<div class=\"day-task-item urgent\">\n<span class=\"task-id\"><a href=\"brake-tuning-plan.html\" target=\"_blank\">브레이크</a></span>\n<span class=\"task-owner\">심태양</span>\n<div>X1/X2축 브레이크 제어 튜닝 테스트</div>\n</div>\n",
          "headerStyle": "background:linear-gradient(135deg,rgba(46,213,115,0.3),rgba(255,165,2,0.2));"
        },
        {
          "dayName": "목",
          "date": "1/22",
          "weekClass": "w1",
          "taskCount": "완료 2건 + 지연 5건",
          "contentHtml": "\n 1/22 완료 \n<div style=\"margin-bottom:8px;padding:6px 8px;background:rgba(16,185,129,0.15);border-radius:6px;border-left:3px solid #10b981;\">\n<strong style=\"color:#10b981;font-size:0.75rem;\">✓ 1/22 완료 (2건)</strong>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(16,185,129,0.1);\">\n<span class=\"task-id\">신규</span>\n<span class=\"task-owner\" style=\"color:#10b981;\">제어팀</span>\n<div>B라인 터치에러 핸들링 <span style=\"background:#10b981;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">삼성컨펌완료</span></div>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(16,185,129,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-116\" style=\"color:#10b981;\" target=\"_blank\">PL-2025-116</a></span>\n<span class=\"task-owner\" style=\"color:#10b981;\">최광년</span>\n<div>노즐 클리닝 티칭 <span style=\"background:#10b981;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">테스트완료</span> (A라인 적용)</div>\n</div>\n 1/27 지연 \n<div style=\"margin:8px 0;padding:6px 8px;background:rgba(255,107,107,0.15);border-radius:6px;border-left:3px solid #ff6b6b;\">\n<strong style=\"color:#ff6b6b;font-size:0.75rem;\">⚠ 1/27 지연 (박주한 담당 5건)</strong>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(255,107,107,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-067\" style=\"color:#ff6b6b;\" target=\"_blank\">PL-2025-067</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>공압/가스/냉각수 상하한치 → 1/27</div>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(255,107,107,0.1);\">\n<span class=\"task-id\" style=\"color:#ff6b6b;\">신규</span>\n<span class=\"task-owner\">박주한</span>\n<div>웜업 UI 가시성 개선 → 1/27</div>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(59,130,246,0.1);border-left:3px solid #3b82f6;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-061\" style=\"color:#3b82f6;\" target=\"_blank\">PL-2025-061</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>PLC알람 관제측 전달 <span style=\"background:#3b82f6;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">PL-2025-084 연계진행</span></div>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(255,107,107,0.1);\">\n<span class=\"task-id\" style=\"color:#ff6b6b;\">신규</span>\n<span class=\"task-owner\">박주한</span>\n<div>와이어 동시 피딩 기능 → 1/27</div>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(255,107,107,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-096\" style=\"color:#ff6b6b;\" target=\"_blank\">PL-2025-096</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>비정상 용접선 정보 필터링 → 1/27</div>\n</div>\n A라인 진행 \n<div style=\"margin:8px 0;padding:6px 8px;background:rgba(37,99,235,0.1);border-radius:6px;border-left:3px solid #2563eb;\">\n<strong style=\"color:#2563eb;font-size:0.75rem;\">A라인 진행 (3건)</strong>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(16,185,129,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-020\" target=\"_blank\">PL-2025-020</a></span>\n<span class=\"task-owner\" style=\"color:#10b981;\">A라인</span>\n<div>버티컬 용접데이터 UI <span style=\"background:#10b981;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">품질확인완료</span> (관제연동 23일 예정)</div>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(16,185,129,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-177\" target=\"_blank\">PL-2026-177</a></span>\n<span class=\"task-owner\" style=\"color:#10b981;\">박주한</span>\n<div>에러플래그 초기화 UI <span style=\"background:#10b981;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">전달완료</span></div>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(245,158,11,0.1);\">\n<span class=\"task-id\">신규</span>\n<span class=\"task-owner\" style=\"color:#f59e0b;\">조용현</span>\n<div>A라인 디지털 트윈 개선 <span style=\"background:#f59e0b;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">확인대기</span> (B라인 개선완료)</div>\n</div>\n 긴급 - Plan C 관련 \n<div style=\"margin:8px 0;padding:6px 8px;background:rgba(220,38,38,0.15);border-radius:6px;border-left:3px solid #dc2626;\">\n<strong style=\"color:#dc2626;font-size:0.75rem;\">🔴 긴급 (1건)</strong>\n</div>\n<div class=\"day-task-item urgent\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-184\" target=\"_blank\">PL-2026-184</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>Plan C 아크에러 동기화 에러 <span style=\"background:#dc2626;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">검증중</span></div>\n</div>\n 기타 예정 \n<div style=\"margin:8px 0;padding:6px 8px;background:rgba(107,114,128,0.1);border-radius:6px;border-left:3px solid #6b7280;\">\n<strong style=\"color:#6b7280;font-size:0.75rem;\">기타 예정 (4건)</strong>\n</div>\n<div class=\"day-task-item\" style=\"background:#dcfce7;border-left:3px solid #22c55e;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-165\" target=\"_blank\">PL-2026-165</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>✅ 용접 포인트 부재 두깨 반영 완료</div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-080\" target=\"_blank\">PL-2025-080</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>아크 에러 시 RAPID 제어 [검증]</div>\n</div>\n<div class=\"day-task-item high\" style=\"background:rgba(59,130,246,0.1);border-left:3px solid #3b82f6;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-084\" target=\"_blank\">PL-2025-084</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>PLC 알람 체크 <span style=\"background:#3b82f6;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">PL-2025-061 연계진행</span></div>\n</div>\n<div class=\"day-task-item high\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-155\" target=\"_blank\">PL-2025-155</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>홀센서 기반 원점 인식 <span style=\"background:#3b82f6;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">UI준비</span> (A라인 우선, B라인 PlanC 오염)</div>\n</div>\n",
          "cardStyle": "border:2px solid #10b981;",
          "headerStyle": "background:linear-gradient(135deg,rgba(16,185,129,0.2),rgba(16,185,129,0.1));",
          "taskCountStyle": "background:#10b981;color:#fff;"
        },
        {
          "dayName": "금",
          "date": "1/23",
          "weekClass": "w1",
          "taskCount": "6건 완료",
          "contentHtml": "\n 1/23 신규 추가: 스프레이 티칭 테스트 \n<div class=\"day-task-item high\" style=\"background:rgba(16,185,129,0.15);border-left:3px solid #10b981;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-117\" target=\"_blank\">PL-2025-117</a></span>\n<span class=\"task-owner\">최광년</span>\n<div>스프레이 티칭 기능 <span style=\"background:#10b981;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">테스트예정</span></div>\n</div>\n<div class=\"day-task-item\" style=\"background:rgba(59,130,246,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-099\" target=\"_blank\">PL-2025-099</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>UI 조작 로깅 <span style=\"background:#3b82f6;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">완료예정</span></div>\n</div>\n<div class=\"day-task-item low\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-111\" target=\"_blank\">PL-2025-111</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>형상 보간 실패 에러 <span style=\"background:#6b7280;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">기능필요</span></div>\n</div>\n<div class=\"day-task-item high\" style=\"background:rgba(16,185,129,0.15);border-left:3px solid #10b981;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-105\" target=\"_blank\">PL-2025-105</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>로봇/UI 통신 단절 <span style=\"background:#10b981;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">완료</span></div>\n</div>\n<div class=\"day-task-item high\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-020\" target=\"_blank\">PL-2025-020</a></span>\n<span class=\"task-owner\">A라인</span>\n<div>버티컬 용접데이터 관제연동</div>\n</div>\n<div class=\"day-task-item high\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-083\" target=\"_blank\">PL-2025-083</a></span>\n<span class=\"task-owner\">이상주</span>\n<div>X축 하드 리밋 결선 조치</div>\n</div>\n",
          "cardStyle": "border:2px solid #10b981;",
          "headerStyle": "background:linear-gradient(135deg,rgba(16,185,129,0.2),rgba(16,185,129,0.1));",
          "headerBadge": "<span style=\"background:#10b981;color:#fff;padding:2px 6px;border-radius:4px;font-size:0.65rem;margin-left:4px;\">완료</span>",
          "taskCountStyle": "background:#10b981;color:#fff;"
        },
        {
          "dayName": "토 (현장작업)",
          "date": "1/24",
          "weekClass": "w1",
          "taskCount": "3건 완료",
          "contentHtml": "\n 완료 항목 \n<div style=\"margin:5px 0;padding:8px 10px;background:rgba(16,185,129,0.15);border-radius:6px;border-left:3px solid #10b981;\">\n<strong style=\"color:#10b981;\">✅ 완료 (3건)</strong>\n</div>\n<div class=\"day-task-item high\" style=\"background:rgba(16,185,129,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-168\" target=\"_blank\">PL-2026-168</a></span>\n<span class=\"task-owner\">이상주</span>\n<div>불스아이 결선 <span style=\"background:#10b981;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">완료</span></div>\n</div>\n<div class=\"day-task-item high\" style=\"background:rgba(16,185,129,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-142\" target=\"_blank\">PL-2025-142</a></span>\n<span class=\"task-owner\">기계팀</span>\n<div>B라인 BullsEye 설치 <span style=\"background:#10b981;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">완료</span></div>\n</div>\n<div class=\"day-task-item high\" style=\"background:rgba(16,185,129,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-097\" target=\"_blank\">PL-2025-097</a></span>\n<span class=\"task-owner\">기계팀</span>\n<div>로봇 절연처리 (백그라이트) <span style=\"background:#10b981;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">완료</span></div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(16,185,129,0.1);border-left:3px solid #10b981;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-124\" target=\"_blank\">PL-2025-124</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>디바이스넷 통신 상실 <span style=\"background:#10b981;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">완료</span></div>\n</div>\n<div class=\"day-task-item high\" style=\"background:rgba(16,185,129,0.15);border-left:3px solid #10b981;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-143\" target=\"_blank\">PL-2025-143</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>용접 가능 범위 제한 <span style=\"background:#10b981;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">완료</span></div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(16,185,129,0.15);border-left:3px solid #10b981;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-148\" target=\"_blank\">PL-2025-148</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>갠트리 이동 가능 범위 변수화 <span style=\"background:#10b981;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">완료</span></div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-168\" target=\"_blank\">PL-2026-168</a></span>\n<span class=\"task-owner\">이상주</span>\n<div>불스아이 결선</div>\n</div>\n",
          "cardStyle": "border: 2px solid #10b981;",
          "headerStyle": "background: rgba(16,185,129,0.3);",
          "headerBadge": "<span style=\"background:#10b981;color:#fff;padding:2px 6px;border-radius:4px;font-size:0.65rem;margin-left:4px;\">완료</span>",
          "taskCountStyle": "background:#10b981;color:#fff;"
        }
      ]
    },
    {
      "heading": "2주차 상세 일정 (1/26~2/1) - 높음 우선순위 집중",
      "cards": [
        {
          "dayName": "월",
          "date": "1/26",
          "weekClass": "w2",
          "taskCount": "완료1 + 신규5 + 긴급1",
          "contentHtml": "\n A라인 1/26 완료 \n<div style=\"margin:5px 0;padding:8px 10px;background:rgba(16,185,129,0.15);border-radius:6px;border-left:3px solid #10b981;\">\n<strong style=\"color:#10b981;\">✅ A라인 1/26 완료 (1건)</strong>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(16,185,129,0.1);border-left:3px solid #10b981;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-202\" target=\"_blank\">PL-2026-202</a></span>\n<span class=\"task-owner\">심태양</span>\n<div>A라인 윤활 배관 수정 작업 <span style=\"background:#10b981;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">완료</span></div>\n</div>\n A라인 테스트완료 (배포대기) \n<div style=\"margin:8px 0;padding:6px 8px;background:rgba(16,185,129,0.15);border-radius:6px;border-left:3px solid #10b981;\">\n<strong style=\"color:#10b981;font-size:0.75rem;\">✅ A라인 테스트완료 (배포대기 2건)</strong>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(16,185,129,0.1);border-left:3px solid #10b981;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-191\" target=\"_blank\">PL-2026-191</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>웜업 UI 가시성 개선 <span style=\"background:#10b981;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">테스트완료</span></div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(16,185,129,0.1);border-left:3px solid #10b981;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-157\" target=\"_blank\">PL-2025-157</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>수평 터치 오프셋 일괄 변경 <span style=\"background:#10b981;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">테스트완료</span></div>\n</div>\n A라인 개선필요 \n<div style=\"margin:8px 0;padding:6px 8px;background:rgba(245,158,11,0.15);border-radius:6px;border-left:3px solid #f59e0b;\">\n<strong style=\"color:#f59e0b;font-size:0.75rem;\">⚠️ A라인 개선필요 (1건)</strong>\n</div>\n<div class=\"day-task-item\" style=\"background:#dcfce7;border-left:3px solid #22c55e;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-106\" target=\"_blank\">PL-2025-106</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>✅ UI와 관제 통신 주기 문제 완료 (1/28)</div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(245,158,11,0.1);border-left:3px solid #f59e0b;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-196\" target=\"_blank\">PL-2026-196</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>커스텀 팝업 (프리징현상) <span style=\"background:#f59e0b;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">개선필요</span></div>\n</div>\n 1/27 예정 \n<div style=\"margin:8px 0;padding:6px 8px;background:rgba(59,130,246,0.15);border-radius:6px;border-left:3px solid #3b82f6;\">\n<strong style=\"color:#3b82f6;font-size:0.75rem;\">📅 1/27 예정 (8건)</strong>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(59,130,246,0.1);border-left:3px solid #3b82f6;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-092\" target=\"_blank\">PL-2025-092</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>수직 터치 센싱 오프셋 값 적용 <span style=\"background:#3b82f6;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">1/27테스트</span></div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(59,130,246,0.1);border-left:3px solid #3b82f6;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-020\" target=\"_blank\">PL-2025-020</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>수직용접 CSV작성 1/3 (간섭확인용 자세정보→삼성전달) <span style=\"background:#8b5cf6;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">진행대기</span></div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(59,130,246,0.1);border-left:3px solid #3b82f6;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-170\" target=\"_blank\">PL-2026-170</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>갠트리 상대 이동 조깅 기능 <span style=\"background:#3b82f6;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">2/7→1/27</span></div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(59,130,246,0.1);border-left:3px solid #3b82f6;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-084\" target=\"_blank\">PL-2025-084</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>PLC 알람 체크 (061 연계) <span style=\"background:#3b82f6;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">1/22→1/27</span></div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(59,130,246,0.1);border-left:3px solid #3b82f6;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-179\" target=\"_blank\">PL-2026-179</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>매크로 미선택 시 전체 용접데이터 표시 <span style=\"background:#3b82f6;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">1/27진행</span></div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(59,130,246,0.1);border-left:3px solid #3b82f6;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-039\" target=\"_blank\">PL-2025-039</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>불스아이 스프레이 LOW 경고 <span style=\"background:#3b82f6;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">1/22→1/27</span></div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(59,130,246,0.1);border-left:3px solid #3b82f6;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-156\" target=\"_blank\">PL-2025-156</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>경광등-UI-관제 동기화 (UI알람 표시) <span style=\"background:#3b82f6;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">2/7→1/27</span></div>\n</div>\n B라인 확인완료 \n<div style=\"margin:8px 0;padding:6px 8px;background:rgba(16,185,129,0.15);border-radius:6px;border-left:3px solid #10b981;\">\n<strong style=\"color:#10b981;font-size:0.75rem;\">✅ B라인 확인완료 (3건)</strong>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(16,185,129,0.1);border-left:3px solid #10b981;\">\n<span class=\"task-owner\">B라인</span>\n<div>불스아이 스프레이/클리닝 동작 확인 <span style=\"background:#10b981;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">확인완료</span></div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(16,185,129,0.1);border-left:3px solid #10b981;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-150\" target=\"_blank\">PL-2025-150</a> / <a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-192\" target=\"_blank\">192</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>와이어 동시 피딩 기능 <span style=\"background:#10b981;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">테스트완료</span></div>\n</div>\n B라인 진행중 \n<div style=\"margin:8px 0;padding:6px 8px;background:rgba(245,158,11,0.15);border-radius:6px;border-left:3px solid #f59e0b;\">\n<strong style=\"color:#f59e0b;font-size:0.75rem;\">🔧 B라인 진행중 (1건)</strong>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(245,158,11,0.1);border-left:3px solid #f59e0b;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-167\" target=\"_blank\">PL-2026-167</a></span>\n<span class=\"task-owner\">이상주</span>\n<div>B라인 센서 명판 부착 <span style=\"background:#f59e0b;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">40%</span></div>\n</div>\n 1/26 신규 추가 항목 \n<div style=\"margin:8px 0;padding:6px 8px;background:rgba(139,92,246,0.15);border-radius:6px;border-left:3px solid #8b5cf6;\">\n<strong style=\"color:#8b5cf6;font-size:0.75rem;\">🆕 1/26 신규 추가 (5건)</strong>\n</div>\n<div class=\"day-task-item high\" style=\"background:rgba(139,92,246,0.1);border-left:3px solid #8b5cf6;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-198\" target=\"_blank\">PL-2026-198</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>동일 위치 터치 에러 발생 처리 <span style=\"background:#8b5cf6;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">NEW</span> <span style=\"background:#ff6b6b;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">높음</span></div>\n</div>\n<div class=\"day-task-item high\" style=\"background:rgba(139,92,246,0.1);border-left:3px solid #8b5cf6;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-199\" target=\"_blank\">PL-2026-199</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>끝점 터치 후 시작점 이동 에러 (터치에러2단계) <span style=\"background:#3b82f6;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">1/27진행</span> <span style=\"background:#ff6b6b;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">높음</span></div>\n</div>\n<div class=\"day-task-item high\" style=\"background:rgba(139,92,246,0.1);border-left:3px solid #8b5cf6;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-200\" target=\"_blank\">PL-2026-200</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>수직용접 관제 명령 및 노티 연결 <span style=\"background:#8b5cf6;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">NEW</span> <span style=\"background:#ff6b6b;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">높음</span></div>\n</div>\n<div class=\"day-task-item high\" style=\"background:rgba(139,92,246,0.1);border-left:3px solid #8b5cf6;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-188\" target=\"_blank\">PL-2026-188</a></span>\n<span class=\"task-owner\">최광년</span>\n<div>CCLink IO CO_16_HeadShock 생성 <span style=\"background:#3b82f6;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">1/27진행</span> <span style=\"background:#ff6b6b;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">높음</span></div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(139,92,246,0.1);border-left:3px solid #8b5cf6;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-194\" target=\"_blank\">PL-2026-194</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>B라인 Z방향 상대이동 표시 <span style=\"background:#8b5cf6;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">NEW</span> <span style=\"background:#10b981;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">완료</span></div>\n</div>\n 긴급 진행 항목 \n<div style=\"margin:8px 0;padding:6px 8px;background:rgba(220,38,38,0.1);border-radius:6px;border-left:3px solid #dc2626;\">\n<strong style=\"color:#dc2626;font-size:0.75rem;\">🔴 긴급 진행</strong>\n</div>\n<div class=\"day-task-item\" style=\"background:#dcfce7;border-left:3px solid #22c55e;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-165\" target=\"_blank\">PL-2026-165</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>✅ 용접 포인트 부재 두께 반영 완료 (2/3)</div>\n</div>\n 지연 항목 (1/27 예정) \n<div style=\"margin:8px 0;padding:6px 8px;background:rgba(255,107,107,0.15);border-radius:6px;border-left:3px solid #ff6b6b;\">\n<strong style=\"color:#ff6b6b;font-size:0.75rem;\">⚠ 1/27 지연 (박주한 5건)</strong>\n</div>\n"
        },
        {
          "dayName": "화",
          "date": "1/27",
          "weekClass": "w2",
          "taskCount": "13건 (지연 5건 포함)",
          "contentHtml": "\n PL-2025-089: 1/28에 유지, 1/27 제거 (중복) \n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-115\" target=\"_blank\">PL-2025-115</a></span>\n<span class=\"task-owner\">최광년</span>\n<div>B라인 앵글 회피 거리</div>\n</div>\n PL-2025-109: 1/22 완료로 제거 \n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-033\" target=\"_blank\">PL-2025-033</a></span>\n<span class=\"task-owner\">박기혁</span>\n<div>로봇 전원 케이블 타입</div>\n</div>\n<div class=\"day-task-item high\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-020\" target=\"_blank\">PL-2025-020</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>A라인 수직용접</div>\n</div>\n<div class=\"day-task-item high\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-023\" target=\"_blank\">PL-2025-023</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>로봇 자동 운전 조건 진단</div>\n</div>\n<div class=\"day-task-item high\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-092\" target=\"_blank\">PL-2025-092</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>A라인 수직용접 터치 옵셋</div>\n</div>\n<div class=\"day-task-item high\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-169\" target=\"_blank\">PL-2026-169</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>한팔용접 (1xx 매크로) [1/27~29]</div>\n</div>\n"
        },
        {
          "dayName": "수",
          "date": "1/28",
          "weekClass": "w2",
          "taskCount": "8건",
          "contentHtml": "\n<div class=\"day-task-item normal\" style=\"background:rgba(46,213,115,0.1);border-left:3px solid #2ed573;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-089\" target=\"_blank\">PL-2025-089</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>✅ 돌림 용접 구간 개별 옵셋 (완료)</div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-116\" target=\"_blank\">PL-2025-116</a></span>\n<span class=\"task-owner\">최광년</span>\n<div>노즐 클리닝 티칭</div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(16,185,129,0.15);border-left:3px solid #10b981;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-166\" target=\"_blank\">PL-2026-166</a></span>\n<span class=\"task-owner\">이상주</span>\n<div>경광등 스위치 추가 <span style=\"background:#10b981;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">완료</span></div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(16,185,129,0.15);border-left:3px solid #10b981;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-034\" target=\"_blank\">PL-2025-034</a></span>\n<span class=\"task-owner\">박기혁</span>\n<div>릴, 피더기 위치 상향 <span style=\"background:#10b981;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">완료</span></div>\n</div>\n<div class=\"day-task-item high\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-100\" target=\"_blank\">PL-2025-100</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>터치 모션 파라미터 X_init</div>\n</div>\n<div class=\"day-task-item high\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-132\" target=\"_blank\">PL-2025-132</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>A라인 계측 홈 / 기본 Z홈 구분</div>\n</div>\n<div class=\"day-task-item high\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-142\" target=\"_blank\">PL-2025-142</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>B라인 BullsEye 모션 확인</div>\n</div>\n"
        },
        {
          "dayName": "목",
          "date": "1/29",
          "weekClass": "w2",
          "taskCount": "6건",
          "contentHtml": "\n PL-2025-088: 1/30에 유지, 1/29 제거 (중복) \n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-117\" target=\"_blank\">PL-2025-117</a></span>\n<span class=\"task-owner\">최광년</span>\n<div>스프레이 티칭 기능</div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(16,185,129,0.15);border-left:3px solid #10b981;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-035\" target=\"_blank\">PL-2025-035</a></span>\n<span class=\"task-owner\">박기혁</span>\n<div>블스아이 위치 확정 <span style=\"background:#10b981;color:#fff;padding:1px 4px;border-radius:3px;font-size:0.6rem;\">완료</span></div>\n</div>\n<div class=\"day-task-item high\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-146\" target=\"_blank\">PL-2025-146</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>TCP 위치 기반 커맨드 판단</div>\n</div>\n<div class=\"day-task-item high\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-149\" target=\"_blank\">PL-2025-149</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>용접기 복원 매뉴얼 작성</div>\n</div>\n<div class=\"day-task-item high\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-152\" target=\"_blank\">PL-2025-152</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>LDS 센서 기반 원점 인식</div>\n</div>\n"
        },
        {
          "dayName": "금",
          "date": "1/30",
          "weekClass": "w2",
          "taskCount": "5건",
          "contentHtml": "\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-088\" target=\"_blank\">PL-2025-088</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>권한 설정 (계속)</div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(107,114,128,0.15);border-left:3px solid #6b7280;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-036\" style=\"color:#6b7280;\" target=\"_blank\">PL-2025-036</a></span>\n<span class=\"task-owner\">박기혁</span>\n<div><span style=\"color:#6b7280;\">[보류]</span> 거더 상향 조정</div>\n</div>\n<div class=\"day-task-item high\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-154\" target=\"_blank\">PL-2025-154</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>명령 취소 시 rInit 동작</div>\n</div>\n<div class=\"day-task-item high\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-155\" target=\"_blank\">PL-2025-155</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>홀 센서 기반 원점 인식</div>\n</div>\n"
        },
        {
          "dayName": "토",
          "date": "1/31",
          "weekClass": "w2",
          "taskCount": "5건",
          "contentHtml": "\n<div class=\"day-task-item\" style=\"background:#dcfce7;border-left:3px solid #22c55e;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-191\" target=\"_blank\">PL-2026-191</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>✅ 웜업 A/B라인 컨펌완료</div>\n</div>\n<div class=\"day-task-item\" style=\"background:#dcfce7;border-left:3px solid #22c55e;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-173\" target=\"_blank\">PL-2026-173</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>✅ A라인 스프레이/토치클리닝 컨펌</div>\n</div>\n<div class=\"day-task-item\" style=\"background:#dcfce7;border-left:3px solid #22c55e;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-172\" target=\"_blank\">PL-2026-172</a></span>\n<span class=\"task-owner\">최광년</span>\n<div>✅ 노즐 클리닝/스프레이 완료</div>\n</div>\n<div class=\"day-task-item\" style=\"background:#dbeafe;border-left:3px solid #3b82f6;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-092\" target=\"_blank\">PL-2025-092</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>🔧 수직용접 터치 옵셋 진행중</div>\n</div>\n<div class=\"day-task-item high\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-048\" target=\"_blank\">PL-2025-048</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>Plan B 로봇 시스템 재구성</div>\n</div>\n"
        },
        {
          "dayName": "일",
          "date": "2/1",
          "weekClass": "w2",
          "taskCount": "점검",
          "contentHtml": "\n<div class=\"day-task-item normal\">\n<span class=\"task-owner\">전체</span>\n<div>2주차 완료 점검 및 3주차 준비</div>\n</div>\n"
        }
      ],
      "summaryHtml": "<div style=\"display:grid;grid-template-columns:repeat(4,1fr);gap:15px;margin-bottom:20px;padding:15px;background:#fff;border-radius:12px;box-shadow:0 2px 8px rgba(0,0,0,0.08);\">\n<div style=\"text-align:center;padding:15px;background:linear-gradient(135deg,#10b981,#059669);border-radius:8px;color:#fff;\">\n<div style=\"font-size:2rem;font-weight:700;\">18</div>\n<div style=\"font-size:0.8rem;opacity:0.9;\">✅ 1/26 기준 완료</div>\n</div>\n<div style=\"text-align:center;padding:15px;background:linear-gradient(135deg,#f59e0b,#d97706);border-radius:8px;color:#fff;\">\n<div style=\"font-size:2rem;font-weight:700;\">8</div>\n<div style=\"font-size:0.8rem;opacity:0.9;\">🔧 진행중/테스트완료</div>\n</div>\n<div style=\"text-align:center;padding:15px;background:linear-gradient(135deg,#dc2626,#b91c1c);border-radius:8px;color:#fff;\">\n<div style=\"font-size:2rem;font-weight:700;\">5</div>\n<div style=\"font-size:0.8rem;opacity:0.9;\">⚠️ 지연 (1/27 예정)</div>\n</div>\n<div style=\"text-align:center;padding:15px;background:linear-gradient(135deg,#8b5cf6,#7c3aed);border-radius:8px;color:#fff;\">\n<div style=\"font-size:2rem;font-weight:700;\">5</div>\n<div style=\"font-size:0.8rem;opacity:0.9;\">🆕 신규 추가</div>\n</div>\n</div><div style=\"display:grid;grid-template-columns:1fr 1fr;gap:15px;margin-bottom:20px;\">\n<!-- 완료 항목 -->\n<div style=\"background:#fff;border-radius:12px;padding:15px;box-shadow:0 2px 8px rgba(0,0,0,0.08);border-left:4px solid #10b981;\">\n<h3 style=\"color:#10b981;margin-bottom:10px;font-size:1rem;\">✅ 1/26 기준 완료 (18건)</h3>\n<div style=\"font-size:0.8rem;line-height:1.8;\">\n<div style=\"padding:4px 0;border-bottom:1px dashed #e5e7eb;\"><strong>1/20:</strong> 토크모니터링, Z홈모드, 갠트리리밋, 디지털트윈, PlanC (5건)</div>\n<div style=\"padding:4px 0;border-bottom:1px dashed #e5e7eb;\"><strong>1/21:</strong> 커스텀팝업, 에러세분화, DB상하한선UI, 데드라인, SpeedLimit, RAPID에러 (6건)</div>\n<div style=\"padding:4px 0;border-bottom:1px dashed #e5e7eb;\"><strong>1/22:</strong> B라인터치에러, 노즐클리닝 (2건)</div>\n<div style=\"padding:4px 0;border-bottom:1px dashed #e5e7eb;\"><strong>1/23:</strong> 스프레이티칭, 디지털트윈영상 (2건)</div>\n<div style=\"padding:4px 0;border-bottom:1px dashed #e5e7eb;\"><strong>1/24:</strong> 불스아이결선, BullsEye설치, 로봇절연처리 (3건)</div>\n<div style=\"padding:4px 0;color:#10b981;font-weight:600;\"><strong>1/26:</strong> 윤활배관수정 PL-2026-202 (1건)</div>\n</div>\n</div>\n<!-- 지연 항목 -->\n<div style=\"background:#fff;border-radius:12px;padding:15px;box-shadow:0 2px 8px rgba(0,0,0,0.08);border-left:4px solid #dc2626;\">\n<h3 style=\"color:#dc2626;margin-bottom:10px;font-size:1rem;\">⚠️ 지연 항목 (5건) → 1/27 예정</h3>\n<div style=\"font-size:0.8rem;line-height:1.8;\">\n<div style=\"padding:4px 0;border-bottom:1px dashed #e5e7eb;\">❌ PL-2025-067 공압/가스/냉각수 상하한치 <span style=\"color:#666;\">(박주한)</span></div>\n<div style=\"padding:4px 0;border-bottom:1px dashed #e5e7eb;\">❌ PL-2025-061 PLC알람 관제측 전달 <span style=\"color:#666;\">(박주한)</span></div>\n<div style=\"padding:4px 0;border-bottom:1px dashed #e5e7eb;\">📅 PL-2025-096 비정상 용접선 정보 필터링 <span style=\"color:#3b82f6;font-weight:600;\">→ 2/2 진행</span></div>\n<div style=\"padding:4px 0;color:#f59e0b;\">✅ PL-2026-191 웜업 UI 가시성 <span style=\"color:#10b981;font-weight:600;\">테스트완료→배포대기</span></div>\n<div style=\"padding:4px 0;color:#f59e0b;\">✅ PL-2025-150 와이어 동시피딩 <span style=\"color:#10b981;font-weight:600;\">테스트완료→배포대기</span></div>\n</div>\n<div style=\"margin-top:10px;padding:8px;background:#fef2f2;border-radius:6px;font-size:0.75rem;color:#dc2626;\">\n                        ※ 1/22 예정 → 1/27로 일정 변경\n                    </div>\n</div>\n</div>"
    },
    {
      "heading": "3주차 상세 일정 (2/2~2/7) - 보통/낮음 마무리",
      "cards": [
        {
          "dayName": "월",
          "date": "2/2",
          "weekClass": "w3",
          "taskCount": "5건",
          "contentHtml": "\n<div class=\"day-task-item verify\" style=\"background:rgba(59,130,246,0.1);border-left:3px solid #3b82f6;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-096\" target=\"_blank\">PL-2025-096</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>🔧 비정상 용접선 정보 필터링</div>\n</div>\n<div class=\"day-task-item verify\" style=\"background:rgba(59,130,246,0.1);border-left:3px solid #3b82f6;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-100\" target=\"_blank\">PL-2025-100</a></span>\n<span class=\"task-owner\">최광년</span>\n<div>🔧 터치 모션 파라미터 X_init</div>\n</div>\n<div class=\"day-task-item high\" style=\"background:rgba(245,158,11,0.1);border-left:3px solid #f59e0b;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-092\" target=\"_blank\">PL-2025-092</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>🔧 A라인 수직용접 터치 옵셋 (계속)</div>\n</div>\n<div class=\"day-task-item high\" style=\"background:rgba(245,158,11,0.1);border-left:3px solid #f59e0b;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-200\" target=\"_blank\">PL-2026-200</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>🔧 수직용접 관제 명령 (계속)</div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-owner\">전체</span>\n<div>📋 2주차 완료 점검 / 3주차 시작</div>\n</div>\n"
        },
        {
          "dayName": "화",
          "date": "2/3",
          "weekClass": "w3",
          "taskCount": "7건",
          "contentHtml": "\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-060\" target=\"_blank\">PL-2025-060</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>시뮬레이션 vs 실제 알람</div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-104\" target=\"_blank\">PL-2025-104</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>작업자 사용 이력 로그</div>\n</div>\n<div class=\"day-task-item low\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-131\" target=\"_blank\">PL-2025-131</a></span>\n<span class=\"task-owner\">이상주</span>\n<div>PC 전원 인가 방법</div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-008\" target=\"_blank\">PL-2025-008</a></span>\n<span class=\"task-owner\">기계팀</span>\n<div>블스아이 용접토치 스프레이</div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-026\" target=\"_blank\">PL-2025-026</a></span>\n<span class=\"task-owner\">기계팀</span>\n<div>컨트롤러 보전용 발판</div>\n</div>\n<div class=\"day-task-item low\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-021\" target=\"_blank\">PL-2025-021</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>사용자 편의성 UI 개선</div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-055\" target=\"_blank\">PL-2025-055</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>B라인 드라이런 속도 배율</div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-065\" target=\"_blank\">PL-2025-065</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>실시간 용접 조건 변경</div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-167\" target=\"_blank\">PL-2026-167</a></span>\n<span class=\"task-owner\">이상주</span>\n<div>B라인 센서 명판 부착</div>\n</div>\n"
        },
        {
          "dayName": "수",
          "date": "2/4",
          "weekClass": "w3",
          "taskCount": "13건",
          "contentHtml": "\n 2/4 완료 항목 (6건) \n<div class=\"day-task-item completed\" style=\"background:#f0fdf4;border-left:3px solid #22c55e;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-083\" style=\"color:#16a34a;\" target=\"_blank\">PL-2025-083</a></span>\n<span class=\"task-owner\">이상주</span>\n<div>✅ X축 하드 리밋 결선 [완료] → PL-2026-217 후속이슈</div>\n</div>\n<div class=\"day-task-item completed\" style=\"background:#f0fdf4;border-left:3px solid #22c55e;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-092\" style=\"color:#16a34a;\" target=\"_blank\">PL-2025-092</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>✅ A라인 수직용접 터치 옵셋 [완료]</div>\n</div>\n<div class=\"day-task-item completed\" style=\"background:#f0fdf4;border-left:3px solid #22c55e;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-126\" style=\"color:#16a34a;\" target=\"_blank\">PL-2025-126</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>✅ 작업 취소 시 속도 0% [완료]</div>\n</div>\n<div class=\"day-task-item completed\" style=\"background:#f0fdf4;border-left:3px solid #22c55e;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-147\" style=\"color:#16a34a;\" target=\"_blank\">PL-2025-147</a></span>\n<span class=\"task-owner\">최광년</span>\n<div>✅ 계측 도중 X축 범위 확인 [완료]</div>\n</div>\n<div class=\"day-task-item completed\" style=\"background:#f0fdf4;border-left:3px solid #22c55e;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-214\" style=\"color:#16a34a;\" target=\"_blank\">PL-2026-214</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>✅ 와이어 교체모드 R축 0도 세팅 [완료]</div>\n</div>\n 이슈/진행 항목 \n<div class=\"day-task-item high\" style=\"background:#fef2f2;border-left:3px solid #ef4444;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-170\" style=\"color:#dc2626;\" target=\"_blank\">PL-2026-170</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>⚠️ 갠트리 조깅 - Y축 이슈 (본사지원필요)</div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:#fffbeb;border-left:3px solid #f59e0b;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-100\" target=\"_blank\">PL-2025-100</a></span>\n<span class=\"task-owner\">최광년</span>\n<div>🔄 터치 모션 파라미터 X_init [진행중]</div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:#fffbeb;border-left:3px solid #f59e0b;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-177\" target=\"_blank\">PL-2026-177</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>🔄 터치/아크에러 후 로봇 초기화 [진행중]</div>\n</div>\n 보류 전환 \n<div class=\"day-task-item normal\" style=\"background:rgba(46,213,115,0.1);border-left:3px solid #2ed573;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-089\" style=\"color:#2ed573;\" target=\"_blank\">PL-2025-089</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>✅ 돌림 용접 구간 개별 옵셋 [완료 - PL-2025-015]</div>\n</div>\n 신규 등록 \n<div class=\"day-task-item normal\" style=\"background:rgba(155,89,182,0.1);border-left:3px solid #9b59b6;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-215\" style=\"color:#9b59b6;\" target=\"_blank\">PL-2026-215</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>🆕 매크로 122 터치 보정 모션 변경 [신규]</div>\n</div>\n 기존 계획 항목 \n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-157\" target=\"_blank\">PL-2025-157</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>터치 오프셋 일괄 변경</div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-091\" target=\"_blank\">PL-2025-091</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>수동 용접시 기능 추가</div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-121\" target=\"_blank\">PL-2025-121</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>시작점 터치 TCP 오프셋</div>\n</div>\n"
        },
        {
          "dayName": "목",
          "date": "2/5",
          "weekClass": "w3",
          "taskCount": "11건",
          "contentHtml": "\n 2/5 완료 (3건) \n<div class=\"day-task-item completed\" style=\"background:#f0fdf4;border-left:3px solid #22c55e;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-184\" style=\"color:#16a34a;\" target=\"_blank\">PL-2026-184</a></span>\n<span class=\"task-owner\">최광년</span>\n<div>✅ Plan C 아크에러 동기화 에러 [완료]</div>\n</div>\n<div class=\"day-task-item completed\" style=\"background:#f0fdf4;border-left:3px solid #22c55e;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-206\" style=\"color:#16a34a;\" target=\"_blank\">PL-2026-206</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>✅ 와이어 인칭 개별제어 [완료]</div>\n</div>\n<div class=\"day-task-item completed\" style=\"background:#f0fdf4;border-left:3px solid #22c55e;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-210\" style=\"color:#16a34a;\" target=\"_blank\">PL-2026-210</a></span>\n<span class=\"task-owner\">기계팀</span>\n<div>✅ 케이블 베어 클램프 미체결 [완료]</div>\n</div>\n 2/5 진행중/신규 \n<div class=\"day-task-item high\" style=\"background:#fef2f2;border-left:3px solid #ef4444;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-217\" style=\"color:#dc2626;\" target=\"_blank\">PL-2026-217</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>🆕 하드/소프트 리밋 Bypass 동시동작 오류 [진행중]</div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(155,89,182,0.1);border-left:3px solid #9b59b6;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-216\" style=\"color:#9b59b6;\" target=\"_blank\">PL-2026-216</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>🆕 터치/갠트리 오프셋 엑셀 관리 [신규]</div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(155,89,182,0.1);border-left:3px solid #9b59b6;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-218\" style=\"color:#9b59b6;\" target=\"_blank\">PL-2026-218</a></span>\n<span class=\"task-owner\">기계팀</span>\n<div>🆕 라이트 커튼 추가 설치 및 결선 [신규]</div>\n</div>\n 기존 계획 항목 \n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-157\" target=\"_blank\">PL-2025-157</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>터치 오프셋 (계속)</div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-032\" target=\"_blank\">PL-2025-032</a></span>\n<span class=\"task-owner\">기계팀</span>\n<div>토치 케이블 처짐 방지</div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-040\" target=\"_blank\">PL-2025-040</a></span>\n<span class=\"task-owner\">기계팀</span>\n<div>레이저 커튼 보완</div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-138\" target=\"_blank\">PL-2025-138</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>B라인 터치 보정 에러</div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-141\" target=\"_blank\">PL-2025-141</a></span>\n<span class=\"task-owner\">최광년</span>\n<div>SMB 배터리 관리</div>\n</div>\n"
        },
        {
          "dayName": "금",
          "date": "2/6",
          "weekClass": "w3",
          "taskCount": "4건",
          "contentHtml": "\n<div class=\"day-task-item low\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-093\" target=\"_blank\">PL-2025-093</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>운영 S/W 최종 매뉴얼</div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-097\" target=\"_blank\">PL-2025-097</a></span>\n<span class=\"task-owner\">기계팀</span>\n<div>로봇 백그라이트 부착</div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-141\" target=\"_blank\">PL-2025-141</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>SMB 배터리 관리</div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-147\" target=\"_blank\">PL-2025-147</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>계측 도중 X축 범위 확인</div>\n</div>\n"
        },
        {
          "dayName": "토 (완료)",
          "date": "2/7",
          "weekClass": "w3",
          "taskCount": "최종일",
          "contentHtml": "\n<div class=\"day-task-item low\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-093\" target=\"_blank\">PL-2025-093</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>매뉴얼 (계속)</div>\n</div>\n<div class=\"day-task-item low\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-103\" target=\"_blank\">PL-2025-103</a></span>\n<span class=\"task-owner\">기계팀</span>\n<div>겐트리 호기 구분 명판</div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-153\" target=\"_blank\">PL-2025-153</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>십자 레이저 기반 갠트리 원점</div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-156\" target=\"_blank\">PL-2025-156</a></span>\n<span class=\"task-owner\">제어팀</span>\n<div>경광등-UI-관제 동기화</div>\n</div>\n 1/21 신규 추가 - 보통 우선순위 6건 \n<div style=\"margin:10px 0 5px;padding:8px 10px;background:rgba(155,89,182,0.15);border-radius:6px;border-left:3px solid #9b59b6;\">\n<strong style=\"color:#9b59b6;\">🆕 1/21 신규 추가 (보통 6건)</strong>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(155,89,182,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-170\" style=\"color:#9b59b6;\" target=\"_blank\">PL-2026-170</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>갠트리 조깅 기능</div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(155,89,182,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-172\" style=\"color:#9b59b6;\" target=\"_blank\">PL-2026-172</a></span>\n<span class=\"task-owner\">최광년</span>\n<div>노즐 클리닝/스프레이 기능</div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(155,89,182,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-173\" style=\"color:#9b59b6;\" target=\"_blank\">PL-2026-173</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>노즐 클리닝/스프레이 수동 티칭</div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(155,89,182,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-175\" style=\"color:#9b59b6;\" target=\"_blank\">PL-2026-175</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>체크한 포인트만 용접</div>\n</div>\n<div class=\"day-task-item normal\" style=\"background:rgba(155,89,182,0.1);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-178\" style=\"color:#9b59b6;\" target=\"_blank\">PL-2026-178</a></span>\n<span class=\"task-owner\">최광년</span>\n<div>터치 보정 필터링</div>\n</div>\n<div class=\"day-task-item completed\" style=\"background:rgba(5,150,105,0.15);\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-181\" style=\"color:#059669;\" target=\"_blank\">PL-2026-181 ✓</a></span>\n<span class=\"task-owner\">황민철</span>\n<div>노즐 클리너 용액 누수 (완료)</div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-owner\">전체</span>\n<div>전체 완료 점검 및 인수인계</div>\n</div>\n",
          "cardStyle": "border: 2px solid #059669;",
          "headerStyle": "background: rgba(5,150,105,0.2);",
          "taskCountStyle": "background:#059669;color:#fff;"
        },
        {
          "dayName": "일",
          "date": "2/8",
          "weekClass": "w4",
          "taskCount": "배포7+진행4",
          "contentHtml": "\n<div style=\"font-size:0.7rem;color:#059669;font-weight:bold;padding:4px 8px;background:#ecfdf5;border-radius:4px;margin-bottom:4px;\">📦 배포 예정 (7건)</div>\n<div class=\"day-task-item\" style=\"background:#dcfce7;border-left:3px solid #059669;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-084\" target=\"_blank\">PL-2025-084</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>📦 PLC 알람 체크 → 배포</div>\n</div>\n<div class=\"day-task-item\" style=\"background:#dcfce7;border-left:3px solid #059669;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-061\" target=\"_blank\">PL-2025-061</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>📦 알람처리 (팬던트&gt;UI&gt;관제) → 배포</div>\n</div>\n<div class=\"day-task-item\" style=\"background:#dcfce7;border-left:3px solid #059669;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-067\" target=\"_blank\">PL-2025-067</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>📦 공압/가스 알람처리(UI) → 배포</div>\n</div>\n<div class=\"day-task-item\" style=\"background:#dcfce7;border-left:3px solid #059669;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-196\" target=\"_blank\">PL-2026-196</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>📦 커스텀 팝업 → 컨펌배포</div>\n</div>\n<div class=\"day-task-item\" style=\"background:#dbeafe;border-left:3px solid #3b82f6;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-039\" target=\"_blank\">PL-2025-039</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>📦 불스아이 스프레이 LOW → 컨펌배포</div>\n</div>\n<div class=\"day-task-item\" style=\"background:#dbeafe;border-left:3px solid #3b82f6;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-096\" target=\"_blank\">PL-2025-096</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>📦 용접선 유효선 검사 → 컨펌배포</div>\n</div>\n<div class=\"day-task-item\" style=\"background:#dbeafe;border-left:3px solid #3b82f6;\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-177\" target=\"_blank\">PL-2026-177</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>📦 터치/아크에러 로봇 초기화 → 컨펌배포</div>\n</div>\n<div style=\"font-size:0.7rem;color:#3b82f6;font-weight:bold;padding:4px 8px;background:#dbeafe;border-radius:4px;margin:4px 0;\">🔧 진행 예정 (4건)</div>\n<div class=\"day-task-item high\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-171\" target=\"_blank\">PL-2026-171</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>🔧 와이어 커팅 수동 티칭 (개발중)</div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-191\" target=\"_blank\">PL-2026-191</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>📦 웜업 UI 가시성 개선 → 컨펌배포</div>\n</div>\n<div class=\"day-task-item high\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2025-023\" target=\"_blank\">PL-2025-023</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>🧪 용접 활성화 확인 (테스트)</div>\n</div>\n<div class=\"day-task-item normal\">\n<span class=\"task-id\"><a href=\"https://s2501602.vercel.app/punchlist/pages/detail.html?id=PL-2026-170\" target=\"_blank\">PL-2026-170</a></span>\n<span class=\"task-owner\">박주한</span>\n<div>🧪 갠트리 조깅 기능 (테스트)</div>\n</div>\n"
        }
      ]
    }
  ],
  "issueNames": {
    "008": "블스아이 용접토치 스프레이",
    "020": "A라인 수직용접",
    "021": "사용자 편의성 UI 개선",
    "022": "커스텀 팝업",
    "023": "로봇 자동 운전 조건 진단",
    "026": "컨트롤러 보전용 발판",
    "027": "IN/OUT 차광막 설치",
    "030": "자율안전신고서 서류준비",
    "032": "토치 케이블 처짐 방지",
    "033": "로봇 전원 케이블 타입",
    "034": "릴, 피더기 위치 상향",
    "035": "블스아이 위치 확정",
    "036": "거더 상향 조정",
    "039": "불스아이 스프레이 LOW 경고",
    "040": "레이저 커튼 보완",
    "048": "Plan B 로봇 시스템 재구성",
    "055": "B라인 드라이런 속도 배율",
    "060": "시뮬레이션 vs 실제 알람",
    "061": "알람 전달",
    "062": "갠트리 수동 이동 시 동적 리미트",
    "065": "실시간 용접 조건 변경",
    "067": "가스유량 알람처리",
    "069": "RAPID 자동 상태 확인 에러",
    "074": "인셉션 에러 세분화",
    "080": "아크 에러 시 RAPID 제어",
    "083": "X축 하드 리밋 무시 결선",
    "084": "PLC 알람 체크",
    "088": "작업자/관리자 권한 설정",
    "089": "돌림 용접 구간 개별 옵셋",
    "091": "수동 용접시 기능 추가",
    "092": "A라인 수직용접 터치 옵셋",
    "093": "운영 S/W 최종 매뉴얼",
    "096": "B라인 용접 불가 반환",
    "097": "로봇 절연처리 (백그라이트, 절연볼트)",
    "099": "UI 조작 로깅",
    "100": "터치 모션 파라미터 X_init",
    "103": "겐트리 호기 구분 명판",
    "104": "작업자 사용 이력 로그",
    "105": "로봇/UI 통신 단절",
    "106": "UI-관제 통신 주기 / 디지털트윈",
    "109": "Weld-Robot LAN Cable",
    "111": "형상 보간 실패 에러 원인",
    "113": "Z축 과부하 에러 / 웜업",
    "115": "B라인 앵글 회피 거리",
    "116": "노즐 클리닝 티칭",
    "117": "스프레이 티칭 기능",
    "121": "시작점 터치 TCP 오프셋",
    "124": "디바이스넷 통신 상실",
    "126": "작업 취소 시 속도 0% 문제",
    "131": "PC 전원 인가 방법",
    "132": "A라인 계측 홈 / 기본 Z홈 구분",
    "138": "B라인 터치 보정 에러",
    "139": "B라인 로봇 동작 이상현상",
    "141": "SMB 배터리 관리",
    "142": "B라인 BullsEye 설치/모션",
    "143": "용접 가능 범위 제한",
    "146": "TCP 위치 기반 커맨드 판단",
    "147": "계측 도중 X축 범위 확인",
    "148": "갠트리 이동 가능 범위 변수화",
    "149": "용접기 복원 매뉴얼 작성",
    "150": "와이어 교체 모드 피딩기능",
    "151": "Z홈 모션 기본 모드",
    "152": "LDS 센서 기반 원점 인식",
    "153": "십자 레이저 기반 갠트리 원점",
    "154": "명령 취소 시 rInit 동작",
    "155": "홀 센서 기반 원점 인식",
    "156": "경광등-UI-관제 동기화",
    "157": "터치 오프셋 일괄 변경",
    "165": "용접 포인트 부재 두깨 반영",
    "166": "경광등 스위치 추가",
    "167": "B라인 센서 명판 부착",
    "168": "불스아이 결선",
    "169": "한팔용접 (1xx 매크로)",
    "170": "갠트리 조깅 기능",
    "171": "와이어 커팅 수동 티칭",
    "172": "노즐 클리닝/스프레이 기능",
    "173": "노즐 클리닝/스프레이 수동 티칭",
    "175": "체크한 포인트만 용접",
    "176": "터치 끝 점 리트라이 수정",
    "177": "터치/아크에러 후 로봇 초기화",
    "178": "터치 보정 필터링",
    "179": "매크로 미선택 시 용접데이터",
    "180": "매크로 미선택 시 용접데이터(2)",
    "181": "노즐 클리너 용액 누수"
  },
  "year2026Ids": [
    "165",
    "166",
    "167",
    "168",
    "169",
    "170",
    "171",
    "172",
    "173",
    "175",
    "176",
    "177",
    "178",
    "179",
    "180",
    "181"
  ],
  "bLineNames": {
    "1": "디지털 트윈 (Lag 이슈 확인)",
    "2": "비정상 용접선 정보 필터링",
    "3": "명령 유형 별 기초 데드라인",
    "4": "명령에 대한 상세 에러 구성",
    "5": "공압, CO2, 냉각수 유량 범위",
    "6": "관제 측 이동 시 DB 상/하한선",
    "7": "갠트리 수동 이동 시 동적 리미트",
    "8": "기본 Z홈 선택",
    "9": "와이어 인칭 시그널 개별 제어",
    "10": "토크 축 가독/가시성 향상",
    "11": "알람 전달",
    "12": "웜업",
    "13": "홀센서 기반 원점 인식",
    "14": "커스텀 팝업"
  },
  "bLineIdMapping": {
    "1": "PL-2025-106",
    "2": "PL-2025-096",
    "4": "PL-2025-074",
    "5": "PL-2025-067",
    "7": "PL-2025-062",
    "8": "PL-2025-132",
    "11": "PL-2025-061",
    "12": "PL-2025-113",
    "13": "PL-2025-155",
    "14": "PL-2025-022"
  },
  "footer": {
    "line1": "S25016 프로젝트 3주 완료 계획 일정표 (Full Version)",
    "line2": "기간: 2026.01.19 ~ 2026.02.14 (27일) | 담당: SP 심태양"
  }
};

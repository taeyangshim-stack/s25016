# Hexagon 측정 프로젝트

## 개요

로봇 정밀도 검증 프로젝트 (Hexagon 측정 시스템)

- 프로젝트 코드: S25016
- 측정 시스템: Hexagon
- 목적: 로봇 정밀도 검증

## 폴더 구조

```
hexagon/
├── index.html              # 메인 대시보드
├── robot-accuracy.html     # 로봇 정밀도 측정
├── schedule.html           # 일정 관리
├── punchlist.html          # 펀치리스트
└── README.md              (이 파일)
```

## 사용법

### 로컬 서버 실행
```bash
python3 -m http.server 8000
```

브라우저: http://localhost:8000/projects/hexagon/

## 관련 프로젝트

- [상하축 이슈](../robot-vertical-axis/) - 로봇 간섭 문제
- [ROBOT↔UI 테스트](../robot-ui-integration-test/) - UI 통합 테스트
- [근무관리](../work-management/) - 현장 출입 기록

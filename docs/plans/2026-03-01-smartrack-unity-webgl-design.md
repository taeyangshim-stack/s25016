# SmartRack Unity WebGL 물류 흐름 시뮬레이션 설계

**날짜:** 2026-03-01
**프로젝트:** s25016 / SmartRack
**대상:** Slide 07 물류 흐름 — Three.js → Unity WebGL 재현

---

## 목표

슬라이드 07의 Three.js 물류 흐름 애니메이션을 Unity WebGL로 재현.
단계별 버튼 제어 + 한국어 UI 라벨 포함. 로컬 확인 후 iframe 임베드 예정.

---

## 결정 사항

| 항목 | 결정 |
|------|------|
| 배포 방식 | 로컬 우선, 추후 iframe 임베드 |
| 인터랙션 | 단계별 버튼 제어 (이전/다음) |
| 비주얼 | 미니멀 + UI 텍스트/라벨 |
| 구현 방식 | C# 스크립트 + Unity MCP |

---

## 씬 구성

```
SmartRack Scene (SampleScene)
├── Environment
│   ├── DirectionalLight
│   ├── Floor (바닥 평면)
│   └── Grid (시각적 그리드)
├── Factory
│   ├── Conveyor (컨베이어 — 주황)
│   ├── ScanGate (스캔게이트 — 파랑 + 사이언 이펙트)
│   ├── RackSystem (8×3 랙 슬롯 — 회색)
│   ├── StackerCrane (크레인 — 은색)
│   └── AMR (자율이동로봇 — 보라)
├── Part (이송 부품 — 황색)
├── UI Canvas
│   ├── StepTitle
│   ├── StepDescription
│   ├── PrevButton
│   ├── NextButton
│   └── StepIndicator (1-2-3-4-5)
└── CameraRig (등각 뷰, OrthographicCamera)
```

---

## 5단계 흐름

| 단계 | 제목 | 설명 | 핵심 동작 |
|------|------|------|----------|
| 1 | 입고 | 부품이 컨베이어에 진입합니다 | Part → 컨베이어 위 이동 |
| 2 | 3D 스캔 | AI가 형상을 인식합니다 | 스캔게이트 통과, 사이언 플래시 |
| 3 | 크레인 이송 | 스태커크레인이 부품을 이송합니다 | Crane X이동 + Part 픽업 |
| 4 | 적치 완료 | 최적 슬롯에 보관됩니다 | Part → 랙 슬롯 배치 |
| 5 | 출고 | AMR이 부품을 출고합니다 | AMR 접근 → Part 픽업 → 출고 |

---

## C# 스크립트 구조

```
Assets/Scripts/
├── SmartRackSimulation.cs   # 메인 시뮬레이션 컨트롤러
├── StepAnimator.cs          # 각 단계별 애니메이션 코루틴
├── UIController.cs          # 버튼/텍스트 UI 관리
└── CameraController.cs      # 등각 카메라 설정
```

### SmartRackSimulation.cs 역할
- 현재 단계(currentStep) 관리
- Next/Prev 버튼 이벤트 수신
- StepAnimator 코루틴 호출
- UI 텍스트 업데이트

---

## 시각 스타일

- **배경색:** #0D1526 (다크 네이비)
- **바닥:** 어두운 회색 평면 + 그리드 라인
- **조명:** Directional (주) + Ambient (보조)
- **카메라:** Orthographic, 45° 등각 뷰
- **UI 폰트:** 한국어 지원 폰트 (NotoSansKR)

### 오브젝트 컬러
| 오브젝트 | 색상 |
|---------|------|
| 컨베이어 | #F97316 (주황) |
| 스캔게이트 | #3B82F6 (파랑) |
| 스캔 이펙트 | #06B6D4 (사이언) |
| 랙 | #374151 (다크 회색) |
| 크레인 | #9CA3AF (실버) |
| AMR | #7C3AED (보라) |
| 부품 | #F59E0B (황색) |

---

## 구현 순서

1. C# 스크립트 파일 작성 (4개)
2. Unity MCP로 씬 오브젝트 생성 및 배치
3. 스크립트 컴포넌트 연결
4. UI Canvas 구성
5. WebGL 빌드 설정 및 빌드
6. 로컬 테스트

---

## 이후 계획

- 로컬 확인 후 피드백 반영
- Cloudinary 또는 별도 CDN에 빌드 업로드
- smartrack/index.html 슬라이드 07에 iframe 임베드

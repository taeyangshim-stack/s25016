# DeviceNet 통신 프로젝트

## 개요

Lincoln Electric Power Wave 용접기 DeviceNet 인터페이스 통신 구현

- 프로젝트 코드: S25016
- 용접기: Lincoln Electric Power Wave
- 통신 프로토콜: DeviceNet
- 신호 개수: 158개 (입력/출력)
- 현장: 34bay 자동용접 A라인/B라인

## 폴더 구조

```
devicenet/
├── index.html              # 통신 문제 해결 진행 현황 대시보드
├── signals.html            # DeviceNet 신호 테이블 (158개 신호)
├── docs/                   # 문서 및 체크리스트
│   ├── ABB_Lincoln_DeviceNet_체크리스트.html
│   ├── 251009_아크불량_체크리스트.html
│   ├── 251009_예상원인점검_이더넷통신.html
│   └── 251009_작업진행_세부내용.html
├── specs/                  # 사양서
│   └── Y50031_DeviceNetInterfaceSpecification-21.pdf (76 pages)
├── images/                 # 구성도 및 이미지
│   ├── A라인구성.jpg
│   ├── B라인구성.jpg
│   ├── 251009_구성_x5직결_LAN_LAN3.jpg
│   ├── 251009_구성_허브단열_LAN_LAN3.jpg
│   ├── 251009_구성_허브복열_LAN_LAN3.jpg
│   ├── 251009_케이블_덕트분리.jpg
│   └── 디바이스넷관련우리웰텍섯업방법공유.jpg
└── README.md              (이 파일)
```

## DeviceNet 신호 테이블

### 총 158개 신호

**출력 신호 (로봇 → 용접기)**: 79개
- Weld Enable
- Wire Feed Enable
- Gas Enable
- Inch Forward/Reverse
- Weld Schedule Selection
- 기타 제어 신호

**입력 신호 (용접기 → 로봇)**: 79개
- Weld Ready
- Arc On
- Wire Feed Speed
- Weld Current
- Weld Voltage
- 기타 상태 신호

### 주요 신호 그룹

1. **Weld Control** (용접 제어)
   - Weld Enable
   - Arc On
   - Gas Enable

2. **Wire Feed** (와이어 송급)
   - Wire Feed Enable
   - Wire Feed Speed
   - Inch Forward/Reverse

3. **Process Parameters** (공정 파라미터)
   - Weld Current
   - Weld Voltage
   - Wire Feed Speed

4. **Status Signals** (상태 신호)
   - Ready
   - Fault
   - Warning

5. **Schedule Selection** (스케줄 선택)
   - Schedule A-Z
   - Process Selection

## 주요 문서

### 대시보드
- **진행 현황**: [index.html](index.html) - 통신 문제 해결 진행 현황

### 신호 테이블
- **전체 신호**: [signals.html](signals.html) - 158개 DeviceNet 신호 상세 정보

### 체크리스트
- **ABB-Lincoln 통합**: [ABB_Lincoln_DeviceNet_체크리스트.html](docs/ABB_Lincoln_DeviceNet_체크리스트.html)
- **아크 불량**: [251009_아크불량_체크리스트.html](docs/251009_아크불량_체크리스트.html)

### 문제 해결
- **이더넷 통신**: [251009_예상원인점검_이더넷통신.html](docs/251009_예상원인점검_이더넷통신.html)
- **작업 진행**: [251009_작업진행_세부내용.html](docs/251009_작업진행_세부내용.html)

### 사양서
- **공식 문서**: [Y50031_DeviceNetInterfaceSpecification-21.pdf](specs/Y50031_DeviceNetInterfaceSpecification-21.pdf) (76 pages)

## 통신 문제 해결 이력

### 2024-10-09: 이더넷 통신 점검
- 허브 구성 변경 (단열 → 복열)
- X5 직결 방식 테스트
- 케이블 덕트 분리 점검

### 주요 이슈
1. **네트워크 간섭**
   - 증상: 간헐적 통신 끊김
   - 대책: 허브 구성 변경, 케이블 분리

2. **아크 불량**
   - 증상: 용접 아크 불안정
   - 대책: 공정 파라미터 조정

3. **신호 매핑**
   - 증상: 일부 신호 미동작
   - 대책: DeviceNet 신호 테이블 재검증

## 네트워크 구성

### A라인 구성
- ABB 로봇 컨트롤러
- DeviceNet Master
- Lincoln Power Wave (Slave)
- Ethernet 허브

### B라인 구성
- ABB 로봇 컨트롤러
- DeviceNet Master
- Lincoln Power Wave (Slave)
- Ethernet 허브

### 테스트 구성안
1. **X5 직결 방식**: 허브 없이 직접 연결
2. **허브 단열 방식**: 허브 사용, 단일 LAN
3. **허브 복열 방식**: 허브 사용, LAN 분리

## 사용법

### 로컬 서버 실행
```bash
python3 -m http.server 8000
```

브라우저: http://localhost:8000/projects/devicenet/

### 신호 테이블 검색
1. `signals.html` 열기
2. 브라우저 검색 기능 (Ctrl+F) 사용
3. 신호 이름 또는 번호로 검색

### 사양서 참조
1. `specs/Y50031_DeviceNetInterfaceSpecification-21.pdf` 열기
2. 76페이지 전체 사양 확인
3. 신호별 상세 설명 참조

## 관련 프로젝트

- [상하축 이슈](../robot-vertical-axis/) - 로봇 간섭 문제
- [ROBOT↔UI 테스트](../robot-ui-integration-test/) - UI 통합 테스트
- [에러 핸들링](../error-handling/) - 에러 처리 가이드
- [근무관리](../work-management/) - 현장 출입 기록

## 기술 사양

**DeviceNet 통신**:
- 프로토콜: CAN-based DeviceNet
- Baud Rate: 125kbps / 250kbps / 500kbps
- Topology: Trunk-line / Drop-line
- Max Nodes: 64
- Max Cable Length: 500m (125kbps)

**Lincoln Electric Power Wave**:
- Model: Power Wave (DeviceNet Interface)
- Signals: 158개 (입력 79, 출력 79)
- Interface: Y50031 DeviceNet Card
- Control: Digital I/O + Analog

**ABB Robot**:
- DeviceNet Master 기능
- Real-time I/O 처리
- RAPID 프로그래밍 연동

## 개발 이력

- 2024-10-03: DeviceNet 신호 테이블 작성 (158개)
- 2024-10-09: 통신 문제 진단 및 해결 시작
- 2024-10-09: 이더넷 통신 점검
- 2024-10-09: 아크 불량 체크리스트 작성
- 2024-10-10: 프로젝트 구조 리팩토링

## 참고 자료

- Lincoln Electric DeviceNet 매뉴얼
- ABB DeviceNet Master 설정 가이드
- 우리웰텍 셋업 방법 공유 자료

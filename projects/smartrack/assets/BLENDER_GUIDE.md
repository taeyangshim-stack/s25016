# Blender 3D 스마트랙 공장 시각화 가이드 v2.0

> 완성된 MP4를 `projects/smartrack/assets/logistics-3d.mp4` 경로에 배치하면 발표 슬라이드에 자동으로 표시됩니다.

---

## 씬 구성 개요 — 2구역 분리 배치

```
┌──────────────────┬─────────────┬──────────────────────────┐
│   Zone A: 선별장  │  AMR 이송   │  Zone B: 스태커크레인+랙장  │
│  (선별갠트리)     │  복도(3m)   │  (자동창고)                │
│                  │  ←→ AMR    │                           │
│  X: -20 ~ -8    │  X: -8~-5   │  X: -4 ~ +18             │
└──────────────────┴─────────────┴──────────────────────────┘
```

### 카메라
- **뷰**: Isometric (Orthographic), 45° 내려다보기
- **위치**: X=0, Y=-25, Z=20 → Look At: X=0, Y=0, Z=0
- **렌더 배율**: Orthographic Scale = 22 (전체 공장이 한 프레임에)

### 바닥 (Floor)
- 크기: **46m × 20m** (Zone A + 복도 + Zone B)
- 재질: 짙은 네이비 (#1A2536), 그리드 오버레이 (불투명도 0.3)

---

## Zone A — 선별장 (Sorting Area)

> 소부재가 입고되어 3D 스캔 후 선별갠트리가 종류별로 분류·적재

| 오브젝트 | 위치 (X) | 크기 | 색상 |
|---------|----------|------|------|
| 입고 컨베이어 | X = -18 | 12m × 1.2m | 호박색 #D97706 |
| 3D 스캔 게이트 | X = -14 | 2m × 2.5m × 3m | 청록 #38BDF8 |
| 선별갠트리 브리지 | X = -18~-8, Z = 4m | 10m 스팬 | 스틸 #CBD5E1 |
| 선별갠트리 호이스트 | 갠트리 하부 | 0.6m × 0.6m × 0.8m | 주황 #EA580C |
| 소부재 임시 대기존 | X = -11 | 3×2 배열 | 호박색 박스 |

### 선별갠트리 동작
- **브리지**: X축 왕복 이동 (입고 컨베이어 ↔ 대기존)
- **호이스트**: Z축 상하 + 마그넷 픽업 시뮬레이션
- **속도**: 실제 갠트리 속도 1/5 스케일 (3초 편도)

---

## Zone B — 스태커크레인 & 랙장 (AS/RS)

> AMR이 가져온 1.5t 파렛트를 스태커크레인이 받아 자동 적재

| 오브젝트 | 위치 (X) | 크기 | 색상 |
|---------|----------|------|------|
| 랙 구조물 | X = -2~+16 | 8열×5단 | 다크 그레이 #374151 |
| 스태커크레인 마스트 | X: 레일 따라 이동 | 높이 6m | 스틸 #CBD5E1 |
| 스태커크레인 포크 | 마스트 하부 | 1.8m × 1.2m | 실버 #94A3B8 |
| 파렛트 수령 스테이션 | X = -3, Y = 0 | 2m × 1.5m | 노랑 #FBBF24 |

### 랙 구조 상세
- **열 수**: 8열 (좌우 4열 × 양면)
- **단 수**: 5단 (지상~5.5m)
- **피치**: 열 간격 2.2m, 단 높이 1.1m
- **파렛트 슬롯**: 80개

---

## AMR 이송 구간 — 1.5t 파렛트 운반

> Zone A 선별 완료 소부재 → 파렛트 적재 → AMR 이송 → Zone B 수령 스테이션

### AMR 사양 (시각화)
| 항목 | 값 |
|------|----|
| 크기 | 1.8m × 1.2m × 0.35m |
| 파렛트 탑재 높이 | 0.35m (AMR 바닥) + 0.15m (파렛트) |
| 적재 중량 | **1.5ton** (파렛트 포함) |
| 재질 | 진한 파랑 #1D4ED8, 상단 안전등 #F59E0B |
| 안전 경고등 | 주황 점멸 (2Hz, 이동 시) |

### AMR 이송 경로
```
선별장 적재존 (X=-9, Y=0)
      ↓  직선 이동 (복도 3m)
Zone B 수령 스테이션 (X=-3, Y=0)
      ↓  파렛트 하역
스태커크레인 픽업
      ↓
랙 적재 완료
      ↑
AMR 빈 상태 복귀 (Y=3 우회 경로)
```

### 바닥 마킹
- **노란 실선**: AMR 전진 경로 (폭 0.3m)
- **점선**: AMR 복귀 경로 (Y+3 오프셋)
- **적색 정지선**: Zone A/B 경계 (X = -5.5)

---

## 애니메이션 시퀀스 (20초 루프)

| 시간 | 이벤트 | 오브젝트 |
|------|--------|---------|
| 0 – 2s | 소부재 컨베이어 진입 | 황색 박스 |
| 2 – 4s | 스캔 게이트 통과 (청록 광선) | 스캔 플레인 |
| 4 – 7s | 선별갠트리 픽업 → 대기존 이동 | 갠트리 + 박스 |
| 7 – 9s | 파렛트 위에 소부재 적재 완료 | 파렛트 + 박스 |
| 9 – 12s | **AMR 전진 이동** (1.5t 파렛트 탑재) | AMR + 파렛트 |
| 12 – 13s | AMR 수령 스테이션 정지, 파렛트 하역 | AMR |
| 13 – 17s | 스태커크레인 픽업 → 랙 이동 → 적재 | 크레인 + 파렛트 |
| 17 – 19s | AMR 빈 상태로 복귀 | AMR (Y+3 경로) |
| 19 – 20s | 전체 조감 카메라 + 루프 | 카메라 |

---

## Blender Python 스크립트 — 씬 자동 생성

아래 스크립트를 Blender Text Editor에서 실행하면 기본 씬이 자동 생성됩니다.

```python
import bpy
import mathutils

# 초기화
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete()

def make_box(name, loc, size, color_hex):
    r = int(color_hex[1:3], 16) / 255
    g = int(color_hex[3:5], 16) / 255
    b = int(color_hex[5:7], 16) / 255
    bpy.ops.mesh.primitive_cube_add(location=loc)
    obj = bpy.context.active_object
    obj.name = name
    obj.scale = (size[0]/2, size[1]/2, size[2]/2)
    mat = bpy.data.materials.new(name=name + "_mat")
    mat.use_nodes = True
    mat.node_tree.nodes["Principled BSDF"].inputs[0].default_value = (r, g, b, 1)
    obj.data.materials.append(mat)
    return obj

# ── 바닥
make_box("Floor", (0, 0, -0.05), (46, 20, 0.1), "#1A2536")

# ── Zone A: 선별장
make_box("Conveyor_Input",   (-18, 0, 0.4),  (12, 1.2, 0.8),  "#D97706")
make_box("Scan_Gate",        (-14, 0, 1.5),  (0.3, 2.5, 3.0), "#38BDF8")
make_box("Sorting_Bridge",   (-13, 0, 4.0),  (10, 0.4, 0.4),  "#CBD5E1")
make_box("Sorting_Hoist",    (-18, 0, 3.5),  (0.6, 0.6, 0.8), "#EA580C")

# 소부재 대기존 (6개)
for i in range(3):
    for j in range(2):
        make_box(f"Part_Wait_{i}_{j}",
                 (-11 + i*1.5, -1 + j*1.2, 0.34),
                 (1.0, 0.9, 0.68), "#D97706")

# ── 파렛트 적재존 (Zone A 출구)
make_box("Pallet_A_Zone", (-9, 0, 0.1), (1.8, 1.2, 0.15), "#FBBF24")

# ── AMR
amr = make_box("AMR", (-9, 0, 0.175), (1.8, 1.2, 0.35), "#1D4ED8")
make_box("AMR_Pallet", (-9, 0, 0.5), (1.8, 1.2, 0.15), "#FBBF24")
make_box("AMR_SafetyLight", (-9, 0, 0.38), (0.4, 1.2, 0.05), "#F59E0B")

# ── Zone B: 수령 스테이션
make_box("Receive_Station", (-3, 0, 0.1), (2.0, 1.5, 0.2), "#FBBF24")

# ── 스태커크레인 마스트
make_box("SC_Mast",  (0, 0, 3.0),  (0.3, 0.3, 6.0),  "#CBD5E1")
make_box("SC_Fork",  (0, 0, 0.5),  (1.8, 1.2, 0.1),  "#94A3B8")
make_box("SC_Bridge",(7, 0, 6.2),  (18, 0.3, 0.3),   "#CBD5E1")

# ── 랙 (8열×5단)
for col in range(8):
    for row in range(5):
        x = -1 + col * 2.2
        z = 0.6 + row * 1.1
        make_box(f"Rack_{col}_{row}", (x, 1.5, z), (2.0, 0.1, 1.0), "#374151")
        make_box(f"Rack_{col}_{row}_B", (x, -1.5, z), (2.0, 0.1, 1.0), "#374151")

# ── 경계선 (AMR 복도)
make_box("Boundary_A", (-5.5, 0, 0.01), (0.05, 20, 0.02), "#EF4444")

print("씬 생성 완료! AMR 이송 경로 및 두 구역 배치 확인하세요.")
```

---

## 애니메이션 키프레임 설정 (Python)

```python
# AMR 이송 애니메이션 (프레임 기준 30fps)
amr = bpy.data.objects["AMR"]
pallet = bpy.data.objects["AMR_Pallet"]

# Zone A 대기 (0~270프레임 = 9초)
amr.location = (-9, 0, 0.175)
amr.keyframe_insert(data_path="location", frame=1)
pallet.keyframe_insert(data_path="location", frame=1)

# Zone B 도착 (9초~12초 = 270~360프레임)
amr.location = (-3, 0, 0.175)
amr.keyframe_insert(data_path="location", frame=360)
pallet.location = (-3, 0, 0.5)
pallet.keyframe_insert(data_path="location", frame=360)

# 파렛트 하역 (12초 = 360프레임)
pallet.location = (-3, 0, 0.175)  # AMR에서 분리, 스테이션에 안착
pallet.keyframe_insert(data_path="location", frame=390)

# AMR 복귀 (17~19초 = 510~570프레임) — Y+3 우회
amr.location = (-3, 3, 0.175)
amr.keyframe_insert(data_path="location", frame=420)
amr.location = (-9, 3, 0.175)
amr.keyframe_insert(data_path="location", frame=510)
amr.location = (-9, 0, 0.175)
amr.keyframe_insert(data_path="location", frame=570)

# 보간 방식: BEZIER → LINEAR로 변경 (로봇 느낌)
for fc in amr.animation_data.action.fcurves:
    for kp in fc.keyframe_points:
        kp.interpolation = 'LINEAR'
```

---

## 렌더링 설정

```
엔진: EEVEE (프레젠테이션용 빠른 렌더)
해상도: 1920 × 1080 (16:9)
FPS: 30
총 프레임: 600 (20초 루프)
출력 포맷: MP4 / H.264 / CRF 20
배경색: #0D1526
Bloom: ON (스캔 게이트 글로우 효과)
Ambient Occlusion: ON
```

---

## 완성 후 배치

```bash
cp ~/render/logistics-3d.mp4 \
  /path/to/s25016/projects/smartrack/assets/logistics-3d.mp4

# 로컬 확인
python3 -m http.server 8000
# http://localhost:8000/projects/smartrack/
```

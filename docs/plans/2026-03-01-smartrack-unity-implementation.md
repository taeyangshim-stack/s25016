# SmartRack Unity WebGL 구현 계획

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** SmartRack 슬라이드 07 물류 흐름을 Unity WebGL로 재현 — 5단계 버튼 제어 + 한국어 UI

**Architecture:** Unity MCP로 씬 오브젝트를 생성/배치하고, C# 스크립트 파일을 직접 작성해 컴포넌트로 연결. UI Canvas는 Unity uGUI 사용. WebGL 빌드 후 로컬 테스트.

**Tech Stack:** Unity 6 (URP), C#, Unity MCP (mcp-unity), uGUI

**Unity Project:** `/home/qwe/Unity/Project/SmartRack3D`
**Scripts Path:** `Assets/Scripts/`
**Build Output:** `Assets/../Builds/WebGL/`

---

## Task 1: 씬 초기화 및 환경 오브젝트 생성

**Files:**
- Unity Scene: `Assets/Scenes/SampleScene.unity` (기존 씬 사용)

**Step 1: 기존 씬 오브젝트 확인**

Unity MCP `get_scene_info` 실행 → 기존 오브젝트 목록 확인

**Step 2: 카메라 등각 뷰 설정**

`update_component`로 Main Camera를 Orthographic으로 변경:
- Projection: Orthographic
- Size: 8
- Position: (10, 12, -10)
- Rotation: (45, -45, 0)
- Clear Flags: Solid Color → Background: #0D1526

**Step 3: 조명 설정**

Directional Light 업데이트:
- Rotation: (50, -30, 0)
- Intensity: 1.0
- Color: white

`update_gameobject`로 Ambient Light 추가:
- Color: #1a2a3a (다크 블루)

**Step 4: 바닥 생성**

GameObject `Floor` 생성:
- Mesh: Plane (34×26 스케일)
- Position: (0, 0, 0)
- Material color: #1a1f2e

**Step 5: 씬 저장**

Unity MCP `save_scene` 실행

**Step 6: Commit**
```bash
# (씬은 Unity에서 저장, Git 커밋은 선택)
git add -A && git commit -m "feat(unity): 씬 환경 초기화 — 카메라/조명/바닥"
```

---

## Task 2: 공장 오브젝트 생성 (컨베이어, 스캔게이트, 랙)

**Files:**
- Unity Scene: `Assets/Scenes/SampleScene.unity`

**Step 1: Factory 부모 오브젝트 생성**

```
GameObject "Factory" at (0, 0, 0)
```

**Step 2: 컨베이어 생성**

GameObject `Conveyor` (Factory 하위):
- Mesh: Cube, Scale: (4, 0.2, 2)
- Position: (-10, 0.1, 0)
- Color: #F97316 (주황)

롤러 3개 (Cylinder):
- Scale: (0.3, 0.3, 2.1), 각각 X=-11, -10, -9

**Step 3: 스캔게이트 생성**

GameObject `ScanGate` (Factory 하위):
- 프레임 좌: Cube Scale(0.2, 3, 0.2) Position(-6.5, 1.5, -1)
- 프레임 우: Cube Scale(0.2, 3, 0.2) Position(-6.5, 1.5, 1)
- 프레임 상: Cube Scale(0.2, 0.2, 2.2) Position(-6.5, 3, 0)
- Color: #3B82F6 (파랑)
- ScanPlane: Quad Scale(0.1, 2.8, 2) Position(-6.5, 1.5, 0) Color: #06B6D4 투명도 0.4

**Step 4: 랙 시스템 생성**

GameObject `RackSystem` (Factory 하위) Position(2, 0, 0):
- 8열 × 3행 = 24개 슬롯
- 각 슬롯: Cube Scale(1.2, 0.9, 1.2)
- Color: #374151 (다크 회색)
- 간격: X방향 1.4, Y방향 1.0

**Step 5: 레일 생성**

Rail_L: Cube Scale(20, 0.1, 0.1) Position(0, 0.5, -1.2) Color: #6B7280
Rail_R: Cube Scale(20, 0.1, 0.1) Position(0, 0.5, 1.2) Color: #6B7280

**Step 6: 씬 저장 후 확인**

Unity MCP `save_scene` → Unity Editor에서 시각 확인

---

## Task 3: 이동 오브젝트 생성 (크레인, AMR, 부품)

**Files:**
- Unity Scene: `Assets/Scenes/SampleScene.unity`

**Step 1: 스태커크레인 생성**

GameObject `StackerCrane` Position(-10, 0, 0):
- Column: Cube Scale(0.3, 4, 0.3) Position(0, 2, 0) Color: #9CA3AF
- Beam: Cube Scale(0.8, 0.2, 0.2) Position(0, 3.5, 0) Color: #9CA3AF
- Fork: Cube Scale(0.6, 0.1, 0.8) Position(0, 3.3, 0) Color: #D1D5DB

**Step 2: AMR 생성**

GameObject `AMR` Position(8, 0.15, 4):
- Body: Cube Scale(1.5, 0.3, 1.0) Color: #7C3AED (보라)
- 바퀴 4개: Cylinder Scale(0.2, 0.15, 0.2)
  - 위치: (±0.6, -0.15, ±0.4)

**Step 3: 이송 부품 생성**

GameObject `Part` Position(-10, 0.6, 0):
- Mesh: Cube Scale(0.8, 0.5, 0.8)
- Color: #F59E0B (황색)

**Step 4: 씬 저장**

Unity MCP `save_scene`

---

## Task 4: C# 스크립트 작성

**Files:**
- Create: `Assets/Scripts/SmartRackSimulation.cs`
- Create: `Assets/Scripts/UIController.cs`

**Step 1: Scripts 폴더 생성**

Unity MCP `execute_menu_item`: `Assets/Create/Folder` → "Scripts"

**Step 2: SmartRackSimulation.cs 작성**

```csharp
using UnityEngine;
using System.Collections;

public class SmartRackSimulation : MonoBehaviour
{
    [Header("Objects")]
    public Transform part;
    public Transform crane;
    public Transform amr;
    public GameObject scanPlane;

    [Header("Positions")]
    public Vector3 conveyorPos = new Vector3(-10, 0.6f, 0);
    public Vector3 scanPos = new Vector3(-6.5f, 0.6f, 0);
    public Vector3 craneStartPos = new Vector3(-10, 0, 0);
    public Vector3 craneScanPos = new Vector3(-6.5f, 0, 0);
    public Vector3 craneRackPos = new Vector3(0, 0, 0);
    public Vector3 rackSlotPos = new Vector3(0, 1.5f, 0);
    public Vector3 amrStartPos = new Vector3(8, 0.15f, 4);
    public Vector3 amrRackPos = new Vector3(2, 0.15f, 0);
    public Vector3 amrExitPos = new Vector3(10, 0.15f, 4);

    public UIController uiController;

    private int currentStep = 0;
    private bool isAnimating = false;

    private static readonly string[] stepTitles = {
        "1단계: 입고",
        "2단계: 3D 스캔",
        "3단계: 크레인 이송",
        "4단계: 적치 완료",
        "5단계: 출고"
    };

    private static readonly string[] stepDescriptions = {
        "부품이 컨베이어에 진입합니다.\nAI 비전 시스템이 대기 중입니다.",
        "3D 카메라가 부품 형상을 인식합니다.\n무게중심 및 형상 분류 완료.",
        "스태커크레인이 부품을 픽업합니다.\n최적 보관 슬롯으로 이송 중.",
        "랙 시스템에 적치 완료.\n재고 데이터베이스 자동 업데이트.",
        "AMR이 부품을 픽업합니다.\n조립 라인으로 출고 중."
    };

    void Start()
    {
        ResetScene();
        UpdateUI();
    }

    public void NextStep()
    {
        if (isAnimating || currentStep >= 4) return;
        currentStep++;
        UpdateUI();
        StartCoroutine(PlayStep(currentStep));
    }

    public void PrevStep()
    {
        if (isAnimating) return;
        currentStep = Mathf.Max(0, currentStep - 1);
        ResetScene();
        UpdateUI();
    }

    void UpdateUI()
    {
        if (uiController != null)
            uiController.UpdateStep(currentStep, stepTitles[currentStep], stepDescriptions[currentStep]);
    }

    void ResetScene()
    {
        StopAllCoroutines();
        isAnimating = false;
        if (part) part.position = conveyorPos;
        if (crane) crane.position = craneStartPos;
        if (amr) amr.position = amrStartPos;
        if (scanPlane) scanPlane.SetActive(false);
    }

    IEnumerator PlayStep(int step)
    {
        isAnimating = true;
        switch (step)
        {
            case 1: yield return StartCoroutine(Step1_Inbound()); break;
            case 2: yield return StartCoroutine(Step2_Scan()); break;
            case 3: yield return StartCoroutine(Step3_CraneTransport()); break;
            case 4: yield return StartCoroutine(Step4_Store()); break;
            case 5: yield return StartCoroutine(Step5_Outbound()); break;
        }
        isAnimating = false;
    }

    IEnumerator Step1_Inbound()
    {
        Vector3 startPos = new Vector3(-14, 0.6f, 0);
        part.position = startPos;
        yield return MoveObject(part, conveyorPos, 1.5f);
    }

    IEnumerator Step2_Scan()
    {
        if (scanPlane) scanPlane.SetActive(true);
        yield return MoveObject(part, scanPos, 1.0f);
        yield return FlashScanPlane(1.5f);
        if (scanPlane) scanPlane.SetActive(false);
    }

    IEnumerator Step3_CraneTransport()
    {
        yield return MoveObject(crane, craneScanPos, 1.0f);
        yield return new WaitForSeconds(0.3f);
        yield return MoveObject(crane, craneRackPos, 1.5f);
        part.SetParent(crane);
    }

    IEnumerator Step4_Store()
    {
        Vector3 worldSlot = crane.position + rackSlotPos;
        part.SetParent(null);
        yield return MoveObject(part, worldSlot, 0.8f);
        yield return MoveObject(crane, craneStartPos, 1.0f);
    }

    IEnumerator Step5_Outbound()
    {
        yield return MoveObject(amr, amrRackPos, 1.5f);
        yield return new WaitForSeconds(0.5f);
        part.SetParent(amr);
        yield return MoveObject(amr, amrExitPos, 1.5f);
    }

    IEnumerator MoveObject(Transform obj, Vector3 target, float duration)
    {
        Vector3 start = obj.position;
        float elapsed = 0;
        while (elapsed < duration)
        {
            elapsed += Time.deltaTime;
            float t = Mathf.SmoothStep(0, 1, elapsed / duration);
            obj.position = Vector3.Lerp(start, target, t);
            yield return null;
        }
        obj.position = target;
    }

    IEnumerator FlashScanPlane(float duration)
    {
        float elapsed = 0;
        var renderer = scanPlane?.GetComponent<Renderer>();
        while (elapsed < duration)
        {
            elapsed += Time.deltaTime;
            if (renderer != null)
            {
                float alpha = (Mathf.Sin(elapsed * 8f) + 1f) * 0.3f;
                Color c = renderer.material.color;
                c.a = alpha;
                renderer.material.color = c;
            }
            yield return null;
        }
    }
}
```

**Step 3: UIController.cs 작성**

```csharp
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class UIController : MonoBehaviour
{
    public TextMeshProUGUI stepTitleText;
    public TextMeshProUGUI stepDescText;
    public TextMeshProUGUI[] stepIndicators; // 5개
    public Button prevButton;
    public Button nextButton;

    private Color activeColor = new Color(0.24f, 0.85f, 0.64f);
    private Color inactiveColor = new Color(0.4f, 0.4f, 0.4f);

    public void UpdateStep(int step, string title, string description)
    {
        if (stepTitleText) stepTitleText.text = title;
        if (stepDescText) stepDescText.text = description;

        for (int i = 0; i < stepIndicators.Length; i++)
        {
            if (stepIndicators[i] != null)
                stepIndicators[i].color = (i <= step) ? activeColor : inactiveColor;
        }

        if (prevButton) prevButton.interactable = (step > 0);
        if (nextButton) nextButton.interactable = (step < 4);
    }
}
```

**Step 4: Unity Editor에서 컴파일 확인**

Unity Editor Console에 오류 없음 확인

---

## Task 5: UI Canvas 구성

**Files:**
- Unity Scene: `Assets/Scenes/SampleScene.unity`

**Step 1: Canvas 생성**

Unity MCP `execute_menu_item`: `GameObject/UI/Canvas`
- Render Mode: Screen Space - Overlay

**Step 2: 단계 제목 텍스트 추가**

`GameObject/UI/Text - TextMeshPro` → "StepTitle"
- Anchor: Top Center
- Pos: (0, -60, 0)
- Font Size: 32, Bold
- Color: White

**Step 3: 단계 설명 텍스트 추가**

TextMeshPro "StepDescription"
- Anchor: Top Center
- Pos: (0, -110, 0)
- Font Size: 18
- Color: #A0AEC0

**Step 4: 이전/다음 버튼 추가**

PrevButton: `GameObject/UI/Button - TextMeshPro`
- Anchor: Bottom Center, Pos: (-100, 60, 0)
- Text: "◀ 이전"
- Color: #374151

NextButton:
- Anchor: Bottom Center, Pos: (100, 60, 0)
- Text: "다음 ▶"
- Color: #0D6E51

**Step 5: 단계 인디케이터 (1~5)**

5개의 TextMeshPro: "① ② ③ ④ ⑤"
- Anchor: Bottom Center, 수평 배치
- Pos Y: 110

**Step 6: SmartRackSimulation 오브젝트에 스크립트 연결**

빈 GameObject "SimulationController" 생성 후:
- SmartRackSimulation 컴포넌트 추가
- UIController 컴포넌트 추가
- Inspector에서 참조 연결:
  - part → Part
  - crane → StackerCrane
  - amr → AMR
  - scanPlane → ScanGate/ScanPlane
  - uiController → UIController 컴포넌트

**Step 7: 버튼 이벤트 연결**

PrevButton.OnClick → SimulationController.SmartRackSimulation.PrevStep()
NextButton.OnClick → SimulationController.SmartRackSimulation.NextStep()

**Step 8: 씬 저장 + Play 모드 테스트**

Unity Editor Play 버튼 → 단계별 버튼 동작 확인

---

## Task 6: WebGL 빌드

**Files:**
- Build output: `/home/qwe/Unity/Project/SmartRack3D/Builds/WebGL/`

**Step 1: Build Settings 설정**

Unity MCP `execute_menu_item`: `File/Build Settings`
- Platform: WebGL 선택
- Switch Platform 클릭

**Step 2: Player Settings 설정**

- Company Name: SP Systems
- Product Name: SmartRack 3D
- WebGL Template: Default
- Compression Format: Disabled (로컬 테스트용)

**Step 3: 씬 추가 확인**

Build Settings에서 SampleScene이 목록에 있는지 확인

**Step 4: 빌드 실행**

Unity MCP `execute_menu_item`: `File/Build And Run`
또는 Build 폴더 지정 후 Build 클릭

**Step 5: 로컬 서버로 테스트**

```bash
cd /home/qwe/Unity/Project/SmartRack3D/Builds/WebGL
python3 -m http.server 8080
# 브라우저에서 http://localhost:8080 접속
```

**Step 6: 동작 확인 체크리스트**
- [ ] 씬 로드 정상
- [ ] 다음 버튼으로 1→2→3→4→5 단계 진행
- [ ] 각 단계 애니메이션 정상
- [ ] 한국어 텍스트 표시
- [ ] 이전 버튼으로 되돌아가기

---

## 완료 기준

- Unity WebGL 빌드 파일 생성 완료
- 5단계 버튼 제어 정상 동작
- 한국어 UI 텍스트 표시
- 로컬 브라우저에서 정상 실행

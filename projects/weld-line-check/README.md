# 용접선 검증 분석 도구

로봇 용접 시스템의 용접선 건전성을 검증하고 분석하는 Python 도구입니다.

## ✨ 주요 기능

### 📊 Excel 보고서 생성 (추천)
- **4개 탭 구성**: 요약, 전체 데이터, FAIL만, 통계
- **거더 정보 및 날짜 자동 추출**
- **검사 기준값 표시**
- **실패 사유 상세 기록**
- **조건부 서식** (PASS=초록, FAIL=빨강)
- **필터 자동 적용**

### 📤 CSV 데이터 추출 (신규!)
- **유연한 필드 선택**: 필요한 데이터만 선택하여 추출
- **4가지 프리셋**: full, basic, coordinates, image_format
- **40개 이상 필드**: 좌표, 두께, 길이, 각도, 용접 모드 등
- **3개 거더 일괄 처리**: B라인 1/2/3번 거더 자동 처리
- **Excel 호환**: UTF-8 BOM, CP949 인코딩 지원

### 📝 7가지 검증 항목
1. **교차 검사**: 두 선분이 교차하지 않는지
2. **방향 검사**: 같은 방향으로 진행하는지
3. **길이 검사**: 길이 차이가 기준 이내인지
4. **각도 검사**: 각도 차이가 기준 이내인지
5. **거리 검사**: 선분 간 거리가 기준 이내인지
6. **시작점 검사**: 시작점 변위가 기준 이내인지
7. **끝점 검사**: 끝점 변위가 기준 이내인지

## 🚀 빠른 시작

### 1단계: 설치

**Windows:**
```cmd
install.bat
```

**Linux/Mac:**
```bash
./install.sh
```

**수동 설치:**
```bash
pip install -r requirements.txt
```

### 2단계: 실행

**A. Excel 검증 분석 (추천):**
```bash
python3 analyze_logs_excel.py
```

**B. CSV 데이터 추출 (신규):**
```bash
# 기본 실행 (이미지 형식)
python3 parse_to_csv.py

# 모든 필드 추출
python3 parse_to_csv.py --preset full

# 필드 목록 확인
python3 parse_to_csv.py --list-fields
```

**C. 간단 버전 (터미널 + CSV):**
```bash
python3 analyze_logs.py --csv
```

### 3단계: 결과 확인

Excel 파일이 생성됩니다:
```
용접선검증_B라인1번거더_20260207_103441.xlsx
```

## 📂 파일 구조

```
weld-line-check/
├── analyze_logs_excel.py       ⭐ Excel 검증 분석 도구
├── analyze_all_detailed.py     📊 전체 거더 상세 분석
├── parse_to_csv.py              🆕 로그 파싱 → CSV 추출 도구 (신규)
├── parse_field_definitions.py   🆕 파싱 필드 정의 모듈
├── parse_config.json            🆕 파싱 설정 파일
├── analyze_logs.py              📄 간단 버전
├── test_validator.py            🔧 디버깅 도구
├── requirements.txt             📦 필요 라이브러리
├── 설치가이드.md                📖 설치 가이드
├── CSV추출가이드.md             🆕 CSV 추출 가이드 (신규)
├── install.bat                  🖥️  Windows 설치
├── install.sh                   🐧 Linux/Mac 설치
├── extracted_data/              🆕 CSV 출력 디렉토리
│   ├── 1거더_20260202.csv
│   ├── 2거더_20260202.csv
│   └── ...
└── README.md                    📚 이 파일
```

## 📊 출력 예시

### Excel 파일 (4개 탭)

**1. 요약 탭**
```
거더 정보: B라인1번거더
날짜: 2026년 02월 04일
검사 기준:
  - 길이 오차: 20mm 이하
  - 각도 차이: 5° 이하
  - 최대 거리: 20mm 이하
  - 점 변위: 20mm 이하

검증 결과:
  총 케이스: 3,804개
  ✅ PASS: 99개 (2.6%)
  ❌ FAIL: 3,705개 (97.4%)
```

**2. 전체 데이터 탭**
| 번호 | 날짜시간 | 거더 | RequestID | 종합결과 | 실패사유 | ... |
|------|----------|------|-----------|---------|---------|-----|
| 1 | 2026-02-04 08:08:58 | B라인1번거더 | 587411 | PASS | N/A | ... |
| 2 | 2026-02-04 08:16:13 | B라인1번거더 | 589178 | PASS | N/A | ... |
| 69 | 2026-02-04 14:23:26 | B라인1번거더 | 653438 | FAIL | 길이차이(100.0mm > 20mm), 시작점변위(100.5mm > 20mm) | ... |

**3. FAIL만 탭**
- FAIL 케이스만 필터링된 데이터

**4. 통계 탭**
| 항목 | 평균 | 최소 | 최대 | 중앙값 |
|------|------|------|------|--------|
| 길이 차이 (mm) | 97.4 | 0.0 | 100.0 | 100.0 |
| 시작점 변위 (mm) | 120.1 | 12.0 | 1871.4 | 100.5 |

## 🔧 검사 기준 변경

`analyze_logs_excel.py` 파일에서 수정:

```python
thresholds = {
    'length': 20.0,    # 길이 오차 (mm)
    'angle': 5.0,      # 각도 차이 (°)
    'distance': 20.0,  # 최대 거리 (mm)
    'offset': 20.0     # 점 변위 (mm)
}
```

## 📖 상세 사용법

### 다른 로그 파일 분석

코드에서 경로 변경:
```python
# analyze_logs_excel.py 67번째 줄
log_file = Path(__file__).parent / "B라인2번거더/2월/05일/rcs_20260205.log"
```

### 여러 날짜 일괄 분석

```bash
# 스크립트 작성
for date in 02일 03일 04일 05일 06일; do
    # 로그 파일 경로 수정하고 실행
    python3 analyze_logs_excel.py
done
```

## 🐛 문제 해결

### openpyxl 설치 오류
```bash
pip install --upgrade pip
pip install openpyxl
```

### 파일 인코딩 오류
로그 파일이 UTF-8이 아닌 경우:
```python
with open(log_file, 'r', encoding='cp949') as f:  # 또는 'euc-kr'
```

### Python 버전 오류
Python 3.7 이상 필요:
```bash
python3 --version
```

## 📝 결과 해석

### PASS/FAIL 판정
- **PASS**: 7개 항목 모두 기준 이내
- **FAIL**: 하나 이상의 항목이 기준 초과

### 실패 사유 예시
```
길이차이(100.0mm > 20mm), 시작점변위(100.5mm > 20mm)
```
→ 길이 차이가 100.0mm (기준 20mm 초과), 시작점 변위가 100.5mm (기준 20mm 초과)

### 높은 불량률의 의미
97%가 FAIL인 경우:
- 로봇 캘리브레이션 필요
- 좌표계 오류 가능성
- 설계 기준 재검토 필요

## 📞 지원

문제 발생 시:
1. `설치가이드.md` 참고
2. 오류 메시지 전체 캡처
3. Python 버전 확인: `python3 --version`
4. 라이브러리 확인: `pip list | grep openpyxl`

## 🔖 버전 정보

- **버전**: 2.0 (Excel 버전)
- **업데이트**: 2026-02-07
- **Python**: 3.7+
- **의존성**: openpyxl

## 📄 라이선스

내부 사용 전용

---

**💡 팁**: Excel 파일에서 필터를 활용하면 특정 조건의 데이터만 빠르게 찾을 수 있습니다!

@echo off
REM Windows용 자동 설치 스크립트

echo ===================================
echo 용접선 검증 분석 도구 설치
echo ===================================
echo.

REM Python 확인
python --version >nul 2>&1
if errorlevel 1 (
    echo [오류] Python이 설치되어 있지 않습니다.
    echo Python 3.7 이상을 설치하세요: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo [확인] Python이 설치되어 있습니다.
python --version
echo.

REM pip 업그레이드
echo [진행] pip 업그레이드 중...
python -m pip install --upgrade pip --quiet
if errorlevel 1 (
    echo [경고] pip 업그레이드 실패 (무시하고 진행)
)
echo.

REM 라이브러리 설치
echo [진행] 필요한 라이브러리 설치 중...
pip install -r requirements.txt
if errorlevel 1 (
    echo [오류] 라이브러리 설치 실패
    pause
    exit /b 1
)
echo.

echo ===================================
echo 설치 완료!
echo ===================================
echo.
echo 사용 방법:
echo   python analyze_logs_excel.py
echo.
pause

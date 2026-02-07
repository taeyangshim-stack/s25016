#!/bin/bash
# Linux/Mac용 자동 설치 스크립트

echo "==================================="
echo "용접선 검증 분석 도구 설치"
echo "==================================="
echo ""

# Python 확인
if ! command -v python3 &> /dev/null; then
    echo "[오류] Python3가 설치되어 있지 않습니다."
    echo "설치 방법:"
    echo "  Ubuntu/Debian: sudo apt install python3 python3-pip"
    echo "  CentOS/RHEL: sudo yum install python3 python3-pip"
    echo "  Mac: brew install python@3.9"
    exit 1
fi

echo "[확인] Python이 설치되어 있습니다."
python3 --version
echo ""

# pip 확인
if ! command -v pip3 &> /dev/null; then
    echo "[오류] pip3가 설치되어 있지 않습니다."
    echo "설치 방법: sudo apt install python3-pip"
    exit 1
fi

# pip 업그레이드
echo "[진행] pip 업그레이드 중..."
pip3 install --upgrade pip --quiet 2>/dev/null || echo "[경고] pip 업그레이드 실패 (무시하고 진행)"
echo ""

# 라이브러리 설치
echo "[진행] 필요한 라이브러리 설치 중..."
pip3 install -r requirements.txt

if [ $? -ne 0 ]; then
    echo "[오류] 라이브러리 설치 실패"
    exit 1
fi
echo ""

echo "==================================="
echo "설치 완료!"
echo "==================================="
echo ""
echo "사용 방법:"
echo "  python3 analyze_logs_excel.py"
echo ""

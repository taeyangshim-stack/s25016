#!/bin/bash
#
# 이 스크립트는 두 개의 ABB 로봇 컨트롤러 백업 디렉터리를 비교하여
# 차이점을 분석하고 보고서를 생성합니다.
#
# 사용법:
#   ./compare_backups.sh <BACKUP_PATH_1> <BACKUP_PATH_2>
#
# 예시:
#   ./compare_backups.sh "robot)badkup/git_reference/1200-526402" "robot)badkup/git_reference/1200-526404"
#

set -e

# --- 입력 변수 확인 ---
if [ "$#" -ne 2 ]; then
    echo "오류: 비교할 두 개의 백업 경로를 입력해야 합니다."
    echo "사용법: $0 <백업1_경로> <백업2_경로>"
    exit 1
fi

BACKUP_A_PATH=$1
BACKUP_B_PATH=$2
REPORT_FILE="backup_comparison_report.md"

# --- 보고서 파일 초기화 ---
>"${REPORT_FILE}"

echo "ABB 백업 비교 보고서" >>"${REPORT_FILE}"
echo "========================================" >>"${REPORT_FILE}"
echo "" >>"${REPORT_FILE}"
echo "- **기준 백업 (A):** \`${BACKUP_A_PATH}\`" >>"${REPORT_FILE}"
echo "- **비교 백업 (B):** \`${BACKUP_B_PATH}\`" >>"${REPORT_FILE}"
echo "- **보고서 생성일:** $(date '+%Y-%m-%d %H:%M:%S')" >>"${REPORT_FILE}"
echo "" >>"${REPORT_FILE}"

# 함수: 섹션 헤더 추가
add_section_header() {
    echo "" >>"${REPORT_FILE}"
    echo "---" >>"${REPORT_FILE}"
    echo "" >>"${REPORT_FILE}"
    echo "## $1" >>"${REPORT_FILE}"
    echo "" >>"${REPORT_FILE}"
}

# --- 1. 파일 및 디렉터리 목록 비교 ---
add_section_header "파일 및 디렉터리 변경 사항"
echo "\`diff -rq\` 명령을 사용하여 두 백업의 파일 목록 차이를 확인합니다." >>"${REPORT_FILE}"
echo '```' >>"${REPORT_FILE}"
diff -rq "${BACKUP_A_PATH}" "${BACKUP_B_PATH}" || true >>"${REPORT_FILE}"
echo '```' >>"${REPORT_FILE}"

# --- 2. 주요 설정 파일(.cfg) 비교 ---
add_section_header "주요 설정 파일(.cfg) 비교"

for cfg_file in MOC.cfg EIO.cfg SYS.cfg; do
    file_a="${BACKUP_A_PATH}/SYSPAR/${cfg_file}"
    file_b="${BACKUP_B_PATH}/SYSPAR/${cfg_file}"

    if [ -f "${file_a}" ] && [ -f "${file_b}" ]; then
        echo "### \`${cfg_file}\` 비교" >>"${REPORT_FILE}"
        echo '```diff' >>"${REPORT_FILE}"
        diff -u "${file_a}" "${file_b}" || true >>"${REPORT_FILE}"
        echo '```' >>"${REPORT_FILE}"
        echo "" >>"${REPORT_FILE}"
    fi
done

# --- 3. RAPID 프로그램 비교 (예: HOME 디렉터리) ---
add_section_header "RAPID 프로그램 비교"
echo "RAPID 프로그램 폴더의 파일 변경 사항을 비교합니다." >>"${REPORT_FILE}"
echo '```' >>"${REPORT_FILE}"
diff -rq "${BACKUP_A_PATH}/HOME/" "${BACKUP_B_PATH}/HOME/" || true >>"${REPORT_FILE}"
echo '```' >>"${REPORT_FILE}"

echo ""
echo "비교가 완료되었습니다. 결과는 '${REPORT_FILE}' 파일에서 확인하세요."

#!/usr/bin/env python3
"""
RAPID 파일 버전 정보 검증 스크립트

검증 항목:
1. 버전 히스토리 존재 여부
2. Current Version 존재 여부
3. Last Modified 존재 여부
4. 버전 번호 형식 (vX.Y.Z)
5. 날짜 형식 (YYYY-MM-DD)
6. Current Version과 최신 히스토리 일치 여부
"""

import re
import sys
from pathlib import Path
from datetime import datetime


class VersionChecker:
    """버전 정보 검증 클래스"""

    def __init__(self, filepath):
        self.filepath = filepath
        self.errors = []
        self.warnings = []
        self.content = None

    def check(self):
        """전체 검증 실행"""
        if not Path(self.filepath).exists():
            self.errors.append(f"파일이 존재하지 않습니다: {self.filepath}")
            return False

        # 파일 읽기
        try:
            with open(self.filepath, 'r', encoding='utf-8', errors='ignore') as f:
                self.content = f.read()
        except Exception as e:
            self.errors.append(f"파일 읽기 실패: {e}")
            return False

        # 검증 실행
        self._check_version_history()
        self._check_current_version()
        self._check_last_modified()
        self._check_version_consistency()

        return len(self.errors) == 0

    def _check_version_history(self):
        """버전 히스토리 검증"""
        # "! Version History:" 패턴 찾기
        if '! Version History:' not in self.content:
            self.errors.append("버전 히스토리 섹션이 없습니다")
            return

        # 버전 엔트리 찾기 (v#.#.# - YYYY-MM-DD - Description)
        version_pattern = r'!\s+v(\d+)\.(\d+)\.(\d+)\s+-\s+(\d{4}-\d{2}-\d{2})\s+-\s+(.+)'
        matches = re.findall(version_pattern, self.content)

        if not matches:
            self.errors.append("유효한 버전 엔트리가 없습니다")
            return

        # 날짜 형식 검증
        for major, minor, patch, date_str, desc in matches:
            try:
                datetime.strptime(date_str, '%Y-%m-%d')
            except ValueError:
                self.errors.append(f"잘못된 날짜 형식: {date_str} (v{major}.{minor}.{patch})")

        # 버전 번호 순서 검증 (선택적)
        versions = [(int(m[0]), int(m[1]), int(m[2])) for m in matches]
        for i in range(len(versions) - 1):
            if versions[i] >= versions[i + 1]:
                self.warnings.append(
                    f"버전 순서 경고: v{'.'.join(map(str, versions[i]))} >= "
                    f"v{'.'.join(map(str, versions[i + 1]))}"
                )

    def _check_current_version(self):
        """Current Version 검증"""
        pattern = r'!\s+Current Version:\s+v(\d+)\.(\d+)\.(\d+)'
        match = re.search(pattern, self.content)

        if not match:
            self.errors.append("Current Version이 없거나 형식이 잘못되었습니다")
            return

        self.current_version = (int(match.group(1)), int(match.group(2)), int(match.group(3)))

    def _check_last_modified(self):
        """Last Modified 검증"""
        pattern = r'!\s+Last Modified:\s+(\d{4}-\d{2}-\d{2})'
        match = re.search(pattern, self.content)

        if not match:
            self.errors.append("Last Modified가 없거나 형식이 잘못되었습니다")
            return

        try:
            datetime.strptime(match.group(1), '%Y-%m-%d')
        except ValueError:
            self.errors.append(f"잘못된 날짜 형식: {match.group(1)}")

    def _check_version_consistency(self):
        """Current Version과 최신 히스토리 일치 여부 검증"""
        if not hasattr(self, 'current_version'):
            return

        # 최신 버전 엔트리 찾기
        version_pattern = r'!\s+v(\d+)\.(\d+)\.(\d+)\s+-\s+\d{4}-\d{2}-\d{2}\s+-'
        matches = re.findall(version_pattern, self.content)

        if not matches:
            return

        latest_version = (int(matches[-1][0]), int(matches[-1][1]), int(matches[-1][2]))

        if self.current_version != latest_version:
            self.errors.append(
                f"Current Version (v{'.'.join(map(str, self.current_version))})과 "
                f"최신 히스토리 (v{'.'.join(map(str, latest_version))})가 일치하지 않습니다"
            )

    def print_report(self):
        """검증 결과 출력"""
        print(f"\n{'='*60}")
        print(f"버전 정보 검증: {self.filepath}")
        print(f"{'='*60}\n")

        if self.errors:
            print("❌ 오류:")
            for error in self.errors:
                print(f"  - {error}")

        if self.warnings:
            print("\n⚠️  경고:")
            for warning in self.warnings:
                print(f"  - {warning}")

        if not self.errors and not self.warnings:
            print("✅ 모든 검증 통과!")
            if hasattr(self, 'current_version'):
                version_str = '.'.join(map(str, self.current_version))
                print(f"\n현재 버전: v{version_str}")

        print(f"\n{'='*60}\n")


def main():
    """메인 함수"""
    if len(sys.argv) < 2:
        print("사용법: python check_version.py <file.mod>")
        print("\n예시:")
        print("  python check_version.py MainModule.mod")
        print("  python check_version.py RAPID/TASK1/PROGMOD/MainModule.mod")
        sys.exit(1)

    filepath = sys.argv[1]

    # 검증 실행
    checker = VersionChecker(filepath)
    success = checker.check()
    checker.print_report()

    # 종료 코드
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()

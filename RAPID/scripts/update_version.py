#!/usr/bin/env python3
"""
RAPID 파일 버전 자동 업데이트 스크립트

기능:
1. 버전 번호 자동 증가 (major/minor/patch)
2. 버전 히스토리 자동 추가
3. Current Version 자동 업데이트
4. Last Modified 자동 업데이트
5. 백업 자동 생성

사용법:
  python update_version.py <file.mod> --type [major|minor|patch] --message "설명"
  python update_version.py <file.mod> --set "3.2.0" --message "설명"
"""

import re
import sys
import argparse
import shutil
from pathlib import Path
from datetime import datetime


class VersionUpdater:
    """버전 업데이트 클래스"""

    def __init__(self, filepath, verbose=True):
        self.filepath = filepath
        self.verbose = verbose
        self.content = None
        self.current_version = None

    def log(self, message):
        """로그 출력"""
        if self.verbose:
            print(message)

    def load(self):
        """파일 로드"""
        if not Path(self.filepath).exists():
            self.log(f"❌ 파일이 존재하지 않습니다: {self.filepath}")
            return False

        try:
            with open(self.filepath, 'r', encoding='utf-8', errors='ignore') as f:
                self.content = f.read()
            return True
        except Exception as e:
            self.log(f"❌ 파일 읽기 실패: {e}")
            return False

    def save(self, backup=True):
        """파일 저장"""
        # 백업
        if backup:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            backup_path = f"{self.filepath}.backup_{timestamp}"
            shutil.copy2(self.filepath, backup_path)
            self.log(f"백업 생성: {backup_path}")

        # 저장
        try:
            with open(self.filepath, 'w', encoding='ascii') as f:
                f.write(self.content)
            self.log(f"✅ 파일 저장 완료: {self.filepath}")
            return True
        except Exception as e:
            self.log(f"❌ 파일 쓰기 실패: {e}")
            return False

    def get_current_version(self):
        """현재 버전 읽기"""
        pattern = r'!\s+Current Version:\s+v(\d+)\.(\d+)\.(\d+)'
        match = re.search(pattern, self.content)

        if not match:
            self.log("⚠️  Current Version을 찾을 수 없습니다")
            return None

        version = (int(match.group(1)), int(match.group(2)), int(match.group(3)))
        self.current_version = version
        return version

    def increment_version(self, bump_type='patch'):
        """버전 번호 증가"""
        if not self.current_version:
            self.get_current_version()

        if not self.current_version:
            self.log("❌ 현재 버전을 찾을 수 없습니다")
            return None

        major, minor, patch = self.current_version

        if bump_type == 'major':
            return (major + 1, 0, 0)
        elif bump_type == 'minor':
            return (major, minor + 1, 0)
        elif bump_type == 'patch':
            return (major, minor, patch + 1)
        else:
            self.log(f"❌ 잘못된 bump_type: {bump_type}")
            return None

    def set_version(self, version_string):
        """버전 번호 직접 설정"""
        match = re.match(r'(\d+)\.(\d+)\.(\d+)', version_string)
        if not match:
            self.log(f"❌ 잘못된 버전 형식: {version_string}")
            return None

        return (int(match.group(1)), int(match.group(2)), int(match.group(3)))

    def update(self, new_version, message):
        """버전 정보 업데이트"""
        if not new_version:
            return False

        major, minor, patch = new_version
        version_str = f"{major}.{minor}.{patch}"
        today = datetime.now().strftime("%Y-%m-%d")

        self.log(f"\n버전 업데이트: v{version_str}")
        self.log(f"날짜: {today}")
        self.log(f"설명: {message}\n")

        # 1. 버전 히스토리 추가
        new_entry = f"    ! v{version_str} - {today} - {message}\n"

        # "! Current Version:" 앞에 삽입
        pattern = r'(!\s+Current Version:)'
        if re.search(pattern, self.content):
            self.content = re.sub(
                pattern,
                new_entry + r'    !\n\1',
                self.content,
                count=1
            )
        else:
            self.log("⚠️  Current Version 섹션을 찾을 수 없습니다")

        # 2. Current Version 업데이트
        pattern = r'(!\s+Current Version:\s+)v\d+\.\d+\.\d+'
        self.content = re.sub(
            pattern,
            rf'\1v{version_str}',
            self.content
        )

        # 3. Last Modified 업데이트
        pattern = r'(!\s+Last Modified:\s+)\d{4}-\d{2}-\d{2}'
        self.content = re.sub(
            pattern,
            rf'\1{today}',
            self.content
        )

        return True


def main():
    """메인 함수"""
    parser = argparse.ArgumentParser(
        description='RAPID 파일 버전 자동 업데이트',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
예시:
  # PATCH 버전 증가 (v3.1.0 -> v3.1.1)
  python update_version.py MainModule.mod --type patch --message "Fix bug"

  # MINOR 버전 증가 (v3.1.1 -> v3.2.0)
  python update_version.py MainModule.mod --type minor --message "Add feature"

  # MAJOR 버전 증가 (v3.2.0 -> v4.0.0)
  python update_version.py MainModule.mod --type major --message "Breaking change"

  # 버전 직접 설정
  python update_version.py MainModule.mod --set "3.5.0" --message "Update"
        """
    )

    parser.add_argument('file', help='대상 .mod 파일')
    parser.add_argument('--type', choices=['major', 'minor', 'patch'],
                        help='버전 증가 타입')
    parser.add_argument('--set', metavar='VERSION',
                        help='버전 직접 설정 (예: 3.2.0)')
    parser.add_argument('--message', '-m', required=True,
                        help='변경 내용 설명')
    parser.add_argument('--no-backup', action='store_true',
                        help='백업 생성 안함')

    args = parser.parse_args()

    # 타입 또는 set 중 하나는 필수
    if not args.type and not args.set:
        parser.error("--type 또는 --set 중 하나는 필수입니다")

    if args.type and args.set:
        parser.error("--type과 --set은 동시에 사용할 수 없습니다")

    # 업데이터 생성
    updater = VersionUpdater(args.file)

    # 파일 로드
    if not updater.load():
        sys.exit(1)

    # 현재 버전 확인
    current = updater.get_current_version()
    if current:
        print(f"현재 버전: v{'.'.join(map(str, current))}")

    # 새 버전 계산
    if args.type:
        new_version = updater.increment_version(args.type)
    else:
        new_version = updater.set_version(args.set)

    if not new_version:
        sys.exit(1)

    # 업데이트 실행
    if not updater.update(new_version, args.message):
        sys.exit(1)

    # 저장
    if not updater.save(backup=not args.no_backup):
        sys.exit(1)

    print(f"\n✅ 버전 업데이트 완료!")
    print(f"   새 버전: v{'.'.join(map(str, new_version))}")

    sys.exit(0)


if __name__ == "__main__":
    main()

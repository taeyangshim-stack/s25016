#!/usr/bin/env python3
"""
RAPID 파일 자동 검증 및 수정 스크립트

기능:
1. UTF-8 문자 자동 감지 및 제거
2. 파일 인코딩 검증
3. 백업 자동 생성
4. 일괄 처리 지원

사용법:
  python validate_and_fix_rapid.py <file_or_directory>
  python validate_and_fix_rapid.py --check <file>  # 검증만
  python validate_and_fix_rapid.py --fix <file>    # 자동 수정
"""

import os
import sys
import shutil
from datetime import datetime
from pathlib import Path


class RAPIDValidator:
    """RAPID 파일 검증 및 수정 클래스"""

    def __init__(self, verbose=True):
        self.verbose = verbose
        self.errors_found = []

    def log(self, message):
        """로그 출력"""
        if self.verbose:
            print(message)

    def check_file(self, filepath):
        """파일 검증 (수정 안함)"""
        self.log(f"\n{'='*60}")
        self.log(f"검증 중: {filepath}")
        self.log(f"{'='*60}")

        if not os.path.exists(filepath):
            self.log(f"❌ 파일이 존재하지 않습니다: {filepath}")
            return False

        # 인코딩 검사
        encoding = self._detect_encoding(filepath)
        self.log(f"파일 인코딩: {encoding}")

        # UTF-8 문자 검사
        non_ascii_chars = self._find_non_ascii(filepath)

        if non_ascii_chars:
            self.log(f"\n⚠️  발견된 non-ASCII 문자: {len(non_ascii_chars)}개")

            # 위치 정보와 함께 표시
            char_locations = {}
            with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                lines = f.readlines()
                for line_num, line in enumerate(lines, 1):
                    for col_num, char in enumerate(line, 1):
                        if ord(char) >= 128:
                            char_info = f"'{char}' (U+{ord(char):04X})"
                            if char_info not in char_locations:
                                char_locations[char_info] = []
                            char_locations[char_info].append((line_num, col_num))

            self.log("\n문자별 위치:")
            for char_info, locations in sorted(char_locations.items()):
                self.log(f"  {char_info}:")
                # 처음 5개 위치만 표시
                for loc in locations[:5]:
                    line_num, col_num = loc
                    self.log(f"    - Line {line_num}, Column {col_num}")
                if len(locations) > 5:
                    self.log(f"    ... 외 {len(locations) - 5}개 위치")

            self.errors_found.append(filepath)
            return False
        else:
            self.log("✅ ASCII 문자만 포함 (정상)")
            return True

    def fix_file(self, filepath, backup=True):
        """파일 자동 수정"""
        self.log(f"\n{'='*60}")
        self.log(f"수정 중: {filepath}")
        self.log(f"{'='*60}")

        if not os.path.exists(filepath):
            self.log(f"❌ 파일이 존재하지 않습니다: {filepath}")
            return False

        # 백업 생성
        if backup:
            backup_path = self._create_backup(filepath)
            self.log(f"백업 생성: {backup_path}")

        # UTF-8로 읽기
        try:
            with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
        except Exception as e:
            self.log(f"❌ 파일 읽기 실패: {e}")
            return False

        original_size = len(content)

        # non-ASCII 문자 찾기
        non_ascii_chars = set()
        for char in content:
            if ord(char) >= 128:
                non_ascii_chars.add(char)

        if non_ascii_chars:
            self.log(f"\n발견된 non-ASCII 문자: {len(non_ascii_chars)}개")
            for char in sorted(non_ascii_chars):
                self.log(f"  - '{char}' (U+{ord(char):04X})")

            # ASCII로 변환 (non-ASCII → 공백)
            clean_content = ''.join(c if ord(c) < 128 else ' ' for c in content)

            # ASCII로 저장
            try:
                with open(filepath, 'w', encoding='ascii') as f:
                    f.write(clean_content)
                self.log(f"\n✅ 수정 완료!")
                self.log(f"   원본 크기: {original_size:,} bytes")
                self.log(f"   수정 크기: {len(clean_content):,} bytes")
                self.log(f"   제거된 문자: {original_size - len(clean_content)} bytes")
                return True
            except Exception as e:
                self.log(f"❌ 파일 쓰기 실패: {e}")
                return False
        else:
            self.log("✅ ASCII 문자만 포함 (수정 불필요)")
            return True

    def process_directory(self, dirpath, fix=False):
        """디렉토리 일괄 처리"""
        self.log(f"\n{'='*60}")
        self.log(f"디렉토리 처리: {dirpath}")
        self.log(f"모드: {'자동 수정' if fix else '검증만'}")
        self.log(f"{'='*60}")

        # .mod 파일 찾기
        mod_files = list(Path(dirpath).rglob("*.mod"))

        if not mod_files:
            self.log("⚠️  .mod 파일을 찾을 수 없습니다.")
            return

        self.log(f"\n발견된 .mod 파일: {len(mod_files)}개\n")

        results = {"ok": 0, "fixed": 0, "failed": 0}

        for mod_file in mod_files:
            filepath = str(mod_file)

            if fix:
                success = self.fix_file(filepath)
                if success:
                    results["fixed"] += 1
                else:
                    results["failed"] += 1
            else:
                is_clean = self.check_file(filepath)
                if is_clean:
                    results["ok"] += 1
                else:
                    results["failed"] += 1

        # 결과 요약
        self.log(f"\n{'='*60}")
        self.log("처리 결과 요약")
        self.log(f"{'='*60}")
        if fix:
            self.log(f"✅ 수정 완료: {results['fixed']}개")
            self.log(f"❌ 수정 실패: {results['failed']}개")
        else:
            self.log(f"✅ 정상 파일: {results['ok']}개")
            self.log(f"⚠️  문제 파일: {results['failed']}개")

        if self.errors_found:
            self.log(f"\n문제가 발견된 파일 목록:")
            for filepath in self.errors_found:
                self.log(f"  - {filepath}")

    def _detect_encoding(self, filepath):
        """파일 인코딩 감지"""
        try:
            with open(filepath, 'rb') as f:
                raw_data = f.read(100)  # 처음 100바이트

            # BOM 체크
            if raw_data.startswith(b'\xef\xbb\xbf'):
                return "UTF-8 with BOM"
            elif raw_data.startswith(b'\xff\xfe'):
                return "UTF-16 LE"
            elif raw_data.startswith(b'\xfe\xff'):
                return "UTF-16 BE"

            # ASCII 체크
            try:
                raw_data.decode('ascii')
                return "ASCII"
            except:
                pass

            # UTF-8 체크
            try:
                raw_data.decode('utf-8')
                return "UTF-8"
            except:
                return "Unknown (possibly binary)"

        except Exception as e:
            return f"Error: {e}"

    def _find_non_ascii(self, filepath):
        """non-ASCII 문자 찾기"""
        non_ascii = set()
        try:
            with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
                for char in content:
                    if ord(char) >= 128:
                        non_ascii.add(char)
        except:
            pass
        return non_ascii

    def _create_backup(self, filepath):
        """백업 파일 생성"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_path = f"{filepath}.backup_{timestamp}"
        shutil.copy2(filepath, backup_path)
        return backup_path


def main():
    """메인 함수"""
    if len(sys.argv) < 2:
        print(__doc__)
        print("\n현재 디렉토리의 모든 .mod 파일 검증:")
        print("  python validate_and_fix_rapid.py .")
        print("\n특정 파일만 검증:")
        print("  python validate_and_fix_rapid.py MainModule.mod")
        print("\n특정 파일 자동 수정:")
        print("  python validate_and_fix_rapid.py --fix MainModule.mod")
        sys.exit(1)

    # 옵션 파싱
    fix_mode = False
    target = sys.argv[1]

    if target == "--fix" or target == "--check":
        fix_mode = (target == "--fix")
        if len(sys.argv) < 3:
            print("❌ 대상 파일/디렉토리를 지정하세요.")
            sys.exit(1)
        target = sys.argv[2]
    elif target == "--help" or target == "-h":
        print(__doc__)
        sys.exit(0)

    # 검증기 생성
    validator = RAPIDValidator(verbose=True)

    # 파일/디렉토리 처리
    if os.path.isfile(target):
        if fix_mode:
            validator.fix_file(target)
        else:
            validator.check_file(target)
    elif os.path.isdir(target):
        validator.process_directory(target, fix=fix_mode)
    else:
        print(f"❌ 파일/디렉토리를 찾을 수 없습니다: {target}")
        sys.exit(1)

    # 종료 코드
    sys.exit(0 if not validator.errors_found else 1)


if __name__ == "__main__":
    main()

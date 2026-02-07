#!/usr/bin/env python3
"""
용접선 데이터 CSV 추출 도구
설정 파일 기반으로 필요한 필드만 선택하여 CSV 생성
"""

from pathlib import Path
import json
import re
import csv
from datetime import datetime
from typing import List, Dict, Any, Optional
import argparse

from parse_field_definitions import ALL_FIELDS, PRESETS, get_field_groups


class DataExtractor:
    """로그 데이터 추출기"""

    def __init__(self, config_file: Path):
        with open(config_file, 'r', encoding='utf-8') as f:
            self.config = json.load(f)

        # 선택된 필드 결정
        if self.config.get('preset'):
            preset = self.config['preset']
            if preset in PRESETS:
                self.selected_fields = PRESETS[preset]
            else:
                print(f"⚠️  알 수 없는 프리셋: {preset}, custom_fields 사용")
                self.selected_fields = self.config.get('custom_fields', [])
        else:
            self.selected_fields = self.config.get('custom_fields', [])

        # 출력 디렉토리 생성
        output_dir = Path(self.config['output_settings']['output_dir'])
        output_dir.mkdir(exist_ok=True)
        self.output_dir = output_dir

    def extract_log_data(self, log_file: Path) -> tuple:
        """로그 파일에서 데이터 추출"""
        with open(log_file, 'r', encoding='utf-8') as f:
            content = f.read()

        # 메타데이터 추출
        metadata = self._extract_metadata(log_file)

        # 용접선 데이터 추출
        pattern = r'(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}),\d+ INFO.*?\[GantryRobotControllerServiceImpl\.RequestWeldingOperationStart\(\)\] ENTERED\. (.+?)(?=\n\d{4}-\d{2}-\d{2}|\Z)'
        matches = re.finditer(pattern, content, re.DOTALL)

        raw_data = []
        for match in matches:
            try:
                timestamp = match.group(1)
                json_str = match.group(2).strip()
                data = json.loads(json_str)

                # 특수 필드 추가
                data['_timestamp'] = timestamp
                data['_girder'] = metadata['girder']

                raw_data.append(data)
            except (json.JSONDecodeError, KeyError):
                continue

        return raw_data, metadata

    def _extract_metadata(self, log_file: Path) -> Dict:
        """메타데이터 추출"""
        metadata = {
            'log_file': log_file.name,
            'girder': '알수없음',
            'date': '알수없음'
        }

        # 경로에서 거더 정보 추출
        parts = log_file.parts
        for part in parts:
            if 'B라인' in part or '거더' in part:
                metadata['girder'] = part
                break

        # 날짜 추출
        date_match = re.search(r'(\d{8})', log_file.name)
        if date_match:
            date_str = date_match.group(1)
            try:
                date_obj = datetime.strptime(date_str, '%Y%m%d')
                metadata['date'] = date_obj.strftime('%Y%m%d')
            except:
                metadata['date'] = date_str

        return metadata

    def get_field_value(self, data: Dict, field_def) -> Any:
        """필드 정의에 따라 값 추출"""
        path = field_def.path
        robot_index = field_def.robot_index

        # 특수 필드 처리
        if path.startswith('_'):
            return data.get(path)

        # 일반 필드 처리
        parts = path.split('.')
        current = data

        for i, part in enumerate(parts):
            if part == 'weldJobs':
                # weldJobs 배열 처리
                if 'weldJobs' not in current or robot_index is None:
                    return field_def.default
                if robot_index >= len(current['weldJobs']):
                    return field_def.default
                current = current['weldJobs'][robot_index]
            else:
                if not isinstance(current, dict) or part not in current:
                    return field_def.default
                current = current[part]

        # 포맷팅 적용
        if field_def.formatter and current is not None:
            try:
                return field_def.formatter(current)
            except:
                return current

        return current

    def convert_to_rows(self, raw_data: List[Dict]) -> tuple:
        """원시 데이터를 CSV 행으로 변환 (중복 제거 포함)"""
        rows = []
        seen_request_ids = set()
        duplicate_count = 0

        for data in raw_data:
            row = {}
            for field_name in self.selected_fields:
                if field_name not in ALL_FIELDS:
                    print(f"⚠️  알 수 없는 필드: {field_name}")
                    row[field_name] = None
                    continue

                field_def = ALL_FIELDS[field_name]
                value = self.get_field_value(data, field_def)
                row[field_name] = value

            # RequestID 중복 체크
            if 'requestId' in row and row['requestId'] is not None:
                request_id = row['requestId']
                if request_id in seen_request_ids:
                    duplicate_count += 1
                    continue  # 중복이면 건너뛰기
                seen_request_ids.add(request_id)

            rows.append(row)

        return rows, duplicate_count

    def export_to_csv(self, rows: List[Dict], output_file: Path, duplicate_count: int = 0):
        """CSV 파일로 저장"""
        if not rows:
            print(f"  ⚠️  데이터 없음, 파일 생성 건너뜀: {output_file}")
            return

        settings = self.config['output_settings']

        with open(output_file, 'w', encoding=settings['encoding'], newline='') as f:
            writer = csv.DictWriter(
                f,
                fieldnames=self.selected_fields,
                delimiter=settings['delimiter']
            )

            if settings['include_header']:
                writer.writeheader()

            writer.writerows(rows)

        msg = f"  ✅ {output_file.name} ({len(rows)}행, {len(self.selected_fields)}컬럼)"
        if duplicate_count > 0:
            msg += f" [중복 제거: {duplicate_count}행]"
        print(msg)

    def process_log_file(self, log_file: Path):
        """단일 로그 파일 처리"""
        print(f"\n📂 처리 중: {log_file.relative_to(Path.cwd())}")

        # 데이터 추출
        raw_data, metadata = self.extract_log_data(log_file)

        if not raw_data:
            print("  ⚠️  데이터 없음")
            return None

        # CSV 행으로 변환 (중복 제거)
        rows, duplicate_count = self.convert_to_rows(raw_data)

        # 파일명 생성
        girder_name = metadata['girder'].replace('B라인', '').replace('번거더', '거더')
        output_file = self.output_dir / f"{girder_name}_{metadata['date']}.csv"

        # CSV 저장
        self.export_to_csv(rows, output_file, duplicate_count)

        return {
            'metadata': metadata,
            'rows': rows,
            'duplicate_count': duplicate_count,
            'output_file': output_file
        }

    def process_all_girders(self, base_dir: Path):
        """전체 거더 일괄 처리"""
        log_files = self.find_all_log_files(base_dir)

        if not log_files:
            print("❌ 로그 파일을 찾을 수 없습니다.")
            return

        print(f"\n✅ 총 {len(log_files)}개 로그 파일 발견")

        all_results = []
        all_rows = []
        total_duplicates = 0

        for log_file in log_files:
            result = self.process_log_file(log_file)
            if result:
                all_results.append(result)
                all_rows.extend(result['rows'])
                total_duplicates += result.get('duplicate_count', 0)

        # 전체 통합 파일 생성 (옵션)
        if self.config['processing_options'].get('merge_all_girders', False):
            timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
            merged_file = self.output_dir / f"전체통합_{timestamp}.csv"
            # 통합 파일도 중복 제거 필요
            merged_rows, merged_dups = self._remove_duplicates_from_rows(all_rows)
            self.export_to_csv(merged_rows, merged_file, merged_dups)
            print(f"\n✅ 통합 파일 생성: {merged_file.name}")

        print(f"\n{'='*80}")
        print(f"처리 완료!")
        print(f"{'='*80}")
        print(f"처리된 파일: {len(all_results)}개")
        print(f"총 데이터 행: {len(all_rows):,}개")
        if total_duplicates > 0:
            print(f"중복 제거: {total_duplicates:,}행")
        print(f"출력 디렉토리: {self.output_dir}")

    def _remove_duplicates_from_rows(self, rows: List[Dict]) -> tuple:
        """이미 생성된 rows에서 중복 제거"""
        unique_rows = []
        seen_ids = set()
        dup_count = 0

        for row in rows:
            if 'requestId' in row and row['requestId'] is not None:
                rid = row['requestId']
                if rid in seen_ids:
                    dup_count += 1
                    continue
                seen_ids.add(rid)
            unique_rows.append(row)

        return unique_rows, dup_count

    def find_all_log_files(self, base_dir: Path) -> List[Path]:
        """모든 rcs_*.log 파일 찾기"""
        log_files = []

        for girder_dir in base_dir.glob('B라인*거더'):
            for log_file in girder_dir.rglob('rcs_*.log'):
                if not log_file.name.startswith('rcs_error'):
                    log_files.append(log_file)

        return sorted(log_files)


def show_available_fields():
    """사용 가능한 필드 목록 표시"""
    print("\n" + "="*80)
    print("사용 가능한 필드 목록")
    print("="*80)

    groups = get_field_groups()
    for group_name, fields in groups.items():
        print(f"\n📌 {group_name}")
        for field_name in fields:
            field_def = ALL_FIELDS[field_name]
            print(f"  - {field_name:25s} : {field_def.description}")

    print("\n" + "="*80)
    print("프리셋")
    print("="*80)
    for preset_name, fields in PRESETS.items():
        print(f"\n📦 {preset_name} ({len(fields)}개 필드)")
        print(f"  {', '.join(fields[:10])}", end='')
        if len(fields) > 10:
            print(f" ... 외 {len(fields)-10}개")
        else:
            print()


def create_config_template(output_file: Path):
    """설정 파일 템플릿 생성"""
    template = {
        "_comment": "용접선 데이터 추출 설정 파일",
        "_preset_info": "프리셋: full, basic, coordinates, image_format",
        "preset": "image_format",
        "custom_fields": PRESETS['image_format'],
        "output_settings": {
            "format": "csv",
            "encoding": "utf-8-sig",
            "delimiter": ",",
            "include_header": True,
            "output_dir": "extracted_data"
        },
        "processing_options": {
            "merge_all_girders": False,
            "separate_by_date": True,
            "skip_empty_files": True
        }
    }

    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(template, f, indent=2, ensure_ascii=False)

    print(f"✅ 설정 파일 템플릿 생성: {output_file}")


def main():
    parser = argparse.ArgumentParser(
        description='용접선 로그 데이터를 CSV로 추출'
    )
    parser.add_argument(
        '--config',
        type=Path,
        default=Path('parse_config.json'),
        help='설정 파일 경로 (기본: parse_config.json)'
    )
    parser.add_argument(
        '--create-config',
        action='store_true',
        help='설정 파일 템플릿 생성'
    )
    parser.add_argument(
        '--list-fields',
        action='store_true',
        help='사용 가능한 필드 목록 표시'
    )
    parser.add_argument(
        '--preset',
        choices=list(PRESETS.keys()),
        help='프리셋 선택 (설정 파일 무시)'
    )

    args = parser.parse_args()

    # 필드 목록 표시
    if args.list_fields:
        show_available_fields()
        return

    # 설정 파일 템플릿 생성
    if args.create_config:
        create_config_template(args.config)
        return

    # 설정 파일 확인
    if not args.config.exists():
        print(f"❌ 설정 파일을 찾을 수 없습니다: {args.config}")
        print(f"   템플릿 생성: python {Path(__file__).name} --create-config")
        return

    # 프리셋 오버라이드
    if args.preset:
        with open(args.config, 'r', encoding='utf-8') as f:
            config = json.load(f)
        config['preset'] = args.preset
        with open(args.config, 'w', encoding='utf-8') as f:
            json.dump(config, f, indent=2, ensure_ascii=False)
        print(f"✅ 프리셋 변경: {args.preset}")

    # 데이터 추출 실행
    print("="*80)
    print("용접선 데이터 CSV 추출")
    print("="*80)
    print(f"설정 파일: {args.config}")

    extractor = DataExtractor(args.config)

    print(f"선택된 필드: {len(extractor.selected_fields)}개")
    print(f"  {', '.join(extractor.selected_fields[:10])}", end='')
    if len(extractor.selected_fields) > 10:
        print(f" ... 외 {len(extractor.selected_fields)-10}개")
    else:
        print()

    base_dir = Path(__file__).parent
    extractor.process_all_girders(base_dir)


if __name__ == '__main__':
    main()

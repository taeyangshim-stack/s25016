#!/usr/bin/env python3
"""
RequestID 중복 검사 도구
"""

import csv
from pathlib import Path
from collections import Counter, defaultdict


def analyze_csv_duplicates(csv_file: Path):
    """CSV 파일의 RequestID 중복 분석"""
    if not csv_file.exists():
        return None

    request_ids = []

    with open(csv_file, 'r', encoding='utf-8-sig') as f:
        reader = csv.DictReader(f)
        for row in reader:
            if 'requestId' in row and row['requestId']:
                request_ids.append(int(row['requestId']))

    total_count = len(request_ids)
    unique_count = len(set(request_ids))
    duplicate_count = total_count - unique_count

    # 중복 ID 찾기
    id_counts = Counter(request_ids)
    duplicates = {rid: count for rid, count in id_counts.items() if count > 1}

    return {
        'file': csv_file.name,
        'total': total_count,
        'unique': unique_count,
        'duplicate_rows': duplicate_count,
        'duplicate_ids': duplicates
    }


def main():
    base_dir = Path(__file__).parent / 'extracted_data'

    if not base_dir.exists():
        print(f"❌ {base_dir} 폴더를 찾을 수 없습니다.")
        return

    print("=" * 80)
    print("RequestID 중복 검사")
    print("=" * 80)
    print()

    csv_files = sorted(base_dir.glob('*.csv'))

    if not csv_files:
        print("❌ CSV 파일을 찾을 수 없습니다.")
        return

    all_results = []
    total_rows = 0
    total_unique = 0
    total_duplicates = 0
    all_request_ids = []

    # 파일별 분석
    for csv_file in csv_files:
        result = analyze_csv_duplicates(csv_file)
        if result:
            all_results.append(result)
            total_rows += result['total']
            total_unique += result['unique']
            total_duplicates += result['duplicate_rows']

            # 전체 RequestID 수집
            with open(csv_file, 'r', encoding='utf-8-sig') as f:
                reader = csv.DictReader(f)
                for row in reader:
                    if 'requestId' in row and row['requestId']:
                        all_request_ids.append(int(row['requestId']))

    # 파일별 결과 출력
    print("📂 파일별 중복 현황:")
    print()

    has_duplicates = False
    for result in all_results:
        file_name = result['file']
        total = result['total']
        unique = result['unique']
        dup_rows = result['duplicate_rows']
        dup_ids = result['duplicate_ids']

        if dup_rows > 0:
            has_duplicates = True
            print(f"⚠️  {file_name}")
            print(f"    전체: {total:,}행, 고유: {unique:,}개, 중복: {dup_rows:,}행")
            print(f"    중복 ID 목록:")
            for rid, count in sorted(dup_ids.items(), key=lambda x: x[1], reverse=True)[:5]:
                print(f"      - RequestID {rid}: {count}회 출현")
            if len(dup_ids) > 5:
                print(f"      ... 외 {len(dup_ids) - 5}개")
            print()
        else:
            print(f"✅ {file_name}: {total:,}행 (중복 없음)")

    print()
    print("=" * 80)
    print("📊 전체 통계:")
    print("=" * 80)
    print(f"총 파일: {len(all_results)}개")
    print(f"총 데이터: {total_rows:,}행")
    print(f"고유 RequestID: {total_unique:,}개")
    print(f"중복 데이터: {total_duplicates:,}행 ({total_duplicates/total_rows*100:.1f}%)")
    print()

    # 전체 데이터에서 파일 간 중복 확인
    all_id_counts = Counter(all_request_ids)
    cross_file_duplicates = {rid: count for rid, count in all_id_counts.items() if count > 1}

    print("🔍 파일 간 중복 (같은 RequestID가 여러 파일에 존재):")
    print()

    if cross_file_duplicates:
        # RequestID별로 어느 파일에 있는지 확인
        id_to_files = defaultdict(list)

        for csv_file in csv_files:
            with open(csv_file, 'r', encoding='utf-8-sig') as f:
                reader = csv.DictReader(f)
                for row in reader:
                    if 'requestId' in row and row['requestId']:
                        rid = int(row['requestId'])
                        if rid in cross_file_duplicates:
                            id_to_files[rid].append(csv_file.name)

        # 상위 5개만 출력
        for rid, count in sorted(cross_file_duplicates.items(), key=lambda x: x[1], reverse=True)[:5]:
            files = list(set(id_to_files[rid]))
            print(f"  RequestID {rid}: 총 {count}회")
            print(f"    파일: {', '.join(files[:3])}", end='')
            if len(files) > 3:
                print(f" 외 {len(files)-3}개")
            else:
                print()

        if len(cross_file_duplicates) > 5:
            print(f"  ... 외 {len(cross_file_duplicates) - 5}개 중복 ID")
    else:
        print("  ✅ 파일 간 중복 없음")

    print()
    print("=" * 80)
    print("💡 권장사항:")
    print("=" * 80)

    if has_duplicates or cross_file_duplicates:
        print("⚠️  RequestID 중복이 발견되었습니다.")
        print()
        print("해결 방안:")
        print("  1. 중복 제거: 같은 RequestID는 첫 번째만 유지")
        print("  2. 중복 표시: CSV에 'is_duplicate' 컬럼 추가")
        print("  3. 통계 보정: 검증 시 unique RequestID만 카운트")
        print()
        print("파싱 스크립트 수정 필요:")
        print("  - parse_to_csv.py: 중복 감지 및 처리")
        print("  - analyze_logs_excel.py: 통계 계산 시 unique 카운트")
    else:
        print("✅ 중복이 없습니다. 추가 조치 불필요.")

    print("=" * 80)


if __name__ == '__main__':
    main()

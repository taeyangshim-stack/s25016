#!/usr/bin/env python3
"""
타이트한 대각거리 검사 (2가지)
- 기존: <= 20.0 (이하) → 소수점 이슈로 20.0 경계값 누락 가능
- 수정: < 20.0 (미만) → 20.0 이상은 모두 FAIL
- 경계값 (19.0~21.0) 케이스 전체 출력
"""

from pathlib import Path
import json
import re
import math
from collections import defaultdict


def extract_weld_data(log_file):
    with open(log_file, 'r', encoding='utf-8') as f:
        content = f.read()

    pattern = r'(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}),\d+ INFO.*?\[GantryRobotControllerServiceImpl\.RequestWeldingOperationStart\(\)\] ENTERED\. (.+?)(?=\n\d{4}-\d{2}-\d{2}|\Z)'
    matches = re.finditer(pattern, content, re.DOTALL)

    weld_data = []
    seen_ids = set()
    for match in matches:
        try:
            json_str = match.group(2).strip()
            data = json.loads(json_str)
            if 'weldJobs' in data and len(data['weldJobs']) >= 2:
                rid = data['request']['requestId']
                if rid in seen_ids:
                    continue
                seen_ids.add(rid)

                r1 = data['weldJobs'][0]['weldLine']
                r2 = data['weldJobs'][1]['weldLine']
                weld_data.append({
                    'requestId': rid,
                    'line1': {'start': r1['startPointPosition'], 'end': r1['endPointPosition']},
                    'line2': {'start': r2['startPointPosition'], 'end': r2['endPointPosition']}
                })
        except:
            continue
    return weld_data


def calc_distance_3d(p1, p2):
    """3D 대각거리 (소수점 풀 정밀도)"""
    dx = p1['x'] - p2['x']
    dy = p1['y'] - p2['y']
    dz = p1.get('z', 0) - p2.get('z', 0)
    return math.sqrt(dx*dx + dy*dy + dz*dz)


def find_log_files(base_dir):
    log_files = []
    for girder_dir in sorted(base_dir.glob('B라인*거더')):
        for log_file in sorted(girder_dir.rglob('rcs_*.log')):
            if not log_file.name.startswith('rcs_error'):
                log_files.append(log_file)
    return log_files


def get_label(log_file):
    """로그파일에서 거더/날짜 라벨 추출"""
    parts = str(log_file).split('/')
    girder = ''
    for p in parts:
        if '거더' in p:
            girder = p
            break
    date_match = re.search(r'(\d{8})', log_file.name)
    date_str = date_match.group(1) if date_match else '?'
    return f"{girder} {date_str[4:6]}/{date_str[6:8]}"


def main():
    base_dir = Path(__file__).parent
    log_files = find_log_files(base_dir)

    THRESHOLD = 20.0
    DECIMAL_PLACES = 6  # 반올림 소수점 자리수

    print("=" * 100)
    print("대각거리 2가지 검사 - 3단계 로직 비교")
    print("=" * 100)
    print(f"  로직A (기존):  distance <= {THRESHOLD}     → PASS (이하, 소수점 풀)")
    print(f"  로직B (미만):  distance < {THRESHOLD}      → PASS (미만, 소수점 풀)")
    print(f"  로직C (반올림): round(distance,{DECIMAL_PLACES}) < {THRESHOLD} → PASS (반올림 후 미만)")
    print(f"  경계값 범위: {THRESHOLD-1.0} ~ {THRESHOLD+1.0} mm 사이 케이스 전체 출력")
    print("=" * 100)

    total_cases = 0
    fail_a = 0  # 기존
    fail_b = 0  # 미만
    fail_c = 0  # 반올림
    boundary_cases = []
    all_fail_c = []
    diff_a_to_c = []  # A(PASS) → C(FAIL)
    diff_b_to_c = []  # B(PASS) → C(FAIL)

    file_summary = []

    for log_file in log_files:
        label = get_label(log_file)
        weld_data = extract_weld_data(log_file)

        f_a = f_b = f_c = 0
        file_total = len(weld_data)
        total_cases += file_total

        for d in weld_data:
            start_dist = calc_distance_3d(d['line1']['start'], d['line2']['start'])
            end_dist = calc_distance_3d(d['line1']['end'], d['line2']['end'])

            # 반올림 값
            start_round = round(start_dist, DECIMAL_PLACES)
            end_round = round(end_dist, DECIMAL_PLACES)

            # 로직A: 기존 (<=)
            a_ok = (start_dist <= THRESHOLD) and (end_dist <= THRESHOLD)
            # 로직B: 미만 (<)
            b_ok = (start_dist < THRESHOLD) and (end_dist < THRESHOLD)
            # 로직C: 반올림 후 미만 (<)
            c_ok = (start_round < THRESHOLD) and (end_round < THRESHOLD)

            if not a_ok:
                fail_a += 1
                f_a += 1
            if not b_ok:
                fail_b += 1
                f_b += 1
            if not c_ok:
                fail_c += 1
                f_c += 1
                all_fail_c.append((label, d['requestId'], start_dist, end_dist, start_round, end_round))

            # A(PASS) → C(FAIL)
            if a_ok and not c_ok:
                diff_a_to_c.append((label, d['requestId'], start_dist, end_dist, start_round, end_round))
            # B(PASS) → C(FAIL)
            if b_ok and not c_ok:
                diff_b_to_c.append((label, d['requestId'], start_dist, end_dist, start_round, end_round))

            # 경계값 (19~21)
            if (THRESHOLD - 1.0 <= start_dist <= THRESHOLD + 1.0) or \
               (THRESHOLD - 1.0 <= end_dist <= THRESHOLD + 1.0):
                boundary_cases.append((label, d['requestId'], start_dist, end_dist,
                                       start_round, end_round, a_ok, b_ok, c_ok))

        file_summary.append({
            'label': label, 'total': file_total,
            'f_a': f_a, 'f_b': f_b, 'f_c': f_c
        })

    # ===== 결과 출력 =====

    print(f"\n총 {len(log_files)}개 파일, {total_cases}건 분석 완료\n")

    # 1. 파일별 요약
    print("-" * 110)
    print(f"{'파일':<28} {'총건수':>6} {'A(<=)':>7} {'B(<)':>7} {'C(반올림)':>10} {'A→C':>5}")
    print("-" * 110)
    for fs in file_summary:
        diff = fs['f_c'] - fs['f_a']
        diff_s = f"+{diff}" if diff > 0 else str(diff)
        print(f"{fs['label']:<28} {fs['total']:>6} {fs['f_a']:>7} {fs['f_b']:>7} {fs['f_c']:>10} {diff_s:>5}")
    print("-" * 110)
    diff_total = fail_c - fail_a
    print(f"{'합계':<28} {total_cases:>6} {fail_a:>7} {fail_b:>7} {fail_c:>10} +{diff_total:>4}")

    # 2. 핵심: 기존 PASS → 반올림 FAIL (소수점 이슈로 놓친 케이스)
    print("\n" + "=" * 110)
    print(f"*** 기존(A) PASS → 반올림(C) FAIL 전환: {len(diff_a_to_c)}건 ***")
    print("    (소수점 이슈로 기존에 놓친 케이스)")
    print("=" * 110)
    if diff_a_to_c:
        print(f"{'파일':<28} {'ReqID':>10} {'시작점(raw)':>25} {'시작점(round)':>14} {'끝점(raw)':>25} {'끝점(round)':>14}")
        print("-" * 110)
        for label, rid, sd, ed, sr, er in diff_a_to_c:
            print(f"{label:<28} {rid:>10} {sd:>25.15f} {sr:>14.6f} {ed:>25.15f} {er:>14.6f}")
    else:
        print("  (없음)")

    # 3. 경계값 케이스 (19~21)
    print("\n" + "=" * 110)
    print(f"경계값 케이스 (19.0 ~ 21.0mm): {len(boundary_cases)}건")
    print("=" * 110)
    if boundary_cases:
        print(f"{'파일':<22} {'ReqID':>10} {'시작(raw)':>25} {'시작(R)':>10} {'끝(raw)':>25} {'끝(R)':>10} {'A':>4} {'B':>4} {'C':>4}")
        print("-" * 110)
        for label, rid, sd, ed, sr, er, a, b, c in boundary_cases:
            a_s = "P" if a else "F"
            b_s = "P" if b else "F"
            c_s = "P" if c else "F"
            changed = " <<<" if a != c else ""
            print(f"{label:<22} {rid:>10} {sd:>25.15f} {sr:>10.6f} {ed:>25.15f} {er:>10.6f} {a_s:>4} {b_s:>4} {c_s:>4}{changed}")

    # 4. 전체 FAIL (반올림 기준)
    print("\n" + "=" * 110)
    print(f"전체 FAIL - 로직C 기준 (round({DECIMAL_PLACES}) < {THRESHOLD}mm): {len(all_fail_c)}건")
    print("=" * 110)
    if all_fail_c:
        print(f"{'파일':<28} {'ReqID':>10} {'시작점(raw)':>25} {'시작(R)':>12} {'끝점(raw)':>25} {'끝(R)':>12}")
        print("-" * 110)
        for label, rid, sd, ed, sr, er in all_fail_c:
            print(f"{label:<28} {rid:>10} {sd:>25.15f} {sr:>12.6f} {ed:>25.15f} {er:>12.6f}")

    # 5. 최종 비교
    print("\n" + "=" * 110)
    print("최종 비교")
    print("=" * 110)
    print(f"  로직A (<=, 기존):      PASS {total_cases - fail_a:>5}건, FAIL {fail_a:>3}건")
    print(f"  로직B (<, 미만):       PASS {total_cases - fail_b:>5}건, FAIL {fail_b:>3}건")
    print(f"  로직C (반올림+미만):   PASS {total_cases - fail_c:>5}건, FAIL {fail_c:>3}건")
    print(f"\n  A→C 추가 검출: +{fail_c - fail_a}건 (소수점 이슈로 놓쳤던 케이스)")


if __name__ == '__main__':
    main()
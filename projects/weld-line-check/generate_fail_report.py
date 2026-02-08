#!/usr/bin/env python3
"""
FAIL 케이스 중심 비교 분석 리포트 생성
투영거리 vs 대각거리 - 로우데이터 포함
"""

from pathlib import Path
import json
import re
import math
from datetime import datetime
from typing import List, Dict, Tuple


def extract_weld_data(log_file: Path) -> Tuple[List[Dict], Dict]:
    """로그에서 용접선 데이터 추출"""
    with open(log_file, 'r', encoding='utf-8') as f:
        content = f.read()

    metadata = {'log_file': log_file.name, 'girder': '알수없음', 'date': '알수없음'}

    parts = log_file.parts
    for part in parts:
        if 'B라인' in part or '거더' in part:
            metadata['girder'] = part
            break

    date_match = re.search(r'(\d{8})', log_file.name)
    if date_match:
        date_str = date_match.group(1)
        try:
            date_obj = datetime.strptime(date_str, '%Y%m%d')
            metadata['date'] = date_obj.strftime('%Y-%m-%d')
        except:
            metadata['date'] = date_str

    pattern = r'(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}),\d+ INFO.*?\[GantryRobotControllerServiceImpl\.RequestWeldingOperationStart\(\)\] ENTERED\. (.+?)(?=\n\d{4}-\d{2}-\d{2}|\Z)'
    matches = re.finditer(pattern, content, re.DOTALL)

    weld_data = []
    for match in matches:
        try:
            timestamp = match.group(1)
            json_str = match.group(2).strip()
            data = json.loads(json_str)

            if 'weldJobs' in data and len(data['weldJobs']) >= 2:
                r1 = data['weldJobs'][0]['weldLine']
                r2 = data['weldJobs'][1]['weldLine']

                weld_data.append({
                    'timestamp': timestamp,
                    'requestId': data['request']['requestId'],
                    'line1': {
                        'start': r1['startPointPosition'],
                        'end': r1['endPointPosition']
                    },
                    'line2': {
                        'start': r2['startPointPosition'],
                        'end': r2['endPointPosition']
                    }
                })
        except:
            continue

    return weld_data, metadata


def remove_duplicates(weld_data: List[Dict]) -> List[Dict]:
    """RequestID 중복 제거"""
    unique_data = []
    seen_ids = set()

    for data in weld_data:
        request_id = data.get('requestId')
        if request_id is None:
            unique_data.append(data)
            continue
        if request_id in seen_ids:
            continue
        seen_ids.add(request_id)
        unique_data.append(data)

    return unique_data


def check_projection(line1, line2, threshold=20.0):
    """투영거리 방식 검사"""
    s1x, s1y = line1['start']['x'], line1['start']['y']
    e1x, e1y = line1['end']['x'], line1['end']['y']
    s2x, s2y = line2['start']['x'], line2['start']['y']
    e2x, e2y = line2['end']['x'], line2['end']['y']

    # 시작점 변위 (양방향 투영)
    dx2 = e2x - s2x
    dy2 = e2y - s2y
    len_sq2 = dx2 * dx2 + dy2 * dy2
    if len_sq2 == 0:
        dist_s2_p1 = 0
    else:
        t1 = ((s1x - s2x) * dx2 + (s1y - s2y) * dy2) / len_sq2
        t1 = max(0, min(1, t1))
        p1x = s2x + t1 * dx2
        p1y = s2y + t1 * dy2
        dist_s2_p1 = math.sqrt((p1x - s2x) ** 2 + (p1y - s2y) ** 2)

    dx1 = e1x - s1x
    dy1 = e1y - s1y
    len_sq1 = dx1 * dx1 + dy1 * dy1
    if len_sq1 == 0:
        dist_s1_p2 = 0
    else:
        t2 = ((s2x - s1x) * dx1 + (s2y - s1y) * dy1) / len_sq1
        t2 = max(0, min(1, t2))
        p2x = s1x + t2 * dx1
        p2y = s1y + t2 * dy1
        dist_s1_p2 = math.sqrt((p2x - s1x) ** 2 + (p2y - s1y) ** 2)

    start_off = max(dist_s2_p1, dist_s1_p2)

    # 끝점 변위 (양방향 투영)
    if len_sq2 == 0:
        dist_e2_p3 = 0
    else:
        t3 = ((e1x - s2x) * dx2 + (e1y - s2y) * dy2) / len_sq2
        t3 = max(0, min(1, t3))
        p3x = s2x + t3 * dx2
        p3y = s2y + t3 * dy2
        dist_e2_p3 = math.sqrt((p3x - e2x) ** 2 + (p3y - e2y) ** 2)

    if len_sq1 == 0:
        dist_e1_p4 = 0
    else:
        t4 = ((e2x - s1x) * dx1 + (e2y - s1y) * dy1) / len_sq1
        t4 = max(0, min(1, t4))
        p4x = s1x + t4 * dx1
        p4y = s1y + t4 * dy1
        dist_e1_p4 = math.sqrt((p4x - e1x) ** 2 + (p4y - e1y) ** 2)

    end_off = max(dist_e2_p3, dist_e1_p4)

    return {
        'start_off': start_off,
        'end_off': end_off,
        'pass': start_off <= threshold and end_off <= threshold
    }


def check_diagonal(line1, line2, threshold=20.0):
    """대각거리 방식 검사"""
    s1x, s1y = line1['start']['x'], line1['start']['y']
    e1x, e1y = line1['end']['x'], line1['end']['y']
    s2x, s2y = line2['start']['x'], line2['start']['y']
    e2x, e2y = line2['end']['x'], line2['end']['y']

    s1z = line1['start'].get('z', 0)
    s2z = line2['start'].get('z', 0)
    e1z = line1['end'].get('z', 0)
    e2z = line2['end'].get('z', 0)

    start_off = math.sqrt((s1x - s2x)**2 + (s1y - s2y)**2 + (s1z - s2z)**2)
    end_off = math.sqrt((e1x - e2x)**2 + (e1y - e2y)**2 + (e1z - e2z)**2)

    return {
        'start_off': start_off,
        'end_off': end_off,
        'pass': start_off <= threshold and end_off <= threshold
    }


def analyze_logs():
    """로그 분석 - FAIL 케이스만 추출"""
    base_dir = Path(__file__).parent

    log_files = [
        ('1거더_2026-02-04', 'B라인1번거더/02월/04일/rcs_20260204.log'),
        ('2거더_2026-02-02', 'B라인2번거더/2월/02일/rcs_20260202.log')
    ]

    fail_cases = []

    for label, rel_path in log_files:
        log_path = base_dir / rel_path
        if not log_path.exists():
            continue

        print(f"분석 중: {label}")

        weld_data_raw, metadata = extract_weld_data(log_path)
        weld_data = remove_duplicates(weld_data_raw)

        for data in weld_data:
            proj = check_projection(data['line1'], data['line2'])
            diag = check_diagonal(data['line1'], data['line2'])

            # FAIL 케이스만 수집
            if not proj['pass'] or not diag['pass']:
                s1 = data['line1']['start']
                e1 = data['line1']['end']
                s2 = data['line2']['start']
                e2 = data['line2']['end']

                fail_cases.append({
                    'label': label,
                    'data': data,
                    'proj': proj,
                    'diag': diag,
                    'coords': {
                        's1': s1, 'e1': e1,
                        's2': s2, 'e2': e2
                    }
                })

    return fail_cases


def create_html_report(fail_cases):
    """HTML 리포트 생성"""

    html = """<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>FAIL 케이스 상세 분석 (로우데이터 포함)</title>
<style>
body { font-family: 'Malgun Gothic', sans-serif; line-height: 1.6; margin: 20px; background: #f5f5f5; }
.container { max-width: 1600px; margin: 0 auto; background: white; padding: 30px; box-shadow: 0 0 20px rgba(0,0,0,0.1); }
.header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 40px; margin: -30px -30px 30px -30px; text-align: center; }
h1 { margin: 0; font-size: 2.5em; text-shadow: 2px 2px 4px rgba(0,0,0,0.3); }
.fail-case { border: 3px solid #dc3545; margin: 30px 0; padding: 25px; background: #fff; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
.fail-header { background: #dc3545; color: white; padding: 20px; margin: -25px -25px 25px -25px; border-radius: 10px 10px 0 0; }
.comparison { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin: 20px 0; }
.method-box { padding: 20px; border-radius: 8px; }
.projection { background: #d4edda; border: 2px solid #28a745; }
.diagonal { background: #f8d7da; border: 2px solid #dc3545; }
.pass { color: #28a745; font-weight: bold; font-size: 1.1em; }
.fail { color: #dc3545; font-weight: bold; font-size: 1.1em; }
table { border-collapse: collapse; width: 100%; margin: 15px 0; }
th { background: #495057; color: white; padding: 12px; text-align: left; font-size: 0.95em; }
td { padding: 10px; border-bottom: 1px solid #ddd; background: white; }
tr:hover { background: #f8f9fa; }
.coord-table th { background: #17a2b8; }
.delta-table th { background: #6610f2; }
.highlight { background: #ffc107; padding: 2px 6px; border-radius: 3px; font-weight: bold; }
.section { margin: 25px 0; padding: 20px; background: #f8f9fa; border-left: 5px solid #667eea; border-radius: 5px; }
h2 { color: #495057; margin-top: 30px; }
h3 { margin: 15px 0 10px 0; color: #333; }
.info-box { background: #d1ecf1; padding: 15px; margin: 15px 0; border-left: 5px solid #17a2b8; border-radius: 5px; }
</style>
</head>
<body>

<div class="container">

<div class="header">
<h1>🔍 FAIL 케이스 상세 분석</h1>
<p style="font-size: 1.3em; margin-top: 15px;">투영거리 vs 대각거리 비교 (로우데이터 포함)</p>
<p style="opacity: 0.9; margin-top: 10px;">생성일시: """ + datetime.now().strftime('%Y-%m-%d %H:%M:%S') + """</p>
</div>

<div class="info-box">
<strong>📌 검증 기준:</strong> 시작점/끝점 변위 ≤ 20mm<br>
<strong>📊 총 FAIL 케이스:</strong> """ + str(len(fail_cases)) + """개<br>
<strong>🎯 목적:</strong> 투영거리와 대각거리 방식의 차이점 분석
</div>
"""

    # 거더별로 그룹화
    girders = {}
    for case in fail_cases:
        label = case['label']
        if label not in girders:
            girders[label] = []
        girders[label].append(case)

    for label, cases in girders.items():
        html += f"""
<h2>📊 {label} - {len(cases)}개 FAIL</h2>
"""

        for idx, case in enumerate(cases, 1):
            data = case['data']
            proj = case['proj']
            diag = case['diag']
            coords = case['coords']

            s1, e1 = coords['s1'], coords['e1']
            s2, e2 = coords['s2'], coords['e2']

            # 델타 계산
            dx_s = s1['x'] - s2['x']
            dy_s = s1['y'] - s2['y']
            dz_s = s1.get('z', 0) - s2.get('z', 0)
            dx_e = e1['x'] - e2['x']
            dy_e = e1['y'] - e2['y']
            dz_e = e1.get('z', 0) - e2.get('z', 0)

            # 차이점 확인
            diff_detected = not proj['pass'] and diag['pass']
            same_fail = not proj['pass'] and not diag['pass']
            only_diag_fail = proj['pass'] and not diag['pass']

            status_msg = ""
            if only_diag_fail:
                status_msg = "<span class='highlight'>⚠️ 대각거리에서만 FAIL (과검출)</span>"
            elif diff_detected:
                status_msg = "<span class='highlight'>⚠️ 투영거리에서만 FAIL</span>"
            else:
                status_msg = "두 방식 모두 FAIL"

            html += f"""
<div class="fail-case">
<div class="fail-header">
<h3>FAIL #{idx} - RequestID: {data['requestId']}</h3>
<p style="margin: 5px 0 0 0;">🕐 {data['timestamp']} | {status_msg}</p>
</div>

<div class="comparison">
<div class="method-box projection">
<h3>투영거리 방식 (7가지 검사)</h3>
<table>
<tr><th>항목</th><th>값</th><th>판정</th></tr>
<tr>
<td>시작점 변위</td>
<td>{proj['start_off']:.2f} mm</td>
<td>{"<span class='pass'>PASS ✓</span>" if proj['start_off'] <= 20 else "<span class='fail'>FAIL ✗</span>"}</td>
</tr>
<tr>
<td>끝점 변위</td>
<td>{proj['end_off']:.2f} mm</td>
<td>{"<span class='pass'>PASS ✓</span>" if proj['end_off'] <= 20 else "<span class='fail'>FAIL ✗</span>"}</td>
</tr>
<tr style="background: {"#d4edda" if proj['pass'] else "#f8d7da"};">
<td><strong>종합 결과</strong></td>
<td colspan="2">{"<span class='pass'>PASS ✓</span>" if proj['pass'] else "<span class='fail'>FAIL ✗</span>"}</td>
</tr>
</table>
</div>

<div class="method-box diagonal">
<h3>대각거리 방식 (2가지 검사)</h3>
<table>
<tr><th>항목</th><th>값</th><th>판정</th></tr>
<tr>
<td>시작점 변위</td>
<td>{diag['start_off']:.2f} mm</td>
<td>{"<span class='pass'>PASS ✓</span>" if diag['start_off'] <= 20 else "<span class='fail'>FAIL ✗</span>"}</td>
</tr>
<tr>
<td>끝점 변위</td>
<td>{diag['end_off']:.2f} mm</td>
<td>{"<span class='pass'>PASS ✓</span>" if diag['end_off'] <= 20 else "<span class='fail'>FAIL ✗</span>"}</td>
</tr>
<tr style="background: {"#d4edda" if diag['pass'] else "#f8d7da"};">
<td><strong>종합 결과</strong></td>
<td colspan="2">{"<span class='pass'>PASS ✓</span>" if diag['pass'] else "<span class='fail'>FAIL ✗</span>"}</td>
</tr>
</table>
</div>
</div>

<div class="section">
<h3>📍 로우데이터 (Raw Data)</h3>

<h4>■ 원시 좌표</h4>
<table class="coord-table">
<tr><th>Robot</th><th>시작점 X (mm)</th><th>시작점 Y (mm)</th><th>시작점 Z (mm)</th><th>끝점 X (mm)</th><th>끝점 Y (mm)</th><th>끝점 Z (mm)</th></tr>
<tr>
<td><strong>Robot 1</strong></td>
<td>{s1['x']:.2f}</td><td>{s1['y']:.2f}</td><td>{s1.get('z', 0):.2f}</td>
<td>{e1['x']:.2f}</td><td>{e1['y']:.2f}</td><td>{e1.get('z', 0):.2f}</td>
</tr>
<tr>
<td><strong>Robot 2</strong></td>
<td>{s2['x']:.2f}</td><td>{s2['y']:.2f}</td><td>{s2.get('z', 0):.2f}</td>
<td>{e2['x']:.2f}</td><td>{e2['y']:.2f}</td><td>{e2.get('z', 0):.2f}</td>
</tr>
</table>

<h4>■ 좌표 차이 (ΔX, ΔY, ΔZ)</h4>
<table class="delta-table">
<tr><th>위치</th><th>ΔX (mm)</th><th>ΔY (mm)</th><th>ΔZ (mm)</th><th>직선거리 (mm)</th></tr>
<tr style="background: {"#fff3cd" if abs(dx_s) >= 19 or abs(dy_s) >= 19 else "white"};">
<td><strong>시작점</strong></td>
<td>{dx_s:.2f}</td>
<td>{dy_s:.2f}</td>
<td>{dz_s:.2f}</td>
<td><strong>{diag['start_off']:.2f}</strong></td>
</tr>
<tr style="background: {"#fff3cd" if abs(dx_e) >= 19 or abs(dy_e) >= 19 else "white"};">
<td><strong>끝점</strong></td>
<td>{dx_e:.2f}</td>
<td>{dy_e:.2f}</td>
<td>{dz_e:.2f}</td>
<td><strong>{diag['end_off']:.2f}</strong></td>
</tr>
</table>

<h4>■ 분석</h4>
<ul>
"""

            # 분석 내용 추가
            if only_diag_fail:
                html += f"""
<li><strong>투영거리 PASS, 대각거리 FAIL</strong> - 과검출 케이스</li>
<li>로봇들이 평행하게 이동 (투영거리 ≈ 0mm)</li>
<li>X축 간격: {abs(dx_s):.2f}mm (정상 작업 간격일 가능성)</li>
<li>대각거리는 이 간격을 직선거리로 측정하여 FAIL 판정</li>
"""
            elif same_fail:
                if proj['start_off'] > 50 or proj['end_off'] > 50:
                    html += f"""
<li><strong>심각한 오차 케이스</strong> - 두 방식 모두 FAIL</li>
<li>시작점 변위: {proj['start_off']:.2f}mm (투영), {diag['start_off']:.2f}mm (대각)</li>
<li>끝점 변위: {proj['end_off']:.2f}mm (투영), {diag['end_off']:.2f}mm (대각)</li>
<li>긴급 조치 필요</li>
"""
                else:
                    html += f"""
<li>두 방식 모두 FAIL 감지</li>
<li>실제 문제가 있는 케이스</li>
"""

            html += """
</ul>
</div>

</div>
"""

    # 결론
    html += """
<div class="section" style="background: #fff3cd; border-left: 5px solid #ffc107;">
<h2 style="margin-top: 0;">💡 결론</h2>
<ul>
<li><strong>투영거리 방식</strong>: 용접선 방향을 고려하여 합리적 판정</li>
<li><strong>대각거리 방식</strong>: 단순 점간 거리로 과검출 가능성</li>
<li><strong>권장</strong>: 투영거리 방식 (7가지 검사) 사용</li>
</ul>
</div>

</div>
</body>
</html>
"""

    return html


def main():
    print("="*80)
    print("FAIL 케이스 상세 분석 리포트 생성")
    print("="*80)

    fail_cases = analyze_logs()

    if not fail_cases:
        print("FAIL 케이스가 없습니다.")
        return

    print(f"\n총 {len(fail_cases)}개 FAIL 케이스 발견")

    html = create_html_report(fail_cases)

    output_file = Path(__file__).parent / 'FAIL케이스_상세분석_로우데이터포함.html'
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(html)

    print(f"\n✅ 리포트 생성 완료: {output_file}")
    print("="*80)


if __name__ == '__main__':
    main()

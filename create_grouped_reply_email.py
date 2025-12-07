
import csv
import io
from datetime import datetime

def get_all_punch_list_items(csv_file_path):
    """CSV 파일에서 모든 펀치리스트 항목을 읽어옵니다."""
    all_items = []
    try:
        with open(csv_file_path, 'r', encoding='utf-8') as f:
            first_char = f.read(1)
            if first_char != '\ufeff':
                f.seek(0)
            
            header = [h.strip() for h in f.readline().split(',')]
            reader = csv.DictReader(f, fieldnames=header)
            
            for row in reader:
                if row.get('ID') and row.get('ID').strip():
                    all_items.append(row)
    except FileNotFoundError:
        print(f"오류: {csv_file_path} 파일을 찾을 수 없습니다.")
    except Exception as e:
        print(f"CSV 파일 읽기 중 오류 발생: {e}")
    return all_items

def create_grouped_reply_email():
    """담당자별로 그룹화하고 회신 양식을 포함한 이메일 HTML 생성"""
    
    target_recipients = ['이마룬', '박주한', '최광년', '이상주', '박기혁']
    target_recipients_set = set(target_recipients)

    all_action_items_from_log = {
        "PL-2025-112": "100 매크로 토치 회전속도 완화: 회전 속도 프로파일, 진행각 0도 포인트 제거, 갠트리 오프셋 수치 등 구체적인 적용 방법 공유를 요청합니다.",
        "PL-2025-113": "Z축 과부하(94번 부하 이관): 워밍업 루틴, 파라미터(25→30) 및 모터 리미트 변경, 모션 적용 관련 진행 상황 공유를 요청합니다.",
        "PL-2025-114": "용접 조건 DB 저장 후 UI 리프레시 에러(긴급): 재현 조건, 로그, 수정 및 배포 일정 공유를 요청합니다.",
        "PL-2025-115": "B라인 앵글 회피 거리(130→150mm) 상향: 파라미터 변경 범위, 대상 호기, 적용 일정 공유를 요청합니다.",
        "PL-2025-116": "노즐 클리닝 티칭 기능 추가(우선순위 낮음): 긴급/높음 이슈 우선 처리 후 진행 예정입니다. 구현 및 검증 계획 공유를 부탁드립니다.",
        "PL-2025-117": "스프레이 티칭 기능 추가(우선순위 낮음): 긴급/높음 이슈 우선 처리 후 진행 예정입니다. 구현 및 검증 계획 공유를 부탁드립니다.",
        "PL-2025-118": "스프레이 시간 변수화 및 UI 제어: 구현에 필요한 준비 사항(이마룬) 및 상세 요구/계획(박주한) 확인 후 공유 부탁드립니다.",
        "PL-2025-119": "터치 보정 정밀도 확인(완료): 완료된 작업에 대한 결과 공유를 요청합니다.",
        "PL-2025-120": "터치 모션 중 갠트리 Z축 고정: 조치 계획 공유를 요청합니다.",
        "PL-2025-121": "터치 모션 중 이동 오프셋 적용: 오프셋 계산 및 적용 방식에 대한 조치 계획 공유를 요청합니다.",
        "PL-2025-122": "에어건 설치: 12월 2일 부착 완료되었습니다. - 종결",
        "PL-2025-124": "B라인 1호기 DeviceNet 통신 상실: PLC 재부팅으로 임시 해제되었으나, 근본 원인 파악을 위해 ABB 답변 및 재발 방지 계획 공유가 필요합니다.",
        "PL-2025-125": "B라인 1호기 2번 용접기 모드 상실: 원인 분석, 복구 및 재발 방지 대책 공유를 요청합니다.",
        "PL-2025-126": "작업 취소/재개 시 속도 0% 설정 오류: 재현 조건, 수정 및 배포 계획 공유를 요청합니다.",
        "PL-2025-108": "상부 추락 방지 도어/보수 데크 열림 감지(완료): 최종 적용된 내용에 대한 확인을 요청합니다."
    }
    
    all_csv_items = get_all_punch_list_items('punchlist/펀치리스트점검251203-1_utf8.csv')
    
    # 담당자별로 미완료 항목을 그룹화
    grouped_items = {name: [] for name in target_recipients}
    
    for item in all_csv_items:
        status = item.get('상태', '').strip()
        if status == '완료':
            continue

        owners = {name.strip() for name in (item.get('담당자') or '').split(',') if name.strip()}
        
        # target_recipients에 포함된 담당자들의 목록만 처리
        for owner_name in owners.intersection(target_recipients_set):
            grouped_items[owner_name].append(item)

    html = f'''
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>펀치리스트 담당자별 업무 현황 및 회신 요청</title>
    <style>
        body {{ font-family: 'Malgun Gothic', '맑은 고딕', sans-serif; line-height: 1.6; color: #333; background-color: #f4f4f4; }}
        .container {{ width: 90%; max-width: 900px; margin: 20px auto; padding: 25px; border: 1px solid #ddd; border-radius: 10px; background-color: #ffffff; }}
        h1 {{ color: #2c3e50; border-bottom: 3px solid #3498db; padding-bottom: 10px; }}
        h2 {{ color: #2980b9; margin-top: 40px; margin-bottom: 20px; border-left: 5px solid #2980b9; padding-left: 10px;}}
        ul {{ list-style-type: none; padding-left: 0; }}
        li {{ background-color: #f8f9fa; border: 1px solid #e9ecef; border-left: 5px solid #f39c12; margin-bottom: 15px; padding: 15px 20px; border-radius: 5px; }}
        .pl-title {{ font-weight: bold; font-size: 1.1em; color: #2c3e50; }}
        .pl-id {{ font-size: 0.9em; color: #7f8c8d; margin-right: 10px; }}
        .pl-details p {{ margin: 5px 0; }}
        .log-highlight {{ background-color: #fffbe6; padding: 5px; border-radius: 3px; font-weight: bold; color: #8a6d3b;}}
        .reply-box {{ border: 1px dashed #ccc; padding: 15px; background-color: #fafafa; margin-top: 10px; color: #777; }}
        .footer {{ font-size: 0.8em; color: #95a5a6; text-align: center; margin-top: 30px; }}
    </style>
</head>
<body>
    <div class="container">
        <h1>펀치리스트 담당자별 업무 현황 (회신 필요)</h1>
        <p>
            <b>날짜:</b> {datetime.now().strftime('%Y-%m-%d')}<br>
            <b>수신:</b> {', '.join(target_recipients)}<br>
        </p>
        <p>안녕하세요.<br>담당하고 계신 미완료 펀치리스트 항목에 대해 진행 상황 및 계획을 아래 회신란에 맞춰 <strong>본 메일에 회신</strong> 부탁드립니다.</p>
    '''
    
    for owner_name, items in grouped_items.items():
        if not items:
            continue

        html += f'<h2>{owner_name} 님 담당 항목</h2><ul>'
        
        sorted_items = sorted(items, key=lambda x: x.get('ID',''))
        for item in sorted_items:
            pl_id = item.get('ID', '')
            title = item.get('제목', '제목 없음')
            status = item.get('상태', '상태 미지정')

            action_text = all_action_items_from_log.get(pl_id)
            
            html += f'<li>'
            html += f'''
                <span class="pl-id">[{pl_id}]</span>
                <span class="pl-title">{title}</span>
                <div class="pl-details">
                    <p><b>현재 상태:</b> {status}</p>
            '''
            
            if action_text:
                 html += f'<p><b>주요 검토 내용:</b> <span class="log-highlight">{action_text}</span></p>'
            else:
                 html += f'<p><b>요청 내용:</b> 일반 진행 상황 및 계획 공유를 요청합니다.</p>'

            html += '''
                    <div class="reply-box">
                        <p><strong>[회신 작성란]</strong></p>
                        <p><strong>진행 상황:</strong> </p>
                        <p><strong>조치 계획/일정:</strong> </p>
                        <p><strong>기타 협의사항:</strong> </p>
                    </div>
                '''
                
            html += '</div></li>'
        html += '</ul>'

    html += '''
        <p>감사합니다.</p>
        <p class="footer">* 본 메일은 펀치리스트 및 검토 로그를 기반으로 자동 생성되었습니다.</p>
    </div>
</body>
</html>
    '''
    return html

if __name__ == '__main__':
    output_html_path = 'punchlist_grouped_reply_email.html'
    email_content = create_grouped_reply_email()
    with open(output_html_path, 'w', encoding='utf-8') as f:
        f.write(email_content)
    print(f"'{output_html_path}' 파일에 이메일 초안을 저장했습니다.")

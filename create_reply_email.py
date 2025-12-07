
import csv
import io
import re
from datetime import datetime

def get_punch_list_details(csv_file_path, ids_to_include):
    """지정된 ID의 펀치리스트 상세 정보를 CSV 파일에서 읽어옵니다."""
    details = {}
    try:
        with open(csv_file_path, 'r', encoding='utf-8') as f:
            first_char = f.read(1)
            if first_char != '\ufeff':
                f.seek(0)
            
            header = [h.strip() for h in f.readline().split(',')]
            reader = csv.DictReader(f, fieldnames=header)
            
            for row in reader:
                row_id = row.get('ID')
                if row_id and row_id.strip() in ids_to_include:
                    details[row_id.strip()] = row
    except FileNotFoundError:
        return {}
    return details

def is_item_relevant(pl_id, action_text, csv_item_details, target_recipients_set):
    """펀치리스트 항목이 특정 수신자들에게 관련 있는지 확인합니다."""
    # 1. action_text에서 이름 추출 및 확인
    match_담당 = re.search(r'\(담당:\s*([^)]+)\)', action_text)
    if match_담당:
        names_in_action = [name.strip() for name in match_담당.group(1).split(',')]
        if any(name in target_recipients_set for name in names_in_action):
            return True

    # 2. csv_item_details의 '담당자' 필드 확인
    담당자_csv = (csv_item_details.get('담당자') or '').split(',')
    if any(name.strip() in target_recipients_set for name in 담당자_csv if name.strip()):
        return True

    # 3. csv_item_details의 '협의자' 필드 확인
    협의자_csv = (csv_item_details.get('협의자') or '').split(',')
    if any(name.strip() in target_recipients_set for name in 협의자_csv if name.strip()):
        return True
    
    return False

def create_reply_request_email():
    """회신 요청용 이메일 HTML 생성"""
    
    target_recipients = ['이마룬', '박주한', '최광년', '이상주', '박기혁']
    target_recipients_set = set(target_recipients)

    all_action_items = {
        "PL-2025-112": "100 매크로 토치 회전속도 완화: 회전 속도 프로파일, 진행각 0도 포인트 제거, 갠트리 오프셋 수치 등 구체적인 적용 방법 공유를 요청합니다. (담당: 최광년, 이마룬)",
        "PL-2025-113": "Z축 과부하(94번 부하 이관): 워밍업 루틴, 파라미터(25→30) 및 모터 리미트 변경, 모션 적용 관련 진행 상황 공유를 요청합니다. (담당: 최광년, 이마룬)",
        "PL-2025-114": "용접 조건 DB 저장 후 UI 리프레시 에러(긴급): 재현 조건, 로그, 수정 및 배포 일정 공유를 요청합니다. (담당: 박주한, 이마룬)",
        "PL-2025-115": "B라인 앵글 회피 거리(130→150mm) 상향: 파라미터 변경 범위, 대상 호기, 적용 일정 공유를 요청합니다. (담당: 최광년, 이마룬)",
        "PL-2025-116": "노즐 클리닝 티칭 기능 추가(우선순위 낮음): 긴급/높음 이슈 우선 처리 후 진행 예정입니다. 구현 및 검증 계획 공유를 부탁드립니다. (담당: 최광년, 이마룬)",
        "PL-2025-117": "스프레이 티칭 기능 추가(우선순위 낮음): 긴급/높음 이슈 우선 처리 후 진행 예정입니다. 구현 및 검증 계획 공유를 부탁드립니다. (담당: 최광년, 이마룬)",
        "PL-2025-118": "스프레이 시간 변수화 및 UI 제어: 구현에 필요한 준비 사항(이마룬) 및 상세 요구/계획(박주한) 확인 후 공유 부탁드립니다.",
        "PL-2025-119": "터치 보정 정밀도 확인(완료): 완료된 작업에 대한 결과 공유를 요청합니다. (담당: 최광년, 이마룬)",
        "PL-2025-120": "터치 모션 중 갠트리 Z축 고정: 조치 계획 공유를 요청합니다. (담당: 이마룬)",
        "PL-2025-121": "터치 모션 중 이동 오프셋 적용: 오프셋 계산 및 적용 방식에 대한 조치 계획 공유를 요청합니다. (담당: 이마룬)",
        "PL-2025-122": "에어건 설치: 12월 2일 부착 완료되었습니다. (담당: 박기혁, 심태양) - 종결",
        "PL-2025-123": "메인 에어 압력 게이지 조립 불량: 조치 계획 확인 및 공유 부탁드립니다. (담당: 심태양)",
        "PL-2025-124": "B라인 1호기 DeviceNet 통신 상실: PLC 재부팅으로 임시 해제되었으나, 근본 원인 파악을 위해 ABB 답변 및 재발 방지 계획 공유가 필요합니다. (담당: 최광년, 이마룬)",
        "PL-2025-125": "B라인 1호기 2번 용접기 모드 상실: 원인 분석, 복구 및 재발 방지 대책 공유를 요청합니다. (담당: 최광년, 이마룬)",
        "PL-2025-126": "작업 취소/재개 시 속도 0% 설정 오류: 재현 조건, 수정 및 배포 계획 공유를 요청합니다. (담당: 박주한, 이마룬)",
        "PL-2025-108": "상부 추락 방지 도어/보수 데크 열림 감지(완료): 최종 적용된 내용에 대한 확인을 요청합니다. (담당: 이상주, 박주한, 이마룬)",
        "PL-2025-109": "Weld↔Robot LAN 케이블 노이즈: 임시 배선 상태입니다. 후렉시블 처리 및 분리 경로 변경 계획과 일정 공유를 요청합니다. (담당: 이상주, 이동혁)",
        "PL-2025-103": "겐트리 A/B 라인 호기 구분 명판 요청(신규, 낮음): 제작 및 부착 일정 공유 부탁드립니다. (담당: 심태양)"
    }
    
    csv_details_all = get_punch_list_details('punchlist/펀치리스트점검251203-1_utf8.csv', all_action_items.keys())
    
    filtered_action_items = {}
    for pl_id, action_text in all_action_items.items():
        if pl_id in csv_details_all and is_item_relevant(pl_id, action_text, csv_details_all[pl_id], target_recipients_set):
            filtered_action_items[pl_id] = action_text
            
    html = f'''
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>펀치리스트 후속 조치 요청 및 회신</title>
    <style>
        body {{ font-family: 'Malgun Gothic', '맑은 고딕', sans-serif; line-height: 1.6; color: #333; background-color: #f4f4f4; }}
        .container {{ width: 90%; max-width: 900px; margin: 20px auto; padding: 25px; border: 1px solid #ddd; border-radius: 10px; background-color: #ffffff; }}
        h1 {{ color: #2c3e50; border-bottom: 3px solid #3498db; padding-bottom: 10px; }}
        h2 {{ color: #2980b9; margin-top: 30px; }}
        ul {{ list-style-type: none; padding-left: 0; }}
        li {{ background-color: #f8f9fa; border-left: 5px solid #3498db; margin-bottom: 15px; padding: 15px 20px; border-radius: 5px; }}
        .pl-title {{ font-weight: bold; font-size: 1.1em; color: #2c3e50; }}
        .pl-id {{ font-size: 0.9em; color: #7f8c8d; margin-right: 10px; }}
        .pl-details p {{ margin: 5px 0; }}
        textarea {{ width: 98%; height: 60px; margin-top: 10px; border: 1px solid #ccc; border-radius: 4px; padding: 8px; font-size: 14px; font-family: inherit; }}
        .action-needed {{ border-left-color: #f39c12; }}
        .completed {{ border-left-color: #2ecc71; }}
        .footer {{ font-size: 0.8em; color: #95a5a6; text-align: center; margin-top: 30px; }}
    </style>
</head>
<body>
    <div class="container">
        <h1>펀치리스트 후속 조치 요청 (회신 필요)</h1>
        <p>
            <b>날짜:</b> {datetime.now().strftime('%Y-%m-%d')}<br>
            <b>수신:</b> {', '.join(target_recipients)}<br>
        </p>
        <p>안녕하세요.<br>아래 항목에 대해 진행 상황 및 계획을 작성하시어 <strong>본 메일에 회신</strong> 부탁드립니다.</p>
        
        <h2>담당자별 요청 항목</h2>
        <ul>
    '''
    
    reply_needed_keywords = ['공유', '확인', '일정', '계획']
    
    sorted_ids = sorted(filtered_action_items.keys())
    
    if not filtered_action_items:
        html += "<li>현재 담당자님께 해당하는 요청 사항이 없습니다.</li>"
    
    for pl_id in sorted_ids:
        action_text = filtered_action_items[pl_id]
        details = csv_details_all.get(pl_id, {})
        
        title = details.get('제목', '제목 없음')
        status = details.get('상태', '상태 미지정')
        owner = details.get('담당자', '담당자 미지정')
        
        is_completed = '완료' in status or '종결' in action_text
        needs_reply = any(keyword in action_text for keyword in reply_needed_keywords) and not is_completed
        
        li_class = 'completed' if is_completed else 'action-needed' if needs_reply else ''

        html += f'<li class="{li_class}">'
        html += f'''
            <span class="pl-id">[{pl_id}]</span>
            <span class="pl-title">{title}</span>
            <div class="pl-details">
                <p><b>요청 내용:</b> {action_text}</p>
                <p><b>현재 상태:</b> {status} / <b>담당자:</b> {owner}</p>
        '''
        
        if needs_reply:
            html += '''
                <p><b>진행상황 / 계획 회신:</b></p>
                <textarea placeholder="이곳에 진행 상황, 계획, 일정 등을 작성하여 회신해주세요."></textarea>
            '''
            
        html += '</div></li>'
    
    html += '''
        </ul>
        <p>감사합니다.</p>
        <p class="footer">* 본 메일은 펀치리스트 검토 로그를 기반으로 자동 생성되었습니다.</p>
    </div>
</body>
</html>
    '''
    return html

if __name__ == '__main__':
    output_html_path = 'punchlist_reply_request_email.html'
    email_content = create_reply_request_email()
    with open(output_html_path, 'w', encoding='utf-8') as f:
        f.write(email_content)
    print(f"'{output_html_path}' 파일에 이메일 초안을 저장했습니다.")

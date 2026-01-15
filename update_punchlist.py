
import csv
import re
import datetime

def escape_js_string(value):
    """Escapes a string for use in JavaScript."""
    return value.replace('\\', '\\\\').replace('"', '\"').replace('\n', '\\n').replace('\r', '')

def get_update_info(modification_date_str, today_str):
    """Determines if an item is updated and provides a reason."""
    try:
        # 수정일이 '오늘' 날짜와 같은 경우 업데이트된 것으로 간주
        mod_date = datetime.datetime.fromisoformat(modification_date_str.replace('Z', '+00:00')).date()
        today_date = datetime.datetime.strptime(today_str, '%y%m%d').date()
        
        if mod_date >= today_date:
            return True, "최신 데이터"
        
        # 수정일과 생성일이 다른 경우 업데이트된 것으로 간주
        # creation_date_str = row['생성일시']
        # creation_date = datetime.datetime.fromisoformat(creation_date_str.replace('Z', '+00:00')).date()
        # if mod_date != creation_date:
        #     return True, "내용 변경"

    except (ValueError, KeyError):
        pass
        
    return False, ""


def create_js_object(row, today_str):
    """Creates a JavaScript object string from a CSV row."""
    # 필수 필드 확인
    required_fields = ['ID', '분류', '담당자', '제목', '상태', '수정일시']
    if not all(field in row and row[field] for field in required_fields):
        return None

    item_id = escape_js_string(row['ID'])
    category = escape_js_string(row['분류'])
    owner = escape_js_string(row['담당자'])
    description = escape_js_string(row['제목'])
    status = escape_js_string(row['상태'])
    
    mod_date_str = row['수정일시']

    updated, reason = get_update_info(mod_date_str, today_str)

    # 담당자가 여러 명일 경우 첫 번째 담당자만 선택
    owner = owner.split(',')[0].strip()

    return (
        f'        {{'
        f'id: "{item_id}", ' 
        f'cat: "{category}", ' 
        f'owner: "{owner}", ' 
        f'desc: "{description}", ' 
        f'status: "{status}", ' 
        f'updated: {str(updated).lower()}, ' 
        f'updateReason: "{reason}"' 
        f'}}'
    )

def main():
    csv_file_path = 'punchlist/260115_펀치리스트정리/S25016_펀치리스트_260115최신.csv'
    html_file_path = 'punchlist/260115_펀치리스트정리/펀치리스트점검(260113).html'
    output_html_path = 'punchlist/260115_펀치리스트정리/펀치리스트점검(260115).html'
    
    today_str = '260115' # 데이터 기준일

    punch_list_js = []
    try:
        with open(csv_file_path, mode='r', encoding='utf-8') as csvfile:
            reader = csv.DictReader(csvfile)
            for row in reader:
                js_obj = create_js_object(row, today_str)
                if js_obj:
                    punch_list_js.append(js_obj)
    except FileNotFoundError:
        print(f"Error: CSV file not found at {csv_file_path}")
        return
    except Exception as e:
        print(f"An error occurred while reading the CSV file: {e}")
        return

    js_code = "const punchList = [\n" + ",\n".join(punch_list_js) + "\n    ];"

    try:
        with open(html_file_path, mode='r', encoding='utf-8') as htmlfile:
            content = htmlfile.read()
    except FileNotFoundError:
        print(f"Error: HTML file not found at {html_file_path}")
        return
    except Exception as e:
        print(f"An error occurred while reading the HTML file: {e}")
        return

    # 'punchList' 배열 교체
    content = re.sub(
        r'const punchList = \[.*?\].*;',
        js_code,
        content,
        flags=re.DOTALL
    )
    
    # 날짜 업데이트
    today_formatted = f"{today_str[:2]}.{today_str[2:4]}.{today_str[4:]}"
    content = re.sub(
        r'\(데이터 기준: [0-9.]+\)',
        f'(데이터 기준: {today_formatted})',
        content
    )
    # <h2> 태그 안의 날짜만 변경
    content = re.sub(
        r'(<span class="last-update">)\(데이터 기준: [0-9.]+\)(</span>)',
        f'\1(데이터 기준: {today_formatted})\2',
        content
    )

    try:
        with open(output_html_path, mode='w', encoding='utf-8') as htmlfile:
            htmlfile.write(content)
        print(f"Successfully updated and created '{output_html_path}'")
    except Exception as e:
        print(f"An error occurred while writing the new HTML file: {e}")

if __name__ == '__main__':
    main()

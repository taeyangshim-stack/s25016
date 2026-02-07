#!/usr/bin/env python3
"""
용접선 데이터 필드 정의
로그에서 추출 가능한 모든 필드와 경로 정의
"""

from typing import Any, Callable, Optional


class FieldDefinition:
    """필드 정의 클래스"""

    def __init__(
        self,
        name: str,
        path: str,
        description: str,
        robot_index: Optional[int] = None,
        formatter: Optional[Callable] = None,
        default: Any = None
    ):
        self.name = name                    # CSV 컬럼명
        self.path = path                    # JSON 경로 (점 표기법)
        self.description = description      # 설명
        self.robot_index = robot_index      # Robot 인덱스 (0 또는 1)
        self.formatter = formatter          # 값 포맷팅 함수
        self.default = default              # 기본값


# 모든 사용 가능한 필드 정의
ALL_FIELDS = {
    # ========== 기본 정보 ==========
    'requestId': FieldDefinition(
        name='requestId',
        path='request.requestId',
        description='요청 ID'
    ),
    'timestamp': FieldDefinition(
        name='timestamp',
        path='_timestamp',  # 특수 필드
        description='날짜시간'
    ),
    '호기정보': FieldDefinition(
        name='호기정보',
        path='_girder',  # 특수 필드 (메타데이터에서)
        description='거더 정보'
    ),
    'targetGantryId': FieldDefinition(
        name='targetGantryId',
        path='targetGantryId',
        description='대상 갠트리 ID'
    ),

    # ========== Robot 1 필드 ==========
    # 시작점 좌표
    'startX1': FieldDefinition(
        name='startX1',
        path='weldJobs.weldLine.startPointPosition.x',
        description='Robot 1 시작점 X 좌표',
        robot_index=0,
        formatter=lambda x: round(x, 3)
    ),
    'startY1': FieldDefinition(
        name='startY1',
        path='weldJobs.weldLine.startPointPosition.y',
        description='Robot 1 시작점 Y 좌표',
        robot_index=0,
        formatter=lambda x: round(x, 3)
    ),
    'startZ1': FieldDefinition(
        name='startZ1',
        path='weldJobs.weldLine.startPointPosition.z',
        description='Robot 1 시작점 Z 좌표',
        robot_index=0,
        formatter=lambda x: round(x, 3)
    ),

    # 끝점 좌표
    'endX1': FieldDefinition(
        name='endX1',
        path='weldJobs.weldLine.endPointPosition.x',
        description='Robot 1 끝점 X 좌표',
        robot_index=0,
        formatter=lambda x: round(x, 3)
    ),
    'endY1': FieldDefinition(
        name='endY1',
        path='weldJobs.weldLine.endPointPosition.y',
        description='Robot 1 끝점 Y 좌표',
        robot_index=0,
        formatter=lambda x: round(x, 3)
    ),
    'endZ1': FieldDefinition(
        name='endZ1',
        path='weldJobs.weldLine.endPointPosition.z',
        description='Robot 1 끝점 Z 좌표',
        robot_index=0,
        formatter=lambda x: round(x, 3)
    ),

    # 두께 및 용접 정보
    'startThickness1': FieldDefinition(
        name='startThickness1',
        path='weldJobs.weldLine.startPointPosition.filletThinkness',
        description='Robot 1 시작점 두께',
        robot_index=0
    ),
    'endThickness1': FieldDefinition(
        name='endThickness1',
        path='weldJobs.weldLine.endPointPosition.filletThinkness',
        description='Robot 1 끝점 두께',
        robot_index=0
    ),
    'length1': FieldDefinition(
        name='length1',
        path='weldJobs.weldLine.length',
        description='Robot 1 용접선 길이',
        robot_index=0,
        formatter=lambda x: round(x, 3)
    ),
    'weldingLeg1': FieldDefinition(
        name='weldingLeg1',
        path='weldJobs.weldLine.angularDimension',
        description='Robot 1 각도 치수 (용접 레그)',
        robot_index=0,
        formatter=lambda x: round(x, 1)
    ),

    # 추가 정보
    'workAngle1': FieldDefinition(
        name='workAngle1',
        path='weldJobs.weldLine.startPointPosition.workAngle',
        description='Robot 1 작업 각도',
        robot_index=0
    ),
    'weldingMacroType1': FieldDefinition(
        name='weldingMacroType1',
        path='weldJobs.weldLine.weldingMacroType',
        description='Robot 1 용접 매크로 타입',
        robot_index=0
    ),
    'macroNumber1': FieldDefinition(
        name='macroNumber1',
        path='weldJobs.weldLine.macroNumber',
        description='Robot 1 매크로 번호',
        robot_index=0
    ),
    'installationDirection1': FieldDefinition(
        name='installationDirection1',
        path='weldJobs.weldLine.installationDirection',
        description='Robot 1 설치 방향',
        robot_index=0
    ),
    'weldLineId1': FieldDefinition(
        name='weldLineId1',
        path='weldJobs.weldLine.weldLineId',
        description='Robot 1 용접선 ID',
        robot_index=0
    ),
    'gantryId1': FieldDefinition(
        name='gantryId1',
        path='weldJobs.weldLine.gantryId',
        description='Robot 1 갠트리 ID',
        robot_index=0
    ),
    'robotId1': FieldDefinition(
        name='robotId1',
        path='weldJobs.weldLine.robotId',
        description='Robot 1 로봇 ID',
        robot_index=0
    ),
    'weldMode1': FieldDefinition(
        name='weldMode1',
        path='weldJobs.weldLine.weldMode',
        description='Robot 1 용접 모드',
        robot_index=0
    ),

    # ========== Robot 2 필드 (Robot 1과 동일 구조) ==========
    'startX2': FieldDefinition(
        name='startX2',
        path='weldJobs.weldLine.startPointPosition.x',
        description='Robot 2 시작점 X 좌표',
        robot_index=1,
        formatter=lambda x: round(x, 3)
    ),
    'startY2': FieldDefinition(
        name='startY2',
        path='weldJobs.weldLine.startPointPosition.y',
        description='Robot 2 시작점 Y 좌표',
        robot_index=1,
        formatter=lambda x: round(x, 3)
    ),
    'startZ2': FieldDefinition(
        name='startZ2',
        path='weldJobs.weldLine.startPointPosition.z',
        description='Robot 2 시작점 Z 좌표',
        robot_index=1,
        formatter=lambda x: round(x, 3)
    ),
    'endX2': FieldDefinition(
        name='endX2',
        path='weldJobs.weldLine.endPointPosition.x',
        description='Robot 2 끝점 X 좌표',
        robot_index=1,
        formatter=lambda x: round(x, 3)
    ),
    'endY2': FieldDefinition(
        name='endY2',
        path='weldJobs.weldLine.endPointPosition.y',
        description='Robot 2 끝점 Y 좌표',
        robot_index=1,
        formatter=lambda x: round(x, 3)
    ),
    'endZ2': FieldDefinition(
        name='endZ2',
        path='weldJobs.weldLine.endPointPosition.z',
        description='Robot 2 끝점 Z 좌표',
        robot_index=1,
        formatter=lambda x: round(x, 3)
    ),
    'startThickness2': FieldDefinition(
        name='startThickness2',
        path='weldJobs.weldLine.startPointPosition.filletThinkness',
        description='Robot 2 시작점 두께',
        robot_index=1
    ),
    'endThickness2': FieldDefinition(
        name='endThickness2',
        path='weldJobs.weldLine.endPointPosition.filletThinkness',
        description='Robot 2 끝점 두께',
        robot_index=1
    ),
    'length2': FieldDefinition(
        name='length2',
        path='weldJobs.weldLine.length',
        description='Robot 2 용접선 길이',
        robot_index=1,
        formatter=lambda x: round(x, 3)
    ),
    'weldingLeg2': FieldDefinition(
        name='weldingLeg2',
        path='weldJobs.weldLine.angularDimension',
        description='Robot 2 각도 치수 (용접 레그)',
        robot_index=1,
        formatter=lambda x: round(x, 1)
    ),
    'workAngle2': FieldDefinition(
        name='workAngle2',
        path='weldJobs.weldLine.startPointPosition.workAngle',
        description='Robot 2 작업 각도',
        robot_index=1
    ),
    'weldingMacroType2': FieldDefinition(
        name='weldingMacroType2',
        path='weldJobs.weldLine.weldingMacroType',
        description='Robot 2 용접 매크로 타입',
        robot_index=1
    ),
    'macroNumber2': FieldDefinition(
        name='macroNumber2',
        path='weldJobs.weldLine.macroNumber',
        description='Robot 2 매크로 번호',
        robot_index=1
    ),
    'installationDirection2': FieldDefinition(
        name='installationDirection2',
        path='weldJobs.weldLine.installationDirection',
        description='Robot 2 설치 방향',
        robot_index=1
    ),
    'weldLineId2': FieldDefinition(
        name='weldLineId2',
        path='weldJobs.weldLine.weldLineId',
        description='Robot 2 용접선 ID',
        robot_index=1
    ),
    'gantryId2': FieldDefinition(
        name='gantryId2',
        path='weldJobs.weldLine.gantryId',
        description='Robot 2 갠트리 ID',
        robot_index=1
    ),
    'robotId2': FieldDefinition(
        name='robotId2',
        path='weldJobs.weldLine.robotId',
        description='Robot 2 로봇 ID',
        robot_index=1
    ),
    'weldMode2': FieldDefinition(
        name='weldMode2',
        path='weldJobs.weldLine.weldMode',
        description='Robot 2 용접 모드',
        robot_index=1
    ),
}


# 프리셋 정의
PRESETS = {
    'full': list(ALL_FIELDS.keys()),

    'basic': [
        'requestId', '호기정보', 'timestamp',
        'startX1', 'startY1', 'startZ1',
        'endX1', 'endY1', 'endZ1',
        'startX2', 'startY2', 'startZ2',
        'endX2', 'endY2', 'endZ2'
    ],

    'coordinates': [
        'requestId',
        'startX1', 'startY1', 'startZ1',
        'endX1', 'endY1', 'endZ1',
        'startX2', 'startY2', 'startZ2',
        'endX2', 'endY2', 'endZ2'
    ],

    'image_format': [
        'requestId', '호기정보',
        'startX1', 'startY1', 'startZ1',
        'endX1', 'endY1', 'endZ1',
        'startThickness1', 'endThickness1',
        'length1', 'weldingLeg1',
        'startX2', 'startY2', 'startZ2',
        'endX2', 'endY2', 'endZ2',
        'startThickness2', 'endThickness2',
        'length2', 'weldingLeg2'
    ]
}


def get_field_groups():
    """필드를 그룹별로 반환"""
    return {
        '기본 정보': [
            'requestId', 'timestamp', '호기정보', 'targetGantryId'
        ],
        'Robot 1 좌표': [
            'startX1', 'startY1', 'startZ1',
            'endX1', 'endY1', 'endZ1'
        ],
        'Robot 1 용접 정보': [
            'startThickness1', 'endThickness1',
            'length1', 'weldingLeg1', 'workAngle1'
        ],
        'Robot 1 추가 정보': [
            'weldingMacroType1', 'macroNumber1',
            'installationDirection1', 'weldLineId1',
            'gantryId1', 'robotId1', 'weldMode1'
        ],
        'Robot 2 좌표': [
            'startX2', 'startY2', 'startZ2',
            'endX2', 'endY2', 'endZ2'
        ],
        'Robot 2 용접 정보': [
            'startThickness2', 'endThickness2',
            'length2', 'weldingLeg2', 'workAngle2'
        ],
        'Robot 2 추가 정보': [
            'weldingMacroType2', 'macroNumber2',
            'installationDirection2', 'weldLineId2',
            'gantryId2', 'robotId2', 'weldMode2'
        ]
    }

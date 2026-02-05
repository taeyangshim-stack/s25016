MODULE Head_Data
! ========================================
! T_Head Data Module (v1.9.40)
! ========================================
! Purpose: Upper system interface variables for T_Head command dispatcher
! PlanA reference: Head_Data.mod (TASK8)
! Cross-task PERS sharing: same-name PERS in ConfigModule (TASK1) auto-sync
! ========================================

! ========================================
! RECORD Definitions (identical to ConfigModule for PERS sharing)
! ========================================

! Torch Motion Data Structure (22 fields - PlanA compatible)
RECORD torchmotion
    num No;               ! Sequence number
    num LengthOffset;     ! Weld direction offset (mm)
    num BreadthOffset;    ! Perpendicular offset (mm)
    num HeightOffset;     ! Height offset (mm) - multi-pass Z shift
    num WorkingAngle;     ! Working angle (deg) - RelTool \Ry
    num TravelAngle;      ! Travel angle (deg) - RelTool \Rx
    num WeldingSpeed;     ! Weld speed (mm/s)
    num Schedule;         ! Weld schedule number
    num Voltage;          ! Arc voltage (V)
    num FeedingSpeed;     ! Wire feed speed (mm/s)
    num Current;          ! Weld current (A)
    num WeaveShape;       ! Weave shape (0=none)
    num WeaveType;        ! Weave type
    num WeaveLength;      ! Weave cycle length (mm)
    num WeaveWidth;       ! Weave width (mm)
    num WeaveDwellLeft;   ! Left dwell time (ms)
    num WeaveDwellRight;  ! Right dwell time (ms)
    num TrackType;        ! Track type (0=none)
    num TrackGainY;       ! Y tracking gain
    num TrackGainZ;       ! Z tracking gain
    num MaxCorr;          ! Max correction (mm)
    num Bias;             ! Bias
ENDRECORD

! Edge Point Data Structure (7 fields)
RECORD edgedata
    pos EdgePos;           ! X, Y, Z coordinates (Floor)
    num Height;            ! Part edge height (mm)
    num Breadth;           ! Part edge width (mm)
    num HoleSize;          ! Reference hole diameter (mm)
    num Thickness;         ! Material thickness (mm)
    num AngleHeight;       ! Angle measurement point height (mm)
    num AngleWidth;        ! Angle measurement point width (mm)
ENDRECORD

! ========================================
! Command Interface (shared PERS with ConfigModule)
! ========================================
! Upper system writes nCmdInput, T_Head echoes nCmdOutput
! Upper system confirms with nCmdMatch (1=OK, -1=error)
PERS num nCmdInput := 0;
PERS num nCmdOutput := 0;
PERS num nCmdMatch := 0;

! ========================================
! Command Constants (PlanA compatible)
! ========================================
! Movement (100 series)
CONST num CMD_MOVE_TO_WORLDHOME := 101;
CONST num CMD_MOVE_TO_MEASUREMENTHOME := 102;
CONST num CMD_MOVE_TO_TEACHING_All := 104;    ! v1.9.40 - PlanA
CONST num CMD_MOVE_TO_TEACHING_R1 := 105;
CONST num CMD_MOVE_TO_TEACHING_R2 := 106;
CONST num CMD_MOVE_JOINTS := 107;              ! v1.9.40 - PlanA
CONST num CMD_MOVE_ABS_GANTRY := 108;
CONST num CMD_MOVE_INC_GANTRY := 109;
CONST num CMD_MOVE_TO_ZHOME := 110;
CONST num CMD_MOVE_TO_WARMUP := 112;

! Welding (200 series)
CONST num CMD_WELD := 200;
CONST num CMD_WELD_MOTION := 201;
CONST num CMD_WELD_CORR := 202;
CONST num CMD_WELD_MOTION_CORR := 203;
CONST num CMD_WELD_MM := 204;
CONST num CMD_WELD_MOTION_MM := 205;
CONST num CMD_WELD_CORR_MM := 206;
CONST num CMD_WELD_MOTION_CORR_MM := 207;
CONST num CMD_EDGE_WELD := 210;

! Camera (300 series)
CONST num CMD_CAMERA_DOOR_OPEN := 301;
CONST num CMD_CAMERA_DOOR_CLOSE := 302;
CONST num CMD_CAMERA_BLOW_ON := 303;
CONST num CMD_CAMERA_BLOW_OFF := 304;
! Individual camera control (v1.9.40 - PlanA)
CONST num CMD_CAMERA1_DOOR_OPEN := 311;
CONST num CMD_CAMERA1_DOOR_CLOSE := 312;
CONST num CMD_CAMERA1_BLOW_ON := 313;
CONST num CMD_CAMERA1_BLOW_OFF := 314;
CONST num CMD_CAMERA2_DOOR_OPEN := 321;
CONST num CMD_CAMERA2_DOOR_CLOSE := 322;
CONST num CMD_CAMERA2_BLOW_ON := 323;
CONST num CMD_CAMERA2_BLOW_OFF := 324;

! Wire (500 series)
CONST num CMD_WIRE_CUT := 501;
CONST num CMD_WIRE_CLEAN := 502;
CONST num CMD_WIRE_BULLSEYE_CHECK := 505;    ! v1.9.40 - PlanA
CONST num CMD_WIRE_BULLSEYE_UPDATE := 506;   ! v1.9.40 - PlanA
CONST num CMD_WIRE_ReplacementMode := 507;   ! v1.9.40 - PlanA
CONST num CMD_ROB1_WIRE_CUT := 511;
CONST num CMD_ROB2_WIRE_CUT := 512;

! Inspection (600 series)
CONST num CMD_HOLE_CHECK := 601;
CONST num CMD_LDS_CHECK := 602;

! Test/Debug (900 series)
CONST num CMD_TEST_MENU := 900;
CONST num CMD_TEST_SINGLE := 901;
CONST num CMD_TEST_ROTATION := 902;
CONST num CMD_TEST_MODE2 := 903;

! ========================================
! stCommand/stReact Protocol (v1.9.39 - PlanA style)
! ========================================
! T_Head sets stCommand, TASK1/2 respond via stReact
! stReact{1} = T_ROB1 status, stReact{2} = T_ROB2 status
! States: "" (init), "Ready" (waiting), "Ack" (done)
PERS string stCommand := "";
PERS string stReact{2} := ["",""];

! ========================================
! Mode Flags (PlanA compatible)
! ========================================
! T_Head sets these before dispatching weld commands
PERS bool bEnableWeldSkip := FALSE;         ! Skip arc welding (motion only)
PERS bool bEnableManualMacro := FALSE;      ! Use manual macro arrays
PERS bool bEnableStartEndPointCorr := FALSE; ! Enable start/end point correction
PERS bool bWeldOutputDisable := TRUE;       ! Safety: disable weld output

! ========================================
! Motion Status (shared with upper system)
! ========================================
PERS bool bMotionWorking := FALSE;
PERS bool bMotionFinish := TRUE;

! ========================================
! Macro Buffers (shared PERS - same as ConfigModule)
! ========================================
PERS torchmotion macroStartBuffer1{10} := [
    [1,0,0,0, 0,0,100,0, 36.5,230,380, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0]];
PERS torchmotion macroEndBuffer1{10} := [
    [1,0,0,0, 0,0,100,0, 36.5,230,380, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0]];
PERS torchmotion macroStartBuffer2{10} := [
    [1,0,0,0, 0,0,100,0, 36.5,230,380, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0]];
PERS torchmotion macroEndBuffer2{10} := [
    [1,0,0,0, 0,0,100,0, 36.5,230,380, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0],
    [0,0,0,0, 0,0,0,0, 0,0,0, 0,0,0,0,0,0, 0,0,0,0,0]];

! Number of active weld passes
PERS num nWeldPassCount := 1;

! Arc welding enable flag
PERS bool WELD_ARC_ENABLED := FALSE;

! ========================================
! Edge Data (shared PERS - same as ConfigModule)
! ========================================
PERS edgedata edgeStart{2} := [
    [[5000, 5100, 500], 50, 50, 50, 12, 0, 0],
    [[5000, 4900, 500], 50, 50, 50, 12, 0, 0]
];
PERS edgedata edgeEnd{2} := [
    [[5500, 5100, 500], 50, 50, 50, 12, 0, 0],
    [[5500, 4900, 500], 50, 50, 50, 12, 0, 0]
];

! ========================================
! Gantry Position (shared PERS)
! ========================================
PERS extjoint extGantryPos := [0, 0, 0, 0, 0, 0];

ENDMODULE

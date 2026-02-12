MODULE ConfigModule
! ========================================
! S25016 SpGantry Configuration Module
! ========================================
! Version: v1.9.40
! Date: 2026-02-06
! Purpose: Centralized configuration using PERS variables
! v1.9.0: Added weld sequence configuration
! v1.9.1: Fixed R-axis (X+=0°), added WObj positions, 45° torch
! v2.0.0: Added Edge points and Home/Limit configuration
! v2.1.0: Added PlanA-style command interface (nCmdInput/nCmdOutput)
! v2.2.0: Added PlanA data structures (edgedata, targetdata, corrorder)
! v1.9.40: PlanA-PlanB variable integration complete
!   - Changed variable names to PlanA style (nLimitX_Negative, etc.)
!   - Added dual HOME variables (internal + UI interface)
!   - Added RECORDs: breakpoint, jointgroup, pointgroup, monRobs
!   - Added ~50 new PERS variables (bRobSwap, nRobHeight*, etc.)
!   - Added CMD constants (104, 107, 311-324, 505-507)
!   - Added 40-step welddata/weavedata/trackdata arrays
!   - Added stCommand/stReact for T_Head communication
! ========================================

! ========================================
! Data Type Definitions (v1.9.40 - PlanA Complete)
! ========================================

! Breakpoint Data Structure (PlanA)
RECORD breakpoint
    pos Position;
    num Angle;
ENDRECORD

! Joint Group Data Structure (PlanA - 3-axis sync)
RECORD jointgroup
    jointtarget Joint1;
    jointtarget Joint2;
    jointtarget JointG;
ENDRECORD

! Point Group Data Structure (PlanA)
RECORD pointgroup
    robtarget Point1;
    robtarget Point2;
    robtarget PointG;
ENDRECORD

! Robot Monitor Data Structure (PlanA)
RECORD monRobs
    extjoint monExt;
    robjoint monJoint1;
    robjoint monJoint2;
    pose monPose1;
    pose monPose2;
ENDRECORD

! Edge Point Data Structure
! Contains position, geometry, and material information for weld edges
RECORD edgedata
    pos EdgePos;           ! X, Y, Z coordinates (Floor)
    num Height;            ! Part edge height (mm)
    num Breadth;           ! Part edge width (mm)
    num HoleSize;          ! Reference hole diameter (mm)
    num Thickness;         ! Material thickness (mm)
    num AngleHeight;       ! Angle measurement point height (mm)
    num AngleWidth;        ! Angle measurement point width (mm)
ENDRECORD

! Weld Target Data Structure (per step)
! Contains position and welding parameters for each motion step
RECORD targetdata
    robtarget position;    ! TCP position and orientation
    num cpm;               ! Arc current mode/preset
    num schedule;          ! Weld schedule number
    num voltage;           ! Arc voltage (V)
    num wfs;               ! Wire feed speed (m/min)
    num Current;           ! Weld current (A)
    num WeaveShape;        ! Weave pattern shape (0-5)
    num WeaveType;         ! Weave type (1-5)
    num WeaveLength;       ! Weave cycle length (mm)
    num WeaveWidth;        ! Weave width (mm)
    num WeaveDwellLeft;    ! Dwell time left side (s)
    num WeaveDwellRight;   ! Dwell time right side (s)
    num TrackType;         ! Seam tracking type (0-3)
    num TrackGainY;        ! Tracking Y gain
    num TrackGainZ;        ! Tracking Z gain
    num MaxCorr;           ! Max correction value
    num Bias;              ! Bias value
ENDRECORD

! Correction Order Data Structure
! Contains offset and penetration parameters for weld correction
RECORD corrorder
    num X_StartOffset;     ! X offset before arc start (mm)
    num X_Depth;           ! X penetration depth (mm)
    num X_ReturnLength;    ! X return distance (mm)
    num Y_StartOffset;     ! Y offset (mm)
    num Y_Depth;           ! Y penetration depth (mm)
    num Y_ReturnLength;    ! Y return distance (mm)
    num Z_StartOffset;     ! Z offset (mm)
    num Z_Depth;           ! Z penetration depth (mm)
    num Z_ReturnLength;    ! Z return distance (mm)
    num RY_Torch;          ! Torch angle RY (deg)
ENDRECORD

! ========================================
! Torch Motion Data Structure (v1.9.38 - PlanA compatible)
! ========================================
! Upper system interface for weld parameters per pass/step
! PlanA reference: Head_Data.mod lines 70-93
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

! ========================================
! Macro Buffers (v1.9.38 - PlanA compatible)
! ========================================
! Buffer1 = Robot1, Buffer2 = Robot2
! Index = pass number (1-10)
! Upper system writes these before sending CMD_EDGE_WELD
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

! Number of active weld passes (upper system sets this)
PERS num nWeldPassCount := 1;

! ========================================
! Edge Data Arrays (v2.2.0)
! ========================================
! Edge points from upper system (2 robots)
! edgeStart{1} = Robot1 side, edgeStart{2} = Robot2 side
PERS edgedata edgeStart{2} := [
    [[5000, 5100, 500], 50, 50, 50, 12, 0, 0],
    [[5000, 4900, 500], 50, 50, 50, 12, 0, 0]
];
PERS edgedata edgeEnd{2} := [
    [[5500, 5100, 500], 50, 50, 50, 12, 0, 0],
    [[5500, 4900, 500], 50, 50, 50, 12, 0, 0]
];

! ========================================
! Part Height Data (v2.2.0)
! ========================================
! Maximum part heights for Z-position optimization
! {1}=move phase, {2}=enter phase, {3}=exit phase
PERS num nMaxPartHeightNearArray{3} := [300, 300, 300];
PERS num nTempAdjustGantryZ := 0;  ! Temporary Z adjustment (mm)

! ========================================
! Error Status Flags (v2.2.0)
! ========================================
! PERS variables to replace I/O signals (for simulation)
PERS bool bEntryR1Error := FALSE;   ! Robot1 entry point error
PERS bool bTouchR1Error := FALSE;   ! Robot1 touch sensing error
PERS bool bArcR1Error := FALSE;     ! Robot1 arc/welding error
PERS bool bEntryR2Error := FALSE;   ! Robot2 entry point error
PERS bool bTouchR2Error := FALSE;   ! Robot2 touch sensing error
PERS bool bArcR2Error := FALSE;     ! Robot2 arc/welding error

! ========================================
! Weld Step Data (v2.2.0)
! ========================================
! Number of weld steps (max 40)
PERS num nWeldStepCount := 2;

! Motion control parameters
PERS num nMotionStep := 5;              ! Current motion step index
PERS num nMotionTotalStep{2} := [2, 2]; ! Total steps per robot
PERS num nMotionStepCount{2} := [4, 4]; ! Step counter per robot
PERS num nRunningStep{2} := [4, 4];     ! Current running step

! Weld enable flags
PERS bool bEnableWeldSkip := FALSE;         ! Skip motion segments
PERS bool bEnableStartEndPointCorr := FALSE; ! Enable start/end correction
PERS bool bEnableManualMacro := FALSE;       ! Enable manual macro

! Macro configuration
PERS string stMacro{2} := ["244", "244"];  ! Macro codes [R1, R2]

! ========================================
! Correction Data (v2.2.0)
! ========================================
! Start/End point corrections (10 types)
PERS corrorder corrStart{10} := [
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
];
PERS corrorder corrEnd{10} := [
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
];

! Correction success flag
PERS bool bCorrectionOk := FALSE;

! ========================================
! Cycle Time Data (v2.2.0)
! ========================================
PERS num nclockWeldTime{2} := [0, 0];  ! Weld time per robot (seconds)
PERS num nclockCycleTime := 0;          ! Total cycle time (seconds)

! ========================================
! Calibration Data (v2.2.0)
! ========================================
! Home position adjustments
PERS num nHomeAdjustX := 0;  ! Calibration X offset
PERS num nHomeAdjustY := 0;  ! Calibration Y offset
PERS num nHomeAdjustZ := 0;  ! Calibration Z offset
PERS num nHomeAdjustR := 0;  ! Calibration R offset

! Reference hole inspection
PERS num nRefHoleX{2} := [0, 0];       ! Reference hole X position
PERS num nInspectHoleX{2} := [0, 0];   ! Measured hole X position
PERS num nDiffHoleX := 0;              ! Hole position X error
PERS num nDiffHoleXskew := 0;          ! Hole skew error

! Gantry calibration errors
PERS num nDiffGantryX := 0;  ! Gantry X calibration error
PERS num nDiffGantryY := 0;  ! Gantry Y calibration error
PERS num nDiffGantryZ := 0;  ! Gantry Z calibration error

! ========================================
! Mode2 Test Configuration
! ========================================
! TCP Offsets for Robot1 (mm)
! Robot1: WobjGantry Y=-100, Floor Y effect = +100*cos(R) (above gantry center)
! v1.8.57: Changed from +100 to -100 to reverse direction
PERS num MODE2_TCP_OFFSET_R1_X := 0;
PERS num MODE2_TCP_OFFSET_R1_Y := -100;
PERS num MODE2_TCP_OFFSET_R1_Z := 0;

! TCP Offsets for Robot2 (mm)
! Robot2: WobjGantry_Rob2 Y = 488 + (-100) = 388, Floor Y effect = -100*cos(R) (below gantry center)
! Y distance = 200*cos(R), Robot2 below, Robot1 above
! v1.8.57: Changed from +100 to -100 to reverse direction
PERS num MODE2_TCP_OFFSET_R2_X := 0;
PERS num MODE2_TCP_OFFSET_R2_Y := -100;
PERS num MODE2_TCP_OFFSET_R2_Z := 0;

! Complex Motion Test Positions
! v1.8.77: 10 random positions with various angles for comprehensive testing
PERS num MODE2_NUM_POS := 10;

! Position arrays (COMPLEX_POS format: offset from HOME)
! Floor coordinates = HOME + offset
! HOME = [9500, 5300, 2100, 0]
! offset_X = floor_X - 9500, offset_Y = floor_Y - 5300, offset_Z = floor_Z - 2100
!
! Gantry limits (Physical):
!   X: [-9510, 12310] mm, Y: [-50, 5350] mm, Z: [-50, 1050] mm, R: [-100, 100]°
!
! Test positions (Floor coords):
!   1. [5000, 5000, 2100] R=0°   - Center, no rotation
!   2. [5000, 5000, 2100] R=45°  - Center, 45° CCW
!   3. [5000, 5000, 2100] R=-45° - Center, 45° CW
!   4. [5000, 5000, 2100] R=90°  - Center, 90° CCW
!   5. [5000, 5000, 2100] R=-90° - Center, 90° CW
!   6. [3000, 4000, 2000] R=30°  - Different XYZ, 30° CCW
!   7. [7000, 5200, 2100] R=-30° - Different XYZ, 30° CW
!   8. [2000, 3500, 1800] R=60°  - Low Z, 60° CCW
!   9. [8000, 4500, 2050] R=-60° - Different XYZ, 60° CW
!  10. [4500, 5000, 1900] R=15°  - Small angle test
PERS num MODE2_POS_X{10} := [-4500, -4500, -4500, -4500, -4500, -6500, -2500, -7500, -1500, -5000];
PERS num MODE2_POS_Y{10} := [-300, -300, -300, -300, -300, -1300, -100, -1800, -800, -300];
PERS num MODE2_POS_Z{10} := [0, 0, 0, 0, 0, -100, 0, -300, -50, -200];
PERS num MODE2_POS_R{10} := [0, 45, -45, 90, -90, 30, -30, 60, -60, 15];

! ========================================
! Weld Sequence Configuration (v1.9.0)
! ========================================
! Robot TCP Offset from R-center (mm)
! Distance from gantry R-center to robot TCP (actual reach, not tool length)
! Used to calculate gantry Z from Floor weld Z
! Gantry_Z = 2100 - Floor_Z - TCP_OFFSET
! v1.9.6: Changed from 1600 to 1000 (actual robot reach based on Mode2 test)
PERS num WELD_R1_TCP_Z_OFFSET := 500;   ! Robot1 (TEST: 1000->500 for Z limit)
PERS num WELD_R2_TCP_Z_OFFSET := 500;   ! Robot2 (TEST: 1000->500 for Z limit)

! Robot1 Weld Line (Floor TCP coordinates, mm)
! Floor Z = (2100 - Gantry_Z) - TCP_OFFSET
! Example: Gantry_Z=600, TCP_OFFSET=1000, Floor_Z = 2100 - 600 - 1000 = 500
PERS num WELD_R1_START_X := 5000;
PERS num WELD_R1_START_Y := 5100;
PERS num WELD_R1_START_Z := 500;
PERS num WELD_R1_END_X := 5500;
PERS num WELD_R1_END_Y := 5100;
PERS num WELD_R1_END_Z := 500;

! Robot2 Weld Line (Floor TCP coordinates, mm)
! Robot2 on opposite side of R-center
PERS num WELD_R2_START_X := 5000;
PERS num WELD_R2_START_Y := 4900;
PERS num WELD_R2_START_Z := 500;
PERS num WELD_R2_END_X := 5500;
PERS num WELD_R2_END_Y := 4900;
PERS num WELD_R2_END_Z := 500;

! Robot Weld Position in WObj (mm)
! WObj origin = weld start point, Z axis = Floor Z direction
! Robot TCP at Z=0 means same height as weld line
! Y=-12 for Robot1 (12mm toward Robot1 side)
! Y=476 for Robot2 (488-12, toward Robot2 side)
! v1.9.18: Updated to WobjGantry coordinates (from user jog position)
PERS num WELD_R1_WObj_X := 0;
PERS num WELD_R1_WObj_Y := 111;   ! From jog: Y=110.59 in wobj0
PERS num WELD_R1_WObj_Z := -73;   ! From jog: Z=2026.89 - R_center_Z(2100) = -73.11

PERS num WELD_R2_WObj_X := 0;
PERS num WELD_R2_WObj_Y := 476;   ! 488 - 12 = 476
PERS num WELD_R2_WObj_Z := 0;     ! At weld line Z level

! Robot1 Weld Orientation (quaternion: q1, q2, q3, q4)
! v1.9.18: Updated from user jog position
PERS num WELD_R1_ORIENT_Q1 := 0.70603;
PERS num WELD_R1_ORIENT_Q2 := 0.03905;
PERS num WELD_R1_ORIENT_Q3 := -0.03904;
PERS num WELD_R1_ORIENT_Q4 := 0.70603;

! Robot2 Weld Orientation (quaternion: q1, q2, q3, q4)
! v1.9.8: Changed to 0 deg (straight down) for testing
! Identity quaternion [1, 0, 0, 0] = no rotation from WObj
PERS num WELD_R2_ORIENT_Q1 := 1;
PERS num WELD_R2_ORIENT_Q2 := 0;
PERS num WELD_R2_ORIENT_Q3 := 0;
PERS num WELD_R2_ORIENT_Q4 := 0;

! Weld Speed (mm/s)
PERS num WELD_SPEED := 100;

! ========================================
! Edge Points from Upper System (v2.0.0)
! ========================================
! Upper system provides 4 edge points (Floor coordinates, mm)
! edgeStart{1}: Robot1 side weld start
! edgeStart{2}: Robot2 side weld start
! edgeEnd{1}: Robot1 side weld end
! edgeEnd{2}: Robot2 side weld end
!
! These are mapped from WELD_R1/R2_START/END for compatibility
! Edge Start Points - Robot1/Robot2 start positions
PERS num EDGE_START1_X := 5000;    ! Robot1 side (= WELD_R1_START_X)
PERS num EDGE_START1_Y := 5100;    ! Robot1 side (= WELD_R1_START_Y)
PERS num EDGE_START1_Z := 1200;    ! Robot1 side (valid range: 600-1600)
PERS num EDGE_START2_X := 5000;    ! Robot2 side (= WELD_R2_START_X)
PERS num EDGE_START2_Y := 4900;    ! Robot2 side (= WELD_R2_START_Y)
PERS num EDGE_START2_Z := 1200;    ! Robot2 side (valid range: 600-1600)

! Edge End Points - Robot1/Robot2 end positions
! TEST: 45 deg diagonal weld line (dx=354, dy=354, ATan2=45 deg)
PERS num EDGE_END1_X := 5354;      ! Robot1 side (5000+354 for 45° test)
PERS num EDGE_END1_Y := 5454;      ! Robot1 side (5100+354 for 45° test)
PERS num EDGE_END1_Z := 1200;      ! Robot1 side (valid range: 600-1600)
PERS num EDGE_END2_X := 5354;      ! Robot2 side (5000+354 for 45° test)
PERS num EDGE_END2_Y := 5254;      ! Robot2 side (4900+354 for 45° test)
PERS num EDGE_END2_Z := 1200;      ! Robot2 side (valid range: 600-1600)

! ========================================
! Gantry Home/Limit Configuration (v2.0.0)
! ========================================
! From PlanA Head_Data.mod
! HOME position: Physical origin [0,0,0,0] = Floor [9500, 5300, 2100, 0]
! Internal calculation variables (PlanB style - DO NOT CHANGE)
PERS num HOME_GANTRY_X := 0;       ! Physical X at HOME (Floor 9500 = Physical 0)
PERS num HOME_GANTRY_Y := 0;       ! Physical Y at HOME (Floor 5300 = Physical 0)
PERS num HOME_GANTRY_Z := 0;       ! Physical Z at HOME (Floor 2100 = Physical 0)
PERS num HOME_GANTRY_R := 0;       ! Physical R at HOME (degrees)

! UI Interface variables (PlanA style - for upper system)
PERS num nHomeGantryX := -9500;    ! Floor X at HOME position
PERS num nHomeGantryY := 5300;     ! Floor Y at HOME position
PERS num nHomeGantryZ := 2100;     ! Floor Z at HOME position
PERS num nHomeGantryR := 0;        ! Rotation at HOME (degrees)

! TCP position at HOME (PlanA)
PERS num nHomeTcpX := -9500;
PERS num nHomeTcpY := 5300;
PERS num nHomeTcpZ := 2100;

! Physical axis limits (mm, degrees) - PlanA naming convention
PERS num nLimitX_Negative := -9500;
PERS num nLimitX_Positive := 12300;
PERS num nLimitY_Negative := 0;
PERS num nLimitY_Positive := 5300;
PERS num nLimitZ_Negative := 0;
PERS num nLimitZ_Positive := 2100;  ! PlanA value (was 1000)
PERS num nLimitR_Negative := -90;
PERS num nLimitR_Positive := 90;

! Robot Height Parameters (PlanA naming)
PERS num nRobWeldSpaceHeight := 1620;    ! Robot weld space height (R-center)
PERS num nRobHeightMin := 1100;          ! Minimum robot height
PERS num nRobCorrSpaceHeight := 1680;    ! Correction space height
PERS num nRobWorkSpaceHeight := 1680;    ! Work space height

! Rotation limits (PlanA style)
PERS num nRotationNegLimit := -90;
PERS num nRotationPosLimit := 90;

! ========================================
! Command Interface (v2.1.0 - PlanA Style)
! ========================================
! Real-time command interface for upper system (PC SDK)
! nCmdInput: Upper system sets command ID
! nCmdOutput: Robot acknowledges (echoes command ID)
! nCmdMatch: 1=matched, -1=mismatch, 0=waiting

! Command Variables (PERS for cross-task access)
PERS num nCmdInput := 0;
PERS num nCmdOutput := 0;
PERS num nCmdMatch := 0;

! Command Constants - Movement (100 series)
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

! Command Constants - Welding (200 series)
CONST num CMD_WELD := 200;
CONST num CMD_WELD_MOTION := 201;
CONST num CMD_WELD_CORR := 202;
CONST num CMD_WELD_MOTION_CORR := 203;
CONST num CMD_WELD_MM := 204;
CONST num CMD_WELD_MOTION_MM := 205;
CONST num CMD_WELD_CORR_MM := 206;
CONST num CMD_WELD_MOTION_CORR_MM := 207;
CONST num CMD_EDGE_WELD := 210;      ! Edge-based weld (v2.0.0)

! Command Constants - Camera (300 series)
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

! Command Constants - Wire (500 series)
CONST num CMD_WIRE_CUT := 501;
CONST num CMD_WIRE_CLEAN := 502;
CONST num CMD_WIRE_BULLSEYE_CHECK := 505;    ! v1.9.40 - PlanA
CONST num CMD_WIRE_BULLSEYE_UPDATE := 506;   ! v1.9.40 - PlanA
CONST num CMD_WIRE_ReplacementMode := 507;   ! v1.9.40 - PlanA
CONST num CMD_ROB1_WIRE_CUT := 511;
CONST num CMD_ROB2_WIRE_CUT := 512;

! Command Constants - Inspection (600 series)
CONST num CMD_HOLE_CHECK := 601;
CONST num CMD_LDS_CHECK := 602;

! Command Constants - Test/Debug (900 series)
CONST num CMD_TEST_MENU := 900;
CONST num CMD_TEST_SINGLE := 901;
CONST num CMD_TEST_ROTATION := 902;
CONST num CMD_TEST_MODE2 := 903;

! Gantry Position for CMD_MOVE_ABS/INC_GANTRY
PERS extjoint extGantryPos := [0, 0, 0, 0, 0, 0];

! Motion Status Signals (PERS for simulation without I/O)
PERS bool bMotionWorking := FALSE;
PERS bool bMotionFinish := TRUE;

! ========================================
! Configuration Notes
! ========================================
! To modify test positions:
! 1. Open Program Data in RobotStudio
! 2. Find ConfigModule
! 3. Edit MODE2_POS_X, MODE2_POS_Y, MODE2_POS_Z, MODE2_POS_R
! 4. Change MODE2_NUM_POS to number of positions to test
! 5. Run program - changes take effect immediately!
!
! Example:
! MODE2_NUM_POS := 5  (test 5 positions)
! MODE2_POS_X{4} := 3000  (set position 4 X offset)
! MODE2_TCP_OFFSET_R1_Y := 150  (change Robot1 Y offset to 150mm)
!
! To configure weld sequence (v1.9.0):
! 1. Set WELD_R1_START_X/Y/Z and WELD_R1_END_X/Y/Z for Robot1 weld line
! 2. Set WELD_R2_START_X/Y/Z and WELD_R2_END_X/Y/Z for Robot2 weld line
! 3. Set WELD_R1_ORIENT_Q1~Q4 for Robot1 weld posture (quaternion)
! 4. Set WELD_R2_ORIENT_Q1~Q4 for Robot2 weld posture (quaternion)
! 5. Set WELD_SPEED for gantry travel speed during welding
! 6. Run ExecuteWeldSequence() to start welding

! ========================================
! Arc Welding System Flag (v1.9.38)
! ========================================
! PlanB-specific: simulation vs hardware mode
! Set TRUE only when arc welding hardware (Lincoln Power Wave) is connected
PERS bool WELD_ARC_ENABLED := FALSE; ! TRUE=ArcLStart/ArcL, FALSE=MoveJ/MoveL (simulation)

! NOTE (v1.9.38): Individual weld parameters moved to torchmotion macroStartBuffer
! WELD_TRAVEL_ANGLE -> macroStartBuffer1{pass}.TravelAngle
! WELD_WORKING_ANGLE -> macroStartBuffer1{pass}.WorkingAngle
! WELD_ARC_VOLTAGE -> macroStartBuffer1{pass}.Voltage
! WELD_ARC_CURRENT -> macroStartBuffer1{pass}.Current
! WELD_ARC_WIRE_FEED -> macroStartBuffer1{pass}.FeedingSpeed
! WELD_ARC_SPEED -> macroStartBuffer1{pass}.WeldingSpeed
! WELD_WEAVE_WIDTH -> macroStartBuffer1{pass}.WeaveWidth
! WELD_WEAVE_LENGTH -> macroStartBuffer1{pass}.WeaveLength
! WELD_USE_ORIENT -> removed (RelTool with TravelAngle/WorkingAngle replaces quaternion)

! ========================================
! PlanA Additional Variables (v1.9.40)
! ========================================

! Robot Swap Flag
PERS bool bRobSwap := FALSE;

! Weld Output Safety
PERS bool bWeldOutputDisable := TRUE;

! Gantry Move Flag
PERS bool bMoveGantry := FALSE;

! Wire Touch Detection
PERS bool bWireTouch1;
PERS bool bWireTouch2;

! Home Move Flag
PERS bool bMoveHome_Head;

! Gantry Speed/Height Parameters
PERS num nGantrySpeed := 0;
PERS num nCurrentGantryHeight := 0;
PERS num nTargetGantryHeight := 0;
PERS num nCalculatedGantryHeight := 0;
PERS num nGantrySafetyHeight := -100;

! Weld Line Parameters
PERS num nLengthWeldLine := 0;
PERS num nOffsetLength := 0;
PERS num nOffsetLengthBuffer := 10;
PERS num nMotionStartStepLast{2} := [1,1];
PERS num nMotionEndStepLast{2} := [1,1];

! Macro Parsing Variables
PERS num nMacro100{2} := [0,0];
PERS num nMacro010{2} := [0,0];
PERS num nMacro001{2} := [0,0];
PERS num nMacro{2} := [0,0];
PERS num Command := 0;

! Position Data
PERS pos posNull := [0,0,0];
PERS pos posStart := [0,0,0];
PERS pos posStartLast := [0,0,0];
PERS num nStartThick := 12;
PERS pos posEnd := [0,0,0];
PERS pos posEndLast := [0,0,0];
PERS num nEndThick := 12;

! Camera/Inspection Variables
PERS num Camera_Door := 0;
PERS num Camera_Tilt := 0;
PERS num nCameraRotationAngle := 0;

! Speed Data
PERS num nDryRunSpeed := 2.5;
PERS num nWireCutSpeed := 500;

! Status Flags
PERS bool bWeldLineLengthCalc := FALSE;
PERS bool bPlateTiltedRx := FALSE;
PERS bool bArcError := FALSE;

! Error Data
PERS num nErrorCmd;
PERS num nWeldDist;
PERS num nEntryRetryCount{2} := [0,0];
PERS num nTouchRetryCount{2} := [0,0];

! Breakpoints
PERS breakpoint BreakPoints{10} := [[[0,0,0],0],[[0,0,0],0],[[0,0,0],0],[[0,0,0],0],[[0,0,0],0],[[0,0,0],0],[[0,0,0],0],[[0,0,0],0],[[0,0,0],0],[[0,0,0],0]];

! ========================================
! Auto/Manual Macro Arrays (v1.9.40 - PlanA)
! ========================================
PERS torchmotion macroAutoStartA{2,10};
PERS torchmotion macroAutoStartB{2,10};
PERS torchmotion macroAutoEndA{2,10};
PERS torchmotion macroAutoEndB{2,10};
PERS torchmotion macroManualStartA{2,10};
PERS torchmotion macroManualStartB{2,10};
PERS torchmotion macroManualEndA{2,10};
PERS torchmotion macroManualEndB{2,10};

! ========================================
! 40-Step Weld Data Arrays (v1.9.40 - PlanA)
! ========================================
! welddata format: [heat, speed, [9-params], [9-params]]
PERS welddata wd1 := [10,0,[5,0,36.5,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd2 := [10,0,[5,0,36.5,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd3 := [10,0,[5,0,36.5,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd4 := [10,0,[5,0,36.5,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd5 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd6 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd7 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd8 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd9 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd10 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd11 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd12 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd13 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd14 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd15 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd16 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd17 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd18 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd19 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd20 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd21 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd22 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd23 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd24 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd25 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd26 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd27 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd28 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd29 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd30 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd31 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd32 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd33 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd34 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd35 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd36 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd37 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd38 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd39 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
PERS welddata wd40 := [0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];

! ========================================
! 40-Step Weave Data Arrays (v1.9.40 - PlanA)
! ========================================
! weavedata format: [shape, type, length, width, dwellL, dwellR, bias, ...] (15 params)
PERS weavedata weave1 := [1,2,2.5,1.7,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave2 := [1,2,2.5,1.7,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave3 := [1,2,2.5,1.7,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave4 := [1,2,2.5,1.7,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave5 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave6 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave7 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave8 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave9 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave10 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave11 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave12 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave13 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave14 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave15 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave16 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave17 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave18 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave19 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave20 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave21 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave22 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave23 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave24 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave25 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave26 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave27 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave28 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave29 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave30 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave31 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave32 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave33 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave34 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave35 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave36 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave37 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave38 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave39 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PERS weavedata weave40 := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

! ========================================
! 40-Step Track Data Arrays (v1.9.40 - PlanA)
! ========================================
! trackdata format: [type, enable, maxCorr, [9-params], [7-params]]
PERS trackdata track0 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track1 := [0,FALSE,50,[0,15,30,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track2 := [0,FALSE,50,[0,15,30,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track3 := [0,FALSE,50,[0,15,30,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track4 := [0,FALSE,50,[0,15,30,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track5 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track6 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track7 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track8 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track9 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track10 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track11 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track12 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track13 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track14 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track15 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track16 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track17 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track18 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track19 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track20 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track21 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track22 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track23 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track24 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track25 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track26 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track27 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track28 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track29 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track30 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track31 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track32 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track33 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track34 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track35 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track36 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track37 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track38 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track39 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
PERS trackdata track40 := [0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];

! ========================================
! T_Head Communication Variables (v1.9.40)
! ========================================
! stCommand: T_Head sets command string for TASK1/TASK2
! stReact: TASK1/TASK2 report status ("Ready", "Ack", etc.)
PERS string stCommand := "";
PERS string stReact{3} := ["", "", ""];

! ========================================
! T_Head Shared Motion Variables (v1.9.41)
! ========================================
! Shared PERS with T_Head (Head_Command.mod) for MoveJgJ/MovePgJ/MovePgL
! T_Head sets these targets, TASK1 executes the motion
PERS jointtarget jRob1;
PERS jointtarget jGantry;
PERS robtarget pRob1;
PERS speeddata vSync;
PERS zonedata zSync;
PERS num idSync;

ENDMODULE

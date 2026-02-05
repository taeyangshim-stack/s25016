MODULE VersionModule
! ========================================
! S25016 SpGantry Version Management
! ========================================
! Purpose: Centralized version tracking for all tasks and modules
! Date: 2026-01-09
! ========================================

! ========================================
! Task Versions
! ========================================
CONST string TASK1_VERSION := "v1.9.40";
CONST string TASK2_VERSION := "v1.9.28";
CONST string TASK_BG_VERSION := "v1.0.0";
CONST string TASK_HEAD_VERSION := "v1.9.40";

! ========================================
! Module Versions
! ========================================
CONST string CONFIG_MODULE_VERSION := "v1.0.0";
CONST string VERSION_MODULE_VERSION := "v1.0.0";

! ========================================
! Build Information
! ========================================
CONST string BUILD_DATE := "2026-02-06";
CONST string BUILD_TIME := "00:00:00";
CONST string PROJECT_NAME := "S25016 SpGantry Dual Robot System";

! ========================================
! Major Component Versions
! ========================================
! Coordinate System
CONST string COORD_SYSTEM_VERSION := "v1.8.5";  ! Last stable coordinate calculation

! Gantry Control
CONST string GANTRY_CONTROL_VERSION := "v1.8.35";  ! Robot init + sync

! Mode2 Test
CONST string MODE2_TEST_VERSION := "v1.8.77";  ! 10 test positions configured

! Weld Sequence (v1.9.0 NEW)
CONST string WELD_SEQUENCE_VERSION := "v1.9.40";  ! PlanA-PlanB variable integration

! ========================================
! Version History (Latest 10)
! ========================================
! v1.9.40 (2026-02-06)
!   - FEAT: PlanA-PlanB variable integration complete (100% UI compatibility)
!   - CHANGE: Variable names to PlanA style (nLimitX_Negative, etc.)
!   - CHANGE: Dual HOME variables (HOME_GANTRY_*=internal, nHomeGantry*=UI)
!   - FEAT: RECORD added (breakpoint, jointgroup, pointgroup, monRobs)
!   - FEAT: ~50 new PERS variables (bRobSwap, nRobHeight*, posStart/End)
!   - FEAT: CMD constants added (104, 107, 311-324, 505-507)
!   - FEAT: 40-step welddata/weavedata/trackdata arrays (wd1~40, weave1~40)
!   - FEAT: stCommand/stReact communication (T_Head interface)
!   - FEAT: Auto/Manual macro arrays (macroAutoStartA{2,10}, etc.)
!
! v1.9.39 (2026-02-06)
!   - FEAT: T_Head task (TASK8) created - PlanA-compatible command dispatcher
!   - FEAT: stCommand/stReact{2} protocol for TASK1/TASK2 dispatch
!   - FEAT: Rob1_CommandListener - responds to T_Head stCommand
!   - FEAT: Rob2_CommandListener - responds to T_Head stCommand
!   - FEAT: test_mode=11 enables T_Head listener mode
!   - FEAT: Head_Data.mod - shared PERS variables for upper system
!   - FEAT: Head_MainModule.mod - command loop with rCheckCmdMatch
!   - FEAT: rDispatchAndWait/rDispatchR1 for dual/single task dispatch
!   - FEAT: MoveAbsGantryFromExtPos/MoveIncGantryFromExtPos extracted as PROCs
!   - KEEP: test_mode 0-10 backward compatible (existing flows unchanged)
!   - SYS.cfg: T_Head added as NORMAL task (non-motion)
!
! v1.9.38 (2026-02-05)
!   - FEAT: torchmotion RECORD adopted from PlanA (22 fields, upper system compatible)
!   - FEAT: macroStartBuffer1/macroEndBuffer1 arrays (10 passes, PERS)
!   - FEAT: Multi-pass welding loop (nWeldPassCount passes)
!   - FEAT: Approach path (-100mm RelTool Z) before weld start
!   - FEAT: Retract path (-50mm RelTool Z) after weld end
!   - FEAT: RelTool torch orientation (TravelAngle=\Rx, WorkingAngle=\Ry)
!   - FEAT: bRobSwap-dependent base orientation ([0.5,0.5,-0.5,0.5] vs [-0.5])
!   - FEAT: Per-pass weld parameters from torchmotion (voltage, current, speed, weave)
!   - REFACTOR: Individual WELD_ARC_* PERS replaced by macroStartBuffer fields
!   - KEEP: WELD_ARC_ENABLED flag (simulation vs hardware)
!
! v1.9.37 (2026-02-05)
!   - FEAT: Z-axis enabled in TraceWeldLine (posStart.z/posEnd.z applied)
!   - FEAT: Torch orientation support (WELD_USE_ORIENT flag, WELD_R1_ORIENT quaternion)
!   - FEAT: Arc welding preparation (WELD_ARC_ENABLED flag, voltage/current/wire params)
!   - FEAT: Robot2 weld tracking - edge positions shared via PERS (shared_posStart_r2)
!   - FEAT: Robot2_EdgeWeldSequence logs to HOME:/robot2_weld_trace.txt
!   - FEAT: Robot2 monitors t1_weld_start/t1_weld_done during weld phase
!   - ADD: ConfigModule - WELD_TRAVEL_ANGLE, WELD_WORKING_ANGLE, WELD_ARC_* params
!   - ADD: 3D position error (dX, dY, dZ) in TraceWeldLine verification
!   - ADD: Weld speed from WELD_ARC_SPEED (configurable, default 100mm/s)
!   - NOTE: Arc welding placeholder (MoveL) - replace with ArcLStart/ArcL when ready
!   - NOTE: Robot2 MoveAbsJ only (no config linkage) - MultiMove needed for full tracking
!
! v1.9.36 (2026-02-05)
!   - FEAT: TraceWeldLine - Robot1 TCP traces weld line (posStart -> posEnd)
!   - Uses WobjFloor (not WobjGantry) for Floor coordinate movement
!   - CRobT(\WObj:=WobjFloor) gets TCP in Floor coords directly
!   - MoveJ to start, MoveL to end (gantry stays fixed via extax)
!   - Position error verification at start and end points
!   - TestFullWeldSequence Step 8 calls TraceWeldLine
!
! v1.9.35 (2026-02-04)
!   - FIX: Robot2 wait timeout increased from 10s to 30s
!   - Robot2_WeldReady execution time may exceed 10 seconds
!   - Prevents premature timeout during weld sequence sync
!
! TASK2 v1.9.28 (2026-02-05)
!   - FIX: Robot2_EdgeWeldSequence MoveJ -> MoveAbsJ
!   - MoveJ with WobjGantry_Rob2 fails after Gantry moves to weld position
!   - Cause: Robot2 has no config linkage, controller thinks base is fixed
!   - World target from WobjGantry_Rob2 is far from Robot2 configured base
!   - Solution: MoveAbsJ (joint-based) bypasses World coord reach check
!   - Robot2 already at correct relative position from initialization
!
! TASK2 v1.9.27 (2026-02-05)
!   - FEAT: Robot2_EdgeWeldSequence uses WobjGantry_Rob2 coordinate system
!   - Target [0, 488, -1000] in WobjGantry_Rob2 (Gantry-relative)
!   - UpdateGantryWobj_Rob2 before MoveJ for current Gantry position
!   - ISSUE: Position outside reach when Gantry moved far from HOME
!
! TASK2 v1.9.26 (2026-02-05)
!   - TEST: Robot2 move skipped (signal exchange only)
!   - Verified TASK1/TASK2 sync works: Robot2 ready after 0.2s
!
! TASK2 v1.9.25 (2026-02-04)
!   - FIX: Robot2_EdgeWeldSequence now moves directly (no t1_weld_start wait)
!   - Robot2_WeldReady was waiting for t1_weld_start which TASK1 never sets
!   - Direct move: MoveAbsJ safe joints, then MoveJ wobj0 [0,118,-1300]
!   - Eliminates deadlock between TASK1 and TASK2
!
! TASK2 v1.9.24 (2026-02-04)
!   - FIX: Wait for flag reset after EdgeWeldSequence completes
!   - Prevents duplicate Robot2_EdgeWeldSequence calls
!   - Waits for t1_weld_position_ready=FALSE before resuming monitor
!
! TASK2 v1.9.23 (2026-02-04)
!   - FEAT: TestMenu mode (mode=9) now monitors weld sync signals
!   - When t1_weld_position_ready=TRUE, runs Robot2_EdgeWeldSequence
!   - Enables TestFullWeldSequence (menu 11) to work without config change
!   - Continuous monitoring loop with 200ms interval
!
! v1.9.34 (2026-02-04)
!   - FEAT: TestFullWeldSequence - Complete weld with Robot2 sync
!   - TASK1 signals t1_weld_position_ready after Gantry+Robot1 move
!   - TASK1 waits for t2_weld_ready from Robot2 (TASK2)
!   - TASK1 signals t1_weld_done after weld complete
!   - shared_bRobSwap passed to TASK2 for position adjustment
!   - TestMenu updated to v2.6.0 (option 11 added)
!   - Logs to HOME:/full_weld_sequence.txt
!
! v1.9.33 (2026-02-04)
!   - FIX: MoveGantryToWeldPosition - Z offset order bug
!   - TCP Z offset now applied in Floor coords BEFORE FloorToPhysical
!   - Previously: FloorToPhysical clamped to 1000, then subtract 500 = 500 (wrong)
!   - Now: Add 500 to Floor Z first, then FloorToPhysical = 800 (correct)
!   - LowZ test error: 300mm -> expected <0.5mm
!
! v1.9.32 (2026-02-04)
!   - FEAT: TestMultiPosition - Test 5 different Floor positions
!   - Center [5000,5000,1200], Left [3000,5000,1200], Right [7000,5000,1200]
!   - LowZ [5000,5000,800], HighZ [5000,5000,1600]
!   - All tests use 45 deg angle for consistency
!   - Logs to HOME:/multi_position_test.txt
!   - TestMenu updated to v2.5.0 (option 10 added)
!
! v1.9.31 (2026-02-04)
!   - FIX: MoveRobotToWeldPosition - Joint Out of Range error
!   - Keep current Z position (avoid joint limit issues)
!   - Keep current orientation (avoid incompatible pose)
!   - Use MoveJ instead of MoveL (more forgiving)
!
! v1.9.30 (2026-02-04)
!   - FIX: MoveRobotToWeldPosition - Missing External Axis Value error
!   - Changed: Copy entire current_tcp to weld_target first
!   - This preserves robconf and extax from current position
!   - Only modify trans and rot fields afterward
!
! v1.9.29 (2026-02-04)
!   - FEAT: Multi-Angle Test (TestMultiAngle)
!   - Tests 0°, 45°, 90°, -45° weld line angles automatically
!   - Logs all results to HOME:/multi_angle_test.txt
!   - FEAT: Robot TCP Movement (MoveRobotToWeldPosition)
!   - Moves Robot1 TCP to weld start position in WobjGantry
!   - Uses predefined weld orientation (WELD_R1_ORIENT_Q1~Q4)
!   - FEAT: Combined Test (TestEdgeToWeldWithRobot)
!   - Gantry move + Robot TCP move in one sequence
!   - TestMenu updated to v2.4.0 (options 8, 9 added)
!
! v1.9.28 (2026-02-04)
!   - FIX: TCP Tracking now uses gantry-based calculation
!   - Read gantry position, convert to Floor coordinates
!   - Apply rotated TCP offset to calculate expected TCP Floor position
!   - Compare calculated vs target weld line position
!   - Shows actual TCP in WobjGantry for reference
!   - TestEdgeToWeld updated to v2.3.0
!
! v1.9.27 (2026-02-04)
!   - FEAT: TCP Tracking Verification in TestEdgeToWeld
!   - Read actual TCP position after gantry move
!   - Compare actual vs target (weld line position)
!   - Calculate dX, dY, dZ, Total error
!   - Log to HOME:/tcp_tracking.txt
!   - TestEdgeToWeld updated to v2.2.0
!
! v1.9.26 (2026-02-04)
!   - PERF: WaitUntil replaces polling loop (faster response)
!   - ADD: ForceLinkedMotorSync - auto-fix X1/X2 mismatch
!   - Menu mode wait reduced: 3 seconds (was 5)
!   - Normal mode wait reduced: 10 seconds (was 20)
!
! v1.9.25 (2026-02-04)
!   - PERF: Reduced Robot2 wait time for Menu mode (20s -> 5s)
!   - ADD: TestEdgeToWeld now returns gantry to HOME after test
!
! v1.9.24 (2026-02-04)
!   - FIX: RAPID Cos/Sin use DEGREES, not radians!
!   - Removed unnecessary radian conversion (angle_rad variable)
!   - Now: Cos(target_r) instead of Cos(target_r * pi/180)
!   - R=-45 test: offset should be [-70.7, -70.7], was [-1.4, -100]
!
! v1.9.23 (2026-02-04)
!   - FEAT: X/Y TCP offset support in MoveGantryToWeldPosition
!   - Offset rotation by R-axis angle: offset_floor = Rot(R) * tcp_offset
!   - MODE2_TCP_OFFSET_R1_X/Y now applied (was only Z)
!   - TestEdgeToWeldCalcOnly updated to v1.2 with X/Y offset logging
!   - Formula: gantry_floor = weld_center - rotated_tcp_offset
!
! v1.9.22 (2026-01-18)
!   - FIX: Corrected WobjGantry coords from user jog data
!   - User jog at X=-4500: wobj0 Y=110.59, Z=2026.89
!   - WobjGantry = [0, 111, -73] (not [0, 370, 1300])
!
! v1.9.21 (2026-01-18)
!   - FIX: Robot1 Step2 uses WobjGantry instead of wobj0
!   - wobj0 [0,370,1300] unreachable when gantry at X=-4500
!   - WobjGantry is relative to R-center, works at any gantry position
!
! v1.9.20 (2026-01-18)
!   - ADD: Home return after weld sequence complete
!   - Step6: ReturnRobot1ToSafe - Robot1 to safe joint [0,-10,-50,0,-30,0]
!   - Step7: ReturnGantryToHome - Gantry to HOME [0,0,0,0]
!
! v1.9.19 (2026-01-18)
!   - FIX: 2-step weld move approach (safer motion path)
!   - Step1: MoveAbsJ to safe joint [0,-10,-50,0,-30,0]
!   - Step2: MoveJ to wobj0 target
!   - Robot1: wobj0 [0, 370, 1300]
!   - Robot2: wobj0 [0, 118, -1300]
!
! v1.9.18 (2026-01-18)
!   - FIX: MoveRobot1ToWeldReady uses WobjGantry instead of WobjWeldR1
!   - WobjWeldR1 was set to Floor coords (unreachable from gantry position)
!   - Updated WELD_R1_WObj_X/Y/Z to WobjGantry coords from user jog position
!   - Updated WELD_R1_ORIENT quaternion from user jog position
!
! v1.9.17 (2026-01-18)
!   - FIX: TASK2 test_mode was hardcoded to 2
!   - ADD: shared_test_mode PERS variable for cross-task sync
!   - TASK1 sets shared_test_mode after reading config.txt
!   - TASK2 waits for shared_test_mode (max 5s) then uses it
!   - TASK2 now calls Robot2_WeldSequence when test_mode=3
!
! v1.9.16 (2026-01-18)
!   - REVERT: 9E9 approach failed with error 40512 (Missing External Axis Value)
!   - FIX: Set eax_f := eax_a for all MoveAbsJ commands (linked motor requirement)
!   - Applied to: MoveGantryToWeldStart, WeldAlongCenterLine
!   - NOTE: X1/X2 state sync still not resolved - requires Virtual Controller restart
!
! v1.9.15 (2026-01-18)
!   - FIX: Use 9E9 for eax_f in all MoveAbsJ commands
!   - 9E9 means "don't control this axis" - let linked motor system handle X2
!   - This avoids the stale X2 state comparison issue
!   - Applied to: SetRobot1InitialPosition, MoveGantryToWeldStart, WeldAlongCenterLine
!
! v1.9.14 (2026-01-18)
!   - FIX: SetRobot1InitialPosition X1/X2 software state sync
!   - Set BOTH eax_a AND eax_f to same value (actual physical position)
!   - Simulation regain only updates X1 state, X2 state gets stale
!   - Added detailed logging to robot1_init_position.txt
!
! v1.9.13 (2026-01-18)
!   - FIX: Changed tWeld1 to tool0 for MoveRobot1ToWeldReady and WeldAlongCenterLine
!   - tWeld1 has large TCP offset [320, -6, 330] causing "Position outside reach"
!   - Testing with tool0 (no offset) to verify robot reach
!
! v1.9.12 (2026-01-18)
!   - ANALYSIS: X1/X2 are physically same axis (linked motors)
!   - eax_f different value is SOFTWARE STATE issue, not physical
!   - Removed physical sync attempts (meaningless)
!   - Added gantry_move_debug.txt for detailed MoveAbsJ diagnostics
!
! v1.9.11 (2026-01-18)
!   - FIX: X1/X2 sync - both eax_a and eax_f must be same in MoveAbsJ
!   - Step 1: Move X1 to X2's position (both at same place)
!   - Step 2: Move both together to target position
!   - This ensures linked motors always have matching command values
!
! v1.9.10 (2026-01-18)
!   - FIX: Force X1/X2 sync at ExecuteWeldSequence start
!   - Added progressive sync (4 steps) for large differences (>100mm)
!   - Log sync status to weld_sequence.txt
!   - Prevents linked motor error (50246) from pre-existing desync
!
! v1.9.8 (2026-01-18)
!   - TEST: Position outside reach (50050) debug
!   - Changed torch orientation from 45 deg to 0 deg (straight down)
!   - WELD_R1_ORIENT: [0.9239, 0.3827, 0, 0] -> [1, 0, 0, 0]
!   - WELD_R2_ORIENT: [0.9239, -0.3827, 0, 0] -> [1, 0, 0, 0]
!   - Identity quaternion = no rotation from WObj axes
!
! v1.9.7 (2026-01-18)
!   - FIX: Linked motor error (50246) - X1/X2 desync
!   - MoveGantryToWeldStart: added eax_f := gantry_target.x (X2 linked motor)
!   - WeldAlongCenterLine: added eax_f := gantry_end.x (X2 linked motor)
!   - Both X1 (eax_a) and X2 (eax_f) must be set to same value for linked motors
!
! v1.9.6 (2026-01-18)
!   - FIX: Linked motor error (50246) - gantry Z calculation wrong
!   - WELD_R1_TCP_Z_OFFSET: 1600 -> 1000 (actual robot reach from Mode2 test)
!   - WELD_R2_TCP_Z_OFFSET: 1600 -> 1000 (actual robot reach)
!   - Now: Gantry Z = 2100 - 500 - 1000 = 600 (valid range [-50, 1050])
!   - R-center Floor Z = 1500, Robot reach 1000mm -> TCP at Floor Z=500 (OK)
!
! v1.9.5 (2026-01-18)
!   - FIX: Linked motor error (50246) - robot unreachable position
!   - WELD_R1_WObj_Z: 1600 -> 0 (at weld line Z level)
!   - WELD_R2_WObj_Z: -1600 -> 0 (at weld line Z level)
!   - Robot TCP now at same Z as weld line in WObj coordinates
!
! v1.9.4 (2026-01-17)
!   - FIX: Missing External Axis Value (40512) in MoveRobot1ToWeldReady
!   - Robot1 is gantry-configured, needs valid extax (not 9E9)
!   - Changed: weld_target.extax := current_jt.extax (from CJointT)
!
! v1.9.3 (2026-01-17)
!   - FIX: RAPID syntax errors in weld sequence procedures
!   - FIX: pos type assignment (cannot use [x,y,z] literal)
!   - FIX: robconf/extax assignment (must use component syntax)
!   - FIX: ERR_RANYBIN -> ELSE (invalid error constant)
!   - Changed: r1_start := [x,y,z] -> r1_start.x/y/z := value
!   - Changed: robconf := [0,0,0,0] -> robconf.cf1/cf4/cf6/cfx := 0
!   - Changed: extax := [9E9,...] -> extax.eax_a/b/c/d/e/f := 9E9
!
! v1.9.2 (2026-01-17)
!   - ADD: TP Menu System (TestMenu procedure)
!   - Menu options: Mode2, Weld, Results, Config, Exit
!   - TEST_MODE=9 triggers interactive menu
!   - TEST_MODE=3 now runs Weld Sequence (was not implemented)
!   - ViewLastResults: Display last test results on TP
!   - ViewCurrentConfig: Display current configuration on TP
!
! v1.9.1 (2026-01-17)
!   - FIX: R-axis angle calculation: Floor X+ = R=0° (was Y+ = 0°)
!   - FIX: WObj creation: X = weld direction using ATan2(dy, dx)
!   - FIX: TCP Z offset: 1600mm (was 1500mm)
!   - FIX: Torch orientation: Rx rotation (around weld line), not Ry
!   - ADD: Robot weld positions in WObj coordinates
!     Robot1: (0, -12, 1600), Robot2: (0, 476, -1600)
!   - ADD: 45° torch angle (Rx rotation around weld line X-axis)
!     Robot1: Rx +45° [0.9239, 0.3827, 0, 0]
!     Robot2: Rx -45° [0.9239, -0.3827, 0, 0]
!   - ADD: WELD_R1/R2_WObj_X/Y/Z variables in ConfigModule
!
! v1.9.0 (2026-01-16)
!   - NEW: Weld Sequence feature
!   - Input: Robot1/Robot2 weld lines in Floor TCP coordinates
!   - Calculate center line between two weld lines
!   - Auto R-axis angle calculation (atan2)
!   - Dynamic WObj creation for each robot (X = weld direction)
!   - Gantry moves along center line, robots maintain posture
!   - ConfigModule: WELD_R1/R2_START/END_X/Y/Z, WELD_R1/R2_ORIENT_Q1~Q4
!   - MainModule: ExecuteWeldSequence, CalcCenterLine, CreateWeldWobj
!   - Rob2_MainModule: Robot2_WeldSequence (TASK2 sync)
!
! v1.8.77 (2026-01-15)
!   - ConfigModule: Added 10 test positions with various R angles
!
! v1.8.76 (2026-01-15)
!   - FIX: Robot2 rotation direction in UpdateRobot2BaseDynamicWobj
!   - Cause: Robot1 (gantry-configured) rotates CW in Floor coordinates
!   - Robot2 was using CCW rotation formula, causing X offset to be opposite
!   - Solution: Invert Sin sign in rotation matrix (CCW -> CW)
!   - base_floor_x: + 488*Sin(R) -> - 488*Sin(R)
!   - floor_x_offset: X*Cos - Y*Sin -> X*Cos + Y*Sin
!   - floor_y_offset: X*Sin + Y*Cos -> -X*Sin + Y*Cos
!   - Result: TCP distance now 200mm at all R angles
!
! v1.8.71 (2026-01-13)
!   - FIX - MoveJ still causes 50426 on initial offset
!   - SetRobot2InitialPosition uses MoveL and works
!   - SetRobot2OffsetPosition was using MoveJ and failing
!   - SOLUTION: Use MoveL instead of MoveJ for initial offset
!   - Reposition still skips motion (joints maintained from v1.8.70)
!
! v1.8.70 (2026-01-13)
!   - FIX - Robot2 reposition fails with 50050/50426 when gantry not at HOME
!   - ROOT CAUSE: Robot2 is NOT gantry-configured
!     Controller doesn't know Robot2 base moves with gantry
!     MoveJ with WobjGantry_Rob2 or wobj0 both fail at non-HOME positions
!   - SOLUTION: Maintain joints like Robot1 (robot1_offset_joints approach)
!     Initial call (HOME): MoveJ to offset, save robot2_offset_joints
!     Reposition call: Skip MoveJ, joints already at offset position
!   - Added VAR robjoint robot2_offset_joints in Rob2_MainModule
!   - SetRobot2OffsetPosition now checks mode2_r2_reposition_trigger
!   - Flow: Initial offset (MoveJ works) -> Gantry moves -> Joints maintained
!
! v1.8.67 (2026-01-13)
!   - FIX - Race condition: TASK1 moved gantry before Robot2 reached offset
!   - ROOT CAUSE: No sync between Robot1 offset and gantry move
!   - Robot2 offset was called AFTER gantry moved to test position
!   - 50426 error: Robot2 can't reach offset at non-HOME gantry position
!   - SOLUTION: New sync flag mode2_r2_initial_offset_done
!     TASK1: Wait for mode2_r2_initial_offset_done before FOR loop
!     TASK2: Set mode2_r2_initial_offset_done after SetRobot2OffsetPosition
!   - Flow: Both robots at offset (HOME) -> Gantry moves -> Robot2 repositions
!
! v1.8.66 (2026-01-13)
!   - FIX - Deadlock in reposition sync between TASK1 and TASK2
!   - ROOT CAUSE: SetRobot2OffsetPosition waited for mode2_config_ready on every call
!   - TASK1 waited for mode2_r2_reposition_done, TASK2 waited for mode2_config_ready
!   - SOLUTION: Skip config sync wait when called from reposition trigger
!     IF NOT mode2_r2_reposition_trigger THEN wait for config sync
!   - Initial call: waits for config sync
!   - Reposition call: skips sync (config already ready)
!
! v1.8.65 (2026-01-13)
!   - FIX - Revert to WobjGantry_Rob2 + gantry_joint.extax for Robot2 MoveJ
!   - ROOT CAUSE: wobj0 + [9E9] extax caused 50426 (Out of interpolation objects)
!   - Robot2 is part of multimove system, needs valid extax for motion planning
!   - SOLUTION: Use same approach as SetRobot2InitialPosition (which works)
!     offset_tcp = [tcp_offset_x, 488 + tcp_offset_y, -1000 + tcp_offset_z]
!     MoveJ with WobjGantry_Rob2 + gantry_joint.extax
!   - UpdateGantryWobj_Rob2 ensures WObj tracks gantry position
!
! v1.8.64 (2026-01-13)
!   - FIX - Use wobj0 instead of WobjGantry_Rob2 for Robot2 MoveJ
!   - FIX - Use [9E9,...] extax instead of gantry_joint.extax for Robot2
!   - ROOT CAUSE 1: WobjGantry_Rob2 set to gantry physical coordinates
!   - ROOT CAUSE 2: Robot2 has no external axes, gantry extax causes 50426
!   - Robot2 is NOT gantry-configured, so controller doesn't know base moved
!   - SOLUTION: Use wobj0 + extax=[9E9,9E9,9E9,9E9,9E9,9E9]
!   - 2R formula already converts rotating frame to wobj0 coordinates
!
! v1.8.63 (2026-01-13)
!   - FIX - Robot2 reposition at each R angle in test loop
!   - TASK1 triggers mode2_r2_reposition_trigger after each gantry move
!   - TASK2 monitors trigger and calls SetRobot2OffsetPosition
!   - Combined with v1.8.62 2R formula for correct positioning
!
! v1.8.62 (2026-01-13)
!   - FIX - Rotating frame alignment correction for Robot2
!   - ROOT CAUSE: Robot2 wobj0 Y = [-sin(R), cos(R)], Rotating Y = [sin(R), cos(R)]
!   - X component opposite! Caused both robots to move same X direction
!   - SOLUTION: Use 2R formula to convert rotating frame to wobj0
!     calc_offset_x = tcp_offset_x * Cos(2R) + tcp_offset_y * Sin(2R)
!     calc_offset_y = -tcp_offset_x * Sin(2R) + tcp_offset_y * Cos(2R) + 488
!   - EXPECTED: TCP distance = 200mm fixed at all R angles
!
! v1.8.61 (2026-01-13)
!   - DEBUG - 3 test positions: Floor [5000, 5000, 2100] with R=0, 30, -30
!   - DEBUG - Full X and Y coordinate analysis
!   - DEBUG - Robot2 base_floor_y and floor_y_offset logging added
!   - GOAL - Verify X/Y behavior at different R angles
!
! v1.8.60 (2026-01-13)
!   - DEBUG - Restore working formula (488 + tcp_offset_y) for analysis
!   - DEBUG - Single test position: Floor [5000, 5000, 2100], R=0
!   - DEBUG - Detailed logging: Gantry pos, Robot1/2 base, TCP, offsets
!   - GOAL - Step-by-step verification of coordinate system
!
! v1.8.59 (2026-01-13)
!   - FAIL - offset_tcp.y = 588 caused Joint Out of Range
!   - Robot2 cannot reach 588mm from base (beyond physical limit)
!
! v1.8.58 (2026-01-13)
!   - DEBUG - Added detailed X coordinate analysis logging
!   - Traced Robot2 intermediate values (wobj0, base_floor_x, floor_x_offset)
!   - Identified issue: Both robots moving same X direction (should be opposite)
!
! v1.8.57 (2026-01-13)
!   - FIX - Reversed TCP offset direction for both robots
!   - Robot1: R1_Y changed from +100 to -100 (now above gantry center)
!   - Robot2: R2_Y changed from +100 to -100 (now below gantry center)
!   - New layout: R2 tcp <--[Gantry]--> R1 tcp (Y distance = 200*cos(R))
!   - FEAT - Added mode2_config_ready sync flag for cross-task timing
!   - TASK1 sets flag to TRUE after copying config values
!   - TASK2 waits for flag before reading offset values (max 10s timeout)
!   - Prevents stale default value issue from P-Start timing
!
! v1.8.56 (2026-01-12)
!   - FIX - Robot2 tcp_offset_y sign: -100 -> +100
!   - CAUSE - Both robots had same Y direction after transformation
!   - Floor Y effect: R1=-100*cos(R), R2=(488+offset-488)*cos(R)
!   - With offset=-100: both at -100*cos(R), same Y position
!   - With offset=+100: R2 at +100*cos(R), opposite direction
!   - RESULT - Y distance = 200*cos(R), robots on opposite sides
!
! v1.8.55 (2026-01-12)
!   - FIX - Remove 488mm from Robot2 offset_tcp calculation
!   - CAUSE - MoveJ uses WobjGantry_Rob2 (R-center reference)
!   - 488mm was only needed for wobj0 reference, not WobjGantry_Rob2
!   - RESULT - TCP distance 200mm fixed (R-angle independent)
!
! v1.8.54 (2026-01-10)
!   - FIX - Robot1 joint angles fixed during Mode2 test
!   - FIX - Remove MoveJ in loop (no inverse kinematics recalculation)
!   - RESULT - Robot1 maintains exact offset position throughout test
!
! v1.8.53 (2026-01-10)
!   - FIX - Read current_gantry.extax after MoveAbsJ (eax_e mismatch fix)
!   - FIX - Robot1 TCP now properly stays at offset position
!   - FEAT - TP messages saved to tp_messages.txt
!
! v1.8.52 (2026-01-09)
!   - NEW - ConfigModule.mod for settings (MODE2_* PERS variables)
!   - NEW - VersionModule.mod for version management
!
! v1.8.51 (2026-01-09)
!   - REFACTOR - Config migrated from file to PERS variables
!   - REMOVE - config.txt parsing (590 lines removed)
!   - FIX - ReadStr hang issue completely resolved
!
! v1.8.50 (2026-01-08)
!   - DEBUG - Added logging to trace config.txt hang
!   - TEMP - Hardcoded config values
!
! v1.8.44 (2026-01-08)
!   - DEBUG - Detailed WHILE loop logging
!   - FOUND - First ReadStr succeeds, second ReadStr hangs
!
! v1.8.43 (2026-01-08)
!   - DEBUG - Added config.txt open/parse checkpoints
!
! v1.8.39 (2026-01-08)
!   - FEAT - Share Mode2 TCP offsets via PERS for TASK2
!
! v1.8.35 (2026-01-08)
!   - FIX - Robot2 init complete flag cross-task sync
!
! v1.8.25 (2026-01-07)
!   - TEST - Mode2 complex motion verified (0.02mm accuracy)
!
! v1.8.5 (2026-01-05)
!   - FIX - Robot2 coordinate transformation formula
!   - SUCCESS - 0.01-0.03mm accuracy at all R-axis angles
!
! v1.8.0 (2025-12-31)
!   - INIT - Dual robot gantry coordinate system

! ========================================
! Utility Procedures
! ========================================

! Print version information to output window
PROC PrintVersionInfo()
    TPWrite "========================================";
    TPWrite PROJECT_NAME;
    TPWrite "========================================";
    TPWrite "TASK1 Version: " + TASK1_VERSION;
    TPWrite "TASK2 Version: " + TASK2_VERSION;
    TPWrite "Build Date: " + BUILD_DATE + " " + BUILD_TIME;
    TPWrite "========================================";
    TPWrite "Components:";
    TPWrite "  Coord System: " + COORD_SYSTEM_VERSION;
    TPWrite "  Gantry Control: " + GANTRY_CONTROL_VERSION;
    TPWrite "  Mode2 Test: " + MODE2_TEST_VERSION;
    TPWrite "========================================";
ENDPROC

! Get version information as string array (for logging)
! Usage: Write logfile, GetVersionLine(1); Write logfile, GetVersionLine(2); ...
FUNC string GetVersionLine(num line_num)
    IF line_num = 1 THEN
        RETURN "========================================";
    ELSEIF line_num = 2 THEN
        RETURN PROJECT_NAME;
    ELSEIF line_num = 3 THEN
        RETURN "========================================";
    ELSEIF line_num = 4 THEN
        RETURN "TASK1: " + TASK1_VERSION;
    ELSEIF line_num = 5 THEN
        RETURN "TASK2: " + TASK2_VERSION;
    ELSEIF line_num = 6 THEN
        RETURN "T_BG: " + TASK_BG_VERSION;
    ELSEIF line_num = 7 THEN
        RETURN "Build: " + BUILD_DATE + " " + BUILD_TIME;
    ELSEIF line_num = 8 THEN
        RETURN "========================================";
    ELSE
        RETURN "";
    ENDIF
ENDFUNC

! Example: Write version info to log file
! Usage:
!   Open "HOME:/mylog.txt", logfile \Write;
!   FOR i FROM 1 TO 8 DO
!       Write logfile, GetVersionLine(i);
!   ENDFOR
!   Close logfile;

! Get formatted version string for logging
FUNC string GetVersionString()
    RETURN TASK1_VERSION + " (" + BUILD_DATE + ")";
ENDFUNC

ENDMODULE

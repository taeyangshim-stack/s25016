MODULE MainModule
	!========================================
	! TASK1 (Robot1) - MainModule
	! Version History
	!========================================
	! v1.9.48 (2026-02-21) - Floor coordinate TCP logging
	!   - Added CRobT(\Tool:=tWeld1\WObj:=WobjFloor) to SetRobot1InitialPosition
	!   - Logs TCP_Floor position + orientation to robot1_init_position.txt
	!   - For verifying Robot1/Robot2 TCP meeting point at R-axis center
	!
	! v1.9.47 (2026-02-20) - ExecMoveJgJ segmented move
	!   - FIX: Split large gantry moves into segments (ABB 50050 workaround)
	!   - Linear axes: max 2000mm per segment, R-axis: max 45deg per segment
	!   - Changed speed to v100, zone to fine/z50 for stability
	!   - Added ERROR handler with ERRNO logging to debug_movejgj.txt
	!   - Added eax_e logging for complete axis diagnostics
	!
	! v1.9.46 (2026-02-19) - ExecMoveJgJ eax_f sync
	!   - FIX: eax_f explicitly synced to eax_a (X2=X1)
	!   - Added file-based debug logging (HOME:/debug_movejgj.txt)
	!   - Confirmed: eax_f must be valid value, not 9E+09 (40512 error)
	!   - Confirmed: eax_f must equal eax_a (desync causes 10125)
	!
	! v1.9.45 (2026-02-19) - eax_f=9E+09 test (reverted)
	!   - TEST: Set eax_f=9E+09 to exclude from motion planning
	!   - RESULT: 40512 Missing External Axis Value - eax_f is required axis
	!
	! v1.9.44 (2026-02-19) - eax_f=CJointT test (reverted)
	!   - TEST: Keep eax_f from CJointT (current value 0)
	!   - RESULT: 10125 Program stopped - X1/X2 desync when eax_a != eax_f
	!
	! v1.9.43 (2026-02-19) - ExecMoveJgJ debug logging
	!   - Added debug file output (HOME:/debug_movejgj.txt)
	!   - Rob1_CommandListener header updated to v1.9.43
	!   - Logs current/target extax values, vSync, MoveAbsJ start/completion
	!
	! v1.9.42 (2026-02-18) - ExecMoveJgJ for tWeld1
	!   - NEW: ExecMoveJgJ procedure - keeps robot joints from CJointT()
	!   - T_Head jRob1.robax is tool0-calculated, not compatible with tWeld1
	!   - Only overrides gantry extax (X1, Y, Z, R) from jGantry
	!   - Rob2_MainModule: Removed MoveAbsJ jRob2 from MoveJgJ case
	!     (Robot2 keeps tWeld2 posture during gantry move)
	!
	! v1.9.41 (2026-02-18) - T_Head command interface
	!   - Rob1_CommandListener: stCommand handler for T_Head
	!   - Supports MoveJgJ, MovePgJ, MovePgL, checkpos commands
	!   - Manages stReact{1} (robot) and stReact{3} (gantry)
	!
	! v2.2.0 (2026-02-18) - PlanC Phase 1
	!   - TestWeldSequence() now routes to TestFullWeldSequence
	!   - "Weld"/"WeldMotion" commands use full edge-based weld sequence
	!   - TraceWeldLine v2.1.0: multi-segment path (40-segment capable)
	!   - GenerateWeldPath(): linear interpolation of weld path positions
	!   - pWeldPosR1{40}/pWeldPosR2{40}/vWeldSpeed{40} path arrays
	!   - nMotionStepCount{1} controls segments per pass (default 6)
	!
	! v2.1.1 (2026-02-04)
	!   - Fixed linked motor handling (Error 50246)
	!   - Added CheckLinkedMotorSync() procedure
	!   - X1/X2 max_offset=2mm (MOC.cfg LINKED_M_PROCESS)
	!   - Cannot sync from RAPID - must restart controller
	!   - TestEdgeToWeld v2.0.1: Added Step 0 sync check
	!
	! v2.1.0 (2026-02-03)
	!   - Added PlanA-style command interface
	!   - nCmdInput/nCmdOutput/nCmdMatch variables in ConfigModule
	!   - CMD_* constants for all commands
	!   - rInit(), rCheckCmdMatch(), CommandLoop() procedures
	!   - TEST_MODE=10 enters real-time command loop
	!   - Upper system controls via nCmdInput variable
	!
	! v1.0.0 (2025-12-17)
	!   - Initial gantry position sharing system
	!   - Added shared_gantry_pos and related variables
	!   - Created UpdateSharedGantryPosition procedure
	!
	! v1.1.0 (2025-12-18)
	!   - Added wobj0 definition verification
	!   - ShowWobj0Definition procedure with file output
	!   - CompareWorldAndWobj0 procedure
	!   - Output to /HOME/task1_wobj0_definition.txt
	!
	! v1.2.0 (2025-12-18)
	!   - Added Work Object definitions
	!   - WobjFloor: Floor coordinate at [-9500, 5300, 2100] with RX 180deg rotation
	!   - wobjRob1Base: GantryRob coordinate with Y-axis 90deg rotation
	!
	! v1.2.1 (2025-12-19)
	!   - Fixed "Too intense frequency of Write" error (41617)
	!   - Added WaitTime 0.05 between Write operations
	!   - VerifyTCPOrientation procedure for 4 coordinate systems
	!
	! v1.3.0 (2025-12-23)
	!   - Added TestCoordinateMovement procedure
	!   - Move TCP and verify wobj0 vs Floor coordinate changes
	!   - Output to /HOME/task1_coordinate_test.txt
	!
	! v1.4.0 (2025-12-23)
	!   - Added MoveToMiddlePosition procedure
	!   - Added TestGantryAxisMovement procedure
	!   - Added TestGantryX/Y/Z quick test procedures
	!
	! v1.4.1 (2025-12-23)
	!   - Fixed Reference Error 50366
	!   - Removed MoveToMiddlePosition calls
	!   - Changed to relative movement only
	!
	! v1.4.2 (2025-12-24)
	!   - Added Robot TCP coordinate movement tests
	!   - TestRobot1_X, TestRobot1_Y, TestRobot1_Z procedures
	!
	! v1.4.3 (2025-12-24)
	!   - Combined X/Y/Z tests into single procedure
	!   - TestRobot1_XYZ replaces separate axis tests
	!   - Movement: [30, 20, 10] mm
	!
	! v1.4.4 (2025-12-24)
	!   - Reduced movement to avoid joint limits
	!   - Changed from [300, 200, 100] to [30, 20, 10]
	!   - Prevents 50050 "Position outside reach" error
	!
	! v1.4.5 (2025-12-24)
	!   - Added return to start position
	!   - Increased movement back to [50, 30, 20]
	!   - Save start position and return after test
	!
	! v1.4.6 (2025-12-24)
	!   - Start from home position (all 6 axes = 0deg)
	!   - Keep gantry position unchanged
	!   - Return to original joint position after test
	!
	! v1.4.7 (2025-12-24)
	!   - Avoid wrist singularity
	!   - Home position: [-90, 0, 0, 0, 30, 0] (J5 = 30deg)
	!
	! v1.5.0 (2025-12-24)
	!   - Added config.txt MODE support
	!   - ReadConfigMode() function reads /HOME/config.txt
	!   - Robot1 always uses wobj0 (MODE independent)
	!   - Display MODE for consistency with Robot2
	!
	! v1.7.28 (2025-12-29)
	!   - Added SetRobot1InitialPosition procedure
	!   - Robot1: [-90,0,0,0,0,0], Gantry: HOME position
	!
	! v1.7.29 (2025-12-29)
	!   - Fixed Z-axis out of range error (50027)
	!   - Changed HOME Z from 2100 to 700 (within physical limit)
	!
	! v1.7.30 (2025-12-29)
	!   - Moved TestGantryFloorCoordinates from TASK2 to TASK1
	!   - Changed HOME to physical origin [0,0,0,0]
	!   - HOME Physical [0,0,0,0] = Floor [9500,5300,2100,0]
	!
	! v1.7.31 (2025-12-30)
	!   - Added UpdateRobot2FloorPositionLocal to TASK1
	!   - Added WobjFloor_Rob2 and robot2_floor_pos_t1
	!   - Support cross-task Robot2 measurement from TASK1
	!
	! v1.7.32 (2025-12-30)
	!   - Fixed Floor->Physical coordinate transformation
	!   - Physical = Floor_offset - HOME_offset
	!   - Y, Z, R use subtraction due to Rx 180deg rotation
	!
	! v1.7.33 (2025-12-30)
	!   - Added X1-X2 synchronization in TestGantryFloorCoordinates
	!   - Prevent linked motor error 50246
	!
	! v1.7.34 (2025-12-30)
	!   - SetRobot1InitialPosition: Read position after robot movement
	!   - Changed home_pos := initial_pos -> home_pos := CJointT()
	!
	! v1.7.35 (2025-12-30)
	!   - SetRobot1InitialPosition: 2-step move to prevent error 50246
	!   - Step 1: Synchronize X1-X2 at current position
	!   - Step 2: Move all axes to HOME [0,0,0,0]
	!
	! v1.7.36 (2025-12-30)
	!   - SetRobot1InitialPosition: Re-read position in Step 2
	!   - Added home_pos := CJointT() after Step 1 movement
	!   - Ensures X1-X2 synchronization with actual current position
	!
	! v1.7.37 (2025-12-30)
	!   - SetRobot1InitialPosition: Added debug TPWrite messages
	!   - Display X1, X2 values before/after Step 1 synchronization
	!   - Display current position before Step 2 HOME movement
	!
	! v1.7.38 (2025-12-30)
	!   - Fixed Robot2 Floor measurement in TestGantryFloorCoordinates
	!   - Changed robot2_floor_pos_t1 to alias referencing TASK2's variable
	!   - Removed incorrect UpdateRobot2FloorPositionLocal (used wrong WObj)
	!   - Removed WobjFloor_Rob2 from TASK1 (only in TASK2)
	!   - TASK2 now updates robot2_floor_pos_t1 automatically via rUpdateR2Position
	!
	! v1.7.42 - v1.7.44 (2025-12-31)
	!   - Progressive X1-X2 synchronization in SetRobot1InitialPosition
	!   - Updated HOME position to TCP-based: [0, 0, 1000] in wobj0
	!
	! v1.7.45 (2025-12-31)
	!   - Added precise quaternions for HOME positions
	!   - Robot1: [0.5, -0.5, 0.5, 0.5]
	!   - Added intermediate joint [0, -2.58, -11.88, 0, 14.47, 0] to avoid config issues
	!
	! v1.7.46 - v1.7.47 (2025-12-31)
	!   - Fixed 40512 "Missing External Axis Value" error
	!   - Changed from extax=[9E9,...] to actual gantry position from CJointT()
	!   - Changed MoveL to MoveJ for HOME positioning
	!
	! v1.7.48 (2025-12-31)
	!   - Updated TestGantryFloorCoordinates position check
	!   - Changed from J1=-90/+90 check to J1~0 deg check (TCP-based HOME)
	!   - Fixed unicode symbols in comments (replaced +/-, ~ for ASCII)
	!
	! v1.7.49 (2025-12-31)
	!   - Added WobjGantry dynamic work object for TCP control
	!   - Implemented UpdateGantryWobj() to track gantry position
	!   - Enables TCP control from any gantry position
	!   - SetRobot1InitialPosition now uses WobjGantry instead of wobj0
	!
	! v1.7.50 (2025-12-31)
	!   - Corrected R-axis rotation orientation in UpdateGantryWobj()
	!   - R=0: Gantry parallel to Y-axis (perpendicular to X-axis) in Floor coordinate
	!   - Added base 90 deg rotation offset to quaternion calculation
	!
	! v1.7.51 (2026-01-03)
	!   - Replaced fixed WaitTime synchronization with flag-based mechanism
	!   - TASK1 now waits for robot2_init_complete flag from TASK2
	!   - Polls every 100ms with 20 second timeout
	!   - Logs actual wait time and detects timeout conditions
	!   - More robust and efficient than fixed 10 second delay
	!
	! v1.8.2 (2026-01-03)
	!   - CRITICAL FIX: Applied rotation transformation matrix in UpdateRobot2BaseDynamicWobj()
	!   - Robot2 wobj0 coordinates now properly rotated to Floor coordinates
	!   - Fixes incorrect Robot2 TCP during R-axis rotation (was offset by 976mm at R=90deg)
	!   - Robot1 and Robot2 TCP now correctly overlap at R-center for all R angles
	!   - Added rotation matrix: [cos(theta) -sin(theta); sin(theta) cos(theta)]
	!   - Added debug logging for rotated offset values
	!
		! v1.8.7 (2026-01-05)
		!   - STABILITY: Reduced TestGantryRotation header writes to lower 41617 risk.
		!   - STABILITY: Minimized SetRobot1InitialPosition file logging (summary-only).
		!   - STABILITY: Increased per-angle WaitTime to 0.2 in TestGantryRotation.
		!
		! v1.8.8 (2026-01-05)
		!   - STABILITY: Reduced main process log writes to lower 41617 risk.
		!
	! v1.8.9 (2026-01-05)
	!   - STABILITY: Reduced SetRobot1InitialPosition file logging to 1-line summary.
	!
	! v1.8.10 (2026-01-05)
	!   - FEAT: Added TEST_MODE=2 gantry + TCP offset verification.
	!
	! v1.8.11 (2026-01-06)
	!   - FIX: Guard config parsing in TestGantryMode2 to avoid StrPart errors.
	!
	! v1.8.12 (2026-01-06)
	!   - FIX: Support NUM_COMPLEX_POS/COMPLEX_POS_* and validate NUM_POS range.
	!   - FIX: Allow missing TCP_OFFSET_* with default 0 values.
	!
	! v1.8.14 (2026-01-06)
	!   - FIX: Align gantry axis range checks with MOC.cfg limits.
	!
	! v1.8.15 (2026-01-06)
	!   - Version sync with TASK2 (robot1_floor_pos scope fix in TASK2).
	!
	! v1.8.16 (2026-01-06)
	!   - Version sync with TASK2 (robot1_floor_pos TASK PERS init fix).
	!
	! v1.8.17 (2026-01-06)
	!   - Version sync with TASK2 (robot1_floor_pos_t2 rename in TASK2).
	!
	! v1.8.18 (2026-01-06)
	!   - FIX: Rename robot1_floor_pos to robot1_floor_pos_t1 to avoid PERS ambiguity.
	!
	! v1.8.19 (2026-01-06)
	!   - FIX: Rename robot2_floor_pos to robot2_floor_pos_t1 to avoid PERS ambiguity.
	!
	! v1.8.20 (2026-01-06)
	!   - Version sync with TASK2 (robot2_floor_pos_t1 rename in TASK2).
	!
	! v1.8.21 (2026-01-06)
	!   - FIX: Return gantry to HOME after Mode2 test (including out-of-range stop).
	!
	! v1.8.22 (2026-01-06)
	!   - FEAT: Support per-robot TCP offsets (R1) for Mode2 via TCP_OFFSET_R1_*.
	!
	! v1.8.23 (2026-01-07)
	!   - FIX: Make Mode2 TCP offset parsing tolerant of leading whitespace.
	!
	! v1.8.24 (2026-01-07)
	!   - DEBUG: Log Mode2 TCP offset parse results and raw lines.
	!
	! v1.8.25 (2026-01-07)
	!   - FIX: Ignore comment lines and require successful parse for TCP offsets.
	!
	! v1.8.26 (2026-01-07)
	!   - FIX: Trim leading whitespace and require exact key prefix for TCP offsets.
	!
	! v1.8.27 (2026-01-07)
	!   - FIX: Remove tab escape in trim loop for RAPID syntax compatibility.
	!
	! v1.8.28 (2026-01-07)
	!   - FIX: Remove RemoveCR option in Mode2 offset parse loop.
	!
	! v1.8.29 (2026-01-07)
	!   - FIX: Remove RemoveCR option in Mode2 position parsing loops.
	!
! v1.8.30 (2026-01-07)
!   - FIX: Stop Mode2 config parsing once required keys are found.
!
! v1.8.31 (2026-01-07)
!   - FIX: Use TASK PERS for robot2_init_complete to share init flag with TASK2.
!
! v1.8.32 (2026-01-08)
!   - FIX: Initialize TASK PERS robot2_init_complete to satisfy RAPID syntax.
!
! v1.8.35 (2026-01-08)
!   - FIX: Revert robot2_init_complete to shared PERS for cross-task sync.
!
! v1.8.39 (2026-01-08)
!   - FEAT: Share Mode2 TCP offsets for Robot2 via PERS variables.
!
! v1.8.40 (2026-01-08)
!   - DIAG: Add Mode2 entry logging and config parse markers.
!
! v1.8.41 (2026-01-08)
!   - DIAG: Log config open, parse entry, and ERRNO in Mode2.
!
! v1.8.42 (2026-01-08)
!   - DIAG: Persist Mode2 error details to gantry_mode2_test.txt.
!
! v1.8.53 (2026-01-10)
!   - FIX: Read current_gantry.extax after MoveAbsJ (eax_e mismatch fix)
!   - FIX: Robot1 TCP now properly stays at offset position during gantry rotation
!   - FEAT: TP messages saved to tp_messages.txt (separate log file)
!
! v1.8.52 (2026-01-09)
!   - NEW: ConfigModule.mod for MODE2_* PERS settings
!   - NEW: VersionModule.mod for centralized version tracking
!
! v1.8.51 (2026-01-09)
!   - REFACTOR: Config migrated from file to PERS variables
!   - REMOVE: config.txt parsing code (590 lines removed)
!   - FIX: ReadStr hang issue completely resolved
!
! v1.8.50 (2026-01-08)
!   - CHG: Hardcode Mode2 defaults and ignore config.txt.
!
! v1.8.49 (2026-01-08)
!   - FIX: Replace CONTINUE with GOTO label in Mode2 parse loop.
!
! v1.8.48 (2026-01-08)
!   - FIX: Safe single-pass Mode2 config parsing with line guards.
!
! v1.8.47 (2026-01-08)
!   - TEMP: Bypass Mode2 config parsing and use default offsets/positions.
!
! v1.8.46 (2026-01-08)
!   - FIX: Use ReadStr \RemoveCR in Mode2 config parsing loops.
!
! v1.8.45 (2026-01-08)
!   - DIAG: Keep Mode2 log file open to avoid repeated Open/Close.
	!
	! v1.8.13 (2026-01-06)
	!   - FIX: Interpret COMPLEX_POS_* as HOME offsets (convert to Floor).
	!   - FIX: Add gantry axis range checks before MoveAbsJ.
		!
		! v1.8.5 (2026-01-04)
		!   - STABILITY: Implemented 1-line CSV logging in TestGantryRotation to eliminate error 41617.
		!   - STABILITY: Replaced chunked Write calls with single Write per angle, reducing I/O frequency.
		!   - STANDARDS: Added CSV header for structured logging output.
		!
		! v1.8.4 (2026-01-04)
		!   - STABILITY: Reverted previous logging change that caused Value Error.
		!   - STABILITY: Implemented chunked logging with multiple WaitTime 0.1s in TestGantryRotation 
		!     to fix persistent "Too intense frequency of Write" error (41617).
		!
		! v1.8.3 (2026-01-04)
		!   - STABILITY: Corrected file handle usage in 6 diagnostic procedures (unified to `logfile`).
		!   - STABILITY: Added robust ERROR handlers to all file I/O procedures.
		!   - STABILITY: Set motion/initialization procedures to STOP on error, diagnostics to TRYNEXT.
		!   - STANDARDS: Replaced Unicode characters (theta) with ASCII equivalents.
		!
		! v1.8.1 (2026-01-03)
		!   - BUGFIX: Added UpdateRobot2BaseDynamicWobj() call in TestGantryRotation()
		!   - BUGFIX: Increased WaitTime from 0.05 to 0.1 to prevent error 41617
		!   - Fixed Robot2 Floor TCP reporting [0,0,0] in R-axis rotation tests
		!
		! v1.8.0 (2026-01-03)
		!   - Added R-axis rotation testing capability
		!   - Extended config.txt with TEST_MODE (0~3)
		!   - TEST_MODE=0: Single position (backward compatible)
		!   - TEST_MODE=1: R-axis rotation test (multiple angles)
		!   - TEST_MODE=2: Complex motion (translation + rotation)
		!   - TEST_MODE=3: Custom multi-position test
		!   - Added TestGantryRotation() procedure
		!   - Enhanced logging: quaternion, R-axis details
		!========================================

! ========================================
! Version Management
! ========================================
! NOTE: Version constants moved to VersionModule.mod
! TASK1_VERSION, TASK2_VERSION, etc. are defined in VersionModule
! Access them directly: TASK1_VERSION, GetVersionString(), PrintVersionInfo()

	TASK PERS seamdata seam1:=[0.5,0.5,[5,0,24,120,0,0,0,0,0],0.5,1,10,0,5,[5,0,24,120,0,0,0,0,0],0,1,[5,0,24,120,0,0,0,0,0],0,0,[0,0,0,0,0,0,0,0,0],0];
	TASK PERS welddata weld1:=[6,0,[5,0,24,120,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
	TASK PERS weavedata weave1_rob1:=[1,0,3,4,0,0,0,0,0,0,0,0,0,0,0];
    PERS tooldata tWeld1:=[TRUE,[[319.990,0,331.830],[0.92590,0,0.37784,0]],[3.1,[-71.4,3.8,173.2],[1,0,0,0],0.055,0.049,0.005]];
	TASK PERS trackdata track1_rob1:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
	PERS tasks Alltask{2}:=[["T_ROB1"],["T_ROB2"]];
    VAR syncident Sync1;
	PERS pose pose1:=[[0.775146,-0.00012207,-0.0380859],[1,0,0,0]];
	CONST robtarget pWire_Cut:=[[-66.37,0.19,11509.72],[0.415893,-0.575537,-0.42594,0.560683],[-1,-2,1,0],[11500,-4.91429E-05,-0.000147837,1.78433E-06,0,11500]];
	CONST robtarget pWire_Cut10:=[[-66.37,50.10,11509.72],[0.415891,-0.57554,-0.425936,0.560684],[-1,-2,1,0],[11500,-4.91429E-05,-1.11791E-06,-0.000149404,0,11500]];
	CONST robtarget pWire_Cut20:=[[-66.37,50.10,11509.71],[0.415891,-0.575539,-0.425939,0.560683],[-1,-2,1,0],[11500,-4.91429E-05,-1.11791E-06,1.78433E-06,0,11500]];
	CONST robtarget pWire_Cut30:=[[8.64,50.10,11509.71],[0.41589,-0.57554,-0.425938,0.560683],[-1,-2,1,0],[11500,-4.91429E-05,-1.11791E-06,1.78433E-06,0,11500]];
	CONST robtarget pWire_Cut40:=[[8.64,50.10,11509.72],[0.415893,-0.575537,-0.42594,0.560682],[-1,-2,1,0],[11500,-4.91429E-05,-1.11791E-06,1.78433E-06,0,11500]];
	CONST robtarget pWire_Cut50:=[[210.11,-22.74,11790.90],[0.274551,-0.626527,-0.316515,0.657195],[-1,-1,0,0],[11500,0.00274822,0.00777501,1.78433E-06,0,11500]];
	CONST robtarget pWire_Cut60:=[[569.16,494.31,12363.00],[0.00912714,-0.377804,0.00372676,0.925833],[-1,-1,0,1],[11500,-0.000557755,-0.00132159,1.78433E-06,0,11500]];
	CONST robtarget pWire_Cut70:=[[569.16,494.31,12363.00],[0.00912865,-0.377805,0.00372737,0.925833],[-1,0,-1,1],[11500,0.000459469,-0.000881434,1.78433E-06,0,11500]];
	VAR syncident sync2;
	VAR syncident sync3;
    CONST robtarget Target_70:=[[1161.172779454,144.559329246,-14.871009752],[0.061622373,-0.061632152,0.704422634,-0.704409621],[0,-1,0,0],[50.497416407,99.641412497,66.590927541,0,0,2.893288836]];
    CONST robtarget Target_80:=[[1161.172382635,144.558432538,-14.87045264],[0.061622111,-0.06163207,0.704422579,-0.704409706],[0,-1,0,0],[129.957869649,168.339699507,103.588841856,0,0,7.446037445]];
	TASK PERS jointtarget jTemp_rob1:=[[0,-2.51761,-12.1411,0,15.6587,0],[-500,500,300,15,0,-28.6479]];
	PERS pos nCaledR1Pos:=[-28.6282,626.304,300];

	! Shared Variables for Gantry Position (v1.0.0 2025-12-17)
	TASK PERS jointtarget shared_gantry_pos := [[0,0,0,0,0,0],[0,0,0,0,0,0]];
	TASK PERS num shared_gantry_x := 0;
	TASK PERS num shared_gantry_y := 0;
	TASK PERS num shared_gantry_z := 0;
	TASK PERS num shared_gantry_r := 0;
	TASK PERS num shared_gantry_x2 := 0;

	! Debug logging control (v1.7.50)
	VAR bool enable_debug_logging := FALSE;
	VAR iodev debug_logfile;
	TASK PERS num shared_update_counter := 0;
	TASK PERS num shared_test_value := 12345;

	! Robot Position Monitoring (v1.5.1 2025-12-25)
	! Robot1 TCP position in Floor coordinate system (for distance measurement)
	! Shared across tasks - use PERS (not TASK PERS) for cross-task access
	PERS robtarget robot1_floor_pos_t1 := [[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,0,0]];
	! Robot2 TCP position in Floor coordinate system (from TASK2)
	! External reference - initialized and updated by TASK2
	PERS robtarget robot2_floor_pos_t1;
! Robot2 initialization complete flag (from TASK2)
! External reference - set to TRUE by TASK2 when SetRobot2InitialPosition completes
PERS bool robot2_init_complete := FALSE;

! ========================================
! Mode2 Test Configuration (v1.8.52)
! ========================================
! NOTE: Configuration moved to ConfigModule.mod
! Edit MODE2_* variables in ConfigModule for easy access

! Robot2 TCP offsets (shared with TASK2)
! These mirror ConfigModule.MODE2_TCP_OFFSET_R2_* for cross-task access
! v1.8.57: Default changed to -100 (Robot2 below gantry center)
PERS num mode2_r2_offset_x := 0;
PERS num mode2_r2_offset_y := -100;
PERS num mode2_r2_offset_z := 0;

! Synchronization flag for TASK2 (v1.8.57)
! TASK2 waits for this flag before reading mode2_r2_offset values
! Prevents timing issue where TASK2 reads stale default values
PERS bool mode2_config_ready := FALSE;

! v1.8.63: Robot2 reposition sync flags
! TASK1 sets trigger, TASK2 repositions and sets done
PERS bool mode2_r2_reposition_trigger := FALSE;
PERS bool mode2_r2_reposition_done := FALSE;
! v1.8.67: Wait for Robot2 initial offset before moving gantry
PERS bool mode2_r2_initial_offset_done := FALSE;

! v1.9.17: Shared test_mode for cross-task synchronization
! TASK1 sets this after reading config.txt, TASK2 reads it
PERS num shared_test_mode := 0;

! v1.8.61 DEBUG: Robot2 calculation intermediate values
PERS num debug_r2_wobj0_x := 0;
PERS num debug_r2_wobj0_y := 0;
PERS num debug_r2_base_floor_x := 0;
PERS num debug_r2_base_floor_y := 0;
PERS num debug_r2_floor_x_offset := 0;
PERS num debug_r2_floor_y_offset := 0;

	! Robot1 wobj0 snapshot for cross-task comparison
	PERS wobjdata robot1_wobj0_snapshot := [FALSE, TRUE, "", [[0,0,0],[1,0,0,0]], [[0,0,0],[1,0,0,0]]];

	! Work Object Definitions (v1.7.7 2025-12-28)
	! WobjFloor: Floor coordinate system for Robot1 (fixed, for measurement)
	PERS wobjdata WobjFloor := [FALSE, TRUE, "", [[-9500, 5300, 2100], [0, 1, 0, 0]], [[0, 0, 0], [1, 0, 0, 0]]];

	! WobjGantry: Dynamic work object that tracks gantry position (v1.7.49)
	! Updated by UpdateGantryWobj() before TCP movements
	! Allows TCP control regardless of gantry position
	PERS wobjdata WobjGantry := [FALSE, TRUE, "", [[0, 0, 0], [1, 0, 0, 0]], [[0, 0, 0], [1, 0, 0, 0]]];

	! WobjRobot2Base_Dynamic: Robot2 base coordinate in Floor system (v1.7.50)
	! Updated by UpdateRobot2BaseDynamicWobj() in TASK1
	! Tracks Robot2 base position as gantry moves
	! Robot2 base direction = Floor direction (no rotation, quaternion [1,0,0,0])
	! Robot2 offset from R-axis center: -488mm on Y-axis
	PERS wobjdata WobjRobot2Base_Dynamic := [FALSE, TRUE, "", [[0, 0, 0], [1, 0, 0, 0]], [[0, 0, 0], [1, 0, 0, 0]]];

	! wobjRob1Base: Robot1 Base Frame = GantryRob coordinate system (Y-axis 90deg rotation)
	! Quaternion [0, 0.707107, 0, 0.707107] = Y-axis 90deg rotation
	PERS wobjdata wobjRob1Base := [FALSE, TRUE, "", [[0, 0, 0], [0, 0.707107, 0, 0.707107]], [[0, 0, 0], [1, 0, 0, 0]]];

	! ========================================
	! Weld Sequence Work Objects (v1.9.0)
	! ========================================
	! WobjWeldR1: Robot1 weld line coordinate system
	! Origin = weld start point, X = weld direction, Z = down
	PERS wobjdata WobjWeldR1 := [FALSE, TRUE, "", [[0, 0, 0], [1, 0, 0, 0]], [[0, 0, 0], [1, 0, 0, 0]]];

	! WobjWeldR2: Robot2 weld line coordinate system
	! Origin = weld start point, X = weld direction, Z = down
	PERS wobjdata WobjWeldR2 := [FALSE, TRUE, "", [[0, 0, 0], [1, 0, 0, 0]], [[0, 0, 0], [1, 0, 0, 0]]];

	! wobjWeldLine1: Shared PERS from T_Head (weld line coordinate for Robot1 safety check)
	PERS wobjdata wobjWeldLine1;

	! Weld Sequence Variables (v1.9.0)
	! Center line calculated from Robot1 and Robot2 weld lines
	VAR pos weld_center_start;
	VAR pos weld_center_end;
	VAR num weld_center_angle;    ! R-axis angle (degrees)
	VAR num weld_length;          ! Weld line length (mm)

	! ========================================
	! Edge-based Weld Variables (v2.0.0)
	! ========================================
	! PlanA compatible naming for center line
	! NOTE: calcPosStart/calcPosEnd PERS defined in ConfigModule
	VAR pos calcPosStart;         ! Local calc: center line start (avg of edgeStart{1,2})
	VAR pos calcPosEnd;           ! Local calc: center line end (avg of edgeEnd{1,2})
	VAR num nAngleRzStore;        ! R-axis angle (degrees) - PlanA naming
	! NOTE: bRobSwap PERS defined in ConfigModule
	VAR num calcLengthWeldLine;      ! Weld line length (mm) - PlanA naming
	VAR num calcOffsetLengthBuffer;  ! Robot offset from weld line (renamed to avoid PERS conflict)

	! ========================================
	! 40-Segment Path Arrays (PlanC Phase 1)
	! ========================================
	! Dynamically generated by GenerateWeldPath()
	! pWeldPosR1{i}: Robot1 weld path positions (WobjFloor coords)
	! pWeldPosR2{i}: Robot2 weld path positions (WobjFloor coords)
	! vWeldSpeed{i}: Per-segment weld speed
	VAR robtarget pWeldPosR1{40};
	VAR robtarget pWeldPosR2{40};
	VAR speeddata vWeldSpeed{40};

	! TASK2 sync flags for edge-based weld sequence (v2.0.0)
	PERS bool t1_weld_position_ready := FALSE;  ! Gantry + Robot1 positioned
	PERS bool t1_weld_start := FALSE;           ! Start welding signal
	PERS bool t1_weld_done := FALSE;            ! Welding complete
	PERS bool shared_bRobSwap := FALSE;         ! Share bRobSwap with TASK2

	! TASK2 sync flags for weld sequence
	PERS bool t2_weld_ready := FALSE;

	! Robot2 edge positions (shared with TASK2 via PERS, v1.9.37)
	PERS pos shared_calcPosStart_r2 := [0, 0, 0];
	PERS pos shared_calcPosEnd_r2 := [0, 0, 0];
	PERS num shared_calcLengthWeldLine := 0;

	! stCommand/stReact Protocol (v1.9.39 - T_Head interface)
	! T_Head sets stCommand, TASK1/2 respond via stReact
	! NOTE: stCommand/stReact defined in ConfigModule (cross-task PERS)

	PROC main()
		VAR iodev main_logfile;
		VAR iodev configfile;
		VAR num wait_counter;
		VAR num max_wait_cycles;
		VAR num test_mode;
		VAR string line;
		VAR string value_str;
		VAR bool found_value;
		VAR bool timeout_flag;
		VAR num max_wait_time;

		! v1.9.40: Reset shared_test_mode to prevent TASK2 from using stale PERS value
		shared_test_mode := 0;

		! Read TEST_MODE from config.txt
		test_mode := 0;  ! Default: backward compatible
		Open "HOME:/config.txt", configfile \Read;
		WHILE test_mode = 0 DO
			line := ReadStr(configfile);
			IF StrFind(line, 1, "TEST_MODE=") = 1 THEN
				IF StrLen(line) >= 11 THEN
					value_str := StrPart(line, 11, StrLen(line) - 10);
					found_value := StrToVal(value_str, test_mode);
					TPWrite "TEST_MODE=" + NumToStr(test_mode, 0);
					GOTO test_mode_found;
				ENDIF
			ENDIF
		ENDWHILE
		test_mode_found:
		Close configfile;

		! v1.9.17: Share test_mode with TASK2
		shared_test_mode := test_mode;

		! Step 1: Initialize Robot1 and Gantry (TPWrite FIRST for immediate UI feedback)
		TPWrite "========================================";
		TPWrite "MAIN: Starting Robot1 initialization...";
		TPWrite "========================================";

		! Open main process log (moved after TPWrite - file I/O causes delay)
		Open "HOME:/main_process.txt", main_logfile \Write;
		Write main_logfile, "Main Process Log (" + TASK1_VERSION + ") Date=" + CDate() + " Time=" + CTime();
		SetRobot1InitialPosition;
		TPWrite "MAIN: Robot1 initialization completed";
		Write main_logfile, "Step1 done (Robot1 init)";

		! Wait for TASK2 (Robot2) initialization to complete using WaitUntil (reactive)
		! v1.9.26: WaitUntil replaces polling loop for faster response
		IF test_mode = 9 THEN
			! Menu mode: shorter wait (3 seconds max)
			TPWrite "MAIN: Menu mode - short wait for Robot2...";
			max_wait_time := 3;
		ELSE
			! Normal mode: full wait (10 seconds max)
			TPWrite "MAIN: Waiting for Robot2 initialization...";
			max_wait_time := 10;
		ENDIF

		timeout_flag := FALSE;
		WaitUntil robot2_init_complete = TRUE \MaxTime:=max_wait_time \TimeFlag:=timeout_flag;

		IF NOT timeout_flag THEN
			TPWrite "MAIN: Robot2 initialization confirmed (flag = TRUE)";
			Write main_logfile, "WaitRobot2 ok (WaitUntil)";
		ELSE
			TPWrite "MAIN: WARNING - Robot2 initialization timeout!";
			Write main_logfile, "WaitRobot2 timeout " + NumToStr(max_wait_time, 1) + " s";
		ENDIF

		! Step 2: Run Test based on TEST_MODE
		TPWrite "========================================";
		TPWrite "MAIN: Starting Test (MODE=" + NumToStr(test_mode,0) + ")...";
		TPWrite "========================================";
		IF test_mode = 0 THEN
			! Single position test (backward compatible)
			TPWrite "MAIN: Single Position Test";
			Write main_logfile, "Step2 mode=0 type=Single";
			TestGantryFloorCoordinates;
		ELSEIF test_mode = 1 THEN
			! R-axis rotation test
			TPWrite "MAIN: R-axis Rotation Test";
			Write main_logfile, "Step2 mode=1 type=R-axis";
			TestGantryRotation;
		ELSEIF test_mode = 2 THEN
			! Mode 2: gantry + TCP offset verification
			TPWrite "MAIN: Mode2 Test";
			Write main_logfile, "Step2 mode=2 type=Mode2";
			TestGantryMode2;
		ELSEIF test_mode = 3 THEN
			! Weld Sequence Test
			TPWrite "MAIN: Weld Sequence Test";
			Write main_logfile, "Step2 mode=3 type=WeldSequence";
			ExecuteWeldSequence;
		ELSEIF test_mode = 9 THEN
			! Interactive Menu (v1.9.2)
			TPWrite "MAIN: Starting Test Menu";
			Write main_logfile, "Step2 mode=9 type=TestMenu";
			TestMenu;
		ELSEIF test_mode = 10 THEN
			! PlanA-style Command Loop (v2.1.0)
			TPWrite "MAIN: Starting Command Loop (PlanA Style)";
			Write main_logfile, "Step2 mode=10 type=CommandLoop";
			rInit;
			CommandLoop;
		ELSEIF test_mode = 11 THEN
			! T_Head mode - enter stCommand listener (v1.9.39)
			TPWrite "MAIN: Starting T_Head Listener Mode";
			Write main_logfile, "Step2 mode=11 type=T_Head_Listener";
			Rob1_CommandListener;
		ELSE
			TPWrite "ERROR: Invalid TEST_MODE=" + NumToStr(test_mode,0);
			Write main_logfile, "ERROR: Invalid TEST_MODE=" + NumToStr(test_mode,0);
			TPWrite "Valid: 0=Single, 1=R-axis, 2=Mode2, 3=Weld, 9=Menu, 10=CmdLoop, 11=T_Head";
		ENDIF

		TPWrite "MAIN: Test completed";
		Write main_logfile, "Step2 done";

		! Close main log
		Write main_logfile, "Main Process completed at " + CTime();
		Close main_logfile;

		TPWrite "========================================";
		TPWrite "MAIN: All tests completed!";
		TPWrite "Check log files:";
		TPWrite "  - main_process.txt";
		TPWrite "  - robot1_init_position.txt";
		TPWrite "  - robot2_init_position.txt";
		TPWrite "  - gantry_floor_test.txt";
		TPWrite "========================================";

		! Original: rUpdateR1Position;
	ENDPROC
    
    PROC rUpdateR1Position()
        VAR num X;
        VAR num Y;
        VAR num Z;
        VAR num R;
        VAR num X1;
        VAR num Y1;
        VAR num Z1;
        !        jTemp_rob1:=[[0,0,0,0,0,0],[0,0,0,30,0,0]];
        jTemp_rob1 := CJointT(\TaskName:="T_ROB1");

        X:=jTemp_rob1.extax.eax_a;
        Y:=jTemp_rob1.extax.eax_b;
        Z:=jTemp_rob1.extax.eax_c;
        R:=jTemp_rob1.extax.eax_d;

        X1:=X+(488*cos(R));
        !X2:=X-(976*cos(R));
        Y1:=Y+(488*sin(R));
        !Y2:=Y-(976*sin(R));

        nCaledR1Pos:=[X1,Y1,Z];
    ENDPROC
	PROC mainCopy()
		SyncMoveOn Sync1, Alltask;
		MoveL [[2094.90,-367.86,12453.71],[0.0969749,-0.464748,0.371902,-0.79768],[-1,-1,0,1],[12000,470.018,767.656,0.000203368,0,12000]]\ID:=40, v1000, z50, tWeld1;
		ArcLStart [[2094.96,-367.84,12453.68],[0.0969752,-0.464783,0.371888,-0.797666],[-1,-1,0,1],[12000,470.019,767.664,0.000203368,0,12000]]\ID:=10, v1000, seam1, weld1\Weave:=weave1_rob1, fine, tWeld1;
		ArcL [[2094.90,-367.87,12453.71],[0.0969776,-0.464746,0.371904,-0.79768],[-1,-1,0,1],[12000,470.018,767.656,0.000203368,0,12000]]\ID:=20, v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1;
		ArcLEnd [[2095.02,-367.83,11972.6],[0.0969842,-0.464821,0.371896,-0.79764],[-1,-1,0,1],[11519,470.018,767.679,0.000102576,0,11519]]\ID:=30, v1000, seam1, weld1\Weave:=weave1_rob1, fine, tWeld1;
		SyncMoveOff Sync1;
		!MoveL [[2094.90,-367.87,12453.71],[0.0969765,-0.464746,0.371905,-0.79768],[-1,-1,0,1],[12000,470.018,767.656,0.000203368,0,12000]], v1000, z50, tWeld1;
		WaitTime 3;
		!Search_1D pose1, [[2103.66,-574.48,11839.24],[0.196295,0.468915,0.294361,0.809282],[-1,-1,-1,1],[11656.7,1147.82,753.091,-49.1263,0,11656.7]], [[2117.43,-574.48,11839.25],[0.196294,0.468909,0.29436,0.809287],[-1,-1,-1,1],[11656.7,1147.82,753.087,-49.1263,0,11656.7]], v1000, tWeld1;
	ENDPROC
	PROC rFinal_200()
		MoveL [[2047.28,-525.15,12164.96],[0.0970333,-0.465179,0.371637,-0.797546],[-1,-1,-1,1],[11915.7,595.667,723.906,0.000203368,0,11915.7]], v1000, z50, tWeld1;
		WaitSyncTask Sync1, Alltask;
		SyncMoveOn Sync1, Alltask;
		ArcLStart [[2103.49,-543.85,12164.96],[0.114652,-0.524236,0.379809,-0.75351],[-1,-1,-1,1],[11915.7,595.666,723.906,0.000203368,0,11915.7]]\ID:=10, v1000, seam1, weld1\Weave:=weave1_rob1, fine, tWeld1;
		ArcL [[2103.49,-508.95,12164.96],[0.114648,-0.524233,0.379808,-0.753513],[-1,-1,0,1],[11915.7,595.666,723.906,0.000203368,0,11915.7]]\ID:=20, v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1;
		ArcL [[2103.49,-508.95,12064.02],[0.114649,-0.524232,0.379809,-0.753513],[-1,-1,-1,1],[11915.7,595.666,723.906,0.000203368,0,11915.7]]\ID:=30, v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1;
		ArcL [[2102.86,-509.83,11932.99],[0.114649,-0.524234,0.379807,-0.753512],[-1,-1,-1,1],[11784.6,596.544,723.906,0.000203368,0,11784.6]]\ID:=40, v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1;
		ArcL [[2102.86,-510.25,11598.24],[0.114651,-0.524236,0.379808,-0.75351],[-1,-1,-1,1],[11449.9,596.97,723.906,0.000203368,0,11449.9]]\ID:=50, v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1;
		ArcL [[2100.63,-510.26,11501.35],[0.114648,-0.524237,0.37981,-0.753508],[-1,-1,-1,1],[11449.9,596.97,723.906,0.00030416,0,11449.9]]\ID:=70, v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1;
		ArcLEnd [[2100.64,-536.41,11501.35],[0.114652,-0.524234,0.379806,-0.753512],[-1,-1,-1,1],[11449.9,596.97,723.906,0.00030416,0,11449.9]]\ID:=60, v1000, seam1, weld1\Weave:=weave1_rob1, fine, tWeld1;
		SyncMoveOff Sync1;
		MoveL [[2038.80,-475.20,11501.35],[0.114651,-0.524235,0.379811,-0.753509],[-1,-1,-1,1],[11449.9,596.969,723.906,0.00030416,0,11449.9]], v1000, z50, tWeld1;
		WaitTime 3;
	ENDPROC
	PROC rFinal_200_244()
		MoveL [[2047.28,-525.15,12164.96],[0.0970333,-0.465179,0.371637,-0.797546],[-1,-1,-1,1],[11915.7,595.667,723.906,0.000203368,0,11915.7]], v1000, z50, tWeld1;
		WaitSyncTask Sync1, Alltask;
		ArcLStart [[2103.54,-543.83,12164.95],[0.114657,-0.524252,0.379793,-0.753506],[-1,-1,-1,1],[11915.7,595.668,723.913,0.00030416,0,11915.7]], v1000, seam1, weld1, fine, tWeld1;
		ArcL [[2103.54,-543.83,12059.63],[0.114655,-0.52425,0.379791,-0.753508],[-1,-1,-1,1],[11915.7,595.668,723.914,0.000203368,0,11915.7]], v1000, seam1, weld1, z10, tWeld1;
		WaitSyncTask sync2, Alltask;
		ArcL [[2103.55,-508.91,12063.99],[0.114677,-0.52426,0.379798,-0.753495],[-1,-1,-1,1],[11915.7,595.669,723.912,0.000203368,0,11915.7]], v1000, seam1, weld1, z10, tWeld1;
		!WaitTime 2;
		!ArcLStart [[2103.49,-543.85,12164.96],[0.114652,-0.524236,0.379809,-0.75351],[-1,-1,-1,1],[11915.7,595.666,723.906,0.000203368,0,11915.7]]\ID:=10, v1000, seam1, weld1\Weave:=weave1_rob1, fine, tWeld1;
		!ArcL [[2103.49,-508.95,12164.96],[0.114648,-0.524233,0.379808,-0.753513],[-1,-1,0,1],[11915.7,595.666,723.906,0.000203368,0,11915.7]]\ID:=20, v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1;
		SyncMoveOn sync3, Alltask;
		ArcL [[2103.49,-508.95,12064.02],[0.114649,-0.524232,0.379809,-0.753513],[-1,-1,-1,1],[11915.7,595.666,723.906,0.000203368,0,11915.7]]\ID:=30, v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1;
		ArcL [[2102.86,-509.83,11932.99],[0.114649,-0.524234,0.379807,-0.753512],[-1,-1,-1,1],[11784.6,596.544,723.906,0.000203368,0,11784.6]]\ID:=40, v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1;
		ArcL [[2102.86,-510.25,11598.24],[0.114651,-0.524236,0.379808,-0.75351],[-1,-1,-1,1],[11449.9,596.97,723.906,0.000203368,0,11449.9]]\ID:=50, v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1;
		ArcL [[2100.63,-510.26,11501.35],[0.114648,-0.524237,0.37981,-0.753508],[-1,-1,-1,1],[11449.9,596.97,723.906,0.00030416,0,11449.9]]\ID:=70, v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1;
		ArcLEnd [[2100.64,-536.41,11501.35],[0.114652,-0.524234,0.379806,-0.753512],[-1,-1,-1,1],[11449.9,596.97,723.906,0.00030416,0,11449.9]]\ID:=60, v1000, seam1, weld1\Weave:=weave1_rob1, fine, tWeld1;
		SyncMoveOff sync3;
		MoveL [[2038.80,-475.20,11501.35],[0.114651,-0.524235,0.379811,-0.753509],[-1,-1,-1,1],[11449.9,596.969,723.906,0.00030416,0,11449.9]], v1000, z50, tWeld1;
		WaitTime 3;
		!Search_1D pose1, [[2103.66,-574.48,11839.24],[0.196295,0.468915,0.294361,0.809282],[-1,-1,-1,1],[11656.7,1147.82,753.091,-49.1263,0,11656.7]], [[2117.43,-574.48,11839.25],[0.196294,0.468909,0.29436,0.809287],[-1,-1,-1,1],[11656.7,1147.82,753.087,-49.1263,0,11656.7]], v1000, tWeld1;
	ENDPROC
	PROC Routine1()
		MoveAbsJ [[-90,0,0,0,0,0],[11500,0,0,0,0,11500]]\NoEOffs, v1000, z50, tWeld1;
	ENDPROC
	PROC Routine2()
		MoveL [[2068.74,53.25,11799.20],[0.196641,0.468668,0.295017,0.809103],[-1,-1,-1,1],[11633.2,533.997,743.121,-49.2176,0,11633.2]], v1000, z50, tWeld1;
		ArcLStart [[2107.92,42.66,11799.75],[0.196617,0.468748,0.294994,0.809071],[-1,-1,-1,1],[11633.2,533.996,743.134,-49.2176,0,11633.2]], v1000, seam1, weld1\Weave:=weave1_rob1, fine, tWeld1\Track:=track1_rob1;
		ArcL [[2121.40,-108.42,11808.55],[0.196642,0.46866,0.295016,0.809108],[-1,-1,-1,1],[11633.2,533.997,743.12,-49.2176,0,11633.2]], v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1\Track:=track1_rob1;
		ArcL [[2121.40,-149.65,11815.47],[0.196646,0.46866,0.295015,0.809107],[-1,-1,-1,1],[11633.2,533.997,743.12,-49.2176,0,11633.2]], v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1\Track:=track1_rob1;
		ArcLEnd [[2121.40,-291.89,11809.14],[0.196651,0.468665,0.295018,0.809102],[-1,-1,-1,1],[11633.2,533.997,743.12,-49.2176,0,11633.2]], v1000, seam1, weld1\Weave:=weave1_rob1, fine, tWeld1\Track:=track1_rob1;
		MoveL [[2078.83,-291.89,11809.14],[0.196639,0.468664,0.295016,0.809106],[-1,-1,-1,1],[11633.2,533.997,743.12,-49.2176,0,11633.2]], v1000, z50, tWeld1;
	ENDPROC
	PROC Routine3()
		MoveJ pWire_Cut60, v1000, z50, tWeld1;
		MoveJ pWire_Cut50, v1000, z50, tWeld1;
		MoveJ pWire_Cut30, v1000, z50, tWeld1;
		MoveJ pWire_Cut10, v1000, z50, tWeld1;
		MoveL pWire_Cut, v1000, z50, tWeld1;
		WaitTime 1;
		MoveL pWire_Cut20, v1000, z50, tWeld1;
		MoveL pWire_Cut40, v1000, z50, tWeld1;
		MoveJ pWire_Cut70, v1000, z50, tWeld1;
	ENDPROC
	PROC Routine4()
		MoveL [[2042.32,-66.65,11540.79],[0.097731,-0.470113,0.37174,-0.794514],[-1,-1,0,1],[11152.8,171.336,712.533,1.78433E-06,0,11152.8]], v1000, z50, tWeld1;
		ArcLStart [[2078.19,-66.65,11540.79],[0.0977313,-0.470112,0.371741,-0.794514],[-1,-1,0,1],[11152.8,171.336,748.408,1.78433E-06,0,11152.8]], v1000, seam1, weld1, fine, tWeld1;
	ENDPROC
	PROC Routine5()
		MoveAbsJ [[-90,0,0,0,0,0],[0,0,0,0,0,0]]\NoEOffs, v1000, z50, tWeld1;
	ENDPROC
    PROC Path_10()
        MoveL Target_70,v1000,z100,tool0\WObj:=wobj0;
        MoveL Target_80,v1000,z100,tool0\WObj:=wobj0;
    ENDPROC

	!========================================
	! Update Gantry Position
	!========================================
	PROC UpdateSharedGantryPosition()
		VAR jointtarget current_pos;

		current_pos := CJointT();
		shared_gantry_pos := current_pos;
		shared_gantry_x := current_pos.extax.eax_a;
		shared_gantry_y := current_pos.extax.eax_b;
		shared_gantry_z := current_pos.extax.eax_c;
		shared_gantry_r := current_pos.extax.eax_d;
		shared_gantry_x2 := current_pos.extax.eax_f;
		shared_update_counter := shared_update_counter + 1;

	ERROR
		TPWrite "ERROR in UpdateSharedGantryPosition: " + NumToStr(ERRNO, 0);
	ENDPROC

	PROC ContinuousUpdateGantryPosition()
		TPWrite "Starting continuous gantry position update...";

		WHILE TRUE DO
			UpdateSharedGantryPosition;
			WaitTime 0.1;
		ENDWHILE

	ERROR
		TPWrite "ERROR in ContinuousUpdateGantryPosition: " + NumToStr(ERRNO, 0);
	ENDPROC

	PROC TestPrintSharedGantryPosition()
		TPWrite "========================================";
		TPWrite "TASK1 - Shared Gantry Position";
		TPWrite "========================================";

		UpdateSharedGantryPosition;

		TPWrite "Gantry External Axes:";
		TPWrite "  X1 = " + NumToStr(shared_gantry_x, 4) + " m";
		TPWrite "  Y  = " + NumToStr(shared_gantry_y, 4) + " m";
		TPWrite "  Z  = " + NumToStr(shared_gantry_z, 4) + " m";
		TPWrite "  R  = " + NumToStr(shared_gantry_r, 4) + " rad";
		TPWrite "  X2 = " + NumToStr(shared_gantry_x2, 4) + " m";
		TPWrite "Update Counter: " + NumToStr(shared_update_counter, 0);
		TPWrite "========================================";

	ERROR
		TPWrite "ERROR in TestPrintSharedGantryPosition: " + NumToStr(ERRNO, 0);
	ENDPROC

	!========================================
	! Update Robot1 wobj0 Snapshot
	!========================================
	! Version: v1.6.0
	! Date: 2025-12-25
	! Purpose: Share Robot1 wobj0 data with other tasks
	PROC UpdateRobot1Wobj0Snapshot()
		robot1_wobj0_snapshot := wobj0;
	ENDPROC

	!========================================
	! Check wobj0 Definition
	!========================================
	! Version: v1.1.0
	! Date: 2025-12-18
	! Changes: Added file output to /HOME/task1_wobj0_definition.txt

	PROC ShowWobj0Definition()
		VAR string str_robhold;
		VAR string str_ufprog;
		VAR iodev logfile;

		TPWrite "========================================";
		TPWrite "TASK1 - wobj0 Definition (v1.1.0)";
		TPWrite "========================================";

		IF wobj0.robhold = TRUE THEN
			str_robhold := "TRUE";
		ELSE
			str_robhold := "FALSE";
		ENDIF

		IF wobj0.ufprog = TRUE THEN
			str_ufprog := "TRUE";
		ELSE
			str_ufprog := "FALSE";
		ENDIF

		TPWrite "wobj0.robhold: " + str_robhold;
		TPWrite "wobj0.ufprog: " + str_ufprog;
		TPWrite "";
		TPWrite "User Frame (uframe):";
		TPWrite "  X = " + NumToStr(wobj0.uframe.trans.x, 2) + " mm";
		TPWrite "  Y = " + NumToStr(wobj0.uframe.trans.y, 2) + " mm";
		TPWrite "  Z = " + NumToStr(wobj0.uframe.trans.z, 2) + " mm";
		TPWrite "  q1 = " + NumToStr(wobj0.uframe.rot.q1, 4);
		TPWrite "  q2 = " + NumToStr(wobj0.uframe.rot.q2, 4);
		TPWrite "  q3 = " + NumToStr(wobj0.uframe.rot.q3, 4);
		TPWrite "  q4 = " + NumToStr(wobj0.uframe.rot.q4, 4);
		TPWrite "";
		TPWrite "Object Frame (oframe):";
		TPWrite "  X = " + NumToStr(wobj0.oframe.trans.x, 2) + " mm";
		TPWrite "  Y = " + NumToStr(wobj0.oframe.trans.y, 2) + " mm";
		TPWrite "  Z = " + NumToStr(wobj0.oframe.trans.z, 2) + " mm";
		TPWrite "========================================";

		! Save to file
		Open "HOME:/task1_wobj0_definition.txt", logfile \Append;

		Write logfile, "========================================";
		Write logfile, "TASK1 - wobj0 Definition (v1.1.0)";
		Write logfile, "========================================";
		Write logfile, "Date: " + CDate();
		Write logfile, "Time: " + CTime();
		Write logfile, "";
		Write logfile, "wobj0.robhold: " + str_robhold;
		Write logfile, "wobj0.ufprog: " + str_ufprog;
		Write logfile, "";
		Write logfile, "User Frame (uframe):";
		Write logfile, "  X = " + NumToStr(wobj0.uframe.trans.x, 2) + " mm";
		Write logfile, "  Y = " + NumToStr(wobj0.uframe.trans.y, 2) + " mm";
		Write logfile, "  Z = " + NumToStr(wobj0.uframe.trans.z, 2) + " mm";
		Write logfile, "  q1 = " + NumToStr(wobj0.uframe.rot.q1, 4);
		Write logfile, "  q2 = " + NumToStr(wobj0.uframe.rot.q2, 4);
		Write logfile, "  q3 = " + NumToStr(wobj0.uframe.rot.q3, 4);
		Write logfile, "  q4 = " + NumToStr(wobj0.uframe.rot.q4, 4);
		Write logfile, "";
		Write logfile, "Object Frame (oframe):";
		Write logfile, "  X = " + NumToStr(wobj0.oframe.trans.x, 2) + " mm";
		Write logfile, "  Y = " + NumToStr(wobj0.oframe.trans.y, 2) + " mm";
		Write logfile, "  Z = " + NumToStr(wobj0.oframe.trans.z, 2) + " mm";
		Write logfile, "========================================\0A";

		Close logfile;
		TPWrite "Saved to: /HOME/task1_wobj0_definition.txt";

	ERROR
		TPWrite "ERROR in ShowWobj0Definition: " + NumToStr(ERRNO, 0);
		Close logfile;
		TRYNEXT;
	ENDPROC

	! Version: v1.1.0
	! Date: 2025-12-18
	! Changes: Added file output to /HOME/task1_world_vs_wobj0.txt

	PROC CompareWorldAndWobj0()
		VAR robtarget pos_world;
		VAR robtarget pos_wobj0;
		VAR iodev logfile;

		TPWrite "========================================";
		TPWrite "TASK1 - Compare World vs wobj0 (v1.1.0)";
		TPWrite "========================================";

		pos_world := CRobT(\Tool:=tool0);
		pos_wobj0 := CRobT(\Tool:=tool0\WObj:=wobj0);

		TPWrite "World Coordinates:";
		TPWrite "  X = " + NumToStr(pos_world.trans.x, 2) + " mm";
		TPWrite "  Y = " + NumToStr(pos_world.trans.y, 2) + " mm";
		TPWrite "  Z = " + NumToStr(pos_world.trans.z, 2) + " mm";
		TPWrite "";
		TPWrite "wobj0 Coordinates:";
		TPWrite "  X = " + NumToStr(pos_wobj0.trans.x, 2) + " mm";
		TPWrite "  Y = " + NumToStr(pos_wobj0.trans.y, 2) + " mm";
		TPWrite "  Z = " + NumToStr(pos_wobj0.trans.z, 2) + " mm";
		TPWrite "";
		TPWrite "Difference (World - wobj0):";
		TPWrite "  dX = " + NumToStr(pos_world.trans.x - pos_wobj0.trans.x, 2) + " mm";
		TPWrite "  dY = " + NumToStr(pos_world.trans.y - pos_wobj0.trans.y, 2) + " mm";
		TPWrite "  dZ = " + NumToStr(pos_world.trans.z - pos_wobj0.trans.z, 2) + " mm";
		TPWrite "========================================";

		! Save to file
		Open "HOME:/task1_world_vs_wobj0.txt", logfile \Append;

		Write logfile, "========================================";
		Write logfile, "TASK1 - Compare World vs wobj0 (v1.1.0)";
		Write logfile, "========================================";
		Write logfile, "Date: " + CDate();
		Write logfile, "Time: " + CTime();
		Write logfile, "";
		Write logfile, "World Coordinates:";
		Write logfile, "  X = " + NumToStr(pos_world.trans.x, 2) + " mm";
		Write logfile, "  Y = " + NumToStr(pos_world.trans.y, 2) + " mm";
		Write logfile, "  Z = " + NumToStr(pos_world.trans.z, 2) + " mm";
		Write logfile, "";
		Write logfile, "wobj0 Coordinates:";
		Write logfile, "  X = " + NumToStr(pos_wobj0.trans.x, 2) + " mm";
		Write logfile, "  Y = " + NumToStr(pos_wobj0.trans.y, 2) + " mm";
		Write logfile, "  Z = " + NumToStr(pos_wobj0.trans.z, 2) + " mm";
		Write logfile, "";
		Write logfile, "Difference (World - wobj0):";
		Write logfile, "  dX = " + NumToStr(pos_world.trans.x - pos_wobj0.trans.x, 2) + " mm";
		Write logfile, "  dY = " + NumToStr(pos_world.trans.y - pos_wobj0.trans.y, 2) + " mm";
		Write logfile, "  dZ = " + NumToStr(pos_world.trans.z - pos_wobj0.trans.z, 2) + " mm";
		Write logfile, "========================================\0A";

		Close logfile;
		TPWrite "Saved to: /HOME/task1_world_vs_wobj0.txt";

	ERROR
		TPWrite "ERROR in CompareWorldAndWobj0: " + NumToStr(ERRNO, 0);
		Close logfile;
		TRYNEXT;
	ENDPROC

	! ========================================
	! Verify TCP Orientation in All Coordinate Systems
	! ========================================
	! Version: v1.2.1
	! Date: 2025-12-19
	! Changes: Fixed "Too intense frequency of Write" error by adding WaitTime
	! Purpose: Compare TCP position and orientation in 4 coordinate systems:
	!   1. World - Global coordinate system
	!   2. wobj0 - Default work object (= World in current config)
	!   3. WobjFloor - Floor coordinate system at [-9500, 5300, 2100]
	!   4. wobjRob1Base - Robot1 Base Frame (GantryRob with Y-axis 90deg rotation)
	! Output: FlexPendant display + /HOME/task1_tcp_orientation.txt
	PROC VerifyTCPOrientation()
		VAR robtarget tcp_world;
		VAR robtarget tcp_wobj0;
		VAR robtarget tcp_floor;
		VAR robtarget tcp_rob_base;
		VAR iodev logfile;

		! Read TCP in all coordinate systems
		tcp_world := CRobT(\Tool:=tool0);
		tcp_wobj0 := CRobT(\Tool:=tool0\WObj:=wobj0);
		tcp_floor := CRobT(\Tool:=tool0\WObj:=WobjFloor);
		tcp_rob_base := CRobT(\Tool:=tool0\WObj:=wobjRob1Base);

		! Display on FlexPendant (reduced output)
		TPWrite "TASK1 - TCP Orientation (v1.2.1)";
		TPWrite "World: [" + NumToStr(tcp_world.trans.x, 1) + "," + NumToStr(tcp_world.trans.y, 1) + "," + NumToStr(tcp_world.trans.z, 1) + "]";
		TPWrite "Floor: [" + NumToStr(tcp_floor.trans.x, 1) + "," + NumToStr(tcp_floor.trans.y, 1) + "," + NumToStr(tcp_floor.trans.z, 1) + "]";
		TPWrite "Rob1Base: [" + NumToStr(tcp_rob_base.trans.x, 1) + "," + NumToStr(tcp_rob_base.trans.y, 1) + "," + NumToStr(tcp_rob_base.trans.z, 1) + "]";

		! Save to file (with WaitTime to prevent "Too intense frequency" error)
		Open "HOME:/task1_tcp_orientation.txt", logfile \Append;

		Write logfile, "========================================";
		Write logfile, "TASK1 - TCP Orientation Verification (v1.2.1)";
		Write logfile, "Date: " + CDate() + " " + CTime();
		Write logfile, "========================================";
		WaitTime 0.05;

		Write logfile, "1. World: Pos=[" + NumToStr(tcp_world.trans.x, 3) + "," + NumToStr(tcp_world.trans.y, 3) + "," + NumToStr(tcp_world.trans.z, 3) + "]";
		Write logfile, "   Rot=[" + NumToStr(tcp_world.rot.q1, 6) + "," + NumToStr(tcp_world.rot.q2, 6) + "," + NumToStr(tcp_world.rot.q3, 6) + "," + NumToStr(tcp_world.rot.q4, 6) + "]";
		WaitTime 0.05;

		Write logfile, "2. wobj0: Pos=[" + NumToStr(tcp_wobj0.trans.x, 3) + "," + NumToStr(tcp_wobj0.trans.y, 3) + "," + NumToStr(tcp_wobj0.trans.z, 3) + "]";
		Write logfile, "   Rot=[" + NumToStr(tcp_wobj0.rot.q1, 6) + "," + NumToStr(tcp_wobj0.rot.q2, 6) + "," + NumToStr(tcp_wobj0.rot.q3, 6) + "," + NumToStr(tcp_wobj0.rot.q4, 6) + "]";
		WaitTime 0.05;

		Write logfile, "3. Floor: Pos=[" + NumToStr(tcp_floor.trans.x, 3) + "," + NumToStr(tcp_floor.trans.y, 3) + "," + NumToStr(tcp_floor.trans.z, 3) + "]";
		Write logfile, "   Rot=[" + NumToStr(tcp_floor.rot.q1, 6) + "," + NumToStr(tcp_floor.rot.q2, 6) + "," + NumToStr(tcp_floor.rot.q3, 6) + "," + NumToStr(tcp_floor.rot.q4, 6) + "]";
		WaitTime 0.05;

		Write logfile, "4. Rob1Base: Pos=[" + NumToStr(tcp_rob_base.trans.x, 3) + "," + NumToStr(tcp_rob_base.trans.y, 3) + "," + NumToStr(tcp_rob_base.trans.z, 3) + "]";
		Write logfile, "   Rot=[" + NumToStr(tcp_rob_base.rot.q1, 6) + "," + NumToStr(tcp_rob_base.rot.q2, 6) + "," + NumToStr(tcp_rob_base.rot.q3, 6) + "," + NumToStr(tcp_rob_base.rot.q4, 6) + "]";
		WaitTime 0.05;

		Write logfile, "========================================\0A";

		Close logfile;
		TPWrite "Saved to: /HOME/task1_tcp_orientation.txt";

	ERROR
		TPWrite "ERROR in VerifyTCPOrientation: " + NumToStr(ERRNO, 0);
		Close logfile;
		TRYNEXT;
	ENDPROC

	! ========================================
	! Read Config Mode from /HOME/config.txt
	! ========================================
	! Version: v1.5.0
	! Date: 2025-12-24
	! Returns: 0 or 1 (default: 0 if file not found or error)
	FUNC num ReadConfigMode()
		VAR iodev configfile;
		VAR string line;
		VAR num mode_value;
		VAR bool found;
		VAR bool ok;

		mode_value := 0;  ! Default
		found := FALSE;

		! Try to open config.txt
		Open "HOME:/config.txt", configfile \Read;

		! Read lines until MODE= found
		WHILE found = FALSE DO
			line := ReadStr(configfile);

			! Check if line starts with "MODE="
			IF StrFind(line, 1, "MODE=") = 1 THEN
				! Extract number after "MODE=" (StrToVal returns bool, stores result in mode_value)
				ok := StrToVal(StrPart(line, 6, 1), mode_value);
				found := TRUE;
			ENDIF
		ENDWHILE

		Close configfile;
		RETURN mode_value;

	ERROR
		! File not found or read error - return default 0
		IF ERRNO = ERR_FILEOPEN THEN
			TPWrite "config.txt not found - using MODE=0";
		ENDIF
		Close configfile;
		RETURN 0;
	ENDFUNC

	! ========================================
	! Test Coordinate System Movement
	! ========================================
	! Version: v1.5.0
	! Date: 2025-12-24
	! Purpose: Verify coordinate system alignment by moving robot and comparing coordinates
	!   - Move robot in wobj0 coordinate system (Robot1 always uses wobj0)
	!   - Check if Floor coordinate system shows expected movement
	!   - Validates coordinate system direction and position relationship
	! Parameters:
	!   delta_x, delta_y, delta_z: Movement distance in wobj0 coordinates (mm)
	! Output: /HOME/task1_coordinate_test.txt
	PROC TestCoordinateMovement(num delta_x, num delta_y, num delta_z)
		VAR robtarget pos_start_wobj0;
		VAR robtarget pos_start_floor;
		VAR robtarget pos_target;
		VAR robtarget pos_end_wobj0;
		VAR robtarget pos_end_floor;
		VAR num diff_wobj0_x;
		VAR num diff_wobj0_y;
		VAR num diff_wobj0_z;
		VAR num diff_floor_x;
		VAR num diff_floor_y;
		VAR num diff_floor_z;
		VAR iodev logfile;

		! Read starting position in both coordinate systems
		pos_start_wobj0 := CRobT(\Tool:=tool0\WObj:=wobj0);
		pos_start_floor := CRobT(\Tool:=tool0\WObj:=WobjFloor);

		TPWrite "Start wobj0: [" + NumToStr(pos_start_wobj0.trans.x, 1) + "," + NumToStr(pos_start_wobj0.trans.y, 1) + "," + NumToStr(pos_start_wobj0.trans.z, 1) + "]";
		TPWrite "Start Floor: [" + NumToStr(pos_start_floor.trans.x, 1) + "," + NumToStr(pos_start_floor.trans.y, 1) + "," + NumToStr(pos_start_floor.trans.z, 1) + "]";

		! Calculate target position (wobj0 + delta)
		pos_target := pos_start_wobj0;
		pos_target.trans.x := pos_target.trans.x + delta_x;
		pos_target.trans.y := pos_target.trans.y + delta_y;
		pos_target.trans.z := pos_target.trans.z + delta_z;

		TPWrite "Moving wobj0: [" + NumToStr(delta_x, 1) + "," + NumToStr(delta_y, 1) + "," + NumToStr(delta_z, 1) + "]";

		! Move to target position
		MoveL pos_target, v100, fine, tool0\WObj:=wobj0;

		! Read ending position in both coordinate systems
		pos_end_wobj0 := CRobT(\Tool:=tool0\WObj:=wobj0);
		pos_end_floor := CRobT(\Tool:=tool0\WObj:=WobjFloor);

		TPWrite "End wobj0: [" + NumToStr(pos_end_wobj0.trans.x, 1) + "," + NumToStr(pos_end_wobj0.trans.y, 1) + "," + NumToStr(pos_end_wobj0.trans.z, 1) + "]";
		TPWrite "End Floor: [" + NumToStr(pos_end_floor.trans.x, 1) + "," + NumToStr(pos_end_floor.trans.y, 1) + "," + NumToStr(pos_end_floor.trans.z, 1) + "]";

		! Calculate differences
		diff_wobj0_x := pos_end_wobj0.trans.x - pos_start_wobj0.trans.x;
		diff_wobj0_y := pos_end_wobj0.trans.y - pos_start_wobj0.trans.y;
		diff_wobj0_z := pos_end_wobj0.trans.z - pos_start_wobj0.trans.z;

		diff_floor_x := pos_end_floor.trans.x - pos_start_floor.trans.x;
		diff_floor_y := pos_end_floor.trans.y - pos_start_floor.trans.y;
		diff_floor_z := pos_end_floor.trans.z - pos_start_floor.trans.z;

		TPWrite "wobj0 moved: [" + NumToStr(diff_wobj0_x, 1) + "," + NumToStr(diff_wobj0_y, 1) + "," + NumToStr(diff_wobj0_z, 1) + "]";
		TPWrite "Floor moved: [" + NumToStr(diff_floor_x, 1) + "," + NumToStr(diff_floor_y, 1) + "," + NumToStr(diff_floor_z, 1) + "]";

		! Save to file
		Open "HOME:/task1_coordinate_test.txt", logfile \Append;

		Write logfile, "========================================";
		Write logfile, "TASK1 - Coordinate System Movement Test (v1.3.0)";
		Write logfile, "Date: " + CDate() + " " + CTime();
		Write logfile, "========================================";
		WaitTime 0.05;

		Write logfile, "Command: Move wobj0 [" + NumToStr(delta_x, 3) + "," + NumToStr(delta_y, 3) + "," + NumToStr(delta_z, 3) + "]";
		WaitTime 0.05;

		Write logfile, "Start wobj0: [" + NumToStr(pos_start_wobj0.trans.x, 3) + "," + NumToStr(pos_start_wobj0.trans.y, 3) + "," + NumToStr(pos_start_wobj0.trans.z, 3) + "]";
		Write logfile, "Start Floor: [" + NumToStr(pos_start_floor.trans.x, 3) + "," + NumToStr(pos_start_floor.trans.y, 3) + "," + NumToStr(pos_start_floor.trans.z, 3) + "]";
		WaitTime 0.05;

		Write logfile, "End wobj0: [" + NumToStr(pos_end_wobj0.trans.x, 3) + "," + NumToStr(pos_end_wobj0.trans.y, 3) + "," + NumToStr(pos_end_wobj0.trans.z, 3) + "]";
		Write logfile, "End Floor: [" + NumToStr(pos_end_floor.trans.x, 3) + "," + NumToStr(pos_end_floor.trans.y, 3) + "," + NumToStr(pos_end_floor.trans.z, 3) + "]";
		WaitTime 0.05;

		Write logfile, "wobj0 moved: [" + NumToStr(diff_wobj0_x, 3) + "," + NumToStr(diff_wobj0_y, 3) + "," + NumToStr(diff_wobj0_z, 3) + "]";
		Write logfile, "Floor moved: [" + NumToStr(diff_floor_x, 3) + "," + NumToStr(diff_floor_y, 3) + "," + NumToStr(diff_floor_z, 3) + "]";
		WaitTime 0.05;

		Write logfile, "Verification: If wobj0 and Floor have same direction,";
		Write logfile, "  movement should be identical in both coordinate systems.";
		Write logfile, "========================================\0A";

		Close logfile;
		TPWrite "Saved to: /HOME/task1_coordinate_test.txt";

	ERROR
		TPWrite "ERROR in TestCoordinateMovement: " + NumToStr(ERRNO, 0);
		Close logfile;
		TRYNEXT;
	ENDPROC

	! ========================================
	! Move to Safe Middle Position
	! ========================================
	! Version: v1.4.0
	! Date: 2025-12-23
	! Purpose: Move gantry to middle of stroke range for safe testing
	! Middle positions: M1=1.4m, M2=2.65m, M3=0.5m
	PROC MoveToMiddlePosition()
		VAR jointtarget middle_pos;

		TPWrite "Moving to middle position...";

		middle_pos := CJointT();

		! Set gantry axes to middle positions (safe testing position)
		middle_pos.extax.eax_a := 1400;     ! M1DM3 middle: (-9.51+12.31)/2 = 1.4m = 1400mm
		middle_pos.extax.eax_b := 2650;     ! M2DM3 middle: (-0.05+5.35)/2 = 2.65m = 2650mm
		middle_pos.extax.eax_c := 500;      ! M3DM3 middle: (-0.05+1.05)/2 = 0.5m = 500mm

		MoveAbsJ middle_pos, v100, fine, tool0;

		TPWrite "Reached middle position";
	ENDPROC

	! ========================================
	! Test Gantry Axis Movement
	! ========================================
	! Version: v1.4.0
	! Date: 2025-12-23
	! Purpose: Move gantry joint axes and compare wobj0 vs Floor coordinate changes
	! Parameters:
	!   delta_m1 - M1DM3 (X axis) movement in mm
	!   delta_m2 - M2DM3 (Y axis) movement in mm
	!   delta_m3 - M3DM3 (Z axis) movement in mm
	PROC TestGantryAxisMovement(num delta_m1, num delta_m2, num delta_m3)
		VAR jointtarget joints_start;
		VAR jointtarget joints_end;
		VAR robtarget tcp_start_wobj0;
		VAR robtarget tcp_end_wobj0;
		VAR robtarget tcp_start_floor;
		VAR robtarget tcp_end_floor;
		VAR num wobj0_dx;
		VAR num wobj0_dy;
		VAR num wobj0_dz;
		VAR num floor_dx;
		VAR num floor_dy;
		VAR num floor_dz;
		VAR iodev logfile;

		! Read starting positions
		joints_start := CJointT();
		tcp_start_wobj0 := CRobT(\Tool:=tool0\WObj:=wobj0);
		tcp_start_floor := CRobT(\Tool:=tool0\WObj:=WobjFloor);

		TPWrite "Start - Gantry: M1=" + NumToStr(joints_start.extax.eax_a, 1) + " M2=" + NumToStr(joints_start.extax.eax_b, 1) + " M3=" + NumToStr(joints_start.extax.eax_c, 1);

		! Calculate target joint position
		joints_end := joints_start;
		joints_end.extax.eax_a := joints_end.extax.eax_a + delta_m1;
		joints_end.extax.eax_b := joints_end.extax.eax_b + delta_m2;
		joints_end.extax.eax_c := joints_end.extax.eax_c + delta_m3;

		! Move gantry
		MoveAbsJ joints_end, v100, fine, tool0;

		! Read ending positions
		tcp_end_wobj0 := CRobT(\Tool:=tool0\WObj:=wobj0);
		tcp_end_floor := CRobT(\Tool:=tool0\WObj:=WobjFloor);

		TPWrite "End - Gantry: M1=" + NumToStr(joints_end.extax.eax_a, 1) + " M2=" + NumToStr(joints_end.extax.eax_b, 1) + " M3=" + NumToStr(joints_end.extax.eax_c, 1);

		! Calculate TCP changes
		wobj0_dx := tcp_end_wobj0.trans.x - tcp_start_wobj0.trans.x;
		wobj0_dy := tcp_end_wobj0.trans.y - tcp_start_wobj0.trans.y;
		wobj0_dz := tcp_end_wobj0.trans.z - tcp_start_wobj0.trans.z;

		floor_dx := tcp_end_floor.trans.x - tcp_start_floor.trans.x;
		floor_dy := tcp_end_floor.trans.y - tcp_start_floor.trans.y;
		floor_dz := tcp_end_floor.trans.z - tcp_start_floor.trans.z;

		! Save to file
		Open "HOME:/task1_gantry_test.txt", logfile \Append;
		Write logfile, "========================================";
		Write logfile, "TASK1 - Gantry Axis Movement Test (v1.4.0)";
		Write logfile, "Date: " + CDate() + " " + CTime();
		Write logfile, "========================================";
		WaitTime 0.05;
		Write logfile, "Gantry Joint Movement: M1=" + NumToStr(delta_m1, 1) + "mm, M2=" + NumToStr(delta_m2, 1) + "mm, M3=" + NumToStr(delta_m3, 1) + "mm";
		WaitTime 0.05;
		Write logfile, "wobj0 TCP moved: [" + NumToStr(wobj0_dx, 3) + ", " + NumToStr(wobj0_dy, 3) + ", " + NumToStr(wobj0_dz, 3) + "] mm";
		WaitTime 0.05;
		Write logfile, "Floor TCP moved: [" + NumToStr(floor_dx, 3) + ", " + NumToStr(floor_dy, 3) + ", " + NumToStr(floor_dz, 3) + "] mm";
		WaitTime 0.05;
		Write logfile, "========================================";
		Close logfile;

		TPWrite "Saved to: task1_gantry_test.txt";

	ERROR
		TPWrite "ERROR in TestGantryAxisMovement: " + NumToStr(ERRNO, 0);
		Close logfile;
		TRYNEXT;
	ENDPROC

	! ========================================
	! Quick Test - Gantry X Axis Movement
	! ========================================
	! Version: v1.4.1
	! Date: 2025-12-23
	! Purpose: Test M1DM3 (Gantry X) +1000mm movement from current position
	PROC TestGantryX()
		TPWrite "TASK1 - Gantry X Axis Test";
		TPWrite "Testing M1DM3 (X axis) +1000mm";
		TestGantryAxisMovement 1000, 0, 0;
		TPWrite "Test complete!";
	ENDPROC

	! ========================================
	! Quick Test - Gantry Y Axis Movement
	! ========================================
	PROC TestGantryY()
		TPWrite "TASK1 - Gantry Y Axis Test";
		TPWrite "Testing M2DM3 (Y axis) +500mm";
		TestGantryAxisMovement 0, 500, 0;
		TPWrite "Test complete!";
	ENDPROC

	! ========================================
	! Quick Test - Gantry Z Axis Movement
	! ========================================
	PROC TestGantryZ()
		TPWrite "TASK1 - Gantry Z Axis Test";
		TPWrite "Testing M3DM3 (Z axis) +200mm";
		TestGantryAxisMovement 0, 0, 200;
		TPWrite "Test complete!";
	ENDPROC

	! ========================================
	! Robot1 TCP Coordinate Test - XYZ Combined with Return
	! ========================================
	! Version: v1.5.0
	! Date: 2025-12-24
	! Purpose: Move Robot1 TCP in wobj0 [X+50, Y+30, Z+20] from home position and return
	! Expected Result (MODE independent - Robot1 always uses wobj0):
	!   Robot1 wobj0 = World coordinate system
	!   Floor = World + offset [-9500, 5300, 2100] + RX 180deg rotation
	!   RX 180deg inverts Y and Z axes
	!   Therefore: wobj0 [+50, +30, +20] -> Floor [+50, -30, -20]
	! Changes from v1.4.7:
	!   - Added config.txt MODE display (Robot1 behavior unchanged)
	!   - Robot1 always uses wobj0 regardless of MODE
	PROC TestRobot1_XYZ()
		VAR jointtarget original_pos;
		VAR jointtarget home_pos;
		VAR num config_mode;

		TPWrite "TASK1 - Robot1 Coordinate Test (v1.5.0)";

		! Read config mode (for display only - Robot1 always uses wobj0)
		config_mode := ReadConfigMode();
		TPWrite "Config MODE=" + NumToStr(config_mode, 0) + " (Robot1 always uses wobj0)";

		! Save original joint position
		original_pos := CJointT();
		TPWrite "Original joint position saved";

		! Create home position (Robot1: [-90,0,0,0,30,0], keep gantry position)
		home_pos := original_pos;
		home_pos.robax.rax_1 := -90;
		home_pos.robax.rax_2 := 0;
		home_pos.robax.rax_3 := 0;
		home_pos.robax.rax_4 := 0;
		home_pos.robax.rax_5 := 30;
		home_pos.robax.rax_6 := 0;

		! Move to home position
		TPWrite "Moving to home position [-90,0,0,0,30,0]...";
		MoveAbsJ home_pos, v100, fine, tool0;
		TPWrite "At home position";

		! Perform coordinate test
		TPWrite "Moving wobj0: [+50, +30, +20]";
		TestCoordinateMovement 50, 30, 20;

		! Return to original joint position
		TPWrite "Returning to original position...";
		MoveAbsJ original_pos, v100, fine, tool0;
		TPWrite "Returned to original position";

		TPWrite "Test complete! Check txt file";
	ENDPROC

	! ========================================
	! Update Robot1 Floor Position
	! ========================================
	! Version: v1.5.1
	! Date: 2025-12-25
	! Purpose: Update Robot1 TCP position in Floor coordinate system
	! Used for distance measurement between robots
	PROC UpdateRobot1FloorPosition()
		robot1_floor_pos_t1 := CRobT(\Tool:=tWeld1\WObj:=WobjFloor);
	ENDPROC

	! ========================================
	! Update Gantry Work Object
	! ========================================
	! Version: v1.7.50
	! Date: 2025-12-31
	! Purpose: Update WobjGantry to reflect current gantry position and rotation
	! This allows TCP control regardless of gantry position
	! R-axis orientation: R=0 means gantry parallel to Y-axis (Floor coordinate)
	! Must be called before using WobjGantry for TCP movements
	PROC UpdateGantryWobj()
		VAR jointtarget current_gantry;

		! Read current gantry position
		current_gantry := CJointT();

		! Update WobjGantry position to current gantry location
		WobjGantry.uframe.trans.x := current_gantry.extax.eax_a;
		WobjGantry.uframe.trans.y := current_gantry.extax.eax_b;
		WobjGantry.uframe.trans.z := current_gantry.extax.eax_c;

		! WobjGantry orientation
		! IMPORTANT: WobjGantry coordinate system is always aligned with World/Floor
		! R-axis rotation affects robot base, NOT work object orientation
		! Keep quaternion as identity (no rotation)
		WobjGantry.uframe.rot.q1 := 1;
		WobjGantry.uframe.rot.q2 := 0;
		WobjGantry.uframe.rot.q3 := 0;
		WobjGantry.uframe.rot.q4 := 0;

		TPWrite "WobjGantry updated: [" + NumToStr(current_gantry.extax.eax_a,0) + ", "
		                              + NumToStr(current_gantry.extax.eax_b,0) + ", "
		                              + NumToStr(current_gantry.extax.eax_c,0) + ", R="
		                              + NumToStr(current_gantry.extax.eax_d,1) + "]";
	ENDPROC

	! ========================================
	! Update Robot2 Floor Position (from TASK1)
	! ========================================
	! Version: v1.8.9
	! Date: 2026-01-05
	! Purpose: Calculate Robot2 TCP position in Floor coordinates
	! TASK1 calculates this because TASK2 cannot sense gantry movement
	! Approach:
	!   1. Calculate Robot2 base position in Floor coordinates (rotate offset with R)
	!   2. Read Robot2 TCP position in wobj0 (from TASK2)
	!   3. Apply rotation transformation matrix to wobj0 coordinates
	!      - Robot2 wobj0 rotates with gantry R-axis
	!      - Rotation matrix: [cos(theta) -sin(theta); sin(theta) cos(theta)]
	!      - theta = total_r_deg = r_deg
	!   4. Combine: Robot2 TCP Floor = Robot2 base Floor + rotated wobj0 offset
	!   5. Store in robot2_floor_pos_t1 (shared variable)
	! Changes in v1.8.5:
	!   - Align total_r_deg to r_deg (no 90deg offset)
	!   - Compute Robot2 base from gantry Floor + rotated offset
	! Changes in v1.8.2:
	!   - CRITICAL: Added rotation transformation matrix for wobj0 coordinates
	!   - Fixes Robot2 TCP offset error during R-axis rotation
	!   - Both Robot1 and Robot2 TCP now correctly at R-center for all angles
	! Uses global variables for logging:
	!   enable_debug_logging - Set to TRUE to enable file logging
	!   debug_logfile - File handle for debug output
	PROC UpdateRobot2BaseDynamicWobj()
		VAR jointtarget current_gantry;
		VAR num r_deg;
		VAR num total_r_deg;
		VAR num total_r_rad;
		VAR robtarget robot2_tcp_wobj0;
		VAR num base_floor_x;
		VAR num base_floor_y;
		VAR num base_floor_z;
		VAR num gantry_floor_x;
		VAR num gantry_floor_y;
		VAR num gantry_floor_z;
		VAR num floor_x_offset;
		VAR num floor_y_offset;
		VAR num floor_z_offset;

		! Read current gantry position
		current_gantry := CJointT();
		r_deg := current_gantry.extax.eax_d;

		! DEBUG: Show gantry position read by UpdateRobot2BaseDynamicWobj (v1.7.50)
		TPWrite "  [DEBUG] Gantry read in UpdateRobot2BaseDynamicWobj:";
		IF enable_debug_logging Write debug_logfile, "  [DEBUG] Gantry read in UpdateRobot2BaseDynamicWobj:";

		TPWrite "    Physical: [" + NumToStr(current_gantry.extax.eax_a,1) + ", "
		                          + NumToStr(current_gantry.extax.eax_b,1) + ", "
		                          + NumToStr(current_gantry.extax.eax_c,1) + ", "
		                          + NumToStr(current_gantry.extax.eax_d,1) + "]";
		IF enable_debug_logging Write debug_logfile, "    Physical: [" + NumToStr(current_gantry.extax.eax_a,1) + ", "
		                                                                + NumToStr(current_gantry.extax.eax_b,1) + ", "
		                                                                + NumToStr(current_gantry.extax.eax_c,1) + ", "
		                                                                + NumToStr(current_gantry.extax.eax_d,1) + "]";

		! Calculate total R-axis rotation
		! R=0: Gantry parallel to Y-axis (wobj0 aligned with Floor)
		! IMPORTANT: RAPID Cos/Sin functions take DEGREES, not radians!
		total_r_deg := r_deg;
		total_r_rad := total_r_deg * pi / 180;  ! For reference only
		TPWrite "    R total: " + NumToStr(total_r_deg,1) + " deg, Cos=" + NumToStr(Cos(total_r_deg),3) + ", Sin=" + NumToStr(Sin(total_r_deg),3);
		IF enable_debug_logging Write debug_logfile, "    R total: " + NumToStr(total_r_deg,1) + " deg, Cos=" + NumToStr(Cos(total_r_deg),3) + ", Sin=" + NumToStr(Sin(total_r_deg),3);

		! Convert gantry position to Floor coordinates
		gantry_floor_x := current_gantry.extax.eax_a + 9500;
		gantry_floor_y := 5300 - current_gantry.extax.eax_b;
		gantry_floor_z := 2100 - current_gantry.extax.eax_c;

		! Calculate Robot2 base position in Floor coordinates
		! Robot2 base offset at R=0: [0, -488] from R-center in Floor coordinates
		! Rotate base offset with current R-axis angle
		! v1.8.76: CW rotation (Floor coordinate system) - Sin sign inverted
		base_floor_x := gantry_floor_x - (488 * Sin(total_r_deg));
		base_floor_y := gantry_floor_y - (488 * Cos(total_r_deg));
		base_floor_z := gantry_floor_z;

		! Store in WobjRobot2Base_Dynamic for reference
		WobjRobot2Base_Dynamic.uframe.trans.x := base_floor_x;
		WobjRobot2Base_Dynamic.uframe.trans.y := base_floor_y;
		WobjRobot2Base_Dynamic.uframe.trans.z := base_floor_z;

		! Robot2 base direction = Floor direction (no rotation!)
		! Robot2 wobj0 is aligned with Floor coordinate system
		WobjRobot2Base_Dynamic.uframe.rot.q1 := 1;
		WobjRobot2Base_Dynamic.uframe.rot.q2 := 0;
		WobjRobot2Base_Dynamic.uframe.rot.q3 := 0;
		WobjRobot2Base_Dynamic.uframe.rot.q4 := 0;

		! Read Robot2 TCP position in wobj0 (from TASK2, using tWeld1 = same TCP as tWeld2)
		robot2_tcp_wobj0 := CRobT(\TaskName:="T_ROB2"\Tool:=tWeld1\WObj:=wobj0);

		! v1.8.61 DEBUG: Save intermediate values for debugging
		debug_r2_wobj0_x := robot2_tcp_wobj0.trans.x;
		debug_r2_wobj0_y := robot2_tcp_wobj0.trans.y;
		debug_r2_base_floor_x := base_floor_x;
		debug_r2_base_floor_y := base_floor_y;

		! Calculate Robot2 TCP Floor position with rotation transformation
		! CRITICAL: Robot2 wobj0 rotates with gantry R-axis!
		! Apply rotation transformation matrix to convert wobj0 coords to Floor coords
		! v1.8.76: CW rotation matrix (Floor coordinate system):
		!   [cos(T)   sin(T)]   [x_wobj0]   [x_floor]
		!   [-sin(T)  cos(T)] x [y_wobj0] = [y_floor]
		floor_x_offset := robot2_tcp_wobj0.trans.x * Cos(total_r_deg) + robot2_tcp_wobj0.trans.y * Sin(total_r_deg);
		floor_y_offset := -robot2_tcp_wobj0.trans.x * Sin(total_r_deg) + robot2_tcp_wobj0.trans.y * Cos(total_r_deg);
		floor_z_offset := robot2_tcp_wobj0.trans.z;  ! Z-axis not affected by R-axis rotation

		! v1.8.61 DEBUG: Save floor offsets for debugging
		debug_r2_floor_x_offset := floor_x_offset;
		debug_r2_floor_y_offset := floor_y_offset;

		robot2_floor_pos_t1.trans.x := base_floor_x + floor_x_offset;
		robot2_floor_pos_t1.trans.y := base_floor_y + floor_y_offset;
		robot2_floor_pos_t1.trans.z := base_floor_z + floor_z_offset;

		TPWrite "Robot2 Base Floor: [" + NumToStr(base_floor_x,0) + ", "
		                                + NumToStr(base_floor_y,0) + ", "
		                                + NumToStr(base_floor_z,0) + "]";
		IF enable_debug_logging Write debug_logfile, "Robot2 Base Floor: [" + NumToStr(base_floor_x,0) + ", "
		                                                          + NumToStr(base_floor_y,0) + ", "
		                                                          + NumToStr(base_floor_z,0) + "]";

		TPWrite "Robot2 TCP wobj0: [" + NumToStr(robot2_tcp_wobj0.trans.x,0) + ", "
		                               + NumToStr(robot2_tcp_wobj0.trans.y,0) + ", "
		                               + NumToStr(robot2_tcp_wobj0.trans.z,0) + "]";
		IF enable_debug_logging Write debug_logfile, "Robot2 TCP wobj0: [" + NumToStr(robot2_tcp_wobj0.trans.x,0) + ", "
		                                                         + NumToStr(robot2_tcp_wobj0.trans.y,0) + ", "
		                                                         + NumToStr(robot2_tcp_wobj0.trans.z,0) + "]";

		TPWrite "Robot2 TCP Floor offset (rotated): [" + NumToStr(floor_x_offset,1) + ", "
		                                                + NumToStr(floor_y_offset,1) + ", "
		                                                + NumToStr(floor_z_offset,1) + "]";
		IF enable_debug_logging Write debug_logfile, "Robot2 TCP Floor offset (rotated): [" + NumToStr(floor_x_offset,1) + ", "
		                                                                          + NumToStr(floor_y_offset,1) + ", "
		                                                                          + NumToStr(floor_z_offset,1) + "]";

		TPWrite "Robot2 TCP Floor: [" + NumToStr(robot2_floor_pos_t1.trans.x,0) + ", "
		                               + NumToStr(robot2_floor_pos_t1.trans.y,0) + ", "
		                               + NumToStr(robot2_floor_pos_t1.trans.z,0) + "]";
		IF enable_debug_logging Write debug_logfile, "Robot2 TCP Floor: [" + NumToStr(robot2_floor_pos_t1.trans.x,0) + ", "
		                                                         + NumToStr(robot2_floor_pos_t1.trans.y,0) + ", "
		                                                         + NumToStr(robot2_floor_pos_t1.trans.z,0) + "]";
	ENDPROC

	! ========================================
	! Set Robot1 Initial Position for Gantry Test
	! ========================================
	! Version: v1.8.7
	! Date: 2026-01-05
	! Purpose: Move Robot1 to initial test position
	! Position: Robot1 TCP [0, 0, 1000] in WobjGantry (dynamic), Gantry HOME=[0,0,0,0]
	! Uses WobjGantry which tracks current gantry position - safe from any gantry position
	! Note: Safe from any starting position - synchronizes X1-X2 first
	! Changes in v1.8.9:
	!   - Reduced TPWrite output and file logging to 1-line summary
	PROC SetRobot1InitialPosition()
		VAR jointtarget initial_joint;
		VAR jointtarget sync_pos;
		VAR jointtarget home_pos;
		VAR robtarget home_tcp;
		VAR iodev logfile;

		! Step 0: Synchronize X1-X2 at current position (progressive approach)
		! Progressive sync prevents linked motor error when X1-X2 distance is large
		VAR num x1_target;
		VAR num x2_current;
		VAR num distance;

		! Step 2: Iterative refinement variables
		VAR robtarget current_wobj0;
		VAR robtarget tcp_floor;
		VAR num error_x;
		VAR num error_y;
		VAR num iteration;
		VAR num max_iterations;
		VAR num tolerance;

		! Show message FIRST, then open log (file I/O causes delay)
		TPWrite "Robot1 init: start";

		! Open log file (moved after TPWrite for faster UI response)
		Open "HOME:/robot1_init_position.txt", logfile \Write;
		Write logfile, "Robot1 Init (" + TASK1_VERSION + ") Date=" + CDate() + " Time=" + CTime();

		sync_pos := CJointT();

		x1_target := sync_pos.extax.eax_a;
		x2_current := sync_pos.extax.eax_f;
		distance := x1_target - x2_current;

		! v1.9.15: Use 9E9 for eax_f to let linked motor system handle X2 automatically
		! Setting eax_f to 9E9 means "don't control this axis" - let hardware handle it
		Write logfile, "Init X1=" + NumToStr(x1_target,1) + " X2=" + NumToStr(x2_current,1) + " diff=" + NumToStr(distance,1);
		IF Abs(distance) > 1 THEN
			TPWrite "X1/X2 state mismatch - using 9E9 for eax_f";
			Write logfile, "Using 9E9 for eax_f (let linked motor system handle X2)";
		ENDIF

		! Step 1: Move Robot1 joints to intermediate position (tWeld1 HOME config)
		initial_joint := CJointT();
		! v1.9.16: Set eax_f to match eax_a (linked motor requirement)
		initial_joint.extax.eax_f := initial_joint.extax.eax_a;
		! Joint angles taught for tWeld1 HOME (confdata [-1,-1,0,4])
		initial_joint.robax.rax_1 := 0;
		initial_joint.robax.rax_2 := -48.88;
		initial_joint.robax.rax_3 := 6.22;
		initial_joint.robax.rax_4 := 0;
		initial_joint.robax.rax_5 := 8.26;
		initial_joint.robax.rax_6 := 0;
		MoveAbsJ initial_joint, v100, fine, tool0;

		! Step 2: Move Robot1 tWeld1 TCP to HOME [0,0,1000] in WobjGantry
		iteration := 0;
		max_iterations := 3;
		tolerance := 0.5;  ! mm

		! v1.9.49: Disable config supervision for non-home gantry init
		! When R!=0, hardcoded confdata [-1,-1,0,4] may not match optimal joint config
		ConfJ \Off;
		ConfL \Off;

		! Update WobjGantry to reflect current gantry position
		UpdateGantryWobj;
		! tWeld1 TCP HOME: [0, 0, 1000] in WobjGantry
		! Orientation: [0.45452,-0.54167,0.54167,0.45453] (taught for tWeld1)
		! Confdata: [-1,-1,0,4] (taught - critical for tWeld1 config)
		sync_pos := CJointT();
		home_tcp := [[0, 0, 1000], [0.45452, -0.54167, 0.54167, 0.45453], [-1, -1, 0, 4], sync_pos.extax];
		MoveJ home_tcp, v100, fine, tWeld1\WObj:=WobjGantry;
		! Iterative refinement to reach precise R-axis center (max 3 iterations)
		WHILE iteration < max_iterations DO
			iteration := iteration + 1;
			! v1.9.49: Read TCP in WobjGantry (not wobj0!) to avoid unreachable error
			! When gantry XYZ!=0, wobj0 gives large coords -> huge correction -> unreachable
			UpdateGantryWobj;
			current_wobj0 := CRobT(\Tool:=tWeld1\WObj:=WobjGantry);
			error_x := 0 - current_wobj0.trans.x;  ! Target X=0 in WobjGantry
			error_y := 0 - current_wobj0.trans.y;  ! Target Y=0 in WobjGantry

			! Check if within tolerance
			IF Abs(error_x) < tolerance AND Abs(error_y) < tolerance THEN
				! Force loop exit by setting iteration >= max_iterations (BREAK has issues)
				iteration := max_iterations;
			ELSE
				! Apply correction in WobjGantry coordinates
				UpdateGantryWobj;
				sync_pos := CJointT();
				home_tcp := [[error_x, error_y, 1000], [0.45452, -0.54167, 0.54167, 0.45453], [-1, -1, 0, 4], sync_pos.extax];
				MoveL home_tcp, v50, fine, tWeld1\WObj:=WobjGantry;
			ENDIF
		ENDWHILE

		! v1.9.49: Restore config supervision after init positioning
		ConfJ \On;
		ConfL \On;

		! Step 3: Move gantry to HOME position (physical origin)
		home_pos := CJointT();  ! Read current position
		home_pos.extax.eax_a := 0;      ! X1 = Physical origin
		home_pos.extax.eax_b := 0;      ! Y = Physical origin
		home_pos.extax.eax_c := 0;      ! Z = Physical origin
		home_pos.extax.eax_d := 0;      ! R = Physical origin
		! eax_e: keep from CJointT() (not used)
		! v1.9.16: X2 = X1 (linked motor)
		home_pos.extax.eax_f := 0;
		MoveAbsJ home_pos, v100, fine, tool0;
		TPWrite "Robot1 init: done";
		Write logfile, "Done errX=" + NumToStr(error_x, 2) + " errY=" + NumToStr(error_y, 2) + " iter=" + NumToStr(iteration, 0) + " at " + CTime();
		! TCP verification in Floor coordinates
		tcp_floor := CRobT(\Tool:=tWeld1\WObj:=WobjFloor);
		Write logfile, "TCP_Floor tWeld1: X=" + NumToStr(tcp_floor.trans.x, 3) + " Y=" + NumToStr(tcp_floor.trans.y, 3) + " Z=" + NumToStr(tcp_floor.trans.z, 3);
		Write logfile, "TCP_Floor orient: [" + NumToStr(tcp_floor.rot.q1, 5) + "," + NumToStr(tcp_floor.rot.q2, 5) + "," + NumToStr(tcp_floor.rot.q3, 5) + "," + NumToStr(tcp_floor.rot.q4, 5) + "]";
		Close logfile;
	
	ERROR
		TPWrite "ERROR in SetRobot1InitialPosition: " + NumToStr(ERRNO, 0);
		Close logfile;
		STOP;
	ENDPROC

	! ========================================
	! Log Current Position (for HOME teaching)
	! ========================================
	! Purpose: Log current robtarget + jointtarget to file
	! Usage: Jog robot to desired position -> Call this from FlexPendant
	!        FlexPendant: ABB Menu -> Program Editor -> Debug -> Call Routine
	! Output: HOME:/current_position.txt
	PROC LogCurrentPosition()
		VAR iodev logfile;
		VAR robtarget rt_tool0;
		VAR robtarget rt_tw1_wobj0;
		VAR robtarget rt_tw1_gantry;
		VAR jointtarget jt;

		Open "HOME:/current_position.txt", logfile \Write;
		Write logfile, "=== Position Log " + CDate() + " " + CTime() + " ===";

		! --- JointTarget ---
		jt := CJointT();
		Write logfile, "";
		Write logfile, "--- ROB_1 JointTarget ---";
		Write logfile, "robax: [" + NumToStr(jt.robax.rax_1,3) + ", "
			+ NumToStr(jt.robax.rax_2,3) + ", " + NumToStr(jt.robax.rax_3,3) + ", "
			+ NumToStr(jt.robax.rax_4,3) + ", " + NumToStr(jt.robax.rax_5,3) + ", "
			+ NumToStr(jt.robax.rax_6,3) + "]";
		Write logfile, "extax: [" + NumToStr(jt.extax.eax_a,3) + ", "
			+ NumToStr(jt.extax.eax_b,3) + ", " + NumToStr(jt.extax.eax_c,3) + ", "
			+ NumToStr(jt.extax.eax_d,3) + ", " + NumToStr(jt.extax.eax_e,3) + ", "
			+ NumToStr(jt.extax.eax_f,3) + "]";

		! --- RobTarget tool0/wobj0 ---
		rt_tool0 := CRobT(\Tool:=tool0\WObj:=wobj0);
		Write logfile, "";
		Write logfile, "--- ROB_1 RobTarget (tool0, wobj0) ---";
		Write logfile, "[[" + NumToStr(rt_tool0.trans.x,3) + ","
			+ NumToStr(rt_tool0.trans.y,3) + ","
			+ NumToStr(rt_tool0.trans.z,3) + "],["
			+ NumToStr(rt_tool0.rot.q1,5) + ","
			+ NumToStr(rt_tool0.rot.q2,5) + ","
			+ NumToStr(rt_tool0.rot.q3,5) + ","
			+ NumToStr(rt_tool0.rot.q4,5) + "],["
			+ NumToStr(rt_tool0.robconf.cf1,0) + ","
			+ NumToStr(rt_tool0.robconf.cf4,0) + ","
			+ NumToStr(rt_tool0.robconf.cf6,0) + ","
			+ NumToStr(rt_tool0.robconf.cfx,0) + "],extax]";

		! --- RobTarget tWeld1/wobj0 ---
		rt_tw1_wobj0 := CRobT(\Tool:=tWeld1\WObj:=wobj0);
		Write logfile, "";
		Write logfile, "--- ROB_1 RobTarget (tWeld1, wobj0) ---";
		Write logfile, "[[" + NumToStr(rt_tw1_wobj0.trans.x,3) + ","
			+ NumToStr(rt_tw1_wobj0.trans.y,3) + ","
			+ NumToStr(rt_tw1_wobj0.trans.z,3) + "],["
			+ NumToStr(rt_tw1_wobj0.rot.q1,5) + ","
			+ NumToStr(rt_tw1_wobj0.rot.q2,5) + ","
			+ NumToStr(rt_tw1_wobj0.rot.q3,5) + ","
			+ NumToStr(rt_tw1_wobj0.rot.q4,5) + "],["
			+ NumToStr(rt_tw1_wobj0.robconf.cf1,0) + ","
			+ NumToStr(rt_tw1_wobj0.robconf.cf4,0) + ","
			+ NumToStr(rt_tw1_wobj0.robconf.cf6,0) + ","
			+ NumToStr(rt_tw1_wobj0.robconf.cfx,0) + "],extax]";

		! --- RobTarget tWeld1/WobjGantry ---
		UpdateGantryWobj;
		rt_tw1_gantry := CRobT(\Tool:=tWeld1\WObj:=WobjGantry);
		Write logfile, "";
		Write logfile, "--- ROB_1 RobTarget (tWeld1, WobjGantry) ---";
		Write logfile, "[[" + NumToStr(rt_tw1_gantry.trans.x,3) + ","
			+ NumToStr(rt_tw1_gantry.trans.y,3) + ","
			+ NumToStr(rt_tw1_gantry.trans.z,3) + "],["
			+ NumToStr(rt_tw1_gantry.rot.q1,5) + ","
			+ NumToStr(rt_tw1_gantry.rot.q2,5) + ","
			+ NumToStr(rt_tw1_gantry.rot.q3,5) + ","
			+ NumToStr(rt_tw1_gantry.rot.q4,5) + "],["
			+ NumToStr(rt_tw1_gantry.robconf.cf1,0) + ","
			+ NumToStr(rt_tw1_gantry.robconf.cf4,0) + ","
			+ NumToStr(rt_tw1_gantry.robconf.cf6,0) + ","
			+ NumToStr(rt_tw1_gantry.robconf.cfx,0) + "],extax]";

		Close logfile;
		TPWrite "Position saved to HOME:/current_position.txt";
	ENDPROC

	! ========================================
	! Test Robot1 Base Height
	! ========================================
	! Version: v1.7.14
	! Date: 2025-12-28
	! Purpose: Check tool0 TCP height from base at specific joint angles
	! Output: TP display + /HOME/robot1_base_height.txt
	PROC TestRobot1BaseHeight()
		VAR jointtarget test_pos;
		VAR robtarget tcp_wobj0;
		VAR robtarget tcp_floor;
		VAR iodev logfile;

		TPWrite "========================================";
		TPWrite "Robot1 Base Height Test (v1.7.14)";

		! Get current gantry position
		test_pos := CJointT();

		! Set robot joints to [-90, 0, 0, 0, 0, 0]
		test_pos.robax.rax_1 := -90;
		test_pos.robax.rax_2 := 0;
		test_pos.robax.rax_3 := 0;
		test_pos.robax.rax_4 := 0;
		test_pos.robax.rax_5 := 0;
		test_pos.robax.rax_6 := 0;

		! Move to test position
		TPWrite "Moving to test position [-90,0,0,0,0,0]...";
		MoveAbsJ test_pos, v100, fine, tool0;
		WaitTime 0.5;

		! Read TCP position in wobj0
		tcp_wobj0 := CRobT(\Tool:=tool0\WObj:=wobj0);

		! Read TCP position in Floor coordinate
		tcp_floor := CRobT(\Tool:=tool0\WObj:=WobjFloor);

		! Display on TP
		TPWrite "Robot1 wobj0:";
		TPWrite "  X = " + NumToStr(tcp_wobj0.trans.x, 2);
		TPWrite "  Y = " + NumToStr(tcp_wobj0.trans.y, 2);
		TPWrite "  Z = " + NumToStr(tcp_wobj0.trans.z, 2);

		TPWrite "Robot1 Floor:";
		TPWrite "  X = " + NumToStr(tcp_floor.trans.x, 2);
		TPWrite "  Y = " + NumToStr(tcp_floor.trans.y, 2);
		TPWrite "  Z = " + NumToStr(tcp_floor.trans.z, 2);

		TPWrite "========================================";

		! Save to log file
		Open "HOME:/robot1_base_height.txt", logfile \Write;

		Write logfile, "========================================";
		Write logfile, "Robot1 Base Height Test (v1.7.14)";
		Write logfile, "========================================";
		Write logfile, "Date: " + CDate();
		Write logfile, "Time: " + CTime();
		Write logfile, "";
		Write logfile, "Joint Angles: [-90, 0, 0, 0, 0, 0]";
		Write logfile, "";
		Write logfile, "Robot1 wobj0 (tool0):";
		Write logfile, "  X = " + NumToStr(tcp_wobj0.trans.x, 2) + " mm";
		Write logfile, "  Y = " + NumToStr(tcp_wobj0.trans.y, 2) + " mm";
		Write logfile, "  Z = " + NumToStr(tcp_wobj0.trans.z, 2) + " mm";
		Write logfile, "";
		Write logfile, "Robot1 Floor (tool0):";
		Write logfile, "  X = " + NumToStr(tcp_floor.trans.x, 2) + " mm";
		Write logfile, "  Y = " + NumToStr(tcp_floor.trans.y, 2) + " mm";
		Write logfile, "  Z = " + NumToStr(tcp_floor.trans.z, 2) + " mm";
		Write logfile, "========================================\0A";

		Close logfile;
		TPWrite "Saved to: /HOME/robot1_base_height.txt";

	ERROR
		TPWrite "ERROR in TestRobot1BaseHeight: " + NumToStr(ERRNO, 0);
		Close logfile;
		TRYNEXT;
	ENDPROC

	! ========================================
	! Test Gantry Movement Effect on Floor Coordinates
	! ========================================
	! Version: v1.7.50
	! Date: 2025-12-31
	! Purpose: Test if Floor coordinates change when gantry moves
	! Reads gantry movement from config.txt (Floor absolute coordinates)
	! Initial position: Robot1 TCP [0, 0, 1000] wobj0, Robot2 TCP [0, 488, -1000] wobj0
	!   Both robots at J1~0 deg (HOME position)
	! Gantry HOME Physical: [0, 0, 0, 0], Floor: [9500, 5300, 2100, 0]
	! Coordinate transformation: Physical = Floor - HOME_offset
	!   eax_a = Floor_X - 9500, eax_b = 5300 - Floor_Y
	!   eax_c = 2100 - Floor_Z, eax_d = 0 - Floor_R
	! Note: Uses WobjGantry for TCP control from any gantry position
	! Output: /HOME/gantry_floor_test.txt
	PROC TestGantryFloorCoordinates()
		VAR jointtarget rob1_current;
		VAR jointtarget rob2_current;
		VAR jointtarget home_pos;
		VAR jointtarget moved_pos;
		VAR robtarget rob1_floor_before;
		VAR robtarget rob2_floor_before;
		VAR robtarget rob1_floor_after;
		VAR robtarget rob2_floor_after;
		VAR robtarget rob1_floor_home;
		VAR robtarget rob2_floor_home;
		VAR iodev logfile;
		VAR iodev configfile;
		VAR string line;
		VAR string value_str;
		VAR bool found_value;
		VAR bool found_x;
		VAR bool found_y;
		VAR bool found_z;
		VAR bool found_r;
		VAR num gantry_x_offset;
		VAR num gantry_y_offset;
		VAR num gantry_z_offset;
		VAR num gantry_r_offset;

		TPWrite "========================================";
		TPWrite "Gantry Floor Test (" + TASK1_VERSION + ")";

		! Open log file first for debug output (v1.7.50)
		Open "HOME:/gantry_floor_test.txt", debug_logfile \Write;
		enable_debug_logging := TRUE;
		Write debug_logfile, "========================================";
		Write debug_logfile, "Gantry Floor Coordinate Test (" + TASK1_VERSION + ")";
		Write debug_logfile, "========================================";
		Write debug_logfile, "Date: " + CDate();
		Write debug_logfile, "Time: " + CTime();
		Write debug_logfile, "";

		! Initialize variables
		gantry_x_offset := 0;
		gantry_y_offset := 0;
		gantry_z_offset := 0;
		gantry_r_offset := 0;

		! Check if both robots are at initial position (v1.7.48)
		! HOME position changed to TCP [0, 0/488, +/-1000] with J1~0 deg
		TPWrite "Checking robot positions...";
		rob1_current := CJointT();
		rob2_current := CJointT(\TaskName:="T_ROB2");

		IF Abs(rob1_current.robax.rax_1 - 0) > 15 THEN
			TPWrite "WARNING: Robot1 NOT at initial position!";
			TPWrite "Current Robot1 J1: " + NumToStr(rob1_current.robax.rax_1, 1);
			TPWrite "Expected: ~0 degrees (HOME TCP [0,0,1000])";
			TPWrite "Please run SetRobot1InitialPosition first";
			STOP;
		ENDIF

		IF Abs(rob2_current.robax.rax_1 - 0) > 15 THEN
			TPWrite "WARNING: Robot2 NOT at initial position!";
			TPWrite "Current Robot2 J1: " + NumToStr(rob2_current.robax.rax_1, 1);
			TPWrite "Expected: ~0 degrees (HOME TCP [0,488,-1000])";
			TPWrite "Please run TASK2->SetRobot2InitialPosition first";
			STOP;
		ENDIF
		TPWrite "Both robots at initial positions OK";

		! Read gantry offsets from config.txt
		TPWrite "Reading config.txt...";
		Open "HOME:/config.txt", configfile \Read;

		! Read GANTRY_X
		found_x := FALSE;
		WHILE found_x = FALSE DO
			line := ReadStr(configfile);
			IF StrFind(line, 1, "GANTRY_X=") = 1 THEN
				IF StrLen(line) >= 10 THEN
					value_str := StrPart(line, 10, StrLen(line) - 9);
					found_value := StrToVal(value_str, gantry_x_offset);
					found_x := TRUE;
					TPWrite "GANTRY_X=" + NumToStr(gantry_x_offset, 0);
				ENDIF
			ENDIF
		ENDWHILE

		! Read GANTRY_Y
		found_y := FALSE;
		WHILE found_y = FALSE DO
			line := ReadStr(configfile \RemoveCR);
			IF StrFind(line, 1, "GANTRY_Y=") = 1 THEN
				IF StrLen(line) >= 10 THEN
					value_str := StrPart(line, 10, StrLen(line) - 9);
					found_value := StrToVal(value_str, gantry_y_offset);
					found_y := TRUE;
					TPWrite "GANTRY_Y=" + NumToStr(gantry_y_offset, 0);
				ENDIF
			ENDIF
		ENDWHILE

		! Read GANTRY_Z
		found_z := FALSE;
		WHILE found_z = FALSE DO
			line := ReadStr(configfile \RemoveCR);
			IF StrFind(line, 1, "GANTRY_Z=") = 1 THEN
				IF StrLen(line) >= 10 THEN
					value_str := StrPart(line, 10, StrLen(line) - 9);
					found_value := StrToVal(value_str, gantry_z_offset);
					found_z := TRUE;
					TPWrite "GANTRY_Z=" + NumToStr(gantry_z_offset, 0);
				ENDIF
			ENDIF
		ENDWHILE

		! Read GANTRY_R
		found_r := FALSE;
		WHILE found_r = FALSE DO
			line := ReadStr(configfile \RemoveCR);
			IF StrFind(line, 1, "GANTRY_R=") = 1 THEN
				IF StrLen(line) >= 10 THEN
					value_str := StrPart(line, 10, StrLen(line) - 9);
					found_value := StrToVal(value_str, gantry_r_offset);
					found_r := TRUE;
					TPWrite "GANTRY_R=" + NumToStr(gantry_r_offset, 1);
				ENDIF
			ENDIF
		ENDWHILE

		Close configfile;
		TPWrite "Config reading complete!";

		! Move to HOME position [0, 0, 0, 0]
		TPWrite "Moving gantry to HOME [0,0,0,0]...";
		home_pos := CJointT();
		! Synchronize X2 with X1 first (prevent linked motor error)
		home_pos.extax.eax_f := home_pos.extax.eax_a;
		home_pos.extax.eax_a := 0;      ! X1 = Physical origin
		home_pos.extax.eax_b := 0;      ! Y = Physical origin
		home_pos.extax.eax_c := 0;      ! Z = Physical origin
		home_pos.extax.eax_d := 0;      ! R = Physical origin
		home_pos.extax.eax_f := 0;      ! X2 = X1 (Master-Follower sync!)
		MoveAbsJ home_pos, v100, fine, tool0;
		WaitTime 1.0;

		! Verify gantry is at HOME (v1.7.50)
		moved_pos := CJointT();  ! Reuse moved_pos variable to check actual position
		TPWrite "Gantry actual position after HOME move:";
		Write debug_logfile, "";
		Write debug_logfile, "Gantry actual position after HOME move:";
		TPWrite "  Physical: [" + NumToStr(moved_pos.extax.eax_a,1) + ", "
		                        + NumToStr(moved_pos.extax.eax_b,1) + ", "
		                        + NumToStr(moved_pos.extax.eax_c,1) + ", "
		                        + NumToStr(moved_pos.extax.eax_d,1) + "]";
		Write debug_logfile, "  Physical: [" + NumToStr(moved_pos.extax.eax_a,1) + ", "
		                              + NumToStr(moved_pos.extax.eax_b,1) + ", "
		                              + NumToStr(moved_pos.extax.eax_c,1) + ", "
		                              + NumToStr(moved_pos.extax.eax_d,1) + "]";
		TPWrite "  Floor: [" + NumToStr(moved_pos.extax.eax_a + 9500,1) + ", "
		                     + NumToStr(5300 - moved_pos.extax.eax_b,1) + ", "
		                     + NumToStr(2100 - moved_pos.extax.eax_c,1) + ", "
		                     + NumToStr(0 - moved_pos.extax.eax_d,1) + "]";
		Write debug_logfile, "  Floor: [" + NumToStr(moved_pos.extax.eax_a + 9500,1) + ", "
		                           + NumToStr(5300 - moved_pos.extax.eax_b,1) + ", "
		                           + NumToStr(2100 - moved_pos.extax.eax_c,1) + ", "
		                           + NumToStr(0 - moved_pos.extax.eax_d,1) + "]";

		! Measure HOME TCP positions (v1.7.50)
		TPWrite "Measuring HOME TCP positions...";
		Write debug_logfile, "";
		Write debug_logfile, "Measuring HOME TCP positions...";
		UpdateRobot1FloorPosition;
		UpdateRobot2BaseDynamicWobj;  ! This also updates robot2_floor_pos_t1
		rob1_floor_home := robot1_floor_pos_t1;
		rob2_floor_home := robot2_floor_pos_t1;
		TPWrite "Robot1 HOME TCP Floor: [" + NumToStr(rob1_floor_home.trans.x,0) + ", "
		                                    + NumToStr(rob1_floor_home.trans.y,0) + ", "
		                                    + NumToStr(rob1_floor_home.trans.z,0) + "]";
		Write debug_logfile, "Robot1 HOME TCP Floor: [" + NumToStr(rob1_floor_home.trans.x,0) + ", "
		                                          + NumToStr(rob1_floor_home.trans.y,0) + ", "
		                                          + NumToStr(rob1_floor_home.trans.z,0) + "]";
		TPWrite "Robot2 HOME TCP Floor: [" + NumToStr(rob2_floor_home.trans.x,0) + ", "
		                                    + NumToStr(rob2_floor_home.trans.y,0) + ", "
		                                    + NumToStr(rob2_floor_home.trans.z,0) + "]";
		Write debug_logfile, "Robot2 HOME TCP Floor: [" + NumToStr(rob2_floor_home.trans.x,0) + ", "
		                                          + NumToStr(rob2_floor_home.trans.y,0) + ", "
		                                          + NumToStr(rob2_floor_home.trans.z,0) + "]";

		! Measure BEFORE gantry movement
		TPWrite "Measuring BEFORE gantry move...";
		Write debug_logfile, "";
		Write debug_logfile, "========================================";
		Write debug_logfile, "BEFORE Gantry Movement Test";
		Write debug_logfile, "========================================";
		UpdateRobot1FloorPosition;
		UpdateRobot2BaseDynamicWobj;  ! Update Robot2 base coordinate for TASK2
		! Note: robot2_floor_pos_t1 is updated by TASK2's UpdateRobot2FloorPosition
		rob1_floor_before := robot1_floor_pos_t1;
		rob2_floor_before := robot2_floor_pos_t1;

		! Move gantry with Floor->Physical coordinate transformation
		TPWrite "Moving gantry with offsets...";
		moved_pos := home_pos;
		moved_pos.extax.eax_a := gantry_x_offset - 9500;   ! Physical X = Floor_X - 9500
		moved_pos.extax.eax_b := 5300 - gantry_y_offset;   ! Physical Y = 5300 - Floor_Y
		moved_pos.extax.eax_c := 2100 - gantry_z_offset;   ! Physical Z = 2100 - Floor_Z
		moved_pos.extax.eax_d := 0 - gantry_r_offset;      ! Physical R = 0 - Floor_R
		moved_pos.extax.eax_f := gantry_x_offset - 9500;   ! X2 = X1 (synchronized!)
		MoveAbsJ moved_pos, v100, fine, tool0;
		WaitTime 1.0;

		! Measure AFTER gantry movement
		TPWrite "Measuring AFTER gantry move...";
		Write debug_logfile, "";
		Write debug_logfile, "========================================";
		Write debug_logfile, "AFTER Gantry Movement Test";
		Write debug_logfile, "========================================";
		UpdateRobot1FloorPosition;
		UpdateRobot2BaseDynamicWobj;  ! Update Robot2 base coordinate for TASK2
		! Note: robot2_floor_pos_t1 is updated by TASK2's UpdateRobot2FloorPosition
		rob1_floor_after := robot1_floor_pos_t1;
		rob2_floor_after := robot2_floor_pos_t1;

		! Return to HOME position
		TPWrite "Returning to HOME...";
		MoveAbsJ home_pos, v100, fine, tool0;

		! Save final results summary
		TPWrite "Saving results...";
		Write debug_logfile, "";
		Write debug_logfile, "========================================";
		Write debug_logfile, "RESULTS SUMMARY";
		Write debug_logfile, "========================================";
		Write debug_logfile, "Gantry Movement Target (Floor coordinates):";
		Write debug_logfile, "  X = " + NumToStr(gantry_x_offset, 2) + " mm";
		Write debug_logfile, "  Y = " + NumToStr(gantry_y_offset, 2) + " mm";
		Write debug_logfile, "  Z = " + NumToStr(gantry_z_offset, 2) + " mm";
		Write debug_logfile, "  R = " + NumToStr(gantry_r_offset, 2) + " deg";
		Write debug_logfile, "";
		Write debug_logfile, "BEFORE Gantry Movement (HOME):";
		Write debug_logfile, "------------------------";
		Write debug_logfile, "Robot1 Floor (tool0):";
		Write debug_logfile, "  X = " + NumToStr(rob1_floor_before.trans.x, 2) + " mm";
		Write debug_logfile, "  Y = " + NumToStr(rob1_floor_before.trans.y, 2) + " mm";
		Write debug_logfile, "  Z = " + NumToStr(rob1_floor_before.trans.z, 2) + " mm";
		Write debug_logfile, "";
		Write debug_logfile, "Robot2 Floor (tool0):";
		Write debug_logfile, "  X = " + NumToStr(rob2_floor_before.trans.x, 2) + " mm";
		Write debug_logfile, "  Y = " + NumToStr(rob2_floor_before.trans.y, 2) + " mm";
		Write debug_logfile, "  Z = " + NumToStr(rob2_floor_before.trans.z, 2) + " mm";
		Write debug_logfile, "";
		Write debug_logfile, "AFTER Gantry Movement:";
		Write debug_logfile, "----------------------";
		Write debug_logfile, "Robot1 Floor (tool0):";
		Write debug_logfile, "  X = " + NumToStr(rob1_floor_after.trans.x, 2) + " mm";
		Write debug_logfile, "  Y = " + NumToStr(rob1_floor_after.trans.y, 2) + " mm";
		Write debug_logfile, "  Z = " + NumToStr(rob1_floor_after.trans.z, 2) + " mm";
		Write debug_logfile, "";
		Write debug_logfile, "Robot2 Floor (tool0):";
		Write debug_logfile, "  X = " + NumToStr(rob2_floor_after.trans.x, 2) + " mm";
		Write debug_logfile, "  Y = " + NumToStr(rob2_floor_after.trans.y, 2) + " mm";
		Write debug_logfile, "  Z = " + NumToStr(rob2_floor_after.trans.z, 2) + " mm";
		Write debug_logfile, "";
		Write debug_logfile, "DIFFERENCE:";
		Write debug_logfile, "-----------";
		Write debug_logfile, "Robot1 Floor Delta:";
		Write debug_logfile, "  dX = " + NumToStr(rob1_floor_after.trans.x - rob1_floor_before.trans.x, 2) + " mm";
		Write debug_logfile, "  dY = " + NumToStr(rob1_floor_after.trans.y - rob1_floor_before.trans.y, 2) + " mm";
		Write debug_logfile, "  dZ = " + NumToStr(rob1_floor_after.trans.z - rob1_floor_before.trans.z, 2) + " mm";
		Write debug_logfile, "";
		Write debug_logfile, "Robot2 Floor Delta:";
		Write debug_logfile, "  dX = " + NumToStr(rob2_floor_after.trans.x - rob2_floor_before.trans.x, 2) + " mm";
		Write debug_logfile, "  dY = " + NumToStr(rob2_floor_after.trans.y - rob2_floor_before.trans.y, 2) + " mm";
		Write debug_logfile, "  dZ = " + NumToStr(rob2_floor_after.trans.z - rob2_floor_before.trans.z, 2) + " mm";
		Write debug_logfile, "========================================\0A";

		Close debug_logfile;
		TPWrite "Saved to: /HOME/gantry_floor_test.txt";
		TPWrite "Test complete!";
		TPWrite "========================================";

	ERROR
		IF ERRNO = ERR_FILEOPEN THEN
			TPWrite "ERROR: Cannot open config.txt or log file";
		ELSE
			TPWrite "ERROR in TestGantryFloorCoordinates: " + NumToStr(ERRNO, 0);
		ENDIF
		Close configfile;
		Close debug_logfile;
		STOP;
	ENDPROC

	! ========================================
	! Test Gantry with Multiple R-axis Rotations
	! ========================================
	! Version: v1.8.7
	! Date: 2026-01-05
	! Purpose: Test Robot1 and Robot2 TCP positions at various R-axis angles
	! Features:
	!   - Config-based angle configuration (NUM_R_ANGLES, R_ANGLE_1~10)
	!   - Robot1 and Robot2 Floor TCP coordinate measurement
	!   - Automatic gantry position logging
	! Changes in v1.8.7:
	!   - Reduced header writes and summarized R_ANGLES for 41617 stability
	!   - Increased per-angle WaitTime to 0.2 for I/O stability
	! Changes in v1.8.5:
	!   - Log gantry Floor values using Floor conversion (X+9500, Y/Z inverted)
	! Changes in v1.8.4:
	!   - Chunked file logging with WaitTime 0.1 to reduce 41617
	! Changes in v1.8.1:
	!   - BUGFIX: Added UpdateRobot2BaseDynamicWobj() call (Line 1918)
	!   - Fixed Robot2 Floor TCP reporting [0,0,0]
	! Changes in v1.8.0:
	!   - Config-based R-axis angle reading from config.txt
	!   - Replaces hardcoded angles with NUM_R_ANGLES and R_ANGLE_1~10
	!   - Enhanced logging with gantry position details
	! Initial position: Robot1 and Robot2 at HOME
	! Gantry position: X=0, Y=0, Z=0 (fixed), R varies according to config
	! Output: /HOME/gantry_rotation_test.txt
	PROC TestGantryRotation()
		VAR jointtarget home_pos;
		VAR jointtarget test_pos;
		VAR robtarget rob1_floor;
		VAR robtarget rob2_floor;
		VAR iodev logfile;
		VAR iodev configfile;
		VAR num test_x;
		VAR num test_y;
		VAR num test_z;
		VAR num r_angles{10};
		VAR num num_r_angles;
		VAR num i;
		VAR string r_str;
		VAR string line;
		VAR string value_str;
		VAR string r_list;
		VAR string csv_line;
		VAR bool found_value;

		! Initialize
		test_x := 0;  ! Fixed at 0 for R-axis rotation test
		test_y := 0;
		test_z := 0;
		num_r_angles := 0;

		! Read config.txt for R angles
		TPWrite "Reading config.txt for R angles...";
		Open "HOME:/config.txt", configfile \Read;

		! Read NUM_R_ANGLES
		WHILE num_r_angles = 0 DO
			line := ReadStr(configfile \RemoveCR);
			IF StrFind(line, 1, "NUM_R_ANGLES=") = 1 THEN
				IF StrLen(line) >= 14 THEN
					value_str := StrPart(line, 14, StrLen(line) - 13);
					found_value := StrToVal(value_str, num_r_angles);
					TPWrite "NUM_R_ANGLES=" + NumToStr(num_r_angles, 0);
				ENDIF
			ENDIF
		ENDWHILE

		! Read R_ANGLE_1 to R_ANGLE_10
		FOR i FROM 1 TO num_r_angles DO
			WHILE TRUE DO
				line := ReadStr(configfile);
				IF StrFind(line, 1, "R_ANGLE_" + NumToStr(i,0) + "=") = 1 THEN
					value_str := StrPart(line, StrLen("R_ANGLE_" + NumToStr(i,0) + "=") + 1, StrLen(line) - StrLen("R_ANGLE_" + NumToStr(i,0) + "="));
					found_value := StrToVal(value_str, r_angles{i});
					TPWrite "R_ANGLE_" + NumToStr(i,0) + "=" + NumToStr(r_angles{i}, 1);
					GOTO next_angle;
				ENDIF
			ENDWHILE
			next_angle:
		ENDFOR

		Close configfile;

		! Build R angle list for header logging
		r_list := "";
		FOR i FROM 1 TO num_r_angles DO
			IF i = 1 THEN
				r_list := NumToStr(r_angles{i}, 1);
			ELSE
				r_list := r_list + "," + NumToStr(r_angles{i}, 1);
			ENDIF
		ENDFOR

		TPWrite "========================================";
		TPWrite "Starting Multiple R-axis Rotation Test";
		TPWrite "========================================";

		! Verify initial position
		TPWrite "Verifying robots at HOME position...";
		home_pos := CJointT();
		IF Abs(home_pos.extax.eax_a) > 10 OR Abs(home_pos.extax.eax_b) > 10 OR Abs(home_pos.extax.eax_c) > 10 OR Abs(home_pos.extax.eax_d) > 2 THEN
			TPWrite "WARNING: Gantry not at HOME!";
			TPWrite "Current: [" + NumToStr(home_pos.extax.eax_a,0) + ", " + NumToStr(home_pos.extax.eax_b,0) + ", " + NumToStr(home_pos.extax.eax_c,0) + ", " + NumToStr(home_pos.extax.eax_d,1) + "]";
			TPWrite "Please run SetRobot1InitialPosition first";
			RETURN;
		ENDIF

		! Open log file (reduced header writes)
		Open "HOME:/gantry_rotation_test.txt", logfile \Write;
		Write logfile, "Gantry R-axis Rotation Test (" + TASK1_VERSION + ")";
		Write logfile, "Date=" + CDate() + ", Time=" + CTime();
		Write logfile, "Gantry Phys=[" + NumToStr(test_x,0) + "," + NumToStr(test_y,0) + "," + NumToStr(test_z,0)
		              + "], Floor=[" + NumToStr(test_x + 9500,0) + "," + NumToStr(5300 - test_y,0) + "," + NumToStr(2100 - test_z,0) + "]";
		Write logfile, "R_ANGLES=" + r_list;
		Write logfile, "Floor: X+=right, Y+=up, Z+=up, R0:Y-axis, R1 Y+, R2 Y-";
		Write logfile, "R_DEG,GX,GY,GZ,R1X,R1Y,R1Z,R2X,R2Y,R2Z";
		WaitTime 0.3;

		! Test each R angle
		FOR i FROM 1 TO num_r_angles DO
			r_str := NumToStr(r_angles{i}, 1);
			TPWrite "----------------------------------------";
			TPWrite "Test " + NumToStr(i,0) + "/" + NumToStr(num_r_angles,0) + ": R = " + r_str + " degrees";
			TPWrite "----------------------------------------";

			! Move gantry to test position with current R angle
			test_pos := CJointT();
			test_pos.extax.eax_a := test_x;
			test_pos.extax.eax_b := test_y;
			test_pos.extax.eax_c := test_z;
			test_pos.extax.eax_d := r_angles{i};
			test_pos.extax.eax_f := test_x;  ! X2 = X1 (synchronized)
			MoveAbsJ test_pos, v100, fine, tool0;
			WaitTime 0.5;

			! Measure Floor positions
			UpdateRobot1FloorPosition;
			UpdateRobot2BaseDynamicWobj;  ! Update Robot2 base coordinate for TASK2
			! Note: robot2_floor_pos_t1 is updated by UpdateRobot2BaseDynamicWobj
			rob1_floor := robot1_floor_pos_t1;
			rob2_floor := robot2_floor_pos_t1;  ! Updated by TASK2

			! Write results to file (1-line CSV)
			csv_line := NumToStr(r_angles{i}, 1) + ","
			          + NumToStr(test_pos.extax.eax_a,0) + "," + NumToStr(test_pos.extax.eax_b,0) + "," + NumToStr(test_pos.extax.eax_c,0) + ","
			          + NumToStr(rob1_floor.trans.x, 2) + "," + NumToStr(rob1_floor.trans.y, 2) + "," + NumToStr(rob1_floor.trans.z, 2) + ","
			          + NumToStr(rob2_floor.trans.x, 2) + "," + NumToStr(rob2_floor.trans.y, 2) + "," + NumToStr(rob2_floor.trans.z, 2);
			Write logfile, csv_line;
			WaitTime 0.2; ! Keep this WaitTime for I/O stability
			! Display on teach pendant
			TPWrite "Robot1 Floor: [" + NumToStr(rob1_floor.trans.x,1) + ", " + NumToStr(rob1_floor.trans.y,1) + ", " + NumToStr(rob1_floor.trans.z,1) + "]";
			TPWrite "Robot2 Floor: [" + NumToStr(rob2_floor.trans.x,1) + ", " + NumToStr(rob2_floor.trans.y,1) + ", " + NumToStr(rob2_floor.trans.z,1) + "]";
		ENDFOR

		! Return to HOME
		TPWrite "Returning to HOME...";
		MoveAbsJ home_pos, v100, fine, tool0;

		Write logfile, "========================================";
		Write logfile, "Test completed - Returned to HOME";
		Write logfile, "========================================";
		Close logfile;

		TPWrite "========================================";
		TPWrite "R-axis Rotation Test Complete!";
		TPWrite "Results saved to gantry_rotation_test.txt";
		TPWrite "========================================";

	ERROR
		IF ERRNO = ERR_FILEOPEN THEN
			TPWrite "ERROR: Cannot open log file";
		ELSE
			TPWrite "ERROR in TestGantryRotation: " + NumToStr(ERRNO, 0);
		ENDIF
		Close logfile;
		STOP;
	ENDPROC

	! ========================================
	! Mode 2 - Gantry + TCP Offset Verification
	! ========================================
		! Version: v1.8.50
		! Date: 2026-01-08
		! Purpose: Verify TCP tracking with offsets while gantry moves in X/Y/Z/R
		! Config (config.txt):
		!   TEST_MODE=2
		!   TCP_OFFSET_R1_X/Y/Z (fallback: TCP_OFFSET_X/Y/Z)
		!   NUM_POS, POS_1_X/Y/Z/R ...
	! Output: /HOME/gantry_mode2_test.txt
		! Changes in v1.8.50:
		!   - Use hardcoded Mode2 defaults (config.txt ignored).
		! Changes in v1.8.49:
		!   - Remove CONTINUE usage in Mode2 parse loop for RAPID compatibility.
		! Changes in v1.8.48:
		!   - Rework Mode2 config parsing: single-pass ReadStr loop with guards.
		! Changes in v1.8.47:
		!   - TEMP: Bypass config.txt parsing and use default Mode2 offsets/positions.
		! Changes in v1.8.46:
		!   - Use ReadStr \RemoveCR in Mode2 parsing loops to avoid blocking on CRLF files.
		! Changes in v1.8.14:
		!   - Align gantry axis range checks with MOC.cfg (M1/M2/M3/M4 limits)

! ========================================
! Mode 2 - Gantry + TCP Offset Verification (v1.8.51)
! ========================================
! Version: v1.8.51
! Date: 2026-01-08
! Purpose: Verify TCP tracking with offsets using PERS variables
! No config.txt parsing - all settings from PERS variables
! Output: /HOME/gantry_mode2_test.txt
PROC TestGantryMode2()
	VAR jointtarget home_pos;
	VAR jointtarget test_pos;
	VAR robtarget offset_tcp;
	VAR robtarget rob1_floor;
	VAR robtarget rob2_floor;
	VAR iodev logfile;
	VAR num tcp_offset_x;
	VAR num tcp_offset_y;
	VAR num tcp_offset_z;
	VAR num num_pos;
	VAR num pos_x{10};
	VAR num pos_y{10};
	VAR num pos_z{10};
	VAR num pos_r{10};
	VAR num i;
	VAR string csv_line;
	VAR num floor_x;
	VAR num floor_y;
	VAR num floor_z;
	VAR num floor_r;
	VAR num phys_x;
	VAR num phys_y;
	VAR num phys_z;
	VAR num phys_r;
	VAR bool abort_test;
	VAR string mode2_log;
	VAR string tp_log;
	VAR iodev tp_logfile;
	VAR jointtarget current_gantry;
	VAR robjoint robot1_offset_joints;
	VAR num wait_count;

	abort_test := FALSE;
	mode2_log := "HOME:/gantry_mode2_test.txt";
	tp_log := "HOME:/tp_messages.txt";

	! v1.8.57: Reset sync flags at start (TASK2 must wait)
	mode2_config_ready := FALSE;
	mode2_r2_initial_offset_done := FALSE;

	Open mode2_log, logfile \Write;
	Open tp_log, tp_logfile \Write;
	Write tp_logfile, "TP Log (" + TASK1_VERSION + ") Date=" + CDate() + " Time=" + CTime();
	Write tp_logfile, "========================================";
	Write logfile, "Mode2 Test (" + TASK1_VERSION + ") Date=" + CDate() + " Time=" + CTime();
	Write logfile, "Enter TestGantryMode2";
	TPWrite "Mode2: Loading config from PERS variables";
	Write tp_logfile, "Mode2: Loading config from PERS variables";

	! DEBUG: Log ConfigModule PERS values BEFORE copy
	Write tp_logfile, "DEBUG: ConfigModule R2 BEFORE copy:";
	Write tp_logfile, "  MODE2_TCP_OFFSET_R2_X=" + NumToStr(MODE2_TCP_OFFSET_R2_X, 1);
	Write tp_logfile, "  MODE2_TCP_OFFSET_R2_Y=" + NumToStr(MODE2_TCP_OFFSET_R2_Y, 1);
	Write tp_logfile, "  MODE2_TCP_OFFSET_R2_Z=" + NumToStr(MODE2_TCP_OFFSET_R2_Z, 1);
	Write tp_logfile, "DEBUG: mode2_r2_offset BEFORE copy:";
	Write tp_logfile, "  mode2_r2_offset_y=" + NumToStr(mode2_r2_offset_y, 1);

	! Read configuration from PERS variables (no file I/O)
	tcp_offset_x := MODE2_TCP_OFFSET_R1_X;
	tcp_offset_y := MODE2_TCP_OFFSET_R1_Y;
	tcp_offset_z := MODE2_TCP_OFFSET_R1_Z;

	! Sync Robot2 offsets from ConfigModule (for TASK2)
	mode2_r2_offset_x := MODE2_TCP_OFFSET_R2_X;
	mode2_r2_offset_y := MODE2_TCP_OFFSET_R2_Y;
	mode2_r2_offset_z := MODE2_TCP_OFFSET_R2_Z;

	! v1.8.57: Set sync flag (TASK2 can now read values)
	mode2_config_ready := TRUE;
	Write tp_logfile, "SYNC: mode2_config_ready=TRUE (TASK2 can proceed)";

	! DEBUG: Log values AFTER copy
	Write tp_logfile, "DEBUG: mode2_r2_offset AFTER copy:";
	Write tp_logfile, "  mode2_r2_offset_y=" + NumToStr(mode2_r2_offset_y, 1);

	! Log Robot2 offsets
	Write logfile, "R2_OFFSET=" + NumToStr(mode2_r2_offset_x, 1) + ","
	              + NumToStr(mode2_r2_offset_y, 1) + ","
	              + NumToStr(mode2_r2_offset_z, 1);

	! Read test positions
	num_pos := MODE2_NUM_POS;
	FOR i FROM 1 TO 10 DO
		pos_x{i} := MODE2_POS_X{i};
		pos_y{i} := MODE2_POS_Y{i};
		pos_z{i} := MODE2_POS_Z{i};
		pos_r{i} := MODE2_POS_R{i};
	ENDFOR

	Write logfile, "Config loaded from PERS - NUM_POS=" + NumToStr(num_pos, 0);
	Write logfile, "TCP_OFFSET_R1=" + NumToStr(tcp_offset_x,1) + ","
	              + NumToStr(tcp_offset_y,1) + ","
	              + NumToStr(tcp_offset_z,1);
	Write logfile, "X,Y,Z,R,R1X,R1Y,R1Z,R2X,R2Y,R2Z";
	TPWrite "Mode2: Config loaded, NUM_POS=" + NumToStr(num_pos, 0);
	Write tp_logfile, "Mode2: Config loaded, NUM_POS=" + NumToStr(num_pos, 0);
	WaitTime 0.3;

	! Move Robot1 to offset in WobjGantry
	UpdateGantryWobj;
	home_pos := CJointT();
	offset_tcp := [[tcp_offset_x, tcp_offset_y, 1000 + tcp_offset_z], [0.5, -0.5, 0.5, 0.5], [0, 0, 0, 0], home_pos.extax];
	MoveJ offset_tcp, v100, fine, tool0\WObj:=WobjGantry;
	TPWrite "Mode2: Robot1 at offset TCP";
	Write tp_logfile, "Mode2: Robot1 at offset TCP";

	! Save Robot1 joint angles for use in loop (fixed joints = fixed TCP direction)
	current_gantry := CJointT();
	robot1_offset_joints := current_gantry.robax;
	Write tp_logfile, "Robot1 offset joints: saved";

	! v1.8.67: Wait for Robot2 initial offset before moving gantry
	TPWrite "Mode2: Waiting for Robot2 initial offset...";
	Write tp_logfile, "SYNC: Waiting for Robot2 initial offset...";
	wait_count := 0;
	WHILE NOT mode2_r2_initial_offset_done AND wait_count < 100 DO
		WaitTime 0.1;
		wait_count := wait_count + 1;
	ENDWHILE
	IF mode2_r2_initial_offset_done THEN
		Write tp_logfile, "SYNC: Robot2 initial offset done (waited " + NumToStr(wait_count, 0) + " cycles)";
		TPWrite "Mode2: Robot2 initial offset done";
	ELSE
		Write tp_logfile, "WARNING: Robot2 initial offset timeout!";
		TPWrite "Mode2: WARNING - Robot2 offset timeout!";
	ENDIF

	! Test each position
	FOR i FROM 1 TO num_pos DO
		! Calculate Floor coordinates (COMPLEX_POS format)
		floor_x := 9500 + pos_x{i};
		floor_y := 5300 + pos_y{i};
		floor_z := 2100 + pos_z{i};
		floor_r := pos_r{i};

		! Convert to physical gantry coordinates
		phys_x := floor_x - 9500;
		phys_y := 5300 - floor_y;
		phys_z := 2100 - floor_z;
		phys_r := 0 - floor_r;

		! Check gantry axis limits (MOC.cfg)
		! M1 [-9.51, 12.31], M2 [-0.05, 5.35], M3 [-0.05, 1.05], M4 [-100, 100] deg
		IF phys_x < -9510 OR phys_x > 12310 OR phys_y < -50 OR phys_y > 5350 OR phys_z < -50 OR phys_z > 1050 OR phys_r < -100 OR phys_r > 100 THEN
			Write logfile, "OUT_OF_RANGE idx=" + NumToStr(i,0)
			              + " floor=[" + NumToStr(floor_x,0) + "," + NumToStr(floor_y,0) + "," + NumToStr(floor_z,0) + "," + NumToStr(floor_r,1) + "]"
			              + " phys=[" + NumToStr(phys_x,0) + "," + NumToStr(phys_y,0) + "," + NumToStr(phys_z,0) + "," + NumToStr(phys_r,1) + "]";
			TPWrite "Mode2: Position " + NumToStr(i,0) + " out of range!";
			abort_test := TRUE;
			GOTO mode2_cleanup;
		ENDIF

		! Move gantry to test position (Robot1 joints fixed to offset position)
		test_pos := CJointT();
		test_pos.robax := robot1_offset_joints;  ! Keep Robot1 at offset position
		test_pos.extax.eax_a := phys_x;
		test_pos.extax.eax_b := phys_y;
		test_pos.extax.eax_c := phys_z;
		test_pos.extax.eax_d := phys_r;
		test_pos.extax.eax_f := test_pos.extax.eax_a;
		MoveAbsJ test_pos, v100, fine, tool0;
		TPWrite "Mode2: Gantry moved to position " + NumToStr(i,0) + "/" + NumToStr(num_pos,0);
		Write tp_logfile, "Mode2: Gantry moved to position " + NumToStr(i,0) + "/" + NumToStr(num_pos,0);

		! Update WobjGantry for new gantry position and rotation
		UpdateGantryWobj;

		! Read current gantry position AFTER move (fix for eax_e mismatch)
		current_gantry := CJointT();
		Write tp_logfile, "WobjGantry updated: [" + NumToStr(current_gantry.extax.eax_a,0) + ", "
		                  + NumToStr(current_gantry.extax.eax_b,0) + ", "
		                  + NumToStr(current_gantry.extax.eax_c,0) + ", R="
		                  + NumToStr(current_gantry.extax.eax_d,1) + "]";
		Write tp_logfile, "current_gantry.extax: [" + NumToStr(current_gantry.extax.eax_a,1) + ", "
		                  + NumToStr(current_gantry.extax.eax_b,1) + ", "
		                  + NumToStr(current_gantry.extax.eax_c,1) + ", "
		                  + NumToStr(current_gantry.extax.eax_d,1) + ", "
		                  + NumToStr(current_gantry.extax.eax_e,1) + ", "
		                  + NumToStr(current_gantry.extax.eax_f,1) + "]";

		! Robot1 already at offset position (joints fixed in MoveAbsJ)
		Write tp_logfile, "Robot1 maintaining offset joints (pos " + NumToStr(i,0) + ")";

		! v1.8.63: Trigger Robot2 to reposition at current R angle
		mode2_r2_reposition_done := FALSE;
		mode2_r2_reposition_trigger := TRUE;
		Write tp_logfile, "SYNC: Waiting for Robot2 reposition...";
		wait_count := 0;
		WHILE NOT mode2_r2_reposition_done AND wait_count < 100 DO
			WaitTime 0.1;
			wait_count := wait_count + 1;
		ENDWHILE
		mode2_r2_reposition_trigger := FALSE;
		IF mode2_r2_reposition_done THEN
			Write tp_logfile, "SYNC: Robot2 repositioned (waited " + NumToStr(wait_count, 0) + " cycles)";
		ELSE
			Write tp_logfile, "SYNC: WARNING - Robot2 reposition timeout!";
		ENDIF
		WaitTime 0.3;

		! Measure Robot1 and Robot2 TCP positions
		UpdateRobot1FloorPosition;
		UpdateRobot2BaseDynamicWobj;
		rob1_floor := robot1_floor_pos_t1;
		rob2_floor := robot2_floor_pos_t1;

		! v1.8.60 DEBUG: Detailed position analysis
		Write tp_logfile, "========== v1.8.60 DETAILED DEBUG ==========";
		Write tp_logfile, "--- Gantry Position ---";
		Write tp_logfile, "  Gantry Floor: [" + NumToStr(floor_x, 0) + ", " + NumToStr(floor_y, 0) + ", " + NumToStr(floor_z, 0) + "]";
		Write tp_logfile, "  Gantry Local (extax): [" + NumToStr(phys_x, 0) + ", " + NumToStr(phys_y, 0) + ", " + NumToStr(phys_z, 0) + ", R=" + NumToStr(phys_r, 1) + "]";
		Write tp_logfile, "  R-center Floor: [" + NumToStr(floor_x, 0) + ", " + NumToStr(floor_y, 0) + ", " + NumToStr(floor_z, 0) + "]";
		Write tp_logfile, "";
		Write tp_logfile, "--- Robot1 (wobj0 at R-center, gantry-configured) ---";
		Write tp_logfile, "  Robot1 Base Floor = R-center: [" + NumToStr(floor_x, 0) + ", " + NumToStr(floor_y, 0) + ", " + NumToStr(floor_z, 0) + "]";
		Write tp_logfile, "  Robot1 offset_tcp in WobjGantry: [" + NumToStr(tcp_offset_x, 1) + ", " + NumToStr(tcp_offset_y, 1) + ", " + NumToStr(1000 + tcp_offset_z, 1) + "]";
		Write tp_logfile, "  Robot1 TCP Floor (measured): [" + NumToStr(rob1_floor.trans.x, 2) + ", " + NumToStr(rob1_floor.trans.y, 2) + ", " + NumToStr(rob1_floor.trans.z, 2) + "]";
		Write tp_logfile, "  Robot1 TCP offset from R-center: [" + NumToStr(rob1_floor.trans.x - floor_x, 2) + ", " + NumToStr(rob1_floor.trans.y - floor_y, 2) + ", " + NumToStr(rob1_floor.trans.z - floor_z, 2) + "]";
		Write tp_logfile, "";
		Write tp_logfile, "--- Robot2 (wobj0 at Robot2 base, NOT gantry-configured) ---";
		Write tp_logfile, "  Robot2 Base Floor: [" + NumToStr(debug_r2_base_floor_x, 2) + ", " + NumToStr(rob2_floor.trans.y - (debug_r2_wobj0_y * Cos(current_gantry.extax.eax_d)), 2) + "]";
		Write tp_logfile, "  Robot2 offset_tcp in WobjGantry_Rob2: [0, " + NumToStr(488 + mode2_r2_offset_y, 1) + ", -1000]";
		Write tp_logfile, "  Robot2 wobj0 (TCP from base): [" + NumToStr(debug_r2_wobj0_x, 2) + ", " + NumToStr(debug_r2_wobj0_y, 2) + "]";
		Write tp_logfile, "  Robot2 TCP Floor (measured): [" + NumToStr(rob2_floor.trans.x, 2) + ", " + NumToStr(rob2_floor.trans.y, 2) + ", " + NumToStr(rob2_floor.trans.z, 2) + "]";
		Write tp_logfile, "  Robot2 TCP offset from R-center: [" + NumToStr(rob2_floor.trans.x - floor_x, 2) + ", " + NumToStr(rob2_floor.trans.y - floor_y, 2) + ", " + NumToStr(rob2_floor.trans.z - floor_z, 2) + "]";
		Write tp_logfile, "";
		Write tp_logfile, "--- Comparison ---";
		Write tp_logfile, "  3D Distance: " + NumToStr(Sqrt(Pow(rob1_floor.trans.x - rob2_floor.trans.x, 2) + Pow(rob1_floor.trans.y - rob2_floor.trans.y, 2) + Pow(rob1_floor.trans.z - rob2_floor.trans.z, 2)), 2) + " mm";
		Write tp_logfile, "  Expected (at R=0): 200.00 mm";
		Write tp_logfile, "=========================================";

		! v1.8.61 DEBUG: Log X coordinate analysis
		Write tp_logfile, "DEBUG X Analysis:";
		Write tp_logfile, "  Gantry X (R-center): " + NumToStr(phys_x + 9500, 1);
		Write tp_logfile, "  R angle (extax.eax_d): " + NumToStr(current_gantry.extax.eax_d, 1);
		Write tp_logfile, "  sin(R): " + NumToStr(Sin(current_gantry.extax.eax_d), 4);
		Write tp_logfile, "  Robot2 wobj0: [" + NumToStr(debug_r2_wobj0_x, 1) + ", " + NumToStr(debug_r2_wobj0_y, 1) + "]";
		Write tp_logfile, "  Robot2 base_floor_x: " + NumToStr(debug_r2_base_floor_x, 1);
		Write tp_logfile, "  Robot2 floor_x_offset: " + NumToStr(debug_r2_floor_x_offset, 1);
		Write tp_logfile, "  Robot2 X = base + offset: " + NumToStr(debug_r2_base_floor_x, 1) + " + " + NumToStr(debug_r2_floor_x_offset, 1) + " = " + NumToStr(rob2_floor.trans.x, 1);
		Write tp_logfile, "  Robot1 X: " + NumToStr(rob1_floor.trans.x, 2) + " (offset from gantry: " + NumToStr(rob1_floor.trans.x - (phys_x + 9500), 2) + ")";
		Write tp_logfile, "  Robot2 X: " + NumToStr(rob2_floor.trans.x, 2) + " (offset from gantry: " + NumToStr(rob2_floor.trans.x - (phys_x + 9500), 2) + ")";
		Write tp_logfile, "  Expected R2 X offset: +" + NumToStr(100 * Sin(current_gantry.extax.eax_d), 2);
		Write tp_logfile, "  Delta X (R1-R2): " + NumToStr(rob1_floor.trans.x - rob2_floor.trans.x, 2);

		! v1.8.61 DEBUG: Log Y coordinate analysis
		Write tp_logfile, "DEBUG Y Analysis:";
		Write tp_logfile, "  Gantry Y (R-center): " + NumToStr(5300 - phys_y, 1);
		Write tp_logfile, "  cos(R): " + NumToStr(Cos(current_gantry.extax.eax_d), 4);
		Write tp_logfile, "  Robot2 base_floor_y: " + NumToStr(debug_r2_base_floor_y, 1);
		Write tp_logfile, "  Robot2 floor_y_offset: " + NumToStr(debug_r2_floor_y_offset, 1);
		Write tp_logfile, "  Robot2 Y = base + offset: " + NumToStr(debug_r2_base_floor_y, 1) + " + " + NumToStr(debug_r2_floor_y_offset, 1) + " = " + NumToStr(rob2_floor.trans.y, 1);
		Write tp_logfile, "  Robot1 Y: " + NumToStr(rob1_floor.trans.y, 2) + " (offset from gantry: " + NumToStr(rob1_floor.trans.y - (5300 - phys_y), 2) + ")";
		Write tp_logfile, "  Robot2 Y: " + NumToStr(rob2_floor.trans.y, 2) + " (offset from gantry: " + NumToStr(rob2_floor.trans.y - (5300 - phys_y), 2) + ")";
		Write tp_logfile, "  Expected R1 Y offset: +" + NumToStr(100 * Cos(current_gantry.extax.eax_d), 2);
		Write tp_logfile, "  Expected R2 Y offset: -" + NumToStr(100 * Cos(current_gantry.extax.eax_d), 2);
		Write tp_logfile, "  Delta Y (R1-R2): " + NumToStr(rob1_floor.trans.y - rob2_floor.trans.y, 2);
		Write tp_logfile, "  Expected Delta Y: " + NumToStr(200 * Cos(current_gantry.extax.eax_d), 2);

		Write tp_logfile, "Robot1 Floor: [" + NumToStr(rob1_floor.trans.x,2) + ", " + NumToStr(rob1_floor.trans.y,2) + ", " + NumToStr(rob1_floor.trans.z,2) + "]";
		Write tp_logfile, "Robot2 Floor: [" + NumToStr(rob2_floor.trans.x,2) + ", " + NumToStr(rob2_floor.trans.y,2) + ", " + NumToStr(rob2_floor.trans.z,2) + "]";
		Write tp_logfile, "----------------------------------------";

		! Log result
		csv_line := NumToStr(floor_x,0) + "," + NumToStr(floor_y,0) + "," + NumToStr(floor_z,0) + "," + NumToStr(floor_r,1) + ","
		          + NumToStr(rob1_floor.trans.x, 2) + "," + NumToStr(rob1_floor.trans.y, 2) + "," + NumToStr(rob1_floor.trans.z, 2) + ","
		          + NumToStr(rob2_floor.trans.x, 2) + "," + NumToStr(rob2_floor.trans.y, 2) + "," + NumToStr(rob2_floor.trans.z, 2);
		Write logfile, csv_line;
		WaitTime 0.2;
	ENDFOR

mode2_cleanup:
	! Always return gantry to HOME
	TPWrite "Mode2: Returning to HOME";
	Write tp_logfile, "Mode2: Returning to HOME";
	home_pos := CJointT();
	home_pos.extax.eax_a := 0;
	home_pos.extax.eax_b := 0;
	home_pos.extax.eax_c := 0;
	home_pos.extax.eax_d := 0;
	home_pos.extax.eax_f := 0;
	MoveAbsJ home_pos, v100, fine, tool0;

	TPWrite "Mode2: Test complete!";
	Write tp_logfile, "Mode2: Test complete!";
	Write tp_logfile, "========================================";

	! v1.8.63: Signal TASK2 to exit reposition monitor loop
	mode2_config_ready := FALSE;

	Close logfile;
	Close tp_logfile;
	IF abort_test = TRUE THEN
		TPWrite "Mode2: Test aborted (out of range)";
		STOP;
	ENDIF

ERROR
	Write logfile, "ERROR in TestGantryMode2: " + NumToStr(ERRNO, 0);
	Write tp_logfile, "ERROR in TestGantryMode2: " + NumToStr(ERRNO, 0);
	Close logfile;
	Close tp_logfile;
	TPWrite "ERROR in TestGantryMode2: " + NumToStr(ERRNO, 0);
	STOP;
ENDPROC

! ========================================
! Test Menu System (v1.9.2)
! ========================================
! Purpose: TP-based menu for test selection
! Options: Mode2 Test, Weld Sequence, View Results, Exit

! ----------------------------------------
! Main Test Menu
! ----------------------------------------
! Displays menu on TP and executes selected test
! Loop until user selects Exit
PROC TestMenu()
	VAR num menu_sel;
	VAR bool menu_loop;

	menu_loop := TRUE;

	WHILE menu_loop DO
		! Display menu
		TPErase;
		TPWrite "========================================";
		TPWrite "  S25016 SpGantry Test Menu (v2.6.0)";
		TPWrite "========================================";
		TPWrite "";
		TPWrite "  1. Sync X1/X2 (Check + Auto-fix)";
		TPWrite "  2. Edge to Weld (CALC ONLY, no move)";
		TPWrite "  3. Edge to Weld (with gantry move)";
		TPWrite "  4. Test Gantry Floor Coordinates";
		TPWrite "  5. Execute Weld Sequence";
		TPWrite "  6. View Config";
		TPWrite "  7. View Results";
		TPWrite "  8. Multi-Angle Test (0/45/90/-45 deg)";
		TPWrite "  9. Edge to Weld + Robot1 Move";
		TPWrite " 10. Multi-Position Test (5 locations)";
		TPWrite " 11. Full Weld Seq (Gantry+R1+R2 sync)";
		TPWrite "  0. Exit";
		TPWrite "";
		TPWrite "----------------------------------------";

		! Numeric selection
		TPReadNum menu_sel, "Select (0-11): ";

		TEST menu_sel
		CASE 1:
			TPErase;
			TPWrite "[Menu] Checking Linked Motor Sync...";
			CheckLinkedMotorSync;
			TPWrite "";
			TPWrite "Press any key to continue...";
			TPReadFK menu_sel, "Continue?", "OK", "", "", "", "";

		CASE 2:
			TPErase;
			TPWrite "[Menu] Edge to Weld CALC ONLY...";
			TestEdgeToWeldCalcOnly;
			TPWrite "";
			TPWrite "Press any key to continue...";
			TPReadFK menu_sel, "Continue?", "OK", "", "", "", "";

		CASE 3:
			TPErase;
			TPWrite "[Menu] Edge to Weld with Movement...";
			TestEdgeToWeld;
			TPWrite "";
			TPWrite "Press any key to continue...";
			TPReadFK menu_sel, "Continue?", "OK", "", "", "", "";

		CASE 4:
			TPErase;
			TPWrite "[Menu] Starting Floor Coordinate Test...";
			TestGantryFloorCoordinates;
			TPWrite "";
			TPWrite "Press any key to continue...";
			TPReadFK menu_sel, "Continue?", "OK", "", "", "", "";

		CASE 5:
			TPErase;
			TPWrite "[Menu] Starting Weld Sequence...";
			ExecuteWeldSequence;
			TPWrite "";
			TPWrite "Press any key to continue...";
			TPReadFK menu_sel, "Continue?", "OK", "", "", "", "";

		CASE 6:
			TPErase;
			ViewCurrentConfig;
			TPWrite "";
			TPWrite "Press any key to continue...";
			TPReadFK menu_sel, "Continue?", "OK", "", "", "", "";

		CASE 7:
			TPErase;
			ViewLastResults;
			TPWrite "";
			TPWrite "Press any key to continue...";
			TPReadFK menu_sel, "Continue?", "OK", "", "", "", "";

		CASE 8:
			TPErase;
			TPWrite "[Menu] Starting Multi-Angle Test...";
			TestMultiAngle;
			TPWrite "";
			TPWrite "Press any key to continue...";
			TPReadFK menu_sel, "Continue?", "OK", "", "", "", "";

		CASE 9:
			TPErase;
			TPWrite "[Menu] Edge to Weld + Robot Move...";
			TestEdgeToWeldWithRobot;
			TPWrite "";
			TPWrite "Press any key to continue...";
			TPReadFK menu_sel, "Continue?", "OK", "", "", "", "";

		CASE 10:
			TPErase;
			TPWrite "[Menu] Starting Multi-Position Test...";
			TestMultiPosition;
			TPWrite "";
			TPWrite "Press any key to continue...";
			TPReadFK menu_sel, "Continue?", "OK", "", "", "", "";

		CASE 11:
			TPErase;
			TPWrite "[Menu] Full Weld Sequence (Gantry+R1+R2)...";
			TPWrite "NOTE: TASK2 must be in Weld mode";
			TestFullWeldSequence;
			TPWrite "";
			TPWrite "Press any key to continue...";
			TPReadFK menu_sel, "Continue?", "OK", "", "", "", "";

		CASE 0:
			TPErase;
			TPWrite "[Menu] Exiting Test Menu...";
			menu_loop := FALSE;

		DEFAULT:
			TPWrite "[Menu] Invalid selection (0-11)";
			WaitTime 1;
		ENDTEST
	ENDWHILE

	TPWrite "========================================";
	TPWrite "Test Menu closed. Returning to main...";
	TPWrite "========================================";
ENDPROC

! ----------------------------------------
! View Last Test Results
! ----------------------------------------
! Displays summary of last Mode2 test results
PROC ViewLastResults()
	VAR iodev resultfile;
	VAR string line;
	VAR num line_count;
	VAR bool file_ok;

	TPWrite "========================================";
	TPWrite "  Last Mode2 Test Results";
	TPWrite "========================================";
	TPWrite "";

	file_ok := TRUE;
	Open "HOME:/gantry_mode2_test.txt", resultfile \Read;

	! Read and display first 15 lines
	line_count := 0;
	WHILE file_ok AND line_count < 15 DO
		line := ReadStr(resultfile \Delim:="\0a");
		IF StrLen(line) > 0 THEN
			TPWrite line;
			line_count := line_count + 1;
		ENDIF
	ENDWHILE

	Close resultfile;

	TPWrite "";
	TPWrite "----------------------------------------";
	TPWrite "Full log: HOME:/gantry_mode2_test.txt";
	TPWrite "TP log: HOME:/tp_messages.txt";

ERROR
	IF ERRNO = ERR_FILEOPEN THEN
		TPWrite "ERROR: Result file not found";
		TPWrite "Run Mode2 test first!";
		file_ok := FALSE;
		TRYNEXT;
	ELSE
		! End of file or other read error
		Close resultfile;
		file_ok := FALSE;
		TRYNEXT;
	ENDIF
ENDPROC

! ----------------------------------------
! View Current Configuration
! ----------------------------------------
! Displays current Mode2 and Weld configuration
PROC ViewCurrentConfig()
	TPWrite "========================================";
	TPWrite "  Current Configuration (v1.9.2)";
	TPWrite "========================================";
	TPWrite "";

	TPWrite "--- Mode2 TCP Offsets ---";
	TPWrite "R1 Offset: [" + NumToStr(MODE2_TCP_OFFSET_R1_X, 1) + ", "
	                       + NumToStr(MODE2_TCP_OFFSET_R1_Y, 1) + ", "
	                       + NumToStr(MODE2_TCP_OFFSET_R1_Z, 1) + "]";
	TPWrite "R2 Offset: [" + NumToStr(MODE2_TCP_OFFSET_R2_X, 1) + ", "
	                       + NumToStr(MODE2_TCP_OFFSET_R2_Y, 1) + ", "
	                       + NumToStr(MODE2_TCP_OFFSET_R2_Z, 1) + "]";
	TPWrite "Num Positions: " + NumToStr(MODE2_NUM_POS, 0);
	TPWrite "";

	TPWrite "--- Weld Sequence ---";
	TPWrite "R1 Start: [" + NumToStr(WELD_R1_START_X, 0) + ", "
	                      + NumToStr(WELD_R1_START_Y, 0) + ", "
	                      + NumToStr(WELD_R1_START_Z, 0) + "]";
	TPWrite "R1 End: [" + NumToStr(WELD_R1_END_X, 0) + ", "
	                    + NumToStr(WELD_R1_END_Y, 0) + ", "
	                    + NumToStr(WELD_R1_END_Z, 0) + "]";
	TPWrite "R2 Start: [" + NumToStr(WELD_R2_START_X, 0) + ", "
	                      + NumToStr(WELD_R2_START_Y, 0) + ", "
	                      + NumToStr(WELD_R2_START_Z, 0) + "]";
	TPWrite "R2 End: [" + NumToStr(WELD_R2_END_X, 0) + ", "
	                    + NumToStr(WELD_R2_END_Y, 0) + ", "
	                    + NumToStr(WELD_R2_END_Z, 0) + "]";
	TPWrite "";

	TPWrite "--- Weld Robot Positions (WObj) ---";
	TPWrite "R1 WObj: [" + NumToStr(WELD_R1_WObj_X, 0) + ", "
	                     + NumToStr(WELD_R1_WObj_Y, 0) + ", "
	                     + NumToStr(WELD_R1_WObj_Z, 0) + "]";
	TPWrite "R2 WObj: [" + NumToStr(WELD_R2_WObj_X, 0) + ", "
	                     + NumToStr(WELD_R2_WObj_Y, 0) + ", "
	                     + NumToStr(WELD_R2_WObj_Z, 0) + "]";
	TPWrite "TCP Z Offset: " + NumToStr(WELD_R1_TCP_Z_OFFSET, 0) + " mm";
	TPWrite "Weld Speed: " + NumToStr(WELD_SPEED, 0) + " mm/s";
ENDPROC

! ========================================
! Weld Sequence Procedures (v1.9.0)
! ========================================
! Purpose: Execute welding sequence with calculated gantry position
! Input: Weld lines from ConfigModule PERS variables
! Output: Gantry moves along center line while robots maintain weld posture

! ----------------------------------------
! Calculate Center Line from Two Weld Lines
! ----------------------------------------
! Calculates center point between Robot1 and Robot2 weld lines
! Sets module variables: weld_center_start, weld_center_end, weld_center_angle, weld_length
PROC CalcCenterLine()
	VAR num dx;
	VAR num dy;
	VAR num dz;

	TPWrite "[WELD] Calculating center line...";

	! Calculate center start point (average of R1 and R2 start)
	weld_center_start.x := (WELD_R1_START_X + WELD_R2_START_X) / 2;
	weld_center_start.y := (WELD_R1_START_Y + WELD_R2_START_Y) / 2;
	weld_center_start.z := (WELD_R1_START_Z + WELD_R2_START_Z) / 2;

	! Calculate center end point (average of R1 and R2 end)
	weld_center_end.x := (WELD_R1_END_X + WELD_R2_END_X) / 2;
	weld_center_end.y := (WELD_R1_END_Y + WELD_R2_END_Y) / 2;
	weld_center_end.z := (WELD_R1_END_Z + WELD_R2_END_Z) / 2;

	! Calculate weld direction vector
	dx := weld_center_end.x - weld_center_start.x;
	dy := weld_center_end.y - weld_center_start.y;
	dz := weld_center_end.z - weld_center_start.z;

	! Calculate weld length
	weld_length := Sqrt(dx*dx + dy*dy + dz*dz);

	! Calculate R-axis angle (Floor X+ = R=0°)
	! atan2(dy, dx) gives angle from X-axis
	weld_center_angle := ATan2(dy, dx);

	TPWrite "[WELD] Center Start: [" + NumToStr(weld_center_start.x, 1) + ", "
	                                  + NumToStr(weld_center_start.y, 1) + ", "
	                                  + NumToStr(weld_center_start.z, 1) + "]";
	TPWrite "[WELD] Center End: [" + NumToStr(weld_center_end.x, 1) + ", "
	                                + NumToStr(weld_center_end.y, 1) + ", "
	                                + NumToStr(weld_center_end.z, 1) + "]";
	TPWrite "[WELD] R-angle: " + NumToStr(weld_center_angle, 2) + " deg";
	TPWrite "[WELD] Weld length: " + NumToStr(weld_length, 1) + " mm";
ENDPROC

! ----------------------------------------
! Calculate Gantry Position from Floor Coordinates
! ----------------------------------------
! Converts Floor TCP coordinates to Physical gantry coordinates
! Accounts for robot TCP offset from R-center
! Gantry_Z = 2100 - Floor_Z - TCP_Z_OFFSET
FUNC pos CalcGantryFromFloor(pos floor_pos)
	VAR pos gantry_pos;
	VAR num avg_tcp_offset;

	! Average TCP offset (both robots should be at similar Z)
	avg_tcp_offset := (WELD_R1_TCP_Z_OFFSET + WELD_R2_TCP_Z_OFFSET) / 2;

	! Floor -> Physical conversion
	! gantry_x = floor_x - 9500
	! gantry_y = 5300 - floor_y
	! gantry_z = 2100 - floor_z - tcp_offset
	gantry_pos.x := floor_pos.x - 9500;
	gantry_pos.y := 5300 - floor_pos.y;
	gantry_pos.z := 2100 - floor_pos.z - avg_tcp_offset;

	TPWrite "[WELD] Floor->Gantry: TCP offset=" + NumToStr(avg_tcp_offset, 0) + "mm";
	TPWrite "[WELD] Gantry Z = 2100 - " + NumToStr(floor_pos.z, 0) + " - " + NumToStr(avg_tcp_offset, 0) + " = " + NumToStr(gantry_pos.z, 0);

	RETURN gantry_pos;
ENDFUNC

! ----------------------------------------
! Create Weld WObj from Weld Line
! ----------------------------------------
! Creates a work object where X-axis is weld direction, Z-axis is Floor Z (down)
! Parameters:
!   weld_start: Weld line start point (Floor coordinates)
!   weld_end: Weld line end point (Floor coordinates)
!   wobj: Output work object to update
PROC CreateWeldWobj(pos weld_start, pos weld_end, INOUT wobjdata wobj)
	VAR num dx;
	VAR num dy;
	VAR num len_xy;
	VAR num angle_deg;
	VAR num cos_half;
	VAR num sin_half;

	! Calculate weld direction in XY plane
	dx := weld_end.x - weld_start.x;
	dy := weld_end.y - weld_start.y;
	len_xy := Sqrt(dx*dx + dy*dy);

	! Calculate angle from X-axis (Floor X+ = 0 deg)
	! WObj X+ will align with weld direction
	angle_deg := ATan2(dy, dx);

	! Create quaternion for Z-axis rotation
	! Rotation around Z-axis by angle_deg
	! q = [cos(a/2), 0, 0, sin(a/2)]
	cos_half := Cos(angle_deg / 2);
	sin_half := Sin(angle_deg / 2);

	! Set WObj properties
	wobj.robhold := FALSE;
	wobj.ufprog := TRUE;
	wobj.ufmec := "";

	! Set uframe (user frame): origin at weld start, rotated around Z
	! WObj X = weld direction, Y = perpendicular, Z = Floor Z (down)
	wobj.uframe.trans := weld_start;
	wobj.uframe.rot.q1 := cos_half;
	wobj.uframe.rot.q2 := 0;
	wobj.uframe.rot.q3 := 0;
	wobj.uframe.rot.q4 := sin_half;

	! Object frame: identity (no additional offset)
	wobj.oframe.trans.x := 0;
	wobj.oframe.trans.y := 0;
	wobj.oframe.trans.z := 0;
	wobj.oframe.rot.q1 := 1;
	wobj.oframe.rot.q2 := 0;
	wobj.oframe.rot.q3 := 0;
	wobj.oframe.rot.q4 := 0;

	TPWrite "[WELD] Created WObj at [" + NumToStr(weld_start.x, 1) + ", "
	                                    + NumToStr(weld_start.y, 1) + ", "
	                                    + NumToStr(weld_start.z, 1) + "]";
	TPWrite "[WELD] WObj X+ direction: " + NumToStr(angle_deg, 2) + " deg from Floor X+";
ENDPROC

! ----------------------------------------
! Move Gantry to Weld Start Position
! ----------------------------------------
! Moves gantry to center line start with correct R-axis angle
! Robot joints are preserved (robots don't move)
PROC MoveGantryToWeldStart()
	VAR jointtarget current_jt;
	VAR jointtarget target_jt;
	VAR pos gantry_target;
	VAR iodev gantry_log;

	! v1.9.12: Detailed logging to diagnose linked motor error
	Open "HOME:/gantry_move_debug.txt", gantry_log \Write;
	Write gantry_log, "MoveGantryToWeldStart (" + TASK1_VERSION + ") " + CDate() + " " + CTime();

	TPWrite "[WELD] Moving gantry to weld start...";

	! Get current joint positions (preserve robot joints)
	current_jt := CJointT();
	Write gantry_log, "CJointT: X1=" + NumToStr(current_jt.extax.eax_a,1) + " X2=" + NumToStr(current_jt.extax.eax_f,1);

	! Calculate gantry target from center start (Floor -> Physical)
	gantry_target := CalcGantryFromFloor(weld_center_start);
	Write gantry_log, "Target: X=" + NumToStr(gantry_target.x,1) + " Y=" + NumToStr(gantry_target.y,1) + " Z=" + NumToStr(gantry_target.z,1);

	! Create target joint (keep robot joints, set gantry position)
	target_jt := current_jt;
	target_jt.extax.eax_a := gantry_target.x;  ! Gantry X1
	target_jt.extax.eax_b := gantry_target.y;  ! Gantry Y
	target_jt.extax.eax_c := gantry_target.z;  ! Gantry Z
	target_jt.extax.eax_d := weld_center_angle; ! Gantry R
	! v1.9.16: Set X2 to same value as X1 (linked motor requirement)
	target_jt.extax.eax_f := gantry_target.x;

	Write gantry_log, "Command: eax_a=" + NumToStr(target_jt.extax.eax_a,1) + " eax_f=" + NumToStr(target_jt.extax.eax_f,1);
	Write gantry_log, "Calling MoveAbsJ...";
	Close gantry_log;

	TPWrite "[WELD] Gantry target: [" + NumToStr(gantry_target.x, 1) + ", "
	                                   + NumToStr(gantry_target.y, 1) + ", "
	                                   + NumToStr(gantry_target.z, 1) + ", R="
	                                   + NumToStr(weld_center_angle, 2) + "]";

	! Move gantry (robot joints stay same)
	MoveAbsJ target_jt, v500, fine, tool0;

	! Update WobjGantry after gantry move
	UpdateGantryWobj;

	TPWrite "[WELD] Gantry at weld start position";
ENDPROC

! ----------------------------------------
! Move Robot1 to Weld Ready Position
! ----------------------------------------
! Moves Robot1 to weld position with 2-step approach
! v1.9.19: Step1 - MoveAbsJ to safe joint position
!          Step2 - MoveJ to wobj0 target position
PROC MoveRobot1ToWeldReady()
	VAR robtarget weld_target;
	VAR jointtarget safe_jt;
	VAR jointtarget current_jt;

	TPWrite "[WELD] Moving Robot1 to weld ready...";

	! Get current gantry position (Robot1 is gantry-configured)
	current_jt := CJointT();

	! Step 1: Move to safe JOINT position first
	! Robot joints: [0, -10, -50, 0, -30, 0]
	safe_jt := current_jt;  ! Keep gantry extax
	safe_jt.robax.rax_1 := 0;
	safe_jt.robax.rax_2 := -10;
	safe_jt.robax.rax_3 := -50;
	safe_jt.robax.rax_4 := 0;
	safe_jt.robax.rax_5 := -30;
	safe_jt.robax.rax_6 := 0;
	TPWrite "[WELD] R1 Step1: MoveAbsJ to safe joints";
	MoveAbsJ safe_jt, v100, fine, tool0;

	! Step 2: Move to WobjGantry target position
	! v1.9.22: Corrected WobjGantry coords from user jog data
	! User jog at X=-4500: wobj0 Y=110.59, Z=2026.89
	! WobjGantry = [0, 111, -73] (Z = 2026.89 - 2100)
	current_jt := CJointT();  ! Re-read after move
	UpdateGantryWobj;
	weld_target.trans.x := 0;
	weld_target.trans.y := 111;
	weld_target.trans.z := -73;
	weld_target.rot.q1 := WELD_R1_ORIENT_Q1;
	weld_target.rot.q2 := WELD_R1_ORIENT_Q2;
	weld_target.rot.q3 := WELD_R1_ORIENT_Q3;
	weld_target.rot.q4 := WELD_R1_ORIENT_Q4;
	weld_target.robconf.cf1 := 0;
	weld_target.robconf.cf4 := 0;
	weld_target.robconf.cf6 := 0;
	weld_target.robconf.cfx := 0;
	weld_target.extax := current_jt.extax;

	TPWrite "[WELD] R1 Step2: MoveJ to WobjGantry [0, 111, -73]";
	MoveJ weld_target, v100, fine, tWeld1\WObj:=WobjGantry;

	TPWrite "[WELD] Robot1 ready at weld position (tWeld1)";
ENDPROC

! ----------------------------------------
! Signal Robot2 to Move to Weld Ready
! ----------------------------------------
! Sets sync flag and waits for Robot2 to be ready
PROC WaitForRobot2WeldReady()
	TPWrite "[WELD] Waiting for Robot2 weld ready...";

	! Signal Robot2 to move to weld position
	t1_weld_start := TRUE;
	t2_weld_ready := FALSE;

	! Wait for Robot2 ready signal
	WHILE NOT t2_weld_ready DO
		WaitTime 0.1;
	ENDWHILE

	TPWrite "[WELD] Robot2 ready!";
ENDPROC

! ----------------------------------------
! Move Gantry Along Center Line (Welding)
! ----------------------------------------
! Moves gantry from start to end of center line
! Robots maintain position in their respective WObj (weld posture maintained)
PROC WeldAlongCenterLine()
	VAR jointtarget current_jt;
	VAR jointtarget end_jt;
	VAR pos gantry_end;

	TPWrite "[WELD] Starting weld along center line...";

	! Get current joint positions
	current_jt := CJointT();

	! Calculate gantry end position (Floor -> Physical)
	gantry_end := CalcGantryFromFloor(weld_center_end);

	! Create end joint target (keep robot joints, change gantry XY)
	end_jt := current_jt;
	end_jt.extax.eax_a := gantry_end.x;  ! Gantry X1
	end_jt.extax.eax_b := gantry_end.y;  ! Gantry Y
	! v1.9.16: Set X2 to same value as X1 (linked motor requirement)
	end_jt.extax.eax_f := gantry_end.x;
	! Z and R stay the same

	TPWrite "[WELD] Welding to [" + NumToStr(gantry_end.x, 1) + ", "
	                               + NumToStr(gantry_end.y, 1) + "]";
	TPWrite "[WELD] Speed: v100";

	! Move gantry along center line (robots stay in weld posture)
	! Speed: v100 (modify ConfigModule WELD_SPEED for future use)
	! v1.9.13: Use tool0 for testing
	MoveAbsJ end_jt, v100, fine, tool0;

	TPWrite "[WELD] Weld complete!";
ENDPROC

! ----------------------------------------
! Execute Complete Weld Sequence
! ----------------------------------------
! Main entry point for weld sequence
! Steps:
!   1. Calculate center line from weld lines
!   2. Move gantry to center start with R-axis aligned
!   3. Create weld WObjs for both robots
!   4. Move robots to weld ready positions
!   5. Execute weld (gantry moves, robots maintain posture)
PROC ExecuteWeldSequence()
	VAR pos r1_start;
	VAR pos r1_end;
	VAR pos r2_start;
	VAR pos r2_end;
	VAR iodev weld_logfile;
	VAR jointtarget current_jt;
	VAR num x1_val;
	VAR num x2_val;
	VAR num sync_distance;

	! v1.9.12: Added file logging for debugging
	Open "HOME:/weld_sequence.txt", weld_logfile \Write;
	Write weld_logfile, "Weld Sequence Log (" + TASK1_VERSION + ") Date=" + CDate() + " Time=" + CTime();

	TPWrite "========================================";
	TPWrite "[WELD] v1.9.12 Weld Sequence Start";
	TPWrite "========================================";

	! Log current gantry position
	current_jt := CJointT();
	x1_val := current_jt.extax.eax_a;
	x2_val := current_jt.extax.eax_f;
	sync_distance := x1_val - x2_val;
	Write weld_logfile, "Start extax: X1=" + NumToStr(x1_val,1) + " X2=" + NumToStr(x2_val,1) + " diff=" + NumToStr(sync_distance,1);

	! v1.9.12: X1/X2 are physically same axis (linked motors)
	! eax_f reported value may be stale software state - not physical difference
	! Solution: Just log the discrepancy, don't try to physically sync
	IF Abs(sync_distance) > 1 THEN
		Write weld_logfile, "NOTE: eax_f state mismatch (software state, not physical)";
		Write weld_logfile, "Physical axis position is eax_a=" + NumToStr(x1_val,1);
	ENDIF

	! Reset sync flags
	t1_weld_start := FALSE;
	t1_weld_done := FALSE;
	t2_weld_ready := FALSE;
	Write weld_logfile, "Step0: Sync flags reset";

	! Read weld line positions from ConfigModule
	r1_start.x := WELD_R1_START_X;
	r1_start.y := WELD_R1_START_Y;
	r1_start.z := WELD_R1_START_Z;
	r1_end.x := WELD_R1_END_X;
	r1_end.y := WELD_R1_END_Y;
	r1_end.z := WELD_R1_END_Z;
	r2_start.x := WELD_R2_START_X;
	r2_start.y := WELD_R2_START_Y;
	r2_start.z := WELD_R2_START_Z;
	r2_end.x := WELD_R2_END_X;
	r2_end.y := WELD_R2_END_Y;
	r2_end.z := WELD_R2_END_Z;

	Write weld_logfile, "R1 Line: [" + NumToStr(r1_start.x, 0) + "," + NumToStr(r1_start.y, 0) + "," + NumToStr(r1_start.z, 0) + "]";
	Write weld_logfile, "R2 Line: [" + NumToStr(r2_start.x, 0) + "," + NumToStr(r2_start.y, 0) + "," + NumToStr(r2_start.z, 0) + "]";
	TPWrite "[WELD] R1 Line: [" + NumToStr(r1_start.x, 0) + "," + NumToStr(r1_start.y, 0) + "," + NumToStr(r1_start.z, 0) + "] -> ["
	                             + NumToStr(r1_end.x, 0) + "," + NumToStr(r1_end.y, 0) + "," + NumToStr(r1_end.z, 0) + "]";
	TPWrite "[WELD] R2 Line: [" + NumToStr(r2_start.x, 0) + "," + NumToStr(r2_start.y, 0) + "," + NumToStr(r2_start.z, 0) + "] -> ["
	                             + NumToStr(r2_end.x, 0) + "," + NumToStr(r2_end.y, 0) + "," + NumToStr(r2_end.z, 0) + "]";

	! Step 1: Calculate center line
	Write weld_logfile, "Step1: CalcCenterLine START";
	CalcCenterLine;
	Write weld_logfile, "Step1: CalcCenterLine DONE";

	! Step 2: Move gantry to weld start position
	Write weld_logfile, "Step2: MoveGantryToWeldStart START";
	MoveGantryToWeldStart;
	current_jt := CJointT();
	Write weld_logfile, "Step2: MoveGantryToWeldStart DONE - X1=" + NumToStr(current_jt.extax.eax_a,1) + " X2=" + NumToStr(current_jt.extax.eax_f,1);

	! Step 3: Create weld WObjs
	Write weld_logfile, "Step3: CreateWeldWobj START";
	CreateWeldWobj r1_start, r1_end, WobjWeldR1;
	CreateWeldWobj r2_start, r2_end, WobjWeldR2;
	Write weld_logfile, "Step3: CreateWeldWobj DONE";

	! Step 4: Move robots to weld ready
	Write weld_logfile, "Step4a: MoveRobot1ToWeldReady START";
	MoveRobot1ToWeldReady;
	Write weld_logfile, "Step4a: MoveRobot1ToWeldReady DONE";

	Write weld_logfile, "Step4b: WaitForRobot2WeldReady START";
	WaitForRobot2WeldReady;
	Write weld_logfile, "Step4b: WaitForRobot2WeldReady DONE";

	! Step 5: Execute weld (gantry moves along center line)
	Write weld_logfile, "Step5: WeldAlongCenterLine START";
	WeldAlongCenterLine;
	Write weld_logfile, "Step5: WeldAlongCenterLine DONE";

	! Signal completion
	t1_weld_done := TRUE;

	! v1.9.20: Step 6 - Return robots to safe position
	Write weld_logfile, "Step6: ReturnToSafePosition START";
	ReturnRobot1ToSafe;
	Write weld_logfile, "Step6: ReturnToSafePosition DONE";

	! v1.9.20: Step 7 - Return gantry to HOME
	Write weld_logfile, "Step7: ReturnGantryToHome START";
	ReturnGantryToHome;
	Write weld_logfile, "Step7: ReturnGantryToHome DONE";

	Write weld_logfile, "Weld Sequence COMPLETE at " + CTime();
	Close weld_logfile;

	TPWrite "========================================";
	TPWrite "[WELD] Weld Sequence Complete!";
	TPWrite "========================================";
ENDPROC

! ----------------------------------------
! Return Robot1 to Safe Position
! ----------------------------------------
! v1.9.20: Move Robot1 to safe joint position after weld
PROC ReturnRobot1ToSafe()
	VAR jointtarget safe_jt;

	TPWrite "[WELD] Returning Robot1 to safe position...";

	! Get current position and move to safe joints
	safe_jt := CJointT();
	safe_jt.robax.rax_1 := 0;
	safe_jt.robax.rax_2 := -10;
	safe_jt.robax.rax_3 := -50;
	safe_jt.robax.rax_4 := 0;
	safe_jt.robax.rax_5 := -30;
	safe_jt.robax.rax_6 := 0;
	MoveAbsJ safe_jt, v100, fine, tool0;

	TPWrite "[WELD] Robot1 at safe position";
ENDPROC

! ----------------------------------------
! Return Gantry to HOME Position
! ----------------------------------------
! v1.9.20: Move gantry to HOME [0,0,0,0] after weld
PROC ReturnGantryToHome()
	VAR jointtarget home_jt;

	TPWrite "[WELD] Returning gantry to HOME...";

	! Get current position
	home_jt := CJointT();

	! Set gantry to HOME [0,0,0,0]
	home_jt.extax.eax_a := 0;  ! X1
	home_jt.extax.eax_b := 0;  ! Y
	home_jt.extax.eax_c := 0;  ! Z
	home_jt.extax.eax_d := 0;  ! R
	home_jt.extax.eax_f := 0;  ! X2 (linked motor)

	MoveAbsJ home_jt, v500, fine, tool0;

	TPWrite "[WELD] Gantry at HOME [0,0,0,0]";
ENDPROC

! ========================================
! Edge-based Weld Sequence Functions (v2.0.0)
! ========================================
! Ported from PlanA Head_MoveControl.mod
! Calculates center line from 4 edge points and determines R-axis angle

! ----------------------------------------
! Calculate Center Line from Edge Points
! ----------------------------------------
! Reads EDGE_START1/2, EDGE_END1/2 from ConfigModule
! Calculates calcPosStart, calcPosEnd as averages
PROC CalcCenterFromEdges()
	TPWrite "[EDGE] Calculating center line from edges...";

	! Calculate center line start (average of edgeStart{1} and edgeStart{2})
	calcPosStart.x := (EDGE_START1_X + EDGE_START2_X) / 2;
	calcPosStart.y := (EDGE_START1_Y + EDGE_START2_Y) / 2;
	calcPosStart.z := (EDGE_START1_Z + EDGE_START2_Z) / 2;

	! Calculate center line end (average of edgeEnd{1} and edgeEnd{2})
	calcPosEnd.x := (EDGE_END1_X + EDGE_END2_X) / 2;
	calcPosEnd.y := (EDGE_END1_Y + EDGE_END2_Y) / 2;
	calcPosEnd.z := (EDGE_END1_Z + EDGE_END2_Z) / 2;

	TPWrite "[EDGE] Edge Start 1: [" + NumToStr(EDGE_START1_X,0) + ","
	        + NumToStr(EDGE_START1_Y,0) + "," + NumToStr(EDGE_START1_Z,0) + "]";
	TPWrite "[EDGE] Edge Start 2: [" + NumToStr(EDGE_START2_X,0) + ","
	        + NumToStr(EDGE_START2_Y,0) + "," + NumToStr(EDGE_START2_Z,0) + "]";
	TPWrite "[EDGE] Edge End 1: [" + NumToStr(EDGE_END1_X,0) + ","
	        + NumToStr(EDGE_END1_Y,0) + "," + NumToStr(EDGE_END1_Z,0) + "]";
	TPWrite "[EDGE] Edge End 2: [" + NumToStr(EDGE_END2_X,0) + ","
	        + NumToStr(EDGE_END2_Y,0) + "," + NumToStr(EDGE_END2_Z,0) + "]";
	TPWrite "[EDGE] Center Start: [" + NumToStr(calcPosStart.x,1) + ","
	        + NumToStr(calcPosStart.y,1) + "," + NumToStr(calcPosStart.z,1) + "]";
	TPWrite "[EDGE] Center End: [" + NumToStr(calcPosEnd.x,1) + ","
	        + NumToStr(calcPosEnd.y,1) + "," + NumToStr(calcPosEnd.z,1) + "]";
ENDPROC

! ----------------------------------------
! Define Weld Line (R-axis Calculation)
! ----------------------------------------
! Ported from PlanA rDefineWobjWeldLine
! Calculates R-axis angle and determines bRobSwap
PROC DefineWeldLine()
	VAR num dx;
	VAR num dy;
	VAR num dz;

	TPWrite "[WELD] Defining weld line...";

	! Calculate direction vector
	dx := calcPosEnd.x - calcPosStart.x;
	dy := calcPosEnd.y - calcPosStart.y;
	dz := calcPosEnd.z - calcPosStart.z;

	! Calculate weld line length
	calcLengthWeldLine := Sqrt(dx*dx + dy*dy + dz*dz);

	! Calculate R-axis angle (ATan2 gives angle from X+ axis in degrees)
	! Floor coordinate: X+ = gantry forward, Y+ = left
	nAngleRzStore := ATan2(dy, dx);

	! Determine robot swap (PlanA logic)
	! If R-axis angle is outside -90 to +90 range, swap robots
	IF (nAngleRzStore < -90 OR nAngleRzStore >= 90) THEN
		bRobSwap := TRUE;
		shared_bRobSwap := TRUE;
		TPWrite "[WELD] bRobSwap = TRUE (R=" + NumToStr(nAngleRzStore,1) + " deg)";
	ELSE
		bRobSwap := FALSE;
		shared_bRobSwap := FALSE;
		TPWrite "[WELD] bRobSwap = FALSE (R=" + NumToStr(nAngleRzStore,1) + " deg)";
	ENDIF

	! Calculate robot offset length
	IF calcLengthWeldLine < 20 THEN
		calcOffsetLengthBuffer := 10;
	ELSE
		calcOffsetLengthBuffer := 10;  ! Default offset for now
	ENDIF

	TPWrite "[WELD] R-axis angle: " + NumToStr(nAngleRzStore, 2) + " deg";
	TPWrite "[WELD] Weld length: " + NumToStr(calcLengthWeldLine, 1) + " mm";
ENDPROC

! ----------------------------------------
! Floor to Physical Coordinate Conversion
! ----------------------------------------
! Ported from PlanA fnCoordToJoint
! Converts Floor coordinates to Physical gantry coordinates
FUNC pos FloorToPhysical(pos floor_pos)
	VAR pos physical;

	! PlanA conversion formula:
	! Physical = HOME +/- (Floor - FloorHome)
	! FloorHome = [9500, 5300, 2100]
	physical.x := HOME_GANTRY_X + (floor_pos.x - 9500);   ! X: addition
	physical.y := HOME_GANTRY_Y - (floor_pos.y - 5300);   ! Y: subtraction (inverted)
	physical.z := HOME_GANTRY_Z - (floor_pos.z - 2100);   ! Z: subtraction (inverted)

	! Apply limits
	IF physical.x < nLimitX_Negative THEN
		physical.x := nLimitX_Negative;
	ENDIF
	IF physical.x > nLimitX_Positive THEN
		physical.x := nLimitX_Positive;
	ENDIF
	IF physical.y < nLimitY_Negative THEN
		physical.y := nLimitY_Negative;
	ENDIF
	IF physical.y > nLimitY_Positive THEN
		physical.y := nLimitY_Positive;
	ENDIF
	IF physical.z < nLimitZ_Negative THEN
		physical.z := nLimitZ_Negative;
	ENDIF
	IF physical.z > nLimitZ_Positive THEN
		physical.z := nLimitZ_Positive;
	ENDIF

	RETURN physical;
ENDFUNC

! ----------------------------------------
! Physical to Floor Coordinate Conversion
! ----------------------------------------
! Inverse of FloorToPhysical
! Converts Physical gantry coordinates to Floor coordinates
FUNC pos PhysicalToFloor(pos physical_pos)
	VAR pos floor;

	! Inverse of FloorToPhysical formula:
	! Floor = FloorHome +/- (Physical - HOME)
	! FloorHome = [9500, 5300, 2100]
	floor.x := 9500 + (physical_pos.x - HOME_GANTRY_X);   ! X: addition
	floor.y := 5300 - (physical_pos.y - HOME_GANTRY_Y);   ! Y: subtraction (inverted)
	floor.z := 2100 - (physical_pos.z - HOME_GANTRY_Z);   ! Z: subtraction (inverted)

	RETURN floor;
ENDFUNC

! ----------------------------------------
! Move Gantry to Weld Position
! ----------------------------------------
! Uses calculated calcPosStart and nAngleRzStore to position gantry
PROC MoveGantryToWeldPosition()
	VAR jointtarget current_jt;
	VAR jointtarget target_jt;
	VAR pos gantry_physical;
	VAR pos gantry_floor;
	VAR num target_r;
	VAR num offset_floor_x;
	VAR num offset_floor_y;

	TPWrite "[WELD] Moving gantry to weld position...";

	! Get current position
	current_jt := CJointT();
	target_jt := current_jt;

	! Debug: Show current X1/X2 position
	TPWrite "[DEBUG] Current X1=" + NumToStr(current_jt.extax.eax_a,1)
	       + " X2=" + NumToStr(current_jt.extax.eax_f,1)
	       + " diff=" + NumToStr(current_jt.extax.eax_a - current_jt.extax.eax_f,1);

	! Check linked motor sync (max_offset = 2mm in MOC.cfg)
	! X1 and X2 MUST move together - cannot sync independently
	IF Abs(current_jt.extax.eax_a - current_jt.extax.eax_f) > 2 THEN
		TPWrite "[ERROR] X1/X2 not synced (diff > 2mm)!";
		TPWrite "[ERROR] Linked motor requires X1=X2 (max offset: 2mm)";
		TPWrite "[ERROR] Please restart controller or manually jog to sync";
		TPWrite "[ERROR] Current diff: " + NumToStr(Abs(current_jt.extax.eax_a - current_jt.extax.eax_f),1) + "mm";
		Stop;
	ENDIF

	! Calculate R-axis first (needed for X/Y offset rotation)
	target_r := HOME_GANTRY_R - nAngleRzStore;

	! Apply R limits first (needed for offset calculation)
	IF target_r < nLimitR_Negative THEN
		target_r := nLimitR_Negative;
	ENDIF
	IF target_r > nLimitR_Positive THEN
		target_r := nLimitR_Positive;
	ENDIF

	! Calculate TCP X/Y offsets rotated by gantry R-axis angle
	! TCP offset is relative to robot base which rotates with gantry R-axis
	! offset_floor = rotation_matrix(target_r) * tcp_offset
	! NOTE: Use target_r (actual gantry rotation), NOT nAngleRzStore (weld line angle)
	! NOTE: RAPID Cos/Sin functions use DEGREES directly (not radians!)
	offset_floor_x := MODE2_TCP_OFFSET_R1_X * Cos(target_r) - MODE2_TCP_OFFSET_R1_Y * Sin(target_r);
	offset_floor_y := MODE2_TCP_OFFSET_R1_X * Sin(target_r) + MODE2_TCP_OFFSET_R1_Y * Cos(target_r);

	! Calculate gantry Floor position (gantry = weld_center - tcp_offset)
	! Gantry must be offset so that TCP reaches the weld center
	gantry_floor := calcPosStart;
	gantry_floor.x := gantry_floor.x - offset_floor_x;
	gantry_floor.y := gantry_floor.y - offset_floor_y;
	! Z offset: Gantry must be ABOVE weld so TCP can reach down
	! Apply in Floor coordinates BEFORE FloorToPhysical to avoid premature limit clamping
	! (v1.9.33 fix: was applied after FloorToPhysical causing 300mm error at low Z)
	gantry_floor.z := gantry_floor.z + WELD_R1_TCP_Z_OFFSET;

	TPWrite "[WELD] TCP offset (Floor): X=" + NumToStr(offset_floor_x,1) + " Y=" + NumToStr(offset_floor_y,1) + " Z=" + NumToStr(WELD_R1_TCP_Z_OFFSET,0);

	! Convert gantry Floor position to Physical coordinates
	! FloorToPhysical applies limits internally
	gantry_physical := FloorToPhysical(gantry_floor);

	! Set gantry target
	target_jt.extax.eax_a := gantry_physical.x;  ! X1
	target_jt.extax.eax_b := gantry_physical.y;  ! Y
	target_jt.extax.eax_c := gantry_physical.z;  ! Z
	target_jt.extax.eax_d := target_r;            ! R
	target_jt.extax.eax_f := gantry_physical.x;  ! X2 = X1 (linked motor)

	TPWrite "[WELD] Gantry target (Physical):";
	TPWrite "  X1=" + NumToStr(gantry_physical.x,1) + " mm";
	TPWrite "  Y=" + NumToStr(gantry_physical.y,1) + " mm";
	TPWrite "  Z=" + NumToStr(gantry_physical.z,1) + " mm";
	TPWrite "  R=" + NumToStr(target_r,1) + " deg";

	! Debug: Show target extax values
	TPWrite "[DEBUG] Target eax_a=" + NumToStr(target_jt.extax.eax_a,1)
	       + " eax_f=" + NumToStr(target_jt.extax.eax_f,1);

	! Move gantry
	TPWrite "[DEBUG] Calling MoveAbsJ...";
	MoveAbsJ target_jt, v500, fine, tool0;

	! Update WobjGantry after movement
	UpdateGantryWobj;

	TPWrite "[WELD] Gantry at weld position";
ENDPROC

! ----------------------------------------
! CheckLinkedMotorSync: Verify X1/X2 are synchronized
! ----------------------------------------
! Linked motor configuration (MOC.cfg):
!   - ELM_X is follower to M1DM3 (max_offset = 2mm)
!   - X1 (eax_a) and X2 (eax_f) must move together
!   - Cannot be synced from RAPID - must restart controller
PROC CheckLinkedMotorSync()
	VAR jointtarget jt;
	VAR num diff;

	jt := CJointT();
	diff := Abs(jt.extax.eax_a - jt.extax.eax_f);

	TPWrite "----------------------------------------";
	TPWrite "[LINKED MOTOR] Status Check";
	TPWrite "  X1 (Master): " + NumToStr(jt.extax.eax_a,1) + " mm";
	TPWrite "  X2 (Follower): " + NumToStr(jt.extax.eax_f,1) + " mm";
	TPWrite "  Difference: " + NumToStr(diff,1) + " mm";
	TPWrite "  Max Allowed: 2 mm (MOC.cfg LINKED_M_PROCESS)";

	IF diff > 2 THEN
		TPWrite "[LINKED MOTOR] ERROR: Out of sync!";
		TPWrite "[LINKED MOTOR] Attempting auto-fix...";
		ForceLinkedMotorSync;
	ELSE
		TPWrite "[LINKED MOTOR] OK - In sync";
		TPWrite "----------------------------------------";
	ENDIF
ENDPROC

! ----------------------------------------
! Force Linked Motor Sync (v1.9.25)
! ----------------------------------------
! Attempts to fix X1/X2 software state mismatch
! by forcing eax_f := eax_a and performing MoveAbsJ
PROC ForceLinkedMotorSync()
	VAR jointtarget current_jt;
	VAR jointtarget sync_jt;
	VAR num x1_val;

	current_jt := CJointT();
	x1_val := current_jt.extax.eax_a;

	TPWrite "[SYNC] Forcing X2 := X1 (" + NumToStr(x1_val,1) + " mm)";

	! Create sync target: keep all values, but force eax_f = eax_a
	sync_jt := current_jt;
	sync_jt.extax.eax_f := x1_val;

	! Try MoveAbsJ with synced values
	TPWrite "[SYNC] Executing MoveAbsJ to sync software state...";

	MoveAbsJ sync_jt, v100, fine, tool0;

	! Verify sync
	current_jt := CJointT();
	IF Abs(current_jt.extax.eax_a - current_jt.extax.eax_f) <= 2 THEN
		TPWrite "[SYNC] SUCCESS - X1/X2 now synced!";
		TPWrite "  X1=" + NumToStr(current_jt.extax.eax_a,1);
		TPWrite "  X2=" + NumToStr(current_jt.extax.eax_f,1);
		TPWrite "----------------------------------------";
	ELSE
		TPWrite "[SYNC] FAILED - Still out of sync";
		TPWrite "[SYNC] Manual restart required";
		TPWrite "----------------------------------------";
		Stop;
	ENDIF
ERROR
	TPWrite "[SYNC] ERROR during MoveAbsJ: " + NumToStr(ERRNO,0);
	TPWrite "[SYNC] Manual restart required";
	TPWrite "----------------------------------------";
	Stop;
ENDPROC

! ----------------------------------------
! Test: Weld Sequence (stub)
! ----------------------------------------
! Placeholder for weld sequence testing
! TODO: Implement actual weld sequence with arc control
PROC TestWeldSequence()
	! PlanC Phase 1: Route "Weld" command to full edge-based weld sequence
	! Same flow as "EdgeWeld" command (Gantry + Robot1 + Robot2 sync + TraceWeldLine)
	TestFullWeldSequence;
ENDPROC

! ----------------------------------------
! Test: Edge to Weld Calculation Only (No Movement)
! ----------------------------------------
! Verifies calculation logic without MoveAbsJ
! Output: HOME:/edge_to_weld_calc.txt
PROC TestEdgeToWeldCalcOnly()
	VAR pos gantry_physical;
	VAR pos gantry_physical_raw;
	VAR pos gantry_floor;
	VAR num target_r;
	VAR iodev logfile;
	VAR num offset_floor_x;
	VAR num offset_floor_y;

	TPWrite "========================================";
	TPWrite "[TEST] Edge to Weld CALC ONLY v1.2";
	TPWrite "[TEST] + X/Y TCP Offset Support";
	TPWrite "[TEST] Log: HOME:/edge_to_weld_calc.txt";
	TPWrite "========================================";

	! Open log file
	Open "HOME:/edge_to_weld_calc.txt", logfile \Write;
	Write logfile, "========================================";
	Write logfile, "Edge to Weld Calculation Log";
	Write logfile, "Date: " + CDate() + " Time: " + CTime();
	Write logfile, "========================================";
	Write logfile, "";

	! Step 1: Calculate center from edges
	TPWrite "[CALC] Step 1: Calculate center line...";
	Write logfile, "[STEP 1] Calculate center from edges";
	CalcCenterFromEdges;

	! Step 2: Define weld line (R-axis calculation)
	TPWrite "[CALC] Step 2: Define weld line (R-axis)...";
	Write logfile, "[STEP 2] Define weld line (R-axis)";
	DefineWeldLine;

	! Step 3: Calculate gantry target (no movement)
	Write logfile, "[STEP 3] Calculate gantry physical target";
	Write logfile, "";

	! Log input parameters
	Write logfile, "--- INPUT: Edge Points (Floor) ---";
	Write logfile, "EDGE_START1: [" + NumToStr(EDGE_START1_X,1) + ", " + NumToStr(EDGE_START1_Y,1) + ", " + NumToStr(EDGE_START1_Z,1) + "]";
	Write logfile, "EDGE_START2: [" + NumToStr(EDGE_START2_X,1) + ", " + NumToStr(EDGE_START2_Y,1) + ", " + NumToStr(EDGE_START2_Z,1) + "]";
	Write logfile, "EDGE_END1:   [" + NumToStr(EDGE_END1_X,1) + ", " + NumToStr(EDGE_END1_Y,1) + ", " + NumToStr(EDGE_END1_Z,1) + "]";
	Write logfile, "EDGE_END2:   [" + NumToStr(EDGE_END2_X,1) + ", " + NumToStr(EDGE_END2_Y,1) + ", " + NumToStr(EDGE_END2_Z,1) + "]";
	Write logfile, "";

	! Log calculation results
	Write logfile, "--- RESULT: Center Line (Floor) ---";
	Write logfile, "calcPosStart: [" + NumToStr(calcPosStart.x,1) + ", " + NumToStr(calcPosStart.y,1) + ", " + NumToStr(calcPosStart.z,1) + "]";
	Write logfile, "calcPosEnd:   [" + NumToStr(calcPosEnd.x,1) + ", " + NumToStr(calcPosEnd.y,1) + ", " + NumToStr(calcPosEnd.z,1) + "]";
	Write logfile, "nAngleRzStore: " + NumToStr(nAngleRzStore,2) + " deg";
	Write logfile, "bRobSwap: " + ValToStr(bRobSwap);
	Write logfile, "calcLengthWeldLine: " + NumToStr(calcLengthWeldLine,1) + " mm";
	Write logfile, "";

	! Calculate R-axis first (needed for X/Y offset rotation)
	target_r := HOME_GANTRY_R - nAngleRzStore;
	IF target_r < nLimitR_Negative THEN target_r := nLimitR_Negative; ENDIF
	IF target_r > nLimitR_Positive THEN target_r := nLimitR_Positive; ENDIF

	! Calculate X/Y TCP offsets rotated by gantry R-axis angle
	Write logfile, "--- X/Y TCP Offset Calculation ---";
	Write logfile, "MODE2_TCP_OFFSET_R1_X: " + NumToStr(MODE2_TCP_OFFSET_R1_X,1) + " mm";
	Write logfile, "MODE2_TCP_OFFSET_R1_Y: " + NumToStr(MODE2_TCP_OFFSET_R1_Y,1) + " mm";
	Write logfile, "nAngleRzStore (weld line): " + NumToStr(nAngleRzStore,2) + " deg";
	Write logfile, "target_r (gantry R): " + NumToStr(target_r,1) + " deg";
	Write logfile, "NOTE: Use target_r for rotation (actual gantry angle)";
	Write logfile, "NOTE: RAPID Cos/Sin use DEGREES directly!";
	offset_floor_x := MODE2_TCP_OFFSET_R1_X * Cos(target_r) - MODE2_TCP_OFFSET_R1_Y * Sin(target_r);
	offset_floor_y := MODE2_TCP_OFFSET_R1_X * Sin(target_r) + MODE2_TCP_OFFSET_R1_Y * Cos(target_r);
	Write logfile, "Rotated TCP offset (Floor):";
	Write logfile, "  offset_floor_x: " + NumToStr(offset_floor_x,1) + " mm";
	Write logfile, "  offset_floor_y: " + NumToStr(offset_floor_y,1) + " mm";
	Write logfile, "";

	! Calculate gantry Floor position (gantry = weld_center - tcp_offset)
	Write logfile, "--- Gantry Floor Position (with X/Y offset) ---";
	Write logfile, "calcPosStart (weld center): [" + NumToStr(calcPosStart.x,1) + ", " + NumToStr(calcPosStart.y,1) + ", " + NumToStr(calcPosStart.z,1) + "]";
	gantry_floor := calcPosStart;
	gantry_floor.x := gantry_floor.x - offset_floor_x;
	gantry_floor.y := gantry_floor.y - offset_floor_y;
	Write logfile, "gantry_floor (after X/Y offset): [" + NumToStr(gantry_floor.x,1) + ", " + NumToStr(gantry_floor.y,1) + ", " + NumToStr(gantry_floor.z,1) + "]";
	Write logfile, "";

	! Calculate FloorToPhysical (raw, before Z offset)
	gantry_physical_raw := FloorToPhysical(gantry_floor);
	Write logfile, "--- FloorToPhysical Conversion ---";
	Write logfile, "Formula: Physical = HOME + (Floor - FloorHome)";
	Write logfile, "  FloorHome = [9500, 5300, 2100]";
	Write logfile, "  HOME_GANTRY = [" + NumToStr(HOME_GANTRY_X,1) + ", " + NumToStr(HOME_GANTRY_Y,1) + ", " + NumToStr(HOME_GANTRY_Z,1) + "]";
	Write logfile, "";
	Write logfile, "gantry_floor: [" + NumToStr(gantry_floor.x,1) + ", " + NumToStr(gantry_floor.y,1) + ", " + NumToStr(gantry_floor.z,1) + "]";
	Write logfile, "gantry_physical_raw: [" + NumToStr(gantry_physical_raw.x,1) + ", " + NumToStr(gantry_physical_raw.y,1) + ", " + NumToStr(gantry_physical_raw.z,1) + "]";
	Write logfile, "";

	! Apply Z offset (SUBTRACT because Physical Z is inverse of Floor Z)
	! Gantry must be ABOVE weld so TCP can reach down
	gantry_physical := gantry_physical_raw;
	Write logfile, "--- Z Offset Calculation (CORRECTED) ---";
	Write logfile, "WELD_R1_TCP_Z_OFFSET: " + NumToStr(WELD_R1_TCP_Z_OFFSET,1) + " mm";
	Write logfile, "gantry_physical.z (before): " + NumToStr(gantry_physical.z,1) + " mm";
	Write logfile, "Formula: Gantry_Z = Raw_Z - TCP_OFFSET (subtract!)";
	gantry_physical.z := gantry_physical.z - WELD_R1_TCP_Z_OFFSET;
	Write logfile, "gantry_physical.z (after offset): " + NumToStr(gantry_physical.z,1) + " mm";
	Write logfile, "LIMIT_Z: [" + NumToStr(nLimitZ_Negative,1) + ", " + NumToStr(nLimitZ_Positive,1) + "] mm";
	IF gantry_physical.z < nLimitZ_Negative THEN
		gantry_physical.z := nLimitZ_Negative;
		Write logfile, "gantry_physical.z (limited to min): " + NumToStr(gantry_physical.z,1) + " mm";
	ENDIF
	IF gantry_physical.z > nLimitZ_Positive THEN
		gantry_physical.z := nLimitZ_Positive;
		Write logfile, "gantry_physical.z (limited to max): " + NumToStr(gantry_physical.z,1) + " mm";
	ENDIF
	Write logfile, "";

	! Log R-axis (already calculated above for X/Y offset rotation)
	Write logfile, "--- R-axis Summary ---";
	Write logfile, "HOME_GANTRY_R: " + NumToStr(HOME_GANTRY_R,1) + " deg";
	Write logfile, "nAngleRzStore: " + NumToStr(nAngleRzStore,2) + " deg";
	Write logfile, "target_r (final, with limits): " + NumToStr(target_r,1) + " deg";
	Write logfile, "LIMIT_R: [" + NumToStr(nLimitR_Negative,1) + ", " + NumToStr(nLimitR_Positive,1) + "] deg";
	Write logfile, "";

	! Final target summary
	Write logfile, "========================================";
	Write logfile, "FINAL GANTRY TARGET (Physical)";
	Write logfile, "========================================";
	Write logfile, "X1 (eax_a): " + NumToStr(gantry_physical.x,1) + " mm";
	Write logfile, "Y  (eax_b): " + NumToStr(gantry_physical.y,1) + " mm";
	Write logfile, "Z  (eax_c): " + NumToStr(gantry_physical.z,1) + " mm";
	Write logfile, "R  (eax_d): " + NumToStr(target_r,1) + " deg";
	Write logfile, "X2 (eax_f): " + NumToStr(gantry_physical.x,1) + " mm (=X1, linked)";
	Write logfile, "========================================";
	Write logfile, "";

	! Close log file
	Close logfile;

	! Display results on TP
	TPWrite "----------------------------------------";
	TPWrite "[INPUT] Edge Points (Floor):";
	TPWrite "  Start1: [" + NumToStr(EDGE_START1_X,0) + "," + NumToStr(EDGE_START1_Y,0) + "," + NumToStr(EDGE_START1_Z,0) + "]";
	TPWrite "  Start2: [" + NumToStr(EDGE_START2_X,0) + "," + NumToStr(EDGE_START2_Y,0) + "," + NumToStr(EDGE_START2_Z,0) + "]";
	TPWrite "  End1: [" + NumToStr(EDGE_END1_X,0) + "," + NumToStr(EDGE_END1_Y,0) + "," + NumToStr(EDGE_END1_Z,0) + "]";
	TPWrite "  End2: [" + NumToStr(EDGE_END2_X,0) + "," + NumToStr(EDGE_END2_Y,0) + "," + NumToStr(EDGE_END2_Z,0) + "]";
	TPWrite "----------------------------------------";
	TPWrite "[RESULT] Center (Floor):";
	TPWrite "  Start: [" + NumToStr(calcPosStart.x,1) + "," + NumToStr(calcPosStart.y,1) + "," + NumToStr(calcPosStart.z,1) + "]";
	TPWrite "  End: [" + NumToStr(calcPosEnd.x,1) + "," + NumToStr(calcPosEnd.y,1) + "," + NumToStr(calcPosEnd.z,1) + "]";
	TPWrite "[RESULT] R-axis: " + NumToStr(nAngleRzStore,2) + " deg";
	TPWrite "[RESULT] bRobSwap: " + ValToStr(bRobSwap);
	TPWrite "[RESULT] Weld Length: " + NumToStr(calcLengthWeldLine,1) + " mm";
	TPWrite "----------------------------------------";
	TPWrite "[OFFSET] TCP X/Y (rotated to Floor):";
	TPWrite "  X: " + NumToStr(offset_floor_x,1) + " mm, Y: " + NumToStr(offset_floor_y,1) + " mm";
	TPWrite "[TARGET] Gantry Physical (with offsets):";
	TPWrite "  X: " + NumToStr(gantry_physical.x,1) + " mm";
	TPWrite "  Y: " + NumToStr(gantry_physical.y,1) + " mm";
	TPWrite "  Z: " + NumToStr(gantry_physical.z,1) + " mm (limit:" + NumToStr(nLimitZ_Positive,0) + ")";
	TPWrite "  R: " + NumToStr(target_r,1) + " deg";
	TPWrite "========================================";
	TPWrite "[TEST] Log saved: HOME:/edge_to_weld_calc.txt";
	TPWrite "========================================";
ENDPROC

! ----------------------------------------
! Test: Edge to Weld Position
! ----------------------------------------
! Complete test of edge input to gantry positioning
PROC TestEdgeToWeld()
	VAR jointtarget actual_jt;
	VAR robtarget actual_tcp_wobj;
	VAR robtarget actual_tcp_gantry;
	VAR pos target_floor;
	VAR pos gantry_physical;
	VAR pos gantry_floor;
	VAR pos calc_tcp_floor;
	VAR num target_r;
	VAR num offset_floor_x;
	VAR num offset_floor_y;
	VAR num err_x;
	VAR num err_y;
	VAR num err_z;
	VAR num err_total;
	VAR iodev logfile;

	TPWrite "========================================";
	TPWrite "[TEST] Edge to Weld Position Test v2.3.0";
	TPWrite "[TEST] + TCP Tracking (Gantry-based)";
	TPWrite "========================================";

	! Step 0: Check linked motor sync (X1/X2)
	TPWrite "[TEST] Step 0: Check linked motor sync...";
	CheckLinkedMotorSync;

	! Step 1: Calculate center from edges
	TPWrite "[TEST] Step 1: Calculate center line...";
	CalcCenterFromEdges;

	! Step 2: Define weld line (R-axis calculation)
	TPWrite "[TEST] Step 2: Define weld line (R-axis)...";
	DefineWeldLine;

	! Step 3: Display calculated results
	TPWrite "----------------------------------------";
	TPWrite "[RESULT] Center Start: [" + NumToStr(calcPosStart.x,1) + ","
	        + NumToStr(calcPosStart.y,1) + "," + NumToStr(calcPosStart.z,1) + "]";
	TPWrite "[RESULT] Center End: [" + NumToStr(calcPosEnd.x,1) + ","
	        + NumToStr(calcPosEnd.y,1) + "," + NumToStr(calcPosEnd.z,1) + "]";
	TPWrite "[RESULT] R-axis: " + NumToStr(nAngleRzStore,2) + " deg";
	TPWrite "[RESULT] bRobSwap: " + ValToStr(bRobSwap);
	TPWrite "[RESULT] Weld Length: " + NumToStr(calcLengthWeldLine,1) + " mm";
	TPWrite "----------------------------------------";

	! Step 4: Move gantry to weld position
	TPWrite "[TEST] Step 4: Move gantry to weld position...";
	MoveGantryToWeldPosition;

	! Step 5: Verify gantry position
	actual_jt := CJointT();
	TPWrite "----------------------------------------";
	TPWrite "[VERIFY] Actual Gantry Position:";
	TPWrite "  X1=" + NumToStr(actual_jt.extax.eax_a,1) + " mm";
	TPWrite "  Y=" + NumToStr(actual_jt.extax.eax_b,1) + " mm";
	TPWrite "  Z=" + NumToStr(actual_jt.extax.eax_c,1) + " mm";
	TPWrite "  R=" + NumToStr(actual_jt.extax.eax_d,1) + " deg";
	TPWrite "  X2=" + NumToStr(actual_jt.extax.eax_f,1) + " mm";

	! Step 6: TCP Tracking Verification (Gantry-based calculation)
	TPWrite "----------------------------------------";
	TPWrite "[TCP] Step 6: TCP Tracking Verification";

	! Target: calcPosStart (weld start position in Floor coordinates)
	target_floor := calcPosStart;
	TPWrite "[TCP] Target Weld (Floor): [" + NumToStr(target_floor.x,1) + ", "
	        + NumToStr(target_floor.y,1) + ", " + NumToStr(target_floor.z,1) + "]";

	! Get actual gantry position and convert to Floor
	gantry_physical.x := actual_jt.extax.eax_a;
	gantry_physical.y := actual_jt.extax.eax_b;
	gantry_physical.z := actual_jt.extax.eax_c;
	target_r := actual_jt.extax.eax_d;
	gantry_floor := PhysicalToFloor(gantry_physical);
	TPWrite "[TCP] Gantry (Floor): [" + NumToStr(gantry_floor.x,1) + ", "
	        + NumToStr(gantry_floor.y,1) + ", " + NumToStr(gantry_floor.z,1) + "]";
	TPWrite "[TCP] Gantry R: " + NumToStr(target_r,1) + " deg";

	! Calculate TCP offset rotated by R-axis angle
	! TCP offset in Floor coords = Rot(R) * [TCP_X, TCP_Y]
	offset_floor_x := MODE2_TCP_OFFSET_R1_X * Cos(target_r) - MODE2_TCP_OFFSET_R1_Y * Sin(target_r);
	offset_floor_y := MODE2_TCP_OFFSET_R1_X * Sin(target_r) + MODE2_TCP_OFFSET_R1_Y * Cos(target_r);
	TPWrite "[TCP] Rotated Offset: [" + NumToStr(offset_floor_x,1) + ", " + NumToStr(offset_floor_y,1) + "]";

	! Calculate expected TCP position in Floor coordinates
	! TCP_floor = Gantry_floor + Rotated_TCP_Offset
	calc_tcp_floor.x := gantry_floor.x + offset_floor_x;
	calc_tcp_floor.y := gantry_floor.y + offset_floor_y;
	calc_tcp_floor.z := gantry_floor.z - WELD_R1_TCP_Z_OFFSET;  ! Z: gantry above, TCP below
	TPWrite "[TCP] Calculated TCP (Floor): [" + NumToStr(calc_tcp_floor.x,1) + ", "
	        + NumToStr(calc_tcp_floor.y,1) + ", " + NumToStr(calc_tcp_floor.z,1) + "]";

	! Calculate tracking error (Target vs Calculated)
	err_x := calc_tcp_floor.x - target_floor.x;
	err_y := calc_tcp_floor.y - target_floor.y;
	err_z := calc_tcp_floor.z - target_floor.z;
	err_total := Sqrt(err_x*err_x + err_y*err_y + err_z*err_z);

	TPWrite "[TCP] Tracking Error (Calc vs Target):";
	TPWrite "  dX=" + NumToStr(err_x,2) + " mm";
	TPWrite "  dY=" + NumToStr(err_y,2) + " mm";
	TPWrite "  dZ=" + NumToStr(err_z,2) + " mm";
	TPWrite "  Total=" + NumToStr(err_total,2) + " mm";

	! Also read actual TCP in WobjGantry for reference
	UpdateGantryWobj;
	actual_tcp_gantry := CRobT(\Tool:=tWeld1\WObj:=WobjGantry);
	TPWrite "[TCP] Actual TCP (WobjGantry): [" + NumToStr(actual_tcp_gantry.trans.x,1) + ", "
	        + NumToStr(actual_tcp_gantry.trans.y,1) + ", " + NumToStr(actual_tcp_gantry.trans.z,1) + "]";

	! Log to file
	Open "HOME:/tcp_tracking.txt", logfile \Write;
	Write logfile, "TCP Tracking Log (v2.3) - " + CDate() + " " + CTime();
	Write logfile, "";
	Write logfile, "--- Target ---";
	Write logfile, "Weld Start (Floor): [" + NumToStr(target_floor.x,1) + ", " + NumToStr(target_floor.y,1) + ", " + NumToStr(target_floor.z,1) + "]";
	Write logfile, "";
	Write logfile, "--- Gantry Position ---";
	Write logfile, "Physical: X=" + NumToStr(gantry_physical.x,1) + " Y=" + NumToStr(gantry_physical.y,1) + " Z=" + NumToStr(gantry_physical.z,1) + " R=" + NumToStr(target_r,1);
	Write logfile, "Floor: [" + NumToStr(gantry_floor.x,1) + ", " + NumToStr(gantry_floor.y,1) + ", " + NumToStr(gantry_floor.z,1) + "]";
	Write logfile, "";
	Write logfile, "--- TCP Offset Calculation ---";
	Write logfile, "TCP Offset (raw): X=" + NumToStr(MODE2_TCP_OFFSET_R1_X,1) + " Y=" + NumToStr(MODE2_TCP_OFFSET_R1_Y,1);
	Write logfile, "TCP Offset (rotated by R=" + NumToStr(target_r,1) + "): [" + NumToStr(offset_floor_x,1) + ", " + NumToStr(offset_floor_y,1) + "]";
	Write logfile, "";
	Write logfile, "--- Calculated TCP Position ---";
	Write logfile, "TCP Floor (calc): [" + NumToStr(calc_tcp_floor.x,1) + ", " + NumToStr(calc_tcp_floor.y,1) + ", " + NumToStr(calc_tcp_floor.z,1) + "]";
	Write logfile, "";
	Write logfile, "--- Tracking Error ---";
	Write logfile, "dX=" + NumToStr(err_x,2) + " dY=" + NumToStr(err_y,2) + " dZ=" + NumToStr(err_z,2) + " Total=" + NumToStr(err_total,2) + " mm";
	Write logfile, "";
	Write logfile, "--- Robot TCP (reference) ---";
	Write logfile, "TCP in WobjGantry: [" + NumToStr(actual_tcp_gantry.trans.x,1) + ", " + NumToStr(actual_tcp_gantry.trans.y,1) + ", " + NumToStr(actual_tcp_gantry.trans.z,1) + "]";
	Close logfile;
	TPWrite "[TCP] Log saved: HOME:/tcp_tracking.txt";

	TPWrite "========================================";
	TPWrite "[TEST] Edge to Weld Position Test Complete";
	TPWrite "========================================";

	! Step 7: Return gantry to HOME
	TPWrite "";
	TPWrite "[TEST] Step 7: Returning to HOME...";
	ReturnGantryToHome;
	TPWrite "[TEST] Gantry returned to HOME [0,0,0,0]";
	TPWrite "========================================";
ENDPROC

! ----------------------------------------
! Test Multi-Angle: Test 0°, 45°, 90°, -45° (v2.4.0)
! ----------------------------------------
! Tests 4 different weld line angles to verify calculation accuracy
! Temporarily changes EDGE points, runs test, and logs results
PROC TestMultiAngle()
	VAR num orig_end1_x;
	VAR num orig_end1_y;
	VAR num orig_end2_x;
	VAR num orig_end2_y;
	VAR num test_angles{4};
	VAR num test_dx{4};
	VAR num test_dy{4};
	VAR num i;
	VAR iodev logfile;
	VAR jointtarget actual_jt;
	VAR pos gantry_physical;
	VAR pos gantry_floor;
	VAR pos target_floor;
	VAR pos calc_tcp_floor;
	VAR num target_r;
	VAR num offset_floor_x;
	VAR num offset_floor_y;
	VAR num err_x;
	VAR num err_y;
	VAR num err_z;
	VAR num err_total;
	VAR robtarget actual_tcp_gantry;

	TPWrite "========================================";
	TPWrite "[MULTI] Multi-Angle Test v2.4.0";
	TPWrite "========================================";

	! Save original edge points
	orig_end1_x := EDGE_END1_X;
	orig_end1_y := EDGE_END1_Y;
	orig_end2_x := EDGE_END2_X;
	orig_end2_y := EDGE_END2_Y;

	! Define test angles (degrees) and corresponding dx, dy for 500mm weld line
	! 0°:   dx=500, dy=0    (horizontal X+)
	! 45°:  dx=354, dy=354  (diagonal)
	! 90°:  dx=0,   dy=500  (vertical Y+)
	! -45°: dx=354, dy=-354 (diagonal X+, Y-)
	test_angles{1} := 0;
	test_dx{1} := 500;
	test_dy{1} := 0;
	test_angles{2} := 45;
	test_dx{2} := 354;
	test_dy{2} := 354;
	test_angles{3} := 90;
	test_dx{3} := 0;
	test_dy{3} := 500;
	test_angles{4} := -45;
	test_dx{4} := 354;
	test_dy{4} := -354;

	! Open log file
	Open "HOME:/multi_angle_test.txt", logfile \Write;
	Write logfile, "Multi-Angle Test Log (v2.4.0) - " + CDate() + " " + CTime();
	Write logfile, "";
	Write logfile, "Start Point (Floor): [" + NumToStr(EDGE_START1_X,0) + ", " + NumToStr(EDGE_START1_Y,0) + ", " + NumToStr(EDGE_START1_Z,0) + "]";
	Write logfile, "";
	Write logfile, "Angle | Expected R | Actual R | Error X | Error Y | Total (mm)";
	Write logfile, "------+-----------+----------+---------+---------+-----------";

	! Run tests for each angle
	FOR i FROM 1 TO 4 DO
		TPWrite "";
		TPWrite "----------------------------------------";
		TPWrite "[MULTI] Test " + NumToStr(i,0) + "/4: Angle = " + NumToStr(test_angles{i},0) + " deg";
		TPWrite "----------------------------------------";

		! Set edge end points for this angle
		! Robot1 side: center + dy/2
		! Robot2 side: center - dy/2
		EDGE_END1_X := EDGE_START1_X + test_dx{i};
		EDGE_END1_Y := EDGE_START1_Y + test_dy{i};
		EDGE_END2_X := EDGE_START2_X + test_dx{i};
		EDGE_END2_Y := EDGE_START2_Y + test_dy{i};

		TPWrite "[MULTI] Edge End: [" + NumToStr(EDGE_END1_X,0) + ", " + NumToStr(EDGE_END1_Y,0) + "]";

		! Calculate and move
		CalcCenterFromEdges;
		DefineWeldLine;

		TPWrite "[MULTI] Calculated R: " + NumToStr(nAngleRzStore,1) + " deg";
		TPWrite "[MULTI] bRobSwap: " + ValToStr(bRobSwap);

		MoveGantryToWeldPosition;

		! Get actual position
		actual_jt := CJointT();
		target_r := actual_jt.extax.eax_d;

		! Calculate TCP tracking
		gantry_physical.x := actual_jt.extax.eax_a;
		gantry_physical.y := actual_jt.extax.eax_b;
		gantry_physical.z := actual_jt.extax.eax_c;
		gantry_floor := PhysicalToFloor(gantry_physical);

		target_floor := calcPosStart;
		offset_floor_x := MODE2_TCP_OFFSET_R1_X * Cos(target_r) - MODE2_TCP_OFFSET_R1_Y * Sin(target_r);
		offset_floor_y := MODE2_TCP_OFFSET_R1_X * Sin(target_r) + MODE2_TCP_OFFSET_R1_Y * Cos(target_r);

		calc_tcp_floor.x := gantry_floor.x + offset_floor_x;
		calc_tcp_floor.y := gantry_floor.y + offset_floor_y;
		calc_tcp_floor.z := gantry_floor.z - WELD_R1_TCP_Z_OFFSET;

		err_x := calc_tcp_floor.x - target_floor.x;
		err_y := calc_tcp_floor.y - target_floor.y;
		err_z := calc_tcp_floor.z - target_floor.z;
		err_total := Sqrt(err_x*err_x + err_y*err_y + err_z*err_z);

		TPWrite "[MULTI] Tracking Error: Total=" + NumToStr(err_total,2) + " mm";

		! Log result
		Write logfile, NumToStr(test_angles{i},0) + " deg | " + NumToStr(test_angles{i},0) + " deg | "
			+ NumToStr(nAngleRzStore,1) + " deg | " + NumToStr(err_x,2) + " | " + NumToStr(err_y,2)
			+ " | " + NumToStr(err_total,2);

		! Wait briefly before next test
		WaitTime 1;
	ENDFOR

	! Restore original edge points
	EDGE_END1_X := orig_end1_x;
	EDGE_END1_Y := orig_end1_y;
	EDGE_END2_X := orig_end2_x;
	EDGE_END2_Y := orig_end2_y;

	! Return to home
	TPWrite "";
	TPWrite "[MULTI] Returning to HOME...";
	ReturnGantryToHome;

	Write logfile, "";
	Write logfile, "Test completed at " + CTime();
	Close logfile;

	TPWrite "";
	TPWrite "========================================";
	TPWrite "[MULTI] Multi-Angle Test Complete";
	TPWrite "[MULTI] Log saved: HOME:/multi_angle_test.txt";
	TPWrite "========================================";
ENDPROC

! ----------------------------------------
! Test Multi-Position: Test various Floor positions (v2.5.0)
! ----------------------------------------
! Tests multiple Floor positions to verify coordinate transformation
! Uses 45° angle for all tests (consistent with TestMultiAngle)
PROC TestMultiPosition()
	VAR num orig_start1_x;
	VAR num orig_start1_y;
	VAR num orig_start1_z;
	VAR num orig_start2_x;
	VAR num orig_start2_y;
	VAR num orig_start2_z;
	VAR num orig_end1_x;
	VAR num orig_end1_y;
	VAR num orig_end2_x;
	VAR num orig_end2_y;
	VAR num test_x{5};
	VAR num test_y{5};
	VAR num test_z{5};
	VAR string test_name{5};
	VAR num i;
	VAR iodev logfile;
	VAR jointtarget actual_jt;
	VAR pos gantry_physical;
	VAR pos gantry_floor;
	VAR pos target_floor;
	VAR pos calc_tcp_floor;
	VAR num target_r;
	VAR num offset_floor_x;
	VAR num offset_floor_y;
	VAR num err_x;
	VAR num err_y;
	VAR num err_z;
	VAR num err_total;

	TPWrite "========================================";
	TPWrite "[POS] Multi-Position Test v2.5.0";
	TPWrite "========================================";

	! Save original edge points
	orig_start1_x := EDGE_START1_X;
	orig_start1_y := EDGE_START1_Y;
	orig_start1_z := EDGE_START1_Z;
	orig_start2_x := EDGE_START2_X;
	orig_start2_y := EDGE_START2_Y;
	orig_start2_z := EDGE_START2_Z;
	orig_end1_x := EDGE_END1_X;
	orig_end1_y := EDGE_END1_Y;
	orig_end2_x := EDGE_END2_X;
	orig_end2_y := EDGE_END2_Y;

	! Define test positions (Floor coordinates)
	! Position 1: Center (current default)
	test_name{1} := "Center";
	test_x{1} := 5000;
	test_y{1} := 5000;
	test_z{1} := 1200;
	! Position 2: Left side (X smaller)
	test_name{2} := "Left";
	test_x{2} := 3000;
	test_y{2} := 5000;
	test_z{2} := 1200;
	! Position 3: Right side (X larger)
	test_name{3} := "Right";
	test_x{3} := 7000;
	test_y{3} := 5000;
	test_z{3} := 1200;
	! Position 4: Low Z (closer to floor)
	test_name{4} := "LowZ";
	test_x{4} := 5000;
	test_y{4} := 5000;
	test_z{4} := 800;
	! Position 5: High Z (higher up)
	test_name{5} := "HighZ";
	test_x{5} := 5000;
	test_y{5} := 5000;
	test_z{5} := 1600;

	! Open log file
	Open "HOME:/multi_position_test.txt", logfile \Write;
	Write logfile, "Multi-Position Test Log (v2.5.0) - " + CDate() + " " + CTime();
	Write logfile, "";
	Write logfile, "All tests use 45 deg weld line angle";
	Write logfile, "";
	Write logfile, "Position | Floor X,Y,Z | Gantry X,Y,Z,R | Error (mm)";
	Write logfile, "---------+-------------+----------------+-----------";

	! Run tests for each position
	FOR i FROM 1 TO 5 DO
		TPWrite "";
		TPWrite "----------------------------------------";
		TPWrite "[POS] Test " + NumToStr(i,0) + "/5: " + test_name{i};
		TPWrite "[POS] Floor: [" + NumToStr(test_x{i},0) + ", " + NumToStr(test_y{i},0) + ", " + NumToStr(test_z{i},0) + "]";
		TPWrite "----------------------------------------";

		! Set edge points for this position (45° angle, 500mm weld line)
		! Robot1 side: center Y + 100
		! Robot2 side: center Y - 100
		EDGE_START1_X := test_x{i};
		EDGE_START1_Y := test_y{i} + 100;
		EDGE_START1_Z := test_z{i};
		EDGE_START2_X := test_x{i};
		EDGE_START2_Y := test_y{i} - 100;
		EDGE_START2_Z := test_z{i};
		! End points: 45° diagonal (dx=354, dy=354)
		EDGE_END1_X := test_x{i} + 354;
		EDGE_END1_Y := test_y{i} + 100 + 354;
		EDGE_END2_X := test_x{i} + 354;
		EDGE_END2_Y := test_y{i} - 100 + 354;

		! Calculate and move
		CalcCenterFromEdges;
		DefineWeldLine;

		TPWrite "[POS] Calculated R: " + NumToStr(nAngleRzStore,1) + " deg";

		MoveGantryToWeldPosition;

		! Get actual position
		actual_jt := CJointT();
		target_r := actual_jt.extax.eax_d;

		! Calculate TCP tracking
		gantry_physical.x := actual_jt.extax.eax_a;
		gantry_physical.y := actual_jt.extax.eax_b;
		gantry_physical.z := actual_jt.extax.eax_c;
		gantry_floor := PhysicalToFloor(gantry_physical);

		target_floor := calcPosStart;
		offset_floor_x := MODE2_TCP_OFFSET_R1_X * Cos(target_r) - MODE2_TCP_OFFSET_R1_Y * Sin(target_r);
		offset_floor_y := MODE2_TCP_OFFSET_R1_X * Sin(target_r) + MODE2_TCP_OFFSET_R1_Y * Cos(target_r);

		calc_tcp_floor.x := gantry_floor.x + offset_floor_x;
		calc_tcp_floor.y := gantry_floor.y + offset_floor_y;
		calc_tcp_floor.z := gantry_floor.z - WELD_R1_TCP_Z_OFFSET;

		err_x := calc_tcp_floor.x - target_floor.x;
		err_y := calc_tcp_floor.y - target_floor.y;
		err_z := calc_tcp_floor.z - target_floor.z;
		err_total := Sqrt(err_x*err_x + err_y*err_y + err_z*err_z);

		TPWrite "[POS] Gantry: X=" + NumToStr(gantry_physical.x,0) + " Y=" + NumToStr(gantry_physical.y,0)
			+ " Z=" + NumToStr(gantry_physical.z,0) + " R=" + NumToStr(target_r,0);
		TPWrite "[POS] Tracking Error: " + NumToStr(err_total,2) + " mm";

		! Log result
		Write logfile, test_name{i} + " | [" + NumToStr(test_x{i},0) + "," + NumToStr(test_y{i},0) + "," + NumToStr(test_z{i},0)
			+ "] | [" + NumToStr(gantry_physical.x,0) + "," + NumToStr(gantry_physical.y,0) + ","
			+ NumToStr(gantry_physical.z,0) + "," + NumToStr(target_r,0) + "] | " + NumToStr(err_total,2);

		! Wait briefly before next test
		WaitTime 1;
	ENDFOR

	! Restore original edge points
	EDGE_START1_X := orig_start1_x;
	EDGE_START1_Y := orig_start1_y;
	EDGE_START1_Z := orig_start1_z;
	EDGE_START2_X := orig_start2_x;
	EDGE_START2_Y := orig_start2_y;
	EDGE_START2_Z := orig_start2_z;
	EDGE_END1_X := orig_end1_x;
	EDGE_END1_Y := orig_end1_y;
	EDGE_END2_X := orig_end2_x;
	EDGE_END2_Y := orig_end2_y;

	! Return to home
	TPWrite "";
	TPWrite "[POS] Returning to HOME...";
	ReturnGantryToHome;

	Write logfile, "";
	Write logfile, "Test completed at " + CTime();
	Close logfile;

	TPWrite "";
	TPWrite "========================================";
	TPWrite "[POS] Multi-Position Test Complete";
	TPWrite "[POS] Log saved: HOME:/multi_position_test.txt";
	TPWrite "========================================";
ENDPROC

! ----------------------------------------
! Move Robot TCP to Weld Position (v2.4.0)
! ----------------------------------------
! Moves Robot1 TCP to the weld start position using WobjGantry
! Call this AFTER gantry is positioned with MoveGantryToWeldPosition
PROC MoveRobotToWeldPosition()
	VAR robtarget weld_target;
	VAR robtarget current_tcp;

	TPWrite "========================================";
	TPWrite "[ROB] Move Robot to Weld Position v2.4.2";
	TPWrite "========================================";

	! Ensure WobjGantry is updated
	UpdateGantryWobj;

	! Get current TCP position - use this as base for weld_target
	current_tcp := CRobT(\Tool:=tWeld1\WObj:=WobjGantry);
	TPWrite "[ROB] Current TCP tWeld1 (WobjGantry): ["
		+ NumToStr(current_tcp.trans.x,1) + ", "
		+ NumToStr(current_tcp.trans.y,1) + ", "
		+ NumToStr(current_tcp.trans.z,1) + "]";

	! Start with current position (preserves robconf, extax, AND orientation)
	weld_target := current_tcp;

	! Define weld target in WobjGantry coordinates
	! X=0 (along weld line)
	! Y=TCP_OFFSET (offset from gantry center)
	! Z=keep current (safer, avoids joint limit issues)
	weld_target.trans.x := 0;
	weld_target.trans.y := MODE2_TCP_OFFSET_R1_Y;
	! weld_target.trans.z := WELD_R1_TCP_Z_OFFSET;  ! Commented: may cause joint limit error
	! Keep current Z for safety (orientation already preserved from current_tcp)

	TPWrite "[ROB] Target TCP (WobjGantry): ["
		+ NumToStr(weld_target.trans.x,1) + ", "
		+ NumToStr(weld_target.trans.y,1) + ", "
		+ NumToStr(weld_target.trans.z,1) + "]";
	TPWrite "[ROB] Note: Keeping current Z and orientation for safety";

	! Move robot to weld position (MoveJ for more forgiving joint interpolation)
	TPWrite "[ROB] Moving robot...";
	MoveJ weld_target, v100, fine, tWeld1 \WObj:=WobjGantry;

	! Verify position
	current_tcp := CRobT(\Tool:=tWeld1\WObj:=WobjGantry);
	TPWrite "[ROB] Final TCP (WobjGantry): ["
		+ NumToStr(current_tcp.trans.x,1) + ", "
		+ NumToStr(current_tcp.trans.y,1) + ", "
		+ NumToStr(current_tcp.trans.z,1) + "]";

	TPWrite "========================================";
	TPWrite "[ROB] Robot move complete";
	TPWrite "========================================";
ERROR
	TPWrite "[ROB] ERROR: " + NumToStr(ERRNO,0);
	TPWrite "[ROB] Robot move failed - check configuration";
	TPWrite "========================================";
ENDPROC

! ----------------------------------------
! Generate Multi-Segment Weld Path (PlanC Phase 1)
! ----------------------------------------
! Converts start/end positions into nMotionStepCount{1} segments
! Fills pWeldPosR1{1..N} and vWeldSpeed{1..N} with linearly interpolated data
!
! Parameters:
!   adjStart/adjEnd: macro-offset-adjusted start/end positions (Floor coords)
!   refTarget: reference robtarget for robconf and extax (from CRobT)
!   nPass: current pass number (for macro torch orientation)
!
! Output: pWeldPosR1{1..nMotionStepCount{1}}, vWeldSpeed{1..nMotionStepCount{1}}
!
! Phase 1: Simple linear interpolation (calcPosStart -> calcPosEnd)
! Phase 4+: Touch sensing correction will modify positions after generation
PROC GenerateWeldPath(pos adjStart, pos adjEnd, robtarget refTarget, num nPass)
	VAR num ratio;
	VAR num i;
	VAR num nSegs;

	nSegs := nMotionStepCount{1};
	TPWrite "[PATH] Generating " + NumToStr(nSegs,0) + " segments"
		+ " len=" + NumToStr(calcLengthWeldLine,1) + "mm";

	FOR i FROM 1 TO nSegs DO
		! Linear interpolation: midpoint of each segment
		! ratio = 0.5/N for first, 1.5/N for second, ..., (N-0.5)/N for last
		ratio := (i - 0.5) / nSegs;

		! Inherit robconf and extax from current robot position
		pWeldPosR1{i} := refTarget;

		! Set interpolated position
		pWeldPosR1{i}.trans.x := adjStart.x + ratio * (adjEnd.x - adjStart.x);
		pWeldPosR1{i}.trans.y := adjStart.y + ratio * (adjEnd.y - adjStart.y);
		pWeldPosR1{i}.trans.z := adjStart.z + ratio * (adjEnd.z - adjStart.z);

		! Set torch orientation based on bRobSwap (PlanA convention)
		IF bRobSwap = FALSE THEN
			pWeldPosR1{i}.rot := [0.5, 0.5, -0.5, 0.5];
			pWeldPosR1{i} := RelTool(pWeldPosR1{i}, 0, 0, 0
				\Rx:=-1*macroStartBuffer1{nPass}.TravelAngle
				\Ry:=-1*macroStartBuffer1{nPass}.WorkingAngle);
		ELSE
			pWeldPosR1{i}.rot := [0.5, -0.5, -0.5, -0.5];
			pWeldPosR1{i} := RelTool(pWeldPosR1{i}, 0, 0, 0
				\Rx:=macroStartBuffer1{nPass}.TravelAngle
				\Ry:=-1*macroStartBuffer1{nPass}.WorkingAngle);
		ENDIF

		! Set weld speed for this segment
		vWeldSpeed{i}.v_tcp := macroStartBuffer1{nPass}.WeldingSpeed;
		vWeldSpeed{i}.v_ori := 500;
		vWeldSpeed{i}.v_leax := 5000;
		vWeldSpeed{i}.v_reax := 1000;
	ENDFOR
ENDPROC

! ----------------------------------------
! Trace Weld Line: Multi-pass weld with Approach/Retract (v2.0.0 PlanC)
! ----------------------------------------
! Moves Robot1 TCP from calcPosStart to calcPosEnd in Floor coordinates
! Uses WobjFloor for correct Floor<->World transformation
! v2.0.0 PlanC Phase 1: Multi-segment path (40-segment capable)
!
! Parameters from ConfigModule:
!   nMotionStepCount{1}: Number of active segments per pass (1-40)
!   macroStartBuffer1/macroEndBuffer1: Torch motion parameters per pass
!   nWeldPassCount: Number of active passes (1-10)
!   WELD_ARC_ENABLED: FALSE=MoveL (simulation), TRUE=ArcL (Phase 3)
!
! Flow: Approach -> MoveL(seg1) -> MoveL(seg2) -> ... -> MoveL(segN) -> Retract
PROC TraceWeldLine()
	VAR robtarget current_floor;
	VAR robtarget approach_pos;
	VAR robtarget retract_pos;
	VAR robtarget actual_floor;
	VAR pos adjStart;
	VAR pos adjEnd;
	VAR num err_x;
	VAR num err_y;
	VAR num err_z;
	VAR num err_total;
	VAR iodev trace_log;
	VAR num pass;
	VAR num seg;
	VAR num nSegs;

	TPWrite "[TRACE] TraceWeldLine v2.1.0 (PlanC Phase 1)";

	! Open own log file
	Open "HOME:/trace_weld_line.txt", trace_log \Write;
	Write trace_log, "TraceWeldLine Log (v2.0.0 PlanC) - " + CDate() + " " + CTime();
	Write trace_log, "Passes=" + NumToStr(nWeldPassCount,0)
		+ " segments=" + NumToStr(nMotionStepCount{1},0)
		+ " arc_enabled=" + ValToStr(WELD_ARC_ENABLED)
		+ " bRobSwap=" + ValToStr(bRobSwap);

	! Get current TCP in Floor coordinates (preserves robconf + extax)
	current_floor := CRobT(\Tool:=tWeld1\WObj:=WobjFloor);
	Write trace_log, "Tool=tWeld1 (design TCP)";
	Write trace_log, "Current Floor TCP=["
		+ NumToStr(current_floor.trans.x,1) + ","
		+ NumToStr(current_floor.trans.y,1) + ","
		+ NumToStr(current_floor.trans.z,1) + "]";

	nSegs := nMotionStepCount{1};

	! === Multi-Pass Loop ===
	FOR pass FROM 1 TO nWeldPassCount DO
		TPWrite "[TRACE] === Pass " + NumToStr(pass,0) + "/" + NumToStr(nWeldPassCount,0)
			+ " (" + NumToStr(nSegs,0) + " segments) ===";
		Write trace_log, "";
		Write trace_log, "=== Pass " + NumToStr(pass,0) + "/" + NumToStr(nWeldPassCount,0)
			+ " (" + NumToStr(nSegs,0) + " segments) ===";

		! --- Calculate macro-adjusted start/end positions ---
		adjStart.x := calcPosStart.x + macroStartBuffer1{pass}.LengthOffset;
		adjStart.y := calcPosStart.y + macroStartBuffer1{pass}.BreadthOffset;
		adjStart.z := calcPosStart.z + macroStartBuffer1{pass}.HeightOffset;

		adjEnd.x := calcPosEnd.x + macroEndBuffer1{pass}.LengthOffset;
		adjEnd.y := calcPosEnd.y + macroEndBuffer1{pass}.BreadthOffset;
		adjEnd.z := calcPosEnd.z + macroEndBuffer1{pass}.HeightOffset;

		Write trace_log, "AdjStart=[" + NumToStr(adjStart.x,1) + ","
			+ NumToStr(adjStart.y,1) + "," + NumToStr(adjStart.z,1) + "]"
			+ " TA=" + NumToStr(macroStartBuffer1{pass}.TravelAngle,1)
			+ " WA=" + NumToStr(macroStartBuffer1{pass}.WorkingAngle,1);
		Write trace_log, "AdjEnd=[" + NumToStr(adjEnd.x,1) + ","
			+ NumToStr(adjEnd.y,1) + "," + NumToStr(adjEnd.z,1) + "]"
			+ " len=" + NumToStr(calcLengthWeldLine,1) + "mm";
		Write trace_log, "Speed=" + NumToStr(macroStartBuffer1{pass}.WeldingSpeed,0)
			+ "mm/s V=" + NumToStr(macroStartBuffer1{pass}.Voltage,1)
			+ "V A=" + NumToStr(macroStartBuffer1{pass}.Current,0)
			+ "A WFS=" + NumToStr(macroStartBuffer1{pass}.FeedingSpeed,0);

		! --- Generate multi-segment path ---
		! Fills pWeldPosR1{1..nSegs} and vWeldSpeed{1..nSegs}
		GenerateWeldPath adjStart, adjEnd, current_floor, pass;
		Write trace_log, "GenerateWeldPath: " + NumToStr(nSegs,0) + " segments generated";
		! Log all generated segment positions for verification
		FOR seg FROM 1 TO nSegs DO
			Write trace_log, "  Seg " + NumToStr(seg,0)
				+ " cmd=[" + NumToStr(pWeldPosR1{seg}.trans.x,1)
				+ "," + NumToStr(pWeldPosR1{seg}.trans.y,1)
				+ "," + NumToStr(pWeldPosR1{seg}.trans.z,1) + "]"
				+ " spd=" + NumToStr(vWeldSpeed{seg}.v_tcp,0) + "mm/s";
		ENDFOR

		! --- Approach: 100mm above first segment along tool Z ---
		approach_pos := RelTool(pWeldPosR1{1}, 0, 0, -100);
		TPWrite "[TRACE] Approach (-100mm)...";
		MoveJ approach_pos, v100, fine, tWeld1 \WObj:=WobjFloor;
		Write trace_log, "Approach (-100mm) OK";

		! --- Move to first segment position ---
		TPWrite "[TRACE] MoveL to seg 1...";
		MoveL pWeldPosR1{1}, v100, fine, tWeld1 \WObj:=WobjFloor;

		! --- Verify start position ---
		actual_floor := CRobT(\Tool:=tWeld1\WObj:=WobjFloor);
		err_x := actual_floor.trans.x - pWeldPosR1{1}.trans.x;
		err_y := actual_floor.trans.y - pWeldPosR1{1}.trans.y;
		err_z := actual_floor.trans.z - pWeldPosR1{1}.trans.z;
		err_total := Sqrt(err_x*err_x + err_y*err_y + err_z*err_z);
		TPWrite "[TRACE] At seg 1 err=" + NumToStr(err_total,2) + "mm";
		Write trace_log, "Seg 1 pos=[" + NumToStr(pWeldPosR1{1}.trans.x,1) + ","
			+ NumToStr(pWeldPosR1{1}.trans.y,1) + ","
			+ NumToStr(pWeldPosR1{1}.trans.z,1) + "] err=" + NumToStr(err_total,2) + "mm";

		! --- Trace weld line: multi-segment MoveL loop ---
		IF WELD_ARC_ENABLED = TRUE THEN
			! Phase 3: ArcLStart -> ArcL -> ArcLEnd (placeholder)
			TPWrite "[TRACE] ARC WELD pass " + NumToStr(pass,0) + " (" + NumToStr(nSegs,0) + " segs)...";
			Write trace_log, "ARC mode: V=" + NumToStr(macroStartBuffer1{pass}.Voltage,1)
				+ "V A=" + NumToStr(macroStartBuffer1{pass}.Current,0)
				+ "A WFS=" + NumToStr(macroStartBuffer1{pass}.FeedingSpeed,0);
			FOR seg FROM 2 TO nSegs DO
				MoveL pWeldPosR1{seg}, vWeldSpeed{seg}, z1, tWeld1 \WObj:=WobjFloor;
				Write trace_log, "ARC seg " + NumToStr(seg,0) + " pos=["
					+ NumToStr(pWeldPosR1{seg}.trans.x,1) + ","
					+ NumToStr(pWeldPosR1{seg}.trans.y,1) + ","
					+ NumToStr(pWeldPosR1{seg}.trans.z,1) + "]";
			ENDFOR
		ELSE
			! Simulation: MoveL only (no arc) - with position verification
			TPWrite "[TRACE] MoveL weld pass " + NumToStr(pass,0) + " (" + NumToStr(nSegs,0) + " segs)...";
			FOR seg FROM 2 TO nSegs DO
				MoveL pWeldPosR1{seg}, vWeldSpeed{seg}, fine, tWeld1 \WObj:=WobjFloor;
				! Verify actual position after each segment (fine zone = stopped)
				actual_floor := CRobT(\Tool:=tWeld1\WObj:=WobjFloor);
				err_x := actual_floor.trans.x - pWeldPosR1{seg}.trans.x;
				err_y := actual_floor.trans.y - pWeldPosR1{seg}.trans.y;
				err_z := actual_floor.trans.z - pWeldPosR1{seg}.trans.z;
				err_total := Sqrt(err_x*err_x + err_y*err_y + err_z*err_z);
				TPWrite "[TRACE] Seg " + NumToStr(seg,0) + "/" + NumToStr(nSegs,0)
					+ " err=" + NumToStr(err_total,2) + "mm";
				Write trace_log, "Seg " + NumToStr(seg,0)
					+ " cmd=[" + NumToStr(pWeldPosR1{seg}.trans.x,1)
					+ "," + NumToStr(pWeldPosR1{seg}.trans.y,1)
					+ "," + NumToStr(pWeldPosR1{seg}.trans.z,1) + "]"
					+ " act=[" + NumToStr(actual_floor.trans.x,1)
					+ "," + NumToStr(actual_floor.trans.y,1)
					+ "," + NumToStr(actual_floor.trans.z,1) + "]"
					+ " err=" + NumToStr(err_total,2) + "mm";
			ENDFOR
		ENDIF

		! --- Final segment: MoveL to fine position ---
		MoveL pWeldPosR1{nSegs}, vWeldSpeed{nSegs}, fine, tWeld1 \WObj:=WobjFloor;

		! --- Verify end position ---
		actual_floor := CRobT(\Tool:=tWeld1\WObj:=WobjFloor);
		err_x := actual_floor.trans.x - pWeldPosR1{nSegs}.trans.x;
		err_y := actual_floor.trans.y - pWeldPosR1{nSegs}.trans.y;
		err_z := actual_floor.trans.z - pWeldPosR1{nSegs}.trans.z;
		err_total := Sqrt(err_x*err_x + err_y*err_y + err_z*err_z);
		TPWrite "[TRACE] At seg " + NumToStr(nSegs,0) + " err=" + NumToStr(err_total,2) + "mm";
		Write trace_log, "Final seg " + NumToStr(nSegs,0) + " err=" + NumToStr(err_total,2) + "mm"
			+ " dX=" + NumToStr(err_x,2) + " dY=" + NumToStr(err_y,2)
			+ " dZ=" + NumToStr(err_z,2);

		! --- Retract: 50mm above last segment along tool Z ---
		retract_pos := RelTool(pWeldPosR1{nSegs}, 0, 0, -50);
		TPWrite "[TRACE] Retract (-50mm)...";
		MoveL retract_pos, v100, fine, tWeld1 \WObj:=WobjFloor;
		Write trace_log, "Retract (-50mm) OK";

		! --- Inter-pass delay ---
		IF pass < nWeldPassCount THEN
			WaitTime 1.0;
			Write trace_log, "Inter-pass delay 1.0s";
		ENDIF
	ENDFOR

	Write trace_log, "";
	Write trace_log, "TraceWeldLine complete at " + CTime();
	Close trace_log;
	TPWrite "[TRACE] TraceWeldLine complete (" + NumToStr(nWeldPassCount,0) + " passes, "
		+ NumToStr(nSegs,0) + " segs/pass)";
ERROR
	TPWrite "[TRACE] ERROR: " + NumToStr(ERRNO,0);
	Write trace_log, "TraceWeldLine ERROR " + NumToStr(ERRNO,0);
	Close trace_log;
ENDPROC

! ----------------------------------------
! Test Edge to Weld with Robot Move (v2.4.0)
! ----------------------------------------
! Combined test: Gantry positioning + Robot TCP movement
PROC TestEdgeToWeldWithRobot()
	VAR jointtarget actual_jt;
	VAR robtarget actual_tcp;

	TPWrite "========================================";
	TPWrite "[TEST] Edge to Weld + Robot Move v2.4.0";
	TPWrite "========================================";

	! Step 1: Check sync
	TPWrite "[TEST] Step 1: Check linked motor sync...";
	CheckLinkedMotorSync;

	! Step 2-3: Calculate
	TPWrite "[TEST] Step 2-3: Calculate weld position...";
	CalcCenterFromEdges;
	DefineWeldLine;

	TPWrite "[RESULT] Weld Start: [" + NumToStr(calcPosStart.x,1) + "," + NumToStr(calcPosStart.y,1) + "]";
	TPWrite "[RESULT] R-axis: " + NumToStr(nAngleRzStore,1) + " deg";

	! Step 4: Move gantry
	TPWrite "[TEST] Step 4: Move gantry...";
	MoveGantryToWeldPosition;

	actual_jt := CJointT();
	TPWrite "[VERIFY] Gantry: X=" + NumToStr(actual_jt.extax.eax_a,1)
		+ " Y=" + NumToStr(actual_jt.extax.eax_b,1)
		+ " Z=" + NumToStr(actual_jt.extax.eax_c,1)
		+ " R=" + NumToStr(actual_jt.extax.eax_d,1);

	! Step 5: Move robot
	TPWrite "[TEST] Step 5: Move robot TCP...";
	MoveRobotToWeldPosition;

	! Step 6: Verify final position
	UpdateGantryWobj;
	actual_tcp := CRobT(\Tool:=tWeld1\WObj:=WobjGantry);
	TPWrite "[VERIFY] Robot TCP tWeld1 (WobjGantry): ["
		+ NumToStr(actual_tcp.trans.x,1) + ", "
		+ NumToStr(actual_tcp.trans.y,1) + ", "
		+ NumToStr(actual_tcp.trans.z,1) + "]";

	! Step 7: Return home
	TPWrite "[TEST] Step 7: Return to HOME...";
	ReturnGantryToHome;

	TPWrite "========================================";
	TPWrite "[TEST] Edge to Weld + Robot Complete";
	TPWrite "========================================";
ENDPROC

! ----------------------------------------
! Test Full Weld Sequence with Robot2 Sync (v1.9.34)
! ----------------------------------------
! Complete weld sequence: Gantry + Robot1 + Robot2 synchronization
! Requires: TASK2 in mode 3 (Weld Sequence) or mode 9 (Test Menu with /sync)
PROC TestFullWeldSequence()
	VAR jointtarget actual_jt;
	VAR robtarget actual_tcp;
	VAR num wait_count;
	VAR num max_wait := 300;  ! 30 seconds timeout (Robot2_WeldReady may take time)
	VAR iodev logfile;

	TPWrite "========================================";
	TPWrite "[FULL] Full Weld Sequence v1.9.38";
	TPWrite "========================================";

	! Open log file
	Open "HOME:/full_weld_sequence.txt", logfile \Write;
	Write logfile, "Full Weld Sequence Log (v1.9.38) - " + CDate() + " " + CTime();
	Write logfile, "";

	! Step 0: Reset sync flags
	TPWrite "[FULL] Step 0: Reset sync flags";
	t1_weld_position_ready := FALSE;
	t1_weld_start := FALSE;
	t1_weld_done := FALSE;
	t2_weld_ready := FALSE;
	shared_bRobSwap := bRobSwap;
	Write logfile, "Sync flags reset, shared_bRobSwap=" + ValToStr(shared_bRobSwap);

	! Step 1: Check linked motor sync
	TPWrite "[FULL] Step 1: Check linked motor sync...";
	CheckLinkedMotorSync;
	Write logfile, "Step 1: Linked motor sync OK";

	! Step 2-3: Calculate weld position
	TPWrite "[FULL] Step 2-3: Calculate weld position...";
	CalcCenterFromEdges;
	DefineWeldLine;
	Write logfile, "Step 2-3: Weld Start=[" + NumToStr(calcPosStart.x,1) + "," + NumToStr(calcPosStart.y,1) + "," + NumToStr(calcPosStart.z,1) + "]";
	Write logfile, "         R-axis=" + NumToStr(nAngleRzStore,1) + " deg, bRobSwap=" + ValToStr(bRobSwap);

	! v1.9.37: Share Robot2 edge positions with TASK2
	shared_calcPosStart_r2.x := EDGE_START2_X;
	shared_calcPosStart_r2.y := EDGE_START2_Y;
	shared_calcPosStart_r2.z := EDGE_START2_Z;
	shared_calcPosEnd_r2.x := EDGE_END2_X;
	shared_calcPosEnd_r2.y := EDGE_END2_Y;
	shared_calcPosEnd_r2.z := EDGE_END2_Z;
	shared_calcLengthWeldLine := calcLengthWeldLine;
	Write logfile, "         Robot2 edge: Start=[" + NumToStr(EDGE_START2_X,0) + "," + NumToStr(EDGE_START2_Y,0) + "," + NumToStr(EDGE_START2_Z,0) + "]"
		+ " End=[" + NumToStr(EDGE_END2_X,0) + "," + NumToStr(EDGE_END2_Y,0) + "," + NumToStr(EDGE_END2_Z,0) + "]";

	TPWrite "[RESULT] Weld Start: [" + NumToStr(calcPosStart.x,1) + "," + NumToStr(calcPosStart.y,1) + "]";
	TPWrite "[RESULT] R-axis: " + NumToStr(nAngleRzStore,1) + " deg, bRobSwap=" + ValToStr(bRobSwap);

	! Step 4: Move gantry
	TPWrite "[FULL] Step 4: Move gantry...";
	MoveGantryToWeldPosition;
	actual_jt := CJointT();
	Write logfile, "Step 4: Gantry X=" + NumToStr(actual_jt.extax.eax_a,1) + " Y=" + NumToStr(actual_jt.extax.eax_b,1)
		+ " Z=" + NumToStr(actual_jt.extax.eax_c,1) + " R=" + NumToStr(actual_jt.extax.eax_d,1);

	! Step 5: Move Robot1
	TPWrite "[FULL] Step 5: Move Robot1 TCP...";
	MoveRobotToWeldPosition;
	UpdateGantryWobj;
	actual_tcp := CRobT(\Tool:=tWeld1\WObj:=WobjGantry);
	Write logfile, "Step 5: Robot1 TCP(tWeld1)=[" + NumToStr(actual_tcp.trans.x,1) + "," + NumToStr(actual_tcp.trans.y,1) + "," + NumToStr(actual_tcp.trans.z,1) + "]";

	! Step 6: Signal TASK2 (Robot2)
	TPWrite "[FULL] Step 6: Signal TASK2 (t1_weld_position_ready)...";
	t1_weld_position_ready := TRUE;
	Write logfile, "Step 6: t1_weld_position_ready=TRUE";

	! Step 7: Wait for Robot2 ready
	TPWrite "[FULL] Step 7: Waiting for Robot2 (t2_weld_ready)...";
	wait_count := 0;
	WHILE NOT t2_weld_ready DO
		WaitTime 0.1;
		wait_count := wait_count + 1;
		IF wait_count > max_wait THEN
			TPWrite "[FULL] WARNING: Robot2 timeout (continue anyway)";
			Write logfile, "Step 7: Robot2 timeout after " + NumToStr(wait_count * 0.1, 1) + "s";
			GOTO skip_r2_wait;
		ENDIF
	ENDWHILE
	TPWrite "[FULL] Robot2 ready!";
	Write logfile, "Step 7: Robot2 ready after " + NumToStr(wait_count * 0.1, 1) + "s";

skip_r2_wait:
	! Step 8: Trace weld line (multi-pass, approach/retract, RelTool orient)
	TPWrite "[FULL] Step 8: Trace weld line (" + NumToStr(nWeldPassCount,0) + " passes)...";
	Write logfile, "Step 8: TraceWeldLine start (passes=" + NumToStr(nWeldPassCount,0)
		+ " speed=" + NumToStr(macroStartBuffer1{1}.WeldingSpeed,0) + "mm/s)";
	t1_weld_start := TRUE;
	TraceWeldLine;
	Write logfile, "Step 8: TraceWeldLine complete";

	! Step 9: Signal weld done
	TPWrite "[FULL] Step 9: Signal weld done...";
	t1_weld_done := TRUE;
	WaitTime 1.0;  ! Let TASK2 process the signal
	Write logfile, "Step 9: t1_weld_done=TRUE";

	! Step 10: Reset flags and return
	TPWrite "[FULL] Step 10: Reset and return home...";
	t1_weld_position_ready := FALSE;
	t1_weld_done := FALSE;
	ReturnGantryToHome;
	Write logfile, "Step 10: Flags reset, returned home";

	! Close log
	Write logfile, "";
	Write logfile, "Full Weld Sequence completed at " + CTime();
	Close logfile;

	TPWrite "========================================";
	TPWrite "[FULL] Full Weld Sequence Complete!";
	TPWrite "========================================";
ENDPROC

! ========================================
! Command Interface (v2.1.0 - PlanA Style)
! ========================================

! ----------------------------------------
! rInit: Initialize command interface
! ----------------------------------------
PROC rInit()
	! Reset command interface
	nCmdInput := 0;
	nCmdOutput := 0;
	nCmdMatch := 0;

	! Reset motion status
	bMotionWorking := FALSE;
	bMotionFinish := TRUE;

	! Reset weld flags
	bRobSwap := FALSE;
	t1_weld_position_ready := FALSE;
	t1_weld_start := FALSE;
	t1_weld_done := FALSE;
	shared_bRobSwap := FALSE;

	TPWrite "[INIT] Command interface ready";
ENDPROC

! ----------------------------------------
! rCheckCmdMatch: Verify command acknowledgement
! ----------------------------------------
! Called after setting nCmdOutput to verify upper system received
PROC rCheckCmdMatch(num CMD)
	nCmdOutput := CMD;
	WaitUntil nCmdMatch = 1 OR nCmdMatch = -1;
	WHILE nCmdMatch <> 1 DO
		IF nCmdMatch = -1 THEN
			TPWrite "[ERROR] Command mismatch: " + NumToStr(CMD, 0);
			Stop;
		ENDIF
	ENDWHILE
	nCmdMatch := 0;
ENDPROC

! ----------------------------------------
! CommandLoop: Main command processing loop
! ----------------------------------------
! Call this from main() to enter PlanA-style command mode
PROC CommandLoop()
	VAR string sDate;
	VAR string sTime;
	VAR jointtarget abs_jt;
	VAR jointtarget inc_jt;

	TPWrite "========================================";
	TPWrite "[CMD] Entering Command Loop (v2.1.0)";
	TPWrite "[CMD] Waiting for nCmdInput...";
	TPWrite "========================================";

	WHILE TRUE DO
		! Wait for command from upper system
		WaitUntil nCmdInput <> 0;

		! Set motion status
		bMotionWorking := TRUE;
		bMotionFinish := FALSE;

		! Log timestamp and command
		sDate := CDate();
		sTime := CTime();
		sDate := StrPart(sDate, 3, 2) + StrPart(sDate, 6, 2) + StrPart(sDate, 9, 2);
		sTime := StrPart(sTime, 1, 2) + StrPart(sTime, 4, 2) + StrPart(sTime, 7, 2);
		TPWrite "[CMD] " + sDate + " " + sTime + " | Command: " + NumToStr(nCmdInput, 0);

		! Process command
		TEST nCmdInput
		CASE CMD_MOVE_TO_WORLDHOME:
			rCheckCmdMatch CMD_MOVE_TO_WORLDHOME;
			TPWrite "[CMD] Move to World Home";
			SetRobot1InitialPosition;

		CASE CMD_MOVE_ABS_GANTRY:
			rCheckCmdMatch CMD_MOVE_ABS_GANTRY;
			TPWrite "[CMD] Move Gantry Absolute";
			TPWrite "  Target: X=" + NumToStr(extGantryPos.eax_a, 1)
			       + " Y=" + NumToStr(extGantryPos.eax_b, 1)
			       + " Z=" + NumToStr(extGantryPos.eax_c, 1)
			       + " R=" + NumToStr(extGantryPos.eax_d, 1);
			abs_jt := CJointT();
			abs_jt.extax.eax_a := extGantryPos.eax_a;
			abs_jt.extax.eax_b := extGantryPos.eax_b;
			abs_jt.extax.eax_c := extGantryPos.eax_c;
			abs_jt.extax.eax_d := extGantryPos.eax_d;
			abs_jt.extax.eax_f := extGantryPos.eax_a;  ! X2 sync
			MoveAbsJ abs_jt, v500, fine, tool0;
			UpdateGantryWobj;

		CASE CMD_MOVE_INC_GANTRY:
			rCheckCmdMatch CMD_MOVE_INC_GANTRY;
			TPWrite "[CMD] Move Gantry Incremental";
			TPWrite "  Delta: X=" + NumToStr(extGantryPos.eax_a, 1)
			       + " Y=" + NumToStr(extGantryPos.eax_b, 1)
			       + " Z=" + NumToStr(extGantryPos.eax_c, 1)
			       + " R=" + NumToStr(extGantryPos.eax_d, 1);
			inc_jt := CJointT();
			inc_jt.extax.eax_a := inc_jt.extax.eax_a + extGantryPos.eax_a;
			inc_jt.extax.eax_b := inc_jt.extax.eax_b + extGantryPos.eax_b;
			inc_jt.extax.eax_c := inc_jt.extax.eax_c + extGantryPos.eax_c;
			inc_jt.extax.eax_d := inc_jt.extax.eax_d + extGantryPos.eax_d;
			inc_jt.extax.eax_f := inc_jt.extax.eax_a;  ! X2 sync
			MoveAbsJ inc_jt, v500, fine, tool0;
			UpdateGantryWobj;

		CASE CMD_WELD:
			rCheckCmdMatch CMD_WELD;
			TPWrite "[CMD] Weld (motion + arc)";
			! TODO: Implement full weld with arc
			TestWeldSequence;

		CASE CMD_WELD_MOTION:
			rCheckCmdMatch CMD_WELD_MOTION;
			TPWrite "[CMD] Weld Motion Only (no arc)";
			TestWeldSequence;

		CASE CMD_EDGE_WELD:
			rCheckCmdMatch CMD_EDGE_WELD;
			TPWrite "[CMD] Edge-based Weld";
			TestEdgeToWeld;

		CASE CMD_WIRE_CUT:
			rCheckCmdMatch CMD_WIRE_CUT;
			TPWrite "[CMD] Wire Cut (both robots)";
		CASE CMD_TEST_MENU:
			rCheckCmdMatch CMD_TEST_MENU;
			TPWrite "[CMD] Test Menu";
			TestMenu;

		CASE CMD_TEST_SINGLE:
			rCheckCmdMatch CMD_TEST_SINGLE;
			TPWrite "[CMD] Test Single Position";
			TestGantryFloorCoordinates;

		CASE CMD_TEST_ROTATION:
			rCheckCmdMatch CMD_TEST_ROTATION;
			TPWrite "[CMD] Test R-axis Rotation";
			TestGantryRotation;

		CASE CMD_TEST_MODE2:
			rCheckCmdMatch CMD_TEST_MODE2;
			TPWrite "[CMD] Test Mode2";
			TestGantryMode2;

		DEFAULT:
			TPWrite "[ERROR] Unknown command: " + NumToStr(nCmdInput, 0);
			rCheckCmdMatch 999;

		ENDTEST

		! Reset motion status
		bMotionWorking := FALSE;
		bMotionFinish := TRUE;

		! Clear command output and wait for input reset
		nCmdOutput := 0;
		WaitUntil nCmdInput = 0;

		TPWrite "[CMD] Ready for next command";
	ENDWHILE
ENDPROC

! ========================================
! ExecMoveJgJ: Execute MoveJgJ from T_Head (v1.9.47)
! ========================================
! PlanB: Move gantry to target, keep robot at current joints
! T_Head jRob1.robax is calculated for tool0 - not compatible with tWeld1 HOME
! Robot maintains current posture while gantry moves
! v1.9.47: Split large moves into segments (ABB 50050 workaround)
PROC ExecMoveJgJ()
	VAR jointtarget jMoveTarget;
	VAR jointtarget jCurrent;
	VAR jointtarget jStep;
	VAR iodev dbg_log;
	VAR num nSegments;
	VAR num nMaxSegs;
	VAR num da;
	VAR num db;
	VAR num dc;
	VAR num dd;
	VAR num i;

	Open "HOME:/debug_movejgj.txt", dbg_log \Write;
	Write dbg_log, "ExecMoveJgJ (v1.9.47 segmented) " + CDate() + " " + CTime();

	! Read current position
	jCurrent := CJointT();
	Write dbg_log, "Current extax: a=" + NumToStr(jCurrent.extax.eax_a,1) + " b=" + NumToStr(jCurrent.extax.eax_b,1) + " c=" + NumToStr(jCurrent.extax.eax_c,1) + " d=" + NumToStr(jCurrent.extax.eax_d,1) + " f=" + NumToStr(jCurrent.extax.eax_f,1);

	! Build final target: keep robot joints, update gantry axes
	jMoveTarget := jCurrent;
	IF jGantry.extax.eax_a < 9E+08 THEN
		jMoveTarget.extax.eax_a := jGantry.extax.eax_a;
	ENDIF
	IF jGantry.extax.eax_b < 9E+08 THEN
		jMoveTarget.extax.eax_b := jGantry.extax.eax_b;
	ENDIF
	IF jGantry.extax.eax_c < 9E+08 THEN
		jMoveTarget.extax.eax_c := jGantry.extax.eax_c;
	ENDIF
	IF jGantry.extax.eax_d < 9E+08 THEN
		jMoveTarget.extax.eax_d := jGantry.extax.eax_d;
	ENDIF
	jMoveTarget.extax.eax_f := jMoveTarget.extax.eax_a;

	Write dbg_log, "Target extax: a=" + NumToStr(jMoveTarget.extax.eax_a,1) + " b=" + NumToStr(jMoveTarget.extax.eax_b,1) + " c=" + NumToStr(jMoveTarget.extax.eax_c,1) + " d=" + NumToStr(jMoveTarget.extax.eax_d,1) + " f=" + NumToStr(jMoveTarget.extax.eax_f,1);

	! Calculate movement per axis
	da := Abs(jMoveTarget.extax.eax_a - jCurrent.extax.eax_a);
	db := Abs(jMoveTarget.extax.eax_b - jCurrent.extax.eax_b);
	dc := Abs(jMoveTarget.extax.eax_c - jCurrent.extax.eax_c);
	dd := Abs(jMoveTarget.extax.eax_d - jCurrent.extax.eax_d);

	! Determine segments: linear max 2000mm, rotational max 45deg per segment
	nSegments := 1;
	nMaxSegs := Trunc(da / 2000) + 1;
	IF nMaxSegs > nSegments nSegments := nMaxSegs;
	nMaxSegs := Trunc(db / 2000) + 1;
	IF nMaxSegs > nSegments nSegments := nMaxSegs;
	nMaxSegs := Trunc(dc / 2000) + 1;
	IF nMaxSegs > nSegments nSegments := nMaxSegs;
	nMaxSegs := Trunc(dd / 45) + 1;
	IF nMaxSegs > nSegments nSegments := nMaxSegs;

	Write dbg_log, "Delta: a=" + NumToStr(da,0) + " b=" + NumToStr(db,0) + " c=" + NumToStr(dc,0) + " d=" + NumToStr(dd,0) + " segs=" + NumToStr(nSegments,0);
	Close dbg_log;

	IF nSegments <= 1 THEN
		! Single move - small distance
		TPWrite "[R1] MoveJgJ: single move";
		MoveAbsJ jMoveTarget, v100, fine, tool0;
	ELSE
		! Segmented move - split into steps
		TPWrite "[R1] MoveJgJ: " + NumToStr(nSegments,0) + " segments";
		FOR i FROM 1 TO nSegments DO
			jStep := jCurrent;
			! Linear interpolation for each axis
			jStep.extax.eax_a := jCurrent.extax.eax_a + (jMoveTarget.extax.eax_a - jCurrent.extax.eax_a) * i / nSegments;
			jStep.extax.eax_b := jCurrent.extax.eax_b + (jMoveTarget.extax.eax_b - jCurrent.extax.eax_b) * i / nSegments;
			jStep.extax.eax_c := jCurrent.extax.eax_c + (jMoveTarget.extax.eax_c - jCurrent.extax.eax_c) * i / nSegments;
			jStep.extax.eax_d := jCurrent.extax.eax_d + (jMoveTarget.extax.eax_d - jCurrent.extax.eax_d) * i / nSegments;
			jStep.extax.eax_f := jStep.extax.eax_a;
			IF i < nSegments THEN
				MoveAbsJ jStep, v100, z50, tool0;
			ELSE
				MoveAbsJ jStep, v100, fine, tool0;
			ENDIF
		ENDFOR
	ENDIF

	TPWrite "[R1] MoveJgJ: MoveAbsJ done";

	Open "HOME:/debug_movejgj.txt", dbg_log \Append;
	Write dbg_log, "MoveAbsJ completed (segs=" + NumToStr(nSegments,0) + ") " + CTime();
	Close dbg_log;

	UpdateGantryWobj;

	Open "HOME:/debug_movejgj.txt", dbg_log \Append;
	Write dbg_log, "UpdateGantryWobj done " + CTime();
	Write dbg_log, "ExecMoveJgJ completed OK";
	Close dbg_log;
	RETURN;

ERROR
	Open "HOME:/debug_movejgj.txt", dbg_log \Append;
	Write dbg_log, "ERROR in ExecMoveJgJ! ERRNO=" + NumToStr(ERRNO,0) + " at " + CTime();
	Close dbg_log;
	TPWrite "[R1] MoveJgJ ERROR: ERRNO=" + NumToStr(ERRNO,0);
	STOP;
ENDPROC

! ========================================
! ExecMovePgJ: Execute MovePgJ from T_Head (v1.9.41)
! ========================================
! PlanB: MoveJ to robtarget pRob1 set by T_Head
PROC ExecMovePgJ()
	MoveJ pRob1, vSync, zSync, tWeld1;
	UpdateGantryWobj;
ENDPROC

! ========================================
! ExecMovePgL: Execute MovePgL from T_Head (v1.9.41)
! ========================================
! PlanB: MoveL to robtarget pRob1 set by T_Head
PROC ExecMovePgL()
	MoveL pRob1, vSync, zSync, tWeld1;
	UpdateGantryWobj;
ENDPROC

! ========================================
! MoveAbsGantryFromExtPos: Absolute gantry move (v1.9.39)
! ========================================
! Extracted from CommandLoop CASE CMD_MOVE_ABS_GANTRY for reuse
PROC MoveAbsGantryFromExtPos()
	VAR jointtarget abs_jt;
	TPWrite "[R1] MoveAbsGantry X=" + NumToStr(extGantryPos.eax_a, 1)
	       + " Y=" + NumToStr(extGantryPos.eax_b, 1)
	       + " Z=" + NumToStr(extGantryPos.eax_c, 1)
	       + " R=" + NumToStr(extGantryPos.eax_d, 1);
	abs_jt := CJointT();
	abs_jt.extax.eax_a := extGantryPos.eax_a;
	abs_jt.extax.eax_b := extGantryPos.eax_b;
	abs_jt.extax.eax_c := extGantryPos.eax_c;
	abs_jt.extax.eax_d := extGantryPos.eax_d;
	abs_jt.extax.eax_f := extGantryPos.eax_a;  ! X2 sync
	MoveAbsJ abs_jt, v500, fine, tool0;
	UpdateGantryWobj;
ENDPROC

! ========================================
! MoveIncGantryFromExtPos: Incremental gantry move (v1.9.39)
! ========================================
! Extracted from CommandLoop CASE CMD_MOVE_INC_GANTRY for reuse
PROC MoveIncGantryFromExtPos()
	VAR jointtarget inc_jt;
	TPWrite "[R1] MoveIncGantry dX=" + NumToStr(extGantryPos.eax_a, 1)
	       + " dY=" + NumToStr(extGantryPos.eax_b, 1)
	       + " dZ=" + NumToStr(extGantryPos.eax_c, 1)
	       + " dR=" + NumToStr(extGantryPos.eax_d, 1);
	inc_jt := CJointT();
	inc_jt.extax.eax_a := inc_jt.extax.eax_a + extGantryPos.eax_a;
	inc_jt.extax.eax_b := inc_jt.extax.eax_b + extGantryPos.eax_b;
	inc_jt.extax.eax_c := inc_jt.extax.eax_c + extGantryPos.eax_c;
	inc_jt.extax.eax_d := inc_jt.extax.eax_d + extGantryPos.eax_d;
	inc_jt.extax.eax_f := inc_jt.extax.eax_a;  ! X2 sync
	MoveAbsJ inc_jt, v500, fine, tool0;
	UpdateGantryWobj;
ENDPROC

! ========================================
! rT_ROB1check: Safety position check before MoveToZHome
! ========================================
! If Robot1 is near weld line (Y<100, Z<200), move to safe Y position
PROC rT_ROB1check()
	VAR robtarget pTemp;
	pTemp := CRobT(\TaskName:="T_ROB1"\Tool:=tWeld1\WObj:=wobjWeldLine1);
	IF Abs(pTemp.trans.Y) < 100 AND Abs(pTemp.trans.Z) < 200 THEN
		IF pTemp.trans.Y > 0 THEN
			pTemp.trans.y := 130;
			MoveL pTemp, v100, fine, tWeld1\WObj:=wobjWeldLine1;
		ENDIF
		IF pTemp.trans.Y < 0 THEN
			pTemp.trans.y := -130;
			MoveL pTemp, v100, fine, tWeld1\WObj:=wobjWeldLine1;
		ENDIF
	ENDIF
ENDPROC

! ========================================
! Rob1_CommandListener: T_Head stCommand handler (v1.9.43)
! ========================================
! Responds to stCommand from T_Head task
! Protocol: "Ready" -> receive command -> execute -> "Ack" -> wait clear -> "Ready"
PROC Rob1_CommandListener()
	VAR iodev head_log;
	Open "HOME:/head_r1_listener.txt", head_log \Write;
	Write head_log, "Rob1 CommandListener (v1.9.43) - " + CDate() + " " + CTime();

	TPWrite "[R1] CommandListener started, entering Ready state";

	WHILE TRUE DO
		stReact{1} := "Ready";
		stReact{3} := "Ready";
		Write head_log, "Status: Ready, waiting stCommand...";
		WaitUntil stCommand <> "";
		Write head_log, "Received: " + stCommand;
		TPWrite "[R1] stCommand=" + stCommand;

		TEST stCommand
			CASE "MoveJgJ":
				stReact{1} := "";
				stReact{3} := "";
				ExecMoveJgJ;
				stReact{1} := "Ack";
				stReact{3} := "Ack";
				Write head_log, "MoveJgJ done";
				WaitUntil stCommand = "";

			CASE "MovePgJ":
				stReact{1} := "";
				stReact{3} := "";
				ExecMovePgJ;
				stReact{1} := "Ack";
				stReact{3} := "Ack";
				Write head_log, "MovePgJ done";
				WaitUntil stCommand = "";

			CASE "MovePgL":
				stReact{1} := "";
				stReact{3} := "";
				ExecMovePgL;
				stReact{1} := "Ack";
				stReact{3} := "Ack";
				Write head_log, "MovePgL done";
				WaitUntil stCommand = "";

			CASE "MoveHome":
				stReact{1} := "";
				stReact{3} := "";
				SetRobot1InitialPosition;
				stReact{1} := "Ack";
				stReact{3} := "Ack";
				Write head_log, "MoveHome done";
				WaitUntil stCommand = "";

			CASE "MoveMeasurementHome":
				stReact{1} := "";
				stReact{3} := "";
				! Stub - measurement home position
				stReact{1} := "Ack";
				stReact{3} := "Ack";
				Write head_log, "MoveMeasurementHome done (stub)";
				WaitUntil stCommand = "";

			CASE "MoveAbsGantry":
				stReact{1} := "";
				stReact{3} := "";
				MoveAbsGantryFromExtPos;
				stReact{1} := "Ack";
				stReact{3} := "Ack";
				Write head_log, "MoveAbsGantry done";
				WaitUntil stCommand = "";

			CASE "MoveIncGantry":
				stReact{1} := "";
				stReact{3} := "";
				MoveIncGantryFromExtPos;
				stReact{1} := "Ack";
				stReact{3} := "Ack";
				Write head_log, "MoveIncGantry done";
				WaitUntil stCommand = "";

			CASE "EdgeWeld":
				stReact{1} := "";
				stReact{3} := "";
				Write head_log, "EdgeWeld: calling TestFullWeldSequence";
				TestFullWeldSequence;
				stReact{1} := "Ack";
				stReact{3} := "Ack";
				Write head_log, "EdgeWeld done";
				WaitUntil stCommand = "";

			CASE "Weld", "WeldMotion":
				stReact{1} := "";
				stReact{3} := "";
				Write head_log, "Weld/WeldMotion: calling TestWeldSequence";
				TestWeldSequence;
				stReact{1} := "Ack";
				stReact{3} := "Ack";
				Write head_log, "Weld done";
				WaitUntil stCommand = "";

			CASE "WeldCorr", "WeldMotionCorr":
				stReact{1} := "";
				stReact{3} := "";
				Write head_log, "WeldCorr: calling TestWeldSequence (with corr)";
				TestWeldSequence;
				stReact{1} := "Ack";
				stReact{3} := "Ack";
				Write head_log, "WeldCorr done";
				WaitUntil stCommand = "";

			CASE "WireCut", "Rob1WireCut":
				stReact{1} := "";
				stReact{3} := "";
				! Stub - wire cut
				stReact{1} := "Ack";
				stReact{3} := "Ack";
				Write head_log, "WireCut done (stub)";
				WaitUntil stCommand = "";

			CASE "TestMenu":
				stReact{1} := "";
				stReact{3} := "";
				TestMenu;
				stReact{1} := "Ack";
				stReact{3} := "Ack";
				Write head_log, "TestMenu done";
				WaitUntil stCommand = "";

			CASE "TestSingle":
				stReact{1} := "";
				stReact{3} := "";
				TestGantryFloorCoordinates;
				stReact{1} := "Ack";
				stReact{3} := "Ack";
				Write head_log, "TestSingle done";
				WaitUntil stCommand = "";

			CASE "TestRotation":
				stReact{1} := "";
				stReact{3} := "";
				TestGantryRotation;
				stReact{1} := "Ack";
				stReact{3} := "Ack";
				Write head_log, "TestRotation done";
				WaitUntil stCommand = "";

			CASE "TestMode2":
				stReact{1} := "";
				stReact{3} := "";
				TestGantryMode2;
				stReact{1} := "Ack";
				stReact{3} := "Ack";
				Write head_log, "TestMode2 done";
				WaitUntil stCommand = "";

			CASE "checkpos":
				stReact{1} := "";
				stReact{3} := "";
				rT_ROB1check;
				stReact{1} := "checkposok";
				stReact{3} := "checkposok";
				Write head_log, "checkpos done";
				WaitUntil stCommand = "";

			DEFAULT:
				Write head_log, "Unknown command: " + stCommand;
				TPWrite "[R1] Unknown stCommand: " + stCommand;
				stReact{1} := "Ack";
				stReact{3} := "Ack";
				WaitUntil stCommand = "";
		ENDTEST
	ENDWHILE
ERROR
	Write head_log, "ERROR " + NumToStr(ERRNO, 0);
	Close head_log;
ENDPROC

ENDMODULE

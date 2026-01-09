MODULE MainModule
	!========================================
	! TASK1 (Robot1) - MainModule
	! Version History
	!========================================
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
    PERS tooldata tWeld1:=[TRUE,[[319.938,-6.311,330],[0.92587,0.003729,0.377818,-0.009129]],[3.1,[-71.4,3.8,173.2],[1,0,0,0],0.055,0.049,0.005]];
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
PERS num mode2_r2_offset_x := 0;
PERS num mode2_r2_offset_y := -100;
PERS num mode2_r2_offset_z := 0;

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

	PROC main()
		VAR iodev main_logfile;
		VAR iodev configfile;
		VAR num wait_counter;
		VAR num max_wait_cycles;
		VAR num test_mode;
		VAR string line;
		VAR string value_str;
		VAR bool found_value;

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

		! Open main process log
		Open "HOME:/main_process.txt", main_logfile \Write;
		Write main_logfile, "Main Process Log (" + TASK1_VERSION + ") Date=" + CDate() + " Time=" + CTime();

		! Step 1: Initialize Robot1 and Gantry
		TPWrite "========================================";
		TPWrite "MAIN: Starting Robot1 initialization...";
		TPWrite "========================================";
		SetRobot1InitialPosition;
		TPWrite "MAIN: Robot1 initialization completed";
		Write main_logfile, "Step1 done (Robot1 init)";

		! Wait for TASK2 (Robot2) initialization to complete using synchronization flag
		! This replaces the previous fixed WaitTime 10.0 approach
		TPWrite "MAIN: Waiting for Robot2 initialization (checking flag)...";
		wait_counter := 0;
		max_wait_cycles := 200;  ! 20 seconds max (200 * 0.1s)
		WHILE robot2_init_complete = FALSE AND wait_counter < max_wait_cycles DO
			WaitTime 0.1;  ! Check every 100ms
			wait_counter := wait_counter + 1;
		ENDWHILE

		IF robot2_init_complete = TRUE THEN
			TPWrite "MAIN: Robot2 initialization confirmed (flag = TRUE)";
			Write main_logfile, "WaitRobot2 ok " + NumToStr(wait_counter * 0.1, 2) + " s";
		ELSE
			TPWrite "MAIN: WARNING - Robot2 initialization timeout!";
			Write main_logfile, "WaitRobot2 timeout " + NumToStr(max_wait_cycles * 0.1, 1) + " s";
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
			! Custom multi-position test (Phase 3)
			TPWrite "MAIN: Custom Multi-Position Test - Not implemented yet";
			Write main_logfile, "Step2 mode=3 type=NotImplemented";
			TPWrite "ERROR: TEST_MODE=3 not implemented";
			TPWrite "Please use TEST_MODE=0 or 1";
		ELSE
			TPWrite "ERROR: Invalid TEST_MODE=" + NumToStr(test_mode,0);
			Write main_logfile, "ERROR: Invalid TEST_MODE=" + NumToStr(test_mode,0);
			TPWrite "Valid values: 0 (Single), 1 (R-axis)";
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
		robot1_floor_pos_t1 := CRobT(\Tool:=tool0\WObj:=WobjFloor);
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
		base_floor_x := gantry_floor_x + (488 * Sin(total_r_deg));
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

		! Read Robot2 TCP position in wobj0 (from TASK2)
		robot2_tcp_wobj0 := CRobT(\TaskName:="T_ROB2"\Tool:=tool0\WObj:=wobj0);

		! Calculate Robot2 TCP Floor position with rotation transformation
		! CRITICAL: Robot2 wobj0 rotates with gantry R-axis!
		! Apply rotation transformation matrix to convert wobj0 coords to Floor coords
		! Rotation matrix for R-axis (total_r_deg = r_deg):
		!   [cos(T)  -sin(T)]   [x_wobj0]   [x_floor]
		!   [sin(T)   cos(T)] x [y_wobj0] = [y_floor]
		floor_x_offset := robot2_tcp_wobj0.trans.x * Cos(total_r_deg) - robot2_tcp_wobj0.trans.y * Sin(total_r_deg);
		floor_y_offset := robot2_tcp_wobj0.trans.x * Sin(total_r_deg) + robot2_tcp_wobj0.trans.y * Cos(total_r_deg);
		floor_z_offset := robot2_tcp_wobj0.trans.z;  ! Z-axis not affected by R-axis rotation

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
		VAR num error_x;
		VAR num error_y;
		VAR num iteration;
		VAR num max_iterations;
		VAR num tolerance;

		! Open log file (1-line summary)
		Open "HOME:/robot1_init_position.txt", logfile \Write;
		Write logfile, "Robot1 Init (" + TASK1_VERSION + ") Date=" + CDate() + " Time=" + CTime();

		TPWrite "Robot1 init: start";
		sync_pos := CJointT();

		x1_target := sync_pos.extax.eax_a;
		x2_current := sync_pos.extax.eax_f;
		distance := x1_target - x2_current;

		! If distance > 100mm, use progressive approach (25%, 50%, 75%, 100%)
		IF Abs(distance) > 100 THEN
			TPWrite "Large X1-X2 difference (" + NumToStr(Abs(distance),0) + "mm) - progressive sync";
			sync_pos.extax.eax_f := x2_current + distance * 0.25;
			MoveAbsJ sync_pos, v10, fine, tool0;
			sync_pos.extax.eax_f := x2_current + distance * 0.50;
			MoveAbsJ sync_pos, v10, fine, tool0;
			sync_pos.extax.eax_f := x2_current + distance * 0.75;
			MoveAbsJ sync_pos, v10, fine, tool0;
		ENDIF

		! Final synchronization
		sync_pos.extax.eax_f := x1_target;  ! X2 = X1
		MoveAbsJ sync_pos, v10, fine, tool0;

		! Step 1: Move Robot1 joints to intermediate position (avoid configuration issue)
		initial_joint := CJointT();
		! Keep synchronized gantry position
		initial_joint.extax.eax_f := initial_joint.extax.eax_a;
		! Robot1 joint angles: [0, -2.58, -11.88, 0, 14.47, 0]
		initial_joint.robax.rax_1 := 0;
		initial_joint.robax.rax_2 := -2.58;
		initial_joint.robax.rax_3 := -11.88;
		initial_joint.robax.rax_4 := 0;
		initial_joint.robax.rax_5 := 14.47;
		initial_joint.robax.rax_6 := 0;
		MoveAbsJ initial_joint, v100, fine, tool0;

		! Step 2: Move Robot1 TCP to HOME position at R-axis center with iterative refinement
		iteration := 0;
		max_iterations := 3;
		tolerance := 0.5;  ! mm

		! Update WobjGantry to reflect current gantry position
		UpdateGantryWobj;
		! TCP position: [0, 0, 1000] in WobjGantry (tracks gantry position)
		! Quaternion: [0.5, -0.5, 0.5, 0.5] (R-axis center orientation)
		! extax preserves current gantry position
		sync_pos := CJointT();
		home_tcp := [[0, 0, 1000], [0.5, -0.5, 0.5, 0.5], [0, 0, 0, 0], sync_pos.extax];
		MoveJ home_tcp, v100, fine, tool0\WObj:=WobjGantry;
		! Iterative refinement to reach precise R-axis center (max 3 iterations)
		WHILE iteration < max_iterations DO
			iteration := iteration + 1;
			! Read current position in wobj0
			current_wobj0 := CRobT(\Tool:=tool0\WObj:=wobj0);
			error_x := 0 - current_wobj0.trans.x;  ! Target X=0
			error_y := 0 - current_wobj0.trans.y;  ! Target Y=0

			! Check if within tolerance
			IF Abs(error_x) < tolerance AND Abs(error_y) < tolerance THEN
				! Force loop exit by setting iteration >= max_iterations (BREAK has issues)
				iteration := max_iterations;
			ELSE
				! Apply correction in WobjGantry coordinates
				UpdateGantryWobj;
				sync_pos := CJointT();
				home_tcp := [[error_x, error_y, 1000], [0.5, -0.5, 0.5, 0.5], [0, 0, 0, 0], sync_pos.extax];
				MoveL home_tcp, v50, fine, tool0\WObj:=WobjGantry;
			ENDIF
		ENDWHILE

		! Step 3: Move gantry to HOME position (physical origin)
		home_pos := CJointT();  ! Read current position
		home_pos.extax.eax_a := 0;      ! X1 = Physical origin
		home_pos.extax.eax_b := 0;      ! Y = Physical origin
		home_pos.extax.eax_c := 0;      ! Z = Physical origin
		home_pos.extax.eax_d := 0;      ! R = Physical origin
		! eax_e: keep from CJointT() (not used)
		home_pos.extax.eax_f := 0;      ! X2 = X1 (Master-Follower sync!)
		MoveAbsJ home_pos, v100, fine, tool0;
		TPWrite "Robot1 init: done";
		Write logfile, "Done errX=" + NumToStr(error_x, 2) + " errY=" + NumToStr(error_y, 2) + " iter=" + NumToStr(iteration, 0) + " at " + CTime();
		Close logfile;
	
	ERROR
		TPWrite "ERROR in SetRobot1InitialPosition: " + NumToStr(ERRNO, 0);
		Close logfile;
		STOP;
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

	abort_test := FALSE;
	mode2_log := "HOME:/gantry_mode2_test.txt";

	Open mode2_log, logfile \Write;
	Write logfile, "Mode2 Test (" + TASK1_VERSION + ") Date=" + CDate() + " Time=" + CTime();
	Write logfile, "Enter TestGantryMode2";
	TPWrite "Mode2: Loading config from PERS variables";

	! Read configuration from PERS variables (no file I/O)
	tcp_offset_x := MODE2_TCP_OFFSET_R1_X;
	tcp_offset_y := MODE2_TCP_OFFSET_R1_Y;
	tcp_offset_z := MODE2_TCP_OFFSET_R1_Z;

	! Sync Robot2 offsets from ConfigModule (for TASK2)
	mode2_r2_offset_x := MODE2_TCP_OFFSET_R2_X;
	mode2_r2_offset_y := MODE2_TCP_OFFSET_R2_Y;
	mode2_r2_offset_z := MODE2_TCP_OFFSET_R2_Z;

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
	WaitTime 0.3;

	! Move Robot1 to offset in WobjGantry
	UpdateGantryWobj;
	home_pos := CJointT();
	offset_tcp := [[tcp_offset_x, tcp_offset_y, 1000 + tcp_offset_z], [0.5, -0.5, 0.5, 0.5], [0, 0, 0, 0], home_pos.extax];
	MoveJ offset_tcp, v100, fine, tool0\WObj:=WobjGantry;
	TPWrite "Mode2: Robot1 at offset TCP";

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

		! Move gantry to test position
		test_pos := CJointT();
		test_pos.extax.eax_a := phys_x;
		test_pos.extax.eax_b := phys_y;
		test_pos.extax.eax_c := phys_z;
		test_pos.extax.eax_d := phys_r;
		test_pos.extax.eax_f := test_pos.extax.eax_a;
		MoveAbsJ test_pos, v100, fine, tool0;
		TPWrite "Mode2: Gantry moved to position " + NumToStr(i,0) + "/" + NumToStr(num_pos,0);

		! Update WobjGantry for new gantry position and rotation
		UpdateGantryWobj;

		! Move Robot1 TCP back to offset position in updated WobjGantry
		offset_tcp := [[tcp_offset_x, tcp_offset_y, 1000 + tcp_offset_z], [0.5, -0.5, 0.5, 0.5], [0, 0, 0, 0], test_pos.extax];
		MoveJ offset_tcp, v100, fine, tool0\WObj:=WobjGantry;
		TPWrite "Mode2: Robot1 TCP at offset";
		WaitTime 0.5;

		! Measure Robot1 and Robot2 TCP positions
		UpdateRobot1FloorPosition;
		UpdateRobot2BaseDynamicWobj;
		rob1_floor := robot1_floor_pos_t1;
		rob2_floor := robot2_floor_pos_t1;

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
	home_pos := CJointT();
	home_pos.extax.eax_a := 0;
	home_pos.extax.eax_b := 0;
	home_pos.extax.eax_c := 0;
	home_pos.extax.eax_d := 0;
	home_pos.extax.eax_f := 0;
	MoveAbsJ home_pos, v100, fine, tool0;

	Close logfile;
	TPWrite "Mode2: Test complete!";
	IF abort_test = TRUE THEN
		TPWrite "Mode2: Test aborted (out of range)";
		STOP;
	ENDIF

ERROR
	Write logfile, "ERROR in TestGantryMode2: " + NumToStr(ERRNO, 0);
	Close logfile;
	TPWrite "ERROR in TestGantryMode2: " + NumToStr(ERRNO, 0);
	STOP;
ENDPROC


ENDMODULE

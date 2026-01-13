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
CONST string TASK1_VERSION := "v1.8.67";
CONST string TASK2_VERSION := "v1.8.67";
CONST string TASK_BG_VERSION := "v1.0.0";

! ========================================
! Module Versions
! ========================================
CONST string CONFIG_MODULE_VERSION := "v1.0.0";
CONST string VERSION_MODULE_VERSION := "v1.0.0";

! ========================================
! Build Information
! ========================================
CONST string BUILD_DATE := "2026-01-13";
CONST string BUILD_TIME := "21:50:00";
CONST string PROJECT_NAME := "S25016 SpGantry Dual Robot System";

! ========================================
! Major Component Versions
! ========================================
! Coordinate System
CONST string COORD_SYSTEM_VERSION := "v1.8.5";  ! Last stable coordinate calculation

! Gantry Control
CONST string GANTRY_CONTROL_VERSION := "v1.8.35";  ! Robot init + sync

! Mode2 Test
CONST string MODE2_TEST_VERSION := "v1.8.67";  ! Latest: Wait for Robot2 initial offset

! ========================================
! Version History (Latest 10)
! ========================================
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

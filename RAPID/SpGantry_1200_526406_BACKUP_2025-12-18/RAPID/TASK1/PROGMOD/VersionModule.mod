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
CONST string TASK1_VERSION := "v1.8.55";
CONST string TASK2_VERSION := "v1.8.55";
CONST string TASK_BG_VERSION := "v1.0.0";

! ========================================
! Module Versions
! ========================================
CONST string CONFIG_MODULE_VERSION := "v1.0.0";
CONST string VERSION_MODULE_VERSION := "v1.0.0";

! ========================================
! Build Information
! ========================================
CONST string BUILD_DATE := "2026-01-12";
CONST string BUILD_TIME := "14:00:00";
CONST string PROJECT_NAME := "S25016 SpGantry Dual Robot System";

! ========================================
! Major Component Versions
! ========================================
! Coordinate System
CONST string COORD_SYSTEM_VERSION := "v1.8.5";  ! Last stable coordinate calculation

! Gantry Control
CONST string GANTRY_CONTROL_VERSION := "v1.8.35";  ! Robot init + sync

! Mode2 Test
CONST string MODE2_TEST_VERSION := "v1.8.55";  ! Latest: Robot2 offset fix (488mm removed)

! ========================================
! Version History (Latest 10)
! ========================================
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

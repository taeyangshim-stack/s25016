MODULE Head_MainModule
! ========================================
! T_Head Main Module (v1.9.39)
! ========================================
! Purpose: Command dispatcher for upper system interface
! Protocol: nCmdInput → rCheckCmdMatch → stCommand → stReact → nCmdOutput
! PlanA reference: Head_MainModule.mod (TASK8)
! ========================================

PROC main()
    VAR string sDate;
    VAR string sTime;

    rInit;

    sDate := CDate();
    sTime := CTime();
    TPWrite "T_Head v1.9.39 started at " + sTime;

    ! Wait for TASK1/TASK2 to enter listener mode (test_mode=11)
    TPWrite "T_Head: Waiting for robots...";
    WaitUntil stReact{1} = "Ready" AND stReact{2} = "Ready" \MaxTime := 30;

    IF stReact{1} <> "Ready" OR stReact{2} <> "Ready" THEN
        TPWrite "T_Head: Robots not ready (mode != 11?)";
        TPWrite "  stReact{1}=" + stReact{1} + " stReact{2}=" + stReact{2};
        Stop;
    ENDIF

    TPWrite "T_Head: Both robots ready, entering CommandLoop";

    ! ========================================
    ! Main command loop
    ! ========================================
    WHILE TRUE DO
        WaitUntil nCmdInput <> 0;

        bMotionWorking := TRUE;
        bMotionFinish := FALSE;

        sTime := CTime();
        TPWrite "T_Head CMD=" + NumToStr(nCmdInput, 0) + " at " + sTime;

        TEST nCmdInput
            ! --- Movement (100 series) ---
            CASE CMD_MOVE_TO_WORLDHOME:
                rCheckCmdMatch CMD_MOVE_TO_WORLDHOME;
                rDispatchAndWait "MoveHome";

            CASE CMD_MOVE_TO_MEASUREMENTHOME:
                rCheckCmdMatch CMD_MOVE_TO_MEASUREMENTHOME;
                rDispatchR1 "MoveMeasurementHome";

            CASE CMD_MOVE_TO_TEACHING_R1:
                rCheckCmdMatch CMD_MOVE_TO_TEACHING_R1;
                rDispatchR1 "MoveTeachingR1";

            CASE CMD_MOVE_TO_TEACHING_R2:
                rCheckCmdMatch CMD_MOVE_TO_TEACHING_R2;
                rDispatchR1 "MoveTeachingR2";

            CASE CMD_MOVE_ABS_GANTRY:
                rCheckCmdMatch CMD_MOVE_ABS_GANTRY;
                rDispatchR1 "MoveAbsGantry";

            CASE CMD_MOVE_INC_GANTRY:
                rCheckCmdMatch CMD_MOVE_INC_GANTRY;
                rDispatchR1 "MoveIncGantry";

            CASE CMD_MOVE_TO_ZHOME:
                rCheckCmdMatch CMD_MOVE_TO_ZHOME;
                rDispatchR1 "MoveZHome";

            CASE CMD_MOVE_TO_WARMUP:
                rCheckCmdMatch CMD_MOVE_TO_WARMUP;
                rDispatchR1 "MoveWarmup";

            ! --- Welding (200 series) ---
            CASE CMD_WELD:
                rCheckCmdMatch CMD_WELD;
                bEnableWeldSkip := FALSE;
                rDispatchAndWait "Weld";

            CASE CMD_WELD_MOTION:
                rCheckCmdMatch CMD_WELD_MOTION;
                bEnableWeldSkip := TRUE;
                rDispatchAndWait "WeldMotion";

            CASE CMD_WELD_CORR:
                rCheckCmdMatch CMD_WELD_CORR;
                bEnableWeldSkip := FALSE;
                bEnableStartEndPointCorr := TRUE;
                rDispatchAndWait "WeldCorr";

            CASE CMD_WELD_MOTION_CORR:
                rCheckCmdMatch CMD_WELD_MOTION_CORR;
                bEnableWeldSkip := TRUE;
                bEnableStartEndPointCorr := TRUE;
                rDispatchAndWait "WeldMotionCorr";

            CASE CMD_EDGE_WELD:
                rCheckCmdMatch CMD_EDGE_WELD;
                bEnableWeldSkip := FALSE;
                rDispatchAndWait "EdgeWeld";

            ! --- Camera (300 series) ---
            CASE CMD_CAMERA_DOOR_OPEN:
                rCheckCmdMatch CMD_CAMERA_DOOR_OPEN;
                rDispatchR1 "CameraDoorOpen";

            CASE CMD_CAMERA_DOOR_CLOSE:
                rCheckCmdMatch CMD_CAMERA_DOOR_CLOSE;
                rDispatchR1 "CameraDoorClose";

            CASE CMD_CAMERA_BLOW_ON:
                rCheckCmdMatch CMD_CAMERA_BLOW_ON;
                rDispatchR1 "CameraBlowOn";

            CASE CMD_CAMERA_BLOW_OFF:
                rCheckCmdMatch CMD_CAMERA_BLOW_OFF;
                rDispatchR1 "CameraBlowOff";

            ! --- Wire (500 series) ---
            CASE CMD_WIRE_CUT:
                rCheckCmdMatch CMD_WIRE_CUT;
                rDispatchR1 "WireCut";

            CASE CMD_WIRE_CLEAN:
                rCheckCmdMatch CMD_WIRE_CLEAN;
                rDispatchR1 "WireClean";

            CASE CMD_ROB1_WIRE_CUT:
                rCheckCmdMatch CMD_ROB1_WIRE_CUT;
                rDispatchR1 "Rob1WireCut";

            CASE CMD_ROB2_WIRE_CUT:
                rCheckCmdMatch CMD_ROB2_WIRE_CUT;
                rDispatchR1 "Rob2WireCut";

            ! --- Inspection (600 series) ---
            CASE CMD_HOLE_CHECK:
                rCheckCmdMatch CMD_HOLE_CHECK;
                rDispatchR1 "HoleCheck";

            CASE CMD_LDS_CHECK:
                rCheckCmdMatch CMD_LDS_CHECK;
                rDispatchR1 "LdsCheck";

            ! --- Test/Debug (900 series) ---
            CASE CMD_TEST_MENU:
                rCheckCmdMatch CMD_TEST_MENU;
                rDispatchR1 "TestMenu";

            CASE CMD_TEST_SINGLE:
                rCheckCmdMatch CMD_TEST_SINGLE;
                rDispatchR1 "TestSingle";

            CASE CMD_TEST_ROTATION:
                rCheckCmdMatch CMD_TEST_ROTATION;
                rDispatchR1 "TestRotation";

            CASE CMD_TEST_MODE2:
                rCheckCmdMatch CMD_TEST_MODE2;
                rDispatchR1 "TestMode2";

            DEFAULT:
                TPWrite "T_Head: Unknown CMD=" + NumToStr(nCmdInput, 0);
                rCheckCmdMatch nCmdInput;
        ENDTEST

        bMotionWorking := FALSE;
        bMotionFinish := TRUE;
        rInit_Cmd;

        ! Wait for upper system to clear nCmdInput
        WaitUntil nCmdInput = 0;
    ENDWHILE
ENDPROC

! ========================================
! Handshake with upper system
! ========================================
! Upper system sets nCmdInput, T_Head echoes to nCmdOutput
! Upper system confirms with nCmdMatch (1=OK, -1=error)
PROC rCheckCmdMatch(num CMD)
    nCmdOutput := CMD;
    WaitUntil nCmdMatch = 1 OR nCmdMatch = -1 \MaxTime := 30;

    IF nCmdMatch = -1 THEN
        TPWrite "[ERROR] Command mismatch: " + NumToStr(CMD, 0);
        nCmdMatch := 0;
        Stop;
    ENDIF

    IF nCmdMatch <> 1 THEN
        TPWrite "[ERROR] CmdMatch timeout: " + NumToStr(CMD, 0);
        nCmdMatch := 0;
        Stop;
    ENDIF

    nCmdMatch := 0;
ENDPROC

! ========================================
! Dispatch to both TASK1 + TASK2 and wait
! ========================================
PROC rDispatchAndWait(string cmd)
    TPWrite "T_Head: Dispatch [" + cmd + "] to TASK1+TASK2";

    stCommand := cmd;

    ! Wait for both robots to acknowledge
    WaitUntil stReact{1} = "Ack" AND stReact{2} = "Ack" \MaxTime := 300;

    IF stReact{1} <> "Ack" OR stReact{2} <> "Ack" THEN
        TPWrite "[ERROR] Dispatch timeout: " + cmd;
        TPWrite "  stReact{1}=" + stReact{1} + " stReact{2}=" + stReact{2};
        stCommand := "";
        Stop;
    ENDIF

    TPWrite "T_Head: [" + cmd + "] Ack received";

    ! Clear command and wait for ready
    stCommand := "";
    WaitUntil stReact{1} = "Ready" AND stReact{2} = "Ready" \MaxTime := 30;

    TPWrite "T_Head: [" + cmd + "] complete";
ENDPROC

! ========================================
! Dispatch to TASK1 only (gantry moves, single-robot ops)
! ========================================
PROC rDispatchR1(string cmd)
    TPWrite "T_Head: Dispatch [" + cmd + "] to TASK1";

    stCommand := cmd;

    ! Wait for TASK1 to acknowledge
    WaitUntil stReact{1} = "Ack" \MaxTime := 300;

    IF stReact{1} <> "Ack" THEN
        TPWrite "[ERROR] R1 dispatch timeout: " + cmd;
        stCommand := "";
        Stop;
    ENDIF

    TPWrite "T_Head: [" + cmd + "] R1 Ack received";

    ! Clear command and wait for ready
    stCommand := "";
    WaitUntil stReact{1} = "Ready" \MaxTime := 30;

    TPWrite "T_Head: [" + cmd + "] complete";
ENDPROC

! ========================================
! Initialize all command/status variables
! ========================================
PROC rInit()
    nCmdInput := 0;
    nCmdOutput := 0;
    nCmdMatch := 0;
    stCommand := "";
    stReact{1} := "";
    stReact{2} := "";
    bMotionWorking := FALSE;
    bMotionFinish := FALSE;
    bEnableWeldSkip := FALSE;
    bEnableManualMacro := FALSE;
    bEnableStartEndPointCorr := FALSE;
ENDPROC

! ========================================
! Reset command output after completion
! ========================================
PROC rInit_Cmd()
    nCmdOutput := 0;
ENDPROC

ENDMODULE

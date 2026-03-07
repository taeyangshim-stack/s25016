MODULE Head_MainModule
    PERS jointgroup jgTest1:=[[[10,-17,-27.5,0,-45,0],[0,0,0,0,0,0]],[[10,-17,-27.5,0,-45,0],[0,0,0,0,0,0]],[[0,0,0,0,0,0],[8000,2500,0,10,0,8000]]];
    PERS jointgroup jgTest2:=[[[20,-17,-27.5,0,-45,0],[0,0,0,0,0,0]],[[20,-17,-27.5,0,-45,0],[0,0,0,0,0,0]],[[0,0,0,0,0,0],[8000,2500,0,20,0,8000]]];
    PERS jointgroup jgTest3:=[[[30,-17,-27.5,0,-45,0],[0,0,0,0,0,0]],[[30,-17,-27.5,0,-45,0],[0,0,0,0,0,0]],[[0,0,0,0,0,0],[8000,2500,0,30,0,8000]]];
    PERS jointgroup jgTest4:=[[[0,-17,-27.5,0,-45,0],[0,0,0,0,0,0]],[[0,-17,-27.5,0,-45,0],[0,0,0,0,0,0]],[[0,0,0,0,0,0],[8000,2500,0,0,0,8000]]];

    PERS bool sim_touch_detected1;
    PERS bool sim_touch_detected2;

    PROC rInit()
        stCommand:="";
        WaitUntil stReact=["Ready","Ready","Ready"];
        nCmdInput:=0;
        nCmdOutput:=0;

        bArcError:=FALSE;

        bRobSwap:=FALSE;
        bEnableWeldSkip:=FALSE;
        bEnableStartEndPointCorr:=FALSE;
        bEnableManualMacro:=FALSE;
        bWireTouch1:=FALSE;
        bWireTouch2:=FALSE;
        rSettingInitialize;

        ! Touch Sync reset
        bso_MoveG_PosHold:=False;
        bGantryInTrap{1}:=FALSE;
        Reset intReHoldGantry_1;
        Reset intReHoldGantry_2;
        Reset so_MoveG_PosHold;
        Reset do09_Wire_Cutter_Close;
        Reset do10_Wire_Cutter_Open;
        Reset po14_Motion_Working;
        Set po15_Motion_Finish;
        Reset soAwManGasOn;

        WHILE sim_touch_detected1=TRUE OR sim_touch_detected2=TRUE DO
            sim_touch_detected1:=FALSE;
            sim_touch_detected2:=FALSE;
        ENDWHILE

        WHILE soLn2TouchActive=1 OR soLn1TouchActive=1 DO
            Reset soLn1TouchActive;
            Reset soLn2TouchActive;
        ENDWHILE

        TPWrite "END Init";
    ENDPROC

    PROC rInit_PostCmdInput()

        Set po14_Motion_Working;
        Reset po15_Motion_Finish;
        WaitTime 0.2;
        Reset po32_EntryR1Error;
        Reset po34_EntryR2Error;
        Reset po33_TouchR1Error;
        Reset po35_TouchR2Error;
        Reset po36_ArcR1Error;
        Reset po37_ArcR2Error;
        reset po52_CmdCanceled;
        reset po51_MaxHeightUpdated;
        btouchTimeOut:=[FALSE,FALSE];
        TPWrite "END Init_PostCmdInput";
    ENDPROC

    PROC main()
        VAR string sDate;
        VAR string sTime;
        nMoveid:=1;
        IF nErrorCmd=0 rInit;
        IF pi52_CmdCanceled=1 THEN
            set po51_MaxHeightUpdated;
            set po52_CmdCanceled;
            IF max(max(nMaxPartHeightNearArray{1},nMaxPartHeightNearArray{2}),nMaxPartHeightNearArray{3})>800 THEN
                rMeasurementHomeCheck;
            ELSE
                rjgWireCutHomeCheck;
            ENDIF
        ENDIF
        IF nErrorCmd=1 rErrorMoveHome;
        !!! Excute when not automode !!!
        IF (NOT OpMode()=1) rTpRoutine;

        WHILE TRUE DO

            WaitUntil nCmdInput<>0;
            rInit_PostCmdInput;


            sDate:=CDate();
            sTime:=CTime();

            sDate:=StrPart(sDate,3,2)+StrPart(sDate,6,2)+StrPart(sDate,9,2);
            sTime:=StrPart(sTime,1,2)+StrPart(sTime,4,2)+StrPart(sTime,7,2);
            TPWrite "TIME ("+sDate+" "+sTime+") | Cammand : "+ValToStr(nCmdInput);

            TEST nCmdInput

            CASE CMD_MOVE_TO_WORLDHOME:
                rCheckCmdMacth CMD_MOVE_TO_WORLDHOME;
                rGantry_C_Home;
                rMoveToRobotHome;
                rMoveHome;

            CASE CMD_MOVE_TO_MeasurementHOME:
                rCheckCmdMacth CMD_MOVE_TO_MeasurementHOME;
                waittime 2;
                IF max(max(nMaxPartHeightNearArray{1},nMaxPartHeightNearArray{2}),nMaxPartHeightNearArray{3})>800 THEN
                    rMeasurementHomeCheck;
                ELSE
                    rjgWireCutHomeCheck;
                ENDIF

            CASE CMD_MOVE_TO_TEACHING_R1:
                rCheckCmdMacth CMD_MOVE_TO_TEACHING_R1;
                rMoveTeachingPoseR1;
            CASE CMD_MOVE_TO_TEACHING_R2:
                rCheckCmdMacth CMD_MOVE_TO_TEACHING_R2;
                rMoveTeachingPoseR2;

            CASE CMD_MOVE_ABS_GANTRY:
                rCheckCmdMacth CMD_MOVE_ABS_GANTRY;
                sTime:=CTime();
                TPWrite "TIME ("+sTime+") | CmdInput : "+ValToStr(nCmdInput);
                TPWrite "(X, Y, Z): ("+ValToStr(extGantryPos.eax_a)+", "+ValToStr(extGantryPos.eax_b)+", "+ValToStr(extGantryPos.eax_c)+", "+ValToStr(extGantryPos.eax_d)+")";
                rMoveToGantryInAbs;

            CASE CMD_MOVE_INC_GANTRY:
                rCheckCmdMacth CMD_MOVE_INC_GANTRY;
                TPWrite "(INC X, INC Y, INC Z): ("+ValToStr(extGantryPos.eax_a)+", "+ValToStr(extGantryPos.eax_b)+", "+ValToStr(extGantryPos.eax_c)+", "+ValToStr(extGantryPos.eax_d)+")";
                rMoveToGantryInInc;

            CASE CMD_MOVE_TO_ZHOME:
                rCheckCmdMacth CMD_MOVE_TO_ZHOME;
                waittime 2;
                rMoveToRobotHome;
            CASE CMD_MOVE_TO_nWarmUp:
                rCheckCmdMacth CMD_MOVE_TO_nWarmUp;
                rWarm_Up;

            CASE CMD_Tcp_Inspect:
                rCheckCmdMacth CMD_Tcp_Inspect;
                rTcp_Inspect;

            CASE CMD_WELD:
                rCheckCmdMacth CMD_WELD;
                bEnableWeldSkip:=FALSE;
                bEnableStartEndPointCorr:=FALSE;
                bEnableManualMacro:=FALSE;
                rMoveStep;

            CASE CMD_WELD_MOTION:
                rCheckCmdMacth CMD_WELD_MOTION;
                bEnableWeldSkip:=TRUE;
                bEnableStartEndPointCorr:=FALSE;
                bEnableManualMacro:=FALSE;
                rMoveStep;

            CASE CMD_WELD_CORR:
                rCheckCmdMacth CMD_WELD_CORR;
                bEnableWeldSkip:=FALSE;
                bEnableStartEndPointCorr:=TRUE;
                bEnableManualMacro:=FALSE;
                rMoveStep;

            CASE CMD_WELD_MOTION_CORR:
                rCheckCmdMacth CMD_WELD_MOTION_CORR;
                bEnableWeldSkip:=TRUE;
                bEnableStartEndPointCorr:=TRUE;
                bEnableManualMacro:=FALSE;
                rMoveStep;

            CASE CMD_WELD_MM:
                rCheckCmdMacth CMD_WELD_MM;
                bEnableWeldSkip:=FALSE;
                bEnableStartEndPointCorr:=FALSE;
                bEnableManualMacro:=TRUE;
                rMoveStep;

            CASE CMD_WELD_MOTION_MM:
                rCheckCmdMacth CMD_WELD_MOTION_MM;
                bEnableWeldSkip:=TRUE;
                bEnableStartEndPointCorr:=FALSE;
                bEnableManualMacro:=TRUE;
                rMoveStep;

            CASE CMD_WELD_CORR_MM:
                rCheckCmdMacth CMD_WELD_CORR_MM;
                bEnableWeldSkip:=FALSE;
                bEnableStartEndPointCorr:=TRUE;
                bEnableManualMacro:=TRUE;
                rMoveStep;

            CASE CMD_WELD_MOTION_CORR_MM:
                rCheckCmdMacth CMD_WELD_MOTION_CORR_MM;
                bEnableWeldSkip:=TRUE;
                bEnableStartEndPointCorr:=TRUE;
                bEnableManualMacro:=TRUE;
                rMoveStep;

            CASE CMD_CAMERA_DOOR_OPEN:
                rCheckCmdMacth CMD_CAMERA_DOOR_OPEN;
                WaitTime 2;
                rCameraDoorOpen;

            CASE CMD_CAMERA_DOOR_CLOSE:
                rCheckCmdMacth CMD_CAMERA_DOOR_CLOSE;
                WaitTime 2;
                rCameraDoorClose;

            CASE CMD_CAMERA_BLOW_ON:
                rCheckCmdMacth CMD_CAMERA_BLOW_ON;
                WaitTime 2;
                rCameraBlowOn;

            CASE CMD_CAMERA_BLOW_OFF:
                rCheckCmdMacth CMD_CAMERA_BLOW_OFF;
                WaitTime 2;
                rCameraBlowOff;

            CASE CMD_CAMERA1_DOOR_OPEN:
                rCheckCmdMacth CMD_CAMERA1_DOOR_OPEN;
                WaitTime 2;
                rCamera1DoorOpen;

            CASE CMD_CAMERA1_DOOR_CLOSE:
                rCheckCmdMacth CMD_CAMERA1_DOOR_CLOSE;
                WaitTime 2;
                rCamera1DoorClose;

            CASE CMD_CAMERA2_DOOR_OPEN:
                rCheckCmdMacth CMD_CAMERA2_DOOR_OPEN;
                WaitTime 2;
                rCamera2DoorOpen;

            CASE CMD_CAMERA1_BLOW_ON:
                rCheckCmdMacth CMD_CAMERA1_BLOW_ON;
                WaitTime 2;
                rCamera1_BlowOn;

            CASE CMD_CAMERA1_BLOW_OFF:
                rCheckCmdMacth CMD_CAMERA1_BLOW_OFF;
                WaitTime 2;
                rCamera1_BlowOff;

            CASE CMD_CAMERA2_DOOR_CLOSE:
                rCheckCmdMacth CMD_CAMERA2_DOOR_CLOSE;
                WaitTime 2;
                rCamera2DoorClose;

            CASE CMD_CAMERA2_BLOW_ON:
                rCheckCmdMacth CMD_CAMERA2_BLOW_ON;
                WaitTime 2;
                rCamera2_BlowOn;

            CASE CMD_CAMERA2_BLOW_OFF:
                rCheckCmdMacth CMD_CAMERA2_BLOW_OFF;
                WaitTime 2;
                rCamera2_BlowOff;

            CASE CMD_WIRE_CUT:
                rCheckCmdMacth CMD_WIRE_CUT;
                rWirecut 3;

            CASE CMD_WIRE_CLEAN:
                rCheckCmdMacth CMD_WIRE_CLEAN;
                rNozzleClean "R1&R2";

            CASE CMD_MOVE_TO_nWarmUp:
                rCheckCmdMacth CMD_MOVE_TO_nWarmUp;
                rWarm_Up;

            CASE CMD_WIRE_BULLSEYE_CHECK:
                rCheckCmdMacth CMD_WIRE_BULLSEYE_CHECK;
                !                rBullsEyeCheck;

            CASE CMD_WIRE_BULLSEYE_UPDATE:
                rCheckCmdMacth CMD_WIRE_BULLSEYE_UPDATE;
                !                rBullsEyeUpdate;

            CASE CMD_WIRE_ReplacementMode:
                rCheckCmdMacth CMD_WIRE_ReplacementMode;
                rWireReplacementMode;

            CASE CMD_ROB1_WIRE_CUT:
                rCheckCmdMacth CMD_ROB1_WIRE_CUT;
                bWireCutSync:=False;
                rWirecut 1;

            CASE CMD_ROB2_WIRE_CUT:
                rCheckCmdMacth CMD_ROB2_WIRE_CUT;
                bWireCutSync:=False;
                rWirecut 2;

            CASE CMD_WIRE_CLEAN_R1:
                rCheckCmdMacth CMD_WIRE_CLEAN_R1;
                rNozzleClean "R1";

            CASE CMD_WIRE_CLEAN_R2:
                rCheckCmdMacth CMD_WIRE_CLEAN_R2;
                rNozzleClean "R2";

            CASE CMD_GotoTeachingToWirecut:
                rCheckCmdMacth CMD_GotoTeachingToWirecut;
                bTeachingWireCut:=TRUE;
                rjgWireCutHomeCheck;

            CASE CMD_TeachingToWirecutEntry_R1:
                rCheckCmdMacth CMD_TeachingToWirecutEntry_R1;
                stCommand:="TeachingWirecutEntry_R1";
                rTeachingComplete_stReact;

            CASE CMD_TeachingToWirecut_R1:
                rCheckCmdMacth CMD_TeachingToWirecut_R1;
                stCommand:="TeachingWirecut_R1";
                rTeachingComplete_stReact;

            CASE CMD_ReturnToWirecut:
                rCheckCmdMacth CMD_ReturnToWirecut;
                rReTurnToWireCut;
                bTeachingWireCut:=FALSE;
                
            CASE CMD_TeachingToWirecutEntry_R2:
                rCheckCmdMacth CMD_TeachingToWirecutEntry_R2;
                stCommand:="TeachingWirecutEntry_R2";
                rTeachingComplete_stReact;

            CASE CMD_TeachingToWirecut_R2:
                rCheckCmdMacth CMD_TeachingToWirecut_R2;
                stCommand:="TeachingWirecut_R2";
                rTeachingComplete_stReact;

            CASE CMD_HOLE_CHECK:
                rCheckCmdMacth CMD_HOLE_CHECK;
                rHole_check_X;

            CASE CMD_LDS_CHECK:
                rCheckCmdMacth CMD_LDS_CHECK;
                rLdsCheck;
                !rSettingInitialize;
            CASE CMD_ManualOrigin_CHECK:
                rCheckCmdMacth CMD_ManualOrigin_CHECK;
                rManualOriginCheck;
                
            DEFAULT:
                rCheckCmdMacth 999;

            ENDTEST

            Reset po14_Motion_Working;
            Set po15_Motion_Finish;
            rInit;
            !            bRetry:=FALSE;
            nCmdOutput:=0;
            WaitUntil(nCmdInput=0);
        ENDWHILE

        RETURN ;
    ENDPROC

    PROC rCheckCmdMacth(num CMD)
        !        IF bRetry=FALSE THEN
        nCmdOutput:=CMD;
        WaitUntil nCmdMatch=1 OR nCmdMatch=-1;
        WHILE nCmdMatch<>1 DO
            IF nCmdMatch=-1 THEN
                TPWrite "The Command is Not Correct";
                Stop;
            ENDIF
        ENDWHILE
        nCmdMatch:=0;
        !        ENDIF
        RETURN ;
    ENDPROC

    PROC rSettingInitialize()
        !        nHomeTcpX:=nLimitX_Negative;
        !        nHomeTcpY:=nLimitY_Positive;
        !        nHomeTcpZ:=nLimitZ_Positive;

        !        nHomeAdjustX:=nDiffGantryX;
        !        nHomeAdjustY:=nDiffGantryY;
        !        nHomeAdjustZ:=nDiffGantryZ;

        !        nHomeGantryX:=nHomeTcpX+nHomeAdjustX;
        !        nHomeGantryY:=nHomeTcpY+nHomeAdjustY;
        !        nHomeGantryZ:=nHomeTcpZ+nHomeAdjustZ;

        !        WobjFloor.uframe.trans:=[nHomeGantryX,nHomeGantryY,nHomeGantryZ];

        RETURN ;
    ENDPROC

    PROC rZeroPos()
        MoveAbsJ [[0,0,0,0,0,0],[0,0,0,0,0,0]]\NoEOffs,v1000,z50,tool0;
        RETURN ;
        MoveAbsJ [[0,0,0,0,0,0],[0,0,0,0,0,0]]\NoEOffs,v1000,z50,tool0;
    ENDPROC

    PROC rErrorMoveHome()
        VAR jointgroup jTempReadyGroup;
        nErrorCmd:=0;
        IF pi52_CmdCanceled=1 THEN
            set po52_CmdCanceled;
            set po51_MaxHeightUpdated;
        ENDIF
        jTempReadyGroup:=MergeJgWith();
        jTempReadyGroup.Joint1:=jSearchReadyGroup.Joint1;
        jTempReadyGroup.Joint2:=jSearchReadyGroup.Joint2;
        jTempReadyGroup.JointG.extax.eax_c:=jTempReadyGroup.JointG.extax.eax_c-130;

        MoveJgJ MergeJgWith(\Rob1:=jTempReadyGroup.Joint1\Rob2:=jTempReadyGroup.Joint2\Gantry:=jTempReadyGroup.JointG),vTargetSpeed,z200;

        jTempReadyGroup:=MergeJgWith();
        jTempReadyGroup.JointG.extax.eax_c:=0;

        MoveJgJ MergeJgWith(\Gantry:=jTempReadyGroup.JointG),vTargetSpeed,z200;
        IF bMoveToWireCutHome=TRUE THEN
            rjgWireCutHomeCheck;
            
        ELSE
            IF max(max(nMaxPartHeightNearArray{1},nMaxPartHeightNearArray{2}),nMaxPartHeightNearArray{3})>800 THEN
                rMeasurementHomeCheck;
            ELSE
                rjgWireCutHomeCheck;
            ENDIF
        ENDIF
        nErrorCmd:=0;
        IF po36_ArcR1Error=1 OR po37_ArcR2Error=1 rArcErrorGantryDown;
        ExitCycle;
    ENDPROC

    PROC rTeachingComplete_stReact()
        WaitUntil stReact=["WorkComplete","WorkComplete","WorkComplete"];
        stCommand:="";
        WaitUntil stReact{1}="Ready";
        WaitUntil stReact=["Ready","Ready","Ready"];
    ENDPROC

ENDMODULE
MODULE Static
    ! ========================================
    ! T_BG Background Task - Static Module
    ! Ported from PlanA TASK9 for UI compatibility
    ! ========================================
    ! Purpose: Real-time monitoring of robot positions,
    !          motor torques, and weld status for upper UI
    ! UI reads: MonitorPosition, nTorques, stWeld1, stWeld2
    ! ========================================

    ! --- RECORD Definitions ---
    RECORD monRobs
        extjoint monExt;
        robjoint monJoint1;
        robjoint monJoint2;
        pose monPose1;
        pose monPose2;
    ENDRECORD

    RECORD StatusWeld
        num WeldTimeForTotal;
        num WeldTimeForLine;
        num WorkingAngle;
        num TravelAngle;
        num StatusForArc;
        num cpm;
        num rpm;
        num nDummy8;
        num nDummy9;
        num nDummy10;
    ENDRECORD

    RECORD pointgroup
        robtarget Point1;
        robtarget Point2;
        jointtarget JointG;
    ENDRECORD

    RECORD targetdata
        robtarget position;
        num cpm;
        num schedule;
        num voltage;
        num wfs;
        num Current;
        num WeaveShape;
        num WeaveType;
        num WeaveLength;
        num WeaveWidth;
        num WeaveDwellLeft;
        num WeaveDwellRight;
        num TrackType;
        num TrackGainY;
        num TrackGainZ;
        num MaxCorr;
        num Bias;
    ENDRECORD

    ! --- UI-Required PERS Variables ---
    PERS monRobs MonitorPosition;
    PERS num nTorques{18}:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9E+09,0];

    PERS StatusWeld stWeld1:=[0,0,0,0,0,0,0,0,0,0];
    PERS StatusWeld stWeld2:=[0,0,0,0,0,0,0,0,0,0];

    ! --- Shared PERS (cross-task, written by T_Head/T_ROB1/T_ROB2) ---
    PERS wobjdata WobjFloor;

    PERS num nLimitX_Negative;
    PERS num nLimitX_Positive;
    PERS num nLimitY_Negative;
    PERS num nLimitY_Positive;
    PERS num nLimitZ_Negative;
    PERS num nLimitZ_Positive;
    PERS num nHomeGantryX;
    PERS num nHomeGantryY;
    PERS num nHomeGantryZ;
    PERS num nHomeGantryR;
    PERS num nHomeAdjustX;
    PERS num nHomeAdjustY;
    PERS num nHomeAdjustZ;
    PERS num nHomeAdjustR;

    PERS robtarget pCurrentPosition;
    PERS jointtarget jCurrentJoint;

    PERS robtarget originalPosition;
    PERS robtarget objectPosition;
    PERS robtarget pctWeldPosR1;
    PERS robtarget pctWeldPosR2;

    PERS num nTotalMovingClock;
    PERS num nResetMovingClock;

    VAR clock cTotalMovingClock;
    VAR clock cResetMovingClock;

    PERS string stCommand;
    PERS string stReact{3};
    PERS num nWeldSequence:=0;
    PERS num nMotionTotalStep{2};
    PERS num nMotionStepCount{2};
    PERS num nMotionStartStepLast{2};
    PERS num nMotionEndStepLast{2};
    PERS num nRunningStep{2};

    PERS num nOffsetLengthBuffer;

    PERS bool bRqMoveG_PosHold;
    PERS bool bRqMoveG_PosHoldComp;
    PERS bool bWireTouch1:=FALSE;
    PERS bool bWireTouch2:=FALSE;

    PERS bool bShockSensorError:=FALSE;

    PERS tooldata tWeld;
    PERS tooldata tWeld1;
    PERS tooldata tWeld2;

    PERS wobjdata wobjWeldLine;
    PERS wobjdata wobjWeldLine1;
    PERS wobjdata wobjWeldLine2;
    PERS wobjdata wobjRotCtr1;
    PERS wobjdata wobjRotCtr2;

    PERS num nclockCycleTime;
    PERS num nclockWeldTime{2};
    PERS targetdata Welds1{40};
    PERS targetdata Welds2{40};
    PERS targetdata WeldsG{40};

    PERS jointtarget jHomeJoint;

    PERS bool sim_touch_detected1:=FALSE;
    PERS bool sim_touch_detected2:=FALSE;
    PERS bool bMoveHome_Head;
    PERS bool bMoveHome_ROB1;
    PERS bool bMoveHome_ROB2;
    PERS bool bMoveHome_Gantry;
    PERS bool bRobSwap;
    PERS bool bGantryInTrap{2}:=[FALSE,FALSE];
    PERS num nMacro010{2};
    PERS num nMacro001{2};
    PERS bool bWeldOutputDisable;
    PERS num nArcOnCount1;
    PERS num nArcOnCount2;
    PERS num nArcOnCountBuffer1;
    PERS num nArcOnCountBuffer2;
    PERS bool bArconCheck1;
    PERS bool bArconCheck2;
    PERS bool bso_MoveG_PosHold;
    PERS bool bEnableWeldSkip;

    ! --- Utility Functions ---

    FUNC num CalcAngleFromPos(pos posPoint)
        VAR num nlengthToPoint;
        VAR num result;
        nlengthToPoint:=Sqrt(Pow(posPoint.x,2)+Pow(posPoint.y,2));
        IF (0<=posPoint.y) THEN
            result:=ACos(posPoint.x/nlengthToPoint);
        ELSE
            result:=360-ACos(posPoint.x/nlengthToPoint);
        ENDIF

        RETURN result;
    ENDFUNC

    FUNC robtarget CalcCurrentTcp(\switch R1|switch R2)
        VAR robtarget result:=[[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,0,0]];

        IF Present(R1)=TRUE THEN
            result:=CRobT(\taskname:="T_ROB1"\Tool:=tWeld1\WObj:=WobjFloor);
        ENDIF

        IF Present(R2)=TRUE THEN
            result:=CRobT(\taskname:="T_ROB2"\Tool:=tWeld2\WObj:=WobjFloor);
        ENDIF

        RETURN result;
    ENDFUNC

    FUNC extjoint ConvertJointToExtCoord(jointtarget joint)
        VAR extjoint result;

        result:=joint.extax;

        result.eax_a:=Round((-nHomeGantryX+joint.extax.eax_a)\Dec:=2);
        result.eax_b:=Round((nHomeGantryY-joint.extax.eax_b)\Dec:=2);
        result.eax_c:=Round((nHomeGantryZ-joint.extax.eax_c)\Dec:=2);
        result.eax_d:=Round((nHomeGantryR-joint.extax.eax_d)\Dec:=2);
        result.eax_e:=9E+09;
        result.eax_f:=result.eax_a;

        RETURN result;
    ENDFUNC

    ! --- Main Loop ---
    PROC main()
        WHILE TRUE DO
            rReadMotorTorque;
            rUpdateCurrentPosition;
            rDigtalSignalPC;
            rWireTouch1;
            rWireTouch2;
            rUpdateWeldStatus;
            rNotifyHome;
            rShockSensorOperation;
            rErrorTouch;
        ENDWHILE
    ENDPROC

    PROC rErrorTouch()
        IF stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"] THEN
            Set intMoveHome_Head;
        ELSE
            Reset intMoveHome_Head;
        ENDIF
        IF stReact{1}="Error_Arc_Touch" THEN
            Set intMoveHome_RBT2;
        ELSE
            Reset intMoveHome_RBT2;
        ENDIF
        IF stReact{2}="Error_Arc_Touch" THEN
            Set intMoveHome_RBT1;
        ELSE
            Reset intMoveHome_RBT1;
        ENDIF
        IF stReact{1}="Error_Arc_Touch" OR stReact{2}="Error_Arc_Touch" THEN
            Set intMoveHome_Gantry;
        ELSE
            Reset intMoveHome_Gantry;
        ENDIF
    ENDPROC

    PROC rShockSensorOperation()
        IF bShockSensorError=FALSE AND (di17_Head1Shock=1 OR di19_Head2Shock=1) AND co001_AutoMode=1 AND co004_MotorOn=1 THEN
            bShockSensorError:=TRUE;
            ErrLog 4801,"ShockSensorError","","","","";
        ENDIF
        IF co002_PrgRun=1 AND bShockSensorError=TRUE THEN
            bShockSensorError:=FALSE;
        ENDIF
    ENDPROC

    PROC rDigtalSignalPC()
        RETURN ;
    ENDPROC

    PROC rUpdateCurrentPosition()
        VAR jointtarget jct1;
        VAR jointtarget jct2;
        VAR robtarget pct1;
        VAR robtarget pct2;

        MonitorPosition.monExt:=ConvertJointToExtCoord(CJointT(\TaskName:="T_Rob1"));
        jct1:=CJointT(\TaskName:="T_ROB1");
        jct2:=CJointT(\TaskName:="T_ROB2");
        pct1:=CalcCurrentTcp(\R1);
        pct2:=CalcCurrentTcp(\R2);

        MonitorPosition.monJoint1:=jct1.robax;
        MonitorPosition.monJoint2:=jct2.robax;

        MonitorPosition.monPose1.trans:=pct1.trans;
        MonitorPosition.monPose1.rot:=pct1.rot;

        MonitorPosition.monPose2.trans:=pct2.trans;
        MonitorPosition.monPose2.rot:=pct2.rot;

        SetAO cgo05_AxisX_Current,Round(MonitorPosition.monExt.eax_a);
        RETURN ;
    ENDPROC

    PROC rReadMotorTorque()
        FOR i FROM 13 TO 16 DO
            nTorques{i}:=Abs(GetMotorTorque(\mecunit:=GantryRob,i-12));
        ENDFOR

        nTorques{17}:=9E+09;
        nTorques{18}:=Abs(GetMotorTorque(\mecunit:=ELM_X,1));

        RETURN ;
    ENDPROC

    PROC rWireTouch1()
        IF (siLn1Current=1 AND siLn1Voltage=0 AND siLn1TouchActive=1) OR sim_touch_detected1=TRUE THEN
            bWireTouch1:=TRUE;
            Set intTouch_1;
        ENDIF

        IF soLn1TouchActive=0 THEN
            bWireTouch1:=FALSE;
            reSet intTouch_1;
        ENDIF

        RETURN ;
    ENDPROC

    PROC rWireTouch2()
        IF (siLn2Current=1 AND siLn2Voltage=0 AND siLn2TouchActive=1) OR sim_touch_detected2=TRUE THEN
            bWireTouch2:=TRUE;
            set intTouch_2;
        ENDIF

        IF soLn2TouchActive=0 THEN
            bWireTouch2:=FALSE;
            reset intTouch_2;
        ENDIF

        RETURN ;
    ENDPROC

    PROC rUpdateWeldStatus()
        pctWeldPosR1:=CRobT(\TaskName:="T_ROB1"\Tool:=tWeld1\WObj:=wobjWeldLine1);
        pctWeldPosR2:=CRobT(\TaskName:="T_ROB2"\Tool:=tWeld2\WObj:=wobjWeldLine2);

        IF (nMacro010{1}=3 AND nMacro010{2}=3) OR (nMacro010{1}=4 AND nMacro010{2}=4) THEN
            rMacroNo3_4;
        ELSE
            rMacroNo0_1_2;
        ENDIF

        stWeld1.WeldTimeForTotal:=nclockCycleTime;
        stWeld1.WeldTimeForLine:=nclockWeldTime{1};
        stWeld2.WeldTimeForLine:=nclockWeldTime{2};
        IF (nRunningStep{1}<>0) THEN
            stWeld1.WorkingAngle:=EulerZYX(\y,pctWeldPosR1.rot);
            stWeld1.TravelAngle:=EulerZYX(\z,pctWeldPosR1.rot);
            IF siLn1Arc_Est=1 THEN
                stWeld1.StatusForArc:=1;
            ELSE
                stWeld1.StatusForArc:=0;
            ENDIF
            IF (nRunningStep{1}<>0) and stCommand="Weld" stWeld1.cpm:=Welds1{nRunningStep{1}}.cpm;
        ENDIF

        IF (nRunningStep{2}<>0) THEN
            stWeld2.WorkingAngle:=EulerZYX(\y,pctWeldPosR2.rot);
            stWeld2.TravelAngle:=EulerZYX(\z,pctWeldPosR2.rot);
            IF siLn2Arc_Est=1 THEN
                stWeld2.StatusForArc:=1;
            ELSE
                stWeld2.StatusForArc:=0;
            ENDIF
            IF (nRunningStep{2}<>0) and stCommand="Weld" stWeld2.cpm:=Welds2{nRunningStep{2}}.cpm;
        ENDIF

        if so_MoveG_PosHold=0 AND bGantryInTrap{1}=TRUE set intReHoldGantry_1;
        if so_MoveG_PosHold=0 AND bGantryInTrap{2}=TRUE set intReHoldGantry_2;

    ENDPROC

    PROC rNotifyHome()
        VAR jointtarget jTemp;
        VAR jointtarget jHomeOffset;
        VAR num nHomej{10};
        VAR bool bCheckHome{10};

        FOR i FROM 1 TO 10 DO
            IF 0.5<Abs(nHomej{i}) THEN
                bCheckHome{i}:=FALSE;
            ELSE
                bCheckHome{i}:=TRUE;
            ENDIF
        ENDFOR
        IF bCheckHome{1}=TRUE AND bCheckHome{2}=TRUE AND bCheckHome{3}=TRUE AND bCheckHome{4}=TRUE AND bCheckHome{5}=TRUE AND bCheckHome{6}=TRUE AND bCheckHome{7}=TRUE AND bCheckHome{8}=TRUE AND bCheckHome{9}=TRUE AND bCheckHome{10}=TRUE THEN
            Set po03_Home;
        ELSE
            Reset po03_Home;
        ENDIF

    ENDPROC

    PROC rMacroNo3_4()
        IF ((stCommand="Weld") OR (stCommand="NoWeld")) AND (1<=nRunningStep{1}) THEN
            IF (nWeldSequence=0) AND stReact{1}="T_ROB1_ArcOn" AND stReact{2}="T_ROB2_ArcOn" then
                nWeldSequence:=1;
              IF bEnableWeldSkip=FALSE set so_MoveG_PosHold;
            ENDIF
            IF (nWeldSequence=1) THEN
                bRqMoveG_PosHold:=TRUE;
                nWeldSequence:=2;
            ENDIF
            IF stReact{1}="T_ROB1_GantryOn" or stReact{2}="T_ROB2_GantryOn" THEN
                nWeldSequence:=3;
               IF bEnableWeldSkip=TRUE AND bso_MoveG_PosHold=FALSE THEN
                   set so_MoveG_PosHold;
                   bso_MoveG_PosHold:=TRUE;
               ENDIF
            ENDIF
            IF ((nWeldSequence=3) AND (bRqMoveG_PosHoldComp=TRUE AND (nOffsetLengthBuffer-1<pctWeldPosR2.trans.x))) nWeldSequence:=4;
        ELSE
            nWeldSequence:=0;
            bRqMoveG_PosHold:=FALSE;
            bRqMoveG_PosHoldComp:=FALSE;
            bso_MoveG_PosHold:=FALSE;
        ENDIF
    ENDPROC

    PROC rMacroNo0_1_2()
        IF ((stCommand="Weld") OR (stCommand="NoWeld")) AND (1<=nRunningStep{1}) THEN
            IF (nWeldSequence=0) AND (pctWeldPosR1.trans.x<50) nWeldSequence:=1;
            IF ((nWeldSequence=1) AND (50<pctWeldPosR1.trans.x)) nWeldSequence:=2;
            IF ((nWeldSequence=2) AND ((nOffsetLengthBuffer<=pctWeldPosR1.trans.x) OR (nOffsetLengthBuffer<=pctWeldPosR2.trans.x))) THEN
                nWeldSequence:=3;
                bRqMoveG_PosHold:=TRUE;
            ENDIF
            IF ((nWeldSequence=3) AND (bRqMoveG_PosHoldComp=TRUE AND (nOffsetLengthBuffer-1<pctWeldPosR2.trans.x))) nWeldSequence:=4;
        ELSE
            nWeldSequence:=0;
            bRqMoveG_PosHold:=FALSE;
            bRqMoveG_PosHoldComp:=FALSE;
        ENDIF
    ENDPROC
ENDMODULE

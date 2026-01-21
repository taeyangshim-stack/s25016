MODULE Gantry_MainModule
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

    PERS tasks taskGroup12{2};
    PERS tasks taskGroup13{2};
    PERS tasks taskGroup23{2};
    PERS tasks taskGroup123{3};
    TASK PERS speeddata vWeld{40}:=[[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200]];
    ! Sync Data
    TASK VAR syncident SynchronizeJGJon{9999};
    TASK VAR syncident SynchronizePGJon{9999};
    TASK VAR syncident SynchronizePGLon{9999};
    TASK VAR syncident SynchronizeJGJoff{9999};
    TASK VAR syncident SynchronizePGJoff{9999};
    TASK VAR syncident SynchronizePGLoff{9999};
    TASK VAR syncident Wait{100};

    PERS string stCommand:="";
    PERS string stReact{3};
    PERS num idSync:=7;
    PERS speeddata vSync;
    PERS zonedata zSync:=[TRUE,0,0,0,0,0,0];

    CONST jointtarget jNull:=[[0,0,0,0,0,0],[0,0,0,0,0,0]];
    PERS jointtarget jGantry;
    PERS targetdata WeldsG{40};
    PERS targetdata Welds1{40};
    PERS num nRunningStep{2};
    PERS num nLimitX_Negative;
    PERS num nLimitX_Positive;
    PERS num nLimitY_Negative;
    PERS num nLimitY_Positive;
    PERS num nLimitZ_Negative;
    PERS num nLimitZ_Positive;
    PERS num nLimitR_Negative;
    PERS num nLimitR_Positive;
    PERS num nHomeGantryX;
    PERS num nHomeGantryY;
    PERS num nHomeGantryZ;
    PERS num nHomeGantryR;
    PERS num nHomeAdjustX;
    PERS num nHomeAdjustY;
    PERS num nHomeAdjustZ;
    PERS num nHomeAdjustR;
    PERS num nRobHeightMin;
    PERS num nWeldSequence;

    PERS num nMotionStartStepLast{2};
    PERS bool bRqMoveG_PosHoldComp;
    PERS bool bRqMoveG_PosHold;

    !coll
    PERS speeddata vTargetSpeed;
    PERS bool bGanTry_Last_pos;
    PERS bool bTouch_last_R1_Comp;
    PERS bool bTouch_last_R2_Comp;
    PERS bool bGanTry_First_pos;
    PERS bool bTouch_First_R1_Comp;
    PERS bool bTouch_First_R2_Comp;
    PERS jointtarget jCorrTouchGantry_Start;
    PERS jointtarget jCorrTouchGantry_End;
    TASK var intnum iMoveHome_Gantry;
    PERS bool bMoveHome_Gantry;
    PERS num nMacro010{2}:=[4,4];
    PERS num nMacro001{2}:=[4,4];
    PERS num nMoveid;


    TRAP trapMoveHome_Gantry
        IDelete iMoveHome_Gantry;
        reset intMoveHome_Gantry;
        rMoveHome_Gantry;
    ENDTRAP

    FUNC jointtarget fnCoordToJoint(jointtarget joint)
        VAR jointtarget result;

        !!! [x1,y,z,r,9E+09,x2] -> [eax_a,eax_b,eax_c,eax_d,eax_e,eax_f] !!!
        result:=joint;

        result.extax.eax_a:=Limit(nLimitX_Negative,nLimitX_Positive,nHomeGantryX+joint.extax.eax_a);
        result.extax.eax_b:=Limit(nLimitY_Negative,nLimitY_Positive,nHomeGantryY-joint.extax.eax_b);
        result.extax.eax_c:=Limit(nLimitZ_Negative,nLimitZ_Positive-nRobHeightMin,nHomeGantryZ-joint.extax.eax_c);
        result.extax.eax_d:=Limit(nLimitR_Negative,nLimitR_Positive,nHomeGantryR-joint.extax.eax_d);
        result.extax.eax_e:=9E+09;
        result.extax.eax_f:=result.extax.eax_a;

        RETURN result;
    ENDFUNC

    FUNC jointtarget fnPoseToExtax(robtarget RobT)
        VAR jointtarget result;

        !!! [x,y,z],[q1,q2,q3,q4] -> [eax_a,eax_b,eax_c,eax_d,eax_e,eax_f] !!!
        result:=jNull;

        result.extax.eax_a:=RobT.trans.x;
        result.extax.eax_b:=RobT.trans.y;
        result.extax.eax_c:=RobT.trans.z;
        result.extax.eax_d:=EulerZYX(\Z,RobT.rot);
        result.extax.eax_e:=9E+09;
        result.extax.eax_f:=result.extax.eax_a;

        RETURN result;
    ENDFUNC

    FUNC num Limit(num Min,num Max,num Target)
        VAR num result;

        result:=Target;
        IF Target<Min result:=Min;
        IF Max<Target result:=Max;

        RETURN result;
    ENDFUNC

    PROC main()
        rInit;

        WHILE TRUE DO
            WaitUntil stCommand<>"";
            TEST stCommand
            CASE "MoveJgJ","MovePgJ","MovePgL":
                !                WaitSyncTask Wait{1},taskGroup123;
                SyncMoveOn SynchronizeJGJon{nMoveid+2},taskGroup123;
                MoveExtJ jGantry\ID:=nMoveid+3,vSync,zSync;
                SyncMoveOff SynchronizeJGJoff{nMoveid+4};
                stReact{3}:="Ack";
                WaitUntil stCommand="";
                stReact{3}:="Ready";
            CASE "Weld","NoWeld":
                IDelete iMoveHome_Gantry;
                reset intMoveHome_Gantry;
                CONNECT iMoveHome_Gantry WITH trapMoveHome_Gantry;
                ISignalDO intMoveHome_Gantry,1,iMoveHome_Gantry;

                rWeld;

                IDelete iMoveHome_Gantry;
            CASE "CorrSearchStartEnd":
                rCorrSearchStartEnd;
            CASE "WireCutR1":
                WaitUntil stCommand="";
                stReact{3}:="Ready";
            CASE "WireCutR2":
                WaitUntil stCommand="";
                stReact{3}:="Ready";
            CASE "WireCutR1_R2":
                WaitUntil stCommand="";
                stReact{3}:="Ready";   
                
            CASE "WireCutShotR1":
                WaitUntil stCommand="";
                stReact{3}:="Ready";
            CASE "WireCutShotR2":
                WaitUntil stCommand="";
                stReact{3}:="Ready";
            CASE "WireCutShotR1_R2":
                WaitUntil stCommand="";
                stReact{3}:="Ready";                
            CASE "WireCutMoveR1":
                WaitUntil stCommand="";
                stReact{3}:="Ready";
            CASE "WireCutMoveR2":
                WaitUntil stCommand="";
                stReact{3}:="Ready";
            CASE "WireCutMoveR1_R2":
                WaitUntil stCommand="";
                stReact{3}:="Ready";                                
            CASE "checkpos":
                stReact{3}:="checkposok";
                WaitUntil stCommand="";
                stReact{3}:="Ready";
            DEFAULT:
                stReact{3}:="Error";
                Stop;
            ENDTEST
        ENDWHILE
    ENDPROC

    PROC rInit()
        AccSet 20,20;
        stReact{3}:="";
        WaitUntil stCommand="";
        stReact{3}:="Ready";
        IDelete iMoveHome_Gantry;
        reset intMoveHome_Gantry;
        RETURN ;
        MoveAbsJ [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[0,0,0,0,9E+09,0]]\NoEOffs,v1000,z50,tool0;
    ENDPROC

    PROC rWeld()
        VAR jointtarget jTempGantry{2};
        VAR num nTempMmps;

        FOR i FROM 1 TO 40 DO
            !===========================================================!
            !!! [mm/sec] = [cm/sec]*10 = [cm/min]*10/60 = [cm/min]/6  !!!
            !===========================================================!
            !            nTempMmps:=Welds1{nRunningStep{1}}.cpm/6;
            nTempMmps:=Welds1{1}.cpm/6;
            vWeld{i}:=[nTempMmps,200,nTempMmps,200];
        ENDFOR

        jTempGantry{1}:=fnCoordToJoint(fnPoseToExtax(WeldsG{1}.position));
        jTempGantry{2}:=fnCoordToJoint(fnPoseToExtax(WeldsG{2}.position));
        WaitRob\ZeroSpeed;
        WaitSyncTask Wait{20},taskGroup123;
        !!!====== Gantry Start Pos
        MoveExtJ jTempGantry{1},vTargetSpeed,fine;
        !!!====== Gantry Start Pos
        AccSet 10,10;
        IF (nMacro010{1}=3 AND nMacro010{2}=3) OR (nMacro010{1}=4 AND nMacro010{2}=4) THEN
            WaitUntil nWeldSequence=3;
        ELSE
            WaitUntil nWeldSequence=3 AND nRunningStep{2}>=nMotionStartStepLast{2};
        ENDIF
        !        Set so_MoveG_PosHold;
        !!!!=====Gantry Start Delay===========!!!!!
        IF ((nMacro010{1}=3 AND nMacro010{2}=3) OR (nMacro010{1}=4 AND nMacro010{2}=4)) THEN
        ELSE
            WaitTime 0.3;
        ENDIF
        !!!==================================!!!!!
        MoveExtJ jTempGantry{2},vWeld{2},fine;
        Reset so_MoveG_PosHold;
        !!! Gantry End Pos
        !        WaitRob \ZeroSpeed;
        WaitRob\inpos;
        bRqMoveG_PosHoldComp:=TRUE;
        !!!!=====Gantry Stop Delay===========!!!!!
        IF ((nMacro010{1}=3 AND nMacro010{2}=3) OR (nMacro010{1}=4 AND nMacro010{2}=4)) THEN
            !        WaitTime 0.1;
        ELSE
            WaitTime 0.1;
        ENDIF
        !!!==================================!!!!!

        stReact{3}:="WeldOk";
        WaitUntil stCommand="";
        stReact{3}:="Ready";
        AccSet 20,20;
        RETURN ;
    ENDPROC

    PROC rCorrSearchStartEnd()
        VAR jointtarget jTempGantry{2};
        VAR jointtarget jtemp;

        jTempGantry{1}:=fnCoordToJoint(fnPoseToExtax(WeldsG{1}.position));
        jTempGantry{2}:=fnCoordToJoint(fnPoseToExtax(WeldsG{2}.position));
        WaitRob\ZeroSpeed;
        WaitSyncTask Wait{20},taskGroup123;

        jtemp:=jTempGantry{2};
        MoveExtJ jtemp,vTargetSpeed,fine;

        bGanTry_Last_pos:=TRUE;
        bGanTry_First_pos:=False;
        WaitUntil((bTouch_last_R1_Comp=TRUE) AND (bTouch_last_R2_Comp=TRUE)) OR (stReact{1}="Error_Arc_Touch" OR stReact{2}="Error_Arc_Touch");
        IF (stReact{1}="Error_Arc_Touch" OR stReact{2}="Error_Arc_Touch") rMoveHome_Gantry;
        Waittime 0.5;

        jtemp:=jTempGantry{1};
        MoveExtJ jtemp,vTargetSpeed,fine;

        bGanTry_Last_pos:=False;
        bGanTry_First_pos:=TRUE;
        WaitUntil(bTouch_First_R1_Comp=TRUE) AND (bTouch_First_R2_Comp=TRUE) OR (stReact{1}="Error_Arc_Touch" OR stReact{2}="Error_Arc_Touch");
        IF (stReact{1}="Error_Arc_Touch" OR stReact{2}="Error_Arc_Touch") rMoveHome_Gantry;
        waittime 0.5;
        bTouch_last_R1_Comp:=FALSE;
        bTouch_last_R2_Comp:=FALSE;
        bTouch_First_R1_Comp:=FALSE;
        bTouch_First_R2_Comp:=FALSE;
        bGanTry_Last_pos:=FALSE;
        bGanTry_First_pos:=FALSE;
        stReact{3}:="CorrSearchOK";
        WaitUntil stCommand="";
        stReact{3}:="Ready";

    ENDPROC

    PROC rMoveHome_Gantry()
        StopMove;
        ClearPath;
        StartMove;
        stReact{3}:="Error_Arc_Touch";
        WaitSyncTask Wait{80},taskGroup123;

        WaitUntil stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
        WaitSyncTask Wait{81},taskGroup123;

        WaitUntil stCommand="Error_Arc_Touch";
        stReact{3}:="";
        WaitUntil stCommand="";
        WaitSyncTask Wait{82},taskGroup123;
        ExitCycle;
    ENDPROC

ENDMODULE
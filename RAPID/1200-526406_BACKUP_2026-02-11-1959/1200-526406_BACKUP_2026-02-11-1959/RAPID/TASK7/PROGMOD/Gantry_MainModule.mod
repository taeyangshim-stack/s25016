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
    TASK PERS speeddata vWeld{40}:=[[10,200,10,200],[10,200,10,200],[9.80858,200,9.80858,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200],[10,200,10,200]];
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
    PERS zonedata zSync:=[FALSE,200,300,300,30,300,30];

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
    PERS num nMode:=3;
    PERS num nCount_PATHSTOP:=0;

    !LdsCheck
    PERS bool bEnableLdsX:=FALSE;
    PERS num nLdsX_DefinedDiff:=20;
    PERS num nLdsX_Length;
    PERS num nLdsX_LastLength:=600.85;
    PERS bool bLdsX_EdgeChk;

    PERS bool bEnableLdsZ:=FALSE;
    PERS num nLdsZ_DefinedDiff:=20;
    PERS num nLdsZ_Length;
    PERS num nLdsZ_LastLength:=610.31;
    PERS bool bLdsZ_EdgeChk;

    PERS num nLDS_SaveX{2}:=[0,0];
    PERS num nLDS_SaveZ{2}:=[0,0];

    VAR bool skipHomming:=FALSE;
    VAR bool bLDS_Origin;
    VAR num nLDS_Divide;

    PERS num nInspectGantryX{2}:=[7178.18,7178.38];
    PERS num nInspectGantryY{2}:=[569.71,569.63];
    PERS num nInspectGantryZ{2}:=[475.415,475.436];

    PERS num nReferenceLazerX{2}:=[562.69,564.06];
    PERS num nReferenceLazerZ{2}:=[569.91,569.85];

    PERS num nDiffGantryX:=0;
    PERS num nDiffGantryY:=0;
    PERS num nDiffGantryZ:=0;
    
    PERS bool bLDSCheckScss;

    TRAP trapMoveHome_Gantry
        IDelete iMoveHome_Gantry;
        reset intMoveHome_Gantry;
        rMoveHome_Gantry;
    ENDTRAP

    FUNC jointtarget fnCoordToJoint(jointtarget joint)
        VAR jointtarget result;

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
        main:
        rInit;

        WHILE TRUE DO
            WaitUntil stCommand<>"";
            TEST stCommand
            CASE "MoveJgJ","MovePgJ","MovePgL":
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
            CASE "Weld1":
                IDelete iMoveHome_Gantry;
                reset intMoveHome_Gantry;
                CONNECT iMoveHome_Gantry WITH trapMoveHome_Gantry;
                ISignalDO intMoveHome_Gantry,1,iMoveHome_Gantry;
                rWeldAlone1;
                IDelete iMoveHome_Gantry;
            CASE "Weld2":
                IDelete iMoveHome_Gantry;
                reset intMoveHome_Gantry;
                CONNECT iMoveHome_Gantry WITH trapMoveHome_Gantry;
                ISignalDO intMoveHome_Gantry,1,iMoveHome_Gantry;
                rWeldAlone2;
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

            CASE "LdsCheck":
                rLDS_check;
                stReact{3}:="LdsCheck_Ok";
                WaitUntil stCommand="";
                stReact{3}:="Ready";
                
            CASE "TeachingWirecut_R1","TeachingWirecut_R2","TeachingWirecutEntry_R1","TeachingWirecutEntry_R2":
                stReact{3}:="WorkComplete";
                WaitUntil stCommand="";
                stReact{3}:="Ready";
                WaitUntil stReact=["Ready","Ready","Ready"];                  
                
            CASE "MoveToTcp":
                stReact{3}:="MoveToTcp_Ok";
                WaitUntil stCommand="";
                stReact{3}:="Ready";
                
            CASE "NozzleClean_R1","NozzleClean_R2":
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
    ENDPROC

    PROC rWeld()
        ! from.HJB251202
        VAR jointtarget jTempGantry{4};
        VAR num nTempMmps;
        VAR num nTempMmps_re;
        VAR extjoint JGantryWeldStopOffset:=[0.1,0,0,0,0,0];
        nTempMmps:=Welds1{6}.cpm/6;
        vWeld{2}:=[nTempMmps,200,nTempMmps,200];
        nTempMmps_re:=CalcGantrySpeed_ToSumBand(Vectmagn(WeldsG{1}.position.trans-WeldsG{2}.position.trans),nTempMmps,50,nTempMmps,0.01,10);
        IF nTempMmps_re<6.67 THEN
            nTempMmps_re:=10;
        ENDIF
        vWeld{3}:=[nTempMmps_re,200,nTempMmps_re,200];
        jTempGantry{1}:=fnCoordToJoint(fnPoseToExtax(WeldsG{1}.position));
        jTempGantry{2}:=fnCoordToJoint(fnPoseToExtax(WeldsG{2}.position));

        WaitRob\ZeroSpeed;
        WaitSyncTask Wait{20},taskGroup123;
        MoveExtJ jTempGantry{1},vTargetSpeed,fine;
        AccSet 10,10;
        ArcMoveExtJ jTempGantry{1},vWeld{1},fine;
        SyncMoveOn wait{22},taskGroup123;
        ArcMoveExtJ jTempGantry{1}\ID:=50,vWeld{1},z0;
        ArcMoveExtJ jTempGantry{1}\ID:=51,vWeld{1},z0;
        ArcMoveExtJ jTempGantry{2}\ID:=60,vWeld{3},z0;
        ArcMoveExtJ jTempGantry{2}\ID:=61,vWeld{2},z0;
        SyncMoveOff wait{23};
        ArcMoveExtJ jTempGantry{2},vWeld{2},fine;
        
        stReact{3}:="WeldOk";
        WaitUntil stCommand="";
        stReact{3}:="Ready";
        AccSet 20,20;
    ERROR
        IF ERRNO=ERR_PATH_STOP THEN
            StopMove;
            StartMove;
	    PulseDO\high\PLength:=0.5,sdo_T_Rob1_StopProc;
            PulseDO\high\PLength:=0.5,sdo_T_Rob2_StopProc;
            rMoveHome_Gantry;
        ENDIF
    ENDPROC

    PROC rWeldAlone1()
        ! from.HJB251202
        VAR jointtarget jTempGantry{4};
        VAR num nTempMmps;
        VAR extjoint JGantryWeldStopOffset:=[0.1,0,0,0,0,0];
        FOR i FROM 1 TO 40 DO
            nTempMmps:=10;
            vWeld{i}:=[nTempMmps,200,nTempMmps,200];
        ENDFOR

        jTempGantry{1}:=fnCoordToJoint(fnPoseToExtax(WeldsG{1}.position));
        jTempGantry{2}:=fnCoordToJoint(fnPoseToExtax(WeldsG{2}.position));
        WaitRob\ZeroSpeed;
        WaitSyncTask Wait{20},taskGroup13;
        MoveExtJ jTempGantry{1},vTargetSpeed,fine;
        AccSet 10,10;
        SyncMoveOn wait{22},taskGroup13;
        ArcMoveExtJ jTempGantry{1}\ID:=10,vWeld{1},fine;
        ArcMoveExtJ jTempGantry{1}\ID:=20,vWeld{1},z0;
        ArcMoveExtJ jTempGantry{1}\ID:=30,vWeld{1},z0;
        ArcMoveExtJ jTempGantry{1}\ID:=40,vWeld{1},z0;
        ArcMoveExtJ jTempGantry{1}\ID:=50,vWeld{1},z0;
        ArcMoveExtJ jTempGantry{1}\ID:=51,vWeld{1},z0;
        ArcMoveExtJ jTempGantry{2}\ID:=60,vWeld{2},z0;
        ArcMoveExtJ jTempGantry{2}\ID:=61,vWeld{2},z0;
        ArcMoveExtJ jTempGantry{2}\ID:=70,vWeld{2},z0;
        ArcMoveExtJ jTempGantry{2}\ID:=80,vWeld{2},z0;
        ArcMoveExtJ jTempGantry{2}\ID:=90,vWeld{2},z0;
        ArcMoveExtJ jTempGantry{2}\ID:=100,vWeld{2},fine;
        SyncMoveOff wait{23};
        stReact{3}:="WeldOk";
        WaitUntil stCommand="";
        stReact{3}:="Ready";
        AccSet 20,20;
    ERROR
        IF ERRNO=ERR_PATH_STOP THEN
            StopMove;
            nCount_PATHSTOP:=nCount_PATHSTOP+1;
            StorePath\KeepSync;
            WaitTime 1;
            RestoPath;
            StartMove;
        ENDIF
    ENDPROC
    

    PROC rWeldAlone2()
        ! from.HJB251202
        VAR jointtarget jTempGantry{4};
        VAR num nTempMmps;
        VAR extjoint JGantryWeldStopOffset:=[0.1,0,0,0,0,0];
        FOR i FROM 1 TO 40 DO
            nTempMmps:=10;
            vWeld{i}:=[nTempMmps,200,nTempMmps,200];
        ENDFOR

        jTempGantry{1}:=fnCoordToJoint(fnPoseToExtax(WeldsG{1}.position));
        jTempGantry{2}:=fnCoordToJoint(fnPoseToExtax(WeldsG{2}.position));
  
        WaitRob\ZeroSpeed;
        WaitSyncTask Wait{20},taskGroup23;
        MoveExtJ jTempGantry{1},vTargetSpeed,fine;
        AccSet 10,10;
        SyncMoveOn wait{22},taskGroup23;

        ArcMoveExtJ jTempGantry{1}\ID:=10,vWeld{1},fine;
        ArcMoveExtJ jTempGantry{1}\ID:=20,vWeld{1},z0;
        ArcMoveExtJ jTempGantry{1}\ID:=30,vWeld{1},z0;
        ArcMoveExtJ jTempGantry{1}\ID:=40,vWeld{1},z0;
        ArcMoveExtJ jTempGantry{1}\ID:=50,vWeld{1},z0;
        ArcMoveExtJ jTempGantry{1}\ID:=51,vWeld{1},z0;
        ArcMoveExtJ jTempGantry{2}\ID:=60,vWeld{2},z0;
        ArcMoveExtJ jTempGantry{2}\ID:=61,vWeld{2},z0;
        ArcMoveExtJ jTempGantry{2}\ID:=70,vWeld{2},z0;
        ArcMoveExtJ jTempGantry{2}\ID:=80,vWeld{2},z0;
        ArcMoveExtJ jTempGantry{2}\ID:=90,vWeld{2},z0;
        ArcMoveExtJ jTempGantry{2}\ID:=100,vWeld{2},fine;
        SyncMoveOff wait{23};
        stReact{3}:="WeldOk";
        WaitUntil stCommand="";
        stReact{3}:="Ready";
        AccSet 20,20;
    ERROR
        IF ERRNO=ERR_PATH_STOP THEN
            StopMove;
            nCount_PATHSTOP:=nCount_PATHSTOP+1;
            StorePath\KeepSync;
            WaitTime 1;
            RestoPath;
            StartMove;
        ENDIF
    ENDPROC

    PROC rCorrSearchStartEnd()
        VAR jointtarget jTempGantry{2};
        VAR jointtarget jtemp;

        jTempGantry{1}:=fnCoordToJoint(fnPoseToExtax(WeldsG{1}.position));
        jTempGantry{2}:=fnCoordToJoint(fnPoseToExtax(WeldsG{2}.position));
        WaitRob\ZeroSpeed;
        IF nMode=1 THEN
            WaitSyncTask Wait{20},taskGroup13;
        ELSEIF nMode=2 THEN
            WaitSyncTask Wait{20},taskGroup23;
        ELSE
            WaitSyncTask Wait{20},taskGroup123;
        ENDIF
        WHILE bGanTry_First_pos=FALSE AND bTouch_last_R2_Comp=FALSE DO
            jtemp:=jTempGantry{2};
            MoveExtJ jtemp,vTargetSpeed,fine;

            bGanTry_Last_pos:=TRUE;
            WaitUntil((bTouch_last_R1_Comp=TRUE) AND (bTouch_last_R2_Comp=TRUE)) OR (stReact{1}="Error_Arc_Touch" OR stReact{2}="Error_Arc_Touch");
            IF (stReact{1}="Error_Arc_Touch" OR stReact{2}="Error_Arc_Touch") rMoveHome_Gantry;
            Waittime 0.5;

            jtemp:=jTempGantry{1};
            MoveExtJ jtemp,vTargetSpeed,fine;

            bGanTry_First_pos:=TRUE;
        ENDWHILE
        WaitUntil(bTouch_First_R1_Comp=TRUE) AND (bTouch_First_R2_Comp=TRUE) OR (stReact{1}="Error_Arc_Touch" OR stReact{2}="Error_Arc_Touch");
        IF (stReact{1}="Error_Arc_Touch" OR stReact{2}="Error_Arc_Touch") rMoveHome_Gantry;
        waittime 0.5;
        stReact{3}:="CorrSearchOK";
        WaitUntil stCommand="";
        stReact{3}:="Ready";
        bGanTry_Last_pos:=FALSE;
        bGanTry_First_pos:=FALSE;
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

    PROC rLDS_check()
        VAR jointtarget jTemp;
        VAR speeddata sLdsSpeed;
        VAR speeddata sLdsCheckSpeed;
        VAR speeddata sLdsSearchSpeed;
        VAR jointtarget jstartX;
        VAR jointtarget jEndX;
        VAR jointtarget jstartZ;
        VAR jointtarget jEndZ;
        VAR jointtarget jStartY;


        sLdsSpeed:=[300,300,300,25];
        sLdsCheckSpeed:=[25,25,25,25];
        sLdsSearchSpeed:=[5,5,5,5];

        jstartX:=jLDS_Start_TartgetX;
        jEndX:=jLDS_End_TartgetX;
        jstartZ:=jLDS_Start_TartgetZ;
        jEndZ:=jLDS_End_TartgetZ;
        jStartY:=jLDS_End_TartgetZ;

        bLDS_Origin:=FALSE;
        IF bLDS_Origin=TRUE THEN
            nLDS_Divide:=1;
        ELSE
            nLDS_Divide:=2;
        ENDIF
        
        bLDSCheckScss:=FALSE;
                LabalReturn:
        !=========================================
        !LDS_Start Pos X
        !=========================================
        TPWrite "Robot will Start measuring X position";
        MoveExtJ jstartX,sLdsSpeed,fine;
        WaitRob\ZeroSpeed;
        !LDS_Start X
        bEnableLdsX:=TRUE;
        WaitTime 1;
        nLdsX_Length:=0;
        WaitUntil nLdsX_Length>0;
        nLdsX_LastLength:=nLdsX_Length;
        bEnableLdsX:=FALSE;

        WaitTime 1;
        bEnableLdsX:=TRUE;
        bEnableLdsZ:=FALSE;
        bLdsX_EdgeChk:=FALSE;
        WaitTime 1;

        SearchExtJ\Stop,bLdsX_EdgeChk,jstartX,jEndX,sLdsSearchSpeed;
        bEnableLdsX:=FALSE;
        bEnableLdsZ:=FALSE;
        jTemp:=CJointT();
        WaitRob\ZeroSpeed;
        nInspectGantryX{nLDS_Divide}:=jTemp.extax.eax_a;
        nReferenceLazerX{nLDS_Divide}:=nLdsX_Length;
        IF bLDS_Origin=TRUE THEN
            nDiffGantryX:=0;
        ELSE
            nDiffGantryX:=nInspectGantryX{2}-nInspectGantryX{1};
        ENDIF
        TPWrite "Measurement Value X: "+ValToStr(nReferenceLazerX{nLDS_Divide});
        TPWrite "Triggerd position X: "+ValToStr(nInspectGantryX{nLDS_Divide});


        !=========================================
        !LDS_Start Pos Z
        !=========================================
        MoveExtJ jstartZ,sLdsCheckSpeed,fine;
        WaitRob\ZeroSpeed;
        TPWrite "Robot will Start measuring Z position";
        !LDS_Start Z
        WaitTime 1;
        bEnableLdsZ:=TRUE;
        WaitTime 1;
        nLdsZ_Length:=0;
        WaitUntil nLdsZ_Length>0;
        nLdsZ_LastLength:=nLdsZ_Length;
        bEnableLdsZ:=FALSE;

        WaitTime 1;
        bEnableLdsX:=FALSE;
        bEnableLdsZ:=TRUE;
        bLdsZ_EdgeChk:=FALSE;
        WaitTime 1;

        SearchExtJ\Stop,bLdsZ_EdgeChk,jstartZ,jEndZ,sLdsSearchSpeed;
        bEnableLdsX:=FALSE;
        bEnableLdsZ:=FALSE;
        jTemp:=CJointT();
        WaitRob\ZeroSpeed;
        nInspectGantryZ{nLDS_Divide}:=jTemp.extax.eax_c;
        nReferenceLazerZ{nLDS_Divide}:=nLdsZ_Length;
        IF bLDS_Origin=TRUE THEN
            nDiffGantryZ:=0;
        ELSE
            nDiffGantryZ:=nInspectGantryZ{2}-nInspectGantryZ{1};
        ENDIF
        TPWrite "Measurement Value Z: "+ValToStr(nReferenceLazerZ{nLDS_Divide});
        TPWrite "Triggerd position Z: "+ValToStr(nInspectGantryZ{nLDS_Divide});


        !=========================================
        !LDS_Start Pos Y
        !=========================================
        MoveExtJ jStartY,sLdsCheckSpeed,fine;
        TPWrite "Robot will Start measuring Y position";
        WaitRob\ZeroSpeed;
        WaitTime 1;
        nLdsZ_Length:=0;
        bEnableLdsX:=FALSE;
        bEnableLdsZ:=TRUE;
        WaitTime 1;
        !LDS_Start Y
        nInspectGantryY{nLDS_Divide}:=nLdsZ_Length;
        IF bLDS_Origin=TRUE THEN
            nDiffGantryY:=0;
        ELSE
            nDiffGantryY:=nInspectGantryY{2}-nInspectGantryY{1};
        ENDIF
        TPWrite "Measurement Value Y: "+ValToStr(nInspectGantryY{nLDS_Divide});
        bEnableLdsX:=FALSE;
        bEnableLdsZ:=FALSE;
        nLdsZ_Length:=0;

        !=========================================
        !LDS_Value_Display
        !=========================================
        TPWrite "X triggerd position: "+ValToStr(nInspectGantryX{nLDS_Divide});
        TPWrite "Z triggerd position: "+ValToStr(nInspectGantryZ{nLDS_Divide});
        TPWrite "Measurement Value X: "+ValToStr(nReferenceLazerX{nLDS_Divide});
        TPWrite "Measurement Value Y: "+ValToStr(nInspectGantryY{nLDS_Divide});
        TPWrite "Measurement Value Z: "+ValToStr(nReferenceLazerZ{nLDS_Divide});

        bLDSCheckScss:=TRUE;
        
        RETURN ;

        jLDS_Start_TartgetX.robax:=[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09];
        jLDS_end_TartgetX.robax:=[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09];
        jLDS_Start_TartgetZ.robax:=[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09];
        jLDS_end_TartgetZ.robax:=[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09];


        MoveExtJ jLDS_Start_TartgetX,v200,fine;
        MoveExtJ jLDS_end_TartgetX,v200,fine;
        MoveExtJ jLDS_Start_TartgetZ,v200,fine;
        MoveExtJ jLDS_end_TartgetZ,v200,fine;

        RETURN ;
        ERROR
            IF ERRNO=ERR_WHLSEARCH then ErrLog 4811,"LDS_OutRangeError","","","","";
            ELSE RAISE ERRNO;
            endif
    ENDPROC

    FUNC num CalcGantrySpeed_ToSumBand(
    num Dg,
    num Vg_init,
    num Dr,
    num SumTarget,
    num eps,
    num maxIter)
        VAR num Vg;
        VAR num Vg_new;
        VAR num t;
        VAR num Vr;
        VAR num sum;
        VAR num k;
        VAR num i;
        VAR num denom;
        VAR num err;

        Vg:=Vg_init;

        IF Dg<=0.000001 THEN
            RETURN 0;
        ENDIF
        k:=Dr/Dg;
        denom:=1+k;

        FOR i FROM 1 TO maxIter DO

            IF Vg<0.000001 THEN
                Vg:=0.000001;
            ENDIF
            t:=Dg/Vg;
            Vr:=Dr/t;
            sum:=Vg+Vr;
            err:=sum-SumTarget;
            IF Abs(err)<=eps THEN
                RETURN Vg;
            ENDIF

            Vg_new:=Vg-(err/denom);

            IF Vg_new<0 THEN
                Vg_new:=0;
            ENDIF
            Vg:=Vg_new;
        ENDFOR
        RETURN Vg;
    ENDFUNC




ENDMODULE
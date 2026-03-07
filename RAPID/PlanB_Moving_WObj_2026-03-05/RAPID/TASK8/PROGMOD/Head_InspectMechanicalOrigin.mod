MODULE Head_InspectMechanicalOrigin

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
    !! Hole Sensor
    VAR socketdev HoleComSocket;

    PERS num nRefHoleY{2}:=[-0.5,-8];
    PERS num nInspectHoleY{2}:=[-0.47,-7.98];
    PERS num nHoleDiffY:=0;

    !! LDS Trigger direction
    PERS bool X_neg_dir:=FALSE;
    PERS bool Z_neg_dir:=FALSE;

    PERS num nReferenceLazerX{2}:=[562.69,564.06];

    PERS num nReferenceLazerZ{2}:=[569.91,569.85];
    PERS robtarget pLDS_Start_TartgetX{2}:=[[[21013.8,6000,1353.04],[8.96324E-07,-0.707108,1.6634E-06,-0.707106],[0,0,0,2],[9632.8,9632.8,0,955.856,9E+09,9E+09]],[[2890.02,100,1162],[0.0422833,-0.258583,-0.964997,0.0113281],[0,0,0,0],[2187.42,2187.42,100,1214.35,9E+09,9E+09]]];
    PERS robtarget pLDS_end_TartgetX{2}:=[[[21100.4,6000,1353.04],[8.96324E-07,-0.707108,1.6634E-06,-0.707106],[0,0,0,2],[9719.38,9719.38,0,955.856,9E+09,9E+09]],[[2866.06,100,1162],[0.0422625,-0.258585,-0.964997,0.0113226],[0,0,0,0],[2163.43,2163.43,100,1214.35,9E+09,9E+09]]];
    PERS jointtarget jLDS_Start_TartgetX:=[[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[7220,5300,610.53,1.78433E-06,9E+09,7220]];
    PERS jointtarget jLDS_end_TartgetX:=[[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[7140,5300,610.53,1.78433E-06,9E+09,7140]];
    PERS robtarget pLDS_Reference_TargetY:=[[2789.25,100.00,1128.42],[0.0421325,-0.258571,-0.965007,0.0112881],[0,-1,0,0],[2086.53,2086.53,100,1180.58,9E+09,9E+09]];
    PERS jointtarget jLDS_Reference_TargetY;
    PERS robtarget pLDS_Start_TartgetZ{2}:=[[[21161,6000,1379.3],[8.96324E-07,-0.707108,1.6634E-06,-0.707106],[0,0,0,2],[9780,9780,0,929.601,9E+09,9E+09]],[[2898.05,100,1283.8],[0.0420981,-0.25854,-0.965017,0.0112751],[0,0,0,0],[2195.29,2195.29,100,1335.92,9E+09,9E+09]]];
    PERS robtarget pLDS_end_TartgetZ{2}:=[[[21161,6000,1307.82],[8.96324E-07,-0.707108,1.6634E-06,-0.707106],[0,0,0,2],[9780,9780,0,1001.08,9E+09,9E+09]],[[2898.05,100,1257.87],[0.0420839,-0.258538,-0.965018,0.011272],[0,0,0,0],[2195.29,2195.29,100,1309.98,9E+09,9E+09]]];
    PERS jointtarget jLDS_Start_TartgetZ:=[[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[7068.27,5300,435,1.78433E-06,9E+09,7068.27]];
    PERS jointtarget jLDS_end_TartgetZ:=[[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[7068.27,5300,515,1.78433E-06,9E+09,7068.27]];
    PERS robtarget pLDS_Position:=[[2167.88,473.39,1999.22],[0.494771,-0.259313,0.519538,0.646559],[0,0,0,1],[2133.87,2133.87,159.509,1203.37,9E+09,9E+09]];


    !!debug !!
    PERS num X_triggered_pos{2,5};
    PERS num X_LDS_val{2,5};

    PERS num Z_triggered_pos{2,5};
    PERS num Z_LDS_val{2,5};
    PERS num Z_triggered_pos_r{2,5};
    PERS num Z_LDS_val_r{2,5};

    PERS num Y_distance{2,5};
    PERS num Y_distance_r{2,5};

    VAR string sReceiveData;


    func bool rHoleConnectSocket(string IP_Address,num nPort)
        VAR num state;
        state:=SocketGetStatus(HoleComSocket);
        IF state=SOCKET_CONNECTED THEN
            RETURN FALSE;
        ENDIF

        SocketClose HoleComSocket;
        WaitTime 0.2;
        SocketCreate HoleComSocket;
        WaitTime 0.2;
        SocketConnect HoleComSocket,IP_Address,nPort\Time:=5;

        TPErase;
        TPWrite "Socket Connected";
        WaitTime 1;

        sReceiveData:="";
        SocketSend HoleComSocket\Str:="+";
        WaitTime 0.2;
        SocketReceive HoleComSocket\Str:=sReceiveData\ReadNoOfBytes:=24;
        !SocketSend HoleComSocket\Str:="-";
        SocketClose HoleComSocket;

        RETURN TRUE;
    ERROR
        IF ERRNO=ERR_SOCK_TIMEOUT THEN
            TPErase;
            TPWrite "SOCKET CONNECT ERROR";
        ENDIF
        return FALSE;
    ENDFUNC

    PROC rHole_check_X()
        CONST string HoleCameraIP{2}:=["192.168.125.121","192.168.125.122"];
        CONST num HoleCameraPort:=10000;
        VAR bool bCheck:=FALSE;
        VAR bool bCheck_X:=FALSE;
        VAR bool bCheck_Y:=FALSE;

        VAR string X_pos;
        VAR string Y_pos;
        VAR num i:=1;
        VAR num defualt_nHomeAdjustX:=0;
        VAR num defualt_nHomeAdjustY:=0;
        VAR num defualt_nHomeAdjustZ:=0;

        VAR bool bCheckSencorValid:=True;

        !        defualt_nHomeAdjustX:=nHomeAdjustX;
        !        defualt_nHomeAdjustY:=nHomeAdjustY;
        !        defualt_nHomeAdjustZ:=nHomeAdjustZ;

        !        nHomeAdjustX:=0;
        !        nHomeAdjustY:=0;
        !        nHomeAdjustZ:=0;

        rMoveToHoleCheck;
        bHoleCheckScss:=FALSE;
        WHILE bCheckSencorValid=True AND i<3 DO
            WHILE bCheck=FALSE and bCheckSencorValid=True DO
                bCheckSencorValid:=rHoleConnectSocket(HoleCameraIP{i},HoleCameraPort);
                IF bCheckSencorValid then
                    IF StrPart(sReceiveData,10,1)="1" then
                        bCheckSencorValid:=True;
                    ELSE
                        bCheckSencorValid:=FALSE;
                    ENDIF
                    IF bCheckSencorValid THEN
                X_pos:=StrPart(sReceiveData,12,6);
                Y_pos:=StrPart(sReceiveData,19,6);

                bCheck_X:=StrToVal(X_pos,nInspectHoleX{i});
                bCheck_Y:=StrToVal(Y_pos,nInspectHoleY{i});
                        bCheck:= not (bCheck_X AND bCheck_Y);
                        IF bCheck bCheckSencorValid:=FALSE;
                    ENDIF
                ENDIF
            ENDWHILE
            bCheck:=FALSE;
            i:=i+1;

        ENDWHILE
        bHoleCheckScss:=True;

        !        nDiffHoleX:=((nInspectHoleX{1}-nRefHoleX{1})-(nInspectHoleX{2}-nRefHoleX{2}))/2;
        nDiffHoleX:=(nInspectHoleX{1}-nRefHoleX{1});

        nDiffHoleXskew:=asin(((nInspectHoleX{2}-nRefHoleX{2})-(nInspectHoleX{1}-nRefHoleX{1}))/8795);

        !        nHomeAdjustX:=defualt_nHomeAdjustX;
        !        nHomeAdjustY:=defualt_nHomeAdjustY;
        !        nHomeAdjustZ:=defualt_nHomeAdjustZ;
        RETURN ;

    ENDPROC

    !    Mechanical Origin Inspect Routine using LDS
    !    PROC rLDS_check()
    !        VAR num nTemp_Y;
    !        VAR robtarget pTemp;
    !        VAR robtarget pStartPoint;
    !        VAR robtarget pEndPoint;
    !        VAR jointtarget jTemp;
    !        bLDS_Origin:=TRUE;
    !        IF bLDS_Origin=TRUE THEN
    !            nLDS_Divide:=1;
    !        ELSE
    !            nLDS_Divide:=2;
    !        ENDIF
    !        rRbtCheckAtHome;
    !        LabalReturn:
    !        !=========================================
    !        !LDS_Start Pos X
    !        !=========================================
    !        MoveAbsJ jTemp,TargetSpeed,fine,tool0;
    !        WaitRob\ZeroSpeed;
    !        nLdsX_LastLength:=nLdsX_Length;
    !        TPWrite "Robot will Start measuring X position";
    !        bEnableLdsX:=TRUE;
    !        bEnableLdsZ:=FALSE;
    !        !LDS_Start X
    !        SearchExtJ\Stop,bLdsX_EdgeChk,jLDS_Start_TartgetX,jLDS_end_TartgetX,v5;
    !        pTemp:=CRobT();
    !        WaitRob\ZeroSpeed;
    !        nInspectGantryX{nLDS_Divide}:=pTemp.extax.eax_a;
    !        nReferenceLazerX{nLDS_Divide}:=nLdsX_Length;
    !        IF bLDS_Origin=TRUE THEN
    !            nDiffGantryX:=0;
    !        ELSE
    !            nDiffGantryX:=nInspectGantryX{2}-nInspectGantryX{1};
    !        ENDIF
    !        TPWrite "Measurement Value X: "+ValToStr(nReferenceLazerX{nLDS_Divide});
    !        TPWrite "Triggerd position X: "+ValToStr(nInspectGantryX{nLDS_Divide});
    !        bEnableLdsX:=FALSE;
    !        bEnableLdsZ:=FALSE;

    !        !=========================================
    !        !LDS_Start Pos Z
    !        !=========================================
    !        jTemp:=jHomeJoint;
    !        jTemp.extax:=jLDS_Start_TartgetZ.extax;
    !        MoveAbsJ jTemp,TargetSpeed,fine,tool0;
    !        WaitRob\ZeroSpeed;
    !        nLdsZ_LastLength:=nLdsZ_Length;
    !        TPWrite "Robot will Start measuring Z position";
    !        bEnableLdsX:=FALSE;
    !        bEnableLdsZ:=TRUE;
    !        !LDS_Start Z
    !        SearchExtJ\Stop,bLdsZ_EdgeChk,jLDS_Start_TartgetZ,jLDS_end_TartgetZ,v5;
    !        pTemp:=CRobT();
    !        WaitRob\ZeroSpeed;
    !        nInspectGantryZ{nLDS_Divide}:=pTemp.extax.eax_d;
    !        nReferenceLazerZ{nLDS_Divide}:=nLdsZ_Length;
    !        IF bLDS_Origin=TRUE THEN
    !            nDiffGantryZ:=0;
    !        ELSE
    !            nDiffGantryZ:=nInspectGantryZ{2}-nInspectGantryZ{1};
    !        ENDIF
    !        TPWrite "Measurement Value Z: "+ValToStr(nReferenceLazerZ{nLDS_Divide});
    !        TPWrite "Triggerd position Z: "+ValToStr(nInspectGantryZ{nLDS_Divide});
    !        bEnableLdsX:=FALSE;
    !        bEnableLdsZ:=FALSE;

    !        !=========================================
    !        !LDS_Start Pos Y
    !        !=========================================
    !        jTemp:=jHomeJoint;
    !        jTemp.extax:=jLDS_End_TartgetZ.extax;
    !        MoveAbsJ jTemp,TargetSpeed,fine,tool0;
    !        TPWrite "Robot will Start measuring Y position";
    !        WaitRob\ZeroSpeed;
    !        WaitTime 1;
    !        bEnableLdsX:=FALSE;
    !        bEnableLdsZ:=TRUE;
    !        WaitTime 1;
    !        !LDS_Start Y
    !        nInspectGantryZ{nLDS_Divide}:=nLdsZ_Length;
    !        IF bLDS_Origin=TRUE THEN
    !            nDiffGantryY:=0;
    !        ELSE
    !            nDiffGantryY:=nInspectGantryY{2}-nInspectGantryY{1};
    !        ENDIF
    !        TPWrite "Measurement Value Y: "+ValToStr(nLdsZ_Length);
    !        bEnableLdsX:=FALSE;
    !        bEnableLdsZ:=FALSE;

    !        !=========================================
    !        !LDS_Value_Display
    !        !=========================================
    !        TPWrite "X triggerd position: "+ValToStr(nInspectGantryX{nLDS_Divide});
    !        TPWrite "Z triggerd position: "+ValToStr(nInspectGantryZ{nLDS_Divide});
    !        TPWrite "Measurement Value X: "+ValToStr(nReferenceLazerX{nLDS_Divide});
    !        TPWrite "Measurement Value Y: "+ValToStr(nInspectGantryY{nLDS_Divide});
    !        TPWrite "Measurement Value Z: "+ValToStr(nReferenceLazerZ{nLDS_Divide});

    !        IF bLDS_Origin=FALSE and (abs(nDiffGantryX)>1 OR abs(nDiffGantryY)>1 OR abs(nDiffGantryZ)>1) THEN
    !          ErrLog 4851,"LDS_OutRangeError","","","","";
    !          WaitUntil pi19_=1 OR pi20_=1;
    !          IF pi19_=1 GOTO LabalReturn;
    !          IF pi20_=1 rSettingInitialize;
    !        ELSE
    !          rSettingInitialize;
    !        ENDIF

    !        RETURN ;

    !        nTemp_Y:=0;
    !        jLDS_Start_TartgetX.robax:=jHomeJoint.robax;
    !        jLDS_End_TartgetX.robax:=jHomeJoint.robax;
    !        jLDS_Start_TartgetZ.robax:=jHomeJoint.robax;
    !        jLDS_End_TartgetZ.robax:=jHomeJoint.robax;

    !        jLDS_Start_TartgetX.extax.eax_c:=nTemp_Y;
    !        jLDS_End_TartgetX.extax.eax_c:=nTemp_Y;
    !        jLDS_Start_TartgetZ.extax.eax_c:=nTemp_Y;
    !        jLDS_End_TartgetZ.extax.eax_c:=nTemp_Y;

    !        MoveAbsJ jLDS_Start_TartgetX,v200,fine,tool0;
    !        MoveAbsJ jLDS_end_TartgetX,v200,fine,tool0;
    !        MoveAbsJ jLDS_Start_TartgetZ,v200,fine,tool0;
    !        MoveAbsJ jLDS_end_TartgetZ,v200,fine,tool0;

    !    ENDPROC

    !    PROC rRbtCheckAtHome()
    !        VAR jointtarget jtemp{2};
    !        VAR robtarget ptemp{2};
    !        VAR num ntemp{6};
    !        VAR bool btemp:=FALSE;
    !        jtemp{1}:=CJointT();
    !        ntemp{1}:=jtemp{1}.robax.rax_1-jHomeJoint.robax.rax_1;
    !        ntemp{2}:=jtemp{1}.robax.rax_2-jHomeJoint.robax.rax_2;
    !        ntemp{3}:=jtemp{1}.robax.rax_3-jHomeJoint.robax.rax_3;
    !        ntemp{4}:=jtemp{1}.robax.rax_4-jHomeJoint.robax.rax_4;
    !        ntemp{5}:=jtemp{1}.robax.rax_5-jHomeJoint.robax.rax_5;
    !        ntemp{6}:=jtemp{1}.robax.rax_6-jHomeJoint.robax.rax_6;

    !        FOR i FROM 1 TO 6 DO
    !            IF 1<Abs(ntemp{i}) THEN
    !                btemp:=TRUE;
    !                IF btemp=TRUE THEN
    !                    rMoveToRobotHome;
    !                    GOTO next;
    !                ENDIF
    !            ENDIF
    !        ENDFOR
    !        next:
    !        ntemp{1}:=jtemp{1}.extax.eax_d-jHomeJoint.extax.eax_d;
    !        IF 1<Abs(ntemp{1}) THEN
    !            jtemp{1}:=CJointT();
    !            jtemp{1}.extax.eax_d:=jHomeJoint.extax.eax_d;
    !            MoveAbsJ jtemp{1},v200,fine,tool0;
    !        ENDIF
    !    ENDPROC

    PROC rMoveToHoleCheck()
        VAR jointgroup jgHole_check;

        rMeasurementHomeCheck;

        jgHole_check.JointG:=jgHomeJoint.JointG;
        jgHole_check.JointG.extax.eax_a:=jgHomeJoint.JointG.extax.eax_a-500;
        jgHole_check.JointG.extax.eax_f:=jgHomeJoint.JointG.extax.eax_f-500;

        MoveJgJ MergeJgWith(\Gantry:=jgHole_check.JointG),vTargetSpeed,fine;
        WaitRob\InPos;
        WaitRob\ZeroSpeed;

        jgHole_check.JointG.extax.eax_a:=jgHomeJoint.JointG.extax.eax_a;
        jgHole_check.JointG.extax.eax_f:=jgHomeJoint.JointG.extax.eax_f;
        MoveJgJ MergeJgWith(\Gantry:=jgHole_check.JointG),vTargetSpeed,fine;
        WaitRob\InPos;
        WaitRob\ZeroSpeed;

    ENDPROC
ENDMODULE
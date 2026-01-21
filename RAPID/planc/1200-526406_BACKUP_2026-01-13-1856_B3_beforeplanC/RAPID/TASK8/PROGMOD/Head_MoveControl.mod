MODULE Head_MoveControl
    VAR num rotationMatrix{3,3};

    PROC rBullsEyeCheck()
        !        BEToolCheck;
    ENDPROC

    PROC rBullsEyeUpdate()
        !        BEToolUpdate;
    ENDPROC

    PROC rCalcEulerAngles(num matrix{*,*},INOUT num X,INOUT num Y,INOUT num Z)
        VAR num x2;

        x2:=Sqrt(matrix{1,1}*matrix{1,1}+matrix{2,1}*matrix{2,1});
        Y:=ATan2(0.0-matrix{3,1},x2);
        IF Abs(Y-pi/2.0)<=0.0001 THEN
            Z:=0.0;
            X:=ATan2(matrix{1,2},matrix{2,2});
        ELSEIF Abs(Y+pi/2.0)<=0.0001 THEN
            Z:=0.0;
            X:=0.0-ATan2(matrix{1,2},matrix{2,2});
        ELSE
            Z:=ATan2(matrix{2,1},matrix{1,1});
            X:=ATan2(matrix{3,2},matrix{3,3});
        ENDIF
    ENDPROC

    PROC rConfOff()
        ConfL\Off;
        ConfJ\Off;
    ENDPROC

    PROC rConfOn()
        ConfL\On;
        ConfJ\On;
    ENDPROC

    PROC rCorrStartEndPoint()
        VAR robtarget pCorrTemp_Start{2};
        VAR jointtarget jCorrTemp_Start{2};
        VAR robtarget pCorrTemp_End{2};
        VAR jointtarget jCorrTemp_End{2};
        VAR jointgroup jReadyTemp;

        rEdgeDataCheck;

        jCorrTouchGantry_Start:=fnCoordToJoint(fnPoseToExtax(WeldsG{1}.position));
        jCorrTouchGantry_End:=fnCoordToJoint(fnPoseToExtax(WeldsG{2}.position));
        stCommand:="CorrSearchStartEnd";
        WaitUntil(stReact=["CorrSearchOK","CorrSearchOK","CorrSearchOK"]) OR (stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"]);
        IF stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"]rMoveHome_Head;

        stCommand:="";
        WaitUntil stReact=["Ready","Ready","Ready"];

        !!!!!!
        jCorrTouchGantry_Start:=fnJointToCoord(jCorrTouchGantry_Start);
        jCorrTouchGantry_End:=fnJointToCoord(jCorrTouchGantry_End);
        !        stop;
        pCorrT_ROB1_Start:=CalcTouchTcp(pCorrT_ROB1_Start,jCorrTouchGantry_Start);
        pCorrT_ROB1_End:=CalcTouchTcp(pCorrT_ROB1_End,jCorrTouchGantry_End);
        !        stop;

        pCorrT_ROB2_Start:=CalcTouchTcp(pCorrT_ROB2_Start,jCorrTouchGantry_Start);
        pCorrT_ROB2_End:=CalcTouchTcp(pCorrT_ROB2_End,jCorrTouchGantry_End);
        !        stop;

        posStart:=(pCorrT_ROB1_Start.trans+pCorrT_ROB2_Start.trans)/2;
        nStartThick:=VectMagn(pCorrT_ROB2_Start.trans-pCorrT_ROB1_Start.trans);

        posEnd:=(pCorrT_ROB1_End.trans+pCorrT_ROB2_End.trans)/2;
        nEndThick:=VectMagn(pCorrT_ROB2_End.trans-pCorrT_ROB1_End.trans);
        !        stop;

        !        IF (posStartLast<>posStart) OR (posEndLast<>posEnd) THEN
        !            bTouchWorkCount:=[FALSE,FALSE,FALSE,FALSE,FALSE,FALSE];
        !        ENDIF

        !!!!!!
        posStartLast:=posStart;
        posEndLast:=posEnd;
        !        rDefineWobjWeldLine posStart,posEnd;
        rDefineWeldPosR1;
        rDefineWeldPosR2;
        rDefineWeldPosG;

        RETURN ;
    ENDPROC

    PROC rCreateMatrix(pos v1,pos v2,pos v3,INOUT num result{*,*})
        result{1,1}:=v1.x;
        result{2,1}:=v1.y;
        result{3,1}:=v1.z;

        result{1,2}:=v2.x;
        result{2,2}:=v2.y;
        result{3,2}:=v2.z;

        result{1,3}:=v3.x;
        result{2,3}:=v3.y;
        result{3,3}:=v3.z;
    ENDPROC

    PROC rDefineWeldPosG()
        VAR robtarget pDefineWeldPos;
        VAR num nNormalizeAngle90;
        VAR num nNormalizeAngle180;
        VAR num nOffsetLengthTemp;
        VAR num nCount:=1;

        WaitUntil stMacro<>["",""];
        IF 100<=nMacro{1} OR 100<=nMacro{2} THEN
            FOR i FROM 1 TO 40 DO
                WeldsG{i}.position:=pNull;
            ENDFOR

            nNormalizeAngle180:=NormalizeAngle(nAngleRzStore,180);
            nNormalizeAngle90:=NormalizeAngle(nNormalizeAngle180,90);

            !!!!! Calculate Gantry Welds !!!!!
            WeldsG{1}.position:=pNull;
            WeldsG{1}.position.trans:=CalcPosOnLine(posStart,posEnd,nOffsetLengthBuffer);
            WeldsG{1}.position.trans.z:=WeldsG{1}.position.trans.z+nRobWeldSpaceHeight;
            WeldsG{1}.position.rot:=OrientZYX(nNormalizeAngle90,0,0);

            WeldsG{2}.position:=pNull;
            WeldsG{2}.position.trans:=CalcPosOnLine(posStart,posEnd,nLengthWeldLine-nOffsetLengthBuffer);
            WeldsG{2}.position.trans.z:=Limit(1000,nLimitZ_Positive,WeldsG{2}.position.trans.z+nRobWeldSpaceHeight);
            WeldsG{2}.position.rot:=OrientZYX(nNormalizeAngle90,0,0);

        ELSE
            TPWrite "wrong sMacro data had input.";
            Stop;
        ENDIF
        !STOP;
        RETURN ;
    ENDPROC

    PROC rDefineWeldPosR1()
        VAR bool bResult100;
        VAR bool bResult010;
        VAR bool bResult001;

        VAR num nMotionStartStep;
        VAR num nMacroStartStepData;
        VAR num nMotionBreakStep;
        VAR num nMotionBreakStepLast;
        VAR num nMacroBreakStepData;
        VAR num nMotionEndStep;
        VAR num nMacroEndStepData;
        VAR num nBreakPointCount;

        VAR robtarget pBreakPointTargets{20};

        VAR robtarget pDefineWeldPos;

        VAR num nCount:=1;

        WaitUntil stMacro{1}<>"" AND stMacro{2}<>"";
        bResult100:=FALSE;
        bResult010:=FALSE;
        bResult001:=FALSE;

        IF (bRobSwap=FALSE) THEN
            bResult100:=StrToVal(StrPart(stMacro{1},1,1),nMacro100{1});
            bResult010:=StrToVal(StrPart(stMacro{1},2,1),nMacro010{1});
            bResult001:=StrToVal(StrPart(stMacro{1},3,1),nMacro001{1});
            FOR i FROM 1 TO 10 DO
                macroStartBuffer1{i}:=macroAutoStartA{1,i};
                macroEndBuffer1{i}:=macroAutoEndA{1,i};
                IF (bEnableManualMacro=TRUE) THEN
                    macroStartBuffer1{i}:=macroManualStartA{1,i};
                    macroEndBuffer1{i}:=macroManualEndA{1,i};
                ENDIF
            ENDFOR
            seam_TRob1:=smDefault_1{1};
        ELSE
            bResult100:=StrToVal(StrPart(stMacro{2},1,1),nMacro100{1});
            bResult010:=StrToVal(StrPart(stMacro{2},2,1),nMacro010{1});
            bResult001:=StrToVal(StrPart(stMacro{2},3,1),nMacro001{1});
            FOR i FROM 1 TO 10 DO
                macroStartBuffer1{i}:=macroAutoStartB{1,i};
                macroEndBuffer1{i}:=macroAutoEndB{1,i};
                IF (bEnableManualMacro=TRUE) THEN
                    macroStartBuffer1{i}:=macroManualStartB{1,i};
                    macroEndBuffer1{i}:=macroManualEndB{1,i};
                ENDIF
            ENDFOR
            seam_TRob1:=smDefault_1{2};
        ENDIF


        IF bResult100=TRUE AND bResult010=TRUE AND bResult001=TRUE THEN
            nMacro{1}:=((nMacro100{1}*100)+(nMacro010{1}*10)+(nMacro001{1}*1));

            FOR i FROM 1 TO 40 DO
                Welds1{i}.position:=pNull;
            ENDFOR

            !!! Calculate StartPose !!!
            nMotionStepCount{1}:=0;
            nMotionStartStep:=0;
            nMacroStartStepData:=0;

            WHILE nMotionStartStep<10 AND nMacroStartStepData<999 DO
                nMotionStartStep:=nMotionStartStep+1;
                nMacroStartStepData:=macroStartBuffer1{nMotionStartStep}.No;

                IF nMacroStartStepData=0 nMacroStartStepData:=999;

                IF nMacroStartStepData<999 THEN
                    nMotionStepCount{1}:=nMotionStepCount{1}+1;

                    pDefineWeldPos:=pNull;
                    pDefineWeldPos.trans.x:=macroStartBuffer1{nMotionStartStep}.LengthOffset;
                    pDefineWeldPos.trans.z:=macroStartBuffer1{nMotionStartStep}.HeightOffset;
                    pDefineWeldPos.robconf:=[0,0,0,1];

                    IF (bRobSwap=FALSE) THEN
                        pDefineWeldPos.trans.y:=(-1*(macroStartBuffer1{nMotionStartStep}.BreadthOffset)+((nStartThick/2)+((nEndThick-nStartThick)/2)*pDefineWeldPos.trans.x/nLengthWeldLine));
                        pDefineWeldPos.rot:=[0.5,0.5,-0.5,0.5];
                        pDefineWeldPos:=RelTool(pDefineWeldPos,0,0,0\Rx:=-1*macroStartBuffer1{nMotionStartStep}.TravelAngle\Ry:=-1*macroStartBuffer1{nMotionStartStep}.WorkingAngle+nBreakPoint{1});
                    ELSE
                        pDefineWeldPos.trans.y:=(macroStartBuffer1{nMotionStartStep}.BreadthOffset-((nStartThick/2)+((nEndThick-nStartThick)/2)*pDefineWeldPos.trans.x/nLengthWeldLine));
                        pDefineWeldPos.rot:=[0.5,-0.5,-0.5,-0.5];
                        pDefineWeldPos:=RelTool(pDefineWeldPos,0,0,0\Rx:=macroStartBuffer1{nMotionStartStep}.TravelAngle\Ry:=-1*macroStartBuffer1{nMotionStartStep}.WorkingAngle+nBreakPoint{1});
                    ENDIF

                    Welds1{nMotionStepCount{1}}.position:=pDefineWeldPos;
                    Welds1{nMotionStepCount{1}}.cpm:=macroStartBuffer1{nMotionStartStep}.WeldingSpeed;
                    Welds1{nMotionStepCount{1}}.voltage:=macroStartBuffer1{nMotionStartStep}.Voltage;
                    Welds1{nMotionStepCount{1}}.Current:=macroStartBuffer1{nMotionStartStep}.Current;
                    Welds1{nMotionStepCount{1}}.wfs:=macroStartBuffer1{nMotionStartStep}.FeedingSpeed;

                    Welds1{nMotionStepCount{1}}.WeaveShape:=macroStartBuffer1{nMotionStartStep}.WeaveShape;
                    Welds1{nMotionStepCount{1}}.WeaveLength:=macroStartBuffer1{nMotionStartStep}.WeaveLength;
                    Welds1{nMotionStepCount{1}}.WeaveWidth:=macroStartBuffer1{nMotionStartStep}.WeaveWidth;
                    Welds1{nMotionStepCount{1}}.WeaveDwellLeft:=macroStartBuffer1{nMotionStartStep}.WeaveDwellLeft;
                    Welds1{nMotionStepCount{1}}.WeaveDwellRight:=macroStartBuffer1{nMotionStartStep}.WeaveDwellRight;
                    Welds1{nMotionStepCount{1}}.WeaveType:=macroStartBuffer1{nMotionStartStep}.WeaveType;

                    Welds1{nMotionStepCount{1}}.TrackType:=macroStartBuffer1{nMotionStartStep}.TrackType;
                    Welds1{nMotionStepCount{1}}.TrackGainY:=macroStartBuffer1{nMotionStartStep}.TrackGainY;
                    Welds1{nMotionStepCount{1}}.TrackGainZ:=macroStartBuffer1{nMotionStartStep}.TrackGainZ;
                    Welds1{nMotionStepCount{1}}.MaxCorr:=macroStartBuffer1{nMotionStartStep}.MaxCorr;
                    Welds1{nMotionStepCount{1}}.Bias:=macroStartBuffer1{nMotionStartStep}.Bias;
                ELSE
                    nMotionStartStep:=nMotionStartStep-1;
                    nMotionStartStepLast{1}:=nMotionStartStep;
                ENDIF

            ENDWHILE

            !!! Calculcate Align position from start point !!!
            IF (nMacro010{1}=0) OR (nMacro010{1}=1) OR (nMacro010{1}=2) OR (nMacro010{1}=3) OR (nMacro010{1}=4) THEN

                nMotionStepCount{1}:=nMotionStepCount{1}+1;

                pDefineWeldPos:=pNull;
                pDefineWeldPos.trans.x:=nOffsetLengthBuffer/2;
                pDefineWeldPos.trans.z:=macroStartBuffer1{nMotionStartStep}.HeightOffset;
                pDefineWeldPos.robconf:=[0,0,0,1];

                IF (bRobSwap=FALSE) THEN
                    pDefineWeldPos.trans.y:=(-1*(macroStartBuffer1{nMotionStartStep}.BreadthOffset)+((nStartThick/2)+((nEndThick-nStartThick)/2)*pDefineWeldPos.trans.x/nLengthWeldLine));
                    pDefineWeldPos.rot:=[0.5,0.5,-0.5,0.5];
                ELSE
                    pDefineWeldPos.trans.y:=(macroStartBuffer1{nMotionStartStep}.BreadthOffset-((nStartThick/2)+((nEndThick-nStartThick)/2)*pDefineWeldPos.trans.x/nLengthWeldLine));
                    pDefineWeldPos.rot:=[0.5,-0.5,-0.5,-0.5];
                ENDIF

                pDefineWeldPos:=RelTool(pDefineWeldPos,0,0,0\Ry:=-1*macroStartBuffer1{nMotionStartStep}.WorkingAngle+nBreakPoint{1});

                Welds1{nMotionStepCount{1}}.position:=pDefineWeldPos;
                Welds1{nMotionStepCount{1}}.cpm:=macroEndBuffer1{1}.WeldingSpeed;
                Welds1{nMotionStepCount{1}}.voltage:=macroEndBuffer1{1}.Voltage;
                Welds1{nMotionStepCount{1}}.Current:=macroEndBuffer1{1}.Current;
                Welds1{nMotionStepCount{1}}.wfs:=macroEndBuffer1{1}.FeedingSpeed;

                Welds1{nMotionStepCount{1}}.WeaveShape:=macroEndBuffer1{1}.WeaveShape;
                Welds1{nMotionStepCount{1}}.WeaveLength:=macroEndBuffer1{1}.WeaveLength;
                Welds1{nMotionStepCount{1}}.WeaveWidth:=macroEndBuffer1{1}.WeaveWidth;
                Welds1{nMotionStepCount{1}}.WeaveDwellLeft:=macroEndBuffer1{1}.WeaveDwellLeft;
                Welds1{nMotionStepCount{1}}.WeaveDwellRight:=macroEndBuffer1{1}.WeaveDwellRight;
                Welds1{nMotionStepCount{1}}.WeaveType:=macroEndBuffer1{1}.WeaveType;

                Welds1{nMotionStepCount{1}}.TrackType:=macroEndBuffer1{1}.TrackType;
                Welds1{nMotionStepCount{1}}.TrackGainY:=macroEndBuffer1{1}.TrackGainY;
                Welds1{nMotionStepCount{1}}.TrackGainZ:=macroEndBuffer1{1}.TrackGainZ;
                Welds1{nMotionStepCount{1}}.MaxCorr:=macroEndBuffer1{1}.MaxCorr;
                Welds1{nMotionStepCount{1}}.Bias:=macroEndBuffer1{1}.Bias;
            ENDIF

            !!! Calculate breakpoints !!!
            !            nBreakPointCount:=DefineWeldPosOnBreakPoints(macroStartBuffer1{nMotionStartStep},pBreakPointTargets);
            !            IF nBreakPointCount>0 THEN
            !                FOR nCount FROM 1 TO nBreakPointCount DO
            !                    nMotionStepCount{1}:=nMotionStepCount{1}+1;

            !                    Welds1{nMotionStepCount{1}}.position:=pBreakPointTargets{nCount};
            !                    Welds1{nMotionStepCount{1}}.cpm:=macroEndBuffer1{1}.WeldingSpeed;
            !                    Welds1{nMotionStepCount{1}}.voltage:=macroEndBuffer1{1}.Voltage;
            !                    Welds1{nMotionStepCount{1}}.Current:=macroEndBuffer1{1}.Current;
            !                    Welds1{nMotionStepCount{1}}.wfs:=macroEndBuffer1{1}.FeedingSpeed;

            !                    Welds1{nMotionStepCount{1}}.WeaveShape:=macroEndBuffer1{1}.WeaveShape;
            !                    Welds1{nMotionStepCount{1}}.WeaveLength:=macroEndBuffer1{1}.WeaveLength;
            !                    Welds1{nMotionStepCount{1}}.WeaveWidth:=macroEndBuffer1{1}.WeaveWidth;
            !                    Welds1{nMotionStepCount{1}}.WeaveDwellLeft:=macroEndBuffer1{1}.WeaveDwellLeft;
            !                    Welds1{nMotionStepCount{1}}.WeaveDwellRight:=macroEndBuffer1{1}.WeaveDwellRight;
            !                    Welds1{nMotionStepCount{1}}.WeaveType:=macroEndBuffer1{1}.WeaveType;

            !                    Welds1{nMotionStepCount{1}}.TrackType:=macroEndBuffer1{1}.TrackType;
            !                    Welds1{nMotionStepCount{1}}.TrackGainY:=macroEndBuffer1{1}.TrackGainY;
            !                    Welds1{nMotionStepCount{1}}.TrackGainZ:=macroEndBuffer1{1}.TrackGainZ;
            !                    Welds1{nMotionStepCount{1}}.TrackGainZ:=macroEndBuffer1{1}.TrackGainZ;
            !                ENDFOR
            !            ENDIF

            !!! Calculcate gantry position from end point !!!
            IF (nMacro001{1}=0) OR (nMacro001{1}=1) OR (nMacro001{1}=2) OR (nMacro001{1}=3) OR (nMacro001{1}=4) THEN
                nMotionStepCount{1}:=nMotionStepCount{1}+1;

                pDefineWeldPos:=pNull;
                pDefineWeldPos.trans.x:=(nOffsetLengthBuffer)+(nOffsetLengthBuffer/2);
                pDefineWeldPos.trans.z:=macroStartBuffer1{nMotionStartStep}.HeightOffset;
                pDefineWeldPos.robconf:=[0,0,0,1];

                IF (bRobSwap=FALSE) THEN
                    pDefineWeldPos.trans.y:=(-1*(macroStartBuffer1{nMotionStartStep}.BreadthOffset)+((nStartThick/2)+((nEndThick-nStartThick)/2)*pDefineWeldPos.trans.x/nLengthWeldLine));
                    pDefineWeldPos.rot:=[0.5,0.5,-0.5,0.5];
                ELSE
                    pDefineWeldPos.trans.y:=(macroStartBuffer1{nMotionStartStep}.BreadthOffset-((nStartThick/2)+((nEndThick-nStartThick)/2)*pDefineWeldPos.trans.x/nLengthWeldLine));
                    pDefineWeldPos.rot:=[0.5,-0.5,-0.5,-0.5];
                ENDIF

                pDefineWeldPos:=RelTool(pDefineWeldPos,0,0,0\Ry:=-1*macroEndBuffer1{1}.WorkingAngle+nBreakPoint{1});

                Welds1{nMotionStepCount{1}}.position:=pDefineWeldPos;
                Welds1{nMotionStepCount{1}}.cpm:=macroEndBuffer1{1}.WeldingSpeed;
                Welds1{nMotionStepCount{1}}.voltage:=macroEndBuffer1{1}.Voltage;
                Welds1{nMotionStepCount{1}}.Current:=macroEndBuffer1{1}.Current;
                Welds1{nMotionStepCount{1}}.wfs:=macroEndBuffer1{1}.FeedingSpeed;

                Welds1{nMotionStepCount{1}}.WeaveShape:=macroEndBuffer1{1}.WeaveShape;
                Welds1{nMotionStepCount{1}}.WeaveLength:=macroEndBuffer1{1}.WeaveLength;
                Welds1{nMotionStepCount{1}}.WeaveWidth:=macroEndBuffer1{1}.WeaveWidth;
                Welds1{nMotionStepCount{1}}.WeaveDwellLeft:=macroEndBuffer1{1}.WeaveDwellLeft;
                Welds1{nMotionStepCount{1}}.WeaveDwellRight:=macroEndBuffer1{1}.WeaveDwellRight;
                Welds1{nMotionStepCount{1}}.WeaveType:=macroEndBuffer1{1}.WeaveType;

                Welds1{nMotionStepCount{1}}.TrackType:=macroEndBuffer1{1}.TrackType;
                Welds1{nMotionStepCount{1}}.TrackGainY:=macroEndBuffer1{1}.TrackGainY;
                Welds1{nMotionStepCount{1}}.TrackGainZ:=macroEndBuffer1{1}.TrackGainZ;
                Welds1{nMotionStepCount{1}}.MaxCorr:=macroEndBuffer1{1}.MaxCorr;
                Welds1{nMotionStepCount{1}}.Bias:=macroEndBuffer1{1}.Bias;
            ENDIF

            !!! Calculate EndPose !!!
            nMotionEndStep:=0;
            nMacroEndStepData:=0;
            WHILE nMotionEndStep<10 AND nMacroEndStepData<999 DO
                nMotionEndStep:=nMotionEndStep+1;
                nMacroEndStepData:=macroEndBuffer1{nMotionEndStep}.No;
                IF nMacroEndStepData=0 nMacroEndStepData:=999;
                IF nMacroEndStepData<999 THEN
                    nMotionStepCount{1}:=nMotionStepCount{1}+1;

                    pDefineWeldPos:=pNull;
                    pDefineWeldPos.trans.x:=nOffsetLengthBuffer*2+macroEndBuffer1{nMotionEndStep}.LengthOffset;
                    pDefineWeldPos.trans.z:=macroEndBuffer1{nMotionEndStep}.HeightOffset;
                    pDefineWeldPos.robconf:=[0,0,0,1];

                    IF (bRobSwap=FALSE) THEN
                        pDefineWeldPos.trans.y:=(-1*(macroEndBuffer1{nMotionEndStep}.BreadthOffset)+((nStartThick/2)+((nEndThick-nStartThick)/2)*pDefineWeldPos.trans.x/nLengthWeldLine));
                        pDefineWeldPos.rot:=[0.5,0.5,-0.5,0.5];
                        pDefineWeldPos:=RelTool(pDefineWeldPos,0,0,0\Rx:=-1*macroEndBuffer1{nMotionEndStep}.TravelAngle\Ry:=-1*macroEndBuffer1{nMotionEndStep}.WorkingAngle+nBreakPoint{1});
                    ELSE
                        pDefineWeldPos.trans.y:=(macroEndBuffer1{nMotionEndStep}.BreadthOffset-((nStartThick/2)+((nEndThick-nStartThick)/2)*pDefineWeldPos.trans.x/nLengthWeldLine));
                        pDefineWeldPos.rot:=[0.5,-0.5,-0.5,-0.5];
                        pDefineWeldPos:=RelTool(pDefineWeldPos,0,0,0\Rx:=macroEndBuffer1{nMotionEndStep}.TravelAngle\Ry:=-1*macroEndBuffer1{nMotionEndStep}.WorkingAngle+nBreakPoint{1});
                    ENDIF

                    Welds1{nMotionStepCount{1}}.position:=pDefineWeldPos;
                    Welds1{nMotionStepCount{1}}.cpm:=macroEndBuffer1{nMotionEndStep}.WeldingSpeed;
                    Welds1{nMotionStepCount{1}}.voltage:=macroEndBuffer1{nMotionEndStep}.Voltage;
                    Welds1{nMotionStepCount{1}}.Current:=macroEndBuffer1{nMotionEndStep}.Current;
                    Welds1{nMotionStepCount{1}}.wfs:=macroEndBuffer1{nMotionEndStep}.FeedingSpeed;

                    Welds1{nMotionStepCount{1}}.WeaveShape:=macroEndBuffer1{nMotionEndStep}.WeaveShape;
                    Welds1{nMotionStepCount{1}}.WeaveLength:=macroEndBuffer1{nMotionEndStep}.WeaveLength;
                    Welds1{nMotionStepCount{1}}.WeaveWidth:=macroEndBuffer1{nMotionEndStep}.WeaveWidth;
                    Welds1{nMotionStepCount{1}}.WeaveDwellLeft:=macroEndBuffer1{nMotionEndStep}.WeaveDwellLeft;
                    Welds1{nMotionStepCount{1}}.WeaveDwellRight:=macroEndBuffer1{nMotionEndStep}.WeaveDwellRight;
                    Welds1{nMotionStepCount{1}}.WeaveType:=macroEndBuffer1{nMotionEndStep}.WeaveType;

                    Welds1{nMotionStepCount{1}}.TrackType:=macroEndBuffer1{nMotionEndStep}.TrackType;
                    Welds1{nMotionStepCount{1}}.TrackGainY:=macroEndBuffer1{nMotionEndStep}.TrackGainY;
                    Welds1{nMotionStepCount{1}}.TrackGainZ:=macroEndBuffer1{nMotionEndStep}.TrackGainZ;
                    Welds1{nMotionStepCount{1}}.MaxCorr:=macroEndBuffer1{nMotionEndStep}.MaxCorr;
                    Welds1{nMotionStepCount{1}}.Bias:=macroEndBuffer1{nMotionEndStep}.Bias;
                ELSE
                    nMotionEndStep:=nMotionEndStep-1;
                    nMotionEndStepLast{1}:=nMotionEndStep;
                ENDIF
            ENDWHILE

            nMotionTotalStep{1}:=nMotionStartStep+nMacroBreakStepData+nMotionEndStep;
        ELSE
            TPWrite "wrong sMacro data had input.";
            Stop;
        ENDIF

        !STOP;
    ENDPROC

    PROC rDefineWeldPosR2()
        VAR bool bResult100;
        VAR bool bResult010;
        VAR bool bResult001;

        VAR num nMotionStartStep;
        VAR num nMacroStartStepData;
        VAR num nMotionBreakStep;
        VAR num nMotionBreakStepLast;
        VAR num nMacroBreakStepData;
        VAR num nMotionEndStep;
        VAR num nMacroEndStepData;
        VAR num nBreakPointCount;
        VAR robtarget pBreakPointTargets{20};

        VAR robtarget pDefineWeldPos;

        VAR num nCount:=1;

        WaitUntil stMacro{1}<>"" AND stMacro{2}<>"";
        bResult100:=FALSE;
        bResult010:=FALSE;
        bResult001:=FALSE;

        IF (bRobSwap=FALSE) THEN
            bResult100:=StrToVal(StrPart(stMacro{2},1,1),nMacro100{2});
            bResult010:=StrToVal(StrPart(stMacro{2},2,1),nMacro010{2});
            bResult001:=StrToVal(StrPart(stMacro{2},3,1),nMacro001{2});
            FOR i FROM 1 TO 10 DO
                macroStartBuffer2{i}:=macroAutoStartB{2,i};
                macroEndBuffer2{i}:=macroAutoEndB{2,i};
                IF (bEnableManualMacro=TRUE) THEN
                    macroStartBuffer2{i}:=macroManualStartB{2,i};
                    macroEndBuffer2{i}:=macroManualEndB{2,i};
                ENDIF
            ENDFOR
            seam_TRob2:=smDefault_2{1};
        ELSE
            bResult100:=StrToVal(StrPart(stMacro{1},1,1),nMacro100{2});
            bResult010:=StrToVal(StrPart(stMacro{1},2,1),nMacro010{2});
            bResult001:=StrToVal(StrPart(stMacro{1},3,1),nMacro001{2});
            FOR i FROM 1 TO 10 do
                macroStartBuffer2{i}:=macroAutoStartA{2,i};
                macroEndBuffer2{i}:=macroAutoEndA{2,i};
                IF (bEnableManualMacro=TRUE) THEN
                    macroStartBuffer2{i}:=macroManualStartA{2,i};
                    macroEndBuffer2{i}:=macroManualEndA{2,i};
                ENDIF
            ENDFOR
            seam_TRob2:=smDefault_2{2};
        ENDIF

        IF bResult100=TRUE AND bResult010=TRUE AND bResult001=TRUE THEN
            nMacro{2}:=((nMacro100{2}*100)+(nMacro010{2}*10)+(nMacro001{2}*1));

            FOR i FROM 1 TO 40 DO
                Welds2{i}.position:=pNull;
            ENDFOR

            !!! Calculate StartPose !!!
            nMotionStepCount{2}:=0;
            nMotionStartStep:=0;
            nMacroStartStepData:=0;

            WHILE nMotionStartStep<10 AND nMacroStartStepData<999 DO
                nMotionStartStep:=nMotionStartStep+1;
                nMacroStartStepData:=macroStartBuffer2{nMotionStartStep}.No;

                IF nMacroStartStepData=0 nMacroStartStepData:=999;

                IF nMacroStartStepData<999 THEN
                    nMotionStepCount{2}:=nMotionStepCount{2}+1;

                    pDefineWeldPos:=pNull;
                    pDefineWeldPos.trans.x:=macroStartBuffer2{nMotionStartStep}.LengthOffset;
                    pDefineWeldPos.trans.z:=macroStartBuffer2{nMotionStartStep}.HeightOffset;
                    pDefineWeldPos.robconf:=[0,0,0,1];

                    IF (bRobSwap=TRUE) THEN
                        pDefineWeldPos.trans.y:=(-1*(macroStartBuffer2{nMotionStartStep}.BreadthOffset)+((nStartThick/2)+((nEndThick-nStartThick)/2)*pDefineWeldPos.trans.x/nLengthWeldLine));
                        pDefineWeldPos.rot:=[0.5,0.5,-0.5,0.5];
                        pDefineWeldPos:=RelTool(pDefineWeldPos,0,0,0\Rx:=-1*macroStartBuffer2{nMotionStartStep}.TravelAngle\Ry:=-1*macroStartBuffer2{nMotionStartStep}.WorkingAngle+nBreakPoint{2});
                    ELSE
                        pDefineWeldPos.trans.y:=(macroStartBuffer2{nMotionStartStep}.BreadthOffset-((nStartThick/2)+((nEndThick-nStartThick)/2)*pDefineWeldPos.trans.x/nLengthWeldLine));
                        pDefineWeldPos.rot:=[0.5,-0.5,-0.5,-0.5];
                        pDefineWeldPos:=RelTool(pDefineWeldPos,0,0,0\Rx:=macroStartBuffer2{nMotionStartStep}.TravelAngle\Ry:=-1*macroStartBuffer2{nMotionStartStep}.WorkingAngle+nBreakPoint{2});
                    ENDIF

                    Welds2{nMotionStepCount{2}}.position:=pDefineWeldPos;
                    Welds2{nMotionStepCount{2}}.cpm:=macroStartBuffer2{nMotionStartStep}.WeldingSpeed;
                    Welds2{nMotionStepCount{2}}.voltage:=macroStartBuffer2{nMotionStartStep}.Voltage;
                    Welds2{nMotionStepCount{2}}.Current:=macroStartBuffer2{nMotionStartStep}.Current;
                    Welds2{nMotionStepCount{2}}.wfs:=macroStartBuffer2{nMotionStartStep}.FeedingSpeed;

                    Welds2{nMotionStepCount{2}}.WeaveShape:=macroStartBuffer2{nMotionStartStep}.WeaveShape;
                    Welds2{nMotionStepCount{2}}.WeaveLength:=macroStartBuffer2{nMotionStartStep}.WeaveLength;
                    Welds2{nMotionStepCount{2}}.WeaveWidth:=macroStartBuffer2{nMotionStartStep}.WeaveWidth;
                    Welds2{nMotionStepCount{2}}.WeaveDwellLeft:=macroStartBuffer2{nMotionStartStep}.WeaveDwellLeft;
                    Welds2{nMotionStepCount{2}}.WeaveDwellRight:=macroStartBuffer2{nMotionStartStep}.WeaveDwellRight;
                    Welds2{nMotionStepCount{2}}.WeaveType:=macroStartBuffer2{nMotionStartStep}.WeaveType;

                    Welds2{nMotionStepCount{2}}.TrackType:=macroStartBuffer2{nMotionStartStep}.TrackType;
                    Welds2{nMotionStepCount{2}}.TrackGainY:=macroStartBuffer2{nMotionStartStep}.TrackGainY;
                    Welds2{nMotionStepCount{2}}.TrackGainZ:=macroStartBuffer2{nMotionStartStep}.TrackGainZ;
                    Welds2{nMotionStepCount{2}}.MaxCorr:=macroStartBuffer2{nMotionStartStep}.MaxCorr;
                    Welds2{nMotionStepCount{2}}.Bias:=macroStartBuffer2{nMotionStartStep}.Bias;
                ELSE
                    nMotionStartStep:=nMotionStartStep-1;
                    nMotionStartStepLast{2}:=nMotionStartStep;
                ENDIF

            ENDWHILE

            !!! Calculcate Align position from start point !!!
            IF (nMacro010{2}=0) OR (nMacro010{2}=1) OR (nMacro010{2}=2) OR (nMacro010{2}=3) OR (nMacro010{2}=4) THEN

                nMotionStepCount{2}:=nMotionStepCount{2}+1;

                pDefineWeldPos:=pNull;
                pDefineWeldPos.trans.x:=nOffsetLengthBuffer/2;
                pDefineWeldPos.trans.z:=macroStartBuffer2{nMotionStartStep}.HeightOffset;
                pDefineWeldPos.robconf:=[0,0,0,1];

                IF (bRobSwap=TRUE) THEN
                    pDefineWeldPos.trans.y:=(-1*(macroStartBuffer2{nMotionStartStep}.BreadthOffset)+((nStartThick/2)+((nEndThick-nStartThick)/2)*pDefineWeldPos.trans.x/nLengthWeldLine));
                    pDefineWeldPos.rot:=[0.5,0.5,-0.5,0.5];
                ELSE
                    pDefineWeldPos.trans.y:=(macroStartBuffer2{nMotionStartStep}.BreadthOffset-((nStartThick/2)+((nEndThick-nStartThick)/2)*pDefineWeldPos.trans.x/nLengthWeldLine));
                    pDefineWeldPos.rot:=[0.5,-0.5,-0.5,-0.5];
                ENDIF

                pDefineWeldPos:=RelTool(pDefineWeldPos,0,0,0\Ry:=-1*macroStartBuffer2{nMotionStartStep}.WorkingAngle+nBreakPoint{2});

                Welds2{nMotionStepCount{2}}.position:=pDefineWeldPos;
                Welds2{nMotionStepCount{2}}.cpm:=macroEndBuffer2{1}.WeldingSpeed;
                Welds2{nMotionStepCount{2}}.voltage:=macroEndBuffer2{1}.Voltage;
                Welds2{nMotionStepCount{2}}.Current:=macroEndBuffer2{1}.Current;
                Welds2{nMotionStepCount{2}}.wfs:=macroEndBuffer2{1}.FeedingSpeed;

                Welds2{nMotionStepCount{2}}.WeaveShape:=macroEndBuffer2{1}.WeaveShape;
                Welds2{nMotionStepCount{2}}.WeaveLength:=macroEndBuffer2{1}.WeaveLength;
                Welds2{nMotionStepCount{2}}.WeaveWidth:=macroEndBuffer2{1}.WeaveWidth;
                Welds2{nMotionStepCount{2}}.WeaveDwellLeft:=macroEndBuffer2{1}.WeaveDwellLeft;
                Welds2{nMotionStepCount{2}}.WeaveDwellRight:=macroEndBuffer2{1}.WeaveDwellRight;
                Welds2{nMotionStepCount{2}}.WeaveType:=macroEndBuffer2{1}.WeaveType;

                Welds2{nMotionStepCount{2}}.TrackType:=macroEndBuffer2{1}.TrackType;
                Welds2{nMotionStepCount{2}}.TrackGainY:=macroEndBuffer2{1}.TrackGainY;
                Welds2{nMotionStepCount{2}}.TrackGainZ:=macroEndBuffer2{1}.TrackGainZ;
                Welds2{nMotionStepCount{2}}.MaxCorr:=macroEndBuffer2{1}.MaxCorr;
                Welds2{nMotionStepCount{2}}.Bias:=macroEndBuffer2{1}.Bias;
            ENDIF

            !!! Calculate breakpoints !!!
            nBreakPointCount:=DefineWeldPosOnBreakPoints(macroStartBuffer2{nMotionStartStep},pBreakPointTargets);
            IF nBreakPointCount>0 THEN
                FOR nCount FROM 1 TO nBreakPointCount DO
                    nMotionStepCount{2}:=nMotionStepCount{2}+1;

                    Welds2{nMotionStepCount{2}}.position:=pBreakPointTargets{nCount};
                    Welds2{nMotionStepCount{2}}.cpm:=macroEndBuffer2{1}.WeldingSpeed;
                    Welds2{nMotionStepCount{2}}.voltage:=macroEndBuffer2{1}.Voltage;
                    Welds2{nMotionStepCount{2}}.Current:=macroEndBuffer2{1}.Current;
                    Welds2{nMotionStepCount{2}}.wfs:=macroEndBuffer2{1}.FeedingSpeed;

                    Welds2{nMotionStepCount{2}}.WeaveShape:=macroEndBuffer2{1}.WeaveShape;
                    Welds2{nMotionStepCount{2}}.WeaveLength:=macroEndBuffer2{1}.WeaveLength;
                    Welds2{nMotionStepCount{2}}.WeaveWidth:=macroEndBuffer2{1}.WeaveWidth;
                    Welds2{nMotionStepCount{2}}.WeaveDwellLeft:=macroEndBuffer2{1}.WeaveDwellLeft;
                    Welds2{nMotionStepCount{2}}.WeaveDwellRight:=macroEndBuffer2{1}.WeaveDwellRight;
                    Welds2{nMotionStepCount{2}}.WeaveType:=macroEndBuffer2{1}.WeaveType;

                    Welds2{nMotionStepCount{2}}.TrackType:=macroEndBuffer2{1}.TrackType;
                    Welds2{nMotionStepCount{2}}.TrackGainY:=macroEndBuffer2{1}.TrackGainY;
                    Welds2{nMotionStepCount{2}}.TrackGainZ:=macroEndBuffer2{1}.TrackGainZ;
                    Welds2{nMotionStepCount{2}}.MaxCorr:=macroEndBuffer2{1}.MaxCorr;
                    Welds2{nMotionStepCount{2}}.Bias:=macroEndBuffer2{1}.Bias;
                ENDFOR
            ENDIF

            !!! Calculcate gantry position from end point !!!
            IF (nMacro001{2}=0) OR (nMacro001{2}=1) OR (nMacro001{2}=2) OR (nMacro001{2}=3) OR (nMacro001{2}=4) THEN
                nMotionStepCount{2}:=nMotionStepCount{2}+1;

                pDefineWeldPos:=pNull;
                pDefineWeldPos.trans.x:=(nOffsetLengthBuffer)+(nOffsetLengthBuffer/2);
                pDefineWeldPos.trans.z:=macroStartBuffer2{nMotionStartStep}.HeightOffset;
                pDefineWeldPos.robconf:=[0,0,0,1];

                IF (bRobSwap=TRUE) THEN
                    pDefineWeldPos.trans.y:=(-1*(macroStartBuffer2{nMotionStartStep}.BreadthOffset)+((nStartThick/2)+((nEndThick-nStartThick)/2)*pDefineWeldPos.trans.x/nLengthWeldLine));
                    pDefineWeldPos.rot:=[0.5,0.5,-0.5,0.5];
                ELSE
                    pDefineWeldPos.trans.y:=(macroStartBuffer2{nMotionStartStep}.BreadthOffset-((nStartThick/2)+((nEndThick-nStartThick)/2)*pDefineWeldPos.trans.x/nLengthWeldLine));
                    pDefineWeldPos.rot:=[0.5,-0.5,-0.5,-0.5];
                ENDIF

                pDefineWeldPos:=RelTool(pDefineWeldPos,0,0,0\Ry:=-1*macroEndBuffer2{1}.WorkingAngle+nBreakPoint{2});

                Welds2{nMotionStepCount{2}}.position:=pDefineWeldPos;
                Welds2{nMotionStepCount{2}}.cpm:=macroEndBuffer2{1}.WeldingSpeed;
                Welds2{nMotionStepCount{2}}.voltage:=macroEndBuffer2{1}.Voltage;
                Welds2{nMotionStepCount{2}}.Current:=macroEndBuffer2{1}.Current;
                Welds2{nMotionStepCount{2}}.wfs:=macroEndBuffer2{1}.FeedingSpeed;

                Welds2{nMotionStepCount{2}}.WeaveShape:=macroEndBuffer2{1}.WeaveShape;
                Welds2{nMotionStepCount{2}}.WeaveLength:=macroEndBuffer2{1}.WeaveLength;
                Welds2{nMotionStepCount{2}}.WeaveWidth:=macroEndBuffer2{1}.WeaveWidth;
                Welds2{nMotionStepCount{2}}.WeaveDwellLeft:=macroEndBuffer2{1}.WeaveDwellLeft;
                Welds2{nMotionStepCount{2}}.WeaveDwellRight:=macroEndBuffer2{1}.WeaveDwellRight;
                Welds2{nMotionStepCount{2}}.WeaveType:=macroEndBuffer2{1}.WeaveType;

                Welds2{nMotionStepCount{2}}.TrackType:=macroEndBuffer2{1}.TrackType;
                Welds2{nMotionStepCount{2}}.TrackGainY:=macroEndBuffer2{1}.TrackGainY;
                Welds2{nMotionStepCount{2}}.TrackGainZ:=macroEndBuffer2{1}.TrackGainZ;
                Welds2{nMotionStepCount{2}}.MaxCorr:=macroEndBuffer2{1}.MaxCorr;
                Welds2{nMotionStepCount{2}}.Bias:=macroEndBuffer2{1}.Bias;
            ENDIF

            !!! Calculate EndPose !!!
            nMotionEndStep:=0;
            nMacroEndStepData:=0;
            WHILE nMotionEndStep<10 AND nMacroEndStepData<999 DO
                nMotionEndStep:=nMotionEndStep+1;
                nMacroEndStepData:=macroEndBuffer2{nMotionEndStep}.No;

                IF nMacroEndStepData=0 nMacroEndStepData:=999;
                IF nMacroEndStepData<999 THEN
                    nMotionStepCount{2}:=nMotionStepCount{2}+1;

                    pDefineWeldPos:=pNull;
                    pDefineWeldPos.trans.x:=nOffsetLengthBuffer*2+macroEndBuffer2{nMotionEndStep}.LengthOffset;
                    pDefineWeldPos.trans.z:=macroEndBuffer2{nMotionEndStep}.HeightOffset;
                    pDefineWeldPos.robconf:=[0,0,0,1];

                    IF (bRobSwap=TRUE) THEN
                        pDefineWeldPos.trans.y:=(-1*(macroEndBuffer2{nMotionEndStep}.BreadthOffset)+((nStartThick/2)+((nEndThick-nStartThick)/2)*pDefineWeldPos.trans.x/nLengthWeldLine));
                        pDefineWeldPos.rot:=[0.5,0.5,-0.5,0.5];
                        pDefineWeldPos:=RelTool(pDefineWeldPos,0,0,0\Rx:=-1*macroEndBuffer2{nMotionEndStep}.TravelAngle\Ry:=-1*macroEndBuffer2{nMotionEndStep}.WorkingAngle+nBreakPoint{2});
                    ELSE
                        pDefineWeldPos.trans.y:=(macroEndBuffer2{nMotionEndStep}.BreadthOffset-((nStartThick/2)+((nEndThick-nStartThick)/2)*pDefineWeldPos.trans.x/nLengthWeldLine));
                        pDefineWeldPos.rot:=[0.5,-0.5,-0.5,-0.5];
                        pDefineWeldPos:=RelTool(pDefineWeldPos,0,0,0\Rx:=macroEndBuffer2{nMotionEndStep}.TravelAngle\Ry:=-1*macroEndBuffer2{nMotionEndStep}.WorkingAngle+nBreakPoint{2});
                    ENDIF

                    Welds2{nMotionStepCount{2}}.position:=pDefineWeldPos;
                    Welds2{nMotionStepCount{2}}.cpm:=macroEndBuffer2{nMotionEndStep}.WeldingSpeed;
                    Welds2{nMotionStepCount{2}}.voltage:=macroEndBuffer2{nMotionEndStep}.Voltage;
                    Welds2{nMotionStepCount{2}}.Current:=macroEndBuffer2{nMotionEndStep}.Current;
                    Welds2{nMotionStepCount{2}}.wfs:=macroEndBuffer2{nMotionEndStep}.FeedingSpeed;

                    Welds2{nMotionStepCount{2}}.WeaveShape:=macroEndBuffer2{nMotionEndStep}.WeaveShape;
                    Welds2{nMotionStepCount{2}}.WeaveLength:=macroEndBuffer2{nMotionEndStep}.WeaveLength;
                    Welds2{nMotionStepCount{2}}.WeaveWidth:=macroEndBuffer2{nMotionEndStep}.WeaveWidth;
                    Welds2{nMotionStepCount{2}}.WeaveDwellLeft:=macroEndBuffer2{nMotionEndStep}.WeaveDwellLeft;
                    Welds2{nMotionStepCount{2}}.WeaveDwellRight:=macroEndBuffer2{nMotionEndStep}.WeaveDwellRight;
                    Welds2{nMotionStepCount{2}}.WeaveType:=macroEndBuffer2{nMotionEndStep}.WeaveType;

                    Welds2{nMotionStepCount{2}}.TrackType:=macroEndBuffer2{nMotionEndStep}.TrackType;
                    Welds2{nMotionStepCount{2}}.TrackGainY:=macroEndBuffer2{nMotionEndStep}.TrackGainY;
                    Welds2{nMotionStepCount{2}}.TrackGainZ:=macroEndBuffer2{nMotionEndStep}.TrackGainZ;
                    Welds2{nMotionStepCount{2}}.MaxCorr:=macroEndBuffer2{nMotionEndStep}.MaxCorr;
                    Welds2{nMotionStepCount{2}}.Bias:=macroEndBuffer2{nMotionEndStep}.Bias;
                ELSE
                    nMotionEndStep:=nMotionEndStep-1;
                    nMotionEndStepLast{2}:=nMotionEndStep;
                ENDIF
            ENDWHILE

            nMotionTotalStep{2}:=nMotionStartStep+nMacroBreakStepData+nMotionEndStep;
        ELSE
            TPWrite "wrong sMacro data had input.";
            Stop;
        ENDIF

        !STOP;
    ENDPROC

    PROC rDefineWobjWeldLine(pos posStart,pos posEnd)
        VAR pos posWeldingLineVector;
        VAR pos posUpVector:=[0,0,1];
        VAR pos posThickVector;

        VAR num nRx;
        VAR num nRy;
        VAR num nRz;

        VAR pos posStartBuffer;
        VAR pos posEndBuffer;

        posStartBuffer:=posStart;
        posEndBuffer:=posEnd;
        posWeldingLineVector:=CalcNormalVector(posStartBuffer,posEndBuffer);
        posThickVector:=CrossProd(posUpVector,posWeldingLineVector);
        rCreateMatrix posWeldingLineVector,posThickVector,posUpVector,rotationMatrix;
        rCalcEulerAngles rotationMatrix,nRx,nRy,nRz;

        wobjWeldLine:=wobj0;
        wobjWeldLine1:=wobj0;
        wobjWeldLine2:=wobj0;

        wobjWeldLine.uframe:=WobjFloor.uframe;
        wobjWeldLine.oframe.trans:=posStart;
        wobjWeldLine.oframe.rot:=OrientZYX(nRz,nRy,nRx);
        nAngleRzStore:=nRz;
        IF (nMacro010{1}=3 AND nMacro010{2}=3) OR (nMacro010{1}=4 AND nMacro010{2}=4) THEN
            IF (nLengthWeldLine<nOffsetLength*2) THEN
                nOffsetLengthBuffer:=10;
            ELSE
                nOffsetLengthBuffer:=10;
            ENDIF
        ELSE
            IF (nLengthWeldLine<nOffsetLength*2) THEN
                nOffsetLengthBuffer:=nLengthWeldLine/2;
            ELSE
                nOffsetLengthBuffer:=nOffsetLength;
            ENDIF
        ENDIF

        nWeldLineLength_R1:=nOffsetLengthBuffer*2;
        nWeldLineLength_R2:=nOffsetLengthBuffer*2;


        IF (nAngleRzStore<-90 OR 90<=nAngleRzStore) THEN
            bRobSwap:=TRUE;
            wobjWeldLine1.uframe:=[[488,-nOffsetLengthBuffer,nRobWeldSpaceHeight],[0,0.7071067812,0.7071067812,0]];
            wobjWeldLine2.uframe:=[[488,nOffsetLengthBuffer,nRobWeldSpaceHeight],[0,0.7071067812,-0.7071067812,0]];
        ELSE
            bRobSwap:=FALSE;
            wobjWeldLine1.uframe:=[[488,nOffsetLengthBuffer,nRobWeldSpaceHeight],[0,0.7071067812,-0.7071067812,0]];
            wobjWeldLine2.uframe:=[[488,-nOffsetLengthBuffer,nRobWeldSpaceHeight],[0,0.7071067812,0.7071067812,0]];
        ENDIF

        RETURN ;
    ENDPROC

    PROC rMoveCorrConnect(num X,num Y,num Z,num Rx,num Ry,num Rz,num Eax_d,bool isStartPos,bool CCW,\switch LIN)
        VAR robtarget pTempConnect;

        IF isStartPos=bStart THEN
            !            pTempConnect:=ConvertJointToCoord(Welds{1}.pgTarget.Point1);
            IF CCW=FALSE THEN
                pTempConnect.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
                pTempConnect.rot:=[0.5,0.5,-0.5,0.5];
                pTempConnect:=RelTool(pTempConnect,0,0,0\Rx:=-1*macroStartBuffer1{1}.TravelAngle\Ry:=-(1*macroStartBuffer1{1}.WorkingAngle+Ry));
            ELSE
                pTempConnect.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(-1*Y),nCorrZ_Store+(Z)];
                pTempConnect.rot:=[0.5,-0.5,-0.5,-0.5];
                pTempConnect:=RelTool(pTempConnect,0,0,0\Rx:=macroStartBuffer1{1}.TravelAngle\Ry:=-(1*macroStartBuffer1{1}.WorkingAngle+Ry));
            ENDIF
        ELSEIF isStartPos=bEnd THEN
            !            pTempConnect:=ConvertJointToCoord(Welds{nMotionStepCount}.pgTarget.Point1);
            IF CCW=FALSE THEN
                pTempConnect.trans:=[nLengthWeldLine+nCorrX_Store+(X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
                pTempConnect.rot:=[0.5,0.5,-0.5,0.5];
                pTempConnect:=RelTool(pTempConnect,0,0,0\Rx:=-1*macroEndBuffer1{nMotionEndStepLast{1}}.TravelAngle\Ry:=-(1*macroEndBuffer1{nMotionEndStepLast{1}}.WorkingAngle+Ry));
            ELSE
                pTempConnect.trans:=[nLengthWeldLine+nCorrX_Store+(X),nCorrY_Store+(-1*Y),nCorrZ_Store+(Z)];
                pTempConnect.rot:=[0.5,-0.5,-0.5,-0.5];
                pTempConnect:=RelTool(pTempConnect,0,0,0\Rx:=macroEndBuffer1{nMotionEndStepLast{1}}.TravelAngle\Ry:=-(1*macroEndBuffer1{nMotionEndStepLast{1}}.WorkingAngle+Ry));
            ENDIF
        ENDIF

        pTempConnect.extax.eax_d:=Eax_d;

        IF Present(LIN)=FALSE THEN
            MoveJ pTempConnect,v300,fine,tWeld\WObj:=wobjWeldLine;
        ELSE
            MoveL pTempConnect,v300,fine,tWeld\WObj:=wobjWeldLine;
        ENDIF

        RETURN ;
    ENDPROC

    PROC rMoveHome()
        VAR jointtarget jEmptyTarget:=[[0,90,-30,0,15,0],[0,0,6000,0,9e+09,9e+09]];

        !        IF po03_Home=0 THEN
        !            rMoveToRobotHome;
        !        ENDIF

        jEmptyTarget:=jHomeJoint;

        jEmptyTarget.extax.eax_a:=jHomeJoint.extax.eax_a+nHomeAdjustX;
        jEmptyTarget.extax.eax_b:=jHomeJoint.extax.eax_b+nHomeAdjustY;
        jEmptyTarget.extax.eax_c:=jHomeJoint.extax.eax_c+nHomeAdjustZ;
        jEmptyTarget.extax.eax_d:=jHomeJoint.extax.eax_d+nHomeAdjustR;

        MoveJgJ jgHomeJoint,vTargetSpeed,fine;

        !        rMoveToRobotHome;

    ENDPROC

    PROC rMoveNoWeld()
        !        VAR num i:=1;
        !        FOR i FROM 1 TO nMotionStepCount{1} DO
        !        vWeld{i}.v_leax:=vWeld{i}.v_leax*1;
        !        vWeld{i}.v_ori:=vWeld{i}.v_ori*1;
        !        vWeld{i}.v_reax:=vWeld{i}.v_reax*1;
        !        vWeld{i}.v_tcp:=vWeld{i}.v_tcp*1;
        !        nRunningStep{1}:=i;
        !        MovePgJ MergePgWith(\Rob1:=pWeldPosR1{i}\Rob2:=pWeldPosR1{i}\Gantry:=pWeldPosG{1}),vWeld{i},fine;
        !        MovePgJ MergePgWith(\Rob1:=pWeldPosR1{i}),vWeld{i},fine;
        !        MovePgJ MergePgWith(\Rob1:=pWeldPosR1{i}),vWeld{i},fine;
        !        MovePgJ MergePgWith(\Rob1:=pWeldPosR1{i}),vWeld{i},fine;
        !        MovePgJ MergePgWith(\Rob1:=pWeldPosR1{i}),vWeld{i},fine;
        !        MovePgJ MergePgWith(\Rob1:=pWeldPosR1{i}),vWeld{i},fine;
        !Stop;
        !        ENDFOR




        stCommand:="Weld";
        WaitUntil stReact=["WeldOk","WeldOk","WeldOk"];
        stCommand:="";
        WaitUntil stReact=["Ready","Ready","Ready"];

        RETURN ;
    ENDPROC

    PROC rMoveStep()
        VAR robtarget transformed;
        VAR robtarget pTemp;
        VAR robtarget pTemp1;
        VAR robtarget pTempR1;
        VAR robtarget pTempR2;
        VAR robtarget pTempG;
        VAR pointgroup pTempGroup;

        VAR jointtarget jWeldPrepareR1{10};
        VAR jointtarget jWeldPrepareR2{10};
        VAR jointtarget jTemp;
        VAR jointtarget jTemp1;
        VAR jointtarget jTempR1;
        VAR jointtarget jTempR2;
        VAR jointtarget jTempG;
        VAR jointtarget jTempGantry{2};
        VAR jointgroup jTempReadyGroup;
        VAR jointgroup jTempGroup;

        VAR jointtarget jMoveGantry;
        VAR num nZdata;
        VAR num nOtherZdata;
        VAR num nExcutionStep;
        VAR num nAngle;
        VAR num nAngleStart;
        VAR num nAngleEnd;

        VAR num nTempVolt;
        VAR num nTempWFS;
        VAR num nTempMmps;
        VAR num nMaxPartHeightTemp;
        VAR num nHeightTemp;
        VAR bool bHeightMotion;
        Command:=0;
        nMotionStep:=1;
        !        nMaxPartHeightNearArray:=[790,790,790];
        ClkReset clockCycleTime;
        ClkStart clockCycleTime;

        bCorrectionOk:=FALSE;
        !!!!!!
        posStart:=(edgeStart{1}.EdgePos+edgeStart{2}.EdgePos)/2;
        nStartThick:=VectMagn(edgeStart{2}.EdgePos-edgeStart{1}.EdgePos);
        IF nStartThick>50 Stop;
        posEnd:=(edgeEnd{1}.EdgePos+edgeEnd{2}.EdgePos)/2;
        nEndThick:=VectMagn(edgeEnd{2}.EdgePos-edgeEnd{1}.EdgePos);
        IF nEndThick>50 Stop;
        !        IF (posStartLast<>posStart) OR (posEndLast<>posEnd) THEN
        !            bTouchWorkCount:=[FALSE,FALSE,FALSE,FALSE,FALSE,FALSE];
        !        ENDIF

        posStartLast:=posStart;
        posEndLast:=posEnd;
        !!!!!!

        rDefineWobjWeldLine posStart,posEnd;
        nBreakPoint:=[0,0];
        IF bRobSwap=FALSE THEN
            IF bBreakPoint{1}=TRUE THEN
                nBreakPoint{1}:=-5;
            ELSE
                nBreakPoint{1}:=0;
            ENDIF
            IF bBreakPoint{2}=TRUE THEN
                nBreakPoint{2}:=-5;
            ELSE
                nBreakPoint{2}:=0;
            ENDIF
        ELSE
            IF bBreakPoint{1}=TRUE THEN
                nBreakPoint{2}:=-5;
            ELSE
                nBreakPoint{2}:=0;
            ENDIF
            IF bBreakPoint{2}=TRUE THEN
                nBreakPoint{1}:=-5;
            ELSE
                nBreakPoint{1}:=0;
            ENDIF
        ENDIF
        rDefineWeldPosR1;
        rDefineWeldPosR2;
        rDefineWeldPosG;

        !!!!!!!!!!!!
        !        IF (nMaxPartHeightNearArray{1}<nMaxPartHeightNearArray{2}) nMaxPartHeightNearArray{1}:=nMaxPartHeightNearArray{2};
        !!!!!!!!!!!!

        IF nMotionStep=1 THEN
            !Gantry move

            jMoveGantry:=CJointT();
            IF (bEnableStartEndPointCorr=TRUE) THEN
                IF nMaxPartHeightNearArray{3}>800 OR nMaxPartHeightNearArray{2}>800 THEN
                    rMeasurementHomeCheck;
                ELSE
                    rjgWireCutHomeCheck;
                ENDIF
            ELSE
                IF nMaxPartHeightNearArray{1}>800 OR nMaxPartHeightNearArray{2}>800 THEN
                    rMeasurementHomeCheck;
                ELSE
                    rjgWireCutHomeCheck;
                ENDIF
            ENDIF

            IF (bEnableStartEndPointCorr=FALSE) jMoveGantry:=fnCoordToJoint(fnPoseToExtax(WeldsG{1}.position));
            IF (bEnableStartEndPointCorr=TRUE) jMoveGantry:=fnCoordToJoint(fnPoseToExtax(WeldsG{2}.position));
            jMoveGantry.extax.eax_c:=nTargetGantryHeight;
            jMoveGantry.extax.eax_c:=Limit(0,1000,jMoveGantry.extax.eax_c);
            MoveJgJ MergeJgWith(\Gantry:=jMoveGantry),vTargetSpeed,z200;
            WaitRob\ZeroSpeed;

            IF (bEnableStartEndPointCorr=TRUE) THEN
                IF nMaxPartHeightNearArray{3}>800 OR nMaxPartHeightNearArray{2}>800 THEN
                    rWirecutMove 3;
                ELSE
                    rWirecutShot 3;
                ENDIF
            ELSE
                IF nMaxPartHeightNearArray{1}>800 OR nMaxPartHeightNearArray{2}>800 THEN
                    rWirecutMove 3;
                ELSE
                    rWirecutShot 3;
                ENDIF
            ENDIF
            jTempReadyGroup:=MergeJgWith();
            !Rbt_1 And Rbt_2 Ready+GantryHeight
            jTempReadyGroup.Joint1.robax.rax_2:=jJointStepArray{6}.robax.rax_2;
            jTempReadyGroup.Joint1.robax.rax_3:=jJointStepArray{6}.robax.rax_3;
            jTempReadyGroup.Joint1.robax.rax_4:=jJointStepArray{6}.robax.rax_4;
            jTempReadyGroup.Joint1.robax.rax_5:=jJointStepArray{6}.robax.rax_5;
            jTempReadyGroup.Joint1.robax.rax_6:=jJointStepArray{6}.robax.rax_6;

            jTempReadyGroup.Joint2.robax.rax_2:=jJointStepArray{6}.robax.rax_2;
            jTempReadyGroup.Joint2.robax.rax_3:=jJointStepArray{6}.robax.rax_3;
            jTempReadyGroup.Joint2.robax.rax_4:=jJointStepArray{6}.robax.rax_4;
            jTempReadyGroup.Joint2.robax.rax_5:=jJointStepArray{6}.robax.rax_5;
            jTempReadyGroup.Joint2.robax.rax_6:=jJointStepArray{6}.robax.rax_6;

            MoveJgJ MergeJgWith(\Rob1:=jTempReadyGroup.Joint1\Rob2:=jTempReadyGroup.Joint2),vTargetSpeed,z200;

            jTempReadyGroup.Joint1.robax.rax_1:=0;
            jTempReadyGroup.Joint2.robax.rax_1:=0;
            MoveJgJ MergeJgWith(\Rob1:=jTempReadyGroup.Joint1\Rob2:=jTempReadyGroup.Joint2),vTargetSpeed,z200;

        ENDIF

        !!! Joint move to ready pose !!!
        nMotionStep:=2;

        IF nMotionStep=2 THEN
            jReadyGantryHeightBuffer:=CJointT();

            FOR i FROM 1 TO 10 DO
                TEST i
                CASE 1,2,3,4,5:
                    jWeldPrepareR1{i}:=CJointT(\TaskName:="T_ROB1");
                    jWeldPrepareR2{i}:=CJointT(\TaskName:="T_ROB2");
                CASE 6,7,8,9,10:
                    jWeldPrepareR1{i}:=CJointT(\TaskName:="T_ROB1");
                    jWeldPrepareR1{i}.robax.rax_1:=0;

                    jWeldPrepareR2{i}:=CJointT(\TaskName:="T_ROB2");
                    jWeldPrepareR2{i}.robax.rax_1:=0;
                    !      jWeldPrepareR2{i}.extax.eax_c:=Limit(0,1000,wobjWeldLine.uframe.trans.z-((nRobWorkSpaceHeight+120)+wobjWeldLine.oframe.trans.z+nMaxPartHeightNearArray{3}+200));
                ENDTEST
                jWeldPrepareR1{i}.robax.rax_2:=jJointStepArray{i}.robax.rax_2;
                jWeldPrepareR1{i}.robax.rax_3:=jJointStepArray{i}.robax.rax_3;
                jWeldPrepareR1{i}.robax.rax_4:=jJointStepArray{i}.robax.rax_4;
                jWeldPrepareR1{i}.robax.rax_5:=jJointStepArray{i}.robax.rax_5;
                jWeldPrepareR1{i}.robax.rax_6:=jJointStepArray{i}.robax.rax_6;

                jWeldPrepareR2{i}.robax.rax_2:=jJointStepArray{i}.robax.rax_2;
                jWeldPrepareR2{i}.robax.rax_3:=jJointStepArray{i}.robax.rax_3;
                jWeldPrepareR2{i}.robax.rax_4:=jJointStepArray{i}.robax.rax_4;
                jWeldPrepareR2{i}.robax.rax_5:=jJointStepArray{i}.robax.rax_5;
                jWeldPrepareR2{i}.robax.rax_6:=jJointStepArray{i}.robax.rax_6;
            ENDFOR

            IF (NOT jJointStepArray{1}.robax=[0,0,0,0,0,0]) MoveJgJ MergeJgWith(\Rob1:=jWeldPrepareR1{1}\Rob2:=jWeldPrepareR2{1}),vTargetSpeed,zTargetZone;
            IF (NOT jJointStepArray{2}.robax=[0,0,0,0,0,0]) MoveJgJ MergeJgWith(\Rob1:=jWeldPrepareR1{2}\Rob2:=jWeldPrepareR2{2}),vTargetSpeed,zTargetZone;
            IF (NOT jJointStepArray{3}.robax=[0,0,0,0,0,0]) MoveJgJ MergeJgWith(\Rob1:=jWeldPrepareR1{3}\Rob2:=jWeldPrepareR2{3}),vTargetSpeed,zTargetZone;
            IF (NOT jJointStepArray{4}.robax=[0,0,0,0,0,0]) MoveJgJ MergeJgWith(\Rob1:=jWeldPrepareR1{4}\Rob2:=jWeldPrepareR2{4}),vTargetSpeed,zTargetZone;
            IF (NOT jJointStepArray{5}.robax=[0,0,0,0,0,0]) MoveJgJ MergeJgWith(\Rob1:=jWeldPrepareR1{5}\Rob2:=jWeldPrepareR2{5}),vTargetSpeed,zTargetZone;

            IF (NOT jJointStepArray{6}.robax=[0,0,0,0,0,0]) MoveJgJ MergeJgWith(\Rob1:=jWeldPrepareR1{6}\Rob2:=jWeldPrepareR2{6}),vTargetSpeed,zTargetZone;
            IF (NOT jJointStepArray{7}.robax=[0,0,0,0,0,0]) MoveJgJ MergeJgWith(\Rob1:=jWeldPrepareR1{7}\Rob2:=jWeldPrepareR2{7}),vTargetSpeed,zTargetZone;
            IF (NOT jJointStepArray{8}.robax=[0,0,0,0,0,0]) MoveJgJ MergeJgWith(\Rob1:=jWeldPrepareR1{8}\Rob2:=jWeldPrepareR2{8}),vTargetSpeed,zTargetZone;
            IF (NOT jJointStepArray{9}.robax=[0,0,0,0,0,0]) MoveJgJ MergeJgWith(\Rob1:=jWeldPrepareR1{9}\Rob2:=jWeldPrepareR2{9}),vTargetSpeed,zTargetZone;
            IF (NOT jJointStepArray{10}.robax=[0,0,0,0,0,0]) MoveJgJ MergeJgWith(\Rob1:=jWeldPrepareR1{10}\Rob2:=jWeldPrepareR2{10}),vTargetSpeed,zTargetZone;
            WaitRob\inpos;
            pSearchReadyGroup:=MergePgWith();
            jSearchReadyGroup:=MergeJgWith();
            jTempReadyGroup:=MergeJgWith();

            jTempGantry{1}:=fnCoordToJoint(fnPoseToExtax(WeldsG{1}.position));
            jTempReadyGroup.JointG.extax.eax_c:=jTempGantry{1}.extax.eax_c;
            MoveJgJ MergeJgWith(\Gantry:=jTempReadyGroup.JointG),vTargetSpeed,z200;
        ENDIF

        !!! Weld Process !!!
        Reset do13_Torch1_Air_Cooling;
        nMotionStep:=3;
        IF nMotionStep=3 THEN
            !         rConfOff;
            !SingArea\Wrist;

            FOR i FROM 1 TO nMotionStepCount{1} DO
                nExcutionStep:=i;

                !!! [mm/sec] = [cm/sec]*10 = [cm/min]*10/60 = [cm/min]/6!!!
                nTempMmps:=Welds1{i}.cpm/6;
                nTempVolt:=Welds1{i}.voltage;
                nTempWFS:=Welds1{i}.wfs;
                wdArray{i}:=[nTempMmps,0,[5,0,nTempVolt,nTempWFS,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
                ! vWeld{i}:=[nTempMmps,200,200,200];

                !                pWeldPos{i}:=Welds{i}.pgTarget,JointGantry;
                pWeldPosG{i}.extax.eax_a:=nHomeGantryX+Welds1{i}.position.extax.eax_a;
                pWeldPosG{i}.extax.eax_f:=nHomeGantryX+Welds1{i}.position.extax.eax_f;
                pWeldPosG{i}.extax.eax_b:=nHomeGantryY+Welds1{i}.position.extax.eax_b;
                !                nTempAdjustGantryZ:=(posEnd.z-posStart.z)*(pWeldPosG{i}.trans.x/nLengthWeldLine);
                pWeldPosG{i}.extax.eax_c:=Limit(0,1500,wobjWeldLine.uframe.trans.z-(nRobWeldSpaceHeight+wobjWeldLine.oframe.trans.z+nTempAdjustGantryZ));
            ENDFOR

            jSearchReady:=CJointT();

            IF (bEnableStartEndPointCorr=TRUE) THEN
                !                Set ln1di01_TouchSensed;
                !                IDelete innumError_1;
                !                CONNECT innumError_1 WITH trapGoToHome_1;
                !                ISignalDI siLn1Current,1,innumError_1;
                !                IWatch innumError_1;
                !                stop;
                rCorrStartEndPoint;

                FOR i FROM 1 TO nMotionStepCount{1} DO
                    nExcutionStep:=i;

                    !!! [mm/sec] = [cm/sec]*10 = [cm/min]*10/60 = [cm/min]/6!!!
                    nTempMmps:=Welds1{i}.cpm/6;
                    nTempVolt:=Welds1{i}.voltage;
                    nTempWFS:=Welds1{i}.wfs;
                    wdArray{i}:=[nTempMmps,0,[5,0,nTempVolt,nTempWFS,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
                    !   vWeld{i}:=[nTempMmps,200,200,200];

                    !                    pWeldPos{i}:=Welds{i}.position;
                    pWeldPosG{i}.extax.eax_a:=nHomeGantryX+Welds1{i}.position.extax.eax_a;
                    pWeldPosG{i}.extax.eax_f:=nHomeGantryX+Welds1{i}.position.extax.eax_f;
                    pWeldPosG{i}.extax.eax_b:=nHomeGantryY+Welds1{i}.position.extax.eax_b;
                    !                nTempAdjustGantryZ:=(posEnd.z-posStart.z)*(pWeldPosG{i}.trans.x/nLengthWeldLine);
                    pWeldPosG{i}.extax.eax_c:=Limit(0,1500,wobjWeldLine.uframe.trans.z-(nRobWeldSpaceHeight+wobjWeldLine.oframe.trans.z+nTempAdjustGantryZ));

                ENDFOR
            ENDIF

            IF (bEnableWeldSkip=TRUE) THEN
                Set soAwManFeedRev;
                Set soAwManFeedRev2;
                WaitTime 0.5;
                Reset soAwManFeedRev;
                Reset soAwManFeedRev2;

                rMoveNoWeld;
            ELSE
                !                ArcRefresh;
                WaitTime 0;
                rMoveWeld;
            ENDIF
            jTempReadyGroup:=MergeJgWith();
            jTempReadyGroup.Joint1:=jSearchReadyGroup.Joint1;
            jTempReadyGroup.Joint2:=jSearchReadyGroup.Joint2;
            jTempReadyGroup.JointG.extax.eax_c:=jTempReadyGroup.JointG.extax.eax_c-100;
            MoveJgJ MergeJgWith(\Rob1:=jTempReadyGroup.Joint1\Rob2:=jTempReadyGroup.Joint2\Gantry:=jTempReadyGroup.JointG),vTargetSpeed,z200;
        ENDIF

        !!! Return to gantry ready posistion !!!

        nMotionStep:=4;
        IF nMotionStep=4 THEN

            jTempReadyGroup:=MergeJgWith();
            jTempReadyGroup.JointG.extax.eax_c:=Limit(0,1500,wobjWeldLine.uframe.trans.z-(nRobWeldSpaceHeight+wobjWeldLine.oframe.trans.z+nMaxPartHeightNearArray{3}+200));
            MoveJgJ MergeJgWith(\Gantry:=jTempReadyGroup.JointG),vTargetSpeed,z200;
            WaitRob\inpos;

            FOR i FROM 1 TO 10 DO
                TEST i
                CASE 1,2,3,4,5:
                    jWeldPrepareR1{i}:=CJointT(\TaskName:="T_ROB1");
                    jWeldPrepareR1{i}.robax.rax_1:=0;

                    jWeldPrepareR2{i}:=CJointT(\TaskName:="T_ROB2");
                    jWeldPrepareR2{i}.robax.rax_1:=0;
                CASE 6,7,8,9,10:
                    jWeldPrepareR1{i}:=CJointT(\TaskName:="T_ROB1");
                    jWeldPrepareR2{i}:=CJointT(\TaskName:="T_ROB2");
                ENDTEST
                jWeldPrepareR1{i}.robax.rax_2:=jJointStepArray{i}.robax.rax_2;
                jWeldPrepareR1{i}.robax.rax_3:=jJointStepArray{i}.robax.rax_3;
                jWeldPrepareR1{i}.robax.rax_4:=jJointStepArray{i}.robax.rax_4;
                jWeldPrepareR1{i}.robax.rax_5:=jJointStepArray{i}.robax.rax_5;
                jWeldPrepareR1{i}.robax.rax_6:=jJointStepArray{i}.robax.rax_6;

                jWeldPrepareR2{i}.robax.rax_2:=jJointStepArray{i}.robax.rax_2;
                jWeldPrepareR2{i}.robax.rax_3:=jJointStepArray{i}.robax.rax_3;
                jWeldPrepareR2{i}.robax.rax_4:=jJointStepArray{i}.robax.rax_4;
                jWeldPrepareR2{i}.robax.rax_5:=jJointStepArray{i}.robax.rax_5;
                jWeldPrepareR2{i}.robax.rax_6:=jJointStepArray{i}.robax.rax_6;
            ENDFOR

            !            IF (NOT jJointStepArray{10}.robax=[0,0,0,0,0,0]) MoveAbsJ jWeldPrepareArray{10},v500,zTargetZone,tool0;
            IF (NOT jJointStepArray{9}.robax=[0,0,0,0,0,0]) MoveJgJ MergeJgWith(\Rob1:=jWeldPrepareR1{9}\Rob2:=jWeldPrepareR2{9}),vTargetSpeed,zTargetZone;
            IF (NOT jJointStepArray{8}.robax=[0,0,0,0,0,0]) MoveJgJ MergeJgWith(\Rob1:=jWeldPrepareR1{8}\Rob2:=jWeldPrepareR2{8}),vTargetSpeed,zTargetZone;
            IF (NOT jJointStepArray{7}.robax=[0,0,0,0,0,0]) MoveJgJ MergeJgWith(\Rob1:=jWeldPrepareR1{7}\Rob2:=jWeldPrepareR2{7}),vTargetSpeed,zTargetZone;
            IF (NOT jJointStepArray{6}.robax=[0,0,0,0,0,0]) MoveJgJ MergeJgWith(\Rob1:=jWeldPrepareR1{6}\Rob2:=jWeldPrepareR2{6}),vTargetSpeed,zTargetZone;

            !            jMoveReady:=CJointT();
            !            jMoveReady.robax.rax_1:=0;
            !            !            MoveAbsJ jMoveReady,vTargetSpeed,TargetZone,tool0;
            !            MoveAbsJ jMoveReady,vTargetSpeed,TargetZone,tool0;

            IF (NOT jJointStepArray{5}.robax=[0,0,0,0,0,0]) MoveJgJ MergeJgWith(\Rob1:=jWeldPrepareR1{5}\Rob2:=jWeldPrepareR2{5}),vTargetSpeed,zTargetZone;
            IF (NOT jJointStepArray{4}.robax=[0,0,0,0,0,0]) MoveJgJ MergeJgWith(\Rob1:=jWeldPrepareR1{4}\Rob2:=jWeldPrepareR2{4}),vTargetSpeed,zTargetZone;
            IF (NOT jJointStepArray{3}.robax=[0,0,0,0,0,0]) MoveJgJ MergeJgWith(\Rob1:=jWeldPrepareR1{3}\Rob2:=jWeldPrepareR2{3}),vTargetSpeed,zTargetZone;
            IF (NOT jJointStepArray{2}.robax=[0,0,0,0,0,0]) MoveJgJ MergeJgWith(\Rob1:=jWeldPrepareR1{2}\Rob2:=jWeldPrepareR2{2}),vTargetSpeed,zTargetZone;
            IF (NOT jJointStepArray{1}.robax=[0,0,0,0,0,0]) MoveJgJ MergeJgWith(\Rob1:=jWeldPrepareR1{1}\Rob2:=jWeldPrepareR2{1}),vTargetSpeed,zTargetZone;

        ENDIF

        nMotionStep:=5;
        IF nMotionStep=5 THEN
            !move to joint home
            PulseDO\high\PLength:=50,do13_Torch1_Air_Cooling;
            PulseDO\high\PLength:=50,do14_Torch2_Air_Cooling;

            !      rConfOn;
            !     SingArea\off;
            jTempReadyGroup:=MergeJgWith();

            IF nMaxPartHeightNearArray{3}>800 THEN
                jTempReadyGroup.Joint1.robax.rax_1:=jgMeasurementHome.Joint1.robax.rax_1;
                jTempReadyGroup.Joint2.robax.rax_1:=jgMeasurementHome.Joint2.robax.rax_1;
            ELSE
                jTempReadyGroup.Joint1.robax.rax_1:=jgWireCutHome.Joint1.robax.rax_1;
                jTempReadyGroup.Joint2.robax.rax_1:=jgWireCutHome.Joint2.robax.rax_1;
            ENDIF
            MoveJgJ MergeJgWith(\Rob1:=jTempReadyGroup.Joint1\Rob2:=jTempReadyGroup.Joint2),vTargetSpeed,z200;

            jTempReadyGroup:=MergeJgWith();
            IF nMaxPartHeightNearArray{3}>800 THEN
                jTempReadyGroup.Joint1:=jgMeasurementHome.Joint1;
                jTempReadyGroup.Joint2:=jgMeasurementHome.Joint2;
            ELSE
                jTempReadyGroup.Joint1:=jgWireCutHome.Joint1;
                jTempReadyGroup.Joint2:=jgWireCutHome.Joint2;
            ENDIF
            MoveJgJ MergeJgWith(\Rob1:=jTempReadyGroup.Joint1\Rob2:=jTempReadyGroup.Joint2\Gantry:=jTempReadyGroup.JointG),vTargetSpeed,z200;
        ENDIF

        !  SingArea\Off;
        WaitRob\inpos;
        !MoveAbsJ jMoveReady,v500,TargetZone,tool0;
        ClkStop clockCycleTime;
        nclockCycleTime:=ClkRead(clockCycleTime);
    ENDPROC

    PROC rMoveTeachingPoseR1()
        VAR jointgroup jgTemp{10};
        VAR jointtarget jTempG;
        VAR robtarget pTemp{2};
        VAR num nRbtSelection:=0;

        rMoveToRobotHome;

        !!! Save Current Location To jTempCurrentExtax
        jTempG:=CJointT(\TaskName:="T_Gantry");
        ! Calling a Routine To Send The Robot Home
        !        rRbtCheckAtHome;
        !!! Save Current Location To jTemp
        !!! Load Teaching Location

        jgTemp{1}.Joint2:=CJointT(\TaskName:="T_Rob2");
        jgTemp{2}.Joint2:=CJointT(\TaskName:="T_Rob2");
        jgTemp{3}.Joint2:=CJointT(\TaskName:="T_Rob2");
        jgTemp{4}.Joint2:=CJointT(\TaskName:="T_Rob2");
        jgTemp{5}.Joint2:=CJointT(\TaskName:="T_Rob2");

        jgTemp{1}.Joint1.robax:=jgHomeJoint.Joint1.robax;
        jgTemp{2}.Joint1.robax:=jgTemp{1}.Joint1.robax;
        jgTemp{2}.Joint1.robax.rax_2:=-90;
        jgTemp{2}.Joint1.robax.rax_3:=60;
        jgTemp{3}.Joint1.robax:=[jgTemp{2}.Joint1.robax.rax_1,-24.4,-31.97,0,-34,1];
        jgTemp{4}.Joint1.robax:=jgTemp{3}.Joint1.robax;
        jgTemp{4}.Joint1.robax.rax_1:=0;
        FOR i FROM 1 TO 4 DO
            jgTemp{i}.JointG:=jTempG;
            MoveJgJ MergeJgWith(\Rob1:=jgTemp{i}.Joint1\Gantry:=jgTemp{i}.JointG),vTargetSpeed,z200;
        ENDFOR
        RETURN ;
    ENDPROC

    PROC rMoveTeachingPoseR2()
        VAR jointgroup jgTemp{10};
        VAR jointtarget jTempG;
        VAR robtarget pTemp{2};
        VAR num nRbtSelection:=0;

        rMoveToRobotHome;

        !!! Save Current Location To jTempCurrentExtax
        jTempG:=CJointT(\TaskName:="T_Gantry");
        ! Calling a Routine To Send The Robot Home
        !        rRbtCheckAtHome;
        !!! Save Current Location To jTemp
        !!! Load Teaching Location

        jgTemp{1}.Joint1:=CJointT(\TaskName:="T_Rob1");
        jgTemp{2}.Joint1:=CJointT(\TaskName:="T_Rob1");
        jgTemp{3}.Joint1:=CJointT(\TaskName:="T_Rob1");
        jgTemp{4}.Joint1:=CJointT(\TaskName:="T_Rob1");
        jgTemp{5}.Joint1:=CJointT(\TaskName:="T_Rob1");

        jgTemp{1}.Joint2.robax:=jgHomeJoint.Joint2.robax;
        jgTemp{2}.Joint2.robax:=jgTemp{1}.Joint2.robax;
        jgTemp{2}.Joint2.robax.rax_2:=-90;
        jgTemp{2}.Joint2.robax.rax_3:=60;
        jgTemp{3}.Joint2.robax:=[jgTemp{2}.Joint2.robax.rax_1,-24.4,-31.97,0,-34,1];
        jgTemp{4}.Joint2.robax:=jgTemp{3}.Joint2.robax;
        jgTemp{4}.Joint2.robax.rax_1:=0;

        FOR i FROM 1 TO 4 DO
            jgTemp{i}.JointG:=jTempG;
            MoveJgJ MergeJgWith(\Rob2:=jgTemp{i}.Joint2\Gantry:=jgTemp{i}.JointG),vTargetSpeed,z200;
        ENDFOR
        RETURN ;
    ENDPROC

    PROC rMoveTo6AxisRobotHome()
        VAR jointtarget jEmptyTarget;
        VAR num ntemp;
        AccSet 50,50;
        VelSet 100,400;

        jEmptyTarget:=CJointT();
        ntemp:=jEmptyTarget.extax.eax_d;
        IF Abs(ntemp)>650 THEN
            jEmptyTarget.extax.eax_d:=650;
            MoveAbsJ jEmptyTarget,vTargetSpeed,fine,tool0;
        ENDIF

        ntemp:=jEmptyTarget.robax.rax_2-jHomeJoint.robax.rax_2;
        IF Abs(ntemp)>1 THEN
            jEmptyTarget.robax.rax_2:=-60;
        ENDIF
        ntemp:=jEmptyTarget.robax.rax_3-jHomeJoint.robax.rax_3;
        IF Abs(ntemp)>1 THEN
            jEmptyTarget.robax.rax_3:=60;
        ENDIF
        ntemp:=jEmptyTarget.robax.rax_5-jHomeJoint.robax.rax_5;
        IF Abs(ntemp)>1 THEN
            jEmptyTarget.robax.rax_5:=30;
        ENDIF
        MoveAbsJ jEmptyTarget,vTargetSpeed,fine,tool0;
        ntemp:=jEmptyTarget.robax.rax_1-jHomeJoint.robax.rax_1;
        IF Abs(ntemp)>1 THEN
            jEmptyTarget.robax.rax_1:=jHomeJoint.robax.rax_1;
            MoveAbsJ jEmptyTarget,vTargetSpeed,fine,tool0;
        ENDIF

        jEmptyTarget.robax:=jHomeJoint.robax;
        MoveAbsJ jEmptyTarget,vTargetSpeed,fine,tool0;

        RETURN ;
    ENDPROC

    PROC rMoveToGantryInAbs()
        VAR jointtarget jTemp1;
        VAR jointtarget jTemp2;
        VAR jointtarget jTempG;
        VAR jointtarget jTempGBuffer;
        VAR jointgroup jgTemp;
        VAR string sTime;
        VAR num nGantry_R;

        sTime:=CTime();
        TPWrite "TIME ("+sTime+") | CmdOutput : "+ValToStr(nCmdOutput);

        jTemp1:=CJointT(\TaskName:="T_Rob1");
        jTemp2:=CJointT(\TaskName:="T_Rob2");
        jTempG:=CJointT(\TaskName:="T_Gantry");
        jTempGBuffer:=CJointT(\TaskName:="T_Gantry");

        jTempG.extax.eax_a:=nHomeGantryX+extGantryPos.eax_a;
        jTempG.extax.eax_b:=nHomeGantryY-extGantryPos.eax_b;
        jTempG.extax.eax_c:=nHomeGantryZ-extGantryPos.eax_c;
        jTempG.extax.eax_d:=nHomeGantryR-extGantryPos.eax_d;
        jTempG.extax.eax_f:=jTempG.extax.eax_a;

        jgTemp.Joint1:=jTemp1;
        jgTemp.Joint2:=jTemp2;
        jgTemp.JointG:=jTempG;

        MoveJgJ jgTemp,vTargetSpeed,fine;
        WaitRob\inpos;
    ENDPROC

    PROC rMoveToGantryInInc()
        VAR jointtarget jTemp1;
        VAR jointtarget jTemp2;
        VAR jointtarget jTempG;
        VAR jointgroup jgTemp;

        jTemp1:=CJointT(\TaskName:="T_Rob1");
        jTemp2:=CJointT(\TaskName:="T_Rob2");
        jTempG:=CJointT(\TaskName:="T_Gantry");

        jTempG.extax.eax_a:=jTempG.extax.eax_a+extGantryPos.eax_a;
        jTempG.extax.eax_b:=jTempG.extax.eax_b-extGantryPos.eax_b;
        jTempG.extax.eax_c:=jTempG.extax.eax_c-extGantryPos.eax_c;
        jTempG.extax.eax_d:=jTempG.extax.eax_d-extGantryPos.eax_d;
        jTempG.extax.eax_f:=jTempG.extax.eax_a;

        jgTemp.Joint1:=jTemp1;
        jgTemp.Joint2:=jTemp2;
        jgTemp.JointG:=jTempG;

        MoveJgJ jgTemp,vTargetSpeed,fine;
        WaitRob\inpos;
    ENDPROC

    PROC rMoveToRobotHome()
        VAR jointgroup jgEmptyTarget;
        VAR jointgroup jMoveHomeHomeGroup;
        VAR jointtarget jTempG;
        VAR num ntemp;
        VAR bool bHomeCheck:=FALSE;
        bHomeCheck:=FALSE;
        stCommand:="checkpos";
        waituntil stReact=["checkposok","checkposok","checkposok"];
        stCommand:="";
        waituntil stReact=["Ready","Ready","Ready"];

        jMoveHomeHomeGroup:=MergeJgWith();
        IF abs(jMoveHomeHomeGroup.Joint1.robax.rax_1-jgHomeJoint.Joint1.robax.rax_1)>1 bHomeCheck:=TRUE;
        IF abs(jMoveHomeHomeGroup.Joint1.robax.rax_2-jgHomeJoint.Joint1.robax.rax_2)>1 bHomeCheck:=TRUE;
        IF abs(jMoveHomeHomeGroup.Joint1.robax.rax_3-jgHomeJoint.Joint1.robax.rax_3)>1 bHomeCheck:=TRUE;
        IF abs(jMoveHomeHomeGroup.Joint1.robax.rax_4-jgHomeJoint.Joint1.robax.rax_4)>1 bHomeCheck:=TRUE;
        IF abs(jMoveHomeHomeGroup.Joint1.robax.rax_5-jgHomeJoint.Joint1.robax.rax_5)>1 bHomeCheck:=TRUE;
        IF abs(jMoveHomeHomeGroup.Joint1.robax.rax_6-jgHomeJoint.Joint1.robax.rax_6)>1 bHomeCheck:=TRUE;
        IF abs(jMoveHomeHomeGroup.Joint2.robax.rax_1-jgHomeJoint.Joint2.robax.rax_1)>1 bHomeCheck:=TRUE;
        IF abs(jMoveHomeHomeGroup.Joint2.robax.rax_2-jgHomeJoint.Joint2.robax.rax_2)>1 bHomeCheck:=TRUE;
        IF abs(jMoveHomeHomeGroup.Joint2.robax.rax_3-jgHomeJoint.Joint2.robax.rax_3)>1 bHomeCheck:=TRUE;
        IF abs(jMoveHomeHomeGroup.Joint2.robax.rax_4-jgHomeJoint.Joint2.robax.rax_4)>1 bHomeCheck:=TRUE;
        IF abs(jMoveHomeHomeGroup.Joint2.robax.rax_5-jgHomeJoint.Joint2.robax.rax_5)>1 bHomeCheck:=TRUE;
        IF abs(jMoveHomeHomeGroup.Joint2.robax.rax_6-jgHomeJoint.Joint2.robax.rax_6)>1 bHomeCheck:=TRUE;



        jgEmptyTarget.Joint1:=CJointT(\TaskName:="T_Rob1");
        jgEmptyTarget.Joint2:=CJointT(\TaskName:="T_Rob2");
        jgEmptyTarget.JointG:=CJointT(\TaskName:="T_Gantry");
        IF bHomeCheck=FALSE THEN
            jgEmptyTarget.JointG.extax.eax_c:=0;
            MoveJgJ jgEmptyTarget,vTargetSpeed,fine;
        ENDIF
        IF bHomeCheck=TRUE THEN
            jgEmptyTarget.Joint1.robax.rax_2:=-90;
            jgEmptyTarget.Joint1.robax.rax_3:=55;
            jgEmptyTarget.Joint2.robax.rax_2:=-90;
            jgEmptyTarget.Joint2.robax.rax_3:=55;
            MoveJgJ jgEmptyTarget,vTargetSpeed,fine;

            jgEmptyTarget.Joint1.robax.rax_5:=0;
            jgEmptyTarget.Joint2.robax.rax_5:=0;
            MoveJgJ jgEmptyTarget,vTargetSpeed,fine;

            jgEmptyTarget.Joint1.robax.rax_1:=jgHomeJoint.Joint1.robax.rax_1;
            jgEmptyTarget.Joint2.robax.rax_1:=jgHomeJoint.Joint2.robax.rax_1;
            jgEmptyTarget.JointG.extax.eax_d:=0;
            MoveJgJ jgEmptyTarget,vTargetSpeed,fine;

            jgEmptyTarget.Joint1:=CJointT(\TaskName:="T_Rob1");
            jgEmptyTarget.Joint2:=CJointT(\TaskName:="T_Rob2");
            jgEmptyTarget.JointG:=CJointT(\TaskName:="T_Gantry");
            jgEmptyTarget.Joint1.robax:=jgHomeJoint.Joint1.robax;
            jgEmptyTarget.Joint2.robax:=jgHomeJoint.Joint2.robax;
            MoveJgJ jgEmptyTarget,vTargetSpeed,fine;
        ENDIF
        RETURN ;
    ENDPROC

    PROC rMoveWeld()
        VAR num nTempMmps;
        VAR jointgroup jTempReadyGroup;
        ! Define Weld Data
        wd1:=[Welds1{1}.cpm/6,0,[5,0,Welds1{1}.voltage,Welds1{1}.wfs,0,Welds1{1}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd2:=[Welds1{2}.cpm/6,0,[5,0,Welds1{2}.voltage,Welds1{2}.wfs,0,Welds1{2}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd3:=[Welds1{3}.cpm/6,0,[5,0,Welds1{3}.voltage,Welds1{3}.wfs,0,Welds1{3}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd4:=[Welds1{4}.cpm/6,0,[5,0,Welds1{4}.voltage,Welds1{4}.wfs,0,Welds1{4}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd5:=[Welds1{5}.cpm/6,0,[5,0,Welds1{5}.voltage,Welds1{5}.wfs,0,Welds1{5}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd6:=[Welds1{6}.cpm/6,0,[5,0,Welds1{6}.voltage,Welds1{6}.wfs,0,Welds1{6}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd7:=[Welds1{7}.cpm/6,0,[5,0,Welds1{7}.voltage,Welds1{7}.wfs,0,Welds1{7}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd8:=[Welds1{8}.cpm/6,0,[5,0,Welds1{8}.voltage,Welds1{8}.wfs,0,Welds1{8}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd9:=[Welds1{9}.cpm/6,0,[5,0,Welds1{9}.voltage,Welds1{9}.wfs,0,Welds1{9}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd10:=[Welds1{10}.cpm/6,0,[5,0,Welds1{10}.voltage,Welds1{10}.wfs,0,Welds1{10}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd11:=[Welds1{11}.cpm/6,0,[5,0,Welds1{11}.voltage,Welds1{11}.wfs,0,Welds1{11}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd12:=[Welds1{12}.cpm/6,0,[5,0,Welds1{12}.voltage,Welds1{12}.wfs,0,Welds1{12}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd13:=[Welds1{13}.cpm/6,0,[5,0,Welds1{13}.voltage,Welds1{13}.wfs,0,Welds1{13}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd14:=[Welds1{14}.cpm/6,0,[5,0,Welds1{14}.voltage,Welds1{14}.wfs,0,Welds1{14}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd15:=[Welds1{15}.cpm/6,0,[5,0,Welds1{15}.voltage,Welds1{15}.wfs,0,Welds1{15}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd16:=[Welds1{16}.cpm/6,0,[5,0,Welds1{16}.voltage,Welds1{16}.wfs,0,Welds1{16}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd17:=[Welds1{17}.cpm/6,0,[5,0,Welds1{17}.voltage,Welds1{17}.wfs,0,Welds1{17}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd18:=[Welds1{18}.cpm/6,0,[5,0,Welds1{18}.voltage,Welds1{18}.wfs,0,Welds1{18}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd19:=[Welds1{19}.cpm/6,0,[5,0,Welds1{19}.voltage,Welds1{19}.wfs,0,Welds1{19}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd20:=[Welds1{20}.cpm/6,0,[5,0,Welds1{20}.voltage,Welds1{20}.wfs,0,Welds1{20}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd21:=[Welds1{21}.cpm/6,0,[5,0,Welds1{21}.voltage,Welds1{21}.wfs,0,Welds1{21}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd22:=[Welds1{22}.cpm/6,0,[5,0,Welds1{22}.voltage,Welds1{22}.wfs,0,Welds1{22}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd23:=[Welds1{23}.cpm/6,0,[5,0,Welds1{23}.voltage,Welds1{23}.wfs,0,Welds1{23}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd24:=[Welds1{24}.cpm/6,0,[5,0,Welds1{24}.voltage,Welds1{24}.wfs,0,Welds1{24}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd25:=[Welds1{25}.cpm/6,0,[5,0,Welds1{25}.voltage,Welds1{25}.wfs,0,Welds1{25}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd26:=[Welds1{26}.cpm/6,0,[5,0,Welds1{26}.voltage,Welds1{26}.wfs,0,Welds1{26}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd27:=[Welds1{27}.cpm/6,0,[5,0,Welds1{27}.voltage,Welds1{27}.wfs,0,Welds1{27}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd28:=[Welds1{28}.cpm/6,0,[5,0,Welds1{28}.voltage,Welds1{28}.wfs,0,Welds1{28}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd29:=[Welds1{29}.cpm/6,0,[5,0,Welds1{29}.voltage,Welds1{29}.wfs,0,Welds1{29}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd30:=[Welds1{30}.cpm/6,0,[5,0,Welds1{30}.voltage,Welds1{30}.wfs,0,Welds1{30}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd31:=[Welds1{31}.cpm/6,0,[5,0,Welds1{31}.voltage,Welds1{31}.wfs,0,Welds1{31}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd32:=[Welds1{32}.cpm/6,0,[5,0,Welds1{32}.voltage,Welds1{32}.wfs,0,Welds1{32}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd33:=[Welds1{33}.cpm/6,0,[5,0,Welds1{33}.voltage,Welds1{33}.wfs,0,Welds1{33}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd34:=[Welds1{34}.cpm/6,0,[5,0,Welds1{34}.voltage,Welds1{34}.wfs,0,Welds1{34}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd35:=[Welds1{35}.cpm/6,0,[5,0,Welds1{35}.voltage,Welds1{35}.wfs,0,Welds1{35}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd36:=[Welds1{36}.cpm/6,0,[5,0,Welds1{36}.voltage,Welds1{36}.wfs,0,Welds1{36}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd37:=[Welds1{37}.cpm/6,0,[5,0,Welds1{37}.voltage,Welds1{37}.wfs,0,Welds1{37}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd38:=[Welds1{38}.cpm/6,0,[5,0,Welds1{38}.voltage,Welds1{38}.wfs,0,Welds1{38}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd39:=[Welds1{39}.cpm/6,0,[5,0,Welds1{39}.voltage,Welds1{39}.wfs,0,Welds1{39}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd40:=[Welds1{nMotionStepCount{1}}.cpm/6,0,[5,0,Welds1{nMotionStepCount{1}}.voltage,Welds1{nMotionStepCount{1}}.wfs,0,Welds1{nMotionStepCount{1}}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];

        ! Define Wave Data
        weave1:=[Welds1{1}.WeaveShape,Welds1{1}.WeaveType,Welds1{1}.WeaveLength,Welds1{1}.WeaveWidth,0,Welds1{1}.WeaveDwellLeft,0,Welds1{1}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave2:=[Welds1{2}.WeaveShape,Welds1{2}.WeaveType,Welds1{2}.WeaveLength,Welds1{2}.WeaveWidth,0,Welds1{2}.WeaveDwellLeft,0,Welds1{2}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave3:=[Welds1{3}.WeaveShape,Welds1{3}.WeaveType,Welds1{3}.WeaveLength,Welds1{3}.WeaveWidth,0,Welds1{3}.WeaveDwellLeft,0,Welds1{3}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave4:=[Welds1{4}.WeaveShape,Welds1{4}.WeaveType,Welds1{4}.WeaveLength,Welds1{4}.WeaveWidth,0,Welds1{4}.WeaveDwellLeft,0,Welds1{4}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave5:=[Welds1{5}.WeaveShape,Welds1{5}.WeaveType,Welds1{5}.WeaveLength,Welds1{5}.WeaveWidth,0,Welds1{5}.WeaveDwellLeft,0,Welds1{5}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave6:=[Welds1{6}.WeaveShape,Welds1{6}.WeaveType,Welds1{6}.WeaveLength,Welds1{6}.WeaveWidth,0,Welds1{6}.WeaveDwellLeft,0,Welds1{6}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave7:=[Welds1{7}.WeaveShape,Welds1{7}.WeaveType,Welds1{7}.WeaveLength,Welds1{7}.WeaveWidth,0,Welds1{7}.WeaveDwellLeft,0,Welds1{7}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave8:=[Welds1{8}.WeaveShape,Welds1{8}.WeaveType,Welds1{8}.WeaveLength,Welds1{8}.WeaveWidth,0,Welds1{8}.WeaveDwellLeft,0,Welds1{8}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave9:=[Welds1{9}.WeaveShape,Welds1{9}.WeaveType,Welds1{9}.WeaveLength,Welds1{9}.WeaveWidth,0,Welds1{9}.WeaveDwellLeft,0,Welds1{9}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave10:=[Welds1{10}.WeaveShape,Welds1{10}.WeaveType,Welds1{10}.WeaveLength,Welds1{10}.WeaveWidth,0,Welds1{10}.WeaveDwellLeft,0,Welds1{10}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave11:=[Welds1{11}.WeaveShape,Welds1{11}.WeaveType,Welds1{11}.WeaveLength,Welds1{11}.WeaveWidth,0,Welds1{11}.WeaveDwellLeft,0,Welds1{11}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave12:=[Welds1{12}.WeaveShape,Welds1{12}.WeaveType,Welds1{12}.WeaveLength,Welds1{12}.WeaveWidth,0,Welds1{12}.WeaveDwellLeft,0,Welds1{12}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave13:=[Welds1{13}.WeaveShape,Welds1{13}.WeaveType,Welds1{13}.WeaveLength,Welds1{13}.WeaveWidth,0,Welds1{13}.WeaveDwellLeft,0,Welds1{13}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave14:=[Welds1{14}.WeaveShape,Welds1{14}.WeaveType,Welds1{14}.WeaveLength,Welds1{14}.WeaveWidth,0,Welds1{14}.WeaveDwellLeft,0,Welds1{14}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave15:=[Welds1{15}.WeaveShape,Welds1{15}.WeaveType,Welds1{15}.WeaveLength,Welds1{15}.WeaveWidth,0,Welds1{15}.WeaveDwellLeft,0,Welds1{15}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave16:=[Welds1{16}.WeaveShape,Welds1{16}.WeaveType,Welds1{16}.WeaveLength,Welds1{16}.WeaveWidth,0,Welds1{16}.WeaveDwellLeft,0,Welds1{16}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave17:=[Welds1{17}.WeaveShape,Welds1{17}.WeaveType,Welds1{17}.WeaveLength,Welds1{17}.WeaveWidth,0,Welds1{17}.WeaveDwellLeft,0,Welds1{17}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave18:=[Welds1{18}.WeaveShape,Welds1{18}.WeaveType,Welds1{18}.WeaveLength,Welds1{18}.WeaveWidth,0,Welds1{18}.WeaveDwellLeft,0,Welds1{18}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave19:=[Welds1{19}.WeaveShape,Welds1{19}.WeaveType,Welds1{19}.WeaveLength,Welds1{19}.WeaveWidth,0,Welds1{19}.WeaveDwellLeft,0,Welds1{19}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave20:=[Welds1{20}.WeaveShape,Welds1{20}.WeaveType,Welds1{20}.WeaveLength,Welds1{20}.WeaveWidth,0,Welds1{20}.WeaveDwellLeft,0,Welds1{20}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave21:=[Welds1{21}.WeaveShape,Welds1{21}.WeaveType,Welds1{21}.WeaveLength,Welds1{21}.WeaveWidth,0,Welds1{21}.WeaveDwellLeft,0,Welds1{21}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave22:=[Welds1{22}.WeaveShape,Welds1{22}.WeaveType,Welds1{22}.WeaveLength,Welds1{22}.WeaveWidth,0,Welds1{22}.WeaveDwellLeft,0,Welds1{22}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave23:=[Welds1{23}.WeaveShape,Welds1{23}.WeaveType,Welds1{23}.WeaveLength,Welds1{23}.WeaveWidth,0,Welds1{23}.WeaveDwellLeft,0,Welds1{23}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave24:=[Welds1{24}.WeaveShape,Welds1{24}.WeaveType,Welds1{24}.WeaveLength,Welds1{24}.WeaveWidth,0,Welds1{24}.WeaveDwellLeft,0,Welds1{24}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave25:=[Welds1{25}.WeaveShape,Welds1{25}.WeaveType,Welds1{25}.WeaveLength,Welds1{25}.WeaveWidth,0,Welds1{25}.WeaveDwellLeft,0,Welds1{25}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave26:=[Welds1{26}.WeaveShape,Welds1{26}.WeaveType,Welds1{26}.WeaveLength,Welds1{26}.WeaveWidth,0,Welds1{26}.WeaveDwellLeft,0,Welds1{26}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave27:=[Welds1{27}.WeaveShape,Welds1{27}.WeaveType,Welds1{27}.WeaveLength,Welds1{27}.WeaveWidth,0,Welds1{27}.WeaveDwellLeft,0,Welds1{27}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave28:=[Welds1{28}.WeaveShape,Welds1{28}.WeaveType,Welds1{28}.WeaveLength,Welds1{28}.WeaveWidth,0,Welds1{28}.WeaveDwellLeft,0,Welds1{28}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave29:=[Welds1{29}.WeaveShape,Welds1{29}.WeaveType,Welds1{29}.WeaveLength,Welds1{29}.WeaveWidth,0,Welds1{29}.WeaveDwellLeft,0,Welds1{29}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave30:=[Welds1{30}.WeaveShape,Welds1{30}.WeaveType,Welds1{30}.WeaveLength,Welds1{30}.WeaveWidth,0,Welds1{30}.WeaveDwellLeft,0,Welds1{30}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave31:=[Welds1{31}.WeaveShape,Welds1{31}.WeaveType,Welds1{31}.WeaveLength,Welds1{31}.WeaveWidth,0,Welds1{31}.WeaveDwellLeft,0,Welds1{31}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave32:=[Welds1{32}.WeaveShape,Welds1{32}.WeaveType,Welds1{32}.WeaveLength,Welds1{32}.WeaveWidth,0,Welds1{32}.WeaveDwellLeft,0,Welds1{32}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave33:=[Welds1{33}.WeaveShape,Welds1{33}.WeaveType,Welds1{33}.WeaveLength,Welds1{33}.WeaveWidth,0,Welds1{33}.WeaveDwellLeft,0,Welds1{33}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave34:=[Welds1{34}.WeaveShape,Welds1{34}.WeaveType,Welds1{34}.WeaveLength,Welds1{34}.WeaveWidth,0,Welds1{34}.WeaveDwellLeft,0,Welds1{34}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave35:=[Welds1{35}.WeaveShape,Welds1{35}.WeaveType,Welds1{35}.WeaveLength,Welds1{35}.WeaveWidth,0,Welds1{35}.WeaveDwellLeft,0,Welds1{35}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave36:=[Welds1{36}.WeaveShape,Welds1{36}.WeaveType,Welds1{36}.WeaveLength,Welds1{36}.WeaveWidth,0,Welds1{36}.WeaveDwellLeft,0,Welds1{36}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave37:=[Welds1{37}.WeaveShape,Welds1{37}.WeaveType,Welds1{37}.WeaveLength,Welds1{37}.WeaveWidth,0,Welds1{37}.WeaveDwellLeft,0,Welds1{37}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave38:=[Welds1{38}.WeaveShape,Welds1{38}.WeaveType,Welds1{38}.WeaveLength,Welds1{38}.WeaveWidth,0,Welds1{38}.WeaveDwellLeft,0,Welds1{38}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave39:=[Welds1{39}.WeaveShape,Welds1{39}.WeaveType,Welds1{39}.WeaveLength,Welds1{39}.WeaveWidth,0,Welds1{39}.WeaveDwellLeft,0,Welds1{39}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave40:=[Welds1{nMotionStepCount{1}}.WeaveShape,Welds1{nMotionStepCount{1}}.WeaveType,Welds1{nMotionStepCount{1}}.WeaveLength,Welds1{nMotionStepCount{1}}.WeaveWidth,0,Welds1{nMotionStepCount{1}}.WeaveDwellLeft,0,Welds1{nMotionStepCount{1}}.WeaveDwellRight,0,0,0,0,0,0,0];

        track1:=[0,FALSE,50,[Welds1{1}.TrackType,Welds1{1}.TrackGainY,Welds1{1}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track2:=[0,FALSE,50,[Welds1{2}.TrackType,Welds1{2}.TrackGainY,Welds1{2}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track3:=[0,FALSE,50,[Welds1{3}.TrackType,Welds1{3}.TrackGainY,Welds1{3}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track4:=[0,FALSE,50,[Welds1{4}.TrackType,Welds1{4}.TrackGainY,Welds1{4}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track5:=[0,FALSE,50,[Welds1{5}.TrackType,Welds1{5}.TrackGainY,Welds1{5}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track6:=[0,FALSE,50,[Welds1{6}.TrackType,Welds1{6}.TrackGainY,Welds1{6}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track7:=[0,FALSE,50,[Welds1{7}.TrackType,Welds1{7}.TrackGainY,Welds1{7}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track8:=[0,FALSE,50,[Welds1{8}.TrackType,Welds1{8}.TrackGainY,Welds1{8}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track9:=[0,FALSE,50,[Welds1{9}.TrackType,Welds1{9}.TrackGainY,Welds1{9}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track10:=[0,FALSE,50,[Welds1{10}.TrackType,Welds1{10}.TrackGainY,Welds1{10}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track11:=[0,FALSE,50,[Welds1{11}.TrackType,Welds1{11}.TrackGainY,Welds1{11}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track12:=[0,FALSE,50,[Welds1{12}.TrackType,Welds1{12}.TrackGainY,Welds1{12}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track13:=[0,FALSE,50,[Welds1{13}.TrackType,Welds1{13}.TrackGainY,Welds1{13}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track14:=[0,FALSE,50,[Welds1{14}.TrackType,Welds1{14}.TrackGainY,Welds1{14}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track15:=[0,FALSE,50,[Welds1{15}.TrackType,Welds1{15}.TrackGainY,Welds1{15}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track16:=[0,FALSE,50,[Welds1{16}.TrackType,Welds1{16}.TrackGainY,Welds1{16}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track17:=[0,FALSE,50,[Welds1{17}.TrackType,Welds1{17}.TrackGainY,Welds1{17}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track18:=[0,FALSE,50,[Welds1{18}.TrackType,Welds1{18}.TrackGainY,Welds1{18}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track19:=[0,FALSE,50,[Welds1{19}.TrackType,Welds1{19}.TrackGainY,Welds1{19}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track20:=[0,FALSE,50,[Welds1{20}.TrackType,Welds1{20}.TrackGainY,Welds1{20}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track21:=[0,FALSE,50,[Welds1{21}.TrackType,Welds1{21}.TrackGainY,Welds1{21}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track22:=[0,FALSE,50,[Welds1{22}.TrackType,Welds1{22}.TrackGainY,Welds1{22}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track23:=[0,FALSE,50,[Welds1{23}.TrackType,Welds1{23}.TrackGainY,Welds1{23}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track24:=[0,FALSE,50,[Welds1{24}.TrackType,Welds1{24}.TrackGainY,Welds1{24}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track25:=[0,FALSE,50,[Welds1{25}.TrackType,Welds1{25}.TrackGainY,Welds1{25}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track26:=[0,FALSE,50,[Welds1{26}.TrackType,Welds1{26}.TrackGainY,Welds1{26}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track27:=[0,FALSE,50,[Welds1{27}.TrackType,Welds1{27}.TrackGainY,Welds1{27}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track28:=[0,FALSE,50,[Welds1{28}.TrackType,Welds1{28}.TrackGainY,Welds1{28}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track29:=[0,FALSE,50,[Welds1{29}.TrackType,Welds1{29}.TrackGainY,Welds1{29}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track30:=[0,FALSE,50,[Welds1{30}.TrackType,Welds1{30}.TrackGainY,Welds1{30}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track31:=[0,FALSE,50,[Welds1{31}.TrackType,Welds1{31}.TrackGainY,Welds1{31}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track32:=[0,FALSE,50,[Welds1{32}.TrackType,Welds1{32}.TrackGainY,Welds1{32}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track33:=[0,FALSE,50,[Welds1{33}.TrackType,Welds1{33}.TrackGainY,Welds1{33}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track34:=[0,FALSE,50,[Welds1{34}.TrackType,Welds1{34}.TrackGainY,Welds1{34}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track35:=[0,FALSE,50,[Welds1{35}.TrackType,Welds1{35}.TrackGainY,Welds1{35}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track36:=[0,FALSE,50,[Welds1{36}.TrackType,Welds1{36}.TrackGainY,Welds1{36}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track37:=[0,FALSE,50,[Welds1{37}.TrackType,Welds1{37}.TrackGainY,Welds1{37}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track38:=[0,FALSE,50,[Welds1{38}.TrackType,Welds1{38}.TrackGainY,Welds1{38}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track39:=[0,FALSE,50,[Welds1{39}.TrackType,Welds1{39}.TrackGainY,Welds1{39}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track40:=[0,FALSE,50,[Welds1{nMotionStepCount{1}}.TrackType,Welds1{nMotionStepCount{1}}.TrackGainY,Welds1{nMotionStepCount{1}}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];

        pWeldPosR1{40}:=pWeldPosR1{nMotionStepCount{1}};

        stCommand:="Weld";
        WaitUntil stReact=["WeldOk","WeldOk","WeldOk"]OR stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
        IF stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"]rMoveHome_Head;

        stCommand:="";
        WaitUntil stReact=["Ready","Ready","Ready"];

        RETURN ;
    ERROR
        IF 0<ERRNO THEN
            rArcErrorHandling;
        ENDIF
    ENDPROC

    PROC rArcErrorHandling()
        !        VAR robtarget pTemp;
        !        VAR jointtarget jTemp;
        !        VAR num ntemp;
        !        pArcErrorPos:=[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,9E+09,9E+09]];
        !        StopMove;
        !        ClearPath;
        !        StartMove;
        !        pTemp:=CRobT(\TaskName:="T_Gantry"\tool:=tWeld\WObj:=wobjWeldLine);
        !        pArcErrorPos:=CRobT(\tool:=tWeld\WObj:=WobjFloor);
        !        MoveL RelTool(pTemp,0,0,-10),v200,z10,tWeld\WObj:=wobjWeldLine;
        !        rMoveToRobotHome;
        !        jTemp:=CJointT();
        !        ntemp:=2200-(Max(Max(nMaxPartHeightNearArray{1},nMaxPartHeightNearArray{2}),nMaxPartHeightNearArray{3})+100);
        !        ntemp:=Limit(0,1500,ntemp);
        !        jTemp.extax.eax_d:=ntemp;
        !        MoveAbsJ jTemp,vTargetSpeed,z10,tWeld;
        !        bArcError:=TRUE;
        !        WaitUntil pi28_CmdRetry=1 OR pi29_NextCmd=1;
        !        bArcError:=FALSE;
        !        Set po31_ErrorReSetComp;
        !        IF pi28_CmdRetry=1 THEN
        !            bRetry:=TRUE;
        !        ELSE
        !            bRetry:=FALSE;
        !            Reset po14_Motion_Working;
        !            Set po15_Motion_Finish;
        !        ENDIF
        !        WaitUntil pi28_CmdRetry=0 AND pi29_NextCmd=0;
        !        Reset po31_ErrorReSetComp;
        !        ExitCycle;
    ENDPROC

    PROC rNozzleClean()
        VAR jointtarget jTemp;
        VAR jointtarget jTempC;
        VAR robtarget pTemp;
        VAR jointtarget j{10};
        !       Calling a Routine To Send The Robot Home
        !        rRbtCheckAtHome;
        !       Save Current Location To jTemp
        jTemp:=CJointT();
        !       Save Current Location To jTempC
        jTempC:=CJointT();
        !       Load Teaching Location
        j{1}:=jNozzleClean10;
        j{2}:=jNozzleClean20;
        j{3}:=jNozzleClean30;
        j{4}:=jNozzleClean40;
        j{5}:=jNozzleClean;
        j{6}:=jNozzleClean50;
        j{7}:=jNozzleClean60;
        j{8}:=jNozzleClean70;
        j{9}:=jNozzleClean80;
        !       Save Gentry A and B To Current Location
        FOR i FROM 1 TO 9 DO
            j{i}.extax.eax_a:=jTemp.extax.eax_a;
            j{i}.extax.eax_b:=jTemp.extax.eax_b;
        ENDFOR
        !       Set The Current Robot Axis 1 Value Equal To The j{1} Value
        jTempC.extax.eax_c:=j{1}.extax.eax_c;
        !       Execute The Calculated Postion
        MoveAbsJ jTempC,v300,z50,tWeld;
        FOR i FROM 1 TO 9 DO
            MoveAbsJ j{i},v300,z50,tWeld;
            IF i=4 THEN
                WaitTime 2;
            ENDIF
        ENDFOR
        !       Save Current Location To jTemp
        jTemp:=CJointT();
        !       Make All Axes Except The Outer Axis The Same as The Home Postion
        jTemp.robax:=jHomeJoint.robax;
        !       Run jTemp
        MoveAbsJ jTemp,v300,z50,tWeld;
        RETURN ;
        !       Below are The Programs I Use For Teaching

        !       Run The Saved Teaching Progerm
        MoveAbsJ jNozzleClean10,v1000,z50,tWeld;
        MoveAbsJ jNozzleClean20,v1000,z50,tWeld;
        MoveAbsJ jNozzleClean30,v1000,z50,tWeld;
        MoveAbsJ jNozzleClean40,v1000,z50,tWeld;
        MoveAbsJ jNozzleClean,v1000,z50,tWeld;
        MoveAbsJ jNozzleClean50,v1000,z50,tWeld;
        MoveAbsJ jNozzleClean60,v1000,z50,tWeld;
        MoveAbsJ jNozzleClean70,v1000,z50,tWeld;
        MoveAbsJ jNozzleClean80,v1000,z50,tWeld;
        Stop;
    ENDPROC

    PROC rTpRoutine()
        VAR num n;
        VAR num nn;
        VAR num nGantryX;
        VAR num nGantryY;
        VAR num nGantryZ;
        VAR num nRobotAxis1;
        VAR num nRobotAxis2;
        VAR num nRobotAxis3;
        VAR num nRobotAxis4;
        VAR num nRobotAxis5;
        VAR num nRobotAxis6;
        VAR jointtarget rEmptyJoint;



        gStart:
        TPErase;
        TPReadFK n,"Did you want TP Manual Mode or Auto Mode?","Manual",stEmpty,stEmpty,stEmpty,"Auto";

        IF n=5 GOTO gAuto;

        TPReadFK n,"What Position?","Manual Pos",stEmpty,"Repair Pos","Home Pos","Menu";

        TEST n

        CASE 1:
            gMoving:
            TPReadFK n,"What do you want?","Gantry Move",stEmpty,stEmpty,"Robot Move","Menu";

            IF n=1 THEN
                TPReadNum nGantryX,"Gantry X";
                TPReadNum nGantryY,"Gantry Y";
                TPReadNum nGantryZ,"Gantry Z";

                TPErase;
                TPWrite "X"+ValToStr(nGantryX)+"Y"+ValToStr(nGantryY)+"Z"+ValToStr(nGantryZ);
                TPReadFK n,"Right?","Yes",stEmpty,stEmpty,"No","Menu";

                IF n=1 THEN
                    rEmptyJoint:=CJointT();
                    rEmptyJoint.extax.eax_a:=nHomeGantryX+nGantryX;
                    rEmptyJoint.extax.eax_b:=nHomeGantryX+nGantryX;
                    rEmptyJoint.extax.eax_c:=nHomeGantryY-nGantryY;
                    rEmptyJoint.extax.eax_d:=nHomeGantryZ-nGantryZ;

                    TPErase;
                    TPWrite "!!!!!!!!!!!!!!!!!!!!!!!!!";
                    TPWrite "BE Carful! Gantry Moving!";
                    TPWrite "!!!!!!!!!!!!!!!!!!!!!!!!!";
                    WaitTime 0.3;
                    MoveAbsJ rEmptyJoint,v300,fine,tool0;

                    TPErase;
                    TPWrite "!!!!!!!!!!!!!!!!!!!!!!!!!";
                    TPWrite "!!!! Gantry Arrived !!!!!";
                    TPWrite "!!!!!!!!!!!!!!!!!!!!!!!!!";
                    WaitTime 0.3;

                    GOTO gMoving;

                ELSEIF n=4 THEN
                    TPErase;
                    TPWrite "Go To Select";
                    WaitTime 0.3;
                    GOTO gMoving;
                ELSE
                    TPErase;
                    TPWrite "Go To Menu";
                    WaitTime 0.3;
                    GOTO gStart;
                ENDIF

            ELSEIF n=4 THEN
                TPErase;
                TPReadNum nRobotAxis1,"Robot Axis 1";
                TPReadNum nRobotAxis2,"Robot Axis 2";
                TPReadNum nRobotAxis3,"Robot Axis 3";
                TPReadNum nRobotAxis4,"Robot Axis 4";
                TPReadNum nRobotAxis5,"Robot Axis 5";
                TPReadNum nRobotAxis6,"Robot Axis 6";

                TPErase;
                TPWrite "Axis 1 : "+ValToStr(nRobotAxis1)+"Axis 2 : "+ValToStr(nRobotAxis2)+"Axis 3 : "+ValToStr(nRobotAxis3);
                TPWrite "Axis 4 : "+ValToStr(nRobotAxis4)+"Axis 5 : "+ValToStr(nRobotAxis5)+"Axis 6 : "+ValToStr(nRobotAxis6);
                TPReadFK n,"Right?","Yes",stEmpty,stEmpty,"No","Menu";

                IF n=1 THEN
                    rEmptyJoint:=CJointT();
                    rEmptyJoint.robax.rax_1:=nRobotAxis1;
                    rEmptyJoint.robax.rax_2:=nRobotAxis2;
                    rEmptyJoint.robax.rax_3:=nRobotAxis3;
                    rEmptyJoint.robax.rax_4:=nRobotAxis4;
                    rEmptyJoint.robax.rax_5:=nRobotAxis5;
                    rEmptyJoint.robax.rax_6:=nRobotAxis6;

                    TPErase;
                    TPWrite "!!!!!!!!!!!!!!!!!!!!!!!!!";
                    TPWrite "BE Carful! Robot  Moving!";
                    TPWrite "!!!!!!!!!!!!!!!!!!!!!!!!!";
                    WaitTime 0.3;
                    MoveAbsJ rEmptyJoint,v300,fine,tool0;

                    TPErase;
                    TPWrite "!!!!!!!!!!!!!!!!!!!!!!!!!";
                    TPWrite "!!!! Robot  Arrived !!!!!";
                    TPWrite "!!!!!!!!!!!!!!!!!!!!!!!!!";
                    WaitTime 0.3;

                    GOTO gMoving;

                ELSEIF n=4 THEN
                    TPErase;
                    TPWrite "Go To Select";
                    WaitTime 0.3;
                    GOTO gMoving;
                ELSE
                    TPErase;
                    TPWrite "Go To Menu";
                    WaitTime 0.3;
                    GOTO gStart;
                ENDIF

            ELSE
                TPErase;
                TPWrite "Go To Menu";
                WaitTime 0.3;
                GOTO gStart;
            ENDIF


        CASE 3:

            gRepairStart:
            TPErase;
            TPReadFK n,"What do you want to do?","Change Repair Pos",stEmpty,stEmpty,"Move Repair","Menu";


            IF n=1 THEN
                TPReadFK n,"Did you Change Here?","Yes",stEmpty,stEmpty,"NO","Menu";
                IF n=5 GOTO gStart;
                WaitRob\ZeroSpeed;
                ClearPath;
                rEmptyJoint:=CJointT();
                TPErase;
                TPWrite "Gantry Check";
                TPWrite "Gantry X : "+ValToStr(rEmptyJoint.extax.eax_a);
                TPWrite "Gantry Y : "+ValToStr(nHomeGantryY-rEmptyJoint.extax.eax_c);
                TPWrite "Gantry Z : "+ValToStr(nHomeGantryZ-rEmptyJoint.extax.eax_d);
                WaitTime 0.3;

                TPReadFK n,"Right?","Yes",stEmpty,stEmpty,stEmpty,"No";
                IF n=5 GOTO gRepairStart;

                TPErase;
                TPWrite "Robot Axis 1 : "+ValToStr(rEmptyJoint.robax.rax_1)+"Robot Axis 2 : "+ValToStr(rEmptyJoint.robax.rax_2);
                TPWrite "Robot Axis 3 : "+ValToStr(rEmptyJoint.robax.rax_3)+"Robot Axis 4 : "+ValToStr(rEmptyJoint.robax.rax_4);
                TPWrite "Robot Axis 5 : "+ValToStr(rEmptyJoint.robax.rax_5)+"Robot Axis 6 : "+ValToStr(rEmptyJoint.robax.rax_6);

                TPReadFK n,"Right?","Yes",stEmpty,stEmpty,stEmpty,"No";

                IF n=5 GOTO gRepairStart;
                IF n=1 THEN
                    TPReadFK n,"Did you want Save Repair Position?","Yes",stEmpty,stEmpty,stEmpty,"No";
                    IF n=5 GOTO gRepairStart;
                    TPErase;
                    TPWrite "Save Repair Position";
                    jRepairJoint:=rEmptyJoint;
                    WaitTime 0.3;
                    GOTO gRepairStart;
                ENDIF

            ELSEIF n=4 THEN
                MoveAbsJ jRepairJoint,v300,fine,tool0;

            ELSE
                TPErase;
                TPWrite "Go To Manu";
                WaitTime 0.3;
                GOTO gStart;

            ENDIF

        CASE 4:

            gHomeStart:
            TPReadFK n,"What do you want?","Change Home Pos",stEmpty,stEmpty,"Move Home","Menu";

            IF n=1 THEN

                TPReadFK n,"Did you Change Here?","Yes",stEmpty,stEmpty,"NO","Menu";
                IF n=5 GOTO gStart;
                WaitRob\ZeroSpeed;
                ClearPath;
                rEmptyJoint:=CJointT();
                TPErase;
                TPWrite "Gantry Check";
                TPWrite "Gantry X : "+ValToStr(rEmptyJoint.extax.eax_a);
                TPWrite "Gantry Y : "+ValToStr(nHomeGantryY-rEmptyJoint.extax.eax_c);
                TPWrite "Gantry Z : "+ValToStr(nHomeGantryZ-rEmptyJoint.extax.eax_d);
                WaitTime 0.3;

                TPReadFK n,"Right?","Yes",stEmpty,stEmpty,stEmpty,"No";
                IF n=5 GOTO gHomeStart;

                TPErase;
                TPWrite "Robot Axis 1 : "+ValToStr(rEmptyJoint.robax.rax_1)+"Robot Axis 2 : "+ValToStr(rEmptyJoint.robax.rax_2);
                TPWrite "Robot Axis 3 : "+ValToStr(rEmptyJoint.robax.rax_3)+"Robot Axis 4 : "+ValToStr(rEmptyJoint.robax.rax_4);
                TPWrite "Robot Axis 5 : "+ValToStr(rEmptyJoint.robax.rax_5)+"Robot Axis 6 : "+ValToStr(rEmptyJoint.robax.rax_6);

                TPReadFK n,"Right?","Yes",stEmpty,stEmpty,stEmpty,"No";
                IF n=5 GOTO gHomeStart;
                IF n=1 THEN
                    TPReadFK n,"Did you want Save Home Position?","Yes",stEmpty,stEmpty,stEmpty,"No";
                    IF n=5 GOTO gHomeStart;
                    TPErase;
                    TPWrite "Save Home Position";
                    jHomeJoint:=rEmptyJoint;
                    WaitTime 0.3;
                ENDIF
                GOTO gHomeStart;

            ELSEIF n=4 THEN
                TPWrite "Go Home Position";
                rMoveHome;
                !MoveAbsJ jHomeJoint, v300, fine, tool0;
                TPWrite "Arrived Homoe Position Go to Menu";
            ELSE

                TPWrite "Go To Menu";
                WaitTime 0.3;
                GOTO gStart;

            ENDIF

        CASE 5:
            TPWrite "Go To Menu";
            WaitTime 0.3;
            GOTO gStart;
        ENDTEST

        gAuto:

    ENDPROC

    PROC rWirecut(num nRbt_No)
        bWirecut:=[FALSE,FALSE,FALSE];
        IF (sdo_Rob_1_JgHome=1 AND sdo_Rob_2_JgHome=1) OR (sdo_Rob_1_MoveHome=1 AND sdo_Rob_2_MoveHome=1) OR (sdo_Rob_1_WirecutHome=1 AND sdo_Rob_2_WirecutHome=1) THEN
        ELSE
            rMeasurementHomeCheck;
        ENDIF
        IF sdo_Rob_1_JgHome=1 AND sdo_Rob_2_JgHome=1 THEN
            bWirecut:=[TRUE,FALSE,FALSE];
            IF nRbt_No=0 OR nRbt_No=1 THEN
                Wirecut\R1;
                WaitUntil stReact{1}="WireCutOk";
                stCommand:="";
                WaitUntil stReact{1}="Ready";
            ENDIF
            IF nRbt_No=0 OR nRbt_No=2 THEN
                WireCut\R2;
                WaitUntil stReact{2}="WireCutOk";
                stCommand:="";
                WaitUntil stReact{2}="Ready";
            ENDIF
            IF nRbt_No=3 THEN
                bWireCutSync:=TRUE;
                stCommand:="WireCutR1_R2";
                WaitUntil stReact{1}="WireCutOk" AND stReact{2}="WireCutOk";
                stCommand:="";
                WaitUntil stReact{1}="Ready" AND stReact{2}="Ready";
                bWireCutSync:=FALSE;
            ENDIF
        ENDIF
        IF sdo_Rob_1_MoveHome=1 AND sdo_Rob_2_MoveHome=1 THEN
            bWirecut:=[FALSE,TRUE,FALSE];
            IF nRbt_No=0 OR nRbt_No=1 THEN
                WirecutMove\R1;
                WaitUntil stReact{1}="WireCutOk";
                stCommand:="";
                WaitUntil stReact{1}="Ready";
            ENDIF
            IF nRbt_No=0 OR nRbt_No=2 THEN
                WireCutMove\R2;
                WaitUntil stReact{2}="WireCutOk";
                stCommand:="";
                WaitUntil stReact{2}="Ready";
            ENDIF
            IF nRbt_No=3 THEN
                bWireCutSync:=TRUE;
                stCommand:="WireCutMoveR1_R2";
                WaitUntil stReact{1}="WireCutOk" AND stReact{2}="WireCutOk";
                stCommand:="";
                WaitUntil stReact{1}="Ready" AND stReact{2}="Ready";
                bWireCutSync:=FALSE;
            ENDIF
        ENDIF
        IF sdo_Rob_1_WirecutHome=1 AND sdo_Rob_2_WirecutHome=1 THEN
            bWirecut:=[FALSE,FALSE,TRUE];
            IF nRbt_No=0 OR nRbt_No=1 THEN
                WirecutShot\R1;
                WaitUntil stReact{1}="WireCutOk";
                stCommand:="";
                WaitUntil stReact{1}="Ready";
            ENDIF
            IF nRbt_No=0 OR nRbt_No=2 THEN
                WireCutShot\R2;
                WaitUntil stReact{2}="WireCutOk";
                stCommand:="";
                WaitUntil stReact{2}="Ready";
            ENDIF
            IF nRbt_No=3 THEN
                bWireCutSync:=TRUE;
                stCommand:="WireCutShotR1_R2";
                WaitUntil stReact{1}="WireCutOk" AND stReact{2}="WireCutOk";
                stCommand:="";
                WaitUntil stReact{1}="Ready" AND stReact{2}="Ready";
                bWireCutSync:=FALSE;
            ENDIF
        ENDIF
        WaitUntil stReact=["Ready","Ready","Ready"];

    ENDPROC

    PROC rWirecutShot(num nRbt_No)

        IF nRbt_No=0 OR nRbt_No=1 THEN
            WirecutShot\R1;
            WaitUntil stReact{1}="WireCutOk";
            stCommand:="";
            WaitUntil stReact{1}="Ready";
        ENDIF
        IF nRbt_No=0 OR nRbt_No=2 THEN
            WireCutShot\R2;
            WaitUntil stReact{2}="WireCutOk";
            stCommand:="";
            WaitUntil stReact{2}="Ready";
        ENDIF
        IF nRbt_No=3 THEN
            bWireCutSync:=TRUE;
            stCommand:="WireCutShotR1_R2";
            WaitUntil stReact{1}="WireCutOk" AND stReact{2}="WireCutOk";
            stCommand:="";
            WaitUntil stReact{1}="Ready" AND stReact{2}="Ready";
            bWireCutSync:=FALSE;
        ENDIF

        WaitUntil stReact=["Ready","Ready","Ready"];

    ENDPROC

    PROC rWirecutMove(num nRbt_No)

        IF nRbt_No=0 OR nRbt_No=1 THEN
            WirecutMove\R1;
            WaitUntil stReact{1}="WireCutOk";
            stCommand:="";
            WaitUntil stReact{1}="Ready";
        ENDIF
        IF nRbt_No=0 OR nRbt_No=2 THEN
            WireCutMove\R2;
            WaitUntil stReact{2}="WireCutOk";
            stCommand:="";
            WaitUntil stReact{2}="Ready";
        ENDIF
        IF nRbt_No=3 THEN
            bWireCutSync:=TRUE;
            stCommand:="WireCutMoveR1_R2";
            WaitUntil stReact{1}="WireCutOk" AND stReact{2}="WireCutOk";
            stCommand:="";
            WaitUntil stReact{1}="Ready" AND stReact{2}="Ready";
            bWireCutSync:=FALSE;
        ENDIF

        WaitUntil stReact=["Ready","Ready","Ready"];

    ENDPROC

    PROC rEdgeDataCheck()
        IF edgeStart{1}.Breadth<=0 edgeStart{1}.Breadth:=50;
        IF edgeStart{1}.Height<=0 edgeStart{1}.Height:=50;
        IF edgeStart{2}.Breadth<=0 edgeStart{2}.Breadth:=50;
        IF edgeStart{2}.Height<=0 edgeStart{2}.Height:=50;
        IF edgeEnd{1}.Breadth<=0 edgeEnd{1}.Breadth:=50;
        IF edgeEnd{1}.Height<=0 edgeEnd{1}.Height:=50;
        IF edgeEnd{2}.Breadth<=0 edgeEnd{2}.Breadth:=50;
        IF edgeEnd{2}.Height<=0 edgeEnd{2}.Height:=50;
    ENDPROC

    PROC rMoveHome_Head()

        WaitUntil stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
        stCommand:="Error_Arc_Touch";
        WaitUntil stReact=["","",""];
        stCommand:="";
        WaitUntil stReact=["","",""];
        nErrorCmd:=1;
        ExitCycle;

    ENDPROC

    PROC rWireReplacementMode()
        VAR jointgroup jTempReadyGroup;
        VAR num nTempChangPos;
        VAR num nMaxHeight;
        !!!!!!==MoveToHome==,[
        rMeasurementHomeCheck;

        jTempReadyGroup:=MergeJgWith();
        jTempReadyGroup.JointG.extax.eax_b:=Limit(0,5300,nLimitY_Positive-nMaintenanceYPos);
        MoveJgJ MergeJgWith(\Gantry:=jTempReadyGroup.JointG),vTargetSpeed,z200;

        jTempReadyGroup.JointG.extax.eax_c:=700;
        MoveJgJ MergeJgWith(\Gantry:=jTempReadyGroup.JointG),vTargetSpeed,z200;

        RETURN ;
    ENDPROC

    PROC rArcErrorGantryDown()
        VAR jointgroup jTempReadyGroup;
        VAR num nTempGantryHeight;
        VAR num nTempPartHeightTemp;
        jTempReadyGroup:=MergeJgWith();
        nTempPartHeightTemp:=max(max(nMaxPartHeightNearArray{1},nMaxPartHeightNearArray{2}),nMaxPartHeightNearArray{3});

        nTempGantryHeight:=nHomeGantryZ-(900+nTempPartHeightTemp);
        jTempReadyGroup.JointG.extax.eax_c:=nTempGantryHeight;
        jTempReadyGroup.JointG.extax.eax_c:=Limit(0,1000,jTempReadyGroup.JointG.extax.eax_c);
        MoveJgJ MergeJgWith(\Gantry:=jTempReadyGroup.JointG),vTargetSpeed,z200;
    ENDPROC

    PROC rMeasurementHomeCheck()
        VAR jointgroup jMeasurementHomeGroup;
        VAR bool bHomeCheck:=FALSE;
        bHomeCheck:=FALSE;
        jMeasurementHomeGroup:=MergeJgWith();
        IF abs(jMeasurementHomeGroup.Joint1.robax.rax_1-jgMeasurementHome.Joint1.robax.rax_1)>1 bHomeCheck:=TRUE;
        IF abs(jMeasurementHomeGroup.Joint1.robax.rax_2-jgMeasurementHome.Joint1.robax.rax_2)>1 bHomeCheck:=TRUE;
        IF abs(jMeasurementHomeGroup.Joint1.robax.rax_3-jgMeasurementHome.Joint1.robax.rax_3)>1 bHomeCheck:=TRUE;
        IF abs(jMeasurementHomeGroup.Joint1.robax.rax_4-jgMeasurementHome.Joint1.robax.rax_4)>1 bHomeCheck:=TRUE;
        IF abs(jMeasurementHomeGroup.Joint1.robax.rax_5-jgMeasurementHome.Joint1.robax.rax_5)>1 bHomeCheck:=TRUE;
        IF abs(jMeasurementHomeGroup.Joint1.robax.rax_6-jgMeasurementHome.Joint1.robax.rax_6)>1 bHomeCheck:=TRUE;
        IF abs(jMeasurementHomeGroup.Joint2.robax.rax_1-jgMeasurementHome.Joint2.robax.rax_1)>1 bHomeCheck:=TRUE;
        IF abs(jMeasurementHomeGroup.Joint2.robax.rax_2-jgMeasurementHome.Joint2.robax.rax_2)>1 bHomeCheck:=TRUE;
        IF abs(jMeasurementHomeGroup.Joint2.robax.rax_3-jgMeasurementHome.Joint2.robax.rax_3)>1 bHomeCheck:=TRUE;
        IF abs(jMeasurementHomeGroup.Joint2.robax.rax_4-jgMeasurementHome.Joint2.robax.rax_4)>1 bHomeCheck:=TRUE;
        IF abs(jMeasurementHomeGroup.Joint2.robax.rax_5-jgMeasurementHome.Joint2.robax.rax_5)>1 bHomeCheck:=TRUE;
        IF abs(jMeasurementHomeGroup.Joint2.robax.rax_6-jgMeasurementHome.Joint2.robax.rax_6)>1 bHomeCheck:=TRUE;

        IF bHomeCheck=TRUE THEN
            rByTaskMoveToRobotHome 1;
        ELSE
            jMeasurementHomeGroup.JointG.extax.eax_c:=0;
            MoveJgJ jMeasurementHomeGroup,vTargetSpeed,fine;
        ENDIF
    ENDPROC

    PROC rjgWireCutHomeCheck()
        VAR jointgroup jWirecutHomeGroup;
        VAR bool bHomeCheck:=FALSE;
        bHomeCheck:=FALSE;
        jWirecutHomeGroup:=MergeJgWith();

        IF abs(jWirecutHomeGroup.Joint1.robax.rax_1-jgWireCutHome.Joint1.robax.rax_1)>1 bHomeCheck:=TRUE;
        IF abs(jWirecutHomeGroup.Joint1.robax.rax_2-jgWireCutHome.Joint1.robax.rax_2)>1 bHomeCheck:=TRUE;
        IF abs(jWirecutHomeGroup.Joint1.robax.rax_3-jgWireCutHome.Joint1.robax.rax_3)>1 bHomeCheck:=TRUE;
        IF abs(jWirecutHomeGroup.Joint1.robax.rax_4-jgWireCutHome.Joint1.robax.rax_4)>1 bHomeCheck:=TRUE;
        IF abs(jWirecutHomeGroup.Joint1.robax.rax_5-jgWireCutHome.Joint1.robax.rax_5)>1 bHomeCheck:=TRUE;
        IF abs(jWirecutHomeGroup.Joint1.robax.rax_6-jgWireCutHome.Joint1.robax.rax_6)>1 bHomeCheck:=TRUE;
        IF abs(jWirecutHomeGroup.Joint2.robax.rax_1-jgWireCutHome.Joint2.robax.rax_1)>1 bHomeCheck:=TRUE;
        IF abs(jWirecutHomeGroup.Joint2.robax.rax_2-jgWireCutHome.Joint2.robax.rax_2)>1 bHomeCheck:=TRUE;
        IF abs(jWirecutHomeGroup.Joint2.robax.rax_3-jgWireCutHome.Joint2.robax.rax_3)>1 bHomeCheck:=TRUE;
        IF abs(jWirecutHomeGroup.Joint2.robax.rax_4-jgWireCutHome.Joint2.robax.rax_4)>1 bHomeCheck:=TRUE;
        IF abs(jWirecutHomeGroup.Joint2.robax.rax_5-jgWireCutHome.Joint2.robax.rax_5)>1 bHomeCheck:=TRUE;
        IF abs(jWirecutHomeGroup.Joint2.robax.rax_6-jgWireCutHome.Joint2.robax.rax_6)>1 bHomeCheck:=TRUE;

        IF bHomeCheck=TRUE THEN
            rByTaskMoveToRobotHome 2;
        ELSE
            jWirecutHomeGroup.JointG.extax.eax_c:=0;
            MoveJgJ jWirecutHomeGroup,vTargetSpeed,fine;
        ENDIF
    ENDPROC

    PROC rByTaskMoveToRobotHome(num nHomeNo)
        VAR jointgroup jgEmptyTarget;
        VAR jointtarget jTempG;
        VAR num ntemp;

        stCommand:="checkpos";
        waituntil stReact=["checkposok","checkposok","checkposok"];
        stCommand:="";
        waituntil stReact=["Ready","Ready","Ready"];

        jgEmptyTarget.Joint1:=CJointT(\TaskName:="T_Rob1");
        jgEmptyTarget.Joint2:=CJointT(\TaskName:="T_Rob2");
        jgEmptyTarget.JointG:=CJointT(\TaskName:="T_Gantry");
        jgEmptyTarget.JointG.extax.eax_c:=0;
        MoveJgJ jgEmptyTarget,vTargetSpeed,fine;

        jgEmptyTarget.Joint1.robax.rax_2:=-90;
        jgEmptyTarget.Joint1.robax.rax_3:=55;
        jgEmptyTarget.Joint2.robax.rax_2:=-90;
        jgEmptyTarget.Joint2.robax.rax_3:=55;
        MoveJgJ jgEmptyTarget,vTargetSpeed,fine;

        jgEmptyTarget.Joint1.robax.rax_5:=0;
        jgEmptyTarget.Joint2.robax.rax_5:=0;
        MoveJgJ jgEmptyTarget,vTargetSpeed,fine;
        IF nHomeNo=1 THEN
            jgEmptyTarget.Joint1.robax.rax_1:=jgMeasurementHome.Joint1.robax.rax_1;
            jgEmptyTarget.Joint2.robax.rax_1:=jgMeasurementHome.Joint2.robax.rax_1;
        ELSEIF nHomeNo=2 THEN
            jgEmptyTarget.Joint1.robax.rax_1:=jgWireCutHome.Joint1.robax.rax_1;
            jgEmptyTarget.Joint2.robax.rax_1:=jgWireCutHome.Joint2.robax.rax_1;
        ENDIF
        jgEmptyTarget.JointG.extax.eax_d:=0;
        MoveJgJ jgEmptyTarget,vTargetSpeed,fine;

        jgEmptyTarget.Joint1:=CJointT(\TaskName:="T_Rob1");
        jgEmptyTarget.Joint2:=CJointT(\TaskName:="T_Rob2");
        jgEmptyTarget.JointG:=CJointT(\TaskName:="T_Gantry");
        IF nHomeNo=1 THEN
            jgEmptyTarget.Joint1.robax:=jgMeasurementHome.Joint1.robax;
            jgEmptyTarget.Joint2.robax:=jgMeasurementHome.Joint2.robax;
        ELSEIF nHomeNo=2 THEN
            jgEmptyTarget.Joint1.robax:=jgWireCutHome.Joint1.robax;
            jgEmptyTarget.Joint2.robax:=jgWireCutHome.Joint2.robax;
        ENDIF
        MoveJgJ jgEmptyTarget,vTargetSpeed,fine;

        RETURN ;
    ENDPROC
    
   PROC rWarm_Up()

        VAR speeddata vWarmUp_Speed;
        VAR num i:=0;
        VAR num nWarmUp_Distance_X;
        VAR num nWarmUp_Distance_Y;
        VAR num nWarmUp_Distance_Z;
        VAR num nWarmUp_Distance_R;
        VAR num nTempDistance:=0;
        VAR clock clWarmUp;
        VAR bool bWarmUpComplete:=FALSE;
        VAR jointgroup jgWarmUpTargetpos;
        VAR num nWarmUp_Target_X:=0;


        !..... Userset Gantry_X .........
        nWarmUp_Target_X:=12000;
        !................................
        jgWarmUpTargetpos:=jgHomeJoint;
        jgWarmUpTargetpos.JointG.extax.eax_a:=nWarmUp_Target_X;
        jgWarmUpTargetpos.JointG.extax.eax_f:=nWarmUp_Target_X;

        jgTarget:=MergeJgWith();
        jgTarget.JointG:=jgWarmUpTargetpos.JointG;
        jgTarget.JointG.extax.eax_d:=90;

        vWarmUp_Speed:=[300,300,10,10];
        ClkReset clWarmUp;
        ClkStart clWarmUp;

        WHILE bWarmUpComplete=FALSE DO

            jgWarm_Up:=MergeJgWith();

            ! eax_a
            IF jgWarm_Up.JointG.extax.eax_a<jgWarmUpTargetpos.JointG.extax.eax_a+149 AND jgWarm_Up.JointG.extax.eax_a>jgWarmUpTargetpos.JointG.extax.eax_a-149 THEN
                jgTarget.JointG.extax.eax_a:=jgWarmUpTargetpos.JointG.extax.eax_a-150;
            ELSE
                IF jgWarm_Up.JointG.extax.eax_a<jgWarmUpTargetpos.JointG.extax.eax_a-150 jgTarget.JointG.extax.eax_a:=jgWarmUpTargetpos.JointG.extax.eax_a+150;
            ENDIF
            nWarmUp_Distance_X:=jgTarget.JointG.extax.eax_a-jgWarm_Up.JointG.extax.eax_a;
            IF nWarmUp_Distance_X>0 THEN
                nTempDistance:=100;
            ELSE
                nTempDistance:=-100;
            ENDIF
            jgWarm_Up.JointG.extax.eax_a:=jgWarm_Up.JointG.extax.eax_a+nTempDistance;
            jgWarm_Up.JointG.extax.eax_f:=jgWarm_Up.JointG.extax.eax_f+nTempDistance;

            ! eax_b
            IF jgWarm_Up.JointG.extax.eax_b>149 jgTarget.JointG.extax.eax_b:=0;
            IF jgWarm_Up.JointG.extax.eax_b<1 jgTarget.JointG.extax.eax_b:=150;
            nWarmUp_Distance_Y:=jgTarget.JointG.extax.eax_b-jgWarm_Up.JointG.extax.eax_b;
            IF nWarmUp_Distance_Y>0 THEN
                nTempDistance:=100;
            ELSE
                nTempDistance:=-100;
            ENDIF
            jgWarm_Up.JointG.extax.eax_b:=jgWarm_Up.JointG.extax.eax_b+nTempDistance;

            ! eax_c
            IF jgWarm_Up.JointG.extax.eax_c<1 jgTarget.JointG.extax.eax_c:=100;
            IF jgWarm_Up.JointG.extax.eax_c>99 jgTarget.JointG.extax.eax_c:=0;
            nWarmUp_Distance_Z:=jgTarget.JointG.extax.eax_c-jgWarm_Up.JointG.extax.eax_c;
            IF nWarmUp_Distance_Z>0 THEN
                nTempDistance:=100;
            ELSE
                nTempDistance:=-100;
            ENDIF
            jgWarm_Up.JointG.extax.eax_c:=jgWarm_Up.JointG.extax.eax_c+nTempDistance;

            ! eax_d
            IF jgWarm_Up.JointG.extax.eax_d<-81 jgTarget.JointG.extax.eax_d:=90;
            IF jgWarm_Up.JointG.extax.eax_d>81 jgTarget.JointG.extax.eax_d:=-90;
            nWarmUp_Distance_R:=jgTarget.JointG.extax.eax_d-jgWarm_Up.JointG.extax.eax_d;
            IF nWarmUp_Distance_R>0 THEN
                nTempDistance:=10;
            ELSE
                nTempDistance:=-10;
            ENDIF
            jgWarm_Up.JointG.extax.eax_d:=jgWarm_Up.JointG.extax.eax_d+nTempDistance;

            !  move
            jgWarm_Up.JointG.extax.eax_b:=Limit(0,5300,jgWarm_Up.JointG.extax.eax_b);
            jgWarm_Up.JointG.extax.eax_c:=Limit(0,100,jgWarm_Up.JointG.extax.eax_c);
            jgWarm_Up.JointG.extax.eax_d:=Limit(-90,90,jgWarm_Up.JointG.extax.eax_d);
            MoveJgJ MergeJgWith(\Gantry:=jgWarm_Up.JointG),vWarmUp_Speed,fine;
            vWarmUp_Speed.v_reax:=vWarmUp_Speed.v_reax+0.1;
            vWarmUp_Speed.v_leax:=vWarmUp_Speed.v_leax+0.5;
            IF vWarmUp_Speed.v_reax>25 vWarmUp_Speed.v_reax:=25;
            IF vWarmUp_Speed.v_leax>250 vWarmUp_Speed.v_leax:=250;
            nWarmUpTime:=ClkRead(clWarmUp);
            IF nWarmUpTime>nWarmUpCycle bWarmUpComplete:=TRUE;
        ENDWHILE
        ClkStop clWarmUp;
        RETURN ;
    ENDPROC

    PROC rGantry_C_Home()
        VAR jointgroup jgGantry_C_Home;
        jgGantry_C_Home:=MergeJgWith();
        jgGantry_C_Home.JointG.extax.eax_c:=0;
        MoveJgJ MergeJgWith(\Gantry:=jgGantry_C_Home.JointG),vTargetSpeed,fine;
        WaitRob\InPos;
        WaitRob\ZeroSpeed;
    ENDPROC       
ENDMODULE
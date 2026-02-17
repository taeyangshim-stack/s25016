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
        pCorrT_ROB1_Start:=CalcTouchTcp(pCorrT_ROB1_Start,jCorrTouchGantry_Start);
        pCorrT_ROB1_End:=CalcTouchTcp(pCorrT_ROB1_End,jCorrTouchGantry_End);

        pCorrT_ROB2_Start:=CalcTouchTcp(pCorrT_ROB2_Start,jCorrTouchGantry_Start);
        pCorrT_ROB2_End:=CalcTouchTcp(pCorrT_ROB2_End,jCorrTouchGantry_End);
        WAITTIME 0.2;
        IF nMode=1 THEN
            posStart:=pCorrT_ROB1_Start.trans;
            nStartThick:=0;
            posEnd:=pCorrT_ROB1_End.trans;
            nEndThick:=0;
        ELSEIF nMode=2 THEN
            posStart:=pCorrT_ROB2_Start.trans;
            nStartThick:=0;
            posEnd:=pCorrT_ROB2_End.trans;
            nEndThick:=0;
        ELSE
            posStart:=(pCorrT_ROB1_Start.trans+pCorrT_ROB2_Start.trans)/2;
            nStartThick:=VectMagn(pCorrT_ROB2_Start.trans-pCorrT_ROB1_Start.trans);
            IF nEndThick>25 Stop;
            posEnd:=(pCorrT_ROB1_End.trans+pCorrT_ROB2_End.trans)/2;
            nEndThick:=VectMagn(pCorrT_ROB2_End.trans-pCorrT_ROB1_End.trans);
            IF nEndThick>25 Stop;
        ENDIF

        posStartLast:=posStart;
        posEndLast:=posEnd;
        rDefineWeldPosR1_Touch;
        rDefineWeldPosR2_Touch;

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
            WeldsG{1}.position.trans:=CalcPosOnLine(posStart,posEnd,nOffsetStart_Gantry);
            WeldsG{1}.position.trans.z:=WeldsG{1}.position.trans.z+nRobWeldSpaceHeight;
            WeldsG{1}.position.rot:=OrientZYX(nNormalizeAngle90,0,0);

            WeldsG{2}.position:=pNull;
            WeldsG{2}.position.trans:=CalcPosOnLine(posStart,posEnd,nLengthWeldLine-nOffsetEnd_Gantry);
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

        WaitUntil stMacro{1}<>"" AND stMacro{2}<>"";
        bResult100:=FALSE;
        bResult010:=FALSE;
        bResult001:=FALSE;

        bResult100:=StrToVal(StrPart(stMacroBuffer_{1},1,1),nMacro100{1});
        bResult010:=StrToVal(StrPart(stMacroBuffer_{1},2,1),nMacro010{1});
        bResult001:=StrToVal(StrPart(stMacroBuffer_{1},3,1),nMacro001{1});
        FOR i FROM 1 TO 10 DO
            macroStartBuffer1{i}:=macroAutoStartA{1,i};
            macroEndBuffer1{i}:=macroAutoEndA{1,i};
        ENDFOR
        seam_TRob1:=smDefault_1{1};
        IF (bRobSwap=True) THEN
            FOR i FROM 1 TO 10 do
                macroStartBuffer1{i}.BreadthOffset:=macroAutoStartB{1,i}.BreadthOffset;
                macroStartBuffer1{i}.HeightOffset:=macroAutoStartB{1,i}.HeightOffset;
                macroStartBuffer1{i}.LengthOffset:=macroAutoStartB{1,i}.LengthOffset;
                macroStartBuffer1{i}.TravelAngle:=macroAutoStartB{1,i}.TravelAngle;
                macroStartBuffer1{i}.WorkingAngle:=macroAutoStartB{1,i}.WorkingAngle;

                macroEndBuffer1{i}.BreadthOffset:=macroAutoEndB{1,i}.BreadthOffset;
                macroEndBuffer1{i}.HeightOffset:=macroAutoEndB{1,i}.HeightOffset;
                macroEndBuffer1{i}.LengthOffset:=macroAutoEndB{1,i}.LengthOffset;
                macroEndBuffer1{i}.TravelAngle:=macroAutoEndB{1,i}.TravelAngle;
                macroEndBuffer1{i}.WorkingAngle:=macroAutoEndB{1,i}.WorkingAngle;
            ENDFOR
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
                pDefineWeldPos.trans.x:=nOffsetStart_Gantry;
                pDefineWeldPos.trans.x:=nOffsetStart_Gantry;
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
                Welds1{nMotionStepCount{1}}.MaxCorr:=macroStartBuffer1{nMotionStartStep}.MaxCorr;
                Welds1{nMotionStepCount{1}}.Bias:=macroStartBuffer1{nMotionStartStep}.Bias;
            ENDIF

            IF (nMacro001{1}=0) OR (nMacro001{1}=1) OR (nMacro001{1}=2) OR (nMacro001{1}=3) OR (nMacro001{1}=4) THEN
                nMotionStepCount{1}:=nMotionStepCount{1}+1;

                pDefineWeldPos:=pNull;
                pDefineWeldPos.trans.x:=nOffsetStart_Gantry+1;
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
                Welds1{nMotionStepCount{1}}.MaxCorr:=macroStartBuffer1{nMotionStartStep}.MaxCorr;
                Welds1{nMotionStepCount{1}}.Bias:=macroStartBuffer1{nMotionStartStep}.Bias;
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
                    pDefineWeldPos.trans.x:=nOffsetStart_Gantry+nOffsetEnd_Gantry+macroEndBuffer1{nMotionEndStep}.LengthOffset;
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
                    Welds1{nMotionStepCount{1}}.MaxCorr:=macroStartBuffer1{nMotionStartStep}.MaxCorr;
                    Welds1{nMotionStepCount{1}}.Bias:=macroStartBuffer1{nMotionStartStep}.Bias;
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

    PROC rDefineWeldPosR1_Touch()
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

        WaitUntil stMacro{1}<>"" AND stMacro{2}<>"";
        bResult100:=FALSE;
        bResult010:=FALSE;
        bResult001:=FALSE;

        bResult100:=StrToVal(StrPart(stMacroBuffer_{1},1,1),nMacro100{1});
        bResult010:=StrToVal(StrPart(stMacroBuffer_{1},2,1),nMacro010{1});
        bResult001:=StrToVal(StrPart(stMacroBuffer_{1},3,1),nMacro001{1});
        FOR i FROM 1 TO 10 DO
            macroStartBuffer1{i}:=macroAutoStartA{1,i};
            macroEndBuffer1{i}:=macroAutoEndA{1,i};
        ENDFOR
        seam_TRob1:=smDefault_1{1};
        IF (bRobSwap=True) THEN
            FOR i FROM 1 TO 10 do
                macroStartBuffer1{i}.BreadthOffset:=macroAutoStartB{1,i}.BreadthOffset;
                macroStartBuffer1{i}.HeightOffset:=macroAutoStartB{1,i}.HeightOffset;
                macroStartBuffer1{i}.LengthOffset:=macroAutoStartB{1,i}.LengthOffset;
                macroStartBuffer1{i}.TravelAngle:=macroAutoStartB{1,i}.TravelAngle;
                macroStartBuffer1{i}.WorkingAngle:=macroAutoStartB{1,i}.WorkingAngle;

                macroEndBuffer1{i}.BreadthOffset:=macroAutoEndB{1,i}.BreadthOffset;
                macroEndBuffer1{i}.HeightOffset:=macroAutoEndB{1,i}.HeightOffset;
                macroEndBuffer1{i}.LengthOffset:=macroAutoEndB{1,i}.LengthOffset;
                macroEndBuffer1{i}.TravelAngle:=macroAutoEndB{1,i}.TravelAngle;
                macroEndBuffer1{i}.WorkingAngle:=macroAutoEndB{1,i}.WorkingAngle;
            ENDFOR
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
                    pDefineWeldPos.trans.x:=macroStartBuffer1{nMotionStartStep}.LengthOffset+nSearchBuffer_X_Start{1};
                    pDefineWeldPos.trans.z:=macroStartBuffer1{nMotionStartStep}.HeightOffset+nSearchBuffer_Z_Start{1};
                    !+rCalcWeldsPos_LERP(nSearchBuffer_Z_Start{1},nSearchBuffer_Z_End{1},nWeldLineLength_R1,pDefineWeldPos.trans.x);
                    pDefineWeldPos.robconf:=[0,0,0,1];

                    IF (bRobSwap=FALSE) THEN
                        pDefineWeldPos.trans.y:=(macroStartBuffer1{nMotionStartStep}.BreadthOffset*(-1))+nSearchBuffer_Y_Start{1};
                        !+rCalcWeldsPos_LERP(nSearchBuffer_Y_Start{1},nSearchBuffer_Y_End{1},nWeldLineLength_R1,pDefineWeldPos.trans.x);
                        pDefineWeldPos.rot:=[0.5,0.5,-0.5,0.5];
                        pDefineWeldPos:=RelTool(pDefineWeldPos,0,0,0\Rx:=-1*macroStartBuffer1{nMotionStartStep}.TravelAngle\Ry:=-1*macroStartBuffer1{nMotionStartStep}.WorkingAngle+nBreakPoint{1});
                    ELSE
                        pDefineWeldPos.trans.y:=(macroStartBuffer1{nMotionStartStep}.BreadthOffset)+nSearchBuffer_Y_Start{1};
                        !+rCalcWeldsPos_LERP(nSearchBuffer_Y_Start{1},nSearchBuffer_Y_End{1},nWeldLineLength_R1,pDefineWeldPos.trans.x);
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
                pDefineWeldPos.trans.x:=nOffsetStart_Gantry+nSearchBuffer_X_Start{1}-25;
                pDefineWeldPos.trans.z:=macroStartBuffer1{nMotionStartStep}.HeightOffset+nSearchBuffer_Z_Start{1};
                !+rCalcWeldsPos_LERP(nSearchBuffer_Z_Start{1},nSearchBuffer_Z_End{1},nWeldLineLength_R1,pDefineWeldPos.trans.x);
                pDefineWeldPos.robconf:=[0,0,0,1];

                IF (bRobSwap=FALSE) THEN
                    pDefineWeldPos.trans.y:=(macroStartBuffer1{nMotionStartStep}.BreadthOffset*(-1))+nSearchBuffer_Y_Start{1};
                    !rCalcWeldsPos_LERP(nSearchBuffer_Y_Start{1},nSearchBuffer_Y_End{1},nWeldLineLength_R1,pDefineWeldPos.trans.x);
                    pDefineWeldPos.rot:=[0.5,0.5,-0.5,0.5];
                ELSE
                    pDefineWeldPos.trans.y:=(macroStartBuffer1{nMotionStartStep}.BreadthOffset)+nSearchBuffer_Y_Start{1};
                    !rCalcWeldsPos_LERP(nSearchBuffer_Y_Start{1},nSearchBuffer_Y_End{1},nWeldLineLength_R1,pDefineWeldPos.trans.x);
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
                Welds1{nMotionStepCount{1}}.MaxCorr:=macroStartBuffer1{nMotionStartStep}.MaxCorr;
                Welds1{nMotionStepCount{1}}.Bias:=macroStartBuffer1{nMotionStartStep}.Bias;
            ENDIF

            IF (nMacro001{1}=0) OR (nMacro001{1}=1) OR (nMacro001{1}=2) OR (nMacro001{1}=3) OR (nMacro001{1}=4) THEN
                nMotionStepCount{1}:=nMotionStepCount{1}+1;

                pDefineWeldPos:=pNull;
                pDefineWeldPos.trans.x:=nOffsetStart_Gantry+25+nSearchBuffer_X_End{1};
                pDefineWeldPos.trans.z:=macroEndBuffer1{1}.HeightOffset+nSearchBuffer_Z_End{1};
                !rCalcWeldsPos_LERP(nSearchBuffer_Z_Start{1},nSearchBuffer_Z_End{1},nWeldLineLength_R1,pDefineWeldPos.trans.x);
                pDefineWeldPos.robconf:=[0,0,0,1];

                IF (bRobSwap=FALSE) THEN
                    pDefineWeldPos.trans.y:=(macroEndBuffer1{1}.BreadthOffset*(-1))+nSearchBuffer_Y_End{1};
                    !rCalcWeldsPos_LERP(nSearchBuffer_Y_Start{1},nSearchBuffer_Y_End{1},nWeldLineLength_R1,pDefineWeldPos.trans.x);
                    pDefineWeldPos.rot:=[0.5,0.5,-0.5,0.5];
                ELSE
                    pDefineWeldPos.trans.y:=(macroEndBuffer1{1}.BreadthOffset)+nSearchBuffer_Y_End{1};
                    !rCalcWeldsPos_LERP(nSearchBuffer_Y_Start{1},nSearchBuffer_Y_End{1},nWeldLineLength_R1,pDefineWeldPos.trans.x);
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
                Welds1{nMotionStepCount{1}}.MaxCorr:=macroStartBuffer1{nMotionStartStep}.MaxCorr;
                Welds1{nMotionStepCount{1}}.Bias:=macroStartBuffer1{nMotionStartStep}.Bias;
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
                    pDefineWeldPos.trans.x:=nOffsetStart_Gantry+nOffsetEnd_Gantry+macroEndBuffer1{nMotionEndStep}.LengthOffset+nSearchBuffer_X_End{1};
                    pDefineWeldPos.trans.z:=macroEndBuffer1{nMotionEndStep}.HeightOffset+nSearchBuffer_Z_End{1};
                    !rCalcWeldsPos_LERP(nSearchBuffer_Z_Start{1},nSearchBuffer_Z_End{1},nWeldLineLength_R1,pDefineWeldPos.trans.x);
                    pDefineWeldPos.robconf:=[0,0,0,1];

                    IF (bRobSwap=FALSE) THEN
                        pDefineWeldPos.trans.y:=(macroEndBuffer1{nMotionEndStep}.BreadthOffset*(-1))+nSearchBuffer_Y_End{1};
                        !rCalcWeldsPos_LERP(nSearchBuffer_Y_Start{1},nSearchBuffer_Y_End{1},nWeldLineLength_R1,pDefineWeldPos.trans.x);
                        pDefineWeldPos.rot:=[0.5,0.5,-0.5,0.5];
                        pDefineWeldPos:=RelTool(pDefineWeldPos,0,0,0\Rx:=-1*macroEndBuffer1{nMotionEndStep}.TravelAngle\Ry:=-1*macroEndBuffer1{nMotionEndStep}.WorkingAngle+nBreakPoint{1});
                    ELSE
                        pDefineWeldPos.trans.y:=(macroEndBuffer1{nMotionEndStep}.BreadthOffset)+nSearchBuffer_Y_End{1};
                        !rCalcWeldsPos_LERP(nSearchBuffer_Y_Start{1},nSearchBuffer_Y_End{1},nWeldLineLength_R1,pDefineWeldPos.trans.x);
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
                    Welds1{nMotionStepCount{1}}.MaxCorr:=macroStartBuffer1{nMotionStartStep}.MaxCorr;
                    Welds1{nMotionStepCount{1}}.Bias:=macroStartBuffer1{nMotionStartStep}.Bias;
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

        WaitUntil stMacro{1}<>"" AND stMacro{2}<>"";
        bResult100:=FALSE;
        bResult010:=FALSE;
        bResult001:=FALSE;

        bResult100:=StrToVal(StrPart(stMacroBuffer_{2},1,1),nMacro100{2});
        bResult010:=StrToVal(StrPart(stMacroBuffer_{2},2,1),nMacro010{2});
        bResult001:=StrToVal(StrPart(stMacroBuffer_{2},3,1),nMacro001{2});
        FOR i FROM 1 TO 10 DO
            macroStartBuffer2{i}:=macroAutoStartB{2,i};
            macroEndBuffer2{i}:=macroAutoEndB{2,i};
        ENDFOR
        seam_TRob2:=smDefault_2{1};

        IF (bRobSwap=True) THEN
            FOR i FROM 1 TO 10 do
                macroStartBuffer2{i}.BreadthOffset:=macroAutoStartA{2,i}.BreadthOffset;
                macroStartBuffer2{i}.HeightOffset:=macroAutoStartA{2,i}.HeightOffset;
                macroStartBuffer2{i}.LengthOffset:=macroAutoStartA{2,i}.LengthOffset;
                macroStartBuffer2{i}.TravelAngle:=macroAutoStartA{2,i}.TravelAngle;
                macroStartBuffer2{i}.WorkingAngle:=macroAutoStartA{2,i}.WorkingAngle;

                macroEndBuffer2{i}.BreadthOffset:=macroAutoEndA{2,i}.BreadthOffset;
                macroEndBuffer2{i}.HeightOffset:=macroAutoEndA{2,i}.HeightOffset;
                macroEndBuffer2{i}.LengthOffset:=macroAutoEndA{2,i}.LengthOffset;
                macroEndBuffer2{i}.TravelAngle:=macroAutoEndA{2,i}.TravelAngle;
                macroEndBuffer2{i}.WorkingAngle:=macroAutoEndA{2,i}.WorkingAngle;
            ENDFOR
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
                pDefineWeldPos.trans.x:=nOffsetStart_Gantry;
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
                Welds2{nMotionStepCount{2}}.MaxCorr:=macroStartBuffer2{nMotionStartStep}.MaxCorr;
                Welds2{nMotionStepCount{2}}.Bias:=macroStartBuffer2{nMotionStartStep}.Bias;
            ENDIF

            !!! Calculcate gantry position from end point !!!
            IF (nMacro001{2}=0) OR (nMacro001{2}=1) OR (nMacro001{2}=2) OR (nMacro001{2}=3) OR (nMacro001{2}=4) THEN
                nMotionStepCount{2}:=nMotionStepCount{2}+1;

                pDefineWeldPos:=pNull;
                pDefineWeldPos.trans.x:=nOffsetStart_Gantry+1;
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
                Welds2{nMotionStepCount{2}}.MaxCorr:=macroStartBuffer2{nMotionStartStep}.MaxCorr;
                Welds2{nMotionStepCount{2}}.Bias:=macroStartBuffer2{nMotionStartStep}.Bias;
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
                    pDefineWeldPos.trans.x:=nOffsetStart_Gantry+nOffsetEnd_Gantry+macroEndBuffer2{nMotionEndStep}.LengthOffset;
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
                    Welds2{nMotionStepCount{2}}.MaxCorr:=macroStartBuffer2{nMotionStartStep}.MaxCorr;
                    Welds2{nMotionStepCount{2}}.Bias:=macroStartBuffer2{nMotionStartStep}.Bias;
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

    PROC rDefineWeldPosR2_Touch()
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

        WaitUntil stMacro{1}<>"" AND stMacro{2}<>"";
        bResult100:=FALSE;
        bResult010:=FALSE;
        bResult001:=FALSE;

        bResult100:=StrToVal(StrPart(stMacroBuffer_{2},1,1),nMacro100{2});
        bResult010:=StrToVal(StrPart(stMacroBuffer_{2},2,1),nMacro010{2});
        bResult001:=StrToVal(StrPart(stMacroBuffer_{2},3,1),nMacro001{2});
        FOR i FROM 1 TO 10 DO
            macroStartBuffer2{i}:=macroAutoStartB{2,i};
            macroEndBuffer2{i}:=macroAutoEndB{2,i};
        ENDFOR
        seam_TRob2:=smDefault_2{1};

        IF (bRobSwap=True) THEN
            FOR i FROM 1 TO 10 do
                macroStartBuffer2{i}.BreadthOffset:=macroAutoStartA{2,i}.BreadthOffset;
                macroStartBuffer2{i}.HeightOffset:=macroAutoStartA{2,i}.HeightOffset;
                macroStartBuffer2{i}.LengthOffset:=macroAutoStartA{2,i}.LengthOffset;
                macroStartBuffer2{i}.TravelAngle:=macroAutoStartA{2,i}.TravelAngle;
                macroStartBuffer2{i}.WorkingAngle:=macroAutoStartA{2,i}.WorkingAngle;

                macroEndBuffer2{i}.BreadthOffset:=macroAutoEndA{2,i}.BreadthOffset;
                macroEndBuffer2{i}.HeightOffset:=macroAutoEndA{2,i}.HeightOffset;
                macroEndBuffer2{i}.LengthOffset:=macroAutoEndA{2,i}.LengthOffset;
                macroEndBuffer2{i}.TravelAngle:=macroAutoEndA{2,i}.TravelAngle;
                macroEndBuffer2{i}.WorkingAngle:=macroAutoEndA{2,i}.WorkingAngle;
            ENDFOR
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
                    pDefineWeldPos.trans.x:=macroStartBuffer2{nMotionStartStep}.LengthOffset+nSearchBuffer_X_Start{2};
                    pDefineWeldPos.trans.z:=macroStartBuffer2{nMotionStartStep}.HeightOffset+nSearchBuffer_Z_Start{2};
                    !rCalcWeldsPos_LERP(nSearchBuffer_Z_Start{2},nSearchBuffer_Z_End{2},nWeldLineLength_R2,pDefineWeldPos.trans.x);
                    pDefineWeldPos.robconf:=[0,0,0,1];

                    IF (bRobSwap=TRUE) THEN
                        pDefineWeldPos.trans.y:=(macroStartBuffer2{nMotionStartStep}.BreadthOffset*(-1))+nSearchBuffer_Y_Start{2};
                        !rCalcWeldsPos_LERP(nSearchBuffer_Y_Start{2},nSearchBuffer_Y_End{2},nWeldLineLength_R2,pDefineWeldPos.trans.x);
                        pDefineWeldPos.rot:=[0.5,0.5,-0.5,0.5];
                        pDefineWeldPos:=RelTool(pDefineWeldPos,0,0,0\Rx:=-1*macroStartBuffer2{nMotionStartStep}.TravelAngle\Ry:=-1*macroStartBuffer2{nMotionStartStep}.WorkingAngle+nBreakPoint{2});
                    ELSE
                        pDefineWeldPos.trans.y:=(macroStartBuffer2{nMotionStartStep}.BreadthOffset)+nSearchBuffer_Y_Start{2};
                        !rCalcWeldsPos_LERP(nSearchBuffer_Y_Start{2},nSearchBuffer_Y_End{2},nWeldLineLength_R2,pDefineWeldPos.trans.x);
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
                pDefineWeldPos.trans.x:=nOffsetStart_Gantry-25+nSearchBuffer_X_Start{2};
                pDefineWeldPos.trans.z:=macroStartBuffer2{nMotionStartStep}.HeightOffset+nSearchBuffer_Z_Start{2};
                !rCalcWeldsPos_LERP(nSearchBuffer_Z_Start{2},nSearchBuffer_Z_End{2},nWeldLineLength_R2,pDefineWeldPos.trans.x);
                pDefineWeldPos.robconf:=[0,0,0,1];

                IF (bRobSwap=TRUE) THEN
                    pDefineWeldPos.trans.y:=(macroStartBuffer2{nMotionStartStep}.BreadthOffset*(-1))+nSearchBuffer_Y_Start{2};
                    !rCalcWeldsPos_LERP(nSearchBuffer_Y_Start{2},nSearchBuffer_Y_End{2},nWeldLineLength_R2,pDefineWeldPos.trans.x);
                    pDefineWeldPos.rot:=[0.5,0.5,-0.5,0.5];
                ELSE
                    pDefineWeldPos.trans.y:=(macroStartBuffer2{nMotionStartStep}.BreadthOffset)+nSearchBuffer_Y_Start{2};
                    !rCalcWeldsPos_LERP(nSearchBuffer_Y_Start{2},nSearchBuffer_Y_End{2},nWeldLineLength_R2,pDefineWeldPos.trans.x);
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
                Welds2{nMotionStepCount{2}}.MaxCorr:=macroStartBuffer2{nMotionStartStep}.MaxCorr;
                Welds2{nMotionStepCount{2}}.Bias:=macroStartBuffer2{nMotionStartStep}.Bias;
            ENDIF

            !!! Calculcate gantry position from end point !!!
            IF (nMacro001{2}=0) OR (nMacro001{2}=1) OR (nMacro001{2}=2) OR (nMacro001{2}=3) OR (nMacro001{2}=4) THEN
                nMotionStepCount{2}:=nMotionStepCount{2}+1;

                pDefineWeldPos:=pNull;
                pDefineWeldPos.trans.x:=nOffsetStart_Gantry+25+nSearchBuffer_X_End{2};
                pDefineWeldPos.trans.z:=macroEndBuffer2{1}.HeightOffset+nSearchBuffer_Z_End{2};
                !rCalcWeldsPos_LERP(nSearchBuffer_Z_Start{2},nSearchBuffer_Z_End{2},nWeldLineLength_R2,pDefineWeldPos.trans.x);
                pDefineWeldPos.robconf:=[0,0,0,1];

                IF (bRobSwap=TRUE) THEN
                    pDefineWeldPos.trans.y:=(macroEndBuffer2{1}.BreadthOffset*(-1))+nSearchBuffer_Y_End{2};
                    !rCalcWeldsPos_LERP(nSearchBuffer_Y_Start{2},nSearchBuffer_Y_End{2},nWeldLineLength_R2,pDefineWeldPos.trans.x);
                    pDefineWeldPos.rot:=[0.5,0.5,-0.5,0.5];
                ELSE
                    pDefineWeldPos.trans.y:=(macroEndBuffer2{1}.BreadthOffset)+nSearchBuffer_Y_End{2};
                    !rCalcWeldsPos_LERP(nSearchBuffer_Y_Start{2},nSearchBuffer_Y_End{2},nWeldLineLength_R2,pDefineWeldPos.trans.x);
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
                Welds2{nMotionStepCount{2}}.MaxCorr:=macroStartBuffer2{nMotionStartStep}.MaxCorr;
                Welds2{nMotionStepCount{2}}.Bias:=macroStartBuffer2{nMotionStartStep}.Bias;
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
                    pDefineWeldPos.trans.x:=nOffsetStart_Gantry+nOffsetEnd_Gantry+macroEndBuffer2{nMotionEndStep}.LengthOffset+nSearchBuffer_X_End{2};
                    pDefineWeldPos.trans.z:=macroEndBuffer2{nMotionEndStep}.HeightOffset+nSearchBuffer_Z_End{2};
                    !rCalcWeldsPos_LERP(nSearchBuffer_Z_Start{2},nSearchBuffer_Z_End{2},nWeldLineLength_R2,pDefineWeldPos.trans.x);
                    pDefineWeldPos.robconf:=[0,0,0,1];

                    IF (bRobSwap=TRUE) THEN
                        pDefineWeldPos.trans.y:=(macroEndBuffer2{nMotionEndStep}.BreadthOffset*(-1))+nSearchBuffer_Y_End{2};
                        !rCalcWeldsPos_LERP(nSearchBuffer_Y_Start{2},nSearchBuffer_Y_End{2},nWeldLineLength_R2,pDefineWeldPos.trans.x);
                        pDefineWeldPos.rot:=[0.5,0.5,-0.5,0.5];
                        pDefineWeldPos:=RelTool(pDefineWeldPos,0,0,0\Rx:=-1*macroEndBuffer2{nMotionEndStep}.TravelAngle\Ry:=-1*macroEndBuffer2{nMotionEndStep}.WorkingAngle+nBreakPoint{2});
                    ELSE
                        pDefineWeldPos.trans.y:=(macroEndBuffer2{nMotionEndStep}.BreadthOffset)+nSearchBuffer_Y_End{2};
                        !rCalcWeldsPos_LERP(nSearchBuffer_Y_Start{2},nSearchBuffer_Y_End{2},nWeldLineLength_R2,pDefineWeldPos.trans.x);
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
                    Welds2{nMotionStepCount{2}}.MaxCorr:=macroStartBuffer2{nMotionStartStep}.MaxCorr;
                    Welds2{nMotionStepCount{2}}.Bias:=macroStartBuffer2{nMotionStartStep}.Bias;
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
        VAR num nWeldLineLength_R1_buffer;
        VAR num nWeldLineLength_R2_buffer;
        VAR num nOffsetStart_Gantry_buffer;
        VAR num nOffsetEnd_Gantry_buffer;
        VAR num nMode_;
        VAR bool bResult100;
        VAR bool bResult010;
        VAR bool bResult001;

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

        WaitUntil stMacro{1}<>"" AND stMacro{2}<>"";
        IF (nAngleRzStore<-90 OR 90<=nAngleRzStore) THEN
            bRobSwap:=TRUE;
            stMacroBuffer_{1}:=stMacro{2};
            stMacroBuffer_{2}:=stMacro{1};
        ELSE
            bRobSwap:=FALSE;
            stMacroBuffer_{1}:=stMacro{1};
            stMacroBuffer_{2}:=stMacro{2};
        ENDIF

        bResult100:=StrToVal(StrPart(stMacroBuffer_{1},1,1),nMacro100{1});
        bResult100:=StrToVal(StrPart(stMacroBuffer_{2},1,1),nMacro100{2});
        bResult010:=StrToVal(StrPart(stMacroBuffer_{1},2,1),nMacro010{1});
        bResult010:=StrToVal(StrPart(stMacroBuffer_{2},2,1),nMacro010{2});
        bResult001:=StrToVal(StrPart(stMacroBuffer_{1},3,1),nMacro001{1});
        bResult001:=StrToVal(StrPart(stMacroBuffer_{2},3,1),nMacro001{2});


        IF nMacro100{1}=1 AND nMacro100{2}=0 THEN
            nMode:=1;
        ELSEIF nMacro100{1}=0 AND nMacro100{2}=1 THEN
            nMode:=2;
        ELSE
            nMode:=3;
        ENDIF

        IF nMode=1 THEN
            IF nMacro010{1}=0 THEN
                nOffsetStart_A:=50;
            ELSEIF nMacro010{1}=1 THEN
                nOffsetStart_A:=80;
            ELSEIF nMacro010{1}=2 THEN
                nOffsetStart_A:=150;
            ELSEIF nMacro010{1}=4 THEN
                nOffsetStart_A:=50;
            ENDIF
            IF nMacro001{1}=0 THEN
                nOffsetEnd_A:=50;
            ELSEIF nMacro001{1}=1 THEN
                nOffsetEnd_A:=80;
            ELSEIF nMacro001{1}=2 THEN
                nOffsetEnd_A:=150;
            ELSEIF nMacro001{1}=4 THEN
                nOffsetEnd_A:=50;
            ENDIF
            IF nMacro010{2}=0 THEN
                nOffsetStart_B:=50;
            ELSEIF nMacro010{2}=1 THEN
                nOffsetStart_B:=80;
            ELSEIF nMacro010{2}=2 THEN
                nOffsetStart_B:=150;
            ELSEIF nMacro010{2}=4 THEN
                nOffsetStart_B:=50;
            ENDIF
            IF nMacro001{2}=0 THEN
                nOffsetEnd_B:=50;
            ELSEIF nMacro001{2}=1 THEN
                nOffsetEnd_B:=80;
            ELSEIF nMacro001{2}=2 THEN
                nOffsetEnd_B:=150;
            ELSEIF nMacro001{2}=4 THEN
                nOffsetEnd_B:=50;
            ENDIF

        ELSEIF nMode=2 THEN
            IF nMacro010{1}=0 THEN
                nOffsetStart_A:=50;
            ELSEIF nMacro010{1}=1 THEN
                nOffsetStart_A:=80;
            ELSEIF nMacro010{1}=2 THEN
                nOffsetStart_A:=150;
            ELSEIF nMacro010{1}=4 THEN
                nOffsetStart_A:=50;
            ENDIF
            IF nMacro001{1}=0 THEN
                nOffsetEnd_A:=50;
            ELSEIF nMacro001{1}=1 THEN
                nOffsetEnd_A:=80;
            ELSEIF nMacro001{1}=2 THEN
                nOffsetEnd_A:=150;
            ELSEIF nMacro001{1}=4 THEN
                nOffsetEnd_A:=50;
            ENDIF
            IF nMacro010{2}=0 THEN
                nOffsetStart_B:=50;
            ELSEIF nMacro010{2}=1 THEN
                nOffsetStart_B:=80;
            ELSEIF nMacro010{2}=2 THEN
                nOffsetStart_B:=150;
            ELSEIF nMacro010{2}=4 THEN
                nOffsetStart_B:=50;
            ENDIF
            IF nMacro001{2}=0 THEN
                nOffsetEnd_B:=50;
            ELSEIF nMacro001{2}=1 THEN
                nOffsetEnd_B:=80;
            ELSEIF nMacro001{2}=2 THEN
                nOffsetEnd_B:=150;
            ELSEIF nMacro001{2}=4 THEN
                nOffsetEnd_B:=50;
            ENDIF

        ELSE
            IF nMacro010{1}=0 THEN
                nOffsetStart_A:=50;
            ELSEIF nMacro010{1}=1 THEN
                nOffsetStart_A:=80;
            ELSEIF nMacro010{1}=2 THEN
                nOffsetStart_A:=150;
            ELSEIF nMacro010{1}=4 THEN
                nOffsetStart_A:=50;
            ENDIF

            IF nMacro010{2}=0 THEN
                nOffsetStart_B:=50;
            ELSEIF nMacro010{2}=1 THEN
                nOffsetStart_B:=80;
            ELSEIF nMacro010{2}=2 THEN
                nOffsetStart_B:=150;
            ELSEIF nMacro010{2}=4 THEN
                nOffsetStart_B:=50;
            ENDIF

            IF nMacro001{1}=0 THEN
                nOffsetEnd_A:=50;
            ELSEIF nMacro001{1}=1 THEN
                nOffsetEnd_A:=80;
            ELSEIF nMacro001{1}=2 THEN
                nOffsetEnd_A:=150;
            ELSEIF nMacro001{1}=4 THEN
                nOffsetEnd_A:=50;
            ENDIF

            IF nMacro001{2}=0 THEN
                nOffsetEnd_B:=50;
            ELSEIF nMacro001{2}=1 THEN
                nOffsetEnd_B:=80;
            ELSEIF nMacro001{2}=2 THEN
                nOffsetEnd_B:=150;
            ELSEIF nMacro001{2}=4 THEN
                nOffsetEnd_B:=50;
            ENDIF
        ENDIF


        nOffsetStart_Gantry:=Max(nOffsetStart_A,nOffsetStart_B);
        nOffsetEnd_Gantry:=Max(nOffsetEnd_A,nOffsetEnd_B);

        nWeldLineLength_R1:=nOffsetStart_Gantry+nOffsetEnd_Gantry;
        nWeldLineLength_R2:=nOffsetStart_Gantry+nOffsetEnd_Gantry;

        IF bRobSwap=TRUE THEN
            wobjWeldLine1.uframe:=[[488,-nOffsetStart_Gantry,nRobWeldSpaceHeight],[0,0.7071067812,0.7071067812,0]];
            wobjWeldLine2.uframe:=[[488,nOffsetStart_Gantry,nRobWeldSpaceHeight],[0,0.7071067812,-0.7071067812,0]];
        ELSE
            wobjWeldLine1.uframe:=[[488,nOffsetStart_Gantry,nRobWeldSpaceHeight],[0,0.7071067812,-0.7071067812,0]];
            wobjWeldLine2.uframe:=[[488,-nOffsetStart_Gantry,nRobWeldSpaceHeight],[0,0.7071067812,0.7071067812,0]];
        ENDIF


    ENDPROC

    PROC rMoveCorrConnect(num X,num Y,num Z,num Rx,num Ry,num Rz,num Eax_d,bool isStartPos,bool CCW,\switch LIN)
        VAR robtarget pTempConnect;

        IF isStartPos=bStart THEN
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
        jEmptyTarget:=jHomeJoint;
        jEmptyTarget.extax.eax_a:=jHomeJoint.extax.eax_a+nHomeAdjustX;
        jEmptyTarget.extax.eax_b:=jHomeJoint.extax.eax_b+nHomeAdjustY;
        jEmptyTarget.extax.eax_c:=jHomeJoint.extax.eax_c+nHomeAdjustZ;
        jEmptyTarget.extax.eax_d:=jHomeJoint.extax.eax_d+nHomeAdjustR;
        MoveJgJ jgHomeJoint,vTargetSpeed,fine;
    ENDPROC

    PROC rMoveNoWeld()
        IF nMode=1 THEN
            stCommand:="Weld1";
            WaitUntil stReact=["WeldOk","WeldOk","WeldOk"];
            stCommand:="";
            WaitUntil stReact=["Ready","Ready","Ready"];
        ELSEIF nMode=2 THEN
            stCommand:="Weld2";
            WaitUntil stReact=["WeldOk","WeldOk","WeldOk"];
            stCommand:="";
            WaitUntil stReact=["Ready","Ready","Ready"];
        ELSE
            stCommand:="Weld";
            WaitUntil stReact=["WeldOk","WeldOk","WeldOk"];
            stCommand:="";
            WaitUntil stReact=["Ready","Ready","Ready"];
        ENDIF
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
        VAR bool bResult1_100;
        VAR bool bResult2_100;

        Command:=0;
        nMotionStep:=1;
        ClkReset clockCycleTime;
        ClkStart clockCycleTime;

        bCorrectionOk:=FALSE;

        IF (edgeStart{1}.EdgePos.z=50) THEN
            posStart:=edgeStart{2}.EdgePos;
            nStartThick:=0;
            posEnd:=edgeEnd{2}.EdgePos;
            nEndThick:=0;

        ELSEIF (edgeStart{2}.EdgePos.z=50) THEN
            posStart:=edgeStart{1}.EdgePos;
            nStartThick:=0;
            posEnd:=edgeEnd{1}.EdgePos;
            nEndThick:=0;
        ELSE
            posStart:=(edgeStart{1}.EdgePos+edgeStart{2}.EdgePos)/2;
            nStartThick:=VectMagn(edgeStart{2}.EdgePos-edgeStart{1}.EdgePos);
            IF nStartThick>20 Stop;
            posEnd:=(edgeEnd{1}.EdgePos+edgeEnd{2}.EdgePos)/2;
            nEndThick:=VectMagn(edgeEnd{2}.EdgePos-edgeEnd{1}.EdgePos);
            IF nEndThick>20 Stop;
        ENDIF


        posStartLast:=posStart;
        posEndLast:=posEnd;
        !!!!!!

        IF bEnableManualMacro=TRUE THEN
            macroAutoStartA:=macroManualStartA;
            macroAutoStartB:=macroManualStartB;
            macroAutoEndA:=macroManualEndA;
            macroAutoEndB:=macroManualEndB;
        ENDIF

        rDefineWobjWeldLine posStart,posEnd;
        rDefineWeldPosR1;
        rDefineWeldPosR2;
        rDefineWeldPosG;

        IF nMotionStep=1 THEN

            jMoveGantry:=CJointT();



            IF (bEnableStartEndPointCorr=TRUE) THEN
                IF nMaxPartHeightNearArray{3}>800 OR nMaxPartHeightNearArray{2}>800 THEN
                    IF bMoveToWireCutHome=FALSE rMeasurementHomeCheck;
                    IF bMoveToWireCutHome=TRUE rjgWireCutHomeCheck;
                ELSE
                    rjgWireCutHomeCheck;
                ENDIF
            ELSE
                IF nMaxPartHeightNearArray{1}>800 OR nMaxPartHeightNearArray{2}>800 THEN
                    IF bMoveToWireCutHome=FALSE rMeasurementHomeCheck;
                    IF bMoveToWireCutHome=TRUE rjgWireCutHomeCheck;
                ELSE
                    rjgWireCutHomeCheck;
                ENDIF
            ENDIF

            IF (bEnableStartEndPointCorr=FALSE) THEN
                jMoveGantry:=fnCoordToJoint(fnPoseToExtax(WeldsG{1}.position));
            ELSE
                IF bTouch_last_R1_Comp=TRUE AND bTouch_last_R2_Comp=TRUE THEN
                    jMoveGantry:=fnCoordToJoint(fnPoseToExtax(WeldsG{1}.position));
                ELSE
                    jMoveGantry:=fnCoordToJoint(fnPoseToExtax(WeldsG{2}.position));
                ENDIF
            ENDIF

            jMoveGantry.extax.eax_c:=0;
            jMoveGantry.extax.eax_c:=Limit(0,1000,jMoveGantry.extax.eax_c);
            MoveJgJ MergeJgWith(\Gantry:=jMoveGantry),vTargetSpeed,z200;
            WaitRob\ZeroSpeed;

            rWireCut_Select;

            jTempReadyGroup:=MergeJgWith();
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

            if (nMode=1) THEN
                MoveJgJ MergeJgWith(\Rob1:=jTempReadyGroup.Joint1),vTargetSpeed,z200;
                jTempReadyGroup.Joint1.robax.rax_1:=0;
                MoveJgJ MergeJgWith(\Rob1:=jTempReadyGroup.Joint1),vTargetSpeed,z200;
            ELSEIF nmode=2 THEN
                MoveJgJ MergeJgWith(\Rob2:=jTempReadyGroup.Joint2),vTargetSpeed,z200;
                jTempReadyGroup.Joint2.robax.rax_1:=0;
                MoveJgJ MergeJgWith(\Rob2:=jTempReadyGroup.Joint2),vTargetSpeed,z200;
            ELSE
                MoveJgJ MergeJgWith(\Rob1:=jTempReadyGroup.Joint1\Rob2:=jTempReadyGroup.Joint2),vTargetSpeed,z200;
                jTempReadyGroup.Joint1.robax.rax_1:=0;
                jTempReadyGroup.Joint2.robax.rax_1:=0;
                MoveJgJ MergeJgWith(\Rob1:=jTempReadyGroup.Joint1\Rob2:=jTempReadyGroup.Joint2),vTargetSpeed,z200;

            ENDIF
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

            FOR i FROM 1 TO 10 DO
                IF (NOT jJointStepArray{i}.robax=[0,0,0,0,0,0]) THEN
                    IF nMode=1 THEN
                        MoveJgJ MergeJgWith(\Rob1:=jWeldPrepareR1{i}),vTargetSpeed,zTargetZone;
                    ELSEIF nMode=2 THEN
                        MoveJgJ MergeJgWith(\Rob2:=jWeldPrepareR2{i}),vTargetSpeed,zTargetZone;
                    ELSE
                        MoveJgJ MergeJgWith(\Rob1:=jWeldPrepareR1{i}\Rob2:=jWeldPrepareR2{i}),vTargetSpeed,zTargetZone;
                    ENDIF
                ENDIF
            ENDFOR

            WaitRob\inpos;
            pSearchReadyGroup:=MergePgWith();
            jSearchReadyGroup:=MergeJgWith();
            jTempReadyGroup:=MergeJgWith();

            jTempGantry{1}:=fnCoordToJoint(fnPoseToExtax(WeldsG{1}.position));
            jTempReadyGroup.JointG.extax.eax_c:=jTempGantry{1}.extax.eax_c;
            MoveJgJ MergeJgWith(\Gantry:=jTempReadyGroup.JointG),vTargetSpeed,z200;
        ENDIF

        Reset do13_Torch1_Air_Cooling;
        nMotionStep:=3;
        IF nMotionStep=3 THEN

            FOR i FROM 1 TO nMotionStepCount{1} DO
                nExcutionStep:=i;
                nTempMmps:=Welds1{i}.cpm/6;
                nTempVolt:=Welds1{i}.voltage;
                nTempWFS:=Welds1{i}.wfs;
                wdArray{i}:=[nTempMmps,0,[5,0,nTempVolt,nTempWFS,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
                pWeldPosG{i}.extax.eax_a:=nHomeGantryX+Welds1{i}.position.extax.eax_a;
                pWeldPosG{i}.extax.eax_f:=nHomeGantryX+Welds1{i}.position.extax.eax_f;
                pWeldPosG{i}.extax.eax_b:=nHomeGantryY+Welds1{i}.position.extax.eax_b;
                pWeldPosG{i}.extax.eax_c:=Limit(0,1500,wobjWeldLine.uframe.trans.z-(nRobWeldSpaceHeight+wobjWeldLine.oframe.trans.z+nTempAdjustGantryZ));
            ENDFOR

            jSearchReady:=CJointT();

            IF (bEnableStartEndPointCorr=TRUE) THEN
                rCorrStartEndPoint;

                FOR i FROM 1 TO nMotionStepCount{1} DO
                    nExcutionStep:=i;

                    nTempMmps:=Welds1{i}.cpm/6;
                    nTempVolt:=Welds1{i}.voltage;
                    nTempWFS:=Welds1{i}.wfs;
                    wdArray{i}:=[nTempMmps,0,[5,0,nTempVolt,nTempWFS,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
                    pWeldPosG{i}.extax.eax_a:=nHomeGantryX+Welds1{i}.position.extax.eax_a;
                    pWeldPosG{i}.extax.eax_f:=nHomeGantryX+Welds1{i}.position.extax.eax_f;
                    pWeldPosG{i}.extax.eax_b:=nHomeGantryY+Welds1{i}.position.extax.eax_b;
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
                WaitTime 0;
                rMoveWeld;
            ENDIF
            jTempReadyGroup:=MergeJgWith();
            jTempReadyGroup.Joint1:=jSearchReadyGroup.Joint1;
            jTempReadyGroup.Joint2:=jSearchReadyGroup.Joint2;
            jTempReadyGroup.JointG.extax.eax_c:=jTempReadyGroup.JointG.extax.eax_c-100;
            IF nMode=1 THEN
                MoveJgJ MergeJgWith(\Rob1:=jTempReadyGroup.Joint1\Gantry:=jTempReadyGroup.JointG),vTargetSpeed,z200;
            ELSEIF nMode=2 THEN
                MoveJgJ MergeJgWith(\Rob2:=jTempReadyGroup.Joint2\Gantry:=jTempReadyGroup.JointG),vTargetSpeed,z200;
            ELSE
                MoveJgJ MergeJgWith(\Rob1:=jTempReadyGroup.Joint1\Rob2:=jTempReadyGroup.Joint2\Gantry:=jTempReadyGroup.JointG),vTargetSpeed,z200;
            ENDIF

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
            FOR i FROM 9 TO 1 STEP -1 DO
                IF (NOT jJointStepArray{i}.robax=[0,0,0,0,0,0]) THEN
                    IF nMode=1 THEN
                        MoveJgJ MergeJgWith(\Rob1:=jWeldPrepareR1{i}),vTargetSpeed,zTargetZone;
                    ELSEIF nMode=2 THEN
                        MoveJgJ MergeJgWith(\Rob2:=jWeldPrepareR2{i}),vTargetSpeed,zTargetZone;
                    ELSE
                        MoveJgJ MergeJgWith(\Rob1:=jWeldPrepareR1{i}\Rob2:=jWeldPrepareR2{i}),vTargetSpeed,zTargetZone;
                    ENDIF
                ENDIF
            ENDFOR
        ENDIF

        nMotionStep:=5;
        IF nMotionStep=5 THEN

            PulseDO\high\PLength:=50,do13_Torch1_Air_Cooling;
            PulseDO\high\PLength:=50,do14_Torch2_Air_Cooling;

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
        IF nMode=1 THEN
            stCommand:="Weld1";
            WaitUntil stReact=["WeldOk","WeldOk","WeldOk"]OR stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
            IF stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"]rMoveHome_Head;

            stCommand:="";
            WaitUntil stReact=["Ready","Ready","Ready"];
        ELSEIF nMode=2 THEN
            stCommand:="Weld2";
            WaitUntil stReact=["WeldOk","WeldOk","WeldOk"]OR stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
            IF stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"]rMoveHome_Head;

            stCommand:="";
            WaitUntil stReact=["Ready","Ready","Ready"];
        ELSE
            stCommand:="Weld";
            WaitUntil stReact=["WeldOk","WeldOk","WeldOk"]OR stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
            IF stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"]rMoveHome_Head;

            stCommand:="";
            WaitUntil stReact=["Ready","Ready","Ready"];

        ENDIF
    ENDPROC

    PROC rNozzleClean(string Mode)
        VAR jointgroup jgCurrent;
        rGantry_C_Home;
        bNozzleCleanCut:=TRUE;
        rMeasurementHomeCheck;
        TEST Mode
        CASE "R1":
            rWirecutMove 1;
        CASE "R2":
            rWirecutMove 2;
        CASE "R1&R2":
            rWirecutMove 3;
        DEFAULT:
        ENDTEST
        bNozzleCleanCut:=FALSE;
        TEST Mode
        CASE "R1":
            rNozzleClean_R1;
        CASE "R2":
            rNozzleClean_R2;
        CASE "R1&R2":
            jgCurrent:=MergeJgWith();
            IF jgCurrent.JointG.extax.eax_d<0 THEN
                rNozzleClean_R1;
                rNozzleClean_R2;
            ELSE
                rNozzleClean_R2;
                rNozzleClean_R1;
            ENDIF
        DEFAULT:
        ENDTEST

    ENDPROC

    PROC rNozzleClean_R1()
        VAR jointgroup jgTemp;
        VAR speeddata vTemp:=[25,25,400,25];
        jgTemp:=MergeJgWith();
        jgTemp.JointG.extax.eax_b:=jNozzleClean_R1.extax.eax_b;
        jgTemp.JointG.extax.eax_c:=jNozzleClean_R1.extax.eax_c;
        jgTemp.JointG.extax.eax_d:=jNozzleClean_R1.extax.eax_d;
        MoveJgJ MergeJgWith(\Gantry:=jgTemp.JointG),vTemp,fine;
        WaitRob\InPos;
        nR_Angle:=jgTemp.JointG.extax.eax_d;
        stCommand:="NozzleClean_R1";
        WaitUntil stReact=["NozzleClean_R1_Ok","Ready","Ready"];
        stCommand:="";
        WaitUntil stReact=["Ready","Ready","Ready"];
    ENDPROC

    PROC rNozzleClean_R2()
        VAR jointgroup jgTemp;
        VAR speeddata vTemp:=[25,25,400,25];
        jgTemp:=MergeJgWith();
        jgTemp.JointG.extax.eax_b:=jNozzleClean_R2.extax.eax_b;
        jgTemp.JointG.extax.eax_c:=jNozzleClean_R2.extax.eax_c;
        jgTemp.JointG.extax.eax_d:=jNozzleClean_R2.extax.eax_d;
        MoveJgJ MergeJgWith(\Gantry:=jgTemp.JointG),vTemp,fine;
        WaitRob\InPos;
        nR_Angle:=jgTemp.JointG.extax.eax_d;
        stCommand:="NozzleClean_R2";
        WaitUntil stReact=["Ready","NozzleClean_R2_Ok","Ready"];
        stCommand:="";
        WaitUntil stReact=["Ready","Ready","Ready"];
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
        jTempReadyGroup.JointG.extax.eax_d:=0;
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
        IF bNozzleCleanCut=FALSE jgEmptyTarget.JointG.extax.eax_d:=0;
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



        !..... Userset Gantry_X .........
        !        nWarmUp_Target_X:=-9000;
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

    PROC rLdsCheck()

        rGantry_C_Home;
        rMeasurementHomeCheck;

        stCommand:="LdsCheck";
        WaitUntil(stReact=["Ready","Ready","LdsCheck_Ok"]);

        stCommand:="";
        WaitUntil stReact=["Ready","Ready","Ready"];

        IF bLDS_Origin=FALSE and (abs(nDiffGantryX)>1 OR abs(nDiffGantryY)>1 OR abs(nDiffGantryZ)>1) THEN
            ErrLog 4811,"LDS_OutRangeError","","","","";
            !          WaitUntil pi19_=1 OR pi20_=1;
            !          IF pi19_=1 GOTO LabalReturn;
            !          IF pi20_=1 rSettingInitialize;
        ELSE
            rSettingInitialize;
        ENDIF

    ENDPROC

    PROC rTcp_Inspect()
        VAR jointtarget jMoveGantry;
        VAR jointgroup jTempReadyGroup;
        VAR jointtarget jWeldPrepareR1{10};
        VAR jointtarget jWeldPrepareR2{10};
        VAR jointtarget jTempGantry{2};
        VAR num nGantryAngel;
        VAR robtarget pDefineWeldPos;
        VAR jointgroup jTempGroup;

        posStart.x:=tOrder.Tcp_X;
        posStart.y:=tOrder.Tcp_Y;
        posStart.z:=tOrder.Tcp_Z;
        nGantryAngel:=tOrder.Tcp_Angle;
        posEnd:=posStart;
        posEnd.x:=posEnd.x+100;
        nStartThick:=0;
        nEndThick:=0;
        posStartLast:=posStart;
        posEndLast:=posEnd;
        nLengthWeldLine:=0;
        !!!!!!

        rDefineWobjWeldLineTcp posStart,posEnd;
        nBreakPoint:=[0,0];
        !        rDefineWeldPosR1;
        pDefineWeldPos:=pNull;
        pDefineWeldPos.trans:=[0,0,0];
        pDefineWeldPos.robconf:=[0,0,0,1];
        pDefineWeldPos.rot:=[0.5,0.5,-0.5,0.5];
        pDefineWeldPos:=RelTool(pDefineWeldPos,0,0,0\Rx:=0\Ry:=-45);
        Welds1{1}.position:=pDefineWeldPos;
        pDefineWeldPos.rot:=[0.5,-0.5,-0.5,-0.5];
        pDefineWeldPos:=RelTool(pDefineWeldPos,0,0,0\Rx:=0\Ry:=-45);
        Welds2{1}.position:=pDefineWeldPos;
        WeldsG{1}.position.trans:=CalcPosOnLine(posStart,posEnd,0);
        WeldsG{1}.position.trans.z:=WeldsG{1}.position.trans.z+nRobWeldSpaceHeight;
        jgMoveToTcpComparison:=MergeJgWith();
        rJointGroupRound jgMoveToTcpComparison;
        IF jgMoveToTcp.Joint1=jgMoveToTcpComparison.Joint1 AND jgMoveToTcp.Joint2=jgMoveToTcpComparison.Joint2 AND jgMoveToTcp.JointG=jgMoveToTcpComparison.JointG THEN

        ELSE
            rGantry_C_Home;
            rMoveToRobotHome;
            !=====================================
            !=== Gantry Starting Postion =========
            !=====================================

            jMoveGantry:=fnCoordToJoint(fnPoseToExtax(WeldsG{1}.position));
            jMoveGantry.extax.eax_d:=nGantryAngel*(-1);
            jMoveGantry.extax.eax_c:=0;
            jMoveGantry.extax.eax_c:=Limit(0,1000,jMoveGantry.extax.eax_c);
            MoveJgJ MergeJgWith(\Gantry:=jMoveGantry),vTargetSpeed,z200;
            WaitRob\ZeroSpeed;


            jTempReadyGroup:=MergeJgWith();
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

            !!! Joint move to ready pose !!!
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
        ENDIF
        jTempReadyGroup:=MergeJgWith();
        jTempGantry{1}:=fnCoordToJoint(fnPoseToExtax(WeldsG{1}.position));
        jTempReadyGroup.JointG.extax.eax_c:=jTempGantry{1}.extax.eax_c;
        jTempReadyGroup.JointG.extax.eax_d:=nGantryAngel*(-1);
        MoveJgJ MergeJgWith(\Gantry:=jTempReadyGroup.JointG),vTargetSpeed,z200;

        rMoveToTcp;
        jgMoveToTcp:=MergeJgWith();
        rJointGroupRound jgMoveToTcp;

    ENDPROC

    PROC rJointGroupRound(inout jointgroup jg)
        jg.Joint1.robax.rax_1:=Round(jg.Joint1.robax.rax_1\Dec:=0);
        jg.Joint1.robax.rax_2:=Round(jg.Joint1.robax.rax_2\Dec:=0);
        jg.Joint1.robax.rax_3:=Round(jg.Joint1.robax.rax_3\Dec:=0);
        jg.Joint1.robax.rax_4:=Round(jg.Joint1.robax.rax_4\Dec:=0);
        jg.Joint1.robax.rax_5:=Round(jg.Joint1.robax.rax_5\Dec:=0);
        jg.Joint1.robax.rax_6:=Round(jg.Joint1.robax.rax_6\Dec:=0);

        jg.Joint2.robax.rax_1:=Round(jg.Joint2.robax.rax_1\Dec:=0);
        jg.Joint2.robax.rax_2:=Round(jg.Joint2.robax.rax_2\Dec:=0);
        jg.Joint2.robax.rax_3:=Round(jg.Joint2.robax.rax_3\Dec:=0);
        jg.Joint2.robax.rax_4:=Round(jg.Joint2.robax.rax_4\Dec:=0);
        jg.Joint2.robax.rax_5:=Round(jg.Joint2.robax.rax_5\Dec:=0);
        jg.Joint2.robax.rax_6:=Round(jg.Joint2.robax.rax_6\Dec:=0);

        jg.JointG.extax.eax_a:=Round(jg.JointG.extax.eax_a\Dec:=0);
        jg.JointG.extax.eax_f:=Round(jg.JointG.extax.eax_f\Dec:=0);
        jg.JointG.extax.eax_b:=Round(jg.JointG.extax.eax_b\Dec:=0);
        jg.JointG.extax.eax_c:=Round(jg.JointG.extax.eax_c\Dec:=0);
        jg.JointG.extax.eax_d:=Round(jg.JointG.extax.eax_d\Dec:=0);
    ENDPROC

    PROC rMoveToTcp()
        VAR num nTempMmps;
        VAR jointgroup jTempReadyGroup;
        stCommand:="MoveToTcp";
        WaitUntil stReact=["MoveToTcp_Ok","MoveToTcp_Ok","MoveToTcp_Ok"];
        stCommand:="";
        WaitUntil stReact=["Ready","Ready","Ready"];
        RETURN ;
    ERROR
    ENDPROC

    PROC rDefineWobjWeldLineTcp(pos posStart,pos posEnd)
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
        nOffsetLengthBuffer:=0;
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

    PROC rWireCut_Select()
        IF bMoveToWireCutHome=TRUE THEN
            if nMode=1 THEN
                rWirecutShot 1;
            ELSEIF nmode=2 THEN
                rWirecutShot 2;
            ELSE
                rWirecutShot 3;
            ENDIF
        ELSE
            IF (bEnableStartEndPointCorr=TRUE) THEN
                IF nMaxPartHeightNearArray{3}>800 OR nMaxPartHeightNearArray{2}>800 THEN
                    if nMode=1 THEN
                        rWirecutMove 1;
                    ELSEIF nmode=2 THEN
                        rWirecutMove 2;
                    ELSE
                        rWirecutMove 3;
                    ENDIF
                ELSE
                    if nMode=1 THEN
                        rWirecutShot 1;
                    ELSEIF nmode=2 THEN
                        rWirecutShot 2;
                    ELSE
                        rWirecutShot 3;
                    ENDIF
                ENDIF
            ELSE
                IF nMaxPartHeightNearArray{1}>800 OR nMaxPartHeightNearArray{2}>800 THEN
                    if nMode=1 THEN
                        rWirecutMove 1;
                    ELSEIF nmode=2 THEN
                        rWirecutMove 2;
                    ELSE
                        rWirecutMove 3;
                    ENDIF
                ELSE
                    if nMode=1 THEN
                        rWirecutShot 1;
                    ELSEIF nmode=2 THEN
                        rWirecutShot 2;
                    ELSE
                        rWirecutShot 3;
                    ENDIF
                ENDIF
            ENDIF
        ENDIF

    ENDPROC

    PROC rReTurnToWireCut()
        VAR jointgroup jgTemp;

        jgTemp:=MergeJgWith();
        jgTemp.Joint1.robax:=[39.7077,23.0399,30.4536,-87.5281,29.1211,122.951];
        jgTemp.Joint2.robax:=[39.5269,22.7659,30.4413,-87.1375,29.0323,122.34];
        MoveJgJ MergeJgWith(\Rob1:=jgTemp.Joint1\Rob2:=jgTemp.Joint2),v50,fine;
        WaitRob\InPos;
        WaitRob\ZeroSpeed;

    ENDPROC

    PROC rManualOriginCheck()
        VAR jointgroup jgTemp;

        rGantry_C_Home;
        IF sdo_Rob_1_MoveHome=0 OR sdo_Rob_2_MoveHome=0 THEN
            rMoveToRobotHome;
        ENDIF
        jgTemp:=MergeJgWith();
        jgTemp.JointG.extax:=ManualOrigin_Pos.JointG.extax;
        jgTemp.JointG.extax.eax_c:=0;
        MoveJgJ MergeJgWith(\Gantry:=jgTemp.JointG),[300,300,400,25],fine;
        WaitRob\InPos;
        WaitRob\ZeroSpeed;
        MoveJgJ MergeJgWith(\Gantry:=ManualOrigin_Pos.JointG),[300,300,100,25],fine;
        WaitRob\InPos;
        WaitRob\ZeroSpeed;
        
    ENDPROC


ENDMODULE
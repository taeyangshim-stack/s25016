MODULE Rob2_MainModule
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

    RECORD monRobs
        extjoint monExt;
        robjoint monJoint1;
        robjoint monJoint2;
        pose monPose1;
        pose monPose2;
    ENDRECORD

    RECORD torchmotion
        num No;
        num LengthOffset;
        num BreadthOffset;
        num HeightOffset;
        num WorkingAngle;
        num TravelAngle;
        num WeldingSpeed;
        num Schedule;
        num Voltage;
        num FeedingSpeed;
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

    RECORD corrorder
        num X_Init;
        num X_StartOffset;
        num X_Depth;
        num X_ReturnLength;
        num Y_StartOffset;
        num Y_Depth;
        num Y_ReturnLength;
        num Z_StartOffset;
        num Z_Depth;
        num Z_ReturnLength;
        num RY_Torch;
        num Y_MoveCorrConnect;
        num Z_MoveCorrConnect;
    ENDRECORD

    RECORD edgedata
        pos EdgePos;
        num Height;
        num Breadth;
        num HoleSize;
        num Thickness;
        num AngleHeight;
        num AngleWidth;
    ENDRECORD

    PERS tasks taskGroup12{2};
    PERS tasks taskGroup13{2};
    PERS tasks taskGroup23{2};
    PERS tasks taskGroup123{3};

    ! Sync Data
    TASK VAR syncident SynchronizeJGJon{9999};
    TASK VAR syncident SynchronizePGJon{9999};
    TASK VAR syncident SynchronizePGLon{9999};
    TASK VAR syncident SynchronizeJGJoff{9999};
    TASK VAR syncident SynchronizePGJoff{9999};
    TASK VAR syncident SynchronizePGLoff{9999};
    TASK VAR syncident Wait{100};

    PERS string stCommand;
    PERS string stReact{3};
    PERS num idSync;
    PERS speeddata vSync;
    PERS zonedata zSync;

    PERS wobjdata wobjWeldLine2;
    PERS wobjdata wobjRotCtr2;
    PERS wobjdata WobjFloor;

    PERS num nMotionTotalStep{2};
    PERS num nMotionStepCount{2};
    PERS num nMotionStartStepLast{2};
    PERS num nMotionEndStepLast{2};
    PERS num nRunningStep{2};
    PERS num nWeldSequence;

    PERS jointtarget jRob2;
    PERS robtarget pRob2;
    PERS bool bRqMoveG_PosHold;

    PERS robtarget pctWeldPosR1;
    PERS robtarget pctWeldPosR2;

    PERS targetdata Welds2{40};
    TASK PERS speeddata vWeld{40}:=[[10,200,200,200],[10,200,200,200],[10,200,200,200],[10,200,200,200],[10,200,200,200],[10,200,200,200],[10,200,200,200],[10,200,200,200],[10,200,200,200],[10,200,200,200],[200,200,200,200],[0.166667,200,200,200],[0.166667,200,200,200],[0.166667,200,200,200],[0.166667,200,200,200],[0.166667,200,200,200],[0.166667,200,200,200],[0.166667,200,200,200],[0.166667,200,200,200],[0.166667,200,200,200],[0.166667,200,200,200],[0.166667,200,200,200],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[10,200,200,200]];
    PERS seamdata smDefault_2{2};
    PERS seamdata seam_TRob2;

    PERS speeddata vTargetSpeed;
    PERS zonedata zTargetZone;

    TASK PERS welddata wdTrap:=[10,0,[5,0,38,240,0,400,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd1:=[10,0,[5,0,36.3,232,0,360,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd2:=[10,0,[5,0,36.3,232,0,360,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd3:=[10,0,[5,0,36.3,232,0,360,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd4:=[10,0,[5,0,36.3,232,0,360,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd5:=[10,0,[5,0,36.3,232,0,360,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd6:=[10,0,[5,0,36.3,232,0,360,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd7:=[10,0,[5,0,36.3,232,0,360,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd8:=[10,0,[5,0,36.3,232,0,360,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd9:=[10,0,[5,0,36.3,232,0,360,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd10:=[10,0,[5,0,36.3,232,0,360,0,0,0],[0,0,0,0,0,0,0,0,0]];

    !!! weave data !!!
    TASK PERS weavedata weaveTrap:=[1,2,3,3,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave1:=[1,2,2,1.5,0,1,0,1,0,0,0,0,0,0,0];
    TASK PERS weavedata weave2:=[1,2,2,1.5,0,1,0,1,0,0,0,0,0,0,0];
    TASK PERS weavedata weave3:=[1,2,2,1.5,0,1,0,1,0,0,0,0,0,0,0];
    TASK PERS weavedata weave4:=[1,2,2,1.5,0,1,0,1,0,0,0,0,0,0,0];
    TASK PERS weavedata weave5:=[1,2,2,1.5,0,1,0,1,0,0,0,0,0,0,0];
    TASK PERS weavedata weave6:=[1,2,2,1.5,0,1,0,1,0,0,0,0,0,0,0];
    TASK PERS weavedata weave7:=[1,2,2,1.5,0,1,0,1,0,0,0,0,0,0,0];
    TASK PERS weavedata weave8:=[1,2,2,1.5,0,1,0,1,0,0,0,0,0,0,0];
    TASK PERS weavedata weave9:=[1,2,2,1.5,0,1,0,1,0,0,0,0,0,0,0];
    TASK PERS weavedata weave10:=[1,2,2,1.5,0,1,0,1,0,0,0,0,0,0,0];

    !!! Track Data !!!
    TASK PERS trackdata trackTrap:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track0:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track1:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track2:=[0,FALSE,10,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track3:=[0,FALSE,10,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track4:=[0,FALSE,10,[0,15,30,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track5:=[0,FALSE,20,[0,15,30,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track6:=[0,FALSE,0,[0,10,20,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track7:=[0,FALSE,20,[0,15,30,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track8:=[0,FALSE,10,[0,15,30,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track9:=[0,FALSE,10,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track10:=[0,FALSE,10,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];


    TASK VAR intnum inumMoveG_PosHold;

    PERS bool bGanTry_Last_pos;
    PERS bool bTouch_last_R1_Comp;
    PERS bool bTouch_last_R2_Comp;
    PERS bool bGanTry_First_pos;
    PERS bool bTouch_First_R1_Comp;
    PERS bool bTouch_First_R2_Comp;
    PERS num nMacro010{2}:=[4,4];
    PERS num nMacro001{2}:=[4,4];
    PERS bool bEndSearchComplete;
    PERS edgedata edgeStart{2}:=[[[20002.2,2781.66,4.15085],50,50,0,12,0,0],[[19990.2,2781.62,4.13825],50,50,0,12,0,0]];
    PERS edgedata edgeEnd{2}:=[[[20010.1,119.623,2.69116],50,50,0,12,0,0],[[19998.1,119.588,2.67856],50,50,0,12,0,0]];
    PERS corrorder corrStart{10};
    PERS corrorder corrEnd{10};
    PERS pos pCorredStartPos{2};
    PERS pos pCorredEndPos{2};

    PERS num nCorrX_Store_Start{2};
    PERS num nCorrY_Store_Start{2};
    PERS num nCorrZ_Store_Start{2};
    PERS num nCorrX_Store_End{2};
    PERS num nCorrY_Store_End{2};
    PERS num nCorrZ_Store_End{2};

    TASK PERS num nCorrFailOffs_Y:=0;
    TASK PERS num nCorrFailOffs_Z:=0;
    CONST bool bEnd:=FALSE;
    CONST bool bStart:=TRUE;


    PERS num nWeldLineLength:=400;
    ! 264.966;
    PERS num nWeldLineLength_R2;
    ! 264.966;
    PERS robtarget pSearchStart2:=[[0,-27.0001,15.1929],[0.241845,-0.664463,-0.664463,-0.241845],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS robtarget pSearchEnd2:=[[0,25,15.1929],[0.241845,-0.664463,-0.664463,-0.241845],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    TASK PERS string TouchErrorDirSub:="Start_Y";
    TASK PERS string TouchErrorDirMain:="Ready";
    PERS num nTouchRetryCount{2};
    PERS num n_Angle;
    TASK PERS num RetryDepthData{3}:=[10,10,10];
    PERS robtarget pWeldPosR2{40}:=[[[-3,7,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.31,9E+09,9E+09]],[[-3,7,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.31,9E+09,9E+09]],[[-3,-4.5,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.31,9E+09,9E+09]],[[15,-1,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.34,9E+09,9E+09]],[[200,-1,1],[0.270598,-0.653282,-0.653282,-0.270598],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.72,9E+09,9E+09]],[[1390,-1.00592,0.996463],[0.270597,-0.653283,-0.653281,-0.270597],[0,0,-1,1],[-8707.81,-8707.8,1477.15,1033.13,9E+09,9E+09]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[1390,-1,1],[0.270598,-0.653282,-0.653282,-0.270598],[-1,0,0,1],[-8707.8,-8707.8,1477.15,1033.12,9E+09,9E+09]]];
    PERS num nRobCorrSpaceHeight;
    PERS pos pCorredPosBuffer2:=[-0.0404066,-6.76043,15.2342];
    PERS bool bWireTouch2;
    CONST robtarget pNull:=[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

    PERS bool bRobSwap;
    PERS jointtarget jCorrT_ROB2_Start;
    PERS jointtarget jCorrT_ROB2_End;
    PERS robtarget pCorrT_ROB2_Start;
    PERS robtarget pCorrT_ROB2_End;

    !!!!jWireCut
    TASK PERS num nWireCutSpeed:=600;
    PERS tooldata tWeld2:=[TRUE,[[319.938,-6.311,330],[0.92587,0.003729,0.377818,-0.009128]],[3.1,[-71.4,3.8,173.2],[1,0,0,0],0.055,0.049,0.005]];
    PERS tooldata tWeld2copy:=[TRUE,[[320.377,0,330.247],[0.92587,0,0.37784,0]],[3.1,[-71.4,3.8,173.2],[1,0,0,0],0.055,0.049,0.005]];
    PERS bool bEnableWeldSkip;
    PERS num nTrapCheck_2:=0;
    PERS seamdata smDefault_2Trap;
    VAR num tool_rx_end{3};
    VAR num tool_rx_start{3};
    VAR num tool_rx_delta{3};
    VAR robtarget pcalcWeldpos;
    VAR robtarget pMoveWeldpos;
    VAR robtarget pSaveWeldpos;
    !Error
    TASK VAR intnum iErrorDuringEntry;
    PERS num nEntryRetryCount{2};
    TASK VAR intnum iMoveHome_RBT2;
    PERS bool bTouchWorkCount2{6}:=[FALSE,FALSE,FALSE,FALSE,FALSE,FALSE];
    PERS monRobs MonitorweldErrorpostion;
    PERS monRobs MonitorPosition;
    PERS pos posStart;
    PERS pos posEnd;
    PERS bool bGantryInTrap{2};
    TASK VAR intnum intOutGantryHold;
    PERS edgedata edgestartBuffer2;
    PERS edgedata edgeEndBuffer2;
    PERS num nStartThick;
    PERS num nEndThick;
    PERS bool bBreakPoint{2};
    PERS num nBreakPoint{2};
    PERS bool btouchTimeOut{2};
    PERS bool bWeldOutputDisable;
    TASK PERS bool bInstalldir:=FALSE;
    PERS num nMoveid;
    PERS bool bExitCycle:=FALSE;
    PERS bool bWireCutSync;
    PERS num nInchingTime;
    task VAR clock clockWeldTime;
    PERS num nclockWeldTime{2};
    PERS bool bWirecut{3};
    PERS torchmotion macroEndBuffer2{10};
    PERS torchmotion macroStartBuffer2{10};
    PERS bool bArc_On{2};
    PERS num nMode:=3;
    PERS num nSprayTime;
    PERS bool bNozzleCleanCut;
    PERS num nR_Angle;
    PERS wobjdata WobjNozzel_2;
    PERS num nSearchBuffer_X_Start{2};
    PERS num nSearchBuffer_Y_Start{2};
    PERS num nSearchBuffer_Z_Start{2};
    PERS num nSearchBuffer_X_End{2};
    PERS num nSearchBuffer_Y_End{2};
    PERS num nSearchBuffer_Z_End{2};
    TASK VAR intnum iArcError2;
    TASK PERS num nArcError:=0;
    TASK PERS speeddata vReltool:=[200,200,200,200];
    TASK PERS robtarget pReltool:=[[49.4573,-11.2138,-0.0139096],[0.241842,-0.664464,-0.664463,-0.241846],[-1,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    TASK VAR intnum innumTouchErrorWhilMoving;
    PERS num nTouchWhileMovingCount_R2;
    TASK PERS jointtarget jWireCut12:=[[35.9896,26.8044,24.5532,-88.2754,28.2338,120.227],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    pers bool bTouchOnSameSpotError_R1;
    pers bool bTouchOnSameSpotError_R2;
    PERS num nSameSpot_StartX_R2:=0;
    PERS num nSameSpot_StartY_R2:=0;
    PERS num nSameSpot_StartZ_R2:=0;
    PERS num nSameSpot_EndX_R2:=0;
    PERS num nSameSpot_EndY_R2:=0;
    PERS num nSameSpot_EndZ_R2:=0;
    PERS bool bMoveToWireCutHome;
    !!!!!  TeachingWireCut  !!!!!!!!!!!!!
    PERS pos pCuttingInsideOffset_R2;
    PERS pos pCuttingEntryOffset_R2;

    TRAP trapMoveG_PosHold
        rTrapWeldMove;
    ENDTRAP

    TRAP trapErrorDuringEntry
        Set po34_EntryR2Error;
        IDelete iMoveHome_RBT2;
        IDelete iErrorDuringEntry;
        rErrorDuringEntry;
    ENDTRAP

    TRAP trapTouchErrorWhilMoving
        nTouchWhileMovingCount_R2:=nTouchWhileMovingCount_R2+1;
    ENDTRAP

    TRAP trapMoveHome_RBT2
        VAR robtarget pTemp;
        IDelete iMoveHome_RBT2;
        IDelete iErrorDuringEntry;
        Reset soLn2Touch;
        StopMove;
        ClearPath;
        StartMove;
        pTemp:=CRobT(\TaskName:="T_ROB2"\Tool:=tWeld2\WObj:=wobjWeldLine2);
        MoveL RelTool(pTemp,0,0,-10),vTargetSpeed,z0,tWeld2\WObj:=wobjWeldLine2;
        bWeldOutputDisable:=TRUE;

        stReact{2}:="Error_Arc_Touch";
        WaitSyncTask Wait{80},taskGroup123;
        WaitUntil stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
        WaitSyncTask Wait{81},taskGroup123;
        WaitUntil stCommand="Error_Arc_Touch";
        stReact{2}:="";
        WaitUntil stCommand="";
        WaitSyncTask Wait{82},taskGroup123;
        ExitCycle;
    ENDTRAP


    PROC main()
        IF bExitCycle=FALSE THEN
            bExitCycle:=TRUE;
            ExitCycle;
        ENDIF
        bExitCycle:=FALSE;
        rInit;
        WHILE TRUE DO
            if nArcError=1 THEN
                pReltool:=CRobT(\TaskName:="T_ROB2"\Tool:=tWeld2\WObj:=wobjWeldLine2);
                MoveL RelTool(pReltool,0,0,-10),vReltool,z0,tWeld2\WObj:=wobjWeldLine2;
                nArcError:=0;
                WaitTime 0.5;
            ENDIF
            WaitUntil stCommand<>"";
            TEST stCommand
            CASE "MoveJgJ":
                SyncMoveOn SynchronizeJGJon{nMoveid+2},taskGroup123;
                MoveAbsJ jRob2\ID:=nMoveid+3,vSync,zSync,tool:=tool0;
                SyncMoveOff SynchronizeJGJoff{nMoveid+4};
                stReact{2}:="Ack";
                WaitUntil stCommand="";
                stReact{2}:="Ready";
            CASE "MovePgJ":
                SyncMoveOn SynchronizePGJon{nMoveid+2},taskGroup123;
                MoveJ pRob2\ID:=nMoveid+3,vSync,zSync,tool:=tool0;
                SyncMoveOff SynchronizePGJoff{nMoveid+4};
                stReact{2}:="Ack";
                WaitUntil stCommand="";
                stReact{2}:="Ready";
            CASE "MovePgL":
                SyncMoveOn SynchronizePGLon{nMoveid+2},taskGroup123;
                MoveJ pRob2\ID:=nMoveid+3,vSync,zSync,tool:=tool0;
                SyncMoveOff SynchronizePGLoff{nMoveid+4};
                stReact{2}:="Ack";
                WaitUntil stCommand="";
                stReact{2}:="Ready";
            CASE "Weld":
                IF bEnableWeldSkip=TRUE THEN
                    SetDO soLn2InhibWeld,1;
                ELSE
                    SetDO soLn2InhibWeld,0;
                ENDIF
                rweld;
                nTrapCheck_2:=0;

            CASE "Weld1":
                ConfL\On;
                WaitUntil stReact{1}="WeldOk" OR stReact{1}="Error_Arc_Touch";
                IF stReact{1}="Error_Arc_Touch" THEN
                    stReact{2}:="Error_Arc_Touch";

                    WaitSyncTask Wait{80},taskGroup123;

                    WaitUntil stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
                    WaitSyncTask Wait{81},taskGroup123;

                    WaitUntil stCommand="Error_Arc_Touch";
                    stReact{1}:="";
                    WaitUntil stCommand="";
                    WaitSyncTask Wait{82},taskGroup123;
                    Reset po14_Motion_Working;
                    Set po15_Motion_Finish;
                    Stop;
                    ExitCycle;
                ENDIF
                stReact{2}:="WeldOk";
                WaitUntil stCommand="";
                stReact{2}:="Ready";
                nTrapCheck_2:=0;

            CASE "Weld2":
                IF bEnableWeldSkip=TRUE THEN
                    SetDO soLn2InhibWeld,1;
                ELSE
                    SetDO soLn2InhibWeld,0;
                ENDIF
                rWeldAlone2;
                nTrapCheck_2:=0;

            CASE "CorrSearchStartEnd":
                IF nMode=1 THEN
                    bTouch_first_R2_Comp:=TRUE;
                    bTouch_last_R2_Comp:=TRUE;
                    IDelete iMoveHome_RBT2;
                    CONNECT iMoveHome_RBT2 WITH trapMoveHome_RBT2;
                    ISignalDO intMoveHome_RBT2,1,iMoveHome_RBT2;
                    stReact{2}:="CorrSearchOK";
                    WaitUntil stCommand="";
                    stReact{2}:="Ready";
                    nCorrFailOffs_Y:=0;
                    nCorrFailOffs_Z:=0;
                    nCorrX_Store_Start{2}:=0;
                    nCorrY_Store_Start{2}:=0;
                    nCorrZ_Store_Start{2}:=0;
                    nCorrX_Store_End{2}:=0;
                    nCorrY_Store_End{2}:=0;
                    nCorrZ_Store_End{2}:=0;
                    IDelete iMoveHome_RBT2;
                ELSE
                    IF nEntryRetryCount{2}=0 THEN
                        nCorrFailOffs_Y:=0;
                        nCorrFailOffs_Z:=0;
                    ENDIF
                    IF nTouchRetryCount{1}=0 AND nTouchRetryCount{2}=0 AND bTouchOnSameSpotError_R1=FALSE AND bTouchOnSameSpotError_R2=FALSE THEN
                        bTouchWorkCount2:=[FALSE,FALSE,FALSE,FALSE,FALSE,FALSE];
                        nCorrX_Store_Start{2}:=0;
                        nCorrY_Store_Start{2}:=0;
                        nCorrZ_Store_Start{2}:=0;
                        nCorrX_Store_End{2}:=0;
                        nCorrY_Store_End{2}:=0;
                        nCorrZ_Store_End{2}:=0;
                    ENDIF
                    IDelete iMoveHome_RBT2;
                    CONNECT iMoveHome_RBT2 WITH trapMoveHome_RBT2;
                    ISignalDO intMoveHome_RBT2,1,iMoveHome_RBT2;

                    rCorrSearchStartEnd;

                    bTouchWorkCount2:=[FALSE,FALSE,FALSE,FALSE,FALSE,FALSE];
                    IDelete iMoveHome_RBT2;
                ENDIF


            CASE "WireCutR1_R2":
                rWireCut;
            CASE "WireCutR1":
                WaitUntil stCommand="";
                stReact{2}:="Ready";
            CASE "WireCutR2":
                rWireCut;
            CASE "WireCutShotR1_R2":
                rWireCutShot;
            CASE "WireCutShotR1":
                WaitUntil stCommand="";
                stReact{2}:="Ready";
            CASE "WireCutShotR2":
                rWireCutShot;

            CASE "WireCutMoveR1_R2":
                rWireCutMove;
            CASE "WireCutMoveR1":
                WaitUntil stCommand="";
                stReact{2}:="Ready";
            CASE "WireCutMoveR2":
                rWireCutMove;
            CASE "NozzleClean_R2":
                rNozzleClean;
                stReact{2}:="NozzleClean_R2_Ok";
                WaitUntil stCommand="";
                stReact{2}:="Ready";
            CASE "NozzleClean_R1":
                WaitUntil stCommand="";
                stReact{2}:="Ready";
            CASE "checkpos":
                rT_ROB2check;
                stReact{2}:="checkposok";
                WaitUntil stCommand="";
                stReact{2}:="Ready";
            CASE "LdsCheck":
                WaitUntil stCommand="";
                stReact{2}:="Ready";

            CASE "TeachingWirecut_R1":
                stReact{2}:="WorkComplete";
                WaitUntil stCommand="";
                stReact{2}:="Ready";
                WaitUntil stReact=["Ready","Ready","Ready"];

            CASE "TeachingWirecut_R2":
                rTeachingWireCut;
                stReact{2}:="WorkComplete";
                WaitUntil stCommand="";
                stReact{2}:="Ready";
                WaitUntil stReact=["Ready","Ready","Ready"];

            CASE "TeachingWirecutEntry_R1":
                stReact{2}:="WorkComplete";
                WaitUntil stCommand="";
                stReact{2}:="Ready";
                WaitUntil stReact=["Ready","Ready","Ready"];

            CASE "TeachingWirecutEntry_R2":
                rTeachingWireCutEntry;
                stReact{2}:="WorkComplete";
                WaitUntil stCommand="";
                stReact{2}:="Ready";
                WaitUntil stReact=["Ready","Ready","Ready"];

            CASE "MoveToTcp":
                rMoveToTcp;
                stReact{2}:="MoveToTcp_Ok";
                WaitUntil stCommand="";
                stReact{2}:="Ready";

            DEFAULT:
                stReact{2}:="Error";
                Stop;
            ENDTEST
        ENDWHILE

    ENDPROC

    PROC rMoveToTcp()
        MoveJ Welds2{1}.position,v50,fine,tWeld2\WObj:=wobjWeldLine2;
    ENDPROC

    PROC rInit()
        AccSet 30,30;

        stReact{2}:="";
        WaitUntil stCommand="";
        stReact{2}:="Ready";
        IDelete iArcError2;
        IDelete inumMoveG_PosHold;
        IDelete iMoveHome_RBT2;
        IDelete intOutGantryHold;
        Reset intReHoldGantry_2;
        Reset soLn2Touch;
        bGantryInTrap{2}:=FALSE;
        bArc_On{2}:=FALSE;
        RETURN ;
        MoveAbsJ [[0.0204923,-24.7246,-8.05237,0.0496605,-57.6256,1.6],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]]\NoEOffs,v1000,z50,tool0;
        MoveJ [[168.50,0.00,1167.50],[0.999973,0.000344359,-0.00351527,0.00652012],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],v1000,z50,tool0;
        MoveL [[50,0,0],[0.22002,0.689395,-0.638925,0.26096],[0,0,-1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],v1000,z50,tWeld2\WObj:=wobjWeldLine2;
    ENDPROC

    TRAP trapArcError2
        VAR robtarget pTemp;
        bArc_On{2}:=FALSE;
        TPWrite "TROB2_ArcError";

        IDelete iArcError2;
        ClkStop clockWeldTime;
        nclockWeldTime{2}:=ClkRead(clockWeldTime);

        StopMove;
        ClearPath;
        IF bRobSwap=FALSE THEN
            Set po37_ArcR2Error;
            MonitorweldErrorpostion.monPose1:=MonitorPosition.monPose1;
            MonitorweldErrorpostion.monPose2:=MonitorPosition.monPose2;
        ELSE
            Set po36_ArcR1Error;
            MonitorweldErrorpostion.monPose1:=MonitorPosition.monPose1;
            MonitorweldErrorpostion.monPose2:=MonitorPosition.monPose2;
        ENDIF
        !pTemp:=CRobT(\TaskName:="T_ROB2"\Tool:=tWeld2\WObj:=wobjWeldLine2);
        !MoveL RelTool(pTemp,0,0,-10),vTargetSpeed,z0,tWeld2\WObj:=wobjWeldLine2;
        nArcError:=1;
        StartMove;

        stReact{2}:="Error_Arc_Touch";
        WaitSyncTask Wait{80},taskGroup123;

        WaitUntil stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
        WaitSyncTask Wait{81},taskGroup123;

        WaitUntil stCommand="Error_Arc_Touch";
        stReact{2}:="";
        WaitUntil stCommand="";
        WaitSyncTask Wait{82},taskGroup123;
        Reset po14_Motion_Working;
        Set po15_Motion_Finish;
        ExitCycle;
    ENDTRAP

    PROC rWeld()

        VAR num nTempMmps;
        VAR num nTempVolt;
        VAR num nTempWFS;
        VAR num wdArray{40};
        VAR speeddata vHoldspeed;
        VAR num nHoldWeldVel;
        VAR num nHoldDist:=0;

        IDelete inumMoveG_PosHold;
        IDelete iArcError2;

        wd1:=[Welds2{1}.cpm/6,0,[5,0,Welds2{1}.voltage,Welds2{1}.wfs,0,Welds2{1}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd2:=[Welds2{2}.cpm/6,0,[5,0,Welds2{2}.voltage,Welds2{2}.wfs,0,Welds2{2}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd3:=[Welds2{3}.cpm/6,0,[5,0,Welds2{3}.voltage,Welds2{3}.wfs,0,Welds2{3}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd4:=[Welds2{4}.cpm/6,0,[5,0,Welds2{4}.voltage,Welds2{4}.wfs,0,Welds2{4}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd5:=[Welds2{5}.cpm/6,0,[5,0,Welds2{5}.voltage,Welds2{5}.wfs,0,Welds2{5}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd6:=[Welds2{6}.cpm/6,0,[5,0,Welds2{6}.voltage,Welds2{6}.wfs,0,Welds2{6}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd7:=[Welds2{7}.cpm/6,0,[5,0,Welds2{7}.voltage,Welds2{7}.wfs,0,Welds2{7}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd8:=[Welds2{8}.cpm/6,0,[5,0,Welds2{8}.voltage,Welds2{8}.wfs,0,Welds2{8}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd9:=[Welds2{9}.cpm/6,0,[5,0,Welds2{9}.voltage,Welds2{9}.wfs,0,Welds2{9}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd10:=[Welds2{10}.cpm/6,0,[5,0,Welds2{10}.voltage,Welds2{10}.wfs,0,Welds2{10}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];

        weave1:=[Welds2{1}.WeaveShape,Welds2{1}.WeaveType,Welds2{1}.WeaveLength,Welds2{1}.WeaveWidth,0,Welds2{1}.WeaveDwellLeft,0,Welds2{1}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave2:=[Welds2{2}.WeaveShape,Welds2{2}.WeaveType,Welds2{2}.WeaveLength,Welds2{2}.WeaveWidth,0,Welds2{2}.WeaveDwellLeft,0,Welds2{2}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave3:=[Welds2{3}.WeaveShape,Welds2{3}.WeaveType,Welds2{3}.WeaveLength,Welds2{3}.WeaveWidth,0,Welds2{3}.WeaveDwellLeft,0,Welds2{3}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave4:=[Welds2{4}.WeaveShape,Welds2{4}.WeaveType,Welds2{4}.WeaveLength,Welds2{4}.WeaveWidth,0,Welds2{4}.WeaveDwellLeft,0,Welds2{4}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave5:=[Welds2{5}.WeaveShape,Welds2{5}.WeaveType,Welds2{5}.WeaveLength,Welds2{5}.WeaveWidth,0,Welds2{5}.WeaveDwellLeft,0,Welds2{5}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave6:=[Welds2{6}.WeaveShape,Welds2{6}.WeaveType,Welds2{6}.WeaveLength,Welds2{6}.WeaveWidth,0,Welds2{6}.WeaveDwellLeft,0,Welds2{6}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave7:=[Welds2{7}.WeaveShape,Welds2{7}.WeaveType,Welds2{7}.WeaveLength,Welds2{7}.WeaveWidth,0,Welds2{7}.WeaveDwellLeft,0,Welds2{7}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave8:=[Welds2{8}.WeaveShape,Welds2{8}.WeaveType,Welds2{8}.WeaveLength,Welds2{8}.WeaveWidth,0,Welds2{8}.WeaveDwellLeft,0,Welds2{8}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave9:=[Welds2{9}.WeaveShape,Welds2{9}.WeaveType,Welds2{9}.WeaveLength,Welds2{9}.WeaveWidth,0,Welds2{9}.WeaveDwellLeft,0,Welds2{9}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave10:=[Welds2{10}.WeaveShape,Welds2{10}.WeaveType,Welds2{10}.WeaveLength,Welds2{10}.WeaveWidth,0,Welds2{10}.WeaveDwellLeft,0,Welds2{10}.WeaveDwellRight,0,0,0,0,0,0,0];

        track0:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track6:=[0,FALSE,Welds2{6}.MaxCorr,[0,Welds2{6}.TrackGainY,Welds2{6}.TrackGainZ,0,Welds2{6}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        vWeld{11}:=[200,200,200,200];
        FOR i FROM 1 TO nMotionStepCount{2} DO
            nTempMmps:=Welds2{i}.cpm/6;
            vWeld{i}:=[nTempMmps,200,200,200];
            IF nTempMmps<>0 vHoldspeed:=[nTempMmps,60,100,100];
        ENDFOR

        WaitRob\ZeroSpeed;
        WaitSyncTask Wait{20},taskGroup123;
        MoveL RelTool(Welds2{1}.position,0,0,-10),vWeld{11},zTargetZone,tWeld2\WObj:=wobjWeldLine2;
        CONNECT iArcError2 WITH trapArcError2;
        ISignalDO intReHoldGantry_2,1,iArcError2;

        WaitRob\ZeroSpeed;
        ConfL\Off;

        WaitRob\ZeroSpeed;
        WaitSyncTask Wait{21},taskGroup12;

        ClkReset clockWeldTime;
        ClkStart clockWeldTime;

        ArcLStart Welds2{1}.position,vWeld{1},seam_TRob2,wd1\weave:=weave1,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track0;
        ArcL Welds2{2}.position,vWeld{2},seam_TRob2,wd2,\Weave:=weave2,z0,tWeld2\WObj:=wobjWeldLine2\Track:=track0;
        ArcL Welds2{3}.position,vWeld{3},seam_TRob2,wd3,\Weave:=weave3,z0,tWeld2\WObj:=wobjWeldLine2\Track:=track0;
        ArcL Welds2{4}.position,vWeld{4},seam_TRob2,wd4,\Weave:=weave4,z0,tWeld2\WObj:=wobjWeldLine2\Track:=track0;
        SyncMoveOn wait{22},taskGroup123;
        ArcL offs(Welds2{5}.position,-0.3,0,0)\id:=50,vWeld{5},seam_TRob2,wd5,\Weave:=weave5,z0,tWeld2\WObj:=wobjWeldLine2\Track:=track0;
        ArcL offs(Welds2{5}.position,0,0,0)\id:=51,vWeld{5},seam_TRob2,wd5,\Weave:=weave5,z0,tWeld2\WObj:=wobjWeldLine2\Track:=track6;
        ArcL offs(Welds2{6}.position,-0.3,0,0)\id:=60,vWeld{6},seam_TRob2,wd6,\Weave:=weave6,z0,tWeld2\WObj:=wobjWeldLine2\Track:=track6;
        ArcL offs(Welds2{6}.position,0,0,0)\id:=61,vWeld{6},seam_TRob2,wd6,\Weave:=weave6,z0,tWeld2\WObj:=wobjWeldLine2\Track:=track0;
        SyncMoveoff wait{23};
        ArcL Welds2{7}.position,vWeld{7},seam_TRob2,wd7,\Weave:=weave7,z0,tWeld2\WObj:=wobjWeldLine2\Track:=track0;
        ArcL Welds2{8}.position,vWeld{8},seam_TRob2,wd8,\Weave:=weave8,z0,tWeld2\WObj:=wobjWeldLine2\Track:=track0;
        ArcL Welds2{9}.position,vWeld{9},seam_TRob2,wd9,\Weave:=weave9,z0,tWeld2\WObj:=wobjWeldLine2\Track:=track0;
        ArcLEnd Welds2{10}.position,vWeld{10},seam_TRob2,wd10,\Weave:=weave10,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track0;
        ClkStop clockWeldTime;
        nclockWeldTime{1}:=ClkRead(clockWeldTime);
        MoveL RelTool(Welds2{nMotionStepCount{2}}.position,0,0,-10),vWeld{11},fine,tWeld2\WObj:=wobjWeldLine2;
        ConfL\On;
        IDelete iArcError2;

        stReact{2}:="WeldOk";
        WaitUntil stCommand="";
        stReact{2}:="Ready";
    ERROR
        rArcError;
        !IF ERRNO=ERR_PATH_STOP THEN
            !rArcError;
        !ENDIF
    ENDPROC

    PROC rWeldAlone2()

        VAR num nTempMmps;
        VAR num nTempVolt;
        VAR num nTempWFS;
        VAR num wdArray{40};
        VAR speeddata vHoldspeed;
        VAR num nHoldWeldVel;
        VAR num nHoldDist:=0;

        IDelete inumMoveG_PosHold;
        IDelete iArcError2;
        wd1:=[Welds2{1}.cpm/6,0,[5,0,Welds2{1}.voltage,Welds2{1}.wfs,0,Welds2{1}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd2:=[Welds2{2}.cpm/6,0,[5,0,Welds2{2}.voltage,Welds2{2}.wfs,0,Welds2{2}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd3:=[Welds2{3}.cpm/6,0,[5,0,Welds2{3}.voltage,Welds2{3}.wfs,0,Welds2{3}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd4:=[Welds2{4}.cpm/6,0,[5,0,Welds2{4}.voltage,Welds2{4}.wfs,0,Welds2{4}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd5:=[Welds2{5}.cpm/6,0,[5,0,Welds2{5}.voltage,Welds2{5}.wfs,0,Welds2{5}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd6:=[Welds2{6}.cpm/6,0,[5,0,Welds2{6}.voltage,Welds2{6}.wfs,0,Welds2{6}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd7:=[Welds2{7}.cpm/6,0,[5,0,Welds2{7}.voltage,Welds2{7}.wfs,0,Welds2{7}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd8:=[Welds2{8}.cpm/6,0,[5,0,Welds2{8}.voltage,Welds2{8}.wfs,0,Welds2{8}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd9:=[Welds2{9}.cpm/6,0,[5,0,Welds2{9}.voltage,Welds2{9}.wfs,0,Welds2{9}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd10:=[Welds2{10}.cpm/6,0,[5,0,Welds2{10}.voltage,Welds2{10}.wfs,0,Welds2{10}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];

        weave1:=[Welds2{1}.WeaveShape,Welds2{1}.WeaveType,Welds2{1}.WeaveLength,Welds2{1}.WeaveWidth,0,Welds2{1}.WeaveDwellLeft,0,Welds2{1}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave2:=[Welds2{2}.WeaveShape,Welds2{2}.WeaveType,Welds2{2}.WeaveLength,Welds2{2}.WeaveWidth,0,Welds2{2}.WeaveDwellLeft,0,Welds2{2}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave3:=[Welds2{3}.WeaveShape,Welds2{3}.WeaveType,Welds2{3}.WeaveLength,Welds2{3}.WeaveWidth,0,Welds2{3}.WeaveDwellLeft,0,Welds2{3}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave4:=[Welds2{4}.WeaveShape,Welds2{4}.WeaveType,Welds2{4}.WeaveLength,Welds2{4}.WeaveWidth,0,Welds2{4}.WeaveDwellLeft,0,Welds2{4}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave5:=[Welds2{5}.WeaveShape,Welds2{5}.WeaveType,Welds2{5}.WeaveLength,Welds2{5}.WeaveWidth,0,Welds2{5}.WeaveDwellLeft,0,Welds2{5}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave6:=[Welds2{6}.WeaveShape,Welds2{6}.WeaveType,Welds2{6}.WeaveLength,Welds2{6}.WeaveWidth,0,Welds2{6}.WeaveDwellLeft,0,Welds2{6}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave7:=[Welds2{7}.WeaveShape,Welds2{7}.WeaveType,Welds2{7}.WeaveLength,Welds2{7}.WeaveWidth,0,Welds2{7}.WeaveDwellLeft,0,Welds2{7}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave8:=[Welds2{8}.WeaveShape,Welds2{8}.WeaveType,Welds2{8}.WeaveLength,Welds2{8}.WeaveWidth,0,Welds2{8}.WeaveDwellLeft,0,Welds2{8}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave9:=[Welds2{9}.WeaveShape,Welds2{9}.WeaveType,Welds2{9}.WeaveLength,Welds2{9}.WeaveWidth,0,Welds2{9}.WeaveDwellLeft,0,Welds2{9}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave10:=[Welds2{10}.WeaveShape,Welds2{10}.WeaveType,Welds2{10}.WeaveLength,Welds2{10}.WeaveWidth,0,Welds2{10}.WeaveDwellLeft,0,Welds2{10}.WeaveDwellRight,0,0,0,0,0,0,0];

        track0:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track1:=[0,FALSE,Welds2{1}.MaxCorr,[0,Welds2{1}.TrackGainY,Welds2{1}.TrackGainZ,0,Welds2{1}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track2:=[0,FALSE,Welds2{2}.MaxCorr,[0,Welds2{2}.TrackGainY,Welds2{2}.TrackGainZ,0,Welds2{2}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track3:=[0,FALSE,Welds2{3}.MaxCorr,[0,Welds2{3}.TrackGainY,Welds2{3}.TrackGainZ,0,Welds2{3}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track4:=[0,FALSE,Welds2{4}.MaxCorr,[0,Welds2{4}.TrackGainY,Welds2{4}.TrackGainZ,0,Welds2{4}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track5:=[0,FALSE,Welds2{5}.MaxCorr,[0,Welds2{5}.TrackGainY,Welds2{5}.TrackGainZ,0,Welds2{5}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track6:=[0,FALSE,Welds2{6}.MaxCorr,[0,Welds2{6}.TrackGainY,Welds2{6}.TrackGainZ,0,Welds2{6}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track7:=[0,FALSE,Welds2{7}.MaxCorr,[0,Welds2{7}.TrackGainY,Welds2{7}.TrackGainZ,0,Welds2{7}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track8:=[0,FALSE,Welds2{8}.MaxCorr,[0,Welds2{8}.TrackGainY,Welds2{8}.TrackGainZ,0,Welds2{8}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track9:=[0,FALSE,Welds2{9}.MaxCorr,[0,Welds2{9}.TrackGainY,Welds2{9}.TrackGainZ,0,Welds2{9}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track10:=[0,FALSE,Welds2{10}.MaxCorr,[0,Welds2{10}.TrackGainY,Welds2{10}.TrackGainZ,0,Welds2{10}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];

        FOR i FROM 1 TO nMotionStepCount{2} DO
            nTempMmps:=Welds2{i}.cpm/6;
            vWeld{i}:=[nTempMmps,200,200,200];
            IF nTempMmps<>0 vHoldspeed:=[nTempMmps,60,100,100];
        ENDFOR

        WaitRob\ZeroSpeed;
        WaitSyncTask Wait{20},taskGroup23;
        MoveL RelTool(Welds2{1}.position,0,0,-10),vTargetSpeed,zTargetZone,tWeld2\WObj:=wobjWeldLine2;
        CONNECT iArcError2 WITH trapArcError2;
        ISignalDO intReHoldGantry_2,1,iArcError2;
        WaitRob\ZeroSpeed;
        ConfL\Off;
        ClkReset clockWeldTime;
        ClkStart clockWeldTime;
        SyncMoveOn wait{22},taskGroup123;
        ArcLStart Welds2{1}.position\id:=10,vWeld{1},seam_TRob2,wd1\weave:=weave1,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track0;
        ArcL Welds2{2}.position\id:=20,vWeld{2},seam_TRob2,wd2,\Weave:=weave2,z0,tWeld2\WObj:=wobjWeldLine2\Track:=track0;
        ArcL Welds2{3}.position\id:=30,vWeld{3},seam_TRob2,wd3,\Weave:=weave3,z0,tWeld2\WObj:=wobjWeldLine2\Track:=track0;
        ArcL Welds2{4}.position\id:=40,vWeld{4},seam_TRob2,wd4,\Weave:=weave4,z0,tWeld2\WObj:=wobjWeldLine2\Track:=track0;
        ArcL offs(Welds2{5}.position,-0.3,0,0)\id:=50,vWeld{5},seam_TRob2,wd5,\Weave:=weave5,z0,tWeld2\WObj:=wobjWeldLine2\Track:=track0;
        ArcL offs(Welds2{5}.position,0,0,0)\id:=51,vWeld{5},seam_TRob2,wd5,\Weave:=weave5,z0,tWeld2\WObj:=wobjWeldLine2\Track:=track6;
        ArcL offs(Welds2{6}.position,-0.3,0,0)\id:=60,vWeld{6},seam_TRob2,wd6,\Weave:=weave6,z0,tWeld2\WObj:=wobjWeldLine2\Track:=track6;
        ArcL offs(Welds2{6}.position,0,0,0)\id:=61,vWeld{6},seam_TRob2,wd6,\Weave:=weave6,z0,tWeld2\WObj:=wobjWeldLine2\Track:=track0;
        ArcL Welds2{7}.position\id:=70,vWeld{7},seam_TRob2,wd7,\Weave:=weave7,z0,tWeld2\WObj:=wobjWeldLine2\Track:=track0;
        ArcL Welds2{8}.position\id:=80,vWeld{8},seam_TRob2,wd8,\Weave:=weave8,z0,tWeld2\WObj:=wobjWeldLine2\Track:=track0;
        ArcL Welds2{9}.position\id:=90,vWeld{9},seam_TRob2,wd9,\Weave:=weave9,z0,tWeld2\WObj:=wobjWeldLine2\Track:=track0;
        ArcLEnd Welds2{10}.position\id:=100,vWeld{10},seam_TRob2,wd10,\Weave:=weave10,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track0;
        SyncMoveoff wait{23};
        ClkStop clockWeldTime;
        nclockWeldTime{1}:=ClkRead(clockWeldTime);
        MoveL RelTool(Welds2{nMotionStepCount{2}}.position,0,0,-10),vTargetSpeed,fine,tWeld2\WObj:=wobjWeldLine2;
        ConfL\On;
        IDelete intOutGantryHold;
        IDelete iArcError2;

        stReact{2}:="WeldOk";
        WaitUntil stCommand="";
        stReact{2}:="Ready";
    ERROR
        IF ERRNO=ERR_PATH_STOP THEN
            StopMove;
            StorePath\KeepSync;
            WaitTime 1;
            RestoPath;
            StartMove;
        ENDIF
    ENDPROC

    PROC rWireCut()
        VAR jointtarget jTepmCut{10};
        VAR robtarget pTemp_WireCut;
        VAR speeddata vTempFast;
        VAR speeddata vTempSlow;

        vTempFast:=[nWireCutSpeed,100,nWireCutSpeed,100];
        vTempSlow:=[nWireCutSpeed/3,100,nWireCutSpeed/3,100];
        IF bWireCutSync=FALSE THEN
            reset do09_Wire_Cutter_Close;
            set do10_Wire_Cutter_Open;
        ENDIF
        PulseDO\PLength:=nInchingTime,soAwManFeedFwd2;
        jWireCut4.robax:=[90,90,-50,0,0,0];
        MoveAbsJ jWireCut4\NoEOffs,vTempFast,z100,tWeld2;
        MoveAbsJ jWireCut3\NoEOffs,vTempFast,z100,tWeld2;
        MoveAbsJ jWireCut2\NoEOffs,vTempFast,z100,tWeld2;
        MoveAbsJ jWireCut1\NoEOffs,vTempFast,z10,tWeld2;
        WaitRob\ZeroSpeed;
        WaitTime 0.3;
        pTemp_WireCut:=CalcRobT(jWireCut0,tWeld2\WObj:=wobjRotCtr2);
        IF bNozzleCleanCut=TRUE MoveL Offs(pTemp_WireCut,0,0,10),vTempSlow,z0,tWeld2\WObj:=wobjRotCtr2;
        IF bNozzleCleanCut=FALSE MoveL Offs(pTemp_WireCut,0,0,0),vTempSlow,z0,tWeld2\WObj:=wobjRotCtr2;
        MoveAbsJ jWireCut0\NoEOffs,vTempSlow,z0,tWeld2;
        IF bWireCutSync=TRUE WaitSyncTask Wait{90},taskGroup12;
        WaitRob\ZeroSpeed;
        WaitTime 0.5;
        IF bWireCutSync=FALSE Reset do10_Wire_Cutter_Open;
        IF bWireCutSync=FALSE PulseDO\PLength:=1,do09_Wire_Cutter_Close;
        WaitTime 0.5;
        IF bWireCutSync=FALSE PulseDO\PLength:=1,do10_Wire_Cutter_Open;
        WaitTime 1;
        MoveAbsJ jWireCut1\NoEOffs,vTempSlow,z100,tWeld2;
        WaitRob\ZeroSpeed;
        MoveAbsJ jWireCut2\NoEOffs,vTempFast,z100,tWeld2;
        MoveAbsJ jWireCut3\NoEOffs,vTempFast,z100,tWeld2;
        MoveAbsJ jWireCut4\NoEOffs,vTempFast,z0,tWeld2;
        WaitRob\ZeroSpeed;
        IF bWireCutSync=FALSE Reset do10_Wire_Cutter_Open;
        stReact{2}:="WireCutOk";
        WaitUntil stCommand="";
        stReact{2}:="Ready";
        WaitUntil stReact=["Ready","Ready","Ready"];
        RETURN ;
    ENDPROC

    PROC rTeachingWireCut()
        VAR robtarget pTemp_WireCut;
        VAR speeddata vTempFast;
        VAR speeddata vTempSlow;
        vTempFast:=[nWireCutSpeed,500,nWireCutSpeed,100];
        vTempSlow:=[max(Max(pCuttingInsideOffset_R2.x,pCuttingInsideOffset_R2.y),pCuttingInsideOffset_R2.z),500,100,100];
        IF vTempSlow.v_tcp<0.1 vTempSlow.v_tcp:=50;
        pTemp_WireCut:=CalcRobT(jWireCut0,tWeld2\WObj:=wobjRotCtr2);
        MoveL Offs(pTemp_WireCut,pCuttingInsideOffset_R2.x,pCuttingInsideOffset_R2.y,pCuttingInsideOffset_R2.z),vTempSlow,fine,tWeld2\WObj:=wobjRotCtr2;
        WaitRob\InPos;
        WaitRob\ZeroSpeed;
        jWireCut0:=CJointT();

        RETURN ;
    ENDPROC

    PROC rTeachingWireCutEntry()
        VAR robtarget pTemp_WireCut;
        VAR speeddata vTempFast;
        VAR speeddata vTempSlow;
        vTempFast:=[nWireCutSpeed,500,nWireCutSpeed,100];
        vTempSlow:=[nWireCutSpeed/3,500,nWireCutSpeed/3,100];

        pTemp_WireCut:=CalcRobT(jWireCut1,tWeld2\WObj:=wobjRotCtr2);
        MoveL Offs(pTemp_WireCut,pCuttingEntryOffset_R2.x,pCuttingEntryOffset_R2.y,pCuttingEntryOffset_R2.z),vTempSlow,fine,tWeld2\WObj:=wobjRotCtr2;
        WaitRob\InPos;
        WaitRob\ZeroSpeed;
        jWireCut1:=CJointT();

        RETURN ;
    ENDPROC

    PROC rWireCutMove()
        VAR jointtarget jTepmCut{10};
        VAR robtarget pTemp_WireCut;
        VAR speeddata vTempFast;
        VAR speeddata vTempSlow;
        vTempFast:=[nWireCutSpeed,100,nWireCutSpeed,100];
        vTempSlow:=[nWireCutSpeed/3,100,nWireCutSpeed/3,100];
        IF bWireCutSync=FALSE THEN
            reset do09_Wire_Cutter_Close;
            set do10_Wire_Cutter_Open;
        ENDIF
        PulseDO\PLength:=nInchingTime,soAwManFeedFwd2;
        !        WaitTime 2.25;
        MoveAbsJ jWireCut3\NoEOffs,vTempFast,z100,tWeld2;
        MoveAbsJ jWireCut2\NoEOffs,vTempFast,z100,tWeld2;
        MoveAbsJ jWireCut1\NoEOffs,vTempFast,z10,tWeld2;
        WaitRob\ZeroSpeed;
        WaitTime 0.3;
        pTemp_WireCut:=CalcRobT(jWireCut0,tWeld2\WObj:=wobjRotCtr2);
        IF bNozzleCleanCut=TRUE MoveL Offs(pTemp_WireCut,0,0,10),vTempSlow,z0,tWeld2\WObj:=wobjRotCtr2;
        IF bNozzleCleanCut=FALSE MoveL Offs(pTemp_WireCut,0,0,0),vTempSlow,z0,tWeld2\WObj:=wobjRotCtr2;
        IF bWireCutSync=TRUE WaitSyncTask Wait{90},taskGroup12;
        WaitRob\ZeroSpeed;
        WaitTime 0.5;
        IF bWireCutSync=FALSE Reset do10_Wire_Cutter_Open;
        IF bWireCutSync=FALSE PulseDO\PLength:=1,do09_Wire_Cutter_Close;
        WaitTime 0.5;
        IF bWireCutSync=FALSE PulseDO\PLength:=1,do10_Wire_Cutter_Open;
        WaitTime 1;
        MoveAbsJ jWireCut1\NoEOffs,vTempSlow,z100,tWeld2;
        WaitRob\ZeroSpeed;
        MoveAbsJ jWireCut2\NoEOffs,vTempFast,z100,tWeld2;
        WaitRob\ZeroSpeed;
        IF bWirecut=[FALSE,TRUE,FALSE] THEN
            MoveAbsJ jWireCut3\NoEOffs,vTempFast,z100,tWeld2;
            jWireCut4.robax:=[40,90,-90,0,0,0];
            MoveAbsJ jWireCut4\NoEOffs,vTempFast,fine,tWeld2;
        ENDIF
        IF bWireCutSync=FALSE Reset do10_Wire_Cutter_Open;
        WaitRob\InPos;
        WaitRob\ZeroSpeed;
        stReact{2}:="WireCutOk";
        WaitUntil stCommand="";
        stReact{2}:="Ready";
        WaitUntil stReact=["Ready","Ready","Ready"];
        RETURN ;
        MoveAbsJ jWireCut0\NoEOffs,vTempSlow,fine,tWeld2;
    ENDPROC

    PROC rWireCutShot()
        VAR jointtarget jTepmCut{10};
        VAR speeddata vTempFast;
        VAR speeddata vTempSlow;
        vTempFast:=[nWireCutSpeed,100,nWireCutSpeed,100];
        vTempSlow:=[nWireCutSpeed/3,100,nWireCutSpeed/3,100];
        IF bWireCutSync=FALSE THEN
            reset do09_Wire_Cutter_Close;
            set do10_Wire_Cutter_Open;
        ENDIF
        PulseDO\PLength:=nInchingTime,soAwManFeedFwd2;
        WaitTime nInchingTime;
        MoveAbsJ jWireCut1\NoEOffs,vTempFast,z10,tWeld2;
        WaitRob\ZeroSpeed;
        WaitTime 0.3;
        MoveAbsJ jWireCut0\NoEOffs,vTempSlow,z0,tWeld2;
        IF bWireCutSync=TRUE WaitSyncTask Wait{90},taskGroup12;
        WaitRob\ZeroSpeed;
        WaitTime 0.5;
        IF bWireCutSync=FALSE Reset do10_Wire_Cutter_Open;
        IF bWireCutSync=FALSE PulseDO\PLength:=1,do09_Wire_Cutter_Close;
        WaitTime 0.5;
        IF bWireCutSync=FALSE PulseDO\PLength:=1,do10_Wire_Cutter_Open;
        WaitTime 1;
        MoveAbsJ jWireCut1\NoEOffs,vTempSlow,z100,tWeld2;
        WaitRob\ZeroSpeed;
        MoveAbsJ jWireCut2\NoEOffs,vTempFast,z100,tWeld2;
        WaitRob\ZeroSpeed;
        IF bWireCutSync=FALSE Reset do10_Wire_Cutter_Open;
        stReact{2}:="WireCutOk";
        WaitUntil stCommand="";
        stReact{2}:="Ready";
        WaitUntil stReact=["Ready","Ready","Ready"];
        RETURN ;
    ENDPROC

    PROC rTrapWeldMove()
        VAR num i;
        VAR robtarget pWeldTemp;
        VAR robtarget pTemp_pos;
        VAR num nTempMmps;
        VAR speeddata vWeldTemp;
        IDelete inumMoveG_PosHold;
        StopMove;
        i:=nRunningStep{2};
        nTempMmps:=Welds2{i}.cpm/6;
        vWeldTemp:=[nTempMmps,200,200,200];
        pWeldTemp:=CRobT(\taskname:="T_ROB2"\Tool:=tWeld2\WObj:=wobjWeldLine2);
        StartMove;
        ConfL\Off;
        WHILE (so_MoveG_PosHold=1) DO
            nTrapCheck_2:=2;
            MoveL Offs(pWeldTemp,0,0,0),vWeldTemp,fine,tWeld2\WObj:=wobjWeldLine2;
            MoveL Offs(pWeldTemp,0,0,0),vWeldTemp,fine,tWeld2\WObj:=wobjWeldLine2;
        ENDWHILE
        ConfL\On;
    ENDPROC

    PROC rCorrSearchStartEnd()
        VAR num TempHeight;
        VAR num TempBreadth;
        VAR num Temp_X;
        VAR num Temp_Y;
        VAR num nHeightBuffer;
        VAR num n_X;
        VAR num n_Y;
        VAR num n_Z;
        VAR num n_Ret_X;
        VAR num n_Ret_Y;
        VAR num n_Ret_Z;

        VAR robtarget pTemp;
        VAR robtarget pCorrTemp_Start{2};
        VAR jointtarget jCorrTemp_Start{2};
        VAR robtarget pCorrTemp_End{2};
        VAR jointtarget jCorrTemp_End{2};

        RetryDepthData:=[10,10,10];

        IDelete iErrorDuringEntry;
        CONNECT iErrorDuringEntry WITH trapErrorDuringEntry;
        ISignalDO intTouch_2,1,iErrorDuringEntry;
        bInstalldir:=bRobSwap;
        IF bRobSwap=FALSE THEN
            edgestartBuffer2:=edgeStart{2};
            edgeEndBuffer2:=edgeEnd{2};
        ELSE
            edgestartBuffer2:=edgeStart{1};
            edgeEndBuffer2:=edgeEnd{1};
        ENDIF
        WaitRob\ZeroSpeed;
        IF nMode=1 THEN
            WaitSyncTask Wait{20},taskGroup13;
        ELSEIF nMode=2 THEN
            WaitSyncTask Wait{20},taskGroup23;
            bTouch_last_R1_Comp:=TRUE;
        ELSE
            WaitSyncTask Wait{20},taskGroup123;
        ENDIF

        IF (nMacro001{1}=0 AND nMacro001{2}=0) THEN
            WaitUntil bGanTry_Last_pos=TRUE AND bTouch_last_R1_Comp=TRUE;
        ELSE
            WaitUntil bGanTry_Last_pos=TRUE;
        ENDIF

        if edgeEndBuffer2.Breadth<7 edgeEndBuffer2.Breadth:=7;
        if edgeEndBuffer2.height<7 edgeEndBuffer2.height:=7;

        nCorrFailOffs_Z:=10*nEntryRetryCount{2};
        IF bRobSwap=TRUE nCorrFailOffs_Y:=(10*nEntryRetryCount{2});
        IF bRobSwap=FALSE nCorrFailOffs_Y:=(10*nEntryRetryCount{2});
        WHILE bTouch_last_R2_Comp=FALSE DO
            TEST nMacro001{2}
            CASE 0,1,2,3,4,5:
                IF edgeEndBuffer2.Height>edgeEndBuffer2.Breadth THEN
                    IF nMacro001{2}=0 OR nMacro001{2}=1 OR nMacro001{2}=2 OR nMacro001{2}=5 n_X:=-15+(nSameSpot_EndX_R2*(-1));
                    IF nMacro001{2}=1 n_X:=-50;
                    IF nMacro001{2}=4 n_X:=0;
                    n_Y:=corrEnd{nMacro001{2}+1}.Y_StartOffset+nEndThick+nCorrFailOffs_Y+nSameSpot_EndY_R2;
                    n_Y:=n_Y*(-1);
                    n_Ret_Y:=TouchLimit(corrEnd{nMacro001{2}+1}.Y_ReturnLength,edgeEndBuffer2.Breadth);
                    n_Ret_Y:=n_Ret_Y*(-1);
                    n_Ret_Z:=TouchLimit(corrEnd{nMacro001{2}+1}.Z_ReturnLength,edgeEndBuffer2.Height);
                    n_Z:=TouchLimit(corrEnd{nMacro001{2}+1}.Z_StartOffset,edgeEndBuffer2.Height)+nCorrFailOffs_Z+nSameSpot_EndZ_R2;

                    ! Touch Entry Location================================================================
                    IWatch iErrorDuringEntry;

                    rCheckWelder;

                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir\LIN;
                    Reset soLn2Touch;
                    IDelete iErrorDuringEntry;
                    nEntryRetryCount{2}:=0;
                    IF bTouchWorkCount2{3}=TRUE GOTO TouchComplete_End_Y;
                    WaitTime 0;
                    ! rCheckTouchAtStart;
                    !=====================================================================================
                    ! edge_Y
                    IF bTouchWorkCount2{1}=FALSE THEN
                        rCorrSearchWeldLineEdgeY n_X,n_Y,n_Z,(corrEnd{nMacro001{2}+1}.Y_Depth*(-1))+nCorrFailOffs_Y+(nEndThick*(-1)),n_Ret_Y,bEnd,bInstalldir,"End_Y";
                        bTouchWorkCount2{1}:=TRUE;
                        nTouchRetryCount{2}:=0;
                    ENDIF

                    ! edge_Z
                    IF bTouchWorkCount2{2}=FALSE THEN
                        ! Setting Conditions
                        n_Y:=n_Ret_Y;
                        n_Ret_Z:=TouchLimit(corrEnd{nMacro001{2}+1}.Z_ReturnLength,edgeEndBuffer2.Height);

                        rCorrSearchWeldLineEdgeZ n_X,n_Y,n_Z,corrEnd{nMacro001{2}+1}.Z_Depth+nCorrFailOffs_Z,n_Ret_Z,bEnd,bInstalldir,"End_Z";
                        bTouchWorkCount2{2}:=TRUE;
                        nTouchRetryCount{2}:=0;
                    ENDIF

                    ! Setting Conditions
                    n_Z:=n_Ret_Z;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;

                    IF nMacro001{2}=1 OR nMacro001{2}=4 GOTO TouchComplete_End_Y;
                    IF nMacro001{2}=2 OR nMacro001{2}=5 THEN
                        IF nMacro001{2}=5 n_Z:=edgeEndBuffer2.HoleSize+1;
                    ELSE
                        ! Setting Conditions
                        n_X:=corrEnd{nMacro001{2}+1}.X_StartOffset+(nSameSpot_EndX_R2*(-1));
                        rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;
                        ! Setting Conditions
                        n_Y:=5;
                        rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;

                    ENDIF

                    ! edge_X
                    IF bTouchWorkCount2{3}=FALSE THEN
                        rCorrSearchWeldLineEdgeX n_X,n_Y,n_Z,corrEnd{nMacro001{2}+1}.X_Depth,corrEnd{nMacro001{2}+1}.X_ReturnLength,bEnd,bInstalldir,"End_X";
                        bTouchWorkCount2{3}:=TRUE;
                        nTouchRetryCount{2}:=0;
                    ENDIF
                    ! Setting Conditions
                    n_X:=corrEnd{nMacro001{2}+1}.X_ReturnLength+nSameSpot_EndX_R2;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,corrEnd{nMacro001{2}+1}.RY_Torch,0,nHeightBuffer,bEnd,bInstalldir;
                    ! Labal
                    TouchComplete_End_Y:
                    ! Setting Conditions
                    n_Y:=n_Ret_Y+(corrEnd{nMacro001{2}+1}.Y_MoveCorrConnect*(-1));
                    n_Z:=n_Z+(corrEnd{nMacro001{2}+1}.Z_MoveCorrConnect);
                    rMoveCorrConnect n_X,n_Y,n_Z,0,corrEnd{nMacro001{2}+1}.RY_Torch+n_Angle,0,nHeightBuffer,bEnd,bInstalldir;

                ELSE

                    ! Setting Conditions
                    IF nMacro001{2}=0 OR nMacro001{2}=1 OR nMacro001{2}=2 OR nMacro001{2}=5 n_X:=-15+(nSameSpot_EndX_R2*(-1));
                    IF nMacro001{2}=1 n_X:=-50;
                    IF nMacro001{2}=4 n_X:=0;
                    n_Y:=TouchLimit(corrEnd{nMacro001{2}+1}.Y_StartOffset+nEndThick,edgeEndBuffer2.Breadth)+nCorrFailOffs_Y+nSameSpot_EndY_R2;
                    n_Y:=n_Y*(-1);
                    n_Ret_Y:=TouchLimit(corrEnd{nMacro001{2}+1}.Y_ReturnLength,edgeEndBuffer2.Breadth);
                    n_Ret_Y:=n_Ret_Y*(-1);
                    n_Ret_Z:=TouchLimit(corrEnd{nMacro001{2}+1}.Z_ReturnLength,edgeEndBuffer2.Height);
                    n_Z:=corrEnd{nMacro001{2}+1}.Z_StartOffset+nCorrFailOffs_Z+nSameSpot_EndZ_R2;
                    IWatch iErrorDuringEntry;

                    rCheckWelder;

                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir\LIN;
                    Reset soLn2Touch;
                    IDelete iErrorDuringEntry;
                    nEntryRetryCount{2}:=0;
                    IF bTouchWorkCount2{3}=TRUE GOTO TouchComplete_End_Z;
                    !    rCheckTouchAtStart;

                    ! edge_Z
                    IF bTouchWorkCount2{1}=FALSE THEN
                        rCorrSearchWeldLineEdgeZ n_X,n_Y,n_Z,corrEnd{nMacro001{2}+1}.Z_Depth+nCorrFailOffs_Z,n_Ret_Z,bEnd,bInstalldir,"End_Z";
                        bTouchWorkCount2{1}:=TRUE;
                        nTouchRetryCount{2}:=0;
                    ENDIF

                    ! edge_Y
                    IF bTouchWorkCount2{2}=FALSE THEN
                        ! Setting Conditions
                        n_Z:=n_Ret_Z;
                        rCorrSearchWeldLineEdgeY n_X,n_Y,n_Z,(corrEnd{nMacro001{2}+1}.Y_Depth*(-1))+nCorrFailOffs_Y+(nEndThick*(-1)),n_Ret_Y,bEnd,bInstalldir,"End_Y";
                        bTouchWorkCount2{2}:=TRUE;
                        nTouchRetryCount{2}:=0;
                    ENDIF

                    ! Setting Conditions
                    n_Y:=n_Ret_Y;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;

                    IF nMacro001{2}=1 OR nMacro001{2}=4 GOTO TouchComplete_End_Z;
                    IF nMacro001{2}=2 OR nMacro001{2}=5 THEN
                        IF nMacro001{2}=5 n_Z:=edgeEndBuffer2.HoleSize+1;
                    ELSE

                        ! Setting Conditions
                        n_X:=corrEnd{nMacro001{2}+1}.X_StartOffset+(nSameSpot_EndX_R2*(-1));
                        rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;
                        ! Setting Conditions
                        n_Y:=5;
                        rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;

                    ENDIF

                    ! edge_X
                    IF bTouchWorkCount2{3}=FALSE THEN
                        rCorrSearchWeldLineEdgeX n_X,n_Y,n_Z,corrEnd{nMacro001{2}+1}.X_Depth,corrEnd{nMacro001{2}+1}.X_ReturnLength,bEnd,bInstalldir,"End_X";
                        bTouchWorkCount2{3}:=TRUE;
                        nTouchRetryCount{2}:=0;
                    ENDIF

                    ! Setting Conditions
                    n_X:=corrEnd{nMacro001{2}+1}.X_ReturnLength+nSameSpot_EndX_R2;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,corrEnd{nMacro001{2}+1}.RY_Torch,0,nHeightBuffer,bEnd,bInstalldir;
                    ! Labal
                    TouchComplete_End_Z:
                    ! Setting Conditions
                    n_Y:=n_Ret_Y+(corrEnd{nMacro001{2}+1}.Y_MoveCorrConnect*(-1));
                    n_Z:=n_Z+(corrEnd{nMacro001{2}+1}.Z_MoveCorrConnect);
                    rMoveCorrConnect n_X,n_Y,n_Z,0,corrEnd{nMacro001{2}+1}.RY_Torch+n_Angle,0,nHeightBuffer,bEnd,bInstalldir;
                ENDIF

                IF edgeEndBuffer2.AngleWidth>0 THEN
                    rMoveCorrConnect n_X,n_Y-30+corrEnd{nMacro001{2}+1}.Y_MoveCorrConnect,n_Z+corrEnd{nMacro001{2}+1}.Z_MoveCorrConnect,0,corrEnd{nMacro001{2}+1}.RY_Torch+n_Angle,0,nHeightBuffer,bEnd,bInstalldir;
                ENDIF

                IF nMacro001{2}=3 OR nMacro001{2}=4 OR nMacro001{2}=8 THEN
                    !   IF bEndSearchComplete=FALSE pCorredSplitPos:=ConvertPosWeldLineToFloor(pSearchStart2,nWeldLineLength+nCorrX_Store_End,nCorrY_Store_End,nCorrZ_Store_End);
                ENDIF
            DEFAULT:
                Stop;
                ExitCycle;
            ENDTEST

            bTouch_last_R2_Comp:=TRUE;
            bTouch_First_R2_Comp:=FALSE;
            pCorrTemp_End{2}:=CRobT(\TaskName:="T_ROB2"\Tool:=tWeld2\WObj:=wobjWeldLine2);
            pCorrTemp_End{2}.trans:=[nWeldLineLength_R2+nCorrX_Store_End{2},nCorrY_Store_End{2},nCorrZ_Store_End{2}];
            jCorrTemp_End{2}:=CalcJointT(pCorrTemp_End{2},tWeld2\WObj:=wobjWeldLine2);
            pCorrT_ROB2_End:=CalcRobT(jCorrTemp_End{2},Tool:=tWeld2\WObj:=wobjRotCtr2);
        ENDWHILE
        reSet soLn2Touch;
        waittime 0.2;
        IDelete innumTouchErrorWhilMoving;
        IF nTouchWhileMovingCount_R2>0 THEN
            IWatch iErrorDuringEntry;

            Set soLn2Touch;
            nTouchWhileMovingCount_R2:=0;
        ELSE
            CONNECT innumTouchErrorWhilMoving WITH trapTouchErrorWhilMoving;
            ISignalDI siLn2Current,1,innumTouchErrorWhilMoving;
            Set soLn2Touch;
            nTouchWhileMovingCount_R2:=0;
        ENDIF
        IF nMode=2 bTouch_First_R1_Comp:=TRUE;
        IF (nMacro010{1}=0 AND nMacro010{2}=0) THEN
            WaitUntil bGanTry_First_pos=TRUE AND bTouch_First_R1_Comp=TRUE;

        ELSE
            WaitUntil bGanTry_First_pos=TRUE;
        ENDIF
        !!! Start correctioning from start edge !!!

        if edgeStartBuffer2.Breadth<7 edgeStartBuffer2.Breadth:=7;
        if edgeStartBuffer2.height<7 edgeStartBuffer2.height:=7;

        TEST nMacro010{2}
        CASE 0,1,2,3,4,5:
            IF edgestartBuffer2.Height>edgestartBuffer2.Breadth THEN

                ! Setting Conditions
                IF nMacro010{2}=0 OR nMacro010{2}=1 OR nMacro010{2}=2 OR nMacro010{2}=5 n_X:=-15+(nSameSpot_StartX_R2*(-1));
                IF nMacro010{2}=1 n_X:=-50;
                IF nMacro010{2}=4 n_X:=0;
                n_Y:=corrStart{nMacro010{2}+1}.Y_StartOffset+nStartThick+nCorrFailOffs_Y+nSameSpot_StartY_R2;
                n_Y:=n_Y*(-1);
                n_Ret_Y:=TouchLimit(corrStart{nMacro010{2}+1}.Y_ReturnLength,edgestartBuffer2.Breadth);
                n_Ret_Y:=n_Ret_Y*(-1);
                n_Z:=TouchLimit(corrStart{nMacro010{2}+1}.Z_StartOffset,edgestartBuffer2.Height)+nCorrFailOffs_Z+nSameSpot_StartZ_R2;
                n_Ret_Z:=TouchLimit(corrStart{nMacro010{2}+1}.Z_ReturnLength,edgestartBuffer2.Height);

                IF edgestartBuffer2.AngleWidth>0 THEN
                    rMoveCorrConnect n_X,n_Y-30+(corrStart{nMacro010{2}+1}.Y_MoveCorrConnect*(-1)),n_Z+corrStart{nMacro010{2}+1}.Z_MoveCorrConnect,0,corrStart{nMacro010{2}+1}.RY_Torch+n_Angle,0,nHeightBuffer,bStart,bInstalldir\LIN;
                ENDIF
                ! edge_Y
                rMoveCorrConnect n_X,n_Y+(corrStart{nMacro010{2}+1}.Y_MoveCorrConnect*(-1)),n_Z+corrStart{nMacro010{2}+1}.Z_MoveCorrConnect,0,corrStart{nMacro010{2}+1}.RY_Torch+n_Angle,0,nHeightBuffer,bStart,bInstalldir\LIN;
                Reset soLn2Touch;
                IDelete iErrorDuringEntry;
                nEntryRetryCount{2}:=0;
                IDelete innumTouchErrorWhilMoving;
                reSet soLn2Touch;
                IF nTouchWhileMovingCount_R2>=1 rTouchErrorWhilMovingHandling;
                WaitTime 0;

                IF bTouchWorkCount2{4}=FALSE THEN
                    rCorrSearchWeldLineEdgeY n_X,n_Y,n_Z,(corrStart{nMacro010{2}+1}.Y_Depth*(-1))+nCorrFailOffs_Y+(nStartThick*(-1)),n_Ret_Y,bStart,bInstalldir,"Start_Y";
                    bTouchWorkCount2{4}:=TRUE;
                    nTouchRetryCount{2}:=0;
                ENDIF

                ! edge_Z
                IF bTouchWorkCount2{5}=FALSE THEN
                    ! Setting Conditions
                    n_Y:=n_Ret_Y;
                    n_Ret_Z:=TouchLimit(corrStart{nMacro010{2}+1}.Z_ReturnLength,edgestartBuffer2.Height);
                    rCorrSearchWeldLineEdgeZ n_X,n_Y,n_Z,corrStart{nMacro010{2}+1}.Z_Depth+nCorrFailOffs_Z,n_Ret_Z,bStart,bInstalldir,"Start_Z";
                    bTouchWorkCount2{5}:=TRUE;
                    nTouchRetryCount{2}:=0;
                ENDIF

                ! Setting Conditions
                n_Z:=n_Ret_Z;
                rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;

                IF nMacro010{2}=1 OR nMacro010{2}=4 GOTO TouchComplete_Start_Y;
                IF nMacro010{2}=2 OR nMacro010{2}=5 THEN
                    IF nMacro010{2}=5 n_Z:=edgestartBuffer2.HoleSize+1;
                ELSE
                    !         IF bTouchWorkCount2{6}=FALSE THEN
                    ! Setting Conditions
                    n_X:=corrStart{nMacro010{2}+1}.X_StartOffset+(nSameSpot_StartX_R2*(-1));
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;
                    ! Setting Conditions
                    n_Y:=5;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;
                ENDIF
                !    ENDIF

                ! edge_X
                IF bTouchWorkCount2{6}=FALSE THEN
                    rCorrSearchWeldLineEdgeX n_X,n_Y,n_Z,corrStart{nMacro010{2}+1}.X_Depth,corrStart{nMacro010{2}+1}.X_ReturnLength,bStart,bInstalldir,"Start_X";
                    bTouchWorkCount2{6}:=TRUE;
                    nTouchRetryCount{2}:=0;
                ENDIF
                ! Setting Conditions
                n_X:=corrStart{nMacro010{2}+1}.X_ReturnLength+nSameSpot_StartX_R2;
                rMoveCorrConnect n_X,n_Y,n_Z,0,corrStart{nMacro010{2}+1}.RY_Torch,0,nHeightBuffer,bStart,bInstalldir;
                ! Labal
                TouchComplete_Start_Y:
            ELSE

                ! Setting Conditions
                IF nMacro010{2}=0 OR nMacro010{2}=1 OR nMacro010{2}=2 OR nMacro010{2}=5 n_X:=-15+(nSameSpot_StartX_R2*(-1));
                IF nMacro010{2}=1 n_X:=-50;
                IF nMacro010{2}=4 n_X:=0;
                n_Y:=TouchLimit(corrStart{nMacro010{2}+1}.Y_StartOffset+nStartThick,edgestartBuffer2.Breadth)+nCorrFailOffs_Y+nSameSpot_StartY_R2;
                n_Y:=n_Y*(-1);
                n_Ret_Y:=TouchLimit(corrStart{nMacro010{2}+1}.Y_ReturnLength,edgestartBuffer2.Breadth);
                n_Ret_Y:=n_Ret_Y*(-1);
                n_Ret_Z:=TouchLimit(corrStart{nMacro010{2}+1}.Z_ReturnLength,edgestartBuffer2.Height);
                n_Z:=corrStart{nMacro010{2}+1}.Z_StartOffset+nCorrFailOffs_Z+nSameSpot_StartZ_R2;

                IF edgeEndBuffer2.AngleWidth>0 THEN
                    rMoveCorrConnect n_X,n_Y-30+(corrStart{nMacro010{2}+1}.Y_MoveCorrConnect*(-1)),n_Z+corrStart{nMacro010{2}+1}.Z_MoveCorrConnect,0,corrStart{nMacro010{2}+1}.RY_Torch+n_Angle,0,nHeightBuffer,bStart,bInstalldir\LIN;
                ENDIF
                rMoveCorrConnect n_X,n_Y+(corrStart{nMacro010{2}+1}.Y_MoveCorrConnect*(-1)),n_Z+corrStart{nMacro010{2}+1}.Z_MoveCorrConnect,0,corrStart{nMacro010{2}+1}.RY_Torch+n_Angle,0,nHeightBuffer,bStart,bInstalldir\LIN;
                Reset soLn2Touch;
                IDelete iErrorDuringEntry;
                nEntryRetryCount{2}:=0;
                IDelete innumTouchErrorWhilMoving;
                reSet soLn2Touch;
                IF nTouchWhileMovingCount_R2>=1 rTouchErrorWhilMovingHandling;
                WaitTime 0;

                ! edge_Z
                IF bTouchWorkCount2{4}=FALSE THEN
                    rCorrSearchWeldLineEdgeZ n_X,n_Y,n_Z,corrStart{nMacro010{2}+1}.Z_Depth+nCorrFailOffs_Z,n_Ret_Z,bStart,bInstalldir,"Start_Z";
                    bTouchWorkCount2{4}:=TRUE;
                    nTouchRetryCount{2}:=0;
                ENDIF
                ! Setting Conditions


                ! edge_Y
                IF bTouchWorkCount2{5}=FALSE THEN
                    ! Setting Conditions
                    n_Z:=n_Ret_Z;
                    rCorrSearchWeldLineEdgeY n_X,n_Y,n_Z,(corrStart{nMacro010{2}+1}.Y_Depth*(-1))+nCorrFailOffs_Y+(nStartThick*(-1)),n_Ret_Y,bStart,bInstalldir,"Start_Y";
                    bTouchWorkCount2{5}:=TRUE;
                    nTouchRetryCount{2}:=0;
                ENDIF

                ! Setting Conditions
                n_Y:=n_Ret_Y;
                rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;

                IF nMacro010{2}=1 OR nMacro010{2}=4 GOTO TouchComplete_Start_Z;
                IF nMacro010{2}=2 OR nMacro010{2}=5 THEN
                    IF nMacro010{2}=5 n_Z:=edgestartBuffer2.HoleSize+1;
                ELSE
                    !    IF bTouchWorkCount2{6}=FALSE THEN
                    ! Setting Conditions
                    n_X:=corrStart{nMacro010{2}+1}.X_StartOffset+(nSameSpot_StartX_R2*(-1));
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;
                    ! Setting Conditions
                    n_Y:=5;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;
                ENDIF
                ! ENDIF

                ! edge_X
                IF bTouchWorkCount2{6}=FALSE THEN
                    rCorrSearchWeldLineEdgeX n_X,n_Y,n_Z,corrStart{nMacro010{2}+1}.X_Depth,corrStart{nMacro010{2}+1}.X_ReturnLength,bStart,bInstalldir,"Start_X";
                    bTouchWorkCount2{6}:=TRUE;
                    nTouchRetryCount{2}:=0;
                ENDIF
                ! Setting Conditions
                n_X:=corrStart{nMacro010{2}+1}.X_ReturnLength+nSameSpot_StartX_R2;
                rMoveCorrConnect n_X,n_Y,n_Z,0,corrStart{nMacro010{2}+1}.RY_Torch,0,nHeightBuffer,bStart,bInstalldir;

                ! Labal
                TouchComplete_Start_Z:
            ENDIF

        DEFAULT:
            Stop;
            ExitCycle;
        ENDTEST

        pTemp:=CRobT(\TaskName:="T_ROB2"\Tool:=tWeld2\WObj:=wobjWeldLine2);
        WaitRob\ZeroSpeed;
        MoveL RelTool(pTemp,0,0,-15),vTargetSpeed,zTargetZone,tWeld2\WObj:=wobjWeldLine2;

        bTouch_First_R2_Comp:=TRUE;
        bTouch_last_R2_Comp:=TRUE;

        pCorrTemp_Start{2}:=CRobT(\TaskName:="T_ROB2"\Tool:=tWeld2\WObj:=wobjWeldLine2);
        pCorrTemp_Start{2}.trans:=[nCorrX_Store_Start{2},nCorrY_Store_Start{2},nCorrZ_Store_Start{2}];
        jCorrTemp_Start{2}:=CalcJointT(pCorrTemp_Start{2},tWeld2\WObj:=wobjWeldLine2);
        pCorrT_ROB2_Start:=CalcRobT(jCorrTemp_Start{2},Tool:=tWeld2\WObj:=wobjRotCtr2);
        nSearchBuffer_X_Start{2}:=nCorrX_Store_Start{2};
        nSearchBuffer_Y_Start{2}:=nCorrY_Store_Start{2};
        nSearchBuffer_Z_Start{2}:=nCorrZ_Store_Start{2};
        nSearchBuffer_X_End{2}:=nCorrX_Store_End{2};
        nSearchBuffer_Y_End{2}:=nCorrY_Store_End{2};
        nSearchBuffer_Z_End{2}:=nCorrZ_Store_End{2};
        WaitTime 0.2;
        stReact{2}:="CorrSearchOK";
        WaitUntil stCommand="";
        stReact{2}:="Ready";
        nCorrFailOffs_Y:=0;
        nCorrFailOffs_Z:=0;
        nCorrX_Store_Start{2}:=0;
        nCorrY_Store_Start{2}:=0;
        nCorrZ_Store_Start{2}:=0;
        nCorrX_Store_End{2}:=0;
        nCorrY_Store_End{2}:=0;
        nCorrZ_Store_End{2}:=0;
    ENDPROC

    PROC rMoveCorrConnect(num X,num Y,num Z,num Rx,num Ry,num Rz,num EAX_D,bool isStartPos,bool CCW,\switch LIN)
        VAR robtarget pTempConnect;
        VAR num nCorrX_Store;
        VAR num nCorrY_Store;
        VAR num nCorrZ_Store;

        IF (isStartPos=bStart) THEN
            nCorrX_Store:=nCorrX_Store_Start{2};
            nCorrY_Store:=nCorrY_Store_Start{2};
            nCorrZ_Store:=nCorrZ_Store_Start{2};
        ELSE
            nCorrX_Store:=nCorrX_Store_End{2};
            nCorrY_Store:=nCorrY_Store_End{2};
            nCorrZ_Store:=nCorrZ_Store_End{2};
        ENDIF


        pTempConnect:=pNull;
        pTempConnect.robconf:=[0,0,0,1];

        IF isStartPos=bStart THEN
            !        pTempConnect:=ConvertTcpToGantryCoord(pWeldPosR2{2}.position);
            IF CCW=FALSE THEN
                pTempConnect.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
                pTempConnect.rot:=[0.5,-0.5,-0.5,-0.5];
                pTempConnect:=RelTool(pTempConnect,0,0,0\Rx:=macroStartBuffer2{1}.TravelAngle\Ry:=-1*macroStartBuffer2{1}.WorkingAngle+nBreakPoint{2});
            ELSE
                pTempConnect.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y*(-1)),nCorrZ_Store+(Z)];
                pTempConnect.rot:=[0.5,0.5,-0.5,0.5];
                pTempConnect:=RelTool(pTempConnect,0,0,0\Rx:=-1*macroStartBuffer2{1}.TravelAngle\Ry:=-1*macroStartBuffer2{1}.WorkingAngle+nBreakPoint{2});
            ENDIF
        ELSEIF isStartPos=bEnd THEN
            !        pTempConnect:=ConvertTcpToGantryCoord(pWeldPosR2{nMotionStepCount}.position);
            IF CCW=FALSE THEN
                pTempConnect.trans:=[nWeldLineLength_R2+nCorrX_Store+(X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
                pTempConnect.rot:=[0.5,-0.5,-0.5,-0.5];
                pTempConnect:=RelTool(pTempConnect,0,0,0\Rx:=macroEndBuffer2{nMotionEndStepLast{2}}.TravelAngle\Ry:=-1*macroEndBuffer2{nMotionEndStepLast{2}}.WorkingAngle+nBreakPoint{2});
            ELSE
                pTempConnect.trans:=[nWeldLineLength_R2+nCorrX_Store+(X),nCorrY_Store+(Y*(-1)),nCorrZ_Store+(Z)];
                pTempConnect.rot:=[0.5,0.5,-0.5,0.5];
                pTempConnect:=RelTool(pTempConnect,0,0,0\Rx:=-1*macroEndBuffer2{nMotionEndStepLast{2}}.TravelAngle\Ry:=-1*macroEndBuffer2{nMotionEndStepLast{2}}.WorkingAngle+nBreakPoint{2});
            ENDIF
        ENDIF

        IF Present(LIN)=FALSE THEN
            MoveJ pTempConnect,v300,fine,tWeld2\WObj:=wobjWeldLine2;
        ELSE
            MoveL pTempConnect,v300,fine,tWeld2\WObj:=wobjWeldLine2;
        ENDIF

        RETURN ;
    ENDPROC

    PROC rCorrSearchWeldLineEdgeX(num X,num Y,num Z,num Depth,num RetX,bool isStartPos,bool CCW,string dirErrorCheck)
        VAR num nCorrX_Store;
        VAR num nCorrY_Store;
        VAR num nCorrZ_Store;
        VAR robtarget pComparison;
        VAR num nComparison;
        WaitUntil bRobSwap=CCW;
        IF (isStartPos=bStart) THEN
            nCorrX_Store:=nCorrX_Store_Start{2};
            nCorrY_Store:=nCorrY_Store_Start{2};
            nCorrZ_Store:=nCorrZ_Store_Start{2};
        ELSE
            nCorrX_Store:=nCorrX_Store_End{2};
            nCorrY_Store:=nCorrY_Store_End{2};
            nCorrZ_Store:=nCorrZ_Store_End{2};
        ENDIF

        TouchErrorDirSub:=dirErrorCheck;
        IF TouchErrorDirMain=dirErrorCheck AND nTouchRetryCount{2}>0 THEN
            IF (isStartPos=bEnd AND (nMacro001{1}=2 OR nMacro001{1}=5)) OR (isStartPos=bStart AND (nMacro010{1}=2 OR nMacro010{1}=5)) THEN
                Depth:=Depth+((RetryDepthData{1}*(-1))*nTouchRetryCount{2});
            ELSE
                Depth:=Depth+(RetryDepthData{1}*nTouchRetryCount{2});
            ENDIF
        ENDIF
        !!! Search weld X edge !!!
        WaitUntil bRobSwap=CCW;
        IF (isStartPos=bStart) THEN
            !        pSearchStart2:=ConvertTcpToGantryCoord(pWeldPosR2{1}.position);
            pSearchStart2.rot:=Welds2{1}.position.rot;
            IF (CCW=FALSE) pSearchStart2.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart2.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y*(-1)),nCorrZ_Store+(Z)];
        ELSEIF (isStartPos=bEnd) THEN
            !        pSearchStart2:=ConvertTcpToGantryCoord(pWeldPosR2{nMotionStepCount}.position);
            !  pSearchStart2.rot:=pWeldPosR2{nMotionStepCount{2}}.rot;
            pSearchStart2.rot:=Welds2{nMotionStepCount{2}}.position.rot;
            IF (CCW=FALSE) pSearchStart2.trans:=[nWeldLineLength_R2+nCorrX_Store+(X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart2.trans:=[nWeldLineLength_R2+nCorrX_Store+(X),nCorrY_Store+(Y*(-1)),nCorrZ_Store+(Z)];
        ENDIF

        pSearchStart2.robconf.cfx:=1;
        pSearchStart2.extax:=[9e9,9e9,9e9,9e9,9e9,9e9];
        !    pSearchStart2.extax.eax_d:=wobjWeldLine1.uframe.trans.z-(nRobCorrSpaceHeight+wobjWeldLine1.oframe.trans.z);

        pSearchEnd2:=pSearchStart2;
        IF (isStartPos=bStart) pSearchEnd2.trans.x:=pSearchStart2.trans.x+Depth;
        IF (isStartPos=bEnd) pSearchEnd2.trans.x:=pSearchStart2.trans.x-Depth;
        bTouchOnSameSpotError_R2:=FALSE;
        pComparison:=CRobT(\Tool:=tWeld2\WObj:=wobjWeldLine2);
        rCorrSearchByWire pSearchStart2,pSearchEnd2\X;
        nComparison:=VectMagn(pCorredPosBuffer2-pComparison.trans);
        IF nComparison<4 THEN
            bTouchOnSameSpotError_R2:=TRUE;
            IF (isStartPos=bStart) THEN
                nSameSpot_StartX_R2:=nSameSpot_StartX_R2+10;
            ELSE
                nSameSpot_EndX_R2:=nSameSpot_EndX_R2+10;
            ENDIF
            rTouchOnSameSpotErrorHandling;
        ELSE
            bTouchOnSameSpotError_R2:=FALSE;
            IF (isStartPos=bStart) THEN
                nSameSpot_StartX_R2:=0;
            ELSE
                nSameSpot_EndX_R2:=0;
            ENDIF
        ENDIF
        IF (isStartPos=bStart) nCorrX_Store:=pCorredPosBuffer2.x;
        IF (isStartPos=bEnd) nCorrX_Store:=pCorredPosBuffer2.x-nWeldLineLength_R2;

        IF (isStartPos=bStart) THEN
            nCorrX_Store_Start{2}:=nCorrX_Store;
            nCorrY_Store_Start{2}:=nCorrY_Store;
            nCorrZ_Store_Start{2}:=nCorrZ_Store;
        ELSE
            nCorrX_Store_End{2}:=nCorrX_Store;
            nCorrY_Store_End{2}:=nCorrY_Store;
            nCorrZ_Store_End{2}:=nCorrZ_Store;
        ENDIF

        rMoveCorrConnect RetX,Y,Z,0,0,0,pSearchStart2.extax.eax_d,isStartPos,CCW;
        nTouchRetryCount{2}:=0;
        TouchErrorDirMain:="Ready";

        RETURN ;
    ENDPROC

    PROC rCorrSearchWeldLineEdgeY(num X,num Y,num Z,num Depth,num RetY,bool isStartPos,bool CCW,string dirErrorCheck)
        VAR num nCorrX_Store;
        VAR num nCorrY_Store;
        VAR num nCorrZ_Store;
        VAR robtarget pComparison;
        VAR num nComparison;
        WaitUntil bRobSwap=CCW;
        IF (isStartPos=bStart) THEN
            nCorrX_Store:=nCorrX_Store_Start{2};
            nCorrY_Store:=nCorrY_Store_Start{2};
            nCorrZ_Store:=nCorrZ_Store_Start{2};
        ELSE
            nCorrX_Store:=nCorrX_Store_End{2};
            nCorrY_Store:=nCorrY_Store_End{2};
            nCorrZ_Store:=nCorrZ_Store_End{2};
        ENDIF

        TouchErrorDirSub:=dirErrorCheck;
        RetryDepthData{2}:=RetryDepthData{2}*(-1);
        IF TouchErrorDirMain=dirErrorCheck AND nTouchRetryCount{2}>0 Depth:=Depth+(RetryDepthData{2}*nTouchRetryCount{2});
        RetryDepthData{2}:=RetryDepthData{2}*(-1);

        !!! Search weld Y edge !!!
        WaitUntil bRobSwap=CCW;
        IF (isStartPos=bStart) THEN
            !        pSearchStart2:=ConvertTcpToGantryCoord(pWeldPosR2{1}.position);
            pSearchStart2.rot:=Welds2{1}.position.rot;
            IF (CCW=FALSE) pSearchStart2.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart2.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y*(-1)),nCorrZ_Store+Z];
        ELSEIF (isStartPos=bEnd) THEN
            !        pSearchStart2:=ConvertTcpToGantryCoord(pWeldPosR2{nMotionStepCount}.position);
            !pSearchStart2.rot:=pWeldPosR2{nMotionStepCount{2}}.rot;
            pSearchStart2.rot:=Welds2{nMotionStepCount{2}}.position.rot;
            IF (CCW=FALSE) pSearchStart2.trans:=[nWeldLineLength_R2+nCorrX_Store+(X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart2.trans:=[nWeldLineLength_R2+nCorrX_Store+(X),nCorrY_Store+(Y*(-1)),nCorrZ_Store+(Z)];
        ENDIF

        pSearchStart2.robconf.cfx:=1;
        !  pSearchStart2.extax.eax_d:=wobjWeldLine1.uframe.trans.z-(nRobCorrSpaceHeight+wobjWeldLine1.oframe.trans.z);

        pSearchEnd2:=pSearchStart2;
        pSearchStart2.extax:=[9e9,9e9,9e9,9e9,9e9,9e9];
        IF (CCW=FALSE) pSearchEnd2.trans.y:=pSearchStart2.trans.y-Depth;
        IF (CCW=TRUE) pSearchEnd2.trans.y:=pSearchStart2.trans.y+Depth;
        bTouchOnSameSpotError_R2:=FALSE;
        pComparison:=CRobT(\Tool:=tWeld2\WObj:=wobjWeldLine2);
        rCorrSearchByWire pSearchStart2,pSearchEnd2\Y;
        nComparison:=VectMagn(pCorredPosBuffer2-pComparison.trans);
        IF nComparison<4 THEN
            bTouchOnSameSpotError_R2:=TRUE;
            IF (isStartPos=bStart) THEN
                nSameSpot_StartY_R2:=nSameSpot_StartY_R2+10;
            ELSE
                nSameSpot_EndY_R2:=nSameSpot_EndY_R2+10;
            ENDIF
            rTouchOnSameSpotErrorHandling;
        ELSE
            bTouchOnSameSpotError_R2:=FALSE;
            IF (isStartPos=bStart) THEN
                nSameSpot_StartY_R2:=0;
            ELSE
                nSameSpot_EndY_R2:=0;
            ENDIF
        ENDIF

        nCorrY_Store:=pCorredPosBuffer2.y;

        IF (isStartPos=bStart) THEN
            nCorrX_Store_Start{2}:=nCorrX_Store;
            nCorrY_Store_Start{2}:=nCorrY_Store;
            nCorrZ_Store_Start{2}:=nCorrZ_Store;
        ELSE
            nCorrX_Store_End{2}:=nCorrX_Store;
            nCorrY_Store_End{2}:=nCorrY_Store;
            nCorrZ_Store_End{2}:=nCorrZ_Store;
        ENDIF

        rMoveCorrConnect X,RetY,Z,0,0,0,pSearchStart2.extax.eax_d,isStartPos,CCW;
        nTouchRetryCount{2}:=0;
        TouchErrorDirMain:="Ready";

        RETURN ;
    ENDPROC

    PROC rCorrSearchWeldLineEdgeZ(num X,num Y,num Z,num Depth,num RetZ,bool isStartPos,bool CCW,string dirErrorCheck)
        VAR num nCorrX_Store;
        VAR num nCorrY_Store;
        VAR num nCorrZ_Store;
        VAR robtarget pComparison;
        VAR num nComparison;
        WaitUntil bRobSwap=CCW;
        IF (isStartPos=bStart) THEN
            nCorrX_Store:=nCorrX_Store_Start{2};
            nCorrY_Store:=nCorrY_Store_Start{2};
            nCorrZ_Store:=nCorrZ_Store_Start{2};
        ELSE
            nCorrX_Store:=nCorrX_Store_End{2};
            nCorrY_Store:=nCorrY_Store_End{2};
            nCorrZ_Store:=nCorrZ_Store_End{2};
        ENDIF
        TouchErrorDirSub:=dirErrorCheck;
        IF TouchErrorDirMain=dirErrorCheck AND nTouchRetryCount{2}>0 Depth:=Depth+(RetryDepthData{3}*nTouchRetryCount{2});
        !!! Search weld Z edge !!!
        WaitUntil bRobSwap=CCW;
        IF (isStartPos=bStart) THEN
            !       pSearchStart2:=ConvertTcpToGantryCoord(pWeldPosR2{1}.position);
            pSearchStart2.rot:=Welds2{1}.position.rot;
            IF (CCW=FALSE) pSearchStart2.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart2.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y*(-1)),nCorrZ_Store+(Z)];
        ELSEIF (isStartPos=bEnd) THEN
            !        pSearchStart2:=ConvertTcpToGantryCoord(pWeldPosR2{nMotionStepCount}.position);
            pSearchStart2.rot:=Welds2{nMotionStepCount{2}}.position.rot;
            ! pSearchStart2.rot:=pWeldPosR2{nMotionStepCount{2}}.rot;
            IF (CCW=FALSE) pSearchStart2.trans:=[nWeldLineLength_R2+nCorrX_Store+(X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart2.trans:=[nWeldLineLength_R2+nCorrX_Store+(X),nCorrY_Store+(Y*(-1)),nCorrZ_Store+(Z)];
        ENDIF

        pSearchStart2.robconf.cfx:=1;
        pSearchStart2.extax:=[9e9,9e9,9e9,9e9,9e9,9e9];
        !  pSearchStart2.extax.eax_d:=wobjWeldLine1.uframe.trans.z-(nRobCorrSpaceHeight+wobjWeldLine1.oframe.trans.z);

        pSearchEnd2:=pSearchStart2;
        pSearchEnd2.trans.z:=pSearchStart2.trans.z-Depth;
        bTouchOnSameSpotError_R2:=FALSE;
        pComparison:=CRobT(\Tool:=tWeld2\WObj:=wobjWeldLine2);
        rCorrSearchByWire pSearchStart2,pSearchEnd2\Z;
        nComparison:=VectMagn(pCorredPosBuffer2-pComparison.trans);
        IF nComparison<4 THEN
            bTouchOnSameSpotError_R2:=TRUE;
            IF (isStartPos=bStart) THEN
                nSameSpot_StartZ_R2:=nSameSpot_StartZ_R2+10;
            ELSE
                nSameSpot_EndZ_R2:=nSameSpot_EndZ_R2+10;
            ENDIF
            rTouchOnSameSpotErrorHandling;
        ELSE
            bTouchOnSameSpotError_R2:=FALSE;
            IF (isStartPos=bStart) THEN
                nSameSpot_StartZ_R2:=0;
            ELSE
                nSameSpot_EndZ_R2:=0;
            ENDIF
        ENDIF

        nCorrZ_Store:=pCorredPosBuffer2.z;

        IF (isStartPos=bStart) THEN
            nCorrX_Store_Start{2}:=nCorrX_Store;
            nCorrY_Store_Start{2}:=nCorrY_Store;
            nCorrZ_Store_Start{2}:=nCorrZ_Store;
        ELSE
            nCorrX_Store_End{2}:=nCorrX_Store;
            nCorrY_Store_End{2}:=nCorrY_Store;
            nCorrZ_Store_End{2}:=nCorrZ_Store;
        ENDIF

        rMoveCorrConnect X,Y,RetZ,0,0,0,pSearchStart2.extax.eax_d,isStartPos,CCW;
        nTouchRetryCount{2}:=0;
        TouchErrorDirMain:="Ready";

        RETURN ;
    ENDPROC

    PROC rCorrSearchByWire(robtarget SearchStart,robtarget SearchEnd,\switch X\switch Y\switch Z)
        VAR robtarget pTemp:=[[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,9E+09,9E+09]];
        MoveJ SearchStart,v100,fine,tWeld2\WObj:=wobjWeldLine2;
        rCheckWelder;
        SearchL\SStop,bWireTouch2,SearchStart,SearchEnd,v10,tWeld2\WObj:=wobjWeldLine2;

        Reset soLn2Touch;
        WaitTime 0;
        WaitUntil(siLn2TouchActive=0);
        pTemp:=CRobT(\taskname:="T_ROB2"\tool:=tWeld2\WObj:=wobjWeldLine2);
        pCorredPosBuffer2:=pTemp.trans;
        !        stop;
        RETURN ;
    ERROR

        TouchErrorDirMain:=TouchErrorDirSub;
        IDelete iMoveHome_RBT2;
        IF ERRNO=ERR_WHLSEARCH THEN
            rTouchErrorHandling 2;
        ELSEIF ERRNO=ERR_SIGSUPSEARCH THEN
            WaitTime 999;
            rTouchErrorHandling 3;
        ELSE
            rTouchErrorHandling 3;
        ENDIF
    ENDPROC

    PROC rZero()
        MoveAbsJ [[0,0,0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]]\NoEOffs,v1000,fine,tool0;
    ENDPROC

    PROC rErrorDuringEntry()
        VAR robtarget pTemp;
        IDelete iMoveHome_RBT2;
        Reset soLn2Touch;
        StopMove;
        ClearPath;
        StartMove;
        pTemp:=CRobT(\TaskName:="T_ROB2"\Tool:=tWeld2\WObj:=wobjWeldLine2);
        MoveL RelTool(pTemp,0,0,-10),vTargetSpeed,fine,tWeld2\WObj:=wobjWeldLine2;
        stReact{2}:="Error_Arc_Touch";
        WaitSyncTask Wait{80},taskGroup123;

        WaitUntil stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
        WaitSyncTask Wait{81},taskGroup123;

        WaitUntil stCommand="Error_Arc_Touch";
        stReact{2}:="";
        WaitUntil stCommand="";
        WaitSyncTask Wait{82},taskGroup123;

        ExitCycle;
        RETURN ;
    ENDPROC

    PROC rTouchErrorWhilMovingHandling()
        VAR robtarget pTemp;
        Reset soLn2Touch;
        IDelete iMoveHome_RBT2;
        IDelete innumTouchErrorWhilMoving;
        StopMove;
        ClearPath;
        StartMove;

        bMoveToWireCutHome:=TRUE;

        stReact{2}:="Error_Arc_Touch";
        WaitSyncTask Wait{80},taskGroup123;

        WaitUntil stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
        WaitSyncTask Wait{81},taskGroup123;

        WaitUntil stCommand="Error_Arc_Touch";
        stReact{2}:="";
        WaitUntil stCommand="";
        WaitSyncTask Wait{82},taskGroup123;

        ExitCycle;
    ENDPROC

    PROC rTouchOnSameSpotErrorHandling()
        Reset soLn2Touch;
        IDelete iMoveHome_RBT2;
        IDelete innumTouchErrorWhilMoving;
        bMoveToWireCutHome:=TRUE;

        stReact{2}:="Error_Arc_Touch";
        WaitSyncTask Wait{80},taskGroup123;

        WaitUntil stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
        WaitSyncTask Wait{81},taskGroup123;

        WaitUntil stCommand="Error_Arc_Touch";
        stReact{2}:="";
        WaitUntil stCommand="";
        WaitSyncTask Wait{82},taskGroup123;

        ExitCycle;
    ENDPROC

    PROC rArcError()
        VAR robtarget pTemp;
        bArc_On{2}:=FALSE;
        TPWrite "TROB2_ArcError";
        PulseDO\High\PLength:=0.5,sdo_T_Rob1_StopProc;
        IDelete iMoveHome_RBT2;
        ClkStop clockWeldTime;
        nclockWeldTime{2}:=ClkRead(clockWeldTime);
        SetDO intReHoldGantry_1,1;
        StopMove;
        ClearPath;
        IF bRobSwap=FALSE THEN
            Set po36_ArcR1Error;
            MonitorweldErrorpostion.monPose1:=MonitorPosition.monPose1;
            MonitorweldErrorpostion.monPose2:=MonitorPosition.monPose2;
        ELSE
            Set po37_ArcR2Error;
            MonitorweldErrorpostion.monPose1:=MonitorPosition.monPose1;
            MonitorweldErrorpostion.monPose2:=MonitorPosition.monPose2;
        ENDIF
        !pTemp:=CRobT(\TaskName:="T_ROB2"\Tool:=tWeld2\WObj:=wobjWeldLine2);
        !MoveL RelTool(pTemp,0,0,-10),vTargetSpeed,z0,tWeld2\WObj:=wobjWeldLine2;
        nArcError:=1;
        StartMove;

        stReact{2}:="Error_Arc_Touch";
        WaitSyncTask Wait{80},taskGroup123;

        WaitUntil stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
        WaitSyncTask Wait{81},taskGroup123;

        WaitUntil stCommand="Error_Arc_Touch";
        stReact{2}:="";
        WaitUntil stCommand="";
        WaitSyncTask Wait{82},taskGroup123;
        Reset po14_Motion_Working;
        Set po15_Motion_Finish;
        ExitCycle;
    ENDPROC

    PROC rTouchErrorHandling(num Errorno)
        VAR robtarget pTemp;
        Reset soLn2Touch;
        Set po35_TouchR2Error;
        IDelete iMoveHome_RBT2;

        pTemp:=CRobT(\TaskName:="T_ROB2"\tool:=tWeld2\WObj:=wobjWeldLine2);
        MoveL RelTool(pTemp,0,0,-10),v200,z10,tWeld2\WObj:=wobjWeldLine2;
        stReact{2}:="Error_Arc_Touch";
        WaitSyncTask Wait{80},taskGroup123;

        WaitUntil stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
        WaitSyncTask Wait{81},taskGroup123;

        WaitUntil stCommand="Error_Arc_Touch";
        stReact{2}:="";
        WaitUntil stCommand="";
        WaitSyncTask Wait{82},taskGroup123;

        StartMove;
        ExitCycle;


    ENDPROC

    PROC rT_ROB2check()
        VAR robtarget pTemp;
        pTemp:=CRobT(\TaskName:="T_ROB2"\Tool:=tWeld2\WObj:=wobj0);
        IF pTemp.trans.x>350 AND pTemp.trans.z>1420 THEN
            pTemp.trans.x:=350;

            MoveL pTemp,v100,fine,tWeld2\WObj:=wobj0;
        ENDIF
    ENDPROC

    PROC rCheckWelder()
        IF (soLn2Touch=1) THEN
            Reset soLn2Touch;
            WaitTime 0.5;
        ENDIF
        WaitTime 0.5;
        WaitUntil(siLn2TouchActive=0 OR soLn2Touch=0);
        Set soLn2Touch;
        WaitUntil(siLn2TouchActive=1 AND soLn2Touch=1);
    ENDPROC

    PROC rNozzleClean()
        VAR robtarget pTemp{10};
        VAR jointtarget j{20};
        VAR clock clNozzleCleanForward;

        j{1}:=jWorkingHome;
        j{2}:=jNozzle02;
        j{3}:=jNozzle02;
        j{4}:=jNozzle01;
        j{5}:=jNozzleCleanEntry;
        j{6}:=jNozzleClean;
        j{7}:=jSprayEntry;
        j{8}:=jSpray;


        WobjNozzel_2:=wobjRotCtr2;
        WobjNozzel_2.oframe.rot:=OrientZYX(nR_Angle,0,0);
        FOR i FROM 5 TO 8 DO
            pTemp{i}:=CalcRobT(j{i},tWeld2\WObj:=WobjNozzel_2);
        ENDFOR

        MoveAbsJ j{1},v300,z50,tWeld2;
        MoveAbsJ j{2},v300,z50,tWeld2;
        MoveAbsJ j{3},v300,z50,tWeld2;
        MoveAbsJ j{4},v300,z50,tWeld2;
        MoveJ pTemp{5},v300,z0,tWeld2\WObj:=WobjNozzel_2;
        Movel pTemp{6},v50,fine,tWeld2\WObj:=WobjNozzel_2;
        WaitRob\InPos;
        waittime 0.2;
        Set do15_NozzleClean;
        ClkReset clNozzleCleanForward;
        ClkStart clNozzleCleanForward;
        WaitUntil di28_NozzleCleanForward=1 OR ClkRead(clNozzleCleanForward)>5;
        ClkStop clNozzleCleanForward;
        reSet do15_NozzleClean;
        WaitUntil di29_NozzleCleanBackward=1;
        Movel pTemp{5},v300,z0,tWeld2\WObj:=WobjNozzel_2;
        Movel pTemp{7},v300,z0,tWeld2\WObj:=WobjNozzel_2;
        Movel pTemp{8},v50,fine,tWeld2\WObj:=WobjNozzel_2;
        WaitRob\InPos;
        waittime 0.2;
        !PulseDO\High\PLength:=nSprayTime,do16_NozzleSpray;
        WaitTime nSprayTime+1;
        Movel pTemp{7},v300,z0,tWeld2\WObj:=WobjNozzel_2;
        PulseDO\High\PLength:=5,do14_Torch2_Air_Cooling;
        MoveAbsJ j{4},v300,z50,tWeld2;
        MoveAbsJ j{3},v300,z50,tWeld2;
        MoveAbsJ j{2},v300,z50,tWeld2;
        MoveAbsJ j{1},v300,fine,tWeld2;
        RETURN ;

        !=== Teaching ========
        MoveAbsJ jWorkingHome,v300,z50,tWeld2;
        MoveAbsJ jNozzle03,v300,z50,tWeld2;
        MoveAbsJ jNozzle02,v300,z50,tWeld2;
        MoveAbsJ jNozzle01,v300,z50,tWeld2;
        MoveAbsJ jNozzleCleanEntry,v300,z50,tWeld2;
        MoveAbsJ jNozzleClean,v300,z50,tWeld2;
        MoveAbsJ jSprayEntry,v300,z50,tWeld2;
        MoveAbsJ jSpray,v300,z50,tWeld2;

    ENDPROC
ENDMODULE
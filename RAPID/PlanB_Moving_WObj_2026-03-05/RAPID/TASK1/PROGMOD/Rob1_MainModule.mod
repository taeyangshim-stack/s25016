MODULE Rob1_MainModule
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

    PERS wobjdata wobjWeldLine1;
    PERS wobjdata wobjRotCtr1;
    PERS wobjdata WobjFloor;
    PERS tooldata tWeld1;

    PERS num nMotionTotalStep{2};
    PERS num nMotionStepCount{2};
    PERS num nMotionStartStepLast{2};
    PERS num nMotionEndStepLast{2};
    PERS num nRunningStep{2};

    PERS jointtarget jRob1;
    PERS robtarget pRob1;
    PERS bool bRqMoveG_PosHold;

    PERS robtarget pctWeldPosR1;
    PERS robtarget pctWeldPosR2;

    PERS targetdata Welds1{40};
    TASK PERS speeddata vWeld{40}:=[[10,200,200,200],[10,200,200,200],[10,200,200,200],[10,200,200,200],[10,200,200,200],[10,200,200,200],[10,200,200,200],[10,200,200,200],[10,200,200,200],[10,200,200,200],[200,200,200,200],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[10,200,200,200]];
    PERS seamdata smDefault_1{2};
    PERS seamdata seam_TRob1;

    PERS speeddata vTargetSpeed;
    PERS zonedata zTargetZone;

    TASK PERS welddata wdTrap:=[10,0,[5,0,38,240,0,400,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd1:=[10,0,[5,0,36.8,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd2:=[10,0,[5,0,36.8,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd3:=[10,0,[5,0,36.8,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd4:=[10,0,[5,0,36.8,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd5:=[10,0,[5,0,36.8,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd6:=[10,0,[5,0,36.8,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd7:=[10,0,[5,0,36.8,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd8:=[10,0,[5,0,36.8,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd9:=[10,0,[5,0,36.8,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd10:=[10,0,[5,0,36.8,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];


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
    TASK PERS trackdata track1:=[0,FALSE,0,[0,15,30,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track2:=[0,FALSE,0,[0,15,30,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track3:=[0,FALSE,0,[0,15,30,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track4:=[0,FALSE,0,[0,15,30,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track5:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track6:=[0,FALSE,0,[0,10,20,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track7:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track8:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track9:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track10:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];


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

    PERS torchmotion macroStartBuffer1{10};
    PERS torchmotion macroEndBuffer1{10};
    PERS num nWeldLineLength:=400;
    ! 264.966;
    PERS num nWeldLineLength_R1;
    ! 264.966;
    PERS robtarget pSearchStart1:=[[0,27.0001,17.2587],[0.241845,0.664463,-0.664463,0.241845],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS robtarget pSearchEnd1:=[[0,-25,17.2587],[0.241845,0.664463,-0.664463,0.241845],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    TASK PERS string TouchErrorDirSub:="Start_Y";
    TASK PERS string TouchErrorDirMain:="Ready";
    PERS num nTouchRetryCount{2};
    PERS num n_Angle;
    TASK PERS num RetryDepthData{3}:=[10,10,10];
    PERS robtarget pWeldPosR1{40}:=[[[-3,7,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.31,9E+09,9E+09]],[[-3,7,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.31,9E+09,9E+09]],[[-3,-4.5,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.31,9E+09,9E+09]],[[15,-1,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.34,9E+09,9E+09]],[[200,-1,1],[0.270598,-0.653282,-0.653282,-0.270598],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.72,9E+09,9E+09]],[[1390,-1.00592,0.996463],[0.270597,-0.653283,-0.653281,-0.270597],[0,0,-1,1],[-8707.81,-8707.8,1477.15,1033.13,9E+09,9E+09]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]]];
    PERS num nRobCorrSpaceHeight;
    PERS pos pCorredPosBuffer1:=[-0.013625,7.09738,17.3113];
    PERS bool bWireTouch1;
    CONST robtarget pNull:=[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

    PERS bool bRobSwap;
    PERS jointtarget jCorrT_ROB1_Start;
    PERS jointtarget jCorrT_ROB1_End;
    PERS robtarget pCorrT_ROB1_Start;
    PERS robtarget pCorrT_ROB1_End;
    !!!WireCut
    TASK PERS num nWireCutSpeed:=600;
    TASK PERS tooldata tWeld1copy:=[TRUE,[[320.377,0,330.247],[0.92587,0,0.37784,0]],[3.1,[-71.4,3.8,173.2],[1,0,0,0],0.055,0.049,0.005]];

    PERS bool bEnableWeldSkip;
    PERS num nTrapCheck_1;
    PERS seamdata smDefault_1Trap;
    VAR num tool_rx_end{3};
    VAR num tool_rx_start{3};
    VAR num tool_rx_delta{3};
    VAR robtarget pcalcWeldpos;
    VAR robtarget pMoveWeldpos;
    VAR robtarget pSaveWeldpos;
    PERS robtarget pErrorWeldpos1;
    !!!!Error
    TASK VAR intnum iErrorDuringEntry;
    PERS num nEntryRetryCount{2};
    TASK VAR intnum iMoveHome_RBT1;
    PERS bool bTouchWorkCount1{6}:=[FALSE,FALSE,FALSE,FALSE,FALSE,FALSE];
    PERS monRobs MonitorweldErrorpostion;
    PERS monRobs MonitorPosition;
    PERS pos posStart;
    PERS pos posEnd;
    PERS bool bGantryInTrap{2};
    TASK VAR intnum intOutGantryHold;
    PERS edgedata edgestartBuffer1;
    PERS edgedata edgeEndBuffer1;
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
    TASK VAR clock clockWeldTime;
    PERS num nclockWeldTime{2};
    PERS bool bWirecut{3};
    PERS robtarget pCheckBuffer{3};
    PERS bool bArc_On{2};
    PERS num nMode;
    PERS num nSprayTime;
    PERS num nR_Angle;
    PERS bool bNozzleCleanCut;
    PERS wobjdata WobjNozzel_1;
    PERS num nSearchBuffer_X_Start{2};
    PERS num nSearchBuffer_Y_Start{2};
    PERS num nSearchBuffer_Z_Start{2};
    PERS num nSearchBuffer_X_End{2};
    PERS num nSearchBuffer_Y_End{2};
    PERS num nSearchBuffer_Z_End{2};
    TASK VAR intnum iArcError1;
    TASK PERS num nArcError:=0;
    TASK PERS speeddata vReltool:=[200,200,200,200];
    TASK PERS robtarget pReltool:=[[49.3868,6.42327,-1.32008],[0.241846,0.664464,-0.664462,0.241845],[0,-1,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

    TASK VAR intnum innumTouchErrorWhilMoving;
    PERS num nTouchWhileMovingCount_R1;

    pers bool bTouchOnSameSpotError_R1;
    pers bool bTouchOnSameSpotError_R2;    
    PERS num nSameSpot_StartX_R1:=0;
    PERS num nSameSpot_StartY_R1:=0;
    PERS num nSameSpot_StartZ_R1:=0;
    PERS num nSameSpot_EndX_R1:=0;
    PERS num nSameSpot_EndY_R1:=0;
    PERS num nSameSpot_EndZ_R1:=0;
    PERS bool bMoveToWireCutHome:=TRUE;
        !!!!!  TeachingWireCut  !!!!!!!!!!!!!
    PERS pos pCuttingInsideOffset_R1;
    PERS pos pCuttingEntryOffset_R1;
    

    TRAP trapMoveG_PosHold
        rTrapNoWeldMove;
    ENDTRAP

    TRAP trapArcError1
        VAR robtarget pTemp;
        TPWrite "TROB1_ArcError";
        bArc_On{1}:=FALSE;

        IDelete iArcError1;
        ClkStop clockWeldTime;
        nclockWeldTime{1}:=ClkRead(clockWeldTime);

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
        !pTemp:=CRobT(\TaskName:="T_ROB1"\Tool:=tWeld1\WObj:=wobjWeldLine1);
        !MoveL RelTool(pTemp,0,0,-10),vTargetSpeed,z0,tWeld1\WObj:=wobjWeldLine1;
        nArcError:=1;
        StartMove;

        stReact{1}:="Error_Arc_Touch";
        WaitSyncTask Wait{80},taskGroup123;

        WaitUntil stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
        WaitSyncTask Wait{81},taskGroup123;

        WaitUntil stCommand="Error_Arc_Touch";
        stReact{1}:="";
        WaitUntil stCommand="";
        WaitSyncTask Wait{82},taskGroup123;
        Reset po14_Motion_Working;
        Set po15_Motion_Finish;
        ExitCycle;

    ENDTRAP

    TRAP trapTouchErrorWhilMoving
        nTouchWhileMovingCount_R1:=nTouchWhileMovingCount_R1+1;
    ENDTRAP

    TRAP trapMoveHome_RBT1
        VAR robtarget pTemp;
        IDelete iMoveHome_RBT1;
        IDelete iErrorDuringEntry;
        Reset soLn1Touch;
        StopMove;
        ClearPath;
        StartMove;
        pTemp:=CRobT(\TaskName:="T_ROB1"\Tool:=tWeld1\WObj:=wobjWeldLine1);
        MoveL RelTool(pTemp,0,0,-10),vTargetSpeed,z0,tWeld1\WObj:=wobjWeldLine1;
        bWeldOutputDisable:=TRUE;
        stReact{1}:="Error_Arc_Touch";
        WaitSyncTask Wait{80},taskGroup123;

        WaitUntil stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
        WaitSyncTask Wait{81},taskGroup123;

        WaitUntil stCommand="Error_Arc_Touch";
        stReact{1}:="";
        WaitUntil stCommand="";
        WaitSyncTask Wait{82},taskGroup123;
        ExitCycle;
    ENDTRAP

    TRAP trapErrorDuringEntry
        Set po32_EntryR1Error;
        IDelete iMoveHome_RBT1;
        IDelete iErrorDuringEntry;
        rErrorDuringEntry;
    ENDTRAP

    PROC main()
        IF bExitCycle=FALSE THEN
            bExitCycle:=TRUE;
            ExitCycle;
        ENDIF
        bExitCycle:=FALSE;
        rInit;
        WHILE TRUE DO
            IF nArcError=1 THEN
                pReltool:=CRobT(\TaskName:="T_ROB1"\Tool:=tWeld1\WObj:=wobjWeldLine1);
                MoveL RelTool(pReltool,0,0,-10),vReltool,z0,tWeld1\WObj:=wobjWeldLine1;
                nArcError:=0;
                WaitTime 0.5;
            ENDIF
            WaitUntil stCommand<>"";
            TEST stCommand
            CASE "MoveJgJ":
                !                 WaitSyncTask Wait{nMoveid+1},taskGroup123;
                SyncMoveOn SynchronizeJGJon{nMoveid+2},taskGroup123;
                MoveAbsJ jRob1\ID:=nMoveid+3,vSync,zSync,tool:=tool0;
                SyncMoveOff SynchronizeJGJoff{nMoveid+4};
                stReact{1}:="Ack";
                WaitUntil stCommand="";
                stReact{1}:="Ready";
            CASE "MovePgJ":
                !                 WaitSyncTask Wait{nMoveid+1},taskGroup123;
                SyncMoveOn SynchronizePGJon{nMoveid+2},taskGroup123;
                MoveJ pRob1\ID:=nMoveid+3,vSync,zSync,tool:=tool0;
                SyncMoveOff SynchronizePGJoff{nMoveid+4};
                stReact{1}:="Ack";
                WaitUntil stCommand="";
                stReact{1}:="Ready";
            CASE "MovePgL":
                !                 WaitSyncTask Wait{nMoveid+1},taskGroup123;
                SyncMoveOn SynchronizePGLon{nMoveid+2},taskGroup123;
                MoveJ pRob1\ID:=nMoveid+3,vSync,zSync,tool:=tool0;
                SyncMoveOff SynchronizePGLoff{nMoveid+4};
                stReact{1}:="Ack";
                WaitUntil stCommand="";
                stReact{1}:="Ready";
            CASE "Weld":
                IDelete iMoveHome_RBT1;

                IF bEnableWeldSkip=TRUE THEN
                    SetDO soLn1InhibWeld,1;
                ELSE
                    SetDO soLn1InhibWeld,0;
                ENDIF
                rWeld;
                nTrapCheck_1:=0;

            CASE "Weld1":
                IDelete iMoveHome_RBT1;
                IF bEnableWeldSkip=TRUE THEN
                    SetDO soLn1InhibWeld,1;
                ELSE
                    SetDO soLn1InhibWeld,0;
                ENDIF
                rWeldAlone1;
                nTrapCheck_1:=0;

            CASE "Weld2":
                ConfL\On;
                WaitUntil stReact{2}="WeldOk" OR stReact{2}="Error_Arc_Touch";
                IF stReact{2}="Error_Arc_Touch" THEN
                    stReact{1}:="Error_Arc_Touch";

                    WaitSyncTask Wait{80},taskGroup123;

                    WaitUntil stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
                    WaitSyncTask Wait{81},taskGroup123;

                    WaitUntil stCommand="Error_Arc_Touch";
                    stReact{1}:="";
                    WaitUntil stCommand="";
                    WaitSyncTask Wait{82},taskGroup123;
                    Reset po14_Motion_Working;
                    Set po15_Motion_Finish;
                    ExitCycle;
                ENDIF
                stReact{1}:="WeldOk";
                WaitUntil stCommand="";
                stReact{1}:="Ready";
                nTrapCheck_1:=0;

            CASE "CorrSearchStartEnd":
                IF nMode=2 THEN
                    bTouch_First_R1_Comp:=TRUE;
                    bTouch_last_R1_Comp:=TRUE;
                    IDelete iMoveHome_RBT1;
                    CONNECT iMoveHome_RBT1 WITH trapMoveHome_RBT1;
                    ISignalDO intMoveHome_RBT1,1,iMoveHome_RBT1;
                    stReact{1}:="CorrSearchOK";
                    WaitUntil stCommand="";
                    stReact{1}:="Ready";
                    nCorrFailOffs_Y:=0;
                    nCorrFailOffs_Z:=0;
                    nCorrX_Store_Start{1}:=0;
                    nCorrY_Store_Start{1}:=0;
                    nCorrZ_Store_Start{1}:=0;
                    nCorrX_Store_End{1}:=0;
                    nCorrY_Store_End{1}:=0;
                    nCorrZ_Store_End{1}:=0;
                    IDelete iMoveHome_RBT1;
                ELSE
                    IF nEntryRetryCount{1}=0 THEN
                        nCorrFailOffs_Y:=0;
                        nCorrFailOffs_Z:=0;
                    ENDIF
                    IF nTouchRetryCount{1}=0 AND nTouchRetryCount{2}=0 AND bTouchOnSameSpotError_R1=FALSE AND bTouchOnSameSpotError_R2=FALSE THEN
                        bTouchWorkCount1:=[FALSE,FALSE,FALSE,FALSE,FALSE,FALSE];
                        nCorrX_Store_Start{1}:=0;
                        nCorrY_Store_Start{1}:=0;
                        nCorrZ_Store_Start{1}:=0;
                        nCorrX_Store_End{1}:=0;
                        nCorrY_Store_End{1}:=0;
                        nCorrZ_Store_End{1}:=0;
                    ENDIF
                    IDelete iMoveHome_RBT1;
                    CONNECT iMoveHome_RBT1 WITH trapMoveHome_RBT1;
                    ISignalDO intMoveHome_RBT1,1,iMoveHome_RBT1;

                    rCorrSearchStartEnd;

                    bTouchWorkCount1:=[FALSE,FALSE,FALSE,FALSE,FALSE,FALSE];
                    IDelete iMoveHome_RBT1;
                ENDIF
            CASE "WireCutR1_R2":
                rWireCut;
            CASE "WireCutR1":
                rWireCut;
            CASE "WireCutR2":
                WaitUntil stCommand="";
                stReact{1}:="Ready";
            CASE "WireCutShotR1_R2":
                rWireCutShot;
            CASE "WireCutShotR1":
                rWireCutShot;
            CASE "WireCutShotR2":
                WaitUntil stCommand="";
                stReact{1}:="Ready";
            CASE "WireCutMoveR1_R2":
                rWireCutMove;
            CASE "WireCutMoveR1":
                rWireCutMove;
            CASE "WireCutMoveR2":
                WaitUntil stCommand="";
                stReact{1}:="Ready";
            CASE "NozzleClean_R1":
                rNozzleClean;
                stReact{1}:="NozzleClean_R1_Ok";
                WaitUntil stCommand="";
                stReact{1}:="Ready";
            CASE "NozzleClean_R2":
                WaitUntil stCommand="";
                stReact{1}:="Ready";
            CASE "checkpos":
                rT_ROB1check;
                stReact{1}:="checkposok";
                WaitUntil stCommand="";
                stReact{1}:="Ready";

            CASE "TeachingWirecut_R1":
                rTeachingWireCut;
                stReact{1}:="WorkComplete";
                WaitUntil stCommand="";
                stReact{1}:="Ready";
                WaitUntil stReact=["Ready","Ready","Ready"];
                
            CASE "TeachingWirecut_R2":
                stReact{1}:="WorkComplete";
                WaitUntil stCommand="";
                stReact{1}:="Ready";
                WaitUntil stReact=["Ready","Ready","Ready"];                  

            CASE "TeachingWirecutEntry_R1":
                rTeachingWireCutEntry;
                stReact{1}:="WorkComplete";
                WaitUntil stCommand="";
                stReact{1}:="Ready";
                WaitUntil stReact=["Ready","Ready","Ready"];
                
            CASE "TeachingWirecutEntry_R2":
                stReact{1}:="WorkComplete";
                WaitUntil stCommand="";
                stReact{1}:="Ready";
                WaitUntil stReact=["Ready","Ready","Ready"];                  
                
            CASE "LdsCheck":
                WaitUntil stCommand="";
                stReact{1}:="Ready";

            CASE "MoveToTcp":
                rMoveToTcp;
                stReact{1}:="MoveToTcp_Ok";
                WaitUntil stCommand="";
                stReact{1}:="Ready";

            DEFAULT:
                stReact{1}:="Error";
                Stop;
            ENDTEST
        ENDWHILE
    ENDPROC

    PROC rMoveToTcp()
        MoveJ Welds1{1}.position,v50,fine,tWeld1\WObj:=wobjWeldLine1;
    ENDPROC

    PROC rInit()
        AccSet 30,30;

        stReact{1}:="";
        WaitUntil stCommand="";
        stReact{1}:="Ready";
        IDelete inumMoveG_PosHold;
        IDelete iArcError1;
        IDelete iMoveHome_RBT1;
        IDelete intOutGantryHold;
        IDelete innumTouchErrorWhilMoving;
        Reset intReHoldGantry_1;
        Reset soLn1Touch;
        bGantryInTrap{1}:=FALSE;
        bArc_On{1}:=FALSE;
        RETURN ;
        MoveAbsJ [[0.0207831,-24.7259,-8.05171,0.050497,-57.6173,1.6],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]]\NoEOffs,v1000,z50,tool0;
        MoveJ [[9.92,3.15,2.35],[0.26872,-0.651181,-0.658046,-0.265947],[-1,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],v1000,z50,tWeld1\WObj:=wobjWeldLine1;
        MoveL [[50,0,0],[0.268705,-0.651201,-0.658033,-0.265945],[-1,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],v1000,z50,tWeld1\WObj:=wobjWeldLine1;
    ENDPROC

    PROC rWeldAlone1()

        VAR num nTempMmps;
        VAR num nTempVolt;
        VAR num nTempWFS;
        VAR num wdArray{40};
        VAR speeddata vHoldspeed;
        VAR num nHoldWeldVel;
        VAR num nHoldDist:=0;

        IDelete inumMoveG_PosHold;
        IDelete iArcError1;

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

        track0:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track6:=[0,FALSE,Welds1{6}.MaxCorr,[0,Welds1{6}.TrackGainY,Welds1{6}.TrackGainZ,0,Welds1{6}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];


        FOR i FROM 1 TO nMotionStepCount{2} DO
            nTempMmps:=Welds1{i}.cpm/6;
            vWeld{i}:=[nTempMmps,200,200,200];
            IF nTempMmps<>0 vHoldspeed:=[nTempMmps,60,100,100];
        ENDFOR

        WaitRob\ZeroSpeed;
        WaitSyncTask Wait{20},taskGroup13;
        MoveL RelTool(Welds1{1}.position,0,0,-10),vTargetSpeed,zTargetZone,tWeld1\WObj:=wobjWeldLine1;
        CONNECT iArcError1 WITH trapArcError1;
        ISignalDO intReHoldGantry_1,1,iArcError1;

        WaitRob\ZeroSpeed;
        ConfL\Off;
        ClkReset clockWeldTime;
        ClkStart clockWeldTime;
        SyncMoveOn Wait{22},taskGroup123;
        ArcLStart Welds1{1}.position\id:=10,vWeld{1},seam_TRob1,wd1\weave:=weave1,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track0;
        ArcL Welds1{2}.position\id:=20,vWeld{2},seam_TRob1,wd2,\Weave:=weave2,z0,tWeld1\WObj:=wobjWeldLine1\Track:=track0;
        ArcL Welds1{3}.position\id:=30,vWeld{3},seam_TRob1,wd3,\Weave:=weave3,z0,tWeld1\WObj:=wobjWeldLine1\Track:=track0;
        ArcL Welds1{4}.position\id:=40,vWeld{4},seam_TRob1,wd4,\Weave:=weave4,z0,tWeld1\WObj:=wobjWeldLine1\Track:=track0;
        ArcL Offs(Welds1{5}.position,-0.3,0,0)\id:=50,vWeld{5},seam_TRob1,wd5,\Weave:=weave5,z0,tWeld1\WObj:=wobjWeldLine1\Track:=track0;
        ArcL Offs(Welds1{5}.position,0,0,0)\id:=51,vWeld{5},seam_TRob1,wd5,\Weave:=weave5,z0,tWeld1\WObj:=wobjWeldLine1\Track:=track6;
        ArcL Offs(Welds1{6}.position,0.3,0,0)\id:=60,vWeld{6},seam_TRob1,wd6,\Weave:=weave6,z0,tWeld1\WObj:=wobjWeldLine1\Track:=track6;
        ArcL Offs(Welds1{6}.position,0.6,0,0)\id:=61,vWeld{6},seam_TRob1,wd6,\Weave:=weave6,z0,tWeld1\WObj:=wobjWeldLine1\Track:=track0;
        ArcL Offs(Welds1{7}.position,0,0,0)\id:=70,vWeld{7},seam_TRob1,wd7,\Weave:=weave7,z0,tWeld1\WObj:=wobjWeldLine1\Track:=track0;
        ArcL Offs(Welds1{8}.position,0,0,0)\id:=80,vWeld{8},seam_TRob1,wd8,\Weave:=weave8,z0,tWeld1\WObj:=wobjWeldLine1\Track:=track0;
        ArcL Offs(Welds1{9}.position,0,0,0)\id:=90,vWeld{9},seam_TRob1,wd9,\Weave:=weave9,z0,tWeld1\WObj:=wobjWeldLine1\Track:=track0;
        ArcLEnd Offs(Welds1{10}.position,0,0,0)\id:=100,vWeld{10},seam_TRob1,wd10,\Weave:=weave10,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track0;
        SyncMoveOff Wait{23};
        ClkStop clockWeldTime;
        nclockWeldTime{1}:=ClkRead(clockWeldTime);
        MoveL RelTool(Welds1{10}.position,0,0,-10),vTargetSpeed,z0,tWeld1\WObj:=wobjWeldLine1;
        ConfL\On;
        IDelete intOutGantryHold;
        IDelete iArcError1;
        stReact{1}:="WeldOk";
        WaitUntil stCommand="";
        stReact{1}:="Ready";
    ERROR
        IF ERRNO=ERR_PATH_STOP THEN
            StopMove;
            StorePath\KeepSync;
            WaitTime 1;
            RestoPath;
            StartMove;
        ENDIF
    ENDPROC

    PROC rWeld()
        ! from.HJB251202
        VAR num nTempMmps;
        VAR num nTempVolt;
        VAR num nTempWFS;
        VAR num wdArray{40};
        VAR speeddata vHoldspeed;
        VAR num nHoldWeldVel;
        VAR num nHoldDist:=0;
        IDelete inumMoveG_PosHold;
        IDelete iArcError1;

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

        ! Wave Data
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
        vWeld{11}:=[200,200,200,200];
        FOR i FROM 1 TO nMotionStepCount{1} DO
            !===========================================================!
            !!! [mm/sec] = [cm/sec]*10 = [cm/min]*10/60 = [cm/min]/6  !!!
            !===========================================================!
            nTempMmps:=Welds1{i}.cpm/6;
            vWeld{i}:=[nTempMmps,200,200,200];
            IF nTempMmps<>0 vHoldspeed:=[nTempMmps,60,100,100];
        ENDFOR

        WaitRob\ZeroSpeed;
        WaitSyncTask Wait{20},taskGroup123;
        MoveL RelTool(Welds1{1}.position,0,0,-10),vWeld{11},zTargetZone,tWeld1\WObj:=wobjWeldLine1;
        track0:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track6:=[0,FALSE,Welds1{6}.MaxCorr,[0,Welds1{6}.TrackGainY,Welds1{6}.TrackGainZ,0,Welds1{6}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        CONNECT iArcError1 WITH trapArcError1;
        ISignalDO intReHoldGantry_1,1,iArcError1;
        WaitRob\ZeroSpeed;
        ConfL\Off;

        WaitRob\ZeroSpeed;
        WaitSyncTask Wait{21},taskGroup12;
        ClkReset clockWeldTime;
        ClkStart clockWeldTime;
        ArcLStart Welds1{1}.position,vWeld{1},seam_TRob1,wd1\weave:=weave1,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track0;
        ArcL Welds1{2}.position,vWeld{2},seam_TRob1,wd2,\Weave:=weave2,z0,tWeld1\WObj:=wobjWeldLine1\Track:=track0;
        ArcL Welds1{3}.position,vWeld{3},seam_TRob1,wd3,\Weave:=weave3,z0,tWeld1\WObj:=wobjWeldLine1\Track:=track0;
        ArcL Welds1{4}.position,vWeld{4},seam_TRob1,wd4,\Weave:=weave4,z0,tWeld1\WObj:=wobjWeldLine1\Track:=track0;
        SyncMoveOn wait{22},taskGroup123;
        ArcL offs(Welds1{5}.position,-0.3,0,0)\id:=50,vWeld{5},seam_TRob1,wd5,\Weave:=weave5,z0,tWeld1\WObj:=wobjWeldLine1\Track:=track0;
        ArcL offs(Welds1{5}.position,0,0,0)\id:=51,vWeld{5},seam_TRob1,wd5,\Weave:=weave5,z0,tWeld1\WObj:=wobjWeldLine1\Track:=track6;
        ArcL offs(Welds1{6}.position,0.3,0,0)\id:=60,vWeld{6},seam_TRob1,wd6,\Weave:=weave6,z0,tWeld1\WObj:=wobjWeldLine1\Track:=track6;
        ArcL offs(Welds1{6}.position,0.6,0,0)\id:=61,vWeld{6},seam_TRob1,wd6,\Weave:=weave6,z0,tWeld1\WObj:=wobjWeldLine1\Track:=track0;
        SyncMoveoff wait{23};
        ArcL offs(Welds1{7}.position,0,0,0),vWeld{7},seam_TRob1,wd7,\Weave:=weave7,z0,tWeld1\WObj:=wobjWeldLine1\Track:=track0;
        ArcL offs(Welds1{8}.position,0,0,0),vWeld{8},seam_TRob1,wd8,\Weave:=weave8,z0,tWeld1\WObj:=wobjWeldLine1\Track:=track0;
        ArcL offs(Welds1{9}.position,0,0,0),vWeld{9},seam_TRob1,wd9,\Weave:=weave9,z0,tWeld1\WObj:=wobjWeldLine1\Track:=track0;
        ArcLEnd offs(Welds1{10}.position,0,0,0),vWeld{10},seam_TRob1,wd10,\Weave:=weave10,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track0;
        ClkStop clockWeldTime;
        nclockWeldTime{1}:=ClkRead(clockWeldTime);
        MoveL RelTool(Welds1{10}.position,0,0,-10),vWeld{11},z0,tWeld1\WObj:=wobjWeldLine1;

        IDelete iArcError1;

        ConfL\On;
        stReact{1}:="WeldOk";
        WaitUntil stCommand="";
        stReact{1}:="Ready";
    ERROR
        rArcError;
        !IF ERRNO=ERR_PATH_STOP THEN
            !rArcError;
        !ENDIF
    ENDPROC


    PROC rWireCut()
        VAR jointtarget jTepmCut{10};
        VAR robtarget pTemp_WireCut;
        VAR speeddata vTempFast;
        VAR speeddata vTempSlow;

        vTempFast:=[nWireCutSpeed,500,nWireCutSpeed,100];
        vTempSlow:=[nWireCutSpeed/3,500,nWireCutSpeed/3,100];
        PulseDO\PLength:=nInchingTime,soAwManFeedFwd;
        Reset do09_Wire_Cutter_Close;
        Set do10_Wire_Cutter_Open;
        jWireCut4.robax:=[90,90,-50,0,0,0];
        MoveAbsJ jWireCut4\NoEOffs,vTempFast,z100,tWeld1;
        MoveAbsJ jWireCut3\NoEOffs,vTempFast,z100,tWeld1;
        MoveAbsJ jWireCut2\NoEOffs,vTempFast,z100,tWeld1;
        MoveAbsJ jWireCut1\NoEOffs,vTempFast,z10,tWeld1;
        WaitRob\ZeroSpeed;
        WaitTime 0.3;
        pTemp_WireCut:=CalcRobT(jWireCut0,tWeld1\WObj:=wobjRotCtr1);
        IF bNozzleCleanCut=TRUE MoveL Offs(pTemp_WireCut,0,0,10),vTempSlow,z0,tWeld1\WObj:=wobjRotCtr1;
        IF bNozzleCleanCut=FALSE MoveL Offs(pTemp_WireCut,0,0,0),vTempSlow,z0,tWeld1\WObj:=wobjRotCtr1;
        IF bWireCutSync=TRUE WaitSyncTask Wait{90},taskGroup12;
        WaitRob\ZeroSpeed;
        WaitTime 0.5;
        Reset do10_Wire_Cutter_Open;
        PulseDO\PLength:=1,do09_Wire_Cutter_Close;
        WaitTime 0.5;
        PulseDO\PLength:=1,do10_Wire_Cutter_Open;
        WaitTime 1;
        MoveAbsJ jWireCut1\NoEOffs,vTempSlow,z100,tWeld1;
        WaitRob\ZeroSpeed;
        MoveAbsJ jWireCut2\NoEOffs,vTempFast,z100,tWeld1;
        MoveAbsJ jWireCut3\NoEOffs,vTempFast,z100,tWeld1;
        MoveAbsJ jWireCut4\NoEOffs,vTempFast,z0,tWeld1;
        WaitRob\ZeroSpeed;
        Reset do10_Wire_Cutter_Open;
        stReact{1}:="WireCutOk";
        WaitUntil stCommand="";
        stReact{1}:="Ready";
        WaitUntil stReact=["Ready","Ready","Ready"];
        RETURN ;
    ENDPROC

    PROC rWireCutMove()
        VAR jointtarget jTepmCut{10};
        VAR robtarget pTemp_WireCut;
        VAR speeddata vTempFast;
        VAR speeddata vTempSlow;
        vTempFast:=[nWireCutSpeed,500,nWireCutSpeed,100];
        vTempSlow:=[nWireCutSpeed/3,500,nWireCutSpeed/3,100];
        PulseDO\PLength:=nInchingTime,soAwManFeedFwd;
        Reset do09_Wire_Cutter_Close;
        Set do10_Wire_Cutter_Open;
        !      WaitTime 2.25;
        MoveAbsJ jWireCut3\NoEOffs,vTempFast,z100,tWeld1;
        MoveAbsJ jWireCut2\NoEOffs,vTempFast,z100,tWeld1;
        MoveAbsJ jWireCut1\NoEOffs,vTempFast,z10,tWeld1;
        WaitRob\ZeroSpeed;
        WaitTime 0.3;
        pTemp_WireCut:=CalcRobT(jWireCut0,tWeld1\WObj:=wobjRotCtr1);
        IF bNozzleCleanCut=TRUE MoveL Offs(pTemp_WireCut,0,0,10),vTempSlow,z0,tWeld1\WObj:=wobjRotCtr1;
        IF bNozzleCleanCut=FALSE MoveL Offs(pTemp_WireCut,0,0,0),vTempSlow,z0,tWeld1\WObj:=wobjRotCtr1;
        IF bWireCutSync=TRUE WaitSyncTask Wait{90},taskGroup12;
        WaitRob\ZeroSpeed;
        WaitTime 0.5;
        Reset do10_Wire_Cutter_Open;
        PulseDO\PLength:=1,do09_Wire_Cutter_Close;
        WaitTime 0.5;
        PulseDO\PLength:=1,do10_Wire_Cutter_Open;
        WaitTime 1;
        MoveAbsJ jWireCut1\NoEOffs,vTempSlow,z100,tWeld1;
        WaitRob\ZeroSpeed;
        MoveAbsJ jWireCut2\NoEOffs,vTempFast,z100,tWeld1;
        IF bWirecut=[FALSE,TRUE,FALSE] THEN
            MoveAbsJ jWireCut3\NoEOffs,vTempFast,z100,tWeld1;
            jWireCut4.robax:=[40,90,-90,0,0,0];
            MoveAbsJ jWireCut4\NoEOffs,vTempFast,fine,tWeld1;
        ENDIF
        WaitRob\ZeroSpeed;
        Reset do10_Wire_Cutter_Open;
        stReact{1}:="WireCutOk";
        WaitUntil stCommand="";
        stReact{1}:="Ready";
        WaitUntil stReact=["Ready","Ready","Ready"];
        RETURN ;
    ENDPROC

    PROC rWireCutShot()
        VAR jointtarget jTepmCut{10};
        VAR speeddata vTempFast;
        VAR speeddata vTempSlow;
        vTempFast:=[nWireCutSpeed,500,nWireCutSpeed,100];
        vTempSlow:=[nWireCutSpeed/3,500,nWireCutSpeed/3,100];
        PulseDO\PLength:=nInchingTime,soAwManFeedFwd;
        Reset do09_Wire_Cutter_Close;
        Set do10_Wire_Cutter_Open;
        WaitTime nInchingTime;
        MoveAbsJ jWireCut1\NoEOffs,vTempFast,z10,tWeld1;
        WaitRob\ZeroSpeed;
        WaitTime 0.3;
        MoveAbsJ jWireCut0\NoEOffs,vTempSlow,z0,tWeld1;
        IF bWireCutSync=TRUE WaitSyncTask Wait{90},taskGroup12;
        WaitRob\ZeroSpeed;
        WaitTime 0.5;
        Reset do10_Wire_Cutter_Open;
        PulseDO\PLength:=1,do09_Wire_Cutter_Close;
        WaitTime 0.5;
        PulseDO\PLength:=1,do10_Wire_Cutter_Open;
        WaitTime 1;
        MoveAbsJ jWireCut1\NoEOffs,vTempSlow,z100,tWeld1;
        WaitRob\ZeroSpeed;
        MoveAbsJ jWireCut2\NoEOffs,vTempFast,z100,tWeld1;
        WaitRob\ZeroSpeed;
        Reset do10_Wire_Cutter_Open;
        stReact{1}:="WireCutOk";
        WaitUntil stCommand="";
        stReact{1}:="Ready";
        WaitUntil stReact=["Ready","Ready","Ready"];
        RETURN ;
    ENDPROC

    PROC rTeachingWireCut()
        VAR robtarget pTemp_WireCut;
        VAR speeddata vTempFast;
        VAR speeddata vTempSlow;
        vTempFast:=[nWireCutSpeed,500,nWireCutSpeed,100];
        vTempSlow:=[max(Max(pCuttingInsideOffset_R1.x,pCuttingInsideOffset_R1.y),pCuttingInsideOffset_R1.z),500,100,100];
        IF vTempSlow.v_tcp<0.1 vTempSlow.v_tcp:=50;
        pTemp_WireCut:=CalcRobT(jWireCut0,tWeld1\WObj:=wobjRotCtr1);
        MoveL Offs(pTemp_WireCut,pCuttingInsideOffset_R1.x,pCuttingInsideOffset_R1.y,pCuttingInsideOffset_R1.z),vTempSlow,fine,tWeld1\WObj:=wobjRotCtr1;
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

        pTemp_WireCut:=CalcRobT(jWireCut1,tWeld1\WObj:=wobjRotCtr1);
        MoveL Offs(pTemp_WireCut,pCuttingEntryOffset_R1.x,pCuttingEntryOffset_R1.y,pCuttingEntryOffset_R1.z),vTempSlow,fine,tWeld1\WObj:=wobjRotCtr1;
        WaitRob\InPos;
        WaitRob\ZeroSpeed;
        jWireCut1:=CJointT();

        RETURN ;
    ENDPROC    

    PROC rTrapNoWeldMove()
        VAR num i;
        VAR targetdata WeldsTemp;
        VAR robtarget pWeldTemp;
        VAR num nTempMmps;
        VAR speeddata vWeldTemp;
        IDelete inumMoveG_PosHold;
        StopMove;
        i:=nRunningStep{1};
        nTempMmps:=Welds1{i}.cpm/6;
        vWeldTemp:=[nTempMmps,200,200,200];

        pWeldTemp:=CRobT(\taskname:="T_ROB1"\Tool:=tWeld1\WObj:=wobjWeldLine1);
        StartMove;
        ConfL\Off;
        WHILE (so_MoveG_PosHold=1) DO
            nTrapCheck_1:=2;
            MoveL Offs(pWeldTemp,0,0,0),vWeldTemp,fine,tWeld1\WObj:=wobjWeldLine1;
            MoveL Offs(pWeldTemp,0,0,0),vWeldTemp,fine,tWeld1\WObj:=wobjWeldLine1;
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
        ISignalDO intTouch_1,1,iErrorDuringEntry;
        ISleep iErrorDuringEntry;

        bInstalldir:=bRobSwap;
        IF bRobSwap=FALSE THEN
            edgestartBuffer1:=edgeStart{1};
            edgeEndBuffer1:=edgeEnd{1};
        ELSE
            edgestartBuffer1:=edgeStart{2};
            edgeEndBuffer1:=edgeEnd{2};
        ENDIF
        WaitRob\ZeroSpeed;
        IF nMode=1 THEN
            WaitSyncTask Wait{20},taskGroup13;
        ELSEIF nMode=2 THEN
            WaitSyncTask Wait{20},taskGroup23;
        ELSE
            WaitSyncTask Wait{20},taskGroup123;
        ENDIF

        WaitUntil bGanTry_Last_pos=TRUE;

        IF edgeEndBuffer1.Breadth<7 edgeEndBuffer1.Breadth:=7;
        IF edgeEndBuffer1.height<7 edgeEndBuffer1.height:=7;

        nCorrFailOffs_Z:=10*nEntryRetryCount{1};
        IF bRobSwap=TRUE nCorrFailOffs_Y:=(10*nEntryRetryCount{1});
        IF bRobSwap=FALSE nCorrFailOffs_Y:=(10*nEntryRetryCount{1});

        WHILE bTouch_last_R1_Comp=FALSE DO
            TEST nMacro001{1}
            CASE 0,1,2,3,4,5,8:
                IF edgeEndBuffer1.Breadth<edgeEndBuffer1.Height THEN
                    ! Setting Conditions
                    IF nMacro001{1}=0 OR nMacro001{1}=1 OR nMacro001{1}=2 OR nMacro001{1}=5 n_X:=-15+(nSameSpot_EndX_R1*(-1));
                    IF nMacro001{1}=1 n_X:=-50;
                    IF nMacro001{1}=4 n_X:=0;

                    n_Y:=corrEnd{nMacro001{1}+1}.Y_StartOffset+nEndThick+nCorrFailOffs_Y+nSameSpot_EndY_R1;
                    n_Ret_Y:=TouchLimit(corrEnd{nMacro001{1}+1}.Y_ReturnLength,edgeEndBuffer1.Breadth);
                    n_Ret_Z:=TouchLimit(corrEnd{nMacro001{1}+1}.Z_ReturnLength,edgeEndBuffer1.Height);
                    n_Z:=TouchLimit(corrEnd{nMacro001{1}+1}.Z_StartOffset,edgeEndBuffer1.Height)+nCorrFailOffs_Z+nSameSpot_EndZ_R1;

                    ! Touch Entry Location================================================================
                    IWatch iErrorDuringEntry;

                    rCheckWelder;

                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir\LIN;
                    Reset soLn1Touch;
                    IDelete iErrorDuringEntry;
                    nEntryRetryCount{1}:=0;
                    !                IF bTouchWorkCount1{3}=TRUE GOTO TouchComplete_End_Y;
                    WaitTime 0;
                    !                 rCheckTouchAtStart;
                    !=====================================================================================
                    ! edge_Y
                    IF bTouchWorkCount1{1}=FALSE THEN
                        rCorrSearchWeldLineEdgeY n_X,n_Y,n_Z,corrEnd{nMacro001{1}+1}.Y_Depth+nCorrFailOffs_Y+nEndThick,n_Ret_Y,bEnd,bInstalldir,"End_Y";
                        bTouchWorkCount1{1}:=TRUE;
                        nTouchRetryCount{1}:=0;
                    ENDIF

                    ! edge_Z
                    IF bTouchWorkCount1{2}=FALSE THEN
                        !                 Setting Conditions
                        n_Y:=n_Ret_Y;
                        n_Ret_Z:=TouchLimit(corrEnd{nMacro001{1}+1}.Z_ReturnLength,edgeEndBuffer1.Height);

                        rCorrSearchWeldLineEdgeZ n_X,n_Y,n_Z,corrEnd{nMacro001{1}+1}.Z_Depth+nCorrFailOffs_Z,n_Ret_Z,bEnd,bInstalldir,"End_Z";
                        bTouchWorkCount1{2}:=TRUE;
                        nTouchRetryCount{1}:=0;
                    ENDIF

                    ! Setting Conditions
                    n_Z:=n_Ret_Z;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;

                    IF nMacro001{1}=1 OR nMacro001{1}=4 GOTO TouchComplete_End_Y;
                    IF nMacro001{1}=2 OR nMacro001{1}=5 THEN
                        IF nMacro001{1}=5 n_Z:=edgeEndBuffer1.HoleSize+1;
                    ELSE
                        ! Setting Conditions
                        n_X:=corrEnd{nMacro001{1}+1}.X_StartOffset+(nSameSpot_EndX_R1*(-1));
                        rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;
                        ! Setting Conditions
                        n_Y:=-5;
                        rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;

                    ENDIF

                    ! edge_X
                    IF bTouchWorkCount1{3}=FALSE THEN
                        rCorrSearchWeldLineEdgeX n_X,n_Y,n_Z,corrEnd{nMacro001{1}+1}.X_Depth,corrEnd{nMacro001{1}+1}.X_ReturnLength,bEnd,bInstalldir,"End_X";
                        bTouchWorkCount1{3}:=TRUE;
                        nTouchRetryCount{1}:=0;
                    ENDIF
                    ! Setting Conditions
                    n_X:=corrEnd{nMacro001{1}+1}.X_ReturnLength+nSameSpot_EndX_R1;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,corrEnd{nMacro001{1}+1}.RY_Torch,0,nHeightBuffer,bEnd,bInstalldir;
                    ! Labal
                    TouchComplete_End_Y:
                    ! Setting Conditions
                    n_Y:=n_Ret_Y+corrEnd{nMacro001{1}+1}.Y_MoveCorrConnect;
                    n_Z:=n_Z+corrEnd{nMacro001{1}+1}.Z_MoveCorrConnect;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,corrEnd{nMacro001{1}+1}.RY_Torch+n_Angle,0,nHeightBuffer,bEnd,bInstalldir;

                ELSE

                    ! Setting Conditions
                    IF nMacro001{1}=0 OR nMacro001{1}=1 OR nMacro001{1}=2 OR nMacro001{1}=5 n_X:=-15+(nSameSpot_EndX_R1*(-1));
                    IF nMacro001{1}=1 n_X:=-50;
                    IF nMacro001{1}=4 n_X:=0;
                    n_Y:=TouchLimit(corrEnd{nMacro001{1}+1}.Y_StartOffset+nEndThick,edgeEndBuffer1.Breadth)+nCorrFailOffs_Y+nSameSpot_EndY_R1;
                    n_Ret_Y:=TouchLimit(corrEnd{nMacro001{1}+1}.Y_ReturnLength,edgeEndBuffer1.Breadth);
                    n_Ret_Z:=TouchLimit(corrEnd{nMacro001{1}+1}.Z_ReturnLength,edgeEndBuffer1.Height);
                    n_Z:=corrEnd{nMacro001{1}+1}.Z_StartOffset+nCorrFailOffs_Z+nSameSpot_EndZ_R1;

                    IWatch iErrorDuringEntry;

                    rCheckWelder;

                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir\LIN;
                    Reset soLn1Touch;
                    IDelete iErrorDuringEntry;
                    nEntryRetryCount{1}:=0;
                    !                IF bTouchWorkCount1{3}=TRUE GOTO TouchComplete_End_Z;
                    WaitTime 0;
                    !    rCheckTouchAtStart;

                    ! edge_Z
                    IF bTouchWorkCount1{1}=FALSE THEN
                        rCorrSearchWeldLineEdgeZ n_X,n_Y,n_Z,corrEnd{nMacro001{1}+1}.Z_Depth+nCorrFailOffs_Z,n_Ret_Z,bEnd,bInstalldir,"End_Z";
                        bTouchWorkCount1{1}:=TRUE;
                        nTouchRetryCount{1}:=0;
                    ENDIF

                    ! edge_Y
                    IF bTouchWorkCount1{2}=FALSE THEN
                        ! Setting Conditions
                        n_Ret_Y:=TouchLimit(corrEnd{nMacro001{1}+1}.Y_ReturnLength,edgeEndBuffer1.Breadth);
                        n_Z:=n_Ret_Z;
                        rCorrSearchWeldLineEdgeY n_X,n_Y,n_Z,corrEnd{nMacro001{1}+1}.Y_Depth+nCorrFailOffs_Y+nEndThick,n_Ret_Y,bEnd,bInstalldir,"End_Y";
                        bTouchWorkCount1{2}:=TRUE;
                        nTouchRetryCount{1}:=0;
                    ENDIF

                    ! Setting Conditions
                    n_Y:=n_Ret_Y;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;

                    IF nMacro001{1}=1 OR nMacro001{1}=4 GOTO TouchComplete_End_Z;
                    IF nMacro001{1}=2 OR nMacro001{1}=5 THEN
                        IF nMacro001{1}=5 n_Z:=edgeEndBuffer1.HoleSize+1;
                    ELSE

                        ! Setting Conditions
                        n_X:=corrEnd{nMacro001{1}+1}.X_StartOffset+(nSameSpot_EndZ_R1*(-1));
                        rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;
                        ! Setting Conditions
                        n_Y:=-5;
                        rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;

                    ENDIF

                    ! edge_X
                    IF bTouchWorkCount1{3}=FALSE THEN
                        rCorrSearchWeldLineEdgeX n_X,n_Y,n_Z,corrEnd{nMacro001{1}+1}.X_Depth,corrEnd{nMacro001{1}+1}.X_ReturnLength,bEnd,bInstalldir,"End_X";
                        bTouchWorkCount1{3}:=TRUE;
                        nTouchRetryCount{1}:=0;
                    ENDIF

                    ! Setting Conditions
                    n_X:=corrEnd{nMacro001{1}+1}.X_ReturnLength+nSameSpot_EndX_R1;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,corrEnd{nMacro001{1}+1}.RY_Torch,0,nHeightBuffer,bEnd,bInstalldir;
                    ! Labal
                    TouchComplete_End_Z:
                    ! Setting Conditions
                    n_Y:=n_Ret_Y+corrEnd{nMacro001{1}+1}.Y_MoveCorrConnect;
                    n_Z:=n_Z+corrEnd{nMacro001{1}+1}.Z_MoveCorrConnect;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,corrEnd{nMacro001{1}+1}.RY_Torch+n_Angle,0,nHeightBuffer,bEnd,bInstalldir;
                ENDIF

                IF edgeEndBuffer1.AngleWidth>0 THEN
                    rMoveCorrConnect n_X,n_Y+30,n_Z,0,corrEnd{nMacro001{1}+1}.RY_Torch+n_Angle,0,nHeightBuffer,bEnd,bInstalldir;
                ENDIF


                IF nMacro001{1}=3 OR nMacro001{1}=4 OR nMacro001{1}=8 THEN
                    !   IF bEndSearchComplete=FALSE pCorredSplitPos:=ConvertPosWeldLineToFloor(pSearchStart1,nWeldLineLength+nCorrX_Store_End,nCorrY_Store_End,nCorrZ_Store_End);
                ENDIF
            CASE 9:
                !   pCorredEndPos:=pCorredSplitPos;
            DEFAULT:
                Stop;
                Stop;
                ExitCycle;
            ENDTEST

            bTouch_last_R1_Comp:=TRUE;
            bTouch_First_R1_Comp:=FALSE;
            ! sp 2026,01,26
            pCorrTemp_End{1}:=CRobT(\TaskName:="T_ROB1"\Tool:=tWeld1\WObj:=wobjWeldLine1);
            pCorrTemp_End{1}.trans:=[nWeldLineLength_R1+nCorrX_Store_End{1},nCorrY_Store_End{1},nCorrZ_Store_End{1}];
            jCorrTemp_End{1}:=CalcJointT(pCorrTemp_End{1},tWeld1\WObj:=wobjWeldLine1);
            pCorrT_ROB1_End:=CalcRobT(jCorrTemp_End{1},Tool:=tWeld1\WObj:=wobjRotCtr1);
        ENDWHILE
        reSet soLn1Touch;
        waittime 0.2;
        IDelete innumTouchErrorWhilMoving;
        IF nTouchWhileMovingCount_R1>0 THEN
            IWatch iErrorDuringEntry;

            Set soLn1Touch;
            nTouchWhileMovingCount_R1:=0;
        ELSE
            CONNECT innumTouchErrorWhilMoving WITH trapTouchErrorWhilMoving;
            ISignalDI siLn1Current,1,innumTouchErrorWhilMoving;
            Set soLn1Touch;
            nTouchWhileMovingCount_R1:=0;
        ENDIF
        WaitUntil bGanTry_First_pos=TRUE AND bTouch_last_R2_Comp=TRUE;

        !!! Start correctioning from start edge !!!

        IF edgestartBuffer1.Breadth<7 edgestartBuffer1.Breadth:=7;
        IF edgestartBuffer1.Height<7 edgestartBuffer1.Height:=7;

        TEST nMacro010{1}
        CASE 0,1,2,3,4,5:
            IF edgestartBuffer1.Breadth<edgestartBuffer1.Height THEN

                ! Setting Conditions
                IF nMacro010{1}=0 OR nMacro010{1}=1 OR nMacro010{1}=2 OR nMacro010{1}=5 n_X:=-15+(nSameSpot_StartX_R1*(-1));
                IF nMacro010{1}=1 n_X:=-50;
                IF nMacro010{1}=4 n_X:=0;
                n_Y:=corrStart{nMacro010{1}+1}.Y_StartOffset+nStartThick+nCorrFailOffs_Y+nSameSpot_StartY_R1;
                n_Ret_Y:=TouchLimit(corrStart{nMacro010{1}+1}.Y_ReturnLength,edgestartBuffer1.Breadth);
                n_Z:=TouchLimit(corrStart{nMacro010{1}+1}.Z_StartOffset,edgestartBuffer1.Height)+nCorrFailOffs_Z+nSameSpot_StartZ_R1;
                n_Ret_Z:=TouchLimit(corrStart{nMacro010{1}+1}.Z_ReturnLength,edgestartBuffer1.Height);

                IF edgeEndBuffer1.AngleWidth>0 THEN
                    rMoveCorrConnect n_X,n_Y+30+corrStart{nMacro010{1}+1}.Y_MoveCorrConnect,n_Z+corrStart{nMacro010{1}+1}.Z_MoveCorrConnect,0,corrStart{nMacro010{1}+1}.RY_Torch+n_Angle,0,nHeightBuffer,bStart,bInstalldir\LIN;
                ENDIF
                ! edge_Y
                rMoveCorrConnect n_X,n_Y+corrStart{nMacro010{1}+1}.Y_MoveCorrConnect,n_Z+corrStart{nMacro010{1}+1}.Z_MoveCorrConnect,0,corrStart{nMacro010{1}+1}.RY_Torch+n_Angle,0,nHeightBuffer,bStart,bInstalldir\LIN;
                Reset soLn1Touch;
                IDelete iErrorDuringEntry;
                nEntryRetryCount{1}:=0;
                IDelete innumTouchErrorWhilMoving;
                reSet soLn1Touch;
                IF nTouchWhileMovingCount_R1>=1 rTouchErrorWhilMovingHandling;
                WaitTime 0;

                IF bTouchWorkCount1{4}=FALSE THEN
                    rCorrSearchWeldLineEdgeY n_X,n_Y,n_Z,corrStart{nMacro010{1}+1}.Y_Depth+nCorrFailOffs_Y+nStartThick,n_Ret_Y,bStart,bInstalldir,"Start_Y";
                    bTouchWorkCount1{4}:=TRUE;
                    nTouchRetryCount{1}:=0;
                ENDIF

                ! edge_Z
                IF bTouchWorkCount1{5}=FALSE THEN
                    ! Setting Conditions
                    n_Y:=n_Ret_Y;
                    n_Ret_Z:=TouchLimit(corrStart{nMacro010{1}+1}.Z_ReturnLength,edgestartBuffer1.Height);
                    rCorrSearchWeldLineEdgeZ n_X,n_Y,n_Z,corrStart{nMacro010{1}+1}.Z_Depth+nCorrFailOffs_Z,n_Ret_Z,bStart,bInstalldir,"Start_Z";
                    bTouchWorkCount1{5}:=TRUE;
                    nTouchRetryCount{1}:=0;
                ENDIF

                ! Setting Conditions
                n_Z:=n_Ret_Z;
                rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;

                IF nMacro010{1}=1 OR nMacro010{1}=4 GOTO TouchComplete_Start_Y;
                IF nMacro010{1}=2 OR nMacro010{1}=5 THEN
                    IF nMacro010{1}=5 n_Z:=edgestartBuffer1.HoleSize+1;
                ELSE

                    ! Setting Conditions
                    n_X:=corrStart{nMacro010{1}+1}.X_StartOffset+(nSameSpot_StartX_R1*(-1));
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;
                    ! Setting Conditions
                    n_Y:=-5;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;
                ENDIF
                !    ENDIF

                ! edge_X
                IF bTouchWorkCount1{6}=FALSE THEN
                    rCorrSearchWeldLineEdgeX n_X,n_Y,n_Z,corrStart{nMacro010{1}+1}.X_Depth,corrStart{nMacro010{1}+1}.X_ReturnLength,bStart,bInstalldir,"Start_X";
                    bTouchWorkCount1{6}:=TRUE;
                    nTouchRetryCount{1}:=0;
                ENDIF
                ! Setting Conditions
                n_X:=corrStart{nMacro010{1}+1}.X_ReturnLength+nSameSpot_StartX_R1;
                rMoveCorrConnect n_X,n_Y,n_Z,0,corrStart{nMacro010{1}+1}.RY_Torch,0,nHeightBuffer,bStart,bInstalldir;
                ! Labal
                TouchComplete_Start_Y:
            ELSE

                ! Setting Conditions
                IF nMacro010{1}=0 OR nMacro010{1}=1 OR nMacro010{1}=2 OR nMacro010{1}=5 n_X:=-15+(nSameSpot_StartX_R1*(-1));
                IF nMacro010{1}=1 n_X:=-50;
                IF nMacro010{1}=4 n_X:=0;
                n_Y:=TouchLimit(corrStart{nMacro010{1}+1}.Y_StartOffset+nStartThick,edgestartBuffer1.Breadth)+nCorrFailOffs_Y+nSameSpot_StartY_R1;
                n_Ret_Y:=TouchLimit(corrStart{nMacro010{1}+1}.Y_ReturnLength,edgestartBuffer1.Breadth);
                n_Ret_Z:=TouchLimit(corrStart{nMacro010{1}+1}.Z_ReturnLength,edgestartBuffer1.Height);
                n_Z:=corrStart{nMacro010{1}+1}.Z_StartOffset+nCorrFailOffs_Z+nSameSpot_StartZ_R1;

                IF edgeEndBuffer1.AngleWidth>0 THEN
                    rMoveCorrConnect n_X,n_Y+30+corrStart{nMacro010{1}+1}.Y_MoveCorrConnect,n_Z+corrStart{nMacro010{1}+1}.Z_MoveCorrConnect,0,corrStart{nMacro010{1}+1}.RY_Torch+n_Angle,0,nHeightBuffer,bStart,bInstalldir\LIN;
                ENDIF
                rMoveCorrConnect n_X,n_Y+corrStart{nMacro010{1}+1}.Y_MoveCorrConnect,n_Z+corrStart{nMacro010{1}+1}.Z_MoveCorrConnect,0,corrStart{nMacro010{1}+1}.RY_Torch+n_Angle,0,nHeightBuffer,bStart,bInstalldir\LIN;
                Reset soLn1Touch;
                IDelete iErrorDuringEntry;
                nEntryRetryCount{1}:=0;
                IDelete innumTouchErrorWhilMoving;
                reSet soLn1Touch;
                IF nTouchWhileMovingCount_R1>=1 rTouchErrorWhilMovingHandling;
                WaitTime 0;
                ! edge_Z
                IF bTouchWorkCount1{4}=FALSE THEN
                    rCorrSearchWeldLineEdgeZ n_X,n_Y,n_Z,corrStart{nMacro010{1}+1}.Z_Depth+nCorrFailOffs_Z,n_Ret_Z,bStart,bInstalldir,"Start_Z";
                    bTouchWorkCount1{4}:=TRUE;
                    nTouchRetryCount{1}:=0;
                ENDIF
                ! Setting Conditions


                ! edge_Y
                IF bTouchWorkCount1{5}=FALSE THEN
                    ! Setting Conditions
                    n_Ret_Y:=TouchLimit(corrStart{nMacro010{1}+1}.Y_ReturnLength,edgestartBuffer1.Breadth);
                    n_Z:=n_Ret_Z;
                    rCorrSearchWeldLineEdgeY n_X,n_Y,n_Z,corrStart{nMacro010{1}+1}.Y_Depth+nCorrFailOffs_Y+nStartThick,n_Ret_Y,bStart,bInstalldir,"Start_Y";
                    bTouchWorkCount1{5}:=TRUE;
                    nTouchRetryCount{1}:=0;
                ENDIF

                ! Setting Conditions
                n_Y:=n_Ret_Y;
                rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;

                IF nMacro010{1}=1 OR nMacro010{1}=4 GOTO TouchComplete_Start_Z;
                IF nMacro010{1}=2 OR nMacro010{1}=5 THEN
                    IF nMacro010{1}=5 n_Z:=edgestartBuffer1.HoleSize+1;
                ELSE
                    !    IF bTouchWorkCount1{6}=FALSE THEN
                    ! Setting Conditions
                    n_X:=corrStart{nMacro010{1}+1}.X_StartOffset+(nSameSpot_StartX_R1*(-1));
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;
                    ! Setting Conditions
                    n_Y:=-5;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;
                ENDIF
                ! ENDIF

                ! edge_X
                IF bTouchWorkCount1{6}=FALSE THEN
                    rCorrSearchWeldLineEdgeX n_X,n_Y,n_Z,corrStart{nMacro010{1}+1}.X_Depth,corrStart{nMacro010{1}+1}.X_ReturnLength,bStart,bInstalldir,"Start_X";
                    bTouchWorkCount1{6}:=TRUE;
                    nTouchRetryCount{1}:=0;
                ENDIF
                ! Setting Conditions
                n_X:=corrStart{nMacro010{1}+1}.X_ReturnLength+nSameSpot_StartX_R1;
                rMoveCorrConnect n_X,n_Y,n_Z,0,corrStart{nMacro010{1}+1}.RY_Torch,0,nHeightBuffer,bStart,bInstalldir;

                ! Labal
                TouchComplete_Start_Z:
            ENDIF

        DEFAULT:
            Stop;
            Stop;
            ExitCycle;
        ENDTEST

        pTemp:=CRobT(\TaskName:="T_ROB1"\Tool:=tWeld1\WObj:=wobjWeldLine1);
        WaitRob\ZeroSpeed;
        MoveL RelTool(pTemp,0,0,-15),vTargetSpeed,zTargetZone,tWeld1\WObj:=wobjWeldLine1;

        bTouch_First_R1_Comp:=TRUE;
        bTouch_last_R1_Comp:=TRUE;

        WaitUntil bTouch_First_R2_Comp=TRUE;

        pCorrTemp_Start{1}:=CRobT(\TaskName:="T_ROB1"\Tool:=tWeld1\WObj:=wobjWeldLine1);
        pCorrTemp_Start{1}.trans:=[nCorrX_Store_Start{1},nCorrY_Store_Start{1},nCorrZ_Store_Start{1}];
        jCorrTemp_Start{1}:=CalcJointT(pCorrTemp_Start{1},tWeld1\WObj:=wobjWeldLine1);
        pCorrT_ROB1_Start:=CalcRobT(jCorrTemp_Start{1},Tool:=tWeld1\WObj:=wobjRotCtr1);
        nSearchBuffer_X_Start{1}:=nCorrX_Store_Start{1};
        nSearchBuffer_Y_Start{1}:=nCorrY_Store_Start{1};
        nSearchBuffer_Z_Start{1}:=nCorrZ_Store_Start{1};
        nSearchBuffer_X_End{1}:=nCorrX_Store_End{1};
        nSearchBuffer_Y_End{1}:=nCorrY_Store_End{1};
        nSearchBuffer_Z_End{1}:=nCorrZ_Store_End{1};
        WaitTime 0.2;
        stReact{1}:="CorrSearchOK";
        WaitUntil stCommand="";
        stReact{1}:="Ready";
        nCorrFailOffs_Y:=0;
        nCorrFailOffs_Z:=0;
        nCorrX_Store_Start{1}:=0;
        nCorrY_Store_Start{1}:=0;
        nCorrZ_Store_Start{1}:=0;
        nCorrX_Store_End{1}:=0;
        nCorrY_Store_End{1}:=0;
        nCorrZ_Store_End{1}:=0;
    ENDPROC

    PROC rMoveCorrConnect(num X,num Y,num Z,num Rx,num Ry,num Rz,num EAX_D,bool isStartPos,bool CCW,\switch LIN)
        VAR robtarget pTempConnect;
        VAR num nCorrX_Store;
        VAR num nCorrY_Store;
        VAR num nCorrZ_Store;

        IF (isStartPos=bStart) THEN
            nCorrX_Store:=nCorrX_Store_Start{1};
            nCorrY_Store:=nCorrY_Store_Start{1};
            nCorrZ_Store:=nCorrZ_Store_Start{1};
        ELSE
            nCorrX_Store:=nCorrX_Store_End{1};
            nCorrY_Store:=nCorrY_Store_End{1};
            nCorrZ_Store:=nCorrZ_Store_End{1};
        ENDIF


        pTempConnect:=pNull;
        pTempConnect.robconf:=[0,0,0,1];

        IF isStartPos=bStart THEN
            IF CCW=FALSE THEN
                pTempConnect.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
                pTempConnect.rot:=[0.5,0.5,-0.5,0.5];
                pTempConnect:=RelTool(pTempConnect,0,0,0\Rx:=-1*macroStartBuffer1{1}.TravelAngle\Ry:=-1*macroStartBuffer1{1}.WorkingAngle+nBreakPoint{1});
            ELSE
                pTempConnect.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(-1*Y),nCorrZ_Store+(Z)];
                pTempConnect.rot:=[0.5,-0.5,-0.5,-0.5];
                pTempConnect:=RelTool(pTempConnect,0,0,0\Rx:=macroStartBuffer1{1}.TravelAngle\Ry:=-1*macroStartBuffer1{1}.WorkingAngle+nBreakPoint{1});

            ENDIF
        ELSEIF isStartPos=bEnd THEN
            IF CCW=FALSE THEN
                pTempConnect.trans:=[nWeldLineLength_R1+nCorrX_Store+(X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
                pTempConnect.rot:=[0.5,0.5,-0.5,0.5];
                pTempConnect:=RelTool(pTempConnect,0,0,0\Rx:=-1*macroEndBuffer1{nMotionEndStepLast{1}}.TravelAngle\Ry:=-1*macroEndBuffer1{nMotionEndStepLast{1}}.WorkingAngle+nBreakPoint{1});
            ELSE
                pTempConnect.trans:=[nWeldLineLength_R1+nCorrX_Store+(X),nCorrY_Store+(-1*Y),nCorrZ_Store+(Z)];
                pTempConnect.rot:=[0.5,-0.5,-0.5,-0.5];
                pTempConnect:=RelTool(pTempConnect,0,0,0\Rx:=macroEndBuffer1{nMotionEndStepLast{1}}.TravelAngle\Ry:=-1*macroEndBuffer1{nMotionEndStepLast{1}}.WorkingAngle+nBreakPoint{1});
            ENDIF
        ENDIF

        IF Present(LIN)=FALSE THEN
            MoveJ pTempConnect,v300,fine,tWeld1\WObj:=wobjWeldLine1;
        ELSE
            MoveL pTempConnect,v300,fine,tWeld1\WObj:=wobjWeldLine1;
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
            nCorrX_Store:=nCorrX_Store_Start{1};
            nCorrY_Store:=nCorrY_Store_Start{1};
            nCorrZ_Store:=nCorrZ_Store_Start{1};
        ELSE
            nCorrX_Store:=nCorrX_Store_End{1};
            nCorrY_Store:=nCorrY_Store_End{1};
            nCorrZ_Store:=nCorrZ_Store_End{1};
        ENDIF

        TouchErrorDirSub:=dirErrorCheck;
        IF TouchErrorDirMain=dirErrorCheck AND 0<nTouchRetryCount{1} THEN
            IF (isStartPos=bEnd AND (nMacro001{1}=2 OR nMacro001{1}=5)) OR (isStartPos=bStart AND (nMacro010{1}=2 OR nMacro010{1}=5)) THEN
                Depth:=Depth+((RetryDepthData{1}*(-1))*nTouchRetryCount{1});
            ELSE
                Depth:=Depth+(RetryDepthData{1}*nTouchRetryCount{1});
            ENDIF
        ENDIF
        !!! Search weld X edge !!!
        WaitUntil bRobSwap=CCW;
        IF (isStartPos=bStart) THEN
            pSearchStart1.rot:=Welds1{1}.position.rot;
            IF (CCW=FALSE) pSearchStart1.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart1.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(-1*Y),nCorrZ_Store+(Z)];
        ELSEIF (isStartPos=bEnd) THEN
            pSearchStart1.rot:=Welds1{nMotionStepCount{1}}.position.rot;
            IF (CCW=FALSE) pSearchStart1.trans:=[nWeldLineLength_R1+nCorrX_Store+(X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart1.trans:=[nWeldLineLength_R1+nCorrX_Store+(X),nCorrY_Store+(-1*Y),nCorrZ_Store+(Z)];
        ENDIF

        pSearchStart1.robconf.cfx:=1;
        pSearchStart1.extax:=[9e9,9e9,9e9,9e9,9e9,9e9];

        pSearchEnd1:=pSearchStart1;
        IF (isStartPos=bStart) pSearchEnd1.trans.x:=pSearchStart1.trans.x+Depth;
        IF (isStartPos=bEnd) pSearchEnd1.trans.x:=pSearchStart1.trans.x-Depth;

        bTouchOnSameSpotError_R1:=FALSE;
        pComparison:=CRobT(\Tool:=tWeld1\WObj:=wobjWeldLine1);
        rCorrSearchByWire pSearchStart1,pSearchEnd1\X;
        nComparison:=VectMagn(pCorredPosBuffer1-pComparison.trans);
        IF nComparison<4 THEN
            bTouchOnSameSpotError_R1:=TRUE;
            IF (isStartPos=bStart) THEN
                nSameSpot_StartX_R1:=nSameSpot_StartX_R1+10;
            ELSE
                nSameSpot_EndX_R1:=nSameSpot_EndX_R1+10;
            ENDIF
            rTouchOnSameSpotErrorHandling;
        ELSE
            bTouchOnSameSpotError_R1:=FALSE;
            IF (isStartPos=bStart) THEN
                nSameSpot_StartX_R1:=0;
            ELSE
                nSameSpot_EndX_R1:=0;
            ENDIF
        ENDIF
        !        pCheckBuffer{1}.trans:=pCorredPosBuffer1;

        IF (isStartPos=bStart) nCorrX_Store:=pCorredPosBuffer1.x;
        IF (isStartPos=bEnd) nCorrX_Store:=pCorredPosBuffer1.x-nWeldLineLength_R1;

        IF (isStartPos=bStart) THEN
            nCorrX_Store_Start{1}:=nCorrX_Store;
            nCorrY_Store_Start{1}:=nCorrY_Store;
            nCorrZ_Store_Start{1}:=nCorrZ_Store;
        ELSE
            nCorrX_Store_End{1}:=nCorrX_Store;
            nCorrY_Store_End{1}:=nCorrY_Store;
            nCorrZ_Store_End{1}:=nCorrZ_Store;
        ENDIF

        rMoveCorrConnect RetX,Y,Z,0,0,0,pSearchStart1.extax.eax_d,isStartPos,CCW;
        nTouchRetryCount{1}:=0;
        TouchErrorDirMain:="Ready";

        RETURN ;
    ENDPROC

    PROC rCorrSearchWeldLineEdgeY(num X,num Y,num Z,num Depth,num RetY,bool isStartPos,bool CCW,string dirErrorCheck)
        VAR num nCorrX_Store;
        VAR num nCorrY_Store;
        VAR num nCorrZ_Store;
        VAR num nComparison;
        VAR robtarget pComparison;
        WaitUntil bRobSwap=CCW;
        IF (isStartPos=bStart) THEN
            nCorrX_Store:=nCorrX_Store_Start{1};
            nCorrY_Store:=nCorrY_Store_Start{1};
            nCorrZ_Store:=nCorrZ_Store_Start{1};
        ELSE
            nCorrX_Store:=nCorrX_Store_End{1};
            nCorrY_Store:=nCorrY_Store_End{1};
            nCorrZ_Store:=nCorrZ_Store_End{1};
        ENDIF

        TouchErrorDirSub:=dirErrorCheck;
        IF (TouchErrorDirMain=dirErrorCheck AND 0<nTouchRetryCount{1}) Depth:=Depth+(RetryDepthData{2}*nTouchRetryCount{1});

        !!! Search weld Y edge !!!
        WaitUntil bRobSwap=CCW;
        IF (isStartPos=bStart) THEN
            pSearchStart1.rot:=Welds1{1}.position.rot;
            IF (CCW=FALSE) pSearchStart1.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart1.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(-1*Y),nCorrZ_Store+Z];
        ELSEIF (isStartPos=bEnd) THEN
            pSearchStart1.rot:=Welds1{nMotionStepCount{1}}.position.rot;
            IF (CCW=FALSE) pSearchStart1.trans:=[nWeldLineLength_R1+nCorrX_Store+(X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart1.trans:=[nWeldLineLength_R1+nCorrX_Store+(X),nCorrY_Store+(-1*Y),nCorrZ_Store+(Z)];
        ENDIF

        pSearchStart1.robconf.cfx:=1;

        pSearchEnd1:=pSearchStart1;
        pSearchStart1.extax:=[9e9,9e9,9e9,9e9,9e9,9e9];
        IF (CCW=FALSE) pSearchEnd1.trans.y:=pSearchStart1.trans.y-Depth;
        IF (CCW=TRUE) pSearchEnd1.trans.y:=pSearchStart1.trans.y+Depth;
        bTouchOnSameSpotError_R1:=FALSE;
        pComparison:=CRobT(\Tool:=tWeld1\WObj:=wobjWeldLine1);
        rCorrSearchByWire pSearchStart1,pSearchEnd1\Y;
        nComparison:=VectMagn(pCorredPosBuffer1-pComparison.trans);
        IF nComparison<4 THEN
            bTouchOnSameSpotError_R1:=TRUE;
            IF (isStartPos=bStart) THEN
                nSameSpot_StartY_R1:=nSameSpot_StartY_R1+10;
            ELSE
                nSameSpot_EndY_R1:=nSameSpot_EndY_R1+10;
            ENDIF
            rTouchOnSameSpotErrorHandling;
        ELSE
            bTouchOnSameSpotError_R1:=FALSE;
            IF (isStartPos=bStart) THEN
                nSameSpot_StartY_R1:=0;
            ELSE
                nSameSpot_EndY_R1:=0;
            ENDIF
        ENDIF
        !        pCheckBuffer{2}.trans:=pCorredPosBuffer1;

        nCorrY_Store:=pCorredPosBuffer1.y;

        IF (isStartPos=bStart) THEN
            nCorrX_Store_Start{1}:=nCorrX_Store;
            nCorrY_Store_Start{1}:=nCorrY_Store;
            nCorrZ_Store_Start{1}:=nCorrZ_Store;
        ELSE
            nCorrX_Store_End{1}:=nCorrX_Store;
            nCorrY_Store_End{1}:=nCorrY_Store;
            nCorrZ_Store_End{1}:=nCorrZ_Store;
        ENDIF

        rMoveCorrConnect X,RetY,Z,0,0,0,pSearchStart1.extax.eax_d,isStartPos,CCW;
        nTouchRetryCount{1}:=0;
        TouchErrorDirMain:="Ready";

        RETURN ;
    ENDPROC

    PROC rCorrSearchWeldLineEdgeZ(num X,num Y,num Z,num Depth,num RetZ,bool isStartPos,bool CCW,string dirErrorCheck)
        VAR num nCorrX_Store;
        VAR num nCorrY_Store;
        VAR num nCorrZ_Store;
        VAR num nComparison;
        VAR robtarget pComparison;
        WaitUntil bRobSwap=CCW;
        IF (isStartPos=bStart) THEN
            nCorrX_Store:=nCorrX_Store_Start{1};
            nCorrY_Store:=nCorrY_Store_Start{1};
            nCorrZ_Store:=nCorrZ_Store_Start{1};
        ELSE
            nCorrX_Store:=nCorrX_Store_End{1};
            nCorrY_Store:=nCorrY_Store_End{1};
            nCorrZ_Store:=nCorrZ_Store_End{1};
        ENDIF
        TouchErrorDirSub:=dirErrorCheck;
        IF (TouchErrorDirMain=dirErrorCheck AND 0<nTouchRetryCount{1}) Depth:=Depth+(RetryDepthData{3}*nTouchRetryCount{1});
        !!! Search weld Z edge !!!
        WaitUntil bRobSwap=CCW;
        IF (isStartPos=bStart) THEN
            pSearchStart1.rot:=Welds1{1}.position.rot;
            IF (CCW=FALSE) pSearchStart1.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart1.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(-1*Y),nCorrZ_Store+(Z)];
        ELSEIF (isStartPos=bEnd) THEN
            pSearchStart1.rot:=Welds1{nMotionStepCount{1}}.position.rot;
            IF (CCW=FALSE) pSearchStart1.trans:=[nWeldLineLength_R1+nCorrX_Store+(X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart1.trans:=[nWeldLineLength_R1+nCorrX_Store+(X),nCorrY_Store+(-1*Y),nCorrZ_Store+(Z)];
        ENDIF

        pSearchStart1.robconf.cfx:=1;
        pSearchStart1.extax:=[9e9,9e9,9e9,9e9,9e9,9e9];

        pSearchEnd1:=pSearchStart1;
        pSearchEnd1.trans.z:=pSearchStart1.trans.z-Depth;
        bTouchOnSameSpotError_R1:=FALSE;
        pComparison:=CRobT(\Tool:=tWeld1\WObj:=wobjWeldLine1);
        rCorrSearchByWire pSearchStart1,pSearchEnd1\Z;
        nComparison:=VectMagn(pCorredPosBuffer1-pComparison.trans);
        IF nComparison<4 THEN
            bTouchOnSameSpotError_R1:=TRUE;
            IF (isStartPos=bStart) THEN
                nSameSpot_StartZ_R1:=nSameSpot_StartZ_R1+10;
            ELSE
                nSameSpot_EndZ_R1:=nSameSpot_EndZ_R1+10;
            ENDIF
            rTouchOnSameSpotErrorHandling;
        ELSE
            bTouchOnSameSpotError_R1:=FALSE;
            IF (isStartPos=bStart) THEN
                nSameSpot_StartZ_R1:=0;
            ELSE
                nSameSpot_EndZ_R1:=0;
            ENDIF
        ENDIF
        !        pCheckBuffer{3}.trans:=pCorredPosBuffer1;

        nCorrZ_Store:=pCorredPosBuffer1.z;

        IF (isStartPos=bStart) THEN
            nCorrX_Store_Start{1}:=nCorrX_Store;
            nCorrY_Store_Start{1}:=nCorrY_Store;
            nCorrZ_Store_Start{1}:=nCorrZ_Store;
        ELSE
            nCorrX_Store_End{1}:=nCorrX_Store;
            nCorrY_Store_End{1}:=nCorrY_Store;
            nCorrZ_Store_End{1}:=nCorrZ_Store;
        ENDIF

        rMoveCorrConnect X,Y,RetZ,0,0,0,pSearchStart1.extax.eax_d,isStartPos,CCW;
        nTouchRetryCount{1}:=0;
        TouchErrorDirMain:="Ready";

        RETURN ;
    ENDPROC

    PROC rCorrSearchByWire(robtarget SearchStart,robtarget SearchEnd,\switch X\switch Y\switch Z)
        VAR robtarget pTemp:=[[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,9E+09,9E+09]];

        MoveJ SearchStart,v100,fine,tWeld1\WObj:=wobjWeldLine1;

        rCheckWelder;
        SearchL\SStop,bWireTouch1,SearchStart,SearchEnd,v10,tWeld1\WObj:=wobjWeldLine1;

        Reset soLn1Touch;
        WaitTime 0;
        WaitUntil(siLn1TouchActive=0);
        pTemp:=CRobT(\taskname:="T_ROB1"\tool:=tWeld1\WObj:=wobjWeldLine1);
        pCorredPosBuffer1:=pTemp.trans;
        RETURN ;
    ERROR

        TouchErrorDirMain:=TouchErrorDirSub;
        IDelete iMoveHome_RBT1;
        IF ERRNO=ERR_WHLSEARCH THEN

            rTouchErrorHandling 2;
        ELSEIF ERRNO=ERR_SIGSUPSEARCH THEN
            WaitTime 999;
            rTouchErrorHandling 3;
        ELSE
            rTouchErrorHandling 4;
        ENDIF
    ENDPROC

    PROC rZero()
        MoveAbsJ [[0,0,0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]]\NoEOffs,v200,fine,tool0;
    ENDPROC

    PROC rErrorDuringEntry()
        VAR robtarget pTemp;
        Reset soLn1Touch;
        IDelete iMoveHome_RBT1;
        StopMove;
        ClearPath;
        StartMove;

        pTemp:=CRobT(\TaskName:="T_ROB1"\Tool:=tWeld1\WObj:=wobjWeldLine1);
        MoveL RelTool(pTemp,0,0,-10),vTargetSpeed,fine,tWeld1\WObj:=wobjWeldLine1;

        stReact{1}:="Error_Arc_Touch";
        WaitSyncTask Wait{80},taskGroup123;

        WaitUntil stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
        WaitSyncTask Wait{81},taskGroup123;

        WaitUntil stCommand="Error_Arc_Touch";
        stReact{1}:="";
        WaitUntil stCommand="";
        WaitSyncTask Wait{82},taskGroup123;

        ExitCycle;
    ENDPROC

    PROC rTouchErrorWhilMovingHandling()
        VAR robtarget pTemp;
        Reset soLn1Touch;
        IDelete iMoveHome_RBT1;
        IDelete innumTouchErrorWhilMoving;
        StopMove;
        ClearPath;
        StartMove;

        bMoveToWireCutHome:=TRUE;

        stReact{1}:="Error_Arc_Touch";
        WaitSyncTask Wait{80},taskGroup123;

        WaitUntil stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
        WaitSyncTask Wait{81},taskGroup123;

        WaitUntil stCommand="Error_Arc_Touch";
        stReact{1}:="";
        WaitUntil stCommand="";
        WaitSyncTask Wait{82},taskGroup123;

        ExitCycle;
    ENDPROC

    PROC rTouchOnSameSpotErrorHandling()
        Reset soLn1Touch;
        IDelete iMoveHome_RBT1;
        IDelete innumTouchErrorWhilMoving;
        bMoveToWireCutHome:=TRUE;

        stReact{1}:="Error_Arc_Touch";
        WaitSyncTask Wait{80},taskGroup123;

        WaitUntil stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
        WaitSyncTask Wait{81},taskGroup123;

        WaitUntil stCommand="Error_Arc_Touch";
        stReact{1}:="";
        WaitUntil stCommand="";
        WaitSyncTask Wait{82},taskGroup123;

        ExitCycle;
    ENDPROC

    PROC rArcError()
        VAR robtarget pTemp;
        TPWrite "TROB1_ArcError";
        bArc_On{1}:=FALSE;
        PulseDO\high\PLength:=0.5,sdo_T_Rob2_StopProc;
        IDelete iMoveHome_RBT1;
        ClkStop clockWeldTime;
        nclockWeldTime{1}:=ClkRead(clockWeldTime);
        SetDO intReHoldGantry_2,1;
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
        nArcError:=1;
        !pTemp:=CRobT(\TaskName:="T_ROB1"\Tool:=tWeld1\WObj:=wobjWeldLine1);
        !MoveL RelTool(pTemp,0,0,-10),vTargetSpeed,z0,tWeld1\WObj:=wobjWeldLine1;
        StartMove;

        stReact{1}:="Error_Arc_Touch";
        WaitSyncTask Wait{80},taskGroup123;

        WaitUntil stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
        WaitSyncTask Wait{81},taskGroup123;

        WaitUntil stCommand="Error_Arc_Touch";
        stReact{1}:="";
        WaitUntil stCommand="";
        WaitSyncTask Wait{82},taskGroup123;
        Reset po14_Motion_Working;
        Set po15_Motion_Finish;
        ExitCycle;

    ENDPROC

    PROC rTouchErrorHandling(num Errorno)
        VAR robtarget pTemp;
        Reset soLn1Touch;
        Set po33_TouchR1Error;

        pTemp:=CRobT(\TaskName:="T_ROB1"\tool:=tWeld1\WObj:=wobjWeldLine1);
        MoveL RelTool(pTemp,0,0,-10),v200,z10,tWeld1\WObj:=wobjWeldLine1;

        stReact{1}:="Error_Arc_Touch";
        WaitSyncTask Wait{80},taskGroup123;

        WaitUntil stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
        WaitSyncTask Wait{81},taskGroup123;

        WaitUntil stCommand="Error_Arc_Touch";
        stReact{1}:="";
        WaitUntil stCommand="";
        WaitSyncTask Wait{82},taskGroup123;

        StartMove;
        ExitCycle;

    ENDPROC

    PROC rT_ROB1check()
        VAR robtarget pTemp;
        pTemp:=CRobT(\TaskName:="T_ROB1"\Tool:=tWeld1\WObj:=wobj0);
        IF pTemp.trans.x>350 AND pTemp.trans.z>1420 THEN
            pTemp.trans.x:=350;

            MoveL pTemp,v100,fine,tWeld1\WObj:=wobj0;

        ENDIF
    ENDPROC

    PROC rCheckWelder()
        IF (soLn1Touch=1) THEN
            Reset soLn1Touch;
            WaitTime 0.5;
        ENDIF
        WaitTime 0.5;
        WaitUntil(siLn1TouchActive=0 OR soLn1Touch=0);
        Set soLn1Touch;
        WaitUntil(siLn1TouchActive=1 AND soLn1Touch=1);
    ENDPROC

    PROC rNozzleClean()
        VAR robtarget pTemp{10};
        VAR jointtarget j{20};
        VAR clock clNozzleCleanForward;

        j{1}:=jWorkingHome;
        j{2}:=jNozzle02;
        j{3}:=jNozzle01;
        j{4}:=jNozzleCleanEntry;
        j{5}:=jNozzleClean;
        j{6}:=jSprayEntry;
        j{7}:=jSpray;

        WobjNozzel_1:=wobjRotCtr1;
        WobjNozzel_1.oframe.rot:=OrientZYX(nR_Angle,0,0);
        FOR i FROM 4 TO 7 DO
            pTemp{i}:=CalcRobT(j{i},tWeld1\WObj:=WobjNozzel_1);
        ENDFOR

        MoveAbsJ j{1},v300,z50,tWeld1;
        MoveAbsJ j{2},v300,z50,tWeld1;
        MoveAbsJ j{3},v300,z50,tWeld1;
        MoveJ pTemp{4},v300,z0,tWeld1\WObj:=WobjNozzel_1;
        MoveL pTemp{5},v50,fine,tWeld1\WObj:=WobjNozzel_1;
        WaitRob\inpos;
        WaitTime 0.2;
        Set do15_NozzleClean;
        ClkReset clNozzleCleanForward;
        ClkStart clNozzleCleanForward;
        WaitUntil di28_NozzleCleanForward=1 OR ClkRead(clNozzleCleanForward)>5;
        ClkStop clNozzleCleanForward;
        Reset do15_NozzleClean;
        WaitUntil di29_NozzleCleanBackward=1;
        MoveL pTemp{4},v300,z0,tWeld1\WObj:=WobjNozzel_1;
        MoveL pTemp{6},v300,z0,tWeld1\WObj:=WobjNozzel_1;
        MoveL pTemp{7},v50,fine,tWeld1\WObj:=WobjNozzel_1;
        WaitRob\inpos;
        WaitTime 0.2;
        !PulseDO\high\PLength:=nSprayTime,do16_NozzleSpray;
        WaitTime nSprayTime+1;
        MoveL pTemp{6},v300,z0,tWeld1\WObj:=WobjNozzel_1;
        PulseDO\high\PLength:=5,do13_Torch1_Air_Cooling;
        MoveAbsJ j{3},v300,z50,tWeld1;
        MoveAbsJ j{2},v300,z50,tWeld1;
        MoveAbsJ j{1},v300,fine,tWeld1;
        RETURN ;

        !=== Teaching ========
        MoveAbsJ jWorkingHome,v300,z50,tWeld1;
        MoveAbsJ jNozzle02,v300,z50,tWeld1;
        MoveAbsJ jNozzle01,v300,z50,tWeld1;
        MoveAbsJ jNozzleCleanEntry,v300,z50,tWeld1;
        MoveAbsJ jNozzleClean,v300,z50,tWeld1;
        MoveAbsJ jSprayEntry,v300,z50,tWeld1;
        MoveAbsJ jSpray,v300,z50,tWeld1;

    ENDPROC
ENDMODULE
MODULE Head_Data
    RECORD breakpoint
        pos Position;
        num Angle;
    ENDRECORD

    RECORD corrorder
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
    ENDRECORD

    RECORD monRobs
        extjoint monExt;
        robjoint monJoint1;
        robjoint monJoint2;
        pose monPose1;
        pose monPose2;
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

    RECORD jointgroup
        jointtarget Joint1;
        jointtarget Joint2;
        jointtarget JointG;
    ENDRECORD

    RECORD pointgroup
        robtarget Point1;
        robtarget Point2;
        robtarget PointG;
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

    PERS corrorder corrStart{10}:=[[15,30,10,15,40,10,15,30,15,2],[15,30,10,15,40,10,15,30,15,0],[-15,-30,-10,15,40,10,15,30,15,2],[0,0,0,15,40,10,15,30,15,0],[0,0,0,15,40,10,15,40,15,5],[-15,-30,-10,15,40,10,15,30,15,0],[999,0,0,0,0,0,0,0,0,0],[999,0,0,0,0,0,0,0,0,0],[999,0,0,25,40,10,15,30,30,10],[999,0,0,0,0,0,0,0,0,0]];
    PERS corrorder corrEnd{10}:=[[15,30,10,15,40,10,15,30,15,2],[15,30,10,15,40,10,15,30,15,0],[-15,-30,-10,15,40,10,15,30,15,2],[0,0,0,15,40,10,15,30,15,0],[0,0,0,15,40,10,15,40,15,5],[-15,-30,-10,15,40,10,15,30,15,0],[999,0,0,25,40,10,15,30,10,0],[999,0,0,0,0,0,0,0,0,0],[0,0,0,15,40,10,15,30,15,0],[0,0,0,0,0,0,0,0,0,0]];

    PERS tooldata tWeld:=[TRUE,[[320.377,0,330.247],[0.92587,0,0.37784,0]],[3.1,[-71.4,3.8,173.2],[1,0,0,0],0.055,0.049,0.005]];
    PERS tooldata tWeld1:=[TRUE,[[319.938,-6.311,330],[0.92587,0.003729,0.377818,-0.009129]],[3.1,[-71.4,3.8,173.2],[1,0,0,0],0.055,0.049,0.005]];
    PERS tooldata tWeld2:=[TRUE,[[319.938,-6.311,330],[0.92587,0.003729,0.377818,-0.009128]],[3.1,[-71.4,3.8,173.2],[1,0,0,0],0.055,0.049,0.005]];

    PERS wobjdata WobjFloor:=[FALSE,TRUE,"",[[-9500,5300,2100],[0,1,0,0]],[[0,0,0],[1,0,0,0]]];
    PERS wobjdata wobjWeldLine:=[FALSE,TRUE,"",[[-9500,5300,2100],[0,1,0,0]],[[19388.6,1882.18,12.9667],[0.99997,-2.49181E-06,0.000322948,0.00771559]]];
    PERS wobjdata wobjWeldLine1:=[FALSE,TRUE,"",[[488,10,1620],[0,0.707107,-0.707107,0]],[[0,0,0],[1,0,0,0]]];
    PERS wobjdata wobjWeldLine2:=[FALSE,TRUE,"",[[488,-10,1620],[0,0.707107,0.707107,0]],[[0,0,0],[1,0,0,0]]];
    PERS wobjdata wobjRotCtr1:=[FALSE,TRUE,"",[[488,0,0],[0,0.707107,-0.707107,0]],[[0,0,0],[1,0,0,0]]];
    PERS wobjdata wobjRotCtr2:=[FALSE,TRUE,"",[[488,0,0],[0,0.707107,0.707107,0]],[[0,0,0],[1,0,0,0]]];

    !!! Mechanical Geometry !!!
    PERS num nLimitX_Negative:=-9500;
    PERS num nLimitX_Positive:=12300;
    PERS num nLimitY_Negative:=0;
    PERS num nLimitY_Positive:=5300;
    PERS num nLimitZ_Negative:=0;
    PERS num nLimitZ_Positive:=2100;
    PERS num nLimitR_Negative:=-90;
    PERS num nLimitR_Positive:=90;

    ! HomeGantry Home Information
    PERS num nHomeGantryX:=-9500;
    PERS num nHomeGantryY:=5300;
    PERS num nHomeGantryZ:=2100;
    PERS num nHomeGantryR:=0;

    PERS num nHomeTcpX:=-9500;
    PERS num nHomeTcpY:=5300;
    PERS num nHomeTcpZ:=2100;

    ! LDS Check Calibration Reference Point
    PERS num nHomeAdjustX:=0;
    PERS num nHomeAdjustY:=0;
    PERS num nHomeAdjustZ:=0;
    PERS num nHomeAdjustR:=0;

    PERS num Camera_Door:=0;
    PERS num Camera_Tilt:=0;

    ! Robot Welding Posture Height
    PERS num nRobHeightMin:=1100;
    PERS num nRobCorrSpaceHeight:=1680;
    PERS num nRobWorkSpaceHeight:=1680;
    PERS num nRobWeldSpaceHeight:=1620;

    PERS num nRotationNegLimit:=-90;
    PERS num nRotationPosLimit:=90;

    !! Variables for Commands
    PERS num nCmdInput:=0;
    PERS num nCmdOutput:=0;
    PERS num nCmdMatch:=0;


    !!! Bool Data !!!
    PERS bool bEnableWeldSkip:=FALSE;
    PERS bool bEnableStartEndPointCorr:=FALSE;
    PERS bool bEnableManualMacro:=FALSE;
    PERS bool bWireTouch1;
    PERS bool bWireTouch2;
    PERS bool bRobSwap:=FALSE;

    !commands for move
    CONST num CMD_MOVE_TO_WORLDHOME:=101;
    CONST num CMD_MOVE_TO_MeasurementHOME:=102;
    CONST num CMD_MOVE_TO_TEACHING_All:=104;
    CONST num CMD_MOVE_TO_TEACHING_R1:=105;
    CONST num CMD_MOVE_TO_TEACHING_R2:=106;
    CONST num CMD_MOVE_JOINTS:=107;
    CONST num CMD_MOVE_ABS_GANTRY:=108;
    CONST num CMD_MOVE_INC_GANTRY:=109;
    CONST num CMD_MOVE_TO_ZHOME:=110;
    CONST num CMD_MOVE_TO_nWarmUp:=112;

    ! commands for welding
    CONST num CMD_WELD:=200;
    CONST num CMD_WELD_MOTION:=201;
    CONST num CMD_WELD_CORR:=202;
    CONST num CMD_WELD_MOTION_CORR:=203;
    CONST num CMD_WELD_MM:=204;
    CONST num CMD_WELD_MOTION_MM:=205;
    CONST num CMD_WELD_CORR_MM:=206;
    CONST num CMD_WELD_MOTION_CORR_MM:=207;

    !commands for camera actions
    CONST num CMD_CAMERA_DOOR_OPEN:=301;
    CONST num CMD_CAMERA_DOOR_CLOSE:=302;
    CONST num CMD_CAMERA_BLOW_ON:=303;
    CONST num CMD_CAMERA_BLOW_OFF:=304;
    CONST num CMD_CAMERA1_DOOR_OPEN:=311;
    CONST num CMD_CAMERA1_DOOR_CLOSE:=312;
    CONST num CMD_CAMERA2_DOOR_OPEN:=321;
    CONST num CMD_CAMERA2_DOOR_CLOSE:=322;
    CONST num CMD_CAMERA1_BLOW_ON:=313;
    CONST num CMD_CAMERA2_BLOW_ON:=323;
    CONST num CMD_CAMERA1_BLOW_OFF:=314;
    CONST num CMD_CAMERA2_BLOW_OFF:=324;

    !commands for wire processing
    CONST num CMD_WIRE_CUT:=501;
    CONST num CMD_WIRE_CLEAN:=502;
    CONST num CMD_WIRE_BULLSEYE_CHECK:=505;
    CONST num CMD_WIRE_BULLSEYE_UPDATE:=506;
    CONST num CMD_WIRE_ReplacementMode:=507;
    CONST num CMD_ROB1_WIRE_CUT:=511;
    CONST num CMD_ROB2_WIRE_CUT:=512;

    !commands for gantry mechanical origin checking
    CONST num CMD_HOLE_CHECK:=601;
    CONST num CMD_LDS_CHECK:=602;

    ! variables related to commands
    PERS num Command:=0;

    !Weld Time
    VAR clock clockWeldTime;
    PERS num nclockWeldTime{2}:=[184.458,184.376];

    !Cycle Time
    VAR clock clockCycleTime;
    PERS num nclockCycleTime:=243.54;

    PERS num nCameraRotationAngle:=0;

    ! variables for welding command
    PERS num nMotionStep:=5;
    PERS num nMotionTotalStep{2}:=[2,2];
    PERS num nMotionStepCount{2}:=[4,4];

    PERS num nLengthWeldLine:=1813.51;
    PERS num nOffsetLength:=0;
    PERS num nOffsetLengthBuffer:=10;

    !! Variables for Welding Macro
    !! sMacro 2nd,3rd Dim: (1: Open, 2: Snip, 3: Welding, 4: Continued, 5: Divied, 8:MergeStart, 9:MergeEnd)
    PERS string stMacro{2}:=["244","244"];
    PERS num nMacro100{2}:=[2,2];
    PERS num nMacro010{2}:=[4,4];
    PERS num nMacro001{2}:=[4,4];
    PERS num nMacro{2}:=[244,244];

    PERS num nMotionStartStepLast{2}:=[1,1];
    PERS num nMotionEndStepLast{2}:=[1,1];
    PERS num nRunningStep{2}:=[40,40];

    PERS edgedata edgeStart{2}:=[[[19388.5,1888.17,12.9678],50,50,0,12,0,0],[[19388.7,1876.18,12.9655],50,50,0,12,0,0]];
    PERS edgedata edgeEnd{2}:=[[[21201.8,1916.16,11.7965],44.6894,50,0,12,0,0],[[21202,1904.16,11.7942],44.6888,50,0,12,0,0]];

    PERS pos posNull:=[0,0,0];
    PERS pos posStart:=[19388.7,1877.5,-0.426514];
    PERS pos posStartLast:=[19388.7,1877.5,-0.426514];
    PERS num nStartThick:=18.4549;
    PERS pos posEnd:=[21202,1907.3,-2.87933];
    PERS pos posEndLast:=[21202,1907.3,-2.87933];
    PERS num nEndThick:=19.0863;

    PERS breakpoint BreakPoints{10}:=[[[0,0,0],0],[[0,0,0],0],[[0,0,0],0],[[0,0,0],0],[[0,0,0],0],[[0,0,0],0],[[0,0,0],0],[[0,0,0],0],[[0,0,0],0],[[0,0,0],0]];

    ! data for z pos optimization [move,enter,exit]
    PERS num nMaxPartHeightNearArray{3}:=[300,300,300];

    PERS num nTempAdjustGantryZ;

    !!! Variable for correction weldline start & end Pos !!!
    CONST bool bStart:=TRUE;
    CONST bool bEnd:=FALSE;
    PERS bool bCorrectionOk:=FALSE;
    PERS bool bPlateTiltedRx:=FALSE;
    PERS robtarget pSearchStart:=[[0,-26.9999,-0.196656],[0.241845,-0.664463,-0.664463,-0.241845],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS robtarget pSearchEnd:=[[0,25,-0.196656],[0.241845,-0.664463,-0.664463,-0.241845],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS num nCorrZ_Store:=5.43813;
    PERS num nCorrY_Store:=1.20374;
    PERS num nCorrX_Store:=-5.98633;
    PERS num nCorrFailOffs:=0;
    PERS pos pCorredPosBuffer:=[-0.00548779,4.37115,3.45917];
    PERS pos pCorredStartPos{2}:=[[2086.6,5904.59,39.6865],[2086.6,5904.59,39.6865]];
    PERS pos pCorredEndPos{2}:=[[2082.19,4521.61,35.0346],[2086.6,5904.59,39.6865]];
    PERS pos pCorredSplitPos:=[2082.19,4521.61,35.0346];

    PERS bool bWeldLineLengthCalc:=FALSE;
    PERS bool bMoveGantry:=FALSE;

    !! Variables for Position of Gantry Move
    PERS extjoint extGantryPos:=[13750,2300,2100,0,0,13750];

    !!! RoboTarget !!!
    CONST robtarget pNull:=[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pHome:=[[423.10464973,-0.304,-470.07267919],[0.342020143,0,-0.939692621,0],[0,0,-1,0],[0,0,0,9E+09,9E+09,9E+09]];

    PERS robtarget pReadyConf{2}:=[[[200.384,-150.531,462.112],[0.16437,-0.687406,-0.687732,-0.165769],[0,-1,0,1],[-8705.17,-8705.17,300.411,482.178,9E+09,9E+09]],[[200.384,-150.531,462.112],[0.16437,-0.687406,-0.687732,-0.165769],[0,-1,0,1],[-8705.17,-8705.17,300.411,482.178,9E+09,9E+09]]];
    PERS robtarget pTargetWeldArray{30}:=[[[-5,5,5],[0.307623,-0.549545,-0.742667,-0.227629],[0,0,0,0],[1400,1400,1200,0,9E+9,9E+9]],[[-5,-6,5],[0.307623,-0.549545,-0.742667,-0.227629],[0,0,0,0],[1400,1400,1200,0,9E+9,9E+9]],[[4,-3,5],[0.307623,-0.549545,-0.742667,-0.227629],[0,0,0,0],[1400,1400,1200,0,9E+9,9E+9]],[[200,-3,5],[0.270598,-0.653282,-0.653282,-0.270598],[0,0,0,0],[1400,1400,1200,0,9E+9,9E+9]],[[800,-3,5],[0.270598,-0.653282,-0.653282,-0.270598],[0,0,0,0],[1400,1400,1800,0,9E+9,9E+9]],[[951,-3,5],[0.270598,-0.653282,-0.653282,-0.270598],[0,0,0,0],[1400,1400,1800,0,9E+9,9E+9]],[[986,-3,5],[0.270598,-0.653282,-0.653282,-0.270598],[0,0,0,0],[1400,1400,1800,0,9E+9,9E+9]],[[1002,-3,5],[0.227629,-0.742667,-0.549545,-0.307623],[0,0,0,0],[1400,1400,1800,0,9E+9,9E+9]],[[1005,-6,5],[0.227629,-0.742667,-0.549545,-0.307623],[0,0,0,0],[1400,1400,1800,0,9E+9,9E+9]],[[1005,7,5],[0.227629,-0.742667,-0.549545,-0.307623],[0,0,0,0],[1400,1400,1800,0,9E+9,9E+9]],
                                         [[1005,-6,5],[0.227629,-0.742667,-0.549545,-0.307623],[0,0,0,0],[1400,1400,1800,0,9E+9,9E+9]],[[951,-3,5],[0.270598,-0.653282,-0.653282,-0.270598],[0,0,0,0],[1400,1400,1800,0,9E+9,9E+9]],[[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,9E+9,9E+9]],[[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,9E+9,9E+9]],[[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,9E+9,9E+9]],[[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,9E+9,9E+9]],[[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,9E+9,9E+9]],[[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,9E+9,9E+9]],[[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,9E+9,9E+9]],[[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,9E+9,9E+9]],
                                         [[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,9E+9,9E+9]],[[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,9E+9,9E+9]],[[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,9E+9,9E+9]],[[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,9E+9,9E+9]],[[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,9E+9,9E+9]],[[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,9E+9,9E+9]],[[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,9E+9,9E+9]],[[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,9E+9,9E+9]],[[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,9E+9,9E+9]],[[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,9E+9,9E+9]]];

    !!! Joint Target !!!
    PERS jointtarget jNull:=[[0,0,0,0,0,0],[0,0,0,0,9E+09,0]];
    PERS jointtarget jHomeJoint:=[[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[8000,5300,0,0,9E+09,8000]];
    PERS jointgroup jgHomeJoint:=[[[90,90,-50,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],[[90,90,-50,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],[[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[8000,5300,0,0,9E+09,8000]]];
    PERS jointtarget jHomeJointBackup:=[[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[0,0,6000,500,9E+09,9E+09]];
    PERS jointtarget jRepairJoint:=[[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[0,0,6000,500,9E+09,9E+09]];
    PERS jointtarget jMoveReady:=[[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9],[-8707.81,-8707.8,1477.15,0,9E+9,9E+9]];

    PERS jointtarget jJointStepArray{10}:=[[[0,0,0,0,0,0],[0,0,0,0,0,0]],[[0,0,0,0,0,0],[0,0,0,0,0,0]],[[0,0,0,0,0,0],[0,0,0,0,0,0]],[[0,0,0,0,0,0],[0,0,0,0,0,0]],[[0,0,0,0,0,0],[0,0,0,0,0,0]],[[0,-95,65,0,-35,0],[0,0,0,0,0,0]],[[0,0,0,0,0,0],[0,0,0,0,0,0]],[[0,0,0,0,0,0],[0,0,0,0,0,0]],[[0,0,0,0,0,0],[0,0,0,0,0,0]],[[0,-46.86,14,0,-57.52,1.03],[0,0,0,0,0,0]]];

    PERS jointtarget jWeldPos{40}:=[[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]]];
    PERS jointtarget jTest1:=[[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[0,0,0,0,9E+09,0]];
    PERS jointtarget jTest2:=[[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[0,0,0,0,9E+09,0]];
    PERS jointtarget jTest3:=[[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[0,0,0,0,9E+09,0]];
    PERS jointtarget jTest4:=[[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[0,0,0,0,9E+09,0]];

    !!! Variables for macroReference !!!
    !    PERS TorchMotion macroStartArray{10,10};
    PERS torchmotion macroAutoStartA{2,10};
    PERS torchmotion macroAutoStartB{2,10};
    PERS torchmotion macroManualStartA{2,10};
    PERS torchmotion macroManualStartB{2,10};
    PERS torchmotion macroStartBuffer1{10};
    PERS torchmotion macroStartBuffer2{10};
    !    PERS TorchMotion macroEndArray{10,10};
    PERS torchmotion macroAutoEndA{2,10};
    PERS torchmotion macroAutoEndB{2,10};
    PERS torchmotion macroManualEndA{2,10};
    PERS torchmotion macroManualEndB{2,10};
    PERS torchmotion macroEndBuffer1{10};
    PERS torchmotion macroEndBuffer2{10};


    !!! Teaching Pose !!!
    PERS jointtarget jTeachPose10:=[[0,-11.58,-54.61,0,-23.21,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS jointtarget jTeachPose20:=[[0,-13.77,-51.14,0,-24.5,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS jointtarget jTeachPose30:=[[0,-5.48,-66.86,0,-35.66,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS jointtarget jTeachPose40:=[[0,-95,70,0,-35,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

    !!! Wire Cut !!!
    PERS jointtarget jWireCutRdy10:=[[-5.74337,56.5223,-2.36426,0,0,0],[-7805.23,-7805.23,1917.83,1534,9E+09,9E+09]];
    PERS jointtarget jWireCutRdy20:=[[-4.42117,43.9252,29.766,35.9723,-31.0497,-17.7691],[-7805.23,-7805.23,1917.83,1534,9E+09,9E+09]];
    PERS jointtarget jWireCutRdy30:=[[-2.45489,39.2604,46.5236,54.029,-43.8022,-8.52495],[-7805.23,-7805.23,1917.83,1534,9E+09,9E+09]];
    PERS jointtarget jWireCutRdy40:=[[-8.44041,38.4714,56.4802,74.9109,-46.3356,6.60117],[-7805.23,-7805.23,1917.83,1534,9E+09,9E+09]];
    PERS jointtarget jWireCut:=[[-10.3272,38.7931,61.3627,68.3466,-47.9698,13.406],[-7805.23,-7805.23,1917.83,1534,9E+09,9E+09]];
    PERS jointtarget jWireCutRdy50:=[[-8.44041,38.4714,56.4802,74.9108,-46.3356,6.60084],[-7805.23,-7805.23,1917.83,1534,9E+09,9E+09]];
    PERS jointtarget jWireCutRdy60:=[[-4.42128,43.9251,29.766,35.9723,-31.0497,-17.7691],[-7805.23,-7805.23,1917.83,1534,9E+09,9E+09]];
    PERS jointtarget jWireCutRdy70:=[[-5.74337,56.5222,-2.36431,0,0,0],[-7805.23,-7805.23,1917.83,1534,9E+09,9E+09]];

    !!! rNozzle Clean !!!
    PERS jointtarget jNozzleClean10:=[[92.7023,56.7732,-24.6002,-105.292,47.2145,-39.1763],[-7.83472,-7.83523,5212.01,422.601,9E+09,9E+09]];
    PERS jointtarget jNozzleClean20:=[[154.238,56.7746,-24.5971,-105.291,47.2139,-39.1774],[-7.83472,-7.83495,5212.01,422.595,9E+09,9E+09]];
    PERS jointtarget jNozzleClean30:=[[144.266,78.8984,-24.7284,-105.291,47.2139,-39.1774],[-7.83513,-7.83495,5212.01,422.596,9E+09,9E+09]];
    PERS jointtarget jNozzleClean40:=[[136.493,90.5978,-51.7581,-95.8271,39.0251,-59.7871],[-7.83513,-7.83482,5212.01,422.595,9E+09,9E+09]];
    PERS jointtarget jNozzleClean:=[[136.493,90.5979,-51.7581,-95.8269,39.0251,-59.7873],[-7.83513,-7.83495,5212.01,422.595,9E+09,9E+09]];
    PERS jointtarget jNozzleClean50:=[[136.493,90.5979,-51.7581,-95.8269,39.0252,-59.7873],[-7.83513,-7.83495,5212.01,422.595,9E+09,9E+09]];
    PERS jointtarget jNozzleClean60:=[[144.266,78.8983,-24.7285,-105.291,47.2139,-39.1774],[-7.83513,-7.83495,5212.01,422.595,9E+09,9E+09]];
    PERS jointtarget jNozzleClean70:=[[154.238,56.7746,-24.5971,-105.291,47.2139,-39.1774],[-7.83513,-7.83495,5212.01,422.595,9E+09,9E+09]];
    PERS jointtarget jNozzleClean80:=[[92.7023,56.7732,-24.6003,-105.292,47.2145,-39.176],[-7.83472,-7.83523,5212.01,422.601,9E+09,9E+09]];


    PERS robtarget pWeldPosR1{40}:=[[[-3,7,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.31,9E+9,9E+9]],[[-3,7,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.31,9E+9,9E+9]],[[-3,-4.5,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.31,9E+9,9E+9]],[[15,-1,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.34,9E+9,9E+9]],[[200,-1,1],[0.270598,-0.653282,-0.653282,-0.270598],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.72,9E+9,9E+9]],[[1390,-1.00592,0.996463],[0.270597,-0.653283,-0.653281,-0.270597],[0,0,-1,1],[-8707.81,-8707.8,1477.15,1033.13,9E+9,9E+9]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[15,-1,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.34,9E+9,9E+9]]];
    PERS robtarget pWeldPosR2{40}:=[[[-3,7,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.31,9E+09,9E+09]],[[-3,7,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.31,9E+09,9E+09]],[[-3,-4.5,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.31,9E+09,9E+09]],[[15,-1,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.34,9E+09,9E+09]],[[200,-1,1],[0.270598,-0.653282,-0.653282,-0.270598],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.72,9E+09,9E+09]],[[1390,-1.00592,0.996463],[0.270597,-0.653283,-0.653281,-0.270597],[0,0,-1,1],[-8707.81,-8707.8,1477.15,1033.13,9E+09,9E+09]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[1390,-1,1],[0.270598,-0.653282,-0.653282,-0.270598],[-1,0,0,1],[-8707.8,-8707.8,1477.15,1033.12,9E+09,9E+09]]];
    PERS robtarget pWeldPosG{40};
    PERS speeddata vWeld1{40}:=[[10,200,200,200],[10,200,200,200],[10,200,200,200],[10,200,200,200],[10,200,200,200],[10,200,200,200],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[10,200,200,200]];
    PERS speeddata vWeld2{40}:=[[10,200,200,200],[10,200,200,200],[10,200,200,200],[10,200,200,200],[10,200,200,200],[10,200,200,200],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[10,200,200,200]];

    !!! Speed Data !!!
    PERS speeddata vTargetSpeed:=[400,300,400,25];
    PERS speeddata vTargetSpeed2:=[9,200,200,25];
    PERS speeddata vWeldEntry:=[100,20,200,25];

    !!! variables for Speed Data !!!
    PERS num nWireCutSpeed:=500;
    PERS num nGantrySpeed:=0;
    PERS num nDryRunSpeed:=2.5;

    !!! Zone Data !!!
    PERS zonedata zTargetZone:=[FALSE,30,5,5,2,1,1];
    PERS zonedata zFineZone:=[TRUE,0,0,0,0,0,0];

    VAR num rotationMaxtrix{3,3};

    ! MoveStepGantryHeight
    PERS num nCurrentGantryHeight:=0;
    PERS num nTargetGantryHeight:=-35.9858;
    PERS num nCalculatedGantryHeight:=0;
    PERS num nGantrySafetyHeight:=-100;
    PERS jointtarget jReadyGantryHeightBuffer:=[[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[11691.9,3390,-0.00132159,-0.876334,9E+09,11691.9]];
    PERS num nAngleOfEntry:=0.155838;
    PERS num nAngleRzStore:=0.88415;
    PERS num nCalculatedHeight:=461.831;

    !!! weld data !!!
    TASK PERS welddata wdArray{40}:=[[10,0,[5,0,36.5,230,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[10,0,[5,0,36.5,230,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[10,0,[5,0,36.5,230,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[10,0,[5,0,36.5,230,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[9.16667,0,[5,0,39.5,255,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[9.16667,0,[5,0,39.5,255,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[8.33333,0,[5,0,39.5,255,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[7.5,0,[5,0,36,225,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[10,0,[5,0,25.5,120,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[10,0,[5,0,25.5,120,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[10,0,[5,0,34,210,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[10,0,[5,0,34,210,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[10,0,[5,0,37.5,270,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[10,0,[5,0,37.5,250,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[10,0,[5,0,37.5,250,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[10,0,[5,0,37.5,250,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[10,0,[5,0,37.5,250,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[10,0,[5,0,37.5,250,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[10,0,[5,0,37.5,250,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[10,0,[5,0,37.5,250,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[0,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[0,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[0,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[0,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[0,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[0,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[0,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[0,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[0,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[0,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[9,0,[5,0,28,160,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[9,0,[5,0,28,160,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[9,0,[5,0,28,160,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[9,0,[5,0,28,160,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[9,0,[5,0,28,160,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[9,0,[5,0,28,160,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[9,0,[5,0,28,160,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[9,0,[5,0,28,160,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[9,0,[5,0,28,160,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]],[9,0,[5,0,28,160,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]]];
    TASK PERS welddata wd1:=[10,0,[5,0,36.5,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd2:=[10,0,[5,0,36.5,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd3:=[10,0,[5,0,36.5,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd4:=[10,0,[5,0,36.5,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd5:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd6:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd7:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd8:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd9:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd10:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd11:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd12:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd13:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd14:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd15:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd16:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd17:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd18:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd19:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd20:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd21:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd22:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd23:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd24:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd25:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd26:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd27:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd28:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd29:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd30:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd31:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd32:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd33:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd34:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd35:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd36:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd37:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd38:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd39:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd40:=[10,0,[5,0,36.5,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];

    !!! weave data !!!
    TASK PERS weavedata weave1:=[1,2,2.5,1.7,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave2:=[1,2,2.5,1.7,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave3:=[1,2,2.5,1.7,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave4:=[1,2,2.5,1.7,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave5:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave6:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave7:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave8:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave9:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave10:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave11:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave12:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave13:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave14:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave15:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave16:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave17:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave18:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave19:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave20:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave21:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave22:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave23:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave24:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave25:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave26:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave27:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave28:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave29:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave30:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave31:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave32:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave33:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave34:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave35:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave36:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave37:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave38:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave39:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave40:=[1,2,2.5,1.7,0,0,0,0,0,0,0,0,0,0,0];

    !!! Track Data !!!
    TASK PERS trackdata track0:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track1:=[0,FALSE,50,[0,15,30,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track2:=[0,FALSE,50,[0,15,30,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track3:=[0,FALSE,50,[0,15,30,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track4:=[0,FALSE,50,[0,15,30,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track5:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track6:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track7:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track8:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track9:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track10:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track11:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track12:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track13:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track14:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track15:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track16:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track17:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track18:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track19:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track20:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track21:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track22:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track23:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track24:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track25:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track26:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track27:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track28:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track29:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track30:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track31:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track32:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track33:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track34:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track35:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track36:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track37:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track38:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track39:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track40:=[0,FALSE,50,[0,15,30,0,0,0,0,0,0],[0,0,0,0,0,0,0]];

    !TouchMotion
    PERS bool bTouchError{4,2}:=[[FALSE,FALSE],[FALSE,FALSE],[FALSE,FALSE],[FALSE,FALSE]];
    PERS num nCheckCount:=1;
    PERS num RetryDepthData{3}:=[10,-10,10];
    PERS bool bRetry:=FALSE;
    PERS string TouchErrorDirMain:="Ready";
    PERS string TouchErrorDirSub:="Ready";
    PERS jointgroup jSearchReadyGroup;
    PERS pointgroup pSearchReadyGroup;
    PERS jointtarget jSearchReady:=[[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[11691.9,3390,467.021,-0.876133,9E+09,11691.9]];
    PERS num nArcErrorPos:=0;
    PERS robtarget pArcErrorPos:=[[6,8,12],[1,0,0,0],[0,0,0,0],[0,0,0,0,9E+09,9E+09]];
    PERS bool bTouchWorkCount{6};
    PERS bool bEndSearchComplete:=FALSE;
    PERS bool bSumTouchError:=FALSE;

    !Arc_Error
    PERS bool bArcError:=FALSE;

    !! Variables for HoleSensor based Origin Checking
    PERS num nRefHoleX{2}:=[5.7,0.4];
    PERS num nInspectHoleX{2}:=[5.8,0.4];
    PERS num nDiffHoleX:=0.1;
    PERS num nDiffHoleXskew:=-0.000651461;

    !! Variables for LDS based Origin Checking
    CONST pos pInspectGantryOriginal:=[2054.978,731.4054,1208.162];
    PERS num nInspectGantryX{2}:=[2054.98,2055.26];
    PERS num nInspectGantryY{2}:=[731.405,731.295];
    PERS num nInspectGantryZ{2}:=[1208.16,1207.99];
    PERS num nDiffGantryX:=0;
    PERS num nDiffGantryY:=0;
    PERS num nDiffGantryZ:=0;

    PERS num nCorrX_Store_Start{2};
    PERS num nCorrY_Store_Start{2};
    PERS num nCorrZ_Store_Start{2};
    PERS num nCorrX_Store_End{2};
    PERS num nCorrY_Store_End{2};
    PERS num nCorrZ_Store_End{2};

    PERS seamdata smDefault_1{2};
    PERS seamdata seam_TRob1;
    PERS seamdata smDefault_2{2};
    PERS seamdata seam_TRob2;

    ! Variables for Touch Sync
    PERS bool bTouch_last_R1_Comp:=FALSE;
    PERS bool bTouch_last_R2_Comp:=FALSE;
    PERS bool bTouch_First_R1_Comp:=FALSE;
    PERS bool bTouch_First_R2_Comp:=FALSE;
    PERS bool bGanTry_First_pos:=FALSE;
    PERS bool bGanTry_Last_pos:=FALSE;

    PERS jointtarget jCorrT_ROB1_Start;
    PERS jointtarget jCorrT_ROB1_End;
    PERS robtarget pCorrT_ROB1_Start;
    PERS robtarget pCorrT_ROB1_End;

    PERS robtarget pCorrT_ROB2_Start;
    PERS robtarget pCorrT_ROB2_End;
    PERS jointtarget jCorrTouchGantry_Start;
    PERS jointtarget jCorrTouchGantry_End;
    PERS tooldata tWeld1copy:=[TRUE,[[320.377,0,330.247],[0.92587,0,0.37784,0]],[3.1,[-71.4,3.8,173.2],[1,0,0,0],0.055,0.049,0.005]];
    PERS tooldata tWeldcopy2:=[TRUE,[[308.188,-16.1693,300.214],[0.92587,0,0.37784,0]],[3.1,[-71.4,3.8,173.2],[1,0,0,0],0.055,0.049,0.005]];
    PERS targetdata Welds1{40}:=[[[[0,11.2275,2],[0.241845,0.664463,-0.664463,0.241845],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],60,0,36.5,230,380,1,2,2.5,1.7,0,0,0,15,30,10,0],[[[5,11.2283,2],[0.241845,0.664463,-0.664463,0.241845],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],60,0,36.5,230,380,1,2,2.5,1.7,0,0,0,15,30,10,0],[[[15,11.2301,2],[0.241845,0.664463,-0.664463,0.241845],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],60,0,36.5,230,380,1,2,2.5,1.7,0,0,0,15,30,10,0],[[[20,11.2309,2],[0.241845,0.664463,-0.664463,0.241845],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],60,0,36.5,230,380,1,2,2.5,1.7,0,0,0,15,30,10,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[20,11.2309,2],[0.241845,0.664463,-0.664463,0.241845],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]];
    PERS targetdata Welds2{40}:=[[[[0,-11.2275,2],[0.241845,-0.664463,-0.664463,-0.241845],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],60,0,36.8,227,360,1,2,2.5,1.7,0,0,0,15,30,10,0],[[[5,-11.2283,2],[0.241845,-0.664463,-0.664463,-0.241845],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],60,0,36.8,227,360,1,2,2.5,1.7,0,0,0,15,30,10,0],[[[15,-11.2301,2],[0.241845,-0.664463,-0.664463,-0.241845],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],60,0,36.8,227,360,1,2,2.5,1.7,0,0,0,15,30,10,0],[[[20,-11.2309,2],[0.241845,-0.664463,-0.664463,-0.241845],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],60,0,36.8,227,360,1,2,2.5,1.7,0,0,0,15,30,10,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[20,-11.2309,2],[0.241845,-0.664463,-0.664463,-0.241845],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]];
    PERS targetdata WeldsG{40}:=[[[[19398.7,1877.66,1619.56],[0.99997,0,0,0.00771559],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[21192,1907.14,1617.13],[0.99997,0,0,0.00771559],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]];
    PERS bool bMoveHome_Head;
    !Error
    PERS num nErrorCmd;
    !Error_Pos
    PERS num nWeldDist;
    PERS monRobs MonitorweldErrorpostion;
    PERS num nEntryRetryCount{2}:=[0,0];
    PERS num nTouchRetryCount{2}:=[0,0];
    PERS bool bGantryInTrap{2};
    PERS num nWeldLineLength_R1;
    PERS num nWeldLineLength_R2;
    PERS num nMaintenanceYPos:=5300;
    PERS num nInchingTime:=2.1;
    PERS bool bGUI_ArcRefresh;
    PERS bool bBreakPoint{2};
    PERS num nBreakPoint{2};
    PERS bool btouchTimeOut{2}:=[FALSE,FALSE];
    PERS bool bWeldOutputDisable:=TRUE;
    PERS bool bso_MoveG_PosHold:=FALSE;
    PERS num nMoveid:=1;
    PERS bool bRBT_PP_Main:=FALSE;
    PERS bool bWireCutSync:=FALSE;
    !!!!!!!!!
    PERS jointgroup jgMeasurementHome:=[[[40,90,-90,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],[[40,90,-90,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],[[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[7000,5300,0,0,9E+09,7000]]];
    PERS jointgroup jgWireCutHome:=[[[39.7077,23.0399,30.4536,-87.5281,29.1211,122.951],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],[[39.5269,22.7659,30.4413,-87.1375,29.0323,122.34],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],[[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[7000,5300,0,0,9E+09,7000]]];
    PERS bool bWirecut{3}:=[FALSE,TRUE,FALSE];
    PERS bool bArc_On{2}:=[FALSE,FALSE];
    PERS num nWarmUpCycle:=600;
    PERS jointgroup jgWarm_Up;
    PERS jointgroup jgTarget;
    PERS num nWarmUpTime:=601.803;

ENDMODULE
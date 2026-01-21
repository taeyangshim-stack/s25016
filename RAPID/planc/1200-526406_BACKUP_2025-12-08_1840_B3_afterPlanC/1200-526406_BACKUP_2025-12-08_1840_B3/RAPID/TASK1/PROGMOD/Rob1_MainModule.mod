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
    TASK PERS speeddata vWeld{40}:=[[10,200,200,200],[10,200,200,200],[10,200,200,200],[10,200,200,200],[9.16667,200,200,200],[9.16667,200,200,200],[8.33333,200,200,200],[7.5,200,200,200],[10,200,200,200],[10,200,200,200],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[10,200,200,200]];
    PERS seamdata smDefault_1{2};
    PERS seamdata seam_TRob1;

    PERS speeddata vTargetSpeed;
    PERS zonedata zTargetZone;

    TASK PERS welddata wdTrap:=[10,0,[5,0,38,240,0,400,0,0,0],[0,0,0,0,0,0,0,0,0]];
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

    TASK PERS welddata Holdwd1:=[10,0,[5,0,36.5,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata Holdwd2:=[10,0,[5,0,36.5,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata Holdwd3:=[10,0,[5,0,36.5,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata Holdwd4:=[10,0,[5,0,36.5,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata Holdwd5:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata Holdwd6:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata Holdwd7:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata Holdwd8:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata Holdwd9:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata Holdwd10:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];

    !!! weave data !!!
    TASK PERS weavedata weaveTrap:=[1,2,3,3,0,0,0,0,0,0,0,0,0,0,0];
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
    TASK PERS trackdata trackTrap:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track0:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track1:=[0,FALSE,0,[0,15,30,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track2:=[0,FALSE,0,[0,15,30,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track3:=[0,FALSE,0,[0,15,30,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track4:=[0,FALSE,0,[0,15,30,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track5:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track6:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track7:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track8:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track9:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track10:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track11:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track12:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track13:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track14:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track15:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track16:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track17:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track18:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track19:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track20:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track21:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track22:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track23:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track24:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track25:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track26:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track27:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track28:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track29:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track30:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track31:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track32:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track33:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track34:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track35:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track36:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track37:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track38:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track39:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track40:=[0,FALSE,0,[0,15,30,0,0,0,0,0,0],[0,0,0,0,0,0,0]];

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
    PERS edgedata edgeStart{2}:=[[[18006.3,846.64,13.3666],44.6901,50,0,12,0,0],[[18006.3,858.64,13.3668],44.6898,50,0,12,0,0]];
    PERS edgedata edgeEnd{2}:=[[[15947.8,845.054,13.2484],50,50,0,12,0,0],[[15947.8,857.054,13.2487],50,50,0,12,0,0]];
    PERS corrorder corrStart{10}:=[[15,30,10,15,40,10,15,30,15,2],[15,30,10,15,40,10,15,30,15,0],[-15,-30,-10,15,40,10,15,30,15,2],[0,0,0,15,40,10,15,30,15,0],[0,0,0,15,40,10,15,40,15,5],[-15,-30,-10,15,40,10,15,30,15,0],[999,0,0,0,0,0,0,0,0,0],[999,0,0,0,0,0,0,0,0,0],[999,0,0,25,40,10,15,30,30,10],[999,0,0,0,0,0,0,0,0,0]];
    PERS corrorder corrEnd{10}:=[[15,30,10,15,40,10,15,30,15,2],[15,30,10,15,40,10,15,30,15,0],[-15,-30,-10,15,40,10,15,30,15,2],[0,0,0,15,40,10,15,30,15,0],[0,0,0,15,40,10,15,40,15,5],[-15,-30,-10,15,40,10,15,30,15,0],[999,0,0,25,40,10,15,30,10,0],[999,0,0,0,0,0,0,0,0,0],[0,0,0,15,40,10,15,30,15,0],[0,0,0,0,0,0,0,0,0,0]];
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
    PERS robtarget pSearchStart:=[[0,27,-3.52258],[0.241845,0.664463,-0.664463,0.241845],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS robtarget pSearchEnd:=[[0,-25,-3.52258],[0.241845,0.664463,-0.664463,0.241845],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    TASK PERS string TouchErrorDirSub:="Start_Y";
    TASK PERS string TouchErrorDirMain:="Ready";
    PERS num nTouchRetryCount{2};
    PERS num n_Angle;
    TASK PERS num RetryDepthData{3}:=[10,10,10];
    PERS robtarget pWeldPosR1{40}:=[[[-3,7,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.31,9E+09,9E+09]],[[-3,7,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.31,9E+09,9E+09]],[[-3,-4.5,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.31,9E+09,9E+09]],[[15,-1,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.34,9E+09,9E+09]],[[200,-1,1],[0.270598,-0.653282,-0.653282,-0.270598],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.72,9E+09,9E+09]],[[1390,-1.00592,0.996463],[0.270597,-0.653283,-0.653281,-0.270597],[0,0,-1,1],[-8707.81,-8707.8,1477.15,1033.13,9E+09,9E+09]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[15,-1,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.34,9E+09,9E+09]]];
    PERS num nRobCorrSpaceHeight;
    PERS pos pCorredPosBuffer:=[-0.0203692,-6.43895,-2.02792];
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
    TASK PERS bool bTouchWorkCount{6}:=[FALSE,FALSE,FALSE,FALSE,FALSE,FALSE];
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
    TASK PERS seamdata tsm1:=[0.5,0.5,[5,0,24,120,0,0,0,0,0],1,0,0,0,0,[0,0,0,0,0,0,0,0,0],0,1,[5,0,24,120,0,0,0,0,0],0,0,[0,0,0,0,0,0,0,0,0],0];
    TASK PERS welddata twel1:=[0.01,0,[0,0,32,0,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
    CONST robtarget p10:=[[9646.02,5367.14,1098.73],[0.000127632,0.99996,-0.00820973,-0.00350012],[-1,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget p20:=[[9648.07,5402.56,1092.32],[0.000102269,0.999962,-0.00800323,-0.00353187],[-1,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    TASK PERS seamdata tsm2:=[0,0,[0,0,0,0,0,0,0,0,0],0,0,0,0,0,[0,0,0,0,0,0,0,0,0],0,0,[0,0,0,0,0,0,0,0,0],0,0,[0,0,0,0,0,0,0,0,0],0];
    TASK PERS welddata tweld2:=[10,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS weavedata tweave1:=[1,2,2,2,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS bool bInstalldir:=TRUE;
    PERS num nMoveid;
    PERS bool bExitCycle:=FALSE;
    PERS bool bWireCutSync;
    PERS num nInchingTime;
    TASK VAR clock clockWeldTime;
    PERS num nclockWeldTime{2};
    PERS bool bWirecut{3};
    PERS robtarget pCheckBuffer{3};
    TASK PERS welddata wd41:=[10,0,[5,0,12,230,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
    PERS bool bArc_On{2};



    TRAP trapOutGantryHold
        IDelete intOutGantryHold;
        bGantryInTrap{1}:=FALSE;
        Reset intReHoldGantry_1;
        Holdwd1:=[Welds1{1}.cpm/6,0,[5,0,Welds1{1}.voltage,Welds1{1}.wfs,0,Welds1{1}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd2:=[Welds1{2}.cpm/6,0,[5,0,Welds1{2}.voltage,Welds1{2}.wfs,0,Welds1{2}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd3:=[Welds1{3}.cpm/6,0,[5,0,Welds1{3}.voltage,Welds1{3}.wfs,0,Welds1{3}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd4:=[Welds1{4}.cpm/6,0,[5,0,Welds1{4}.voltage,Welds1{4}.wfs,0,Welds1{4}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd5:=[Welds1{5}.cpm/6,0,[5,0,Welds1{5}.voltage,Welds1{5}.wfs,0,Welds1{5}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd6:=[Welds1{6}.cpm/6,0,[5,0,Welds1{6}.voltage,Welds1{6}.wfs,0,Welds1{6}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd7:=[Welds1{7}.cpm/6,0,[5,0,Welds1{7}.voltage,Welds1{7}.wfs,0,Welds1{7}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd8:=[Welds1{8}.cpm/6,0,[5,0,Welds1{8}.voltage,Welds1{8}.wfs,0,Welds1{8}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd9:=[Welds1{9}.cpm/6,0,[5,0,Welds1{9}.voltage,Welds1{9}.wfs,0,Welds1{9}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd10:=[Welds1{10}.cpm/6,0,[5,0,Welds1{10}.voltage,Welds1{10}.wfs,0,Welds1{10}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        ArcRefresh;
    ENDTRAP

    TRAP trapMoveG_PosHold
        rTrapNoWeldMove;
    ENDTRAP

    TRAP trapMoveHome_RBT1
        VAR robtarget pTemp;
        IDelete iMoveHome_RBT1;
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
            WaitUntil stCommand<>"";
            !retry val init
            !rWeldinit;
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
                IF bEnableWeldSkip=TRUE THEN
                    IF (nMacro010{1}=3 AND nMacro010{2}=3) OR (nMacro010{1}=4 AND nMacro010{2}=4) THEN
                        rNoWeld34;
                    ELSE
                        rNoWeld012;
                    ENDIF
                ELSE
                    IDelete iMoveHome_RBT1;
                    !                    CONNECT iMoveHome_RBT1 WITH trapMoveHome_RBT1;
                    !                    ISignalDO intMoveHome_RBT1,1,iMoveHome_RBT1;
                    IF (nMacro010{1}=3 AND nMacro010{2}=3) OR (nMacro010{1}=4 AND nMacro010{2}=4) THEN
                        rWeld34;
                    ELSE
                        rWeld012;
                    ENDIF
                    IDelete iMoveHome_RBT1;
                ENDIF
                nTrapCheck_1:=0;
            CASE "CorrSearchStartEnd":
                IF nEntryRetryCount{1}=0 THEN
                    nCorrFailOffs_Y:=0;
                    nCorrFailOffs_Z:=0;
                ENDIF

                IF nTouchRetryCount{1}=0 THEN
                    bTouchWorkCount:=[FALSE,FALSE,FALSE,FALSE,FALSE,FALSE];
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

                bTouchWorkCount:=[FALSE,FALSE,FALSE,FALSE,FALSE,FALSE];
                IDelete iMoveHome_RBT1;
            CASE "WireCutR1_R2":
                rWireCut;
            CASE "WireCutR1":
                rWireCut;
            CASE "WireCutR2":
                WaitUntil stCommand="";
                stReact{2}:="Ready";
            CASE "WireCutShotR1_R2":
                rWireCutShot;
            CASE "WireCutShotR1":
                rWireCutShot;
            CASE "WireCutShotR2":
                WaitUntil stCommand="";
                stReact{2}:="Ready";
            CASE "WireCutMoveR1_R2":
                rWireCutMove;
            CASE "WireCutMoveR1":
                rWireCutMove;
            CASE "WireCutMoveR2":
                WaitUntil stCommand="";
                stReact{2}:="Ready";
            CASE "checkpos":
                rT_ROB1check;
                stReact{1}:="checkposok";
                WaitUntil stCommand="";
                stReact{1}:="Ready";
            DEFAULT:
                stReact{1}:="Error";
                Stop;
            ENDTEST
        ENDWHILE
    ENDPROC

    PROC rInit()
        AccSet 30,30;

        stReact{1}:="";
        WaitUntil stCommand="";
        stReact{1}:="Ready";
        IDelete inumMoveG_PosHold;
        IDelete iMoveHome_RBT1;
        IDelete intOutGantryHold;
        Reset intReHoldGantry_1;
        Reset soLn1Touch;
        bGantryInTrap{1}:=FALSE;
        bArc_On{1}:=FALSE;
        RETURN ;
        MoveAbsJ [[0.0207831,-24.7259,-8.05171,0.050497,-57.6173,1.6],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]]\NoEOffs,v1000,z50,tool0;
        MoveJ [[168.49,0.00,1167.51],[0.999973,0.000347345,-0.00346186,0.00642441],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],v1000,z50,tool0;
    ENDPROC

    PROC rWeld012()

        VAR num nTempMmps;
        VAR num nTempVolt;
        VAR num nTempWFS;
        VAR num wdArray{40};
        VAR speeddata vHoldspeed;
        VAR num nHoldWeldVel;
        VAR num nHoldDist:=0;
        IDelete inumMoveG_PosHold;
        nHoldWeldVel:=0.01;

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

        Holdwd1:=[nHoldWeldVel,0,[5,0,Welds1{1}.voltage,Welds1{1}.wfs,0,Welds1{1}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd2:=[nHoldWeldVel,0,[5,0,Welds1{2}.voltage,Welds1{2}.wfs,0,Welds1{2}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd3:=[nHoldWeldVel,0,[5,0,Welds1{3}.voltage,Welds1{3}.wfs,0,Welds1{3}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd4:=[nHoldWeldVel,0,[5,0,Welds1{4}.voltage,Welds1{4}.wfs,0,Welds1{4}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd5:=[nHoldWeldVel,0,[5,0,Welds1{5}.voltage,Welds1{5}.wfs,0,Welds1{5}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd6:=[nHoldWeldVel,0,[5,0,Welds1{6}.voltage,Welds1{6}.wfs,0,Welds1{6}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd7:=[nHoldWeldVel,0,[5,0,Welds1{7}.voltage,Welds1{7}.wfs,0,Welds1{7}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd8:=[nHoldWeldVel,0,[5,0,Welds1{8}.voltage,Welds1{8}.wfs,0,Welds1{8}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd9:=[nHoldWeldVel,0,[5,0,Welds1{9}.voltage,Welds1{9}.wfs,0,Welds1{9}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd10:=[nHoldWeldVel,0,[5,0,Welds1{10}.voltage,Welds1{10}.wfs,0,Welds1{10}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];

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

        FOR i FROM 1 TO nMotionStepCount{1} DO
            !===========================================================!
            !!! [mm/sec] = [cm/sec]*10 = [cm/min]*10/60 = [cm/min]/6  !!!
            !===========================================================!
            nTempMmps:=Welds1{i}.cpm/6;
            vWeld{i}:=[nTempMmps,200,200,200];
            IF nTempMmps<>0 vHoldspeed:=[nTempMmps,60,500,500];
        ENDFOR
        seam_TRob1.ign_move_delay:=2;
        Welds1{40}.position:=Welds1{nMotionStepCount{1}}.position;
        WaitRob\ZeroSpeed;
        WaitSyncTask Wait{20},taskGroup123;
        MoveL RelTool(Welds1{1}.position,0,0,-100),vTargetSpeed,zTargetZone,tWeld1\WObj:=wobjWeldLine1;
        ConfL\Off;

        IDelete intOutGantryHold;
        CONNECT intOutGantryHold WITH trapOutGantryHold;
        ISignalDO intReHoldGantry_1,1,intOutGantryHold;

        nRunningStep{1}:=1;
        ArcLStart Welds1{1}.position,vTargetSpeed,seam_TRob1,wd1\weave:=weave1,fine,tWeld1\WObj:=wobjWeldLine1;
        stReact{1}:="T_ROB1_ArcOn";
        !\Track:=track1

        IF nRunningStep{1}>nMotionStartStepLast{1} THEN
            pcalcWeldpos:=Welds1{2}.position;
            WHILE so_MoveG_PosHold=0 AND (1<VectMagn(pcalcWeldpos.trans-Welds1{nRunningStep{1}+1}.position.trans)) DO
                pcalcWeldpos:=fCalcWeldingpos(pcalcWeldpos,Welds1{nRunningStep{1}}.position,Welds1{nRunningStep{1}+1}.position);
                ArcL pcalcWeldpos,vWeld{nRunningStep{1}+1},seam_TRob1,wd2,\Weave:=weave2,fine,tWeld1\WObj:=wobjWeldLine1;
            ENDWHILE
        ENDIF
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{1}=FALSE bGantryInTrap{1}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds1{nRunningStep{1}+1}.position,0,0,0),vWeld{4},seam_TRob1,Holdwd2,\Weave:=weave2,z1,tWeld1\WObj:=wobjWeldLine1;
        ENDWHILE

        IF 2>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=2;
        ArcL Welds1{2}.position,vWeld{2},seam_TRob1,wd2,\Weave:=weave2,z1,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track2

        IF nRunningStep{1}>nMotionStartStepLast{1} THEN
            pcalcWeldpos:=Welds1{2}.position;
            WHILE so_MoveG_PosHold=0 AND (1<VectMagn(pcalcWeldpos.trans-Welds1{nRunningStep{1}+1}.position.trans)) DO
                pcalcWeldpos:=fCalcWeldingpos(pcalcWeldpos,Welds1{nRunningStep{1}}.position,Welds1{nRunningStep{1}+1}.position);
                ArcL pcalcWeldpos,vWeld{nRunningStep{1}+1},seam_TRob1,wd3,\Weave:=weave3,fine,tWeld1\WObj:=wobjWeldLine1;
            ENDWHILE
        ENDIF
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{1}=FALSE bGantryInTrap{1}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds1{nRunningStep{1}+1}.position,0,0,0),vWeld{4},seam_TRob1,Holdwd3,\Weave:=weave3,z1,tWeld1\WObj:=wobjWeldLine1;
        ENDWHILE

        IF 3>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=3;
        ArcL Welds1{3}.position,vWeld{3},seam_TRob1,wd3,\Weave:=weave3,z1,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track3;

        IF nRunningStep{1}>nMotionStartStepLast{1} THEN
            pcalcWeldpos:=Welds1{3}.position;
            WHILE so_MoveG_PosHold=0 AND (1<VectMagn(pcalcWeldpos.trans-Welds1{nRunningStep{1}+1}.position.trans)) DO
                pcalcWeldpos:=fCalcWeldingpos(pcalcWeldpos,Welds1{nRunningStep{1}}.position,Welds1{nRunningStep{1}+1}.position);
                ArcL pcalcWeldpos,vWeld{nRunningStep{1}+1},seam_TRob1,wd4,\Weave:=weave4,fine,tWeld1\WObj:=wobjWeldLine1;
            ENDWHILE
        ENDIF
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{1}=FALSE bGantryInTrap{1}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds1{nRunningStep{1}+1}.position,0,0,0),vWeld{4},seam_TRob1,Holdwd4,\Weave:=weave4,z1,tWeld1\WObj:=wobjWeldLine1;
        ENDWHILE


        IF 4>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=4;
        ArcL Welds1{4}.position,vWeld{4},seam_TRob1,wd4,\Weave:=weave4,z1,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track4;
        IF nRunningStep{1}>nMotionStartStepLast{1} THEN
            pcalcWeldpos:=Welds1{4}.position;
            WHILE so_MoveG_PosHold=0 AND (1<VectMagn(pcalcWeldpos.trans-Welds1{nRunningStep{1}+1}.position.trans)) DO
                pcalcWeldpos:=fCalcWeldingpos(pcalcWeldpos,Welds1{nRunningStep{1}}.position,Welds1{nRunningStep{1}+1}.position);
                ArcL pcalcWeldpos,vWeld{nRunningStep{1}+1},seam_TRob1,wd5,\Weave:=weave5,fine,tWeld1\WObj:=wobjWeldLine1;
            ENDWHILE
        ENDIF
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{1}=FALSE bGantryInTrap{1}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds1{nRunningStep{1}+1}.position,0,0,0),vWeld{5},seam_TRob1,Holdwd5,\Weave:=weave5,z1,tWeld1\WObj:=wobjWeldLine1;
        ENDWHILE

        IF 5>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=5;
        ArcL Welds1{5}.position,vWeld{5},seam_TRob1,wd5,\Weave:=weave5,z1,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track5;
        IF nRunningStep{1}>nMotionStartStepLast{1} THEN
            pcalcWeldpos:=Welds1{5}.position;
            WHILE so_MoveG_PosHold=0 AND (1<VectMagn(pcalcWeldpos.trans-Welds1{nRunningStep{1}+1}.position.trans)) DO
                pcalcWeldpos:=fCalcWeldingpos(pcalcWeldpos,Welds1{nRunningStep{1}}.position,Welds1{nRunningStep{1}+1}.position);
                ArcL pcalcWeldpos,vWeld{nRunningStep{1}+1},seam_TRob1,wd6,\Weave:=weave6,fine,tWeld1\WObj:=wobjWeldLine1;
            ENDWHILE
        ENDIF
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{1}=FALSE bGantryInTrap{1}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds1{nRunningStep{1}+1}.position,0,0,0),vWeld{6},seam_TRob1,Holdwd6,\Weave:=weave6,z1,tWeld1\WObj:=wobjWeldLine1;
        ENDWHILE


        IF 6>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=6;
        ArcL Welds1{6}.position,vWeld{6},seam_TRob1,wd6,\Weave:=weave6,z1,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track6;
        IF nRunningStep{1}>nMotionStartStepLast{1} THEN
            pcalcWeldpos:=Welds1{6}.position;
            WHILE so_MoveG_PosHold=0 AND (1<VectMagn(pcalcWeldpos.trans-Welds1{nRunningStep{1}+1}.position.trans)) DO
                pcalcWeldpos:=fCalcWeldingpos(pcalcWeldpos,Welds1{nRunningStep{1}}.position,Welds1{nRunningStep{1}+1}.position);
                ArcL pcalcWeldpos,vWeld{nRunningStep{1}+1},seam_TRob1,wd7,\Weave:=weave7,fine,tWeld1\WObj:=wobjWeldLine1;
            ENDWHILE
        ENDIF
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{1}=FALSE bGantryInTrap{1}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds1{nRunningStep{1}+1}.position,0,0,0),vWeld{7},seam_TRob1,Holdwd7,\Weave:=weave7,z1,tWeld1\WObj:=wobjWeldLine1;
        ENDWHILE


        IF 7>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=7;
        ArcL Welds1{7}.position,vWeld{7},seam_TRob1,wd7,\Weave:=weave7,z1,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track7;
        IF nRunningStep{1}>nMotionStartStepLast{1} THEN
            pcalcWeldpos:=Welds1{7}.position;
            WHILE so_MoveG_PosHold=0 AND (1<VectMagn(pcalcWeldpos.trans-Welds1{nRunningStep{1}+1}.position.trans)) DO
                pcalcWeldpos:=fCalcWeldingpos(pcalcWeldpos,Welds1{nRunningStep{1}}.position,Welds1{nRunningStep{1}+1}.position);
                ArcL pcalcWeldpos,vWeld{nRunningStep{1}+1},seam_TRob1,wd8,\Weave:=weave8,fine,tWeld1\WObj:=wobjWeldLine1;
            ENDWHILE
        ENDIF
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{1}=FALSE bGantryInTrap{1}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds1{nRunningStep{1}+1}.position,0,0,0),vWeld{8},seam_TRob1,Holdwd8,\Weave:=weave8,z1,tWeld1\WObj:=wobjWeldLine1;
        ENDWHILE


        IF 8>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=8;
        ArcL Welds1{8}.position,vWeld{8},seam_TRob1,wd8,\Weave:=weave8,z1,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track8;
        IF nRunningStep{1}>nMotionStartStepLast{1} THEN
            pcalcWeldpos:=Welds1{8}.position;
            WHILE so_MoveG_PosHold=0 AND (1<VectMagn(pcalcWeldpos.trans-Welds1{nRunningStep{1}+1}.position.trans)) DO
                pcalcWeldpos:=fCalcWeldingpos(pcalcWeldpos,Welds1{nRunningStep{1}}.position,Welds1{nRunningStep{1}+1}.position);
                ArcL pcalcWeldpos,vWeld{nRunningStep{1}+1},seam_TRob1,wd9,\Weave:=weave9,fine,tWeld1\WObj:=wobjWeldLine1;
            ENDWHILE
        ENDIF
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{1}=FALSE bGantryInTrap{1}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds1{nRunningStep{1}+1}.position,0,0,0),vWeld{9},seam_TRob1,Holdwd9,\Weave:=weave9,z1,tWeld1\WObj:=wobjWeldLine1;
        ENDWHILE


        IF 9>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=9;
        ArcL Welds1{9}.position,vWeld{9},seam_TRob1,wd9,\Weave:=weave9,z1,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track9;
        IF nRunningStep{1}>nMotionStartStepLast{1} THEN
            pcalcWeldpos:=Welds1{9}.position;
            WHILE so_MoveG_PosHold=0 AND (1<VectMagn(pcalcWeldpos.trans-Welds1{nRunningStep{1}+1}.position.trans)) DO
                pcalcWeldpos:=fCalcWeldingpos(pcalcWeldpos,Welds1{nRunningStep{1}}.position,Welds1{nRunningStep{1}+1}.position);
                ArcL pcalcWeldpos,vWeld{nRunningStep{1}+1},seam_TRob1,wd10,\Weave:=weave10,fine,tWeld1\WObj:=wobjWeldLine1;
            ENDWHILE
        ENDIF
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{1}=FALSE bGantryInTrap{1}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds1{nRunningStep{1}+1}.position,0,0,0),vWeld{10},seam_TRob1,Holdwd10,\Weave:=weave10,z1,tWeld1\WObj:=wobjWeldLine1;
        ENDWHILE


        IF 10>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=10;
        ArcL Welds1{10}.position,vWeld{10},seam_TRob1,wd10,\Weave:=weave10,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track10;

        IF 11>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=11;
        ArcL Welds1{11}.position,vWeld{11},seam_TRob1,wd11,\Weave:=weave11,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track11;

        IF 12>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=12;
        ArcL Welds1{12}.position,vWeld{12},seam_TRob1,wd12,\Weave:=weave12,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track12;

        IF 13>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=13;
        ArcL Welds1{13}.position,vWeld{13},seam_TRob1,wd13,\Weave:=weave13,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track13;

        IF 14>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=14;
        ArcL Welds1{14}.position,vWeld{14},seam_TRob1,wd14,\Weave:=weave14,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track14;

        IF 15>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=15;
        ArcL Welds1{15}.position,vWeld{15},seam_TRob1,wd15,\Weave:=weave15,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track15;

        IF 16>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=16;
        ArcL Welds1{16}.position,vWeld{16},seam_TRob1,wd16,\Weave:=weave16,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track16;

        IF 17>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=17;
        ArcL Welds1{17}.position,vWeld{17},seam_TRob1,wd17,\Weave:=weave17,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track17;

        IF 18>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=18;
        ArcL Welds1{18}.position,vWeld{18},seam_TRob1,wd18,\Weave:=weave18,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track18;

        IF 19>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=19;
        ArcL Welds1{19}.position,vWeld{19},seam_TRob1,wd19,\Weave:=weave19,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track19;

        IF 20>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=20;
        ArcL Welds1{20}.position,vWeld{20},seam_TRob1,wd20,\Weave:=weave20,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track20;

        IF 21>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=21;
        ArcL Welds1{21}.position,vWeld{21},seam_TRob1,wd21,\Weave:=weave21,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track21;

        IF 22>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=22;
        ArcL Welds1{22}.position,vWeld{22},seam_TRob1,wd22,\Weave:=weave22,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track22;

        IF 23>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=23;
        ArcL Welds1{23}.position,vWeld{23},seam_TRob1,wd23,\Weave:=weave23,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track23;

        IF 24>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=24;
        ArcL Welds1{24}.position,vWeld{24},seam_TRob1,wd24,\Weave:=weave24,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track24;

        IF 25>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=25;
        ArcL Welds1{25}.position,vWeld{25},seam_TRob1,wd25,\Weave:=weave25,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track25;

        IF 26>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=26;
        ArcL Welds1{26}.position,vWeld{26},seam_TRob1,wd26,\Weave:=weave26,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track26;

        IF 27>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=27;
        ArcL Welds1{27}.position,vWeld{27},seam_TRob1,wd27,\Weave:=weave27,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track27;

        IF 28>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=28;
        ArcL Welds1{28}.position,vWeld{28},seam_TRob1,wd28,\Weave:=weave28,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track28;

        IF 29>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=29;
        ArcL Welds1{29}.position,vWeld{29},seam_TRob1,wd29,\Weave:=weave29,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track29;

        IF 30>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=30;
        ArcL Welds1{30}.position,vWeld{30},seam_TRob1,wd30,\Weave:=weave30,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track30;

        IF 31>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=31;
        ArcL Welds1{31}.position,vWeld{31},seam_TRob1,wd31,\Weave:=weave31,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track31;

        IF 32>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=32;
        ArcL Welds1{32}.position,vWeld{32},seam_TRob1,wd32,\Weave:=weave32,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track32;

        IF 33>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=33;
        ArcL Welds1{33}.position,vWeld{33},seam_TRob1,wd33,\Weave:=weave33,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track33;

        IF 34>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=34;
        ArcL Welds1{34}.position,vWeld{34},seam_TRob1,wd34,\Weave:=weave34,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track34;

        IF 35>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=35;
        ArcL Welds1{35}.position,vWeld{35},seam_TRob1,wd35,\Weave:=weave35,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track35;

        IF 36>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=36;
        ArcL Welds1{36}.position,vWeld{36},seam_TRob1,wd36,\Weave:=weave36,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track36;

        IF 37>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=37;
        ArcL Welds1{37}.position,vWeld{37},seam_TRob1,wd37,\Weave:=weave37,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track37;

        IF 38>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=38;
        ArcL Welds1{38}.position,vWeld{38},seam_TRob1,wd38,\Weave:=weave38,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track38;

        IF 39>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=39;
        ArcL Welds1{39}.position,vWeld{39},seam_TRob1,wd39,\Weave:=weave39,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track39;


        MoveArcEnd:
        nRunningStep{1}:=40;
        ArcLEnd Welds1{40}.position,vWeld{40},seam_TRob1,wd40,\Weave:=weave40,fine,tWeld1\WObj:=wobjWeldLine1;
        !\Track:=track40;
        MoveL RelTool(Welds1{nMotionStepCount{1}}.position,0,0,-50),vTargetSpeed,fine,tWeld1\WObj:=wobjWeldLine1;

        IDelete intOutGantryHold;

        ConfL\On;
        stReact{1}:="WeldOk";
        WaitUntil stCommand="";
        stReact{1}:="Ready";

    ENDPROC

    PROC rWeld34()

        VAR num nTempMmps;
        VAR num nTempVolt;
        VAR num nTempWFS;
        VAR num wdArray{40};
        VAR speeddata vHoldspeed;
        VAR num nHoldWeldVel;
        VAR num nHoldDist:=0;
        IDelete inumMoveG_PosHold;
        nHoldWeldVel:=0.01;

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

        Holdwd1:=[nHoldWeldVel,0,[5,0,Welds1{1}.voltage,Welds1{1}.wfs,0,Welds1{1}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd2:=[nHoldWeldVel,0,[5,0,Welds1{2}.voltage,Welds1{2}.wfs,0,Welds1{2}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd3:=[nHoldWeldVel,0,[5,0,Welds1{3}.voltage,Welds1{3}.wfs,0,Welds1{3}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd4:=[nHoldWeldVel,0,[5,0,Welds1{4}.voltage,Welds1{4}.wfs,0,Welds1{4}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd5:=[nHoldWeldVel,0,[5,0,Welds1{5}.voltage,Welds1{5}.wfs,0,Welds1{5}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd6:=[nHoldWeldVel,0,[5,0,Welds1{6}.voltage,Welds1{6}.wfs,0,Welds1{6}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd7:=[nHoldWeldVel,0,[5,0,Welds1{7}.voltage,Welds1{7}.wfs,0,Welds1{7}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd8:=[nHoldWeldVel,0,[5,0,Welds1{8}.voltage,Welds1{8}.wfs,0,Welds1{8}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd9:=[nHoldWeldVel,0,[5,0,Welds1{9}.voltage,Welds1{9}.wfs,0,Welds1{9}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd10:=[nHoldWeldVel,0,[5,0,Welds1{10}.voltage,Welds1{10}.wfs,0,Welds1{10}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];

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

        track1:=[0,FALSE,Welds1{1}.MaxCorr,[Welds1{1}.TrackType,Welds1{1}.TrackGainY,Welds1{1}.TrackGainZ,0,Welds1{1}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track2:=[0,FALSE,Welds1{2}.MaxCorr,[Welds1{2}.TrackType,Welds1{2}.TrackGainY,Welds1{2}.TrackGainZ,0,Welds1{2}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track3:=[0,FALSE,Welds1{3}.MaxCorr,[Welds1{3}.TrackType,Welds1{3}.TrackGainY,Welds1{3}.TrackGainZ,0,Welds1{3}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track4:=[0,FALSE,Welds1{4}.MaxCorr,[Welds1{4}.TrackType,Welds1{4}.TrackGainY,Welds1{4}.TrackGainZ,0,Welds1{4}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track5:=[0,FALSE,Welds1{5}.MaxCorr,[Welds1{5}.TrackType,Welds1{5}.TrackGainY,Welds1{5}.TrackGainZ,0,Welds1{5}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track6:=[0,FALSE,Welds1{6}.MaxCorr,[Welds1{6}.TrackType,Welds1{6}.TrackGainY,Welds1{6}.TrackGainZ,0,Welds1{6}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track7:=[0,FALSE,Welds1{7}.MaxCorr,[Welds1{7}.TrackType,Welds1{7}.TrackGainY,Welds1{7}.TrackGainZ,0,Welds1{7}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track8:=[0,FALSE,Welds1{8}.MaxCorr,[Welds1{8}.TrackType,Welds1{8}.TrackGainY,Welds1{8}.TrackGainZ,0,Welds1{8}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track9:=[0,FALSE,Welds1{9}.MaxCorr,[Welds1{9}.TrackType,Welds1{9}.TrackGainY,Welds1{9}.TrackGainZ,0,Welds1{9}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track10:=[0,FALSE,Welds1{10}.MaxCorr,[Welds1{10}.TrackType,Welds1{10}.TrackGainY,Welds1{10}.TrackGainZ,0,Welds1{10}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track11:=[0,FALSE,Welds1{11}.MaxCorr,[Welds1{11}.TrackType,Welds1{11}.TrackGainY,Welds1{11}.TrackGainZ,0,Welds1{11}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track12:=[0,FALSE,Welds1{12}.MaxCorr,[Welds1{12}.TrackType,Welds1{12}.TrackGainY,Welds1{12}.TrackGainZ,0,Welds1{12}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track13:=[0,FALSE,Welds1{13}.MaxCorr,[Welds1{13}.TrackType,Welds1{13}.TrackGainY,Welds1{13}.TrackGainZ,0,Welds1{13}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track14:=[0,FALSE,Welds1{14}.MaxCorr,[Welds1{14}.TrackType,Welds1{14}.TrackGainY,Welds1{14}.TrackGainZ,0,Welds1{14}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track15:=[0,FALSE,Welds1{15}.MaxCorr,[Welds1{15}.TrackType,Welds1{15}.TrackGainY,Welds1{15}.TrackGainZ,0,Welds1{15}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track16:=[0,FALSE,Welds1{16}.MaxCorr,[Welds1{16}.TrackType,Welds1{16}.TrackGainY,Welds1{16}.TrackGainZ,0,Welds1{16}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track17:=[0,FALSE,Welds1{17}.MaxCorr,[Welds1{17}.TrackType,Welds1{17}.TrackGainY,Welds1{17}.TrackGainZ,0,Welds1{17}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track18:=[0,FALSE,Welds1{18}.MaxCorr,[Welds1{18}.TrackType,Welds1{18}.TrackGainY,Welds1{18}.TrackGainZ,0,Welds1{18}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track19:=[0,FALSE,Welds1{19}.MaxCorr,[Welds1{19}.TrackType,Welds1{19}.TrackGainY,Welds1{19}.TrackGainZ,0,Welds1{19}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track20:=[0,FALSE,Welds1{20}.MaxCorr,[Welds1{20}.TrackType,Welds1{20}.TrackGainY,Welds1{20}.TrackGainZ,0,Welds1{20}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track21:=[0,FALSE,Welds1{21}.MaxCorr,[Welds1{21}.TrackType,Welds1{21}.TrackGainY,Welds1{21}.TrackGainZ,0,Welds1{21}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track22:=[0,FALSE,Welds1{22}.MaxCorr,[Welds1{22}.TrackType,Welds1{22}.TrackGainY,Welds1{22}.TrackGainZ,0,Welds1{22}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track23:=[0,FALSE,Welds1{23}.MaxCorr,[Welds1{23}.TrackType,Welds1{23}.TrackGainY,Welds1{23}.TrackGainZ,0,Welds1{23}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track24:=[0,FALSE,Welds1{24}.MaxCorr,[Welds1{24}.TrackType,Welds1{24}.TrackGainY,Welds1{24}.TrackGainZ,0,Welds1{24}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track25:=[0,FALSE,Welds1{25}.MaxCorr,[Welds1{25}.TrackType,Welds1{25}.TrackGainY,Welds1{25}.TrackGainZ,0,Welds1{25}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track26:=[0,FALSE,Welds1{26}.MaxCorr,[Welds1{26}.TrackType,Welds1{26}.TrackGainY,Welds1{26}.TrackGainZ,0,Welds1{26}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track27:=[0,FALSE,Welds1{27}.MaxCorr,[Welds1{27}.TrackType,Welds1{27}.TrackGainY,Welds1{27}.TrackGainZ,0,Welds1{27}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track28:=[0,FALSE,Welds1{28}.MaxCorr,[Welds1{28}.TrackType,Welds1{28}.TrackGainY,Welds1{28}.TrackGainZ,0,Welds1{28}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track29:=[0,FALSE,Welds1{29}.MaxCorr,[Welds1{29}.TrackType,Welds1{29}.TrackGainY,Welds1{29}.TrackGainZ,0,Welds1{29}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track30:=[0,FALSE,Welds1{30}.MaxCorr,[Welds1{30}.TrackType,Welds1{30}.TrackGainY,Welds1{30}.TrackGainZ,0,Welds1{30}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track31:=[0,FALSE,Welds1{31}.MaxCorr,[Welds1{31}.TrackType,Welds1{31}.TrackGainY,Welds1{31}.TrackGainZ,0,Welds1{31}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track32:=[0,FALSE,Welds1{32}.MaxCorr,[Welds1{32}.TrackType,Welds1{32}.TrackGainY,Welds1{32}.TrackGainZ,0,Welds1{32}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track33:=[0,FALSE,Welds1{33}.MaxCorr,[Welds1{33}.TrackType,Welds1{33}.TrackGainY,Welds1{33}.TrackGainZ,0,Welds1{33}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track34:=[0,FALSE,Welds1{34}.MaxCorr,[Welds1{34}.TrackType,Welds1{34}.TrackGainY,Welds1{34}.TrackGainZ,0,Welds1{34}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track35:=[0,FALSE,Welds1{35}.MaxCorr,[Welds1{35}.TrackType,Welds1{35}.TrackGainY,Welds1{35}.TrackGainZ,0,Welds1{35}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track36:=[0,FALSE,Welds1{36}.MaxCorr,[Welds1{36}.TrackType,Welds1{36}.TrackGainY,Welds1{36}.TrackGainZ,0,Welds1{36}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track37:=[0,FALSE,Welds1{37}.MaxCorr,[Welds1{37}.TrackType,Welds1{37}.TrackGainY,Welds1{37}.TrackGainZ,0,Welds1{37}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track38:=[0,FALSE,Welds1{38}.MaxCorr,[Welds1{38}.TrackType,Welds1{38}.TrackGainY,Welds1{38}.TrackGainZ,0,Welds1{38}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track39:=[0,FALSE,Welds1{39}.MaxCorr,[Welds1{39}.TrackType,Welds1{39}.TrackGainY,Welds1{39}.TrackGainZ,0,Welds1{39}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track40:=[0,FALSE,Welds1{nMotionStepCount{1}}.MaxCorr,[Welds1{nMotionStepCount{1}}.TrackType,Welds1{nMotionStepCount{1}}.TrackGainY,Welds1{nMotionStepCount{1}}.TrackGainZ,0,Welds1{nMotionStepCount{1}}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];

        FOR i FROM 1 TO nMotionStepCount{1} DO
            !===========================================================!
            !!! [mm/sec] = [cm/sec]*10 = [cm/min]*10/60 = [cm/min]/6  !!!
            !===========================================================!
            nTempMmps:=Welds1{i}.cpm/6;
            vWeld{i}:=[nTempMmps,200,200,200];
            IF nTempMmps<>0 vHoldspeed:=[nTempMmps,60,500,500];
        ENDFOR
        seam_TRob1.ign_move_delay:=1;
        Welds1{40}.position:=Welds1{nMotionStepCount{1}}.position;
        WaitRob\ZeroSpeed;
        WaitSyncTask Wait{20},taskGroup123;

        MoveL RelTool(Welds1{1}.position,0,0,-10),vTargetSpeed,zTargetZone,tWeld1\WObj:=wobjWeldLine1;
        ConfL\Off;

        IDelete intOutGantryHold;
        CONNECT intOutGantryHold WITH trapOutGantryHold;
        ISignalDO intReHoldGantry_1,1,intOutGantryHold;

        nRunningStep{1}:=1;
        WaitRob\ZeroSpeed;
        WaitSyncTask Wait{50},taskGroup12;

        ArcLStart Welds1{1}.position,vTargetSpeed,seam_TRob1,wd1\weave:=weave1,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track1;
        ClkReset clockWeldTime;
        ClkStart clockWeldTime;
        bArc_On{1}:=TRUE;
        stReact{1}:="T_ROB1_ArcOn";

        IF 2>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=2;
        ArcL Welds1{2}.position,vWeld{2},seam_TRob1,wd2,\Weave:=weave2,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track2;
        !\Track:=track2
        stReact{1}:="T_ROB1_GantryOn";
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{1}=FALSE bGantryInTrap{1}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds1{nRunningStep{1}+1}.position,-1,0,0),vWeld{3},seam_TRob1,Holdwd3,\Weave:=weave3,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track3;
        ENDWHILE

        IF 3>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=3;
        ArcL Welds1{3}.position,vWeld{3},seam_TRob1,wd3,\Weave:=weave3,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track3;
        !\Track:=track3;

        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{1}=FALSE bGantryInTrap{1}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds1{nRunningStep{1}+1}.position,-1,0,0),vWeld{4},seam_TRob1,Holdwd4,\Weave:=weave4,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track4;
        ENDWHILE


        IF 4>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=4;
        ArcL Welds1{4}.position,vWeld{4},seam_TRob1,wd4,\Weave:=weave4,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track4;
        !\Track:=track4;
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{1}=FALSE bGantryInTrap{1}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds1{nRunningStep{1}+1}.position,-1,0,0),vWeld{5},seam_TRob1,Holdwd5,\Weave:=weave5,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track5;
        ENDWHILE

        IF 5>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=5;
        ArcL Welds1{5}.position,vWeld{5},seam_TRob1,wd5,\Weave:=weave5,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track5;
        !\Track:=track5;
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{1}=FALSE bGantryInTrap{1}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds1{nRunningStep{1}+1}.position,-1,0,0),vWeld{6},seam_TRob1,Holdwd6,\Weave:=weave6,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track6;
        ENDWHILE


        IF 6>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=6;
        ArcL Welds1{6}.position,vWeld{6},seam_TRob1,wd6,\Weave:=weave6,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track6;
        !\Track:=track6;
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{1}=FALSE bGantryInTrap{1}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds1{nRunningStep{1}+1}.position,-1,0,0),vWeld{7},seam_TRob1,Holdwd7,\Weave:=weave7,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track7;
        ENDWHILE


        IF 7>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=7;
        ArcL Welds1{7}.position,vWeld{7},seam_TRob1,wd7,\Weave:=weave7,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track7;
        !\Track:=track7;
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{1}=FALSE bGantryInTrap{1}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds1{nRunningStep{1}+1}.position,-1,0,0),vWeld{8},seam_TRob1,Holdwd8,\Weave:=weave8,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track8;
        ENDWHILE


        IF 8>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=8;
        ArcL Welds1{8}.position,vWeld{8},seam_TRob1,wd8,\Weave:=weave8,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track8;
        !\Track:=track8;
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{1}=FALSE bGantryInTrap{1}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds1{nRunningStep{1}+1}.position,-1,0,0),vWeld{9},seam_TRob1,Holdwd9,\Weave:=weave9,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track9;
        ENDWHILE


        IF 9>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=9;
        ArcL Welds1{9}.position,vWeld{9},seam_TRob1,wd9,\Weave:=weave9,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track9;
        !\Track:=track9;
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{1}=FALSE bGantryInTrap{1}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds1{nRunningStep{1}+1}.position,-1,0,0),vWeld{10},seam_TRob1,Holdwd10,\Weave:=weave10,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track10;
        ENDWHILE


        IF 10>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=10;
        ArcL Welds1{10}.position,vWeld{10},seam_TRob1,wd10,\Weave:=weave10,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track10;
        !\Track:=track10;

        IF 11>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=11;
        ArcL Welds1{11}.position,vWeld{11},seam_TRob1,wd11,\Weave:=weave11,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track11;
        !\Track:=track11;

        IF 12>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=12;
        ArcL Welds1{12}.position,vWeld{12},seam_TRob1,wd12,\Weave:=weave12,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track12;
        !\Track:=track12;

        IF 13>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=13;
        ArcL Welds1{13}.position,vWeld{13},seam_TRob1,wd13,\Weave:=weave13,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track13;
        !\Track:=track13;

        IF 14>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=14;
        ArcL Welds1{14}.position,vWeld{14},seam_TRob1,wd14,\Weave:=weave14,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track14;
        !\Track:=track14;

        IF 15>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=15;
        ArcL Welds1{15}.position,vWeld{15},seam_TRob1,wd15,\Weave:=weave15,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track15;
        !\Track:=track15;

        IF 16>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=16;
        ArcL Welds1{16}.position,vWeld{16},seam_TRob1,wd16,\Weave:=weave16,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track16;
        !\Track:=track16;

        IF 17>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=17;
        ArcL Welds1{17}.position,vWeld{17},seam_TRob1,wd17,\Weave:=weave17,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track17;
        !\Track:=track17;

        IF 18>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=18;
        ArcL Welds1{18}.position,vWeld{18},seam_TRob1,wd18,\Weave:=weave18,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track18;
        !\Track:=track18;

        IF 19>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=19;
        ArcL Welds1{19}.position,vWeld{19},seam_TRob1,wd19,\Weave:=weave19,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track19;
        !\Track:=track19;

        IF 20>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=20;
        ArcL Welds1{20}.position,vWeld{20},seam_TRob1,wd20,\Weave:=weave20,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track20;
        !\Track:=track20;

        IF 21>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=21;
        ArcL Welds1{21}.position,vWeld{21},seam_TRob1,wd21,\Weave:=weave21,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track21;
        !\Track:=track21;

        IF 22>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=22;
        ArcL Welds1{22}.position,vWeld{22},seam_TRob1,wd22,\Weave:=weave22,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track22;
        !\Track:=track22;

        IF 23>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=23;
        ArcL Welds1{23}.position,vWeld{23},seam_TRob1,wd23,\Weave:=weave23,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track23;
        !\Track:=track23;

        IF 24>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=24;
        ArcL Welds1{24}.position,vWeld{24},seam_TRob1,wd24,\Weave:=weave24,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track24;
        !\Track:=track24;

        IF 25>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=25;
        ArcL Welds1{25}.position,vWeld{25},seam_TRob1,wd25,\Weave:=weave25,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track25;
        !\Track:=track25;

        IF 26>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=26;
        ArcL Welds1{26}.position,vWeld{26},seam_TRob1,wd26,\Weave:=weave26,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track26;
        !\Track:=track26;

        IF 27>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=27;
        ArcL Welds1{27}.position,vWeld{27},seam_TRob1,wd27,\Weave:=weave27,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track27;
        !\Track:=track27;

        IF 28>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=28;
        ArcL Welds1{28}.position,vWeld{28},seam_TRob1,wd28,\Weave:=weave28,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track28;
        !\Track:=track28;

        IF 29>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=29;
        ArcL Welds1{29}.position,vWeld{29},seam_TRob1,wd29,\Weave:=weave29,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track29;
        !\Track:=track29;

        IF 30>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=30;
        ArcL Welds1{30}.position,vWeld{30},seam_TRob1,wd30,\Weave:=weave30,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track30;
        !\Track:=track30;

        IF 31>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=31;
        ArcL Welds1{31}.position,vWeld{31},seam_TRob1,wd31,\Weave:=weave31,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track31;
        !\Track:=track31;

        IF 32>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=32;
        ArcL Welds1{32}.position,vWeld{32},seam_TRob1,wd32,\Weave:=weave32,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track32;
        !\Track:=track32;

        IF 33>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=33;
        ArcL Welds1{33}.position,vWeld{33},seam_TRob1,wd33,\Weave:=weave33,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track33;
        !\Track:=track33;

        IF 34>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=34;
        ArcL Welds1{34}.position,vWeld{34},seam_TRob1,wd34,\Weave:=weave34,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track34;
        !\Track:=track34;

        IF 35>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=35;
        ArcL Welds1{35}.position,vWeld{35},seam_TRob1,wd35,\Weave:=weave35,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track35;
        !\Track:=track35;

        IF 36>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=36;
        ArcL Welds1{36}.position,vWeld{36},seam_TRob1,wd36,\Weave:=weave36,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track36;
        !\Track:=track36;

        IF 37>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=37;
        ArcL Welds1{37}.position,vWeld{37},seam_TRob1,wd37,\Weave:=weave37,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track37;
        !\Track:=track37;

        IF 38>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=38;
        ArcL Welds1{38}.position,vWeld{38},seam_TRob1,wd38,\Weave:=weave38,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track38;
        !\Track:=track38;

        IF 39>=nMotionStepCount{1} GOTO MoveArcEnd;
        nRunningStep{1}:=39;
        ArcL Welds1{39}.position,vWeld{39},seam_TRob1,wd39,\Weave:=weave39,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track39;
        !\Track:=track39;

        MoveArcEnd:
        nRunningStep{1}:=40;

        ArcLEnd Welds1{40}.position,vWeld{40},seam_TRob1,wd40,\Weave:=weave40,fine,tWeld1\WObj:=wobjWeldLine1\Track:=track40;	
        bArc_On{1}:=FALSE;
        ClkStop clockWeldTime;
        nclockWeldTime{1}:=ClkRead(clockWeldTime);
        !\Track:=track40;
        MoveL RelTool(Welds1{nMotionStepCount{1}}.position,0,0,-50),vTargetSpeed,fine,tWeld1\WObj:=wobjWeldLine1;

        IDelete intOutGantryHold;

        ConfL\On;
        stReact{1}:="WeldOk";
        WaitUntil stCommand="" OR stReact{2}="Error_Arc_Touch";
        IF stReact{2}="Error_Arc_Touch" rArcError;
        stReact{1}:="Ready";

    ENDPROC

    PROC rNoWeld012()
        VAR num nTempMmps;

        IDelete inumMoveG_PosHold;
        CONNECT inumMoveG_PosHold WITH trapMoveG_PosHold;
        ISignalDO so_MoveG_PosHold,1,inumMoveG_PosHold;
        WaitRob\ZeroSpeed;
        WaitSyncTask Wait{20},taskGroup123;
        nRunningStep{1}:=0;
        FOR i FROM 1 TO nMotionStepCount{1} DO
            !===========================================================!
            !!! [mm/sec] = [cm/sec]*10 = [cm/min]*10/60 = [cm/min]/6  !!!
            !===========================================================!
            nTempMmps:=Welds1{i}.cpm/6;
            vWeld{i}:=[nTempMmps,200,200,200];
            vWeld{i}.v_leax:=vWeld{i}.v_leax*1;
            vWeld{i}.v_ori:=vWeld{i}.v_ori*1;
            vWeld{i}.v_reax:=vWeld{i}.v_reax*1;
            vWeld{i}.v_tcp:=vWeld{i}.v_tcp*1;
            IF i=1 THEN
                MoveL RelTool(Welds1{1}.position,0,0,-50),vTargetSpeed,fine,tWeld1\WObj:=wobjWeldLine1;
            ENDIF
            nRunningStep{1}:=i;
            IF i=1 vWeld{1}:=vTargetSpeed;
            MoveL Welds1{i}.position,vWeld{i},fine,tWeld1\WObj:=wobjWeldLine1;
            IF nRunningStep{1}=1 stReact{1}:="T_ROB1_ArcOn";
        ENDFOR
        MoveL RelTool(Welds1{nMotionStepCount{1}}.position,0,0,-50),vTargetSpeed,fine,tWeld1\WObj:=wobjWeldLine1;
        stReact{1}:="WeldOk";
        WaitUntil stCommand="";
        stReact{1}:="Ready";
        RETURN ;
    ENDPROC

    PROC rNoWeld34()
        VAR num nTempMmps;

        !        IDelete inumMoveG_PosHold;
        !        CONNECT inumMoveG_PosHold WITH trapMoveG_PosHold;
        !        ISignalDO so_MoveG_PosHold,1,inumMoveG_PosHold;
        WaitRob\ZeroSpeed;
        WaitSyncTask Wait{20},taskGroup123;

        nRunningStep{1}:=0;
        FOR i FROM 1 TO nMotionStepCount{1} DO
            !===========================================================!
            !!! [mm/sec] = [cm/sec]*10 = [cm/min]*10/60 = [cm/min]/6  !!!
            !===========================================================!
            nTempMmps:=Welds1{i}.cpm/6;
            vWeld{i}:=[nTempMmps,200,200,200];
            vWeld{i}.v_leax:=vWeld{i}.v_leax*1;
            vWeld{i}.v_ori:=vWeld{i}.v_ori*1;
            vWeld{i}.v_reax:=vWeld{i}.v_reax*1;
            vWeld{i}.v_tcp:=vWeld{i}.v_tcp*1;
            IF i=1 THEN
                MoveL RelTool(Welds1{1}.position,0,0,-50),vTargetSpeed,fine,tWeld1\WObj:=wobjWeldLine1;
            ENDIF
            nRunningStep{1}:=i;
            IF i=1 vWeld{1}:=vTargetSpeed;

            IF i>3 AND so_MoveG_PosHold=1 THEN
                WaitUntil so_MoveG_PosHold=0;
            ENDIF

            MoveL Welds1{i}.position,vWeld{i},fine,tWeld1\WObj:=wobjWeldLine1;
            IF nRunningStep{1}=1 stReact{1}:="T_ROB1_ArcOn";
            IF nRunningStep{1}=1 stReact{1}:="T_ROB1_GantryOn";
        ENDFOR

        MoveL RelTool(Welds1{nMotionStepCount{1}}.position,0,0,-50),vTargetSpeed,fine,tWeld1\WObj:=wobjWeldLine1;
        stReact{1}:="WeldOk";
        WaitUntil stCommand="";
        stReact{1}:="Ready";
        RETURN ;
    ENDPROC

    PROC rWireCut()
        VAR jointtarget jTepmCut{10};
        VAR speeddata vTempFast;
        VAR speeddata vTempSlow;
        vTempFast:=[nWireCutSpeed,500,nWireCutSpeed,100];
        vTempSlow:=[nWireCutSpeed/3,500,nWireCutSpeed/3,100];
        PulseDO\PLength:=nInchingTime,soAwManFeedFwd;
        Reset do09_Wire_Cutter_Close;
        Set do10_Wire_Cutter_Open;
        !      WaitTime 2.25;
        jWireCut4.robax:=[90,90,-50,0,0,0];
        MoveAbsJ jWireCut4\NoEOffs,vTempFast,z100,tWeld1;
        MoveAbsJ jWireCut3\NoEOffs,vTempFast,z100,tWeld1;
        MoveAbsJ jWireCut2\NoEOffs,vTempFast,z100,tWeld1;
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
        MoveAbsJ jWireCut3\NoEOffs,vTempFast,z100,tWeld1;
        MoveAbsJ jWireCut4\NoEOffs,vTempFast,z100,tWeld1;
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
        IF bWirecut=[FALSE,TRUE,FALSE] THEN
            MoveAbsJ jWireCut3\NoEOffs,vTempFast,z100,tWeld1;
            jWireCut4.robax:=[40,90,-90,0,0,0];
            MoveAbsJ jWireCut4\NoEOffs,vTempFast,z100,tWeld1;
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

    PROC rTrapNoWeldMove()
        VAR num i;
        VAR targetdata WeldsTemp;
        VAR robtarget pWeldTemp;
        VAR num nTempMmps;
        VAR speeddata vWeldTemp;
        IDelete inumMoveG_PosHold;
        StopMove;
        !        ClearPath;
        !        StorePath;

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
        !        RestoPath;
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
        WaitSyncTask Wait{20},taskGroup123;

        WaitUntil bGanTry_Last_pos=TRUE;
        !        IF pi29_NextCmd=1 nTouchRetryCount{1}:=0;

        nCorrFailOffs_Z:=10*nEntryRetryCount{1};
        IF bRobSwap=TRUE nCorrFailOffs_Y:=(10*nEntryRetryCount{1});
        IF bRobSwap=FALSE nCorrFailOffs_Y:=(10*nEntryRetryCount{1});


        TEST nMacro001{1}
        CASE 0,1,2,3,4,5,8:
            IF edgeEndBuffer1.Breadth<edgeEndBuffer1.Height THEN
                ! Setting Conditions
                IF nMacro001{1}=0 OR nMacro001{1}=1 OR nMacro001{1}=2 OR nMacro001{1}=5 n_X:=-15;
                IF nMacro001{1}=3 OR nMacro001{1}=4 OR nMacro001{1}=8 n_X:=0;
                !                n_Y:=TouchLimit(corrEnd{nMacro001{1}+1}.Y_StartOffset+nEndThick,edgeEndBuffer1.Breadth)+nCorrFailOffs_Y;
                n_Y:=corrEnd{nMacro001{1}+1}.Y_StartOffset+nEndThick+nCorrFailOffs_Y;
                n_Ret_Y:=TouchLimit(corrEnd{nMacro001{1}+1}.Y_ReturnLength,edgeEndBuffer1.Breadth);
                n_Ret_Z:=TouchLimit(corrEnd{nMacro001{1}+1}.Z_ReturnLength,edgeEndBuffer1.Height);
                n_Z:=TouchLimit(corrEnd{nMacro001{1}+1}.Z_StartOffset,edgeEndBuffer1.Height)+nCorrFailOffs_Z;

                ! Touch Entry Location================================================================
                IWatch iErrorDuringEntry;

                rCheckWelder;

                rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir\LIN;
                Reset soLn1Touch;
                IDelete iErrorDuringEntry;

                !                IF bTouchWorkCount{3}=TRUE GOTO TouchComplete_End_Y;
                WaitTime 0;
                !                 rCheckTouchAtStart;
                !=====================================================================================
                ! edge_Y
                IF bTouchWorkCount{1}=FALSE THEN
                    rCorrSearchWeldLineEdgeY n_X,n_Y,n_Z,corrEnd{nMacro001{1}+1}.Y_Depth+nCorrFailOffs_Y+nEndThick,n_Ret_Y,bEnd,bInstalldir,"End_Y";
                    bTouchWorkCount{1}:=TRUE;
                    nTouchRetryCount{1}:=0;
                ENDIF

                ! edge_Z
                IF bTouchWorkCount{2}=FALSE THEN
                    !                 Setting Conditions
                    n_Y:=n_Ret_Y;
                    n_Ret_Z:=TouchLimit(corrEnd{nMacro001{1}+1}.Z_ReturnLength,edgeEndBuffer1.Height);

                    rCorrSearchWeldLineEdgeZ n_X,n_Y,n_Z,corrEnd{nMacro001{1}+1}.Z_Depth+nCorrFailOffs_Z,n_Ret_Z,bEnd,bInstalldir,"End_Z";
                    bTouchWorkCount{2}:=TRUE;
                    nTouchRetryCount{1}:=0;
                ENDIF

                ! Setting Conditions
                n_Z:=n_Ret_Z;
                rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;

                IF nMacro001{1}=3 OR nMacro001{1}=4 OR nMacro001{1}=8 GOTO TouchComplete_End_Y;
                IF nMacro001{1}=2 OR nMacro001{1}=5 THEN
                    IF nMacro001{1}=5 n_Z:=edgeEndBuffer1.HoleSize+1;
                ELSE
                    ! Setting Conditions
                    n_X:=corrEnd{nMacro001{1}+1}.X_StartOffset;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;
                    ! Setting Conditions
                    n_Y:=-5;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;

                ENDIF

                ! edge_X
                IF bTouchWorkCount{3}=FALSE THEN
                    rCorrSearchWeldLineEdgeX n_X,n_Y,n_Z,corrEnd{nMacro001{1}+1}.X_Depth,corrEnd{nMacro001{1}+1}.X_ReturnLength,bEnd,bInstalldir,"End_X";
                    bTouchWorkCount{3}:=TRUE;
                    nTouchRetryCount{1}:=0;
                ENDIF
                ! Setting Conditions
                n_X:=corrEnd{nMacro001{1}+1}.X_ReturnLength;
                rMoveCorrConnect n_X,n_Y,n_Z,0,corrEnd{nMacro001{1}+1}.RY_Torch,0,nHeightBuffer,bEnd,bInstalldir;
                ! Labal
                TouchComplete_End_Y:
                ! Setting Conditions
                n_Y:=n_Ret_Y;
                rMoveCorrConnect n_X,n_Y,n_Z,0,corrEnd{nMacro001{1}+1}.RY_Torch+n_Angle,0,nHeightBuffer,bEnd,bInstalldir;

            ELSE

                ! Setting Conditions
                IF nMacro001{1}=0 OR nMacro001{1}=1 OR nMacro001{1}=2 OR nMacro001{1}=5 n_X:=-15;
                IF nMacro001{1}=3 OR nMacro001{1}=4 OR nMacro001{1}=8 n_X:=0;
                n_Y:=TouchLimit(corrEnd{nMacro001{1}+1}.Y_StartOffset+nEndThick,edgeEndBuffer1.Breadth)+nCorrFailOffs_Y;
                n_Ret_Y:=TouchLimit(corrEnd{nMacro001{1}+1}.Y_ReturnLength,edgeEndBuffer1.Breadth);
                n_Ret_Z:=TouchLimit(corrEnd{nMacro001{1}+1}.Z_ReturnLength,edgeEndBuffer1.Height);
                n_Z:=TouchLimit(corrEnd{nMacro001{1}+1}.Z_StartOffset,edgeEndBuffer1.Height)+nCorrFailOffs_Z;

                IWatch iErrorDuringEntry;

                rCheckWelder;

                rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir\LIN;
                Reset soLn1Touch;
                IDelete iErrorDuringEntry;

                !                IF bTouchWorkCount{3}=TRUE GOTO TouchComplete_End_Z;
                WaitTime 0;
                !    rCheckTouchAtStart;

                ! edge_Z
                IF bTouchWorkCount{1}=FALSE THEN
                    rCorrSearchWeldLineEdgeZ n_X,n_Y,n_Z,corrEnd{nMacro001{1}+1}.Z_Depth+nCorrFailOffs_Z,n_Ret_Z,bEnd,bInstalldir,"End_Z";
                    bTouchWorkCount{1}:=TRUE;
                    nTouchRetryCount{1}:=0;
                ENDIF

                ! edge_Y
                IF bTouchWorkCount{2}=FALSE THEN
                    ! Setting Conditions
                    n_Ret_Y:=TouchLimit(corrEnd{nMacro001{1}+1}.Y_ReturnLength,edgeEndBuffer1.Breadth);
                    n_Z:=n_Ret_Z;
                    rCorrSearchWeldLineEdgeY n_X,n_Y,n_Z,corrEnd{nMacro001{1}+1}.Y_Depth+nCorrFailOffs_Y+nEndThick,n_Ret_Y,bEnd,bInstalldir,"End_Y";
                    bTouchWorkCount{2}:=TRUE;
                    nTouchRetryCount{1}:=0;
                ENDIF

                ! Setting Conditions
                n_Y:=n_Ret_Y;
                rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;

                IF nMacro001{1}=3 OR nMacro001{1}=4 OR nMacro001{1}=8 GOTO TouchComplete_End_Z;
                IF nMacro001{1}=2 OR nMacro001{1}=5 THEN
                    IF nMacro001{1}=5 n_Z:=edgeEndBuffer1.HoleSize+1;
                ELSE

                    ! Setting Conditions
                    n_X:=corrEnd{nMacro001{1}+1}.X_StartOffset;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;
                    ! Setting Conditions
                    n_Y:=-5;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;

                ENDIF

                ! edge_X
                IF bTouchWorkCount{3}=FALSE THEN
                    rCorrSearchWeldLineEdgeX n_X,n_Y,n_Z,corrEnd{nMacro001{1}+1}.X_Depth,corrEnd{nMacro001{1}+1}.X_ReturnLength,bEnd,bInstalldir,"End_X";
                    bTouchWorkCount{3}:=TRUE;
                    nTouchRetryCount{1}:=0;
                ENDIF

                ! Setting Conditions
                n_X:=corrEnd{nMacro001{1}+1}.X_ReturnLength;
                rMoveCorrConnect n_X,n_Y,n_Z,0,corrEnd{nMacro001{1}+1}.RY_Torch,0,nHeightBuffer,bEnd,bInstalldir;
                ! Labal
                TouchComplete_End_Z:
                ! Setting Conditions
                n_Y:=n_Ret_Y;
                rMoveCorrConnect n_X,n_Y,n_Z,0,corrEnd{nMacro001{1}+1}.RY_Torch+n_Angle,0,nHeightBuffer,bEnd,bInstalldir;
            ENDIF
            IF nMacro001{1}=3 OR nMacro001{1}=4 OR nMacro001{1}=8 THEN
                !   IF bEndSearchComplete=FALSE pCorredSplitPos:=ConvertPosWeldLineToFloor(pSearchStart,nWeldLineLength+nCorrX_Store_End,nCorrY_Store_End,nCorrZ_Store_End);
            ENDIF
        CASE 9:
            !   pCorredEndPos:=pCorredSplitPos;
        DEFAULT:
            Stop;
            Stop;
            ExitCycle;
        ENDTEST

        !        IF abs(pCheckBuffer{2}.trans.x-pCheckBuffer{3}.trans.x)<5 rTouchErrorHandling 13;
        !        IF abs(pCheckBuffer{2}.trans.Y-pCheckBuffer{3}.trans.Y)<5 rTouchErrorHandling 13;
        !        IF abs(pCheckBuffer{2}.trans.Z-pCheckBuffer{3}.trans.Z)<5 rTouchErrorHandling 13;

        bTouch_last_R1_Comp:=TRUE;
        bTouch_First_R1_Comp:=FALSE;
        pCorrTemp_End{1}:=CRobT(\TaskName:="T_ROB1"\Tool:=tWeld1\WObj:=wobjWeldLine1);
        pCorrTemp_End{1}.trans:=[nWeldLineLength_R1+nCorrX_Store_End{1},nCorrY_Store_End{1},nCorrZ_Store_End{1}];
        jCorrTemp_End{1}:=CalcJointT(pCorrTemp_End{1},tWeld1\WObj:=wobjWeldLine1);
        pCorrT_ROB1_End:=CalcRobT(jCorrTemp_End{1},Tool:=tWeld1\WObj:=wobjRotCtr1);
        WaitUntil bGanTry_First_pos=TRUE AND bTouch_last_R2_Comp=TRUE;

        !!! Start correctioning from start edge !!!
        TEST nMacro010{1}
        CASE 0,1,2,3,4,5:
            IF edgestartBuffer1.Breadth<edgestartBuffer1.Height THEN

                ! Setting Conditions
                IF nMacro010{1}=0 OR nMacro010{1}=1 OR nMacro010{1}=2 OR nMacro010{1}=5 n_X:=-15;
                IF nMacro010{1}=3 OR nMacro010{1}=4 OR nMacro010{1}=8 n_X:=0;
                !                n_Y:=TouchLimit(corrStart{nMacro010{1}+1}.Y_StartOffset+nStartThick,edgeStartBuffer1.Breadth)+nCorrFailOffs_Y;
                n_Y:=corrStart{nMacro010{1}+1}.Y_StartOffset+nStartThick+nCorrFailOffs_Y;
                n_Ret_Y:=TouchLimit(corrStart{nMacro010{1}+1}.Y_ReturnLength,edgestartBuffer1.Breadth);
                n_Z:=TouchLimit(corrStart{nMacro010{1}+1}.Z_StartOffset,edgestartBuffer1.Height)+nCorrFailOffs_Z;
                n_Ret_Z:=TouchLimit(corrStart{nMacro010{1}+1}.Z_ReturnLength,edgestartBuffer1.Height);

                ! edge_Y
                rMoveCorrConnect n_X,n_Y,n_Z,0,corrStart{nMacro010{1}+1}.RY_Torch+n_Angle,0,nHeightBuffer,bStart,bInstalldir\LIN;
                !    rCheckTouchAtStart;

                IF bTouchWorkCount{4}=FALSE THEN
                    rCorrSearchWeldLineEdgeY n_X,n_Y,n_Z,corrStart{nMacro010{1}+1}.Y_Depth+nCorrFailOffs_Y+nStartThick,n_Ret_Y,bStart,bInstalldir,"Start_Y";
                    bTouchWorkCount{4}:=TRUE;
                    nTouchRetryCount{1}:=0;
                ENDIF

                ! edge_Z
                IF bTouchWorkCount{5}=FALSE THEN
                    ! Setting Conditions
                    n_Y:=n_Ret_Y;
                    n_Ret_Z:=TouchLimit(corrStart{nMacro010{1}+1}.Z_ReturnLength,edgestartBuffer1.Height);
                    rCorrSearchWeldLineEdgeZ n_X,n_Y,n_Z,corrStart{nMacro010{1}+1}.Z_Depth+nCorrFailOffs_Z,n_Ret_Z,bStart,bInstalldir,"Start_Z";
                    bTouchWorkCount{5}:=TRUE;
                    nTouchRetryCount{1}:=0;
                ENDIF

                ! Setting Conditions
                n_Z:=n_Ret_Z;
                rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;

                IF nMacro010{1}=3 OR nMacro010{1}=4 OR nMacro010{1}=8 GOTO TouchComplete_Start_Y;
                IF nMacro010{1}=2 OR nMacro010{1}=5 THEN
                    IF nMacro010{1}=5 n_Z:=edgestartBuffer1.HoleSize+1;
                ELSE

                    ! Setting Conditions
                    n_X:=corrStart{nMacro010{1}+1}.X_StartOffset;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;
                    ! Setting Conditions
                    n_Y:=-5;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;
                ENDIF
                !    ENDIF

                ! edge_X
                IF bTouchWorkCount{6}=FALSE THEN
                    rCorrSearchWeldLineEdgeX n_X,n_Y,n_Z,corrStart{nMacro010{1}+1}.X_Depth,corrStart{nMacro010{1}+1}.X_ReturnLength,bStart,bInstalldir,"Start_X";
                    bTouchWorkCount{6}:=TRUE;
                    nTouchRetryCount{1}:=0;
                ENDIF
                ! Setting Conditions
                n_X:=corrStart{nMacro010{1}+1}.X_ReturnLength;
                rMoveCorrConnect n_X,n_Y,n_Z,0,corrStart{nMacro010{1}+1}.RY_Torch,0,nHeightBuffer,bStart,bInstalldir;
                ! Labal
                TouchComplete_Start_Y:
            ELSE

                ! Setting Conditions
                IF nMacro010{1}=0 OR nMacro010{1}=1 OR nMacro010{1}=2 OR nMacro010{1}=5 n_X:=-15;
                IF nMacro010{1}=3 OR nMacro010{1}=4 OR nMacro010{1}=8 n_X:=0;
                n_Y:=TouchLimit(corrStart{nMacro010{1}+1}.Y_StartOffset+nStartThick,edgestartBuffer1.Breadth)+nCorrFailOffs_Y;
                n_Ret_Y:=TouchLimit(corrStart{nMacro010{1}+1}.Y_ReturnLength,edgestartBuffer1.Breadth);
                n_Ret_Z:=TouchLimit(corrStart{nMacro010{1}+1}.Z_ReturnLength,edgestartBuffer1.Height);
                n_Z:=TouchLimit(corrStart{nMacro010{1}+1}.Z_StartOffset,edgestartBuffer1.Height)+nCorrFailOffs_Z;

                rMoveCorrConnect n_X,n_Y,n_Z,0,corrStart{nMacro010{1}+1}.RY_Torch+n_Angle,0,nHeightBuffer,bStart,bInstalldir\LIN;
                ! rCheckTouchAtStart;


                ! edge_Z
                IF bTouchWorkCount{4}=FALSE THEN
                    rCorrSearchWeldLineEdgeZ n_X,n_Y,n_Z,corrStart{nMacro010{1}+1}.Z_Depth+nCorrFailOffs_Z,n_Ret_Z,bStart,bInstalldir,"Start_Z";
                    bTouchWorkCount{4}:=TRUE;
                    nTouchRetryCount{1}:=0;
                ENDIF
                ! Setting Conditions


                ! edge_Y
                IF bTouchWorkCount{5}=FALSE THEN
                    ! Setting Conditions
                    n_Ret_Y:=TouchLimit(corrStart{nMacro010{1}+1}.Y_ReturnLength,edgestartBuffer1.Breadth);
                    n_Z:=n_Ret_Z;
                    rCorrSearchWeldLineEdgeY n_X,n_Y,n_Z,corrStart{nMacro010{1}+1}.Y_Depth+nCorrFailOffs_Y+nStartThick,n_Ret_Y,bStart,bInstalldir,"Start_Y";
                    bTouchWorkCount{5}:=TRUE;
                    nTouchRetryCount{1}:=0;
                ENDIF

                ! Setting Conditions
                n_Y:=n_Ret_Y;
                rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;

                IF nMacro010{1}=3 OR nMacro010{1}=4 OR nMacro010{1}=8 GOTO TouchComplete_Start_Z;
                IF nMacro010{1}=2 OR nMacro010{1}=5 THEN
                    IF nMacro010{1}=5 n_Z:=edgestartBuffer1.HoleSize+1;
                ELSE
                    !    IF bTouchWorkCount{6}=FALSE THEN
                    ! Setting Conditions
                    n_X:=corrStart{nMacro010{1}+1}.X_StartOffset;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;
                    ! Setting Conditions
                    n_Y:=-5;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;
                ENDIF
                ! ENDIF

                ! edge_X
                IF bTouchWorkCount{6}=FALSE THEN
                    rCorrSearchWeldLineEdgeX n_X,n_Y,n_Z,corrStart{nMacro010{1}+1}.X_Depth,corrStart{nMacro010{1}+1}.X_ReturnLength,bStart,bInstalldir,"Start_X";
                    bTouchWorkCount{6}:=TRUE;
                    nTouchRetryCount{1}:=0;
                ENDIF
                ! Setting Conditions
                n_X:=corrStart{nMacro010{1}+1}.X_ReturnLength;
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
            pSearchStart.rot:=Welds1{1}.position.rot;
            IF (CCW=FALSE) pSearchStart.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(-1*Y),nCorrZ_Store+(Z)];
        ELSEIF (isStartPos=bEnd) THEN
            pSearchStart.rot:=Welds1{nMotionStepCount{1}}.position.rot;
            IF (CCW=FALSE) pSearchStart.trans:=[nWeldLineLength_R1+nCorrX_Store+(X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart.trans:=[nWeldLineLength_R1+nCorrX_Store+(X),nCorrY_Store+(-1*Y),nCorrZ_Store+(Z)];
        ENDIF

        pSearchStart.robconf.cfx:=1;
        pSearchStart.extax:=[9e9,9e9,9e9,9e9,9e9,9e9];

        pSearchEnd:=pSearchStart;
        IF (isStartPos=bStart) pSearchEnd.trans.x:=pSearchStart.trans.x+Depth;
        IF (isStartPos=bEnd) pSearchEnd.trans.x:=pSearchStart.trans.x-Depth;

        rCorrSearchByWire pSearchStart,pSearchEnd\X;

        !        pCheckBuffer{1}.trans:=pCorredPosBuffer;

        IF (isStartPos=bStart) nCorrX_Store:=pCorredPosBuffer.x;
        IF (isStartPos=bEnd) nCorrX_Store:=pCorredPosBuffer.x-nWeldLineLength_R1;

        IF (isStartPos=bStart) THEN
            nCorrX_Store_Start{1}:=nCorrX_Store;
            nCorrY_Store_Start{1}:=nCorrY_Store;
            nCorrZ_Store_Start{1}:=nCorrZ_Store;
        ELSE
            nCorrX_Store_End{1}:=nCorrX_Store;
            nCorrY_Store_End{1}:=nCorrY_Store;
            nCorrZ_Store_End{1}:=nCorrZ_Store;
        ENDIF

        rMoveCorrConnect RetX,Y,Z,0,0,0,pSearchStart.extax.eax_d,isStartPos,CCW;
        nTouchRetryCount{1}:=0;
        TouchErrorDirMain:="Ready";

        RETURN ;
    ENDPROC

    PROC rCorrSearchWeldLineEdgeY(num X,num Y,num Z,num Depth,num RetY,bool isStartPos,bool CCW,string dirErrorCheck)
        VAR num nCorrX_Store;
        VAR num nCorrY_Store;
        VAR num nCorrZ_Store;
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
            pSearchStart.rot:=Welds1{1}.position.rot;
            IF (CCW=FALSE) pSearchStart.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(-1*Y),nCorrZ_Store+Z];
        ELSEIF (isStartPos=bEnd) THEN
            pSearchStart.rot:=Welds1{nMotionStepCount{1}}.position.rot;
            IF (CCW=FALSE) pSearchStart.trans:=[nWeldLineLength_R1+nCorrX_Store+(X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart.trans:=[nWeldLineLength_R1+nCorrX_Store+(X),nCorrY_Store+(-1*Y),nCorrZ_Store+(Z)];
        ENDIF

        pSearchStart.robconf.cfx:=1;

        pSearchEnd:=pSearchStart;
        pSearchStart.extax:=[9e9,9e9,9e9,9e9,9e9,9e9];
        IF (CCW=FALSE) pSearchEnd.trans.y:=pSearchStart.trans.y-Depth;
        IF (CCW=TRUE) pSearchEnd.trans.y:=pSearchStart.trans.y+Depth;

        rCorrSearchByWire pSearchStart,pSearchEnd\Y;

        !        pCheckBuffer{2}.trans:=pCorredPosBuffer;

        nCorrY_Store:=pCorredPosBuffer.y;

        IF (isStartPos=bStart) THEN
            nCorrX_Store_Start{1}:=nCorrX_Store;
            nCorrY_Store_Start{1}:=nCorrY_Store;
            nCorrZ_Store_Start{1}:=nCorrZ_Store;
        ELSE
            nCorrX_Store_End{1}:=nCorrX_Store;
            nCorrY_Store_End{1}:=nCorrY_Store;
            nCorrZ_Store_End{1}:=nCorrZ_Store;
        ENDIF

        rMoveCorrConnect X,RetY,Z,0,0,0,pSearchStart.extax.eax_d,isStartPos,CCW;
        nTouchRetryCount{1}:=0;
        TouchErrorDirMain:="Ready";

        RETURN ;
    ENDPROC

    PROC rCorrSearchWeldLineEdgeZ(num X,num Y,num Z,num Depth,num RetZ,bool isStartPos,bool CCW,string dirErrorCheck)
        VAR num nCorrX_Store;
        VAR num nCorrY_Store;
        VAR num nCorrZ_Store;
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
            pSearchStart.rot:=Welds1{1}.position.rot;
            IF (CCW=FALSE) pSearchStart.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(-1*Y),nCorrZ_Store+(Z)];
        ELSEIF (isStartPos=bEnd) THEN
            pSearchStart.rot:=Welds1{nMotionStepCount{1}}.position.rot;
            IF (CCW=FALSE) pSearchStart.trans:=[nWeldLineLength_R1+nCorrX_Store+(X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart.trans:=[nWeldLineLength_R1+nCorrX_Store+(X),nCorrY_Store+(-1*Y),nCorrZ_Store+(Z)];
        ENDIF

        pSearchStart.robconf.cfx:=1;
        pSearchStart.extax:=[9e9,9e9,9e9,9e9,9e9,9e9];

        pSearchEnd:=pSearchStart;
        pSearchEnd.trans.z:=pSearchStart.trans.z-Depth;

        rCorrSearchByWire pSearchStart,pSearchEnd\Z;

        !        pCheckBuffer{3}.trans:=pCorredPosBuffer;

        nCorrZ_Store:=pCorredPosBuffer.z;

        IF (isStartPos=bStart) THEN
            nCorrX_Store_Start{1}:=nCorrX_Store;
            nCorrY_Store_Start{1}:=nCorrY_Store;
            nCorrZ_Store_Start{1}:=nCorrZ_Store;
        ELSE
            nCorrX_Store_End{1}:=nCorrX_Store;
            nCorrY_Store_End{1}:=nCorrY_Store;
            nCorrZ_Store_End{1}:=nCorrZ_Store;
        ENDIF

        rMoveCorrConnect X,Y,RetZ,0,0,0,pSearchStart.extax.eax_d,isStartPos,CCW;
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
        pCorredPosBuffer:=pTemp.trans;
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

        !        WaitSyncTask Wait{81},taskGroup123;

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
        StopMove;
        ClearPath;
        StartMove;
        IF bRobSwap=FALSE THEN
            Set po36_ArcR1Error;
            MonitorweldErrorpostion.monPose1:=MonitorPosition.monPose1;
            MonitorweldErrorpostion.monPose2:=MonitorPosition.monPose2;
        ELSE
            Set po37_ArcR2Error;
            MonitorweldErrorpostion.monPose1:=MonitorPosition.monPose1;
            MonitorweldErrorpostion.monPose2:=MonitorPosition.monPose2;
        ENDIF

        pTemp:=CRobT(\TaskName:="T_ROB1"\Tool:=tWeld1\WObj:=wobjWeldLine1);
        MoveL RelTool(pTemp,0,0,-10),vTargetSpeed,z0,tWeld1\WObj:=wobjWeldLine1;
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
        Stop;
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
        pTemp:=CRobT(\TaskName:="T_ROB1"\Tool:=tWeld1\WObj:=wobjWeldLine1);
        IF Abs(pTemp.trans.Y)<100 AND Abs(pTemp.trans.Z)<200 THEN
            IF pTemp.trans.Y>0 THEN
                pTemp.trans.y:=130;
                MoveL pTemp,v100,fine,tWeld1\WObj:=wobjWeldLine1;
            ENDIF
            IF pTemp.trans.Y<0 THEN
                pTemp.trans.y:=-130;
                MoveL pTemp,v100,fine,tWeld1\WObj:=wobjWeldLine1;
            ENDIF
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
ENDMODULE
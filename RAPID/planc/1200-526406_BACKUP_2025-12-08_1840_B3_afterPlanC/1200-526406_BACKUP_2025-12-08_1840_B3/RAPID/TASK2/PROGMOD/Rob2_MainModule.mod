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
    TASK PERS speeddata vWeld{40}:=[[10,200,200,200],[10,200,200,200],[10,200,200,200],[10,200,200,200],[9.16667,200,200,200],[9.16667,200,200,200],[8.33333,200,200,200],[7.5,200,200,200],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[10,200,200,200]];
    PERS seamdata smDefault_2{2};
    PERS seamdata seam_TRob2;

    PERS speeddata vTargetSpeed;
    PERS zonedata zTargetZone;

    TASK PERS welddata wdTrap:=[10,0,[5,0,38,240,0,400,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd1:=[10,0,[5,0,36.3,232,0,360,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd2:=[10,0,[5,0,36.3,232,0,360,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd3:=[10,0,[5,0,36.3,232,0,360,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd4:=[10,0,[5,0,36.3,232,0,360,0,0,0],[0,0,0,0,0,0,0,0,0]];
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
    TASK PERS welddata wd40:=[10,0,[5,0,36.3,232,0,360,0,0,0],[0,0,0,0,0,0,0,0,0]];

    TASK PERS welddata Holdwd1:=[10,0,[5,0,36.3,232,0,360,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata Holdwd2:=[10,0,[5,0,36.3,232,0,360,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata Holdwd3:=[10,0,[5,0,36.3,232,0,360,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata Holdwd4:=[10,0,[5,0,36.3,232,0,360,0,0,0],[0,0,0,0,0,0,0,0,0]];
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


    PERS num nWeldLineLength:=400;
    ! 264.966;
    PERS num nWeldLineLength_R2;
    ! 264.966;
    PERS robtarget pSearchStart:=[[0,27,-3.52258],[0.241845,0.664463,-0.664463,0.241845],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS robtarget pSearchEnd:=[[0,-25,-3.52258],[0.241845,0.664463,-0.664463,0.241845],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    TASK PERS string TouchErrorDirSub:="Start_Y";
    TASK PERS string TouchErrorDirMain:="Ready";
    PERS num nTouchRetryCount{2};
    PERS num n_Angle;
    TASK PERS num RetryDepthData{3}:=[10,10,10];
    PERS robtarget pWeldPosR2{40}:=[[[-3,7,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.31,9E+09,9E+09]],[[-3,7,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.31,9E+09,9E+09]],[[-3,-4.5,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.31,9E+09,9E+09]],[[15,-1,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.34,9E+09,9E+09]],[[200,-1,1],[0.270598,-0.653282,-0.653282,-0.270598],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.72,9E+09,9E+09]],[[1390,-1.00592,0.996463],[0.270597,-0.653283,-0.653281,-0.270597],[0,0,-1,1],[-8707.81,-8707.8,1477.15,1033.13,9E+09,9E+09]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[1390,-1,1],[0.270598,-0.653282,-0.653282,-0.270598],[-1,0,0,1],[-8707.8,-8707.8,1477.15,1033.12,9E+09,9E+09]]];
    PERS num nRobCorrSpaceHeight;
    PERS pos pCorredPosBuffer:=[-0.0203692,-6.43895,-2.02792];
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
    TASK PERS bool bTouchWorkCount{6}:=[FALSE,FALSE,FALSE,FALSE,FALSE,FALSE];
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
    TASK PERS seamdata tsm2:=[0.5,0.5,[5,0,24,120,0,0,0,0,0],0,0,0,0,0,[0,0,0,0,0,0,0,0,0],0,1,[0,0,24,120,0,0,0,0,0],0,0,[0,0,0,0,0,0,0,0,0],0];
    TASK PERS welddata twel2:=[0.01,0,[0,0,32,0,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS weavedata tweav2:=[1,2,2,2,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS bool bInstalldir:=TRUE;
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

    TRAP trapOutGantryHold
        IDelete intOutGantryHold;
        bGantryInTrap{2}:=FALSE;
        Reset intReHoldGantry_2;
        Holdwd1:=[Welds2{1}.cpm/6,0,[5,0,Welds2{1}.voltage,Welds2{1}.wfs,0,Welds2{1}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd2:=[Welds2{2}.cpm/6,0,[5,0,Welds2{2}.voltage,Welds2{2}.wfs,0,Welds2{2}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd3:=[Welds2{3}.cpm/6,0,[5,0,Welds2{3}.voltage,Welds2{3}.wfs,0,Welds2{3}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd4:=[Welds2{4}.cpm/6,0,[5,0,Welds2{4}.voltage,Welds2{4}.wfs,0,Welds2{4}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd5:=[Welds2{5}.cpm/6,0,[5,0,Welds2{5}.voltage,Welds2{5}.wfs,0,Welds2{5}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd6:=[Welds2{6}.cpm/6,0,[5,0,Welds2{6}.voltage,Welds2{6}.wfs,0,Welds2{6}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd7:=[Welds2{7}.cpm/6,0,[5,0,Welds2{7}.voltage,Welds2{7}.wfs,0,Welds2{7}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd8:=[Welds2{8}.cpm/6,0,[5,0,Welds2{8}.voltage,Welds2{8}.wfs,0,Welds2{8}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd9:=[Welds2{9}.cpm/6,0,[5,0,Welds2{9}.voltage,Welds2{9}.wfs,0,Welds2{9}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd10:=[Welds2{10}.cpm/6,0,[5,0,Welds2{10}.voltage,Welds2{10}.wfs,0,Welds2{10}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        ArcRefresh;
    ENDTRAP

    TRAP trapMoveG_PosHold
        rTrapWeldMove;
    ENDTRAP

    TRAP trapErrorDuringEntry
        Set po34_EntryR2Error;
        IDelete iMoveHome_RBT2;
        rErrorDuringEntry;
    ENDTRAP

    TRAP trapMoveHome_RBT2
        VAR robtarget pTemp;
        IDelete iMoveHome_RBT2;
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
            WaitUntil stCommand<>"";
            !retry val init
            !rWeldinit;
            TEST stCommand
            CASE "MoveJgJ":
                !                WaitSyncTask Wait{nMoveid+1},taskGroup123;
                SyncMoveOn SynchronizeJGJon{nMoveid+2},taskGroup123;
                MoveAbsJ jRob2\ID:=nMoveid+3,vSync,zSync,tool:=tool0;
                SyncMoveOff SynchronizeJGJoff{nMoveid+4};
                stReact{2}:="Ack";
                WaitUntil stCommand="";
                stReact{2}:="Ready";
            CASE "MovePgJ":
                !                WaitSyncTask Wait{nMoveid+1},taskGroup123;
                SyncMoveOn SynchronizePGJon{nMoveid+2},taskGroup123;
                MoveJ pRob2\ID:=nMoveid+3,vSync,zSync,tool:=tool0;
                SyncMoveOff SynchronizePGJoff{nMoveid+4};
                stReact{2}:="Ack";
                WaitUntil stCommand="";
                stReact{2}:="Ready";
            CASE "MovePgL":
                !                WaitSyncTask Wait{nMoveid+1},taskGroup123;
                SyncMoveOn SynchronizePGLon{nMoveid+2},taskGroup123;
                MoveJ pRob2\ID:=nMoveid+3,vSync,zSync,tool:=tool0;
                SyncMoveOff SynchronizePGLoff{nMoveid+4};
                stReact{2}:="Ack";
                WaitUntil stCommand="";
                stReact{2}:="Ready";
            CASE "Weld":
                IF bEnableWeldSkip=TRUE THEN
                    IF (nMacro010{1}=3 AND nMacro010{2}=3) OR (nMacro010{1}=4 AND nMacro010{2}=4) THEN
                        rNoWeld34;
                    ELSE
                        rNoWeld012;
                    ENDIF
                ELSE
                    IDelete iMoveHome_RBT2;
                    !                    CONNECT iMoveHome_RBT2 WITH trapMoveHome_RBT2;
                    !                    ISignalDO intMoveHome_RBT2,1,iMoveHome_RBT2;
                    IF (nMacro010{1}=3 AND nMacro010{2}=3) OR (nMacro010{1}=4 AND nMacro010{2}=4) THEN
                        rWeld34;
                    ELSE
                        rWeld012;
                    ENDIF
                    IDelete iMoveHome_RBT2;
                ENDIF
                nTrapCheck_2:=0;
            CASE "CorrSearchStartEnd":
                IF nEntryRetryCount{2}=0 THEN
                    nCorrFailOffs_Y:=0;
                    nCorrFailOffs_Z:=0;
                ENDIF
                IF nTouchRetryCount{2}=0 THEN
                    bTouchWorkCount:=[FALSE,FALSE,FALSE,FALSE,FALSE,FALSE];
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

                bTouchWorkCount:=[FALSE,FALSE,FALSE,FALSE,FALSE,FALSE];
                IDelete iMoveHome_RBT2;

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

            CASE "checkpos":
                rT_ROB2check;
                stReact{2}:="checkposok";
                WaitUntil stCommand="";
                stReact{2}:="Ready";
            DEFAULT:
                stReact{2}:="Error";
                Stop;
            ENDTEST
        ENDWHILE

    ENDPROC

    PROC rInit()
        AccSet 30,30;

        stReact{2}:="";
        WaitUntil stCommand="";
        stReact{2}:="Ready";
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
    ENDPROC

    PROC rWeld012()

        VAR num nTempMmps;
        VAR num nTempVolt;
        VAR num nTempWFS;
        VAR num wdArray{40};
        VAR speeddata vHoldspeed;
        VAR num nHoldWeldVel;
        VAR num nHoldDist:=0;

        nHoldWeldVel:=0.01;
        IDelete inumMoveG_PosHold;
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
        wd11:=[Welds2{11}.cpm/6,0,[5,0,Welds2{11}.voltage,Welds2{11}.wfs,0,Welds2{11}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd12:=[Welds2{12}.cpm/6,0,[5,0,Welds2{12}.voltage,Welds2{12}.wfs,0,Welds2{12}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd13:=[Welds2{13}.cpm/6,0,[5,0,Welds2{13}.voltage,Welds2{13}.wfs,0,Welds2{13}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd14:=[Welds2{14}.cpm/6,0,[5,0,Welds2{14}.voltage,Welds2{14}.wfs,0,Welds2{14}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd15:=[Welds2{15}.cpm/6,0,[5,0,Welds2{15}.voltage,Welds2{15}.wfs,0,Welds2{15}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd16:=[Welds2{16}.cpm/6,0,[5,0,Welds2{16}.voltage,Welds2{16}.wfs,0,Welds2{16}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd17:=[Welds2{17}.cpm/6,0,[5,0,Welds2{17}.voltage,Welds2{17}.wfs,0,Welds2{17}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd18:=[Welds2{18}.cpm/6,0,[5,0,Welds2{18}.voltage,Welds2{18}.wfs,0,Welds2{18}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd19:=[Welds2{19}.cpm/6,0,[5,0,Welds2{19}.voltage,Welds2{19}.wfs,0,Welds2{19}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd20:=[Welds2{20}.cpm/6,0,[5,0,Welds2{20}.voltage,Welds2{20}.wfs,0,Welds2{20}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd21:=[Welds2{21}.cpm/6,0,[5,0,Welds2{21}.voltage,Welds2{21}.wfs,0,Welds2{21}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd22:=[Welds2{22}.cpm/6,0,[5,0,Welds2{22}.voltage,Welds2{22}.wfs,0,Welds2{22}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd23:=[Welds2{23}.cpm/6,0,[5,0,Welds2{23}.voltage,Welds2{23}.wfs,0,Welds2{23}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd24:=[Welds2{24}.cpm/6,0,[5,0,Welds2{24}.voltage,Welds2{24}.wfs,0,Welds2{24}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd25:=[Welds2{25}.cpm/6,0,[5,0,Welds2{25}.voltage,Welds2{25}.wfs,0,Welds2{25}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd26:=[Welds2{26}.cpm/6,0,[5,0,Welds2{26}.voltage,Welds2{26}.wfs,0,Welds2{26}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd27:=[Welds2{27}.cpm/6,0,[5,0,Welds2{27}.voltage,Welds2{27}.wfs,0,Welds2{27}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd28:=[Welds2{28}.cpm/6,0,[5,0,Welds2{28}.voltage,Welds2{28}.wfs,0,Welds2{28}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd29:=[Welds2{29}.cpm/6,0,[5,0,Welds2{29}.voltage,Welds2{29}.wfs,0,Welds2{29}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd30:=[Welds2{30}.cpm/6,0,[5,0,Welds2{30}.voltage,Welds2{30}.wfs,0,Welds2{30}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd31:=[Welds2{31}.cpm/6,0,[5,0,Welds2{31}.voltage,Welds2{31}.wfs,0,Welds2{31}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd32:=[Welds2{32}.cpm/6,0,[5,0,Welds2{32}.voltage,Welds2{32}.wfs,0,Welds2{32}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd33:=[Welds2{33}.cpm/6,0,[5,0,Welds2{33}.voltage,Welds2{33}.wfs,0,Welds2{33}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd34:=[Welds2{34}.cpm/6,0,[5,0,Welds2{34}.voltage,Welds2{34}.wfs,0,Welds2{34}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd35:=[Welds2{35}.cpm/6,0,[5,0,Welds2{35}.voltage,Welds2{35}.wfs,0,Welds2{35}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd36:=[Welds2{36}.cpm/6,0,[5,0,Welds2{36}.voltage,Welds2{36}.wfs,0,Welds2{36}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd37:=[Welds2{37}.cpm/6,0,[5,0,Welds2{37}.voltage,Welds2{37}.wfs,0,Welds2{37}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd38:=[Welds2{38}.cpm/6,0,[5,0,Welds2{38}.voltage,Welds2{38}.wfs,0,Welds2{38}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd39:=[Welds2{39}.cpm/6,0,[5,0,Welds2{39}.voltage,Welds2{39}.wfs,0,Welds2{39}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd40:=[Welds2{nMotionStepCount{2}}.cpm/6,0,[5,0,Welds2{nMotionStepCount{2}}.voltage,Welds2{nMotionStepCount{2}}.wfs,0,Welds2{nMotionStepCount{2}}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];

        Holdwd1:=[nHoldWeldVel,0,[5,0,Welds2{1}.voltage,Welds2{1}.wfs,0,Welds2{1}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd2:=[nHoldWeldVel,0,[5,0,Welds2{2}.voltage,Welds2{2}.wfs,0,Welds2{2}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd3:=[nHoldWeldVel,0,[5,0,Welds2{3}.voltage,Welds2{3}.wfs,0,Welds2{3}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd4:=[nHoldWeldVel,0,[5,0,Welds2{4}.voltage,Welds2{4}.wfs,0,Welds2{4}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd5:=[nHoldWeldVel,0,[5,0,Welds2{5}.voltage,Welds2{5}.wfs,0,Welds2{5}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd6:=[nHoldWeldVel,0,[5,0,Welds2{6}.voltage,Welds2{6}.wfs,0,Welds2{6}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd7:=[nHoldWeldVel,0,[5,0,Welds2{7}.voltage,Welds2{7}.wfs,0,Welds2{7}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd8:=[nHoldWeldVel,0,[5,0,Welds2{8}.voltage,Welds2{8}.wfs,0,Welds2{8}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd9:=[nHoldWeldVel,0,[5,0,Welds2{9}.voltage,Welds2{9}.wfs,0,Welds2{9}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd10:=[nHoldWeldVel,0,[5,0,Welds2{10}.voltage,Welds2{10}.wfs,0,Welds2{10}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];

        ! Define Wave Data
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
        weave11:=[Welds2{11}.WeaveShape,Welds2{11}.WeaveType,Welds2{11}.WeaveLength,Welds2{11}.WeaveWidth,0,Welds2{11}.WeaveDwellLeft,0,Welds2{11}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave12:=[Welds2{12}.WeaveShape,Welds2{12}.WeaveType,Welds2{12}.WeaveLength,Welds2{12}.WeaveWidth,0,Welds2{12}.WeaveDwellLeft,0,Welds2{12}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave13:=[Welds2{13}.WeaveShape,Welds2{13}.WeaveType,Welds2{13}.WeaveLength,Welds2{13}.WeaveWidth,0,Welds2{13}.WeaveDwellLeft,0,Welds2{13}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave14:=[Welds2{14}.WeaveShape,Welds2{14}.WeaveType,Welds2{14}.WeaveLength,Welds2{14}.WeaveWidth,0,Welds2{14}.WeaveDwellLeft,0,Welds2{14}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave15:=[Welds2{15}.WeaveShape,Welds2{15}.WeaveType,Welds2{15}.WeaveLength,Welds2{15}.WeaveWidth,0,Welds2{15}.WeaveDwellLeft,0,Welds2{15}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave16:=[Welds2{16}.WeaveShape,Welds2{16}.WeaveType,Welds2{16}.WeaveLength,Welds2{16}.WeaveWidth,0,Welds2{16}.WeaveDwellLeft,0,Welds2{16}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave17:=[Welds2{17}.WeaveShape,Welds2{17}.WeaveType,Welds2{17}.WeaveLength,Welds2{17}.WeaveWidth,0,Welds2{17}.WeaveDwellLeft,0,Welds2{17}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave18:=[Welds2{18}.WeaveShape,Welds2{18}.WeaveType,Welds2{18}.WeaveLength,Welds2{18}.WeaveWidth,0,Welds2{18}.WeaveDwellLeft,0,Welds2{18}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave19:=[Welds2{19}.WeaveShape,Welds2{19}.WeaveType,Welds2{19}.WeaveLength,Welds2{19}.WeaveWidth,0,Welds2{19}.WeaveDwellLeft,0,Welds2{19}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave20:=[Welds2{20}.WeaveShape,Welds2{20}.WeaveType,Welds2{20}.WeaveLength,Welds2{20}.WeaveWidth,0,Welds2{20}.WeaveDwellLeft,0,Welds2{20}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave21:=[Welds2{21}.WeaveShape,Welds2{21}.WeaveType,Welds2{21}.WeaveLength,Welds2{21}.WeaveWidth,0,Welds2{21}.WeaveDwellLeft,0,Welds2{21}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave22:=[Welds2{22}.WeaveShape,Welds2{22}.WeaveType,Welds2{22}.WeaveLength,Welds2{22}.WeaveWidth,0,Welds2{22}.WeaveDwellLeft,0,Welds2{22}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave23:=[Welds2{23}.WeaveShape,Welds2{23}.WeaveType,Welds2{23}.WeaveLength,Welds2{23}.WeaveWidth,0,Welds2{23}.WeaveDwellLeft,0,Welds2{23}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave24:=[Welds2{24}.WeaveShape,Welds2{24}.WeaveType,Welds2{24}.WeaveLength,Welds2{24}.WeaveWidth,0,Welds2{24}.WeaveDwellLeft,0,Welds2{24}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave25:=[Welds2{25}.WeaveShape,Welds2{25}.WeaveType,Welds2{25}.WeaveLength,Welds2{25}.WeaveWidth,0,Welds2{25}.WeaveDwellLeft,0,Welds2{25}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave26:=[Welds2{26}.WeaveShape,Welds2{26}.WeaveType,Welds2{26}.WeaveLength,Welds2{26}.WeaveWidth,0,Welds2{26}.WeaveDwellLeft,0,Welds2{26}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave27:=[Welds2{27}.WeaveShape,Welds2{27}.WeaveType,Welds2{27}.WeaveLength,Welds2{27}.WeaveWidth,0,Welds2{27}.WeaveDwellLeft,0,Welds2{27}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave28:=[Welds2{28}.WeaveShape,Welds2{28}.WeaveType,Welds2{28}.WeaveLength,Welds2{28}.WeaveWidth,0,Welds2{28}.WeaveDwellLeft,0,Welds2{28}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave29:=[Welds2{29}.WeaveShape,Welds2{29}.WeaveType,Welds2{29}.WeaveLength,Welds2{29}.WeaveWidth,0,Welds2{29}.WeaveDwellLeft,0,Welds2{29}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave30:=[Welds2{30}.WeaveShape,Welds2{30}.WeaveType,Welds2{30}.WeaveLength,Welds2{30}.WeaveWidth,0,Welds2{30}.WeaveDwellLeft,0,Welds2{30}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave31:=[Welds2{31}.WeaveShape,Welds2{31}.WeaveType,Welds2{31}.WeaveLength,Welds2{31}.WeaveWidth,0,Welds2{31}.WeaveDwellLeft,0,Welds2{31}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave32:=[Welds2{32}.WeaveShape,Welds2{32}.WeaveType,Welds2{32}.WeaveLength,Welds2{32}.WeaveWidth,0,Welds2{32}.WeaveDwellLeft,0,Welds2{32}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave33:=[Welds2{33}.WeaveShape,Welds2{33}.WeaveType,Welds2{33}.WeaveLength,Welds2{33}.WeaveWidth,0,Welds2{33}.WeaveDwellLeft,0,Welds2{33}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave34:=[Welds2{34}.WeaveShape,Welds2{34}.WeaveType,Welds2{34}.WeaveLength,Welds2{34}.WeaveWidth,0,Welds2{34}.WeaveDwellLeft,0,Welds2{34}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave35:=[Welds2{35}.WeaveShape,Welds2{35}.WeaveType,Welds2{35}.WeaveLength,Welds2{35}.WeaveWidth,0,Welds2{35}.WeaveDwellLeft,0,Welds2{35}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave36:=[Welds2{36}.WeaveShape,Welds2{36}.WeaveType,Welds2{36}.WeaveLength,Welds2{36}.WeaveWidth,0,Welds2{36}.WeaveDwellLeft,0,Welds2{36}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave37:=[Welds2{37}.WeaveShape,Welds2{37}.WeaveType,Welds2{37}.WeaveLength,Welds2{37}.WeaveWidth,0,Welds2{37}.WeaveDwellLeft,0,Welds2{37}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave38:=[Welds2{38}.WeaveShape,Welds2{38}.WeaveType,Welds2{38}.WeaveLength,Welds2{38}.WeaveWidth,0,Welds2{38}.WeaveDwellLeft,0,Welds2{38}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave39:=[Welds2{39}.WeaveShape,Welds2{39}.WeaveType,Welds2{39}.WeaveLength,Welds2{39}.WeaveWidth,0,Welds2{39}.WeaveDwellLeft,0,Welds2{39}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave40:=[Welds2{nMotionStepCount{2}}.WeaveShape,Welds2{nMotionStepCount{2}}.WeaveType,Welds2{nMotionStepCount{2}}.WeaveLength,Welds2{nMotionStepCount{2}}.WeaveWidth,0,Welds2{nMotionStepCount{2}}.WeaveDwellLeft,0,Welds2{nMotionStepCount{2}}.WeaveDwellRight,0,0,0,0,0,0,0];

        track1:=[0,FALSE,50,[Welds2{1}.TrackType,Welds2{1}.TrackGainY,Welds2{1}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track2:=[0,FALSE,50,[Welds2{2}.TrackType,Welds2{2}.TrackGainY,Welds2{2}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track3:=[0,FALSE,50,[Welds2{3}.TrackType,Welds2{3}.TrackGainY,Welds2{3}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track4:=[0,FALSE,50,[Welds2{4}.TrackType,Welds2{4}.TrackGainY,Welds2{4}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track5:=[0,FALSE,50,[Welds2{5}.TrackType,Welds2{5}.TrackGainY,Welds2{5}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track6:=[0,FALSE,50,[Welds2{6}.TrackType,Welds2{6}.TrackGainY,Welds2{6}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track7:=[0,FALSE,50,[Welds2{7}.TrackType,Welds2{7}.TrackGainY,Welds2{7}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track8:=[0,FALSE,50,[Welds2{8}.TrackType,Welds2{8}.TrackGainY,Welds2{8}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track9:=[0,FALSE,50,[Welds2{9}.TrackType,Welds2{9}.TrackGainY,Welds2{9}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track10:=[0,FALSE,50,[Welds2{10}.TrackType,Welds2{10}.TrackGainY,Welds2{10}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track11:=[0,FALSE,50,[Welds2{11}.TrackType,Welds2{11}.TrackGainY,Welds2{11}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track12:=[0,FALSE,50,[Welds2{12}.TrackType,Welds2{12}.TrackGainY,Welds2{12}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track13:=[0,FALSE,50,[Welds2{13}.TrackType,Welds2{13}.TrackGainY,Welds2{13}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track14:=[0,FALSE,50,[Welds2{14}.TrackType,Welds2{14}.TrackGainY,Welds2{14}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track15:=[0,FALSE,50,[Welds2{15}.TrackType,Welds2{15}.TrackGainY,Welds2{15}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track16:=[0,FALSE,50,[Welds2{16}.TrackType,Welds2{16}.TrackGainY,Welds2{16}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track17:=[0,FALSE,50,[Welds2{17}.TrackType,Welds2{17}.TrackGainY,Welds2{17}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track18:=[0,FALSE,50,[Welds2{18}.TrackType,Welds2{18}.TrackGainY,Welds2{18}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track19:=[0,FALSE,50,[Welds2{19}.TrackType,Welds2{19}.TrackGainY,Welds2{19}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track20:=[0,FALSE,50,[Welds2{20}.TrackType,Welds2{20}.TrackGainY,Welds2{20}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track21:=[0,FALSE,50,[Welds2{21}.TrackType,Welds2{21}.TrackGainY,Welds2{21}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track22:=[0,FALSE,50,[Welds2{22}.TrackType,Welds2{22}.TrackGainY,Welds2{22}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track23:=[0,FALSE,50,[Welds2{23}.TrackType,Welds2{23}.TrackGainY,Welds2{23}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track24:=[0,FALSE,50,[Welds2{24}.TrackType,Welds2{24}.TrackGainY,Welds2{24}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track25:=[0,FALSE,50,[Welds2{25}.TrackType,Welds2{25}.TrackGainY,Welds2{25}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track26:=[0,FALSE,50,[Welds2{26}.TrackType,Welds2{26}.TrackGainY,Welds2{26}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track27:=[0,FALSE,50,[Welds2{27}.TrackType,Welds2{27}.TrackGainY,Welds2{27}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track28:=[0,FALSE,50,[Welds2{28}.TrackType,Welds2{28}.TrackGainY,Welds2{28}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track29:=[0,FALSE,50,[Welds2{29}.TrackType,Welds2{29}.TrackGainY,Welds2{29}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track30:=[0,FALSE,50,[Welds2{30}.TrackType,Welds2{30}.TrackGainY,Welds2{30}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track31:=[0,FALSE,50,[Welds2{31}.TrackType,Welds2{31}.TrackGainY,Welds2{31}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track32:=[0,FALSE,50,[Welds2{32}.TrackType,Welds2{32}.TrackGainY,Welds2{32}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track33:=[0,FALSE,50,[Welds2{33}.TrackType,Welds2{33}.TrackGainY,Welds2{33}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track34:=[0,FALSE,50,[Welds2{34}.TrackType,Welds2{34}.TrackGainY,Welds2{34}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track35:=[0,FALSE,50,[Welds2{35}.TrackType,Welds2{35}.TrackGainY,Welds2{35}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track36:=[0,FALSE,50,[Welds2{36}.TrackType,Welds2{36}.TrackGainY,Welds2{36}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track37:=[0,FALSE,50,[Welds2{37}.TrackType,Welds2{37}.TrackGainY,Welds2{37}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track38:=[0,FALSE,50,[Welds2{38}.TrackType,Welds2{38}.TrackGainY,Welds2{38}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track39:=[0,FALSE,50,[Welds2{39}.TrackType,Welds2{39}.TrackGainY,Welds2{39}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
        track40:=[0,FALSE,50,[Welds2{nMotionStepCount{2}}.TrackType,Welds2{nMotionStepCount{2}}.TrackGainY,Welds2{nMotionStepCount{2}}.TrackGainZ,0,0,0,0,0,0],[0,0,0,0,0,0,0]];



        FOR i FROM 1 TO nMotionStepCount{2} DO
            !===========================================================!
            !!! [mm/sec] = [cm/sec]*10 = [cm/min]*10/60 = [cm/min]/6  !!!
            !===========================================================!
            nTempMmps:=Welds2{i}.cpm/6;
            vWeld{i}:=[nTempMmps,200,200,200];
            IF nTempMmps<>0 vHoldspeed:=[nTempMmps,60,500,500];
        ENDFOR
        seam_TRob2.ign_move_delay:=2;
        Welds2{40}.position:=Welds2{nMotionStepCount{2}}.position;
        WaitRob\ZeroSpeed;
        WaitSyncTask Wait{20},taskGroup123;
        MoveL RelTool(Welds2{1}.position,0,0,-100),vTargetSpeed,zTargetZone,tWeld2\WObj:=wobjWeldLine2;
        IF ((nMacro010{1}=3 AND nMacro010{2}=3) OR (nMacro010{1}=4 AND nMacro010{2}=4)) THEN
        ELSE
            WaitUntil stReact{1}="T_ROB1_ArcOn";
            WaitUntil 2<=nWeldSequence;
        ENDIF
        WaitRob\ZeroSpeed;
        ConfL\Off;


        !        WaitUntil intReHoldGantry_2=0;
        IDelete intOutGantryHold;
        CONNECT intOutGantryHold WITH trapOutGantryHold;
        ISignalDO intReHoldGantry_2,1,intOutGantryHold;

        nRunningStep{2}:=1;
        ArcLStart Welds2{1}.position,vTargetSpeed,seam_TRob2,wd1\weave:=weave1,fine,tWeld2\WObj:=wobjWeldLine2;
        IF ((nMacro010{1}=3 AND nMacro010{2}=3) OR (nMacro010{1}=4 AND nMacro010{2}=4)) stReact{2}:="T_ROB2_ArcOn";
        !\Track:=track1;

        IF nRunningStep{2}>(nMotionStartStepLast{2}-1) THEN
            pcalcWeldpos:=Welds2{1}.position;
            WHILE so_MoveG_PosHold=0 AND (VectMagn(pcalcWeldpos.trans-Welds2{nRunningStep{2}+1}.position.trans)>1) DO
                pcalcWeldpos:=fCalcWeldingpos(pcalcWeldpos,Welds2{nRunningStep{2}}.position,Welds2{nRunningStep{2}+1}.position);
                ArcL pcalcWeldpos,vWeld{nRunningStep{2}+1},seam_TRob2,wd2,\Weave:=weave2,z1,tWeld2\WObj:=wobjWeldLine2;
            ENDWHILE
        ENDIF
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{2}=FALSE bGantryInTrap{2}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds2{nRunningStep{2}+1}.position,0,0,0),vWeld{2},seam_TRob2,Holdwd2,\Weave:=weave2,z1,tWeld2\WObj:=wobjWeldLine2;
        ENDWHILE

        IF 2>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=2;
        ArcL Welds2{2}.position,vWeld{2},seam_TRob2,wd2,\Weave:=weave2,z1,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track2;

        IF nRunningStep{2}>(nMotionStartStepLast{2}-1) THEN
            pcalcWeldpos:=Welds2{2}.position;
            WHILE so_MoveG_PosHold=0 AND (VectMagn(pcalcWeldpos.trans-Welds2{nRunningStep{2}+1}.position.trans)>1) DO
                pcalcWeldpos:=fCalcWeldingpos(pcalcWeldpos,Welds2{nRunningStep{2}}.position,Welds2{nRunningStep{2}+1}.position);
                ArcL pcalcWeldpos,vWeld{nRunningStep{2}+1},seam_TRob2,wd3,\Weave:=weave3,z1,tWeld2\WObj:=wobjWeldLine2;
            ENDWHILE
        ENDIF
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{2}=FALSE bGantryInTrap{2}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds2{nRunningStep{2}+1}.position,0,0,0),vWeld{3},seam_TRob2,Holdwd3,\Weave:=weave3,z1,tWeld2\WObj:=wobjWeldLine2;
        ENDWHILE

        IF 3>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=3;
        ArcL Welds2{3}.position,vWeld{3},seam_TRob2,wd3,\Weave:=weave3,z1,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track3;
        IF nRunningStep{2}>nMotionStartStepLast{2}-1 THEN
            pcalcWeldpos:=Welds2{3}.position;
            WHILE so_MoveG_PosHold=0 AND (VectMagn(pcalcWeldpos.trans-Welds2{nRunningStep{2}+1}.position.trans)>1) DO
                pcalcWeldpos:=fCalcWeldingpos(pcalcWeldpos,Welds2{nRunningStep{2}}.position,Welds2{nRunningStep{2}+1}.position);
                ArcL pcalcWeldpos,vWeld{nRunningStep{2}+1},seam_TRob2,wd4,\Weave:=weave4,z1,tWeld2\WObj:=wobjWeldLine2;
            ENDWHILE
        ENDIF
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{2}=FALSE bGantryInTrap{2}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds2{nRunningStep{2}+1}.position,0,0,0),vWeld{4},seam_TRob2,Holdwd4,\Weave:=weave4,z1,tWeld2\WObj:=wobjWeldLine2;
        ENDWHILE

        IF 4>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=4;
        ArcL Welds2{4}.position,vWeld{4},seam_TRob2,wd4,\Weave:=weave4,z1,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track4;
        IF nRunningStep{2}>nMotionStartStepLast{2}-1 THEN
            pcalcWeldpos:=Welds2{4}.position;
            WHILE so_MoveG_PosHold=0 AND (VectMagn(pcalcWeldpos.trans-Welds2{nRunningStep{2}+1}.position.trans)>1) DO
                pcalcWeldpos:=fCalcWeldingpos(pcalcWeldpos,Welds2{nRunningStep{2}}.position,Welds2{nRunningStep{2}+1}.position);
                ArcL pcalcWeldpos,vWeld{nRunningStep{2}+1},seam_TRob2,wd5,\Weave:=weave5,z1,tWeld2\WObj:=wobjWeldLine2;
            ENDWHILE
        ENDIF
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{2}=FALSE bGantryInTrap{2}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds2{nRunningStep{2}+1}.position,0,0,0),vWeld{5},seam_TRob2,Holdwd5,\Weave:=weave5,z1,tWeld2\WObj:=wobjWeldLine2;
        ENDWHILE

        IF 5>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=5;
        ArcL Welds2{5}.position,vWeld{5},seam_TRob2,wd5,\Weave:=weave5,z1,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track5;
        IF nRunningStep{2}>nMotionStartStepLast{2}-1 THEN
            pcalcWeldpos:=Welds2{5}.position;
            WHILE so_MoveG_PosHold=0 AND (VectMagn(pcalcWeldpos.trans-Welds2{nRunningStep{2}+1}.position.trans)>1) DO
                pcalcWeldpos:=fCalcWeldingpos(pcalcWeldpos,Welds2{nRunningStep{2}}.position,Welds2{nRunningStep{2}+1}.position);
                ArcL pcalcWeldpos,vWeld{nRunningStep{2}+1},seam_TRob2,wd6,\Weave:=weave6,z1,tWeld2\WObj:=wobjWeldLine2;
            ENDWHILE
        ENDIF
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{2}=FALSE bGantryInTrap{2}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds2{nRunningStep{2}+1}.position,0,0,0),vWeld{6},seam_TRob2,Holdwd6,\Weave:=weave6,z1,tWeld2\WObj:=wobjWeldLine2;
        ENDWHILE

        IF 6>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=6;
        ArcL Welds2{6}.position,vWeld{6},seam_TRob2,wd6,\Weave:=weave6,z1,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track6;
        IF nRunningStep{2}>nMotionStartStepLast{2}-1 THEN
            pcalcWeldpos:=Welds2{6}.position;
            WHILE so_MoveG_PosHold=0 AND (VectMagn(pcalcWeldpos.trans-Welds2{nRunningStep{2}+1}.position.trans)>1) DO
                pcalcWeldpos:=fCalcWeldingpos(pcalcWeldpos,Welds2{nRunningStep{2}}.position,Welds2{nRunningStep{2}+1}.position);
                ArcL pcalcWeldpos,vWeld{nRunningStep{2}+1},seam_TRob2,wd7,\Weave:=weave7,z1,tWeld2\WObj:=wobjWeldLine2;
            ENDWHILE
        ENDIF
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{2}=FALSE bGantryInTrap{2}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds2{nRunningStep{2}+1}.position,0,0,0),vWeld{7},seam_TRob2,Holdwd7,\Weave:=weave7,z1,tWeld2\WObj:=wobjWeldLine2;
        ENDWHILE

        IF 7>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=7;
        ArcL Welds2{7}.position,vWeld{7},seam_TRob2,wd7,\Weave:=weave7,z1,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track7;
        IF nRunningStep{2}>nMotionStartStepLast{2}-1 THEN
            pcalcWeldpos:=Welds2{7}.position;
            WHILE so_MoveG_PosHold=0 AND (VectMagn(pcalcWeldpos.trans-Welds2{nRunningStep{2}+1}.position.trans)>1) DO
                pcalcWeldpos:=fCalcWeldingpos(pcalcWeldpos,Welds2{nRunningStep{2}}.position,Welds2{nRunningStep{2}+1}.position);
                ArcL pcalcWeldpos,vWeld{nRunningStep{2}+1},seam_TRob2,wd8,\Weave:=weave8,z1,tWeld2\WObj:=wobjWeldLine2;
            ENDWHILE
        ENDIF
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{2}=FALSE bGantryInTrap{2}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds2{nRunningStep{2}+1}.position,0,0,0),vWeld{8},seam_TRob2,Holdwd8,\Weave:=weave8,z1,tWeld2\WObj:=wobjWeldLine2;
        ENDWHILE

        IF 8>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=8;
        ArcL Welds2{8}.position,vWeld{8},seam_TRob2,wd8,\Weave:=weave8,z1,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track8;
        IF nRunningStep{2}>nMotionStartStepLast{2}-1 THEN
            pcalcWeldpos:=Welds2{8}.position;
            WHILE so_MoveG_PosHold=0 AND (VectMagn(pcalcWeldpos.trans-Welds2{nRunningStep{2}+1}.position.trans)>1) DO
                pcalcWeldpos:=fCalcWeldingpos(pcalcWeldpos,Welds2{nRunningStep{2}}.position,Welds2{nRunningStep{2}+1}.position);
                ArcL pcalcWeldpos,vWeld{nRunningStep{2}+1},seam_TRob2,wd9,\Weave:=weave9,z1,tWeld2\WObj:=wobjWeldLine2;
                !\Track:=track9;
            ENDWHILE
        ENDIF
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{2}=FALSE bGantryInTrap{2}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds2{nRunningStep{2}+1}.position,0,0,0),vWeld{9},seam_TRob2,Holdwd9,\Weave:=weave9,z1,tWeld2\WObj:=wobjWeldLine2;
            !\Track:=track9;
        ENDWHILE

        IF 9>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=9;
        ArcL Welds2{9}.position,vWeld{9},seam_TRob2,wd9,\Weave:=weave9,z1,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track9;
        IF nRunningStep{2}>nMotionStartStepLast{2}-1 THEN
            pcalcWeldpos:=Welds2{9}.position;
            WHILE so_MoveG_PosHold=0 AND (VectMagn(pcalcWeldpos.trans-Welds2{nRunningStep{2}+1}.position.trans)>1) DO
                pcalcWeldpos:=fCalcWeldingpos(pcalcWeldpos,Welds2{nRunningStep{2}}.position,Welds2{nRunningStep{2}+1}.position);
                ArcL pcalcWeldpos,vWeld{nRunningStep{2}+1},seam_TRob2,wd10,\Weave:=weave10,z1,tWeld2\WObj:=wobjWeldLine2;
                !\Track:=track10;
            ENDWHILE
        ENDIF
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{2}=FALSE bGantryInTrap{2}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds2{nRunningStep{2}+1}.position,0,0,0),vWeld{10},seam_TRob2,Holdwd10,\Weave:=weave10,z1,tWeld2\WObj:=wobjWeldLine2;
            !\Track:=track10;
        ENDWHILE

        IF 10>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=10;
        ArcL Welds2{10}.position,vWeld{10},seam_TRob2,wd10,\Weave:=weave10,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track10;

        IF 11>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=11;
        ArcL Welds2{11}.position,vWeld{11},seam_TRob2,wd11,\Weave:=weave11,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track11;

        IF 12>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=12;
        ArcL Welds2{12}.position,vWeld{12},seam_TRob2,wd12,\Weave:=weave12,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track12;


        IF 13>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=13;
        ArcL Welds2{13}.position,vWeld{13},seam_TRob2,wd13,\Weave:=weave13,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track13;

        IF 14>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=14;
        ArcL Welds2{14}.position,vWeld{14},seam_TRob2,wd14,\Weave:=weave14,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track14;

        IF 15>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=15;
        ArcL Welds2{15}.position,vWeld{15},seam_TRob2,wd15,\Weave:=weave15,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track15;

        IF 16>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=16;
        ArcL Welds2{16}.position,vWeld{16},seam_TRob2,wd16,\Weave:=weave16,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track16;

        IF 17>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=17;
        ArcL Welds2{17}.position,vWeld{17},seam_TRob2,wd17,\Weave:=weave17,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track17;

        IF 18>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=18;
        ArcL Welds2{18}.position,vWeld{18},seam_TRob2,wd18,\Weave:=weave18,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track18;

        IF 19>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=19;
        ArcL Welds2{19}.position,vWeld{19},seam_TRob2,wd19,\Weave:=weave19,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track19;

        IF 20>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=20;
        ArcL Welds2{20}.position,vWeld{20},seam_TRob2,wd20,\Weave:=weave20,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track20;

        IF 21>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=21;
        ArcL Welds2{21}.position,vWeld{21},seam_TRob2,wd21,\Weave:=weave21,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track21;

        IF 22>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=22;
        ArcL Welds2{22}.position,vWeld{22},seam_TRob2,wd22,\Weave:=weave22,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track22;

        IF 23>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=23;
        ArcL Welds2{23}.position,vWeld{23},seam_TRob2,wd23,\Weave:=weave23,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track23;

        IF 24>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=24;
        ArcL Welds2{24}.position,vWeld{24},seam_TRob2,wd24,\Weave:=weave24,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track24;

        IF 25>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=25;
        ArcL Welds2{25}.position,vWeld{25},seam_TRob2,wd25,\Weave:=weave25,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track25;

        IF 26>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=26;
        ArcL Welds2{26}.position,vWeld{26},seam_TRob2,wd26,\Weave:=weave26,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track26;

        IF 27>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=27;
        ArcL Welds2{27}.position,vWeld{27},seam_TRob2,wd27,\Weave:=weave27,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track27;

        IF 28>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=28;
        ArcL Welds2{28}.position,vWeld{28},seam_TRob2,wd28,\Weave:=weave28,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track28;

        IF 29>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=29;
        ArcL Welds2{29}.position,vWeld{29},seam_TRob2,wd29,\Weave:=weave29,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track29;

        IF 30>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=30;
        ArcL Welds2{30}.position,vWeld{30},seam_TRob2,wd30,\Weave:=weave30,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track30;

        IF 31>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=31;
        ArcL Welds2{31}.position,vWeld{31},seam_TRob2,wd31,\Weave:=weave31,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track31;

        IF 32>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=32;
        ArcL Welds2{32}.position,vWeld{32},seam_TRob2,wd32,\Weave:=weave32,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track32;

        IF 33>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=33;
        ArcL Welds2{33}.position,vWeld{33},seam_TRob2,wd33,\Weave:=weave33,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track33;

        IF 34>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=34;
        ArcL Welds2{34}.position,vWeld{34},seam_TRob2,wd34,\Weave:=weave34,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track34;

        IF 35>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=35;
        ArcL Welds2{35}.position,vWeld{35},seam_TRob2,wd35,\Weave:=weave35,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track35;

        IF 36>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=36;
        ArcL Welds2{36}.position,vWeld{36},seam_TRob2,wd36,\Weave:=weave36,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track36;

        IF 37>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=37;
        ArcL Welds2{37}.position,vWeld{37},seam_TRob2,wd37,\Weave:=weave37,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track37;

        IF 38>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=38;
        ArcL Welds2{38}.position,vWeld{38},seam_TRob2,wd38,\Weave:=weave38,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track38;

        IF 39>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=39;
        ArcL Welds2{39}.position,vWeld{39},seam_TRob2,wd39,\Weave:=weave39,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track39;

        MoveArcEnd:
        nRunningStep{2}:=40;
        ArcLEnd Welds2{40}.position,vWeld{40},seam_TRob2,wd40,\Weave:=weave40,fine,tWeld2\WObj:=wobjWeldLine2;
        !\Track:=track40;
        MoveL RelTool(Welds2{nMotionStepCount{2}}.position,0,0,-50),vTargetSpeed,fine,tWeld2\WObj:=wobjWeldLine2;
        ConfL\On;

        IDelete intOutGantryHold;

        stReact{2}:="WeldOk";
        WaitUntil stCommand="";
        stReact{2}:="Ready";

    ENDPROC

    PROC rWeld34()

        VAR num nTempMmps;
        VAR num nTempVolt;
        VAR num nTempWFS;
        VAR num wdArray{40};
        VAR speeddata vHoldspeed;
        VAR num nHoldWeldVel;
        VAR num nHoldDist:=0;

        nHoldWeldVel:=0.01;
        IDelete inumMoveG_PosHold;
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
        wd11:=[Welds2{11}.cpm/6,0,[5,0,Welds2{11}.voltage,Welds2{11}.wfs,0,Welds2{11}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd12:=[Welds2{12}.cpm/6,0,[5,0,Welds2{12}.voltage,Welds2{12}.wfs,0,Welds2{12}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd13:=[Welds2{13}.cpm/6,0,[5,0,Welds2{13}.voltage,Welds2{13}.wfs,0,Welds2{13}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd14:=[Welds2{14}.cpm/6,0,[5,0,Welds2{14}.voltage,Welds2{14}.wfs,0,Welds2{14}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd15:=[Welds2{15}.cpm/6,0,[5,0,Welds2{15}.voltage,Welds2{15}.wfs,0,Welds2{15}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd16:=[Welds2{16}.cpm/6,0,[5,0,Welds2{16}.voltage,Welds2{16}.wfs,0,Welds2{16}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd17:=[Welds2{17}.cpm/6,0,[5,0,Welds2{17}.voltage,Welds2{17}.wfs,0,Welds2{17}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd18:=[Welds2{18}.cpm/6,0,[5,0,Welds2{18}.voltage,Welds2{18}.wfs,0,Welds2{18}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd19:=[Welds2{19}.cpm/6,0,[5,0,Welds2{19}.voltage,Welds2{19}.wfs,0,Welds2{19}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd20:=[Welds2{20}.cpm/6,0,[5,0,Welds2{20}.voltage,Welds2{20}.wfs,0,Welds2{20}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd21:=[Welds2{21}.cpm/6,0,[5,0,Welds2{21}.voltage,Welds2{21}.wfs,0,Welds2{21}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd22:=[Welds2{22}.cpm/6,0,[5,0,Welds2{22}.voltage,Welds2{22}.wfs,0,Welds2{22}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd23:=[Welds2{23}.cpm/6,0,[5,0,Welds2{23}.voltage,Welds2{23}.wfs,0,Welds2{23}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd24:=[Welds2{24}.cpm/6,0,[5,0,Welds2{24}.voltage,Welds2{24}.wfs,0,Welds2{24}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd25:=[Welds2{25}.cpm/6,0,[5,0,Welds2{25}.voltage,Welds2{25}.wfs,0,Welds2{25}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd26:=[Welds2{26}.cpm/6,0,[5,0,Welds2{26}.voltage,Welds2{26}.wfs,0,Welds2{26}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd27:=[Welds2{27}.cpm/6,0,[5,0,Welds2{27}.voltage,Welds2{27}.wfs,0,Welds2{27}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd28:=[Welds2{28}.cpm/6,0,[5,0,Welds2{28}.voltage,Welds2{28}.wfs,0,Welds2{28}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd29:=[Welds2{29}.cpm/6,0,[5,0,Welds2{29}.voltage,Welds2{29}.wfs,0,Welds2{29}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd30:=[Welds2{30}.cpm/6,0,[5,0,Welds2{30}.voltage,Welds2{30}.wfs,0,Welds2{30}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd31:=[Welds2{31}.cpm/6,0,[5,0,Welds2{31}.voltage,Welds2{31}.wfs,0,Welds2{31}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd32:=[Welds2{32}.cpm/6,0,[5,0,Welds2{32}.voltage,Welds2{32}.wfs,0,Welds2{32}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd33:=[Welds2{33}.cpm/6,0,[5,0,Welds2{33}.voltage,Welds2{33}.wfs,0,Welds2{33}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd34:=[Welds2{34}.cpm/6,0,[5,0,Welds2{34}.voltage,Welds2{34}.wfs,0,Welds2{34}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd35:=[Welds2{35}.cpm/6,0,[5,0,Welds2{35}.voltage,Welds2{35}.wfs,0,Welds2{35}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd36:=[Welds2{36}.cpm/6,0,[5,0,Welds2{36}.voltage,Welds2{36}.wfs,0,Welds2{36}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd37:=[Welds2{37}.cpm/6,0,[5,0,Welds2{37}.voltage,Welds2{37}.wfs,0,Welds2{37}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd38:=[Welds2{38}.cpm/6,0,[5,0,Welds2{38}.voltage,Welds2{38}.wfs,0,Welds2{38}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd39:=[Welds2{39}.cpm/6,0,[5,0,Welds2{39}.voltage,Welds2{39}.wfs,0,Welds2{39}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        wd40:=[Welds2{nMotionStepCount{2}}.cpm/6,0,[5,0,Welds2{nMotionStepCount{2}}.voltage,Welds2{nMotionStepCount{2}}.wfs,0,Welds2{nMotionStepCount{2}}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];

        Holdwd1:=[nHoldWeldVel,0,[5,0,Welds2{1}.voltage,Welds2{1}.wfs,0,Welds2{1}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd2:=[nHoldWeldVel,0,[5,0,Welds2{2}.voltage,Welds2{2}.wfs,0,Welds2{2}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd3:=[nHoldWeldVel,0,[5,0,Welds2{3}.voltage,Welds2{3}.wfs,0,Welds2{3}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd4:=[nHoldWeldVel,0,[5,0,Welds2{4}.voltage,Welds2{4}.wfs,0,Welds2{4}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd5:=[nHoldWeldVel,0,[5,0,Welds2{5}.voltage,Welds2{5}.wfs,0,Welds2{5}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd6:=[nHoldWeldVel,0,[5,0,Welds2{6}.voltage,Welds2{6}.wfs,0,Welds2{6}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd7:=[nHoldWeldVel,0,[5,0,Welds2{7}.voltage,Welds2{7}.wfs,0,Welds2{7}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd8:=[nHoldWeldVel,0,[5,0,Welds2{8}.voltage,Welds2{8}.wfs,0,Welds2{8}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd9:=[nHoldWeldVel,0,[5,0,Welds2{9}.voltage,Welds2{9}.wfs,0,Welds2{9}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd10:=[nHoldWeldVel,0,[5,0,Welds2{10}.voltage,Welds2{10}.wfs,0,Welds2{10}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];

        ! Define Wave Data
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
        weave11:=[Welds2{11}.WeaveShape,Welds2{11}.WeaveType,Welds2{11}.WeaveLength,Welds2{11}.WeaveWidth,0,Welds2{11}.WeaveDwellLeft,0,Welds2{11}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave12:=[Welds2{12}.WeaveShape,Welds2{12}.WeaveType,Welds2{12}.WeaveLength,Welds2{12}.WeaveWidth,0,Welds2{12}.WeaveDwellLeft,0,Welds2{12}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave13:=[Welds2{13}.WeaveShape,Welds2{13}.WeaveType,Welds2{13}.WeaveLength,Welds2{13}.WeaveWidth,0,Welds2{13}.WeaveDwellLeft,0,Welds2{13}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave14:=[Welds2{14}.WeaveShape,Welds2{14}.WeaveType,Welds2{14}.WeaveLength,Welds2{14}.WeaveWidth,0,Welds2{14}.WeaveDwellLeft,0,Welds2{14}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave15:=[Welds2{15}.WeaveShape,Welds2{15}.WeaveType,Welds2{15}.WeaveLength,Welds2{15}.WeaveWidth,0,Welds2{15}.WeaveDwellLeft,0,Welds2{15}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave16:=[Welds2{16}.WeaveShape,Welds2{16}.WeaveType,Welds2{16}.WeaveLength,Welds2{16}.WeaveWidth,0,Welds2{16}.WeaveDwellLeft,0,Welds2{16}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave17:=[Welds2{17}.WeaveShape,Welds2{17}.WeaveType,Welds2{17}.WeaveLength,Welds2{17}.WeaveWidth,0,Welds2{17}.WeaveDwellLeft,0,Welds2{17}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave18:=[Welds2{18}.WeaveShape,Welds2{18}.WeaveType,Welds2{18}.WeaveLength,Welds2{18}.WeaveWidth,0,Welds2{18}.WeaveDwellLeft,0,Welds2{18}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave19:=[Welds2{19}.WeaveShape,Welds2{19}.WeaveType,Welds2{19}.WeaveLength,Welds2{19}.WeaveWidth,0,Welds2{19}.WeaveDwellLeft,0,Welds2{19}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave20:=[Welds2{20}.WeaveShape,Welds2{20}.WeaveType,Welds2{20}.WeaveLength,Welds2{20}.WeaveWidth,0,Welds2{20}.WeaveDwellLeft,0,Welds2{20}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave21:=[Welds2{21}.WeaveShape,Welds2{21}.WeaveType,Welds2{21}.WeaveLength,Welds2{21}.WeaveWidth,0,Welds2{21}.WeaveDwellLeft,0,Welds2{21}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave22:=[Welds2{22}.WeaveShape,Welds2{22}.WeaveType,Welds2{22}.WeaveLength,Welds2{22}.WeaveWidth,0,Welds2{22}.WeaveDwellLeft,0,Welds2{22}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave23:=[Welds2{23}.WeaveShape,Welds2{23}.WeaveType,Welds2{23}.WeaveLength,Welds2{23}.WeaveWidth,0,Welds2{23}.WeaveDwellLeft,0,Welds2{23}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave24:=[Welds2{24}.WeaveShape,Welds2{24}.WeaveType,Welds2{24}.WeaveLength,Welds2{24}.WeaveWidth,0,Welds2{24}.WeaveDwellLeft,0,Welds2{24}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave25:=[Welds2{25}.WeaveShape,Welds2{25}.WeaveType,Welds2{25}.WeaveLength,Welds2{25}.WeaveWidth,0,Welds2{25}.WeaveDwellLeft,0,Welds2{25}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave26:=[Welds2{26}.WeaveShape,Welds2{26}.WeaveType,Welds2{26}.WeaveLength,Welds2{26}.WeaveWidth,0,Welds2{26}.WeaveDwellLeft,0,Welds2{26}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave27:=[Welds2{27}.WeaveShape,Welds2{27}.WeaveType,Welds2{27}.WeaveLength,Welds2{27}.WeaveWidth,0,Welds2{27}.WeaveDwellLeft,0,Welds2{27}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave28:=[Welds2{28}.WeaveShape,Welds2{28}.WeaveType,Welds2{28}.WeaveLength,Welds2{28}.WeaveWidth,0,Welds2{28}.WeaveDwellLeft,0,Welds2{28}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave29:=[Welds2{29}.WeaveShape,Welds2{29}.WeaveType,Welds2{29}.WeaveLength,Welds2{29}.WeaveWidth,0,Welds2{29}.WeaveDwellLeft,0,Welds2{29}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave30:=[Welds2{30}.WeaveShape,Welds2{30}.WeaveType,Welds2{30}.WeaveLength,Welds2{30}.WeaveWidth,0,Welds2{30}.WeaveDwellLeft,0,Welds2{30}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave31:=[Welds2{31}.WeaveShape,Welds2{31}.WeaveType,Welds2{31}.WeaveLength,Welds2{31}.WeaveWidth,0,Welds2{31}.WeaveDwellLeft,0,Welds2{31}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave32:=[Welds2{32}.WeaveShape,Welds2{32}.WeaveType,Welds2{32}.WeaveLength,Welds2{32}.WeaveWidth,0,Welds2{32}.WeaveDwellLeft,0,Welds2{32}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave33:=[Welds2{33}.WeaveShape,Welds2{33}.WeaveType,Welds2{33}.WeaveLength,Welds2{33}.WeaveWidth,0,Welds2{33}.WeaveDwellLeft,0,Welds2{33}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave34:=[Welds2{34}.WeaveShape,Welds2{34}.WeaveType,Welds2{34}.WeaveLength,Welds2{34}.WeaveWidth,0,Welds2{34}.WeaveDwellLeft,0,Welds2{34}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave35:=[Welds2{35}.WeaveShape,Welds2{35}.WeaveType,Welds2{35}.WeaveLength,Welds2{35}.WeaveWidth,0,Welds2{35}.WeaveDwellLeft,0,Welds2{35}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave36:=[Welds2{36}.WeaveShape,Welds2{36}.WeaveType,Welds2{36}.WeaveLength,Welds2{36}.WeaveWidth,0,Welds2{36}.WeaveDwellLeft,0,Welds2{36}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave37:=[Welds2{37}.WeaveShape,Welds2{37}.WeaveType,Welds2{37}.WeaveLength,Welds2{37}.WeaveWidth,0,Welds2{37}.WeaveDwellLeft,0,Welds2{37}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave38:=[Welds2{38}.WeaveShape,Welds2{38}.WeaveType,Welds2{38}.WeaveLength,Welds2{38}.WeaveWidth,0,Welds2{38}.WeaveDwellLeft,0,Welds2{38}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave39:=[Welds2{39}.WeaveShape,Welds2{39}.WeaveType,Welds2{39}.WeaveLength,Welds2{39}.WeaveWidth,0,Welds2{39}.WeaveDwellLeft,0,Welds2{39}.WeaveDwellRight,0,0,0,0,0,0,0];
        weave40:=[Welds2{nMotionStepCount{2}}.WeaveShape,Welds2{nMotionStepCount{2}}.WeaveType,Welds2{nMotionStepCount{2}}.WeaveLength,Welds2{nMotionStepCount{2}}.WeaveWidth,0,Welds2{nMotionStepCount{2}}.WeaveDwellLeft,0,Welds2{nMotionStepCount{2}}.WeaveDwellRight,0,0,0,0,0,0,0];

        track1:=[0,FALSE,Welds2{1}.MaxCorr,[Welds2{1}.TrackType,Welds2{1}.TrackGainY,Welds2{1}.TrackGainZ,0,Welds2{1}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track2:=[0,FALSE,Welds2{2}.MaxCorr,[Welds2{2}.TrackType,Welds2{2}.TrackGainY,Welds2{2}.TrackGainZ,0,Welds2{2}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track3:=[0,FALSE,Welds2{3}.MaxCorr,[Welds2{3}.TrackType,Welds2{3}.TrackGainY,Welds2{3}.TrackGainZ,0,Welds2{3}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track4:=[0,FALSE,Welds2{4}.MaxCorr,[Welds2{4}.TrackType,Welds2{4}.TrackGainY,Welds2{4}.TrackGainZ,0,Welds2{4}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track5:=[0,FALSE,Welds2{5}.MaxCorr,[Welds2{5}.TrackType,Welds2{5}.TrackGainY,Welds2{5}.TrackGainZ,0,Welds2{5}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track6:=[0,FALSE,Welds2{6}.MaxCorr,[Welds2{6}.TrackType,Welds2{6}.TrackGainY,Welds2{6}.TrackGainZ,0,Welds2{6}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track7:=[0,FALSE,Welds2{7}.MaxCorr,[Welds2{7}.TrackType,Welds2{7}.TrackGainY,Welds2{7}.TrackGainZ,0,Welds2{7}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track8:=[0,FALSE,Welds2{8}.MaxCorr,[Welds2{8}.TrackType,Welds2{8}.TrackGainY,Welds2{8}.TrackGainZ,0,Welds2{8}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track9:=[0,FALSE,Welds2{9}.MaxCorr,[Welds2{9}.TrackType,Welds2{9}.TrackGainY,Welds2{9}.TrackGainZ,0,Welds2{9}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track10:=[0,FALSE,Welds2{10}.MaxCorr,[Welds2{10}.TrackType,Welds2{10}.TrackGainY,Welds2{10}.TrackGainZ,0,Welds2{10}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track11:=[0,FALSE,Welds2{11}.MaxCorr,[Welds2{11}.TrackType,Welds2{11}.TrackGainY,Welds2{11}.TrackGainZ,0,Welds2{11}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track12:=[0,FALSE,Welds2{12}.MaxCorr,[Welds2{12}.TrackType,Welds2{12}.TrackGainY,Welds2{12}.TrackGainZ,0,Welds2{12}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track13:=[0,FALSE,Welds2{13}.MaxCorr,[Welds2{13}.TrackType,Welds2{13}.TrackGainY,Welds2{13}.TrackGainZ,0,Welds2{13}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track14:=[0,FALSE,Welds2{14}.MaxCorr,[Welds2{14}.TrackType,Welds2{14}.TrackGainY,Welds2{14}.TrackGainZ,0,Welds2{14}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track15:=[0,FALSE,Welds2{15}.MaxCorr,[Welds2{15}.TrackType,Welds2{15}.TrackGainY,Welds2{15}.TrackGainZ,0,Welds2{15}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track16:=[0,FALSE,Welds2{16}.MaxCorr,[Welds2{16}.TrackType,Welds2{16}.TrackGainY,Welds2{16}.TrackGainZ,0,Welds2{16}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track17:=[0,FALSE,Welds2{17}.MaxCorr,[Welds2{17}.TrackType,Welds2{17}.TrackGainY,Welds2{17}.TrackGainZ,0,Welds2{17}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track18:=[0,FALSE,Welds2{18}.MaxCorr,[Welds2{18}.TrackType,Welds2{18}.TrackGainY,Welds2{18}.TrackGainZ,0,Welds2{18}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track19:=[0,FALSE,Welds2{19}.MaxCorr,[Welds2{19}.TrackType,Welds2{19}.TrackGainY,Welds2{19}.TrackGainZ,0,Welds2{19}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track20:=[0,FALSE,Welds2{20}.MaxCorr,[Welds2{20}.TrackType,Welds2{20}.TrackGainY,Welds2{20}.TrackGainZ,0,Welds2{20}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track21:=[0,FALSE,Welds2{21}.MaxCorr,[Welds2{21}.TrackType,Welds2{21}.TrackGainY,Welds2{21}.TrackGainZ,0,Welds2{21}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track22:=[0,FALSE,Welds2{22}.MaxCorr,[Welds2{22}.TrackType,Welds2{22}.TrackGainY,Welds2{22}.TrackGainZ,0,Welds2{22}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track23:=[0,FALSE,Welds2{23}.MaxCorr,[Welds2{23}.TrackType,Welds2{23}.TrackGainY,Welds2{23}.TrackGainZ,0,Welds2{23}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track24:=[0,FALSE,Welds2{24}.MaxCorr,[Welds2{24}.TrackType,Welds2{24}.TrackGainY,Welds2{24}.TrackGainZ,0,Welds2{24}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track25:=[0,FALSE,Welds2{25}.MaxCorr,[Welds2{25}.TrackType,Welds2{25}.TrackGainY,Welds2{25}.TrackGainZ,0,Welds2{25}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track26:=[0,FALSE,Welds2{26}.MaxCorr,[Welds2{26}.TrackType,Welds2{26}.TrackGainY,Welds2{26}.TrackGainZ,0,Welds2{26}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track27:=[0,FALSE,Welds2{27}.MaxCorr,[Welds2{27}.TrackType,Welds2{27}.TrackGainY,Welds2{27}.TrackGainZ,0,Welds2{27}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track28:=[0,FALSE,Welds2{28}.MaxCorr,[Welds2{28}.TrackType,Welds2{28}.TrackGainY,Welds2{28}.TrackGainZ,0,Welds2{28}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track29:=[0,FALSE,Welds2{29}.MaxCorr,[Welds2{29}.TrackType,Welds2{29}.TrackGainY,Welds2{29}.TrackGainZ,0,Welds2{29}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track30:=[0,FALSE,Welds2{30}.MaxCorr,[Welds2{30}.TrackType,Welds2{30}.TrackGainY,Welds2{30}.TrackGainZ,0,Welds2{30}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track31:=[0,FALSE,Welds2{31}.MaxCorr,[Welds2{31}.TrackType,Welds2{31}.TrackGainY,Welds2{31}.TrackGainZ,0,Welds2{31}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track32:=[0,FALSE,Welds2{32}.MaxCorr,[Welds2{32}.TrackType,Welds2{32}.TrackGainY,Welds2{32}.TrackGainZ,0,Welds2{32}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track33:=[0,FALSE,Welds2{33}.MaxCorr,[Welds2{33}.TrackType,Welds2{33}.TrackGainY,Welds2{33}.TrackGainZ,0,Welds2{33}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track34:=[0,FALSE,Welds2{34}.MaxCorr,[Welds2{34}.TrackType,Welds2{34}.TrackGainY,Welds2{34}.TrackGainZ,0,Welds2{34}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track35:=[0,FALSE,Welds2{35}.MaxCorr,[Welds2{35}.TrackType,Welds2{35}.TrackGainY,Welds2{35}.TrackGainZ,0,Welds2{35}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track36:=[0,FALSE,Welds2{36}.MaxCorr,[Welds2{36}.TrackType,Welds2{36}.TrackGainY,Welds2{36}.TrackGainZ,0,Welds2{36}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track37:=[0,FALSE,Welds2{37}.MaxCorr,[Welds2{37}.TrackType,Welds2{37}.TrackGainY,Welds2{37}.TrackGainZ,0,Welds2{37}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track38:=[0,FALSE,Welds2{38}.MaxCorr,[Welds2{38}.TrackType,Welds2{38}.TrackGainY,Welds2{38}.TrackGainZ,0,Welds2{38}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track39:=[0,FALSE,Welds2{39}.MaxCorr,[Welds2{39}.TrackType,Welds2{39}.TrackGainY,Welds2{39}.TrackGainZ,0,Welds2{39}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];
        track40:=[0,FALSE,Welds2{nMotionStepCount{2}}.MaxCorr,[Welds2{nMotionStepCount{2}}.TrackType,Welds2{nMotionStepCount{2}}.TrackGainY,Welds2{nMotionStepCount{2}}.TrackGainZ,0,Welds2{nMotionStepCount{2}}.Bias,0,0,0,0],[0,0,0,0,0,0,0]];



        FOR i FROM 1 TO nMotionStepCount{2} DO
            !===========================================================!
            !!! [mm/sec] = [cm/sec]*10 = [cm/min]*10/60 = [cm/min]/6  !!!
            !===========================================================!
            nTempMmps:=Welds2{i}.cpm/6;
            vWeld{i}:=[nTempMmps,200,200,200];
            IF nTempMmps<>0 vHoldspeed:=[nTempMmps,60,500,500];
        ENDFOR
        seam_TRob2.ign_move_delay:=1;
        Welds2{40}.position:=Welds2{nMotionStepCount{2}}.position;
        WaitRob\ZeroSpeed;
        WaitSyncTask Wait{20},taskGroup123;

        MoveL RelTool(Welds2{1}.position,0,0,-10),vTargetSpeed,zTargetZone,tWeld2\WObj:=wobjWeldLine2;
        IF ((nMacro010{1}=3 AND nMacro010{2}=3) OR (nMacro010{1}=4 AND nMacro010{2}=4)) THEN
        ELSE
            WaitUntil stReact{1}="T_ROB1_ArcOn";
            WaitUntil 2<=nWeldSequence;
        ENDIF
        WaitRob\ZeroSpeed;
        ConfL\Off;

        IDelete intOutGantryHold;
        CONNECT intOutGantryHold WITH trapOutGantryHold;
        ISignalDO intReHoldGantry_2,1,intOutGantryHold;

        nRunningStep{2}:=1;
        WaitRob\ZeroSpeed;
        WaitSyncTask Wait{50},taskGroup12;

        ArcLStart Welds2{1}.position,vTargetSpeed,seam_TRob2,wd1\weave:=weave1,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track1;
        ClkReset clockWeldTime;
        ClkStart clockWeldTime;
        bArc_On{2}:=TRUE;
        stReact{2}:="T_ROB2_ArcOn";

        IF 2>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=2;
        ArcL Welds2{2}.position,vWeld{2},seam_TRob2,wd2,\Weave:=weave2,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track2;
        !\Track:=track2;
        stReact{2}:="T_ROB2_GantryOn";
        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{2}=FALSE bGantryInTrap{2}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds2{nRunningStep{2}+1}.position,-1,0,0),vWeld{3},seam_TRob2,Holdwd3,\Weave:=weave3,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track3;
        ENDWHILE

        IF 3>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=3;
        ArcL Welds2{3}.position,vWeld{3},seam_TRob2,wd3,\Weave:=weave3,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track3;
        !\Track:=track3;

        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{2}=FALSE bGantryInTrap{2}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds2{nRunningStep{2}+1}.position,-1,0,0),vWeld{4},seam_TRob2,Holdwd4,\Weave:=weave4,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track4;
        ENDWHILE

        IF 4>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=4;
        ArcL Welds2{4}.position,vWeld{4},seam_TRob2,wd4,\Weave:=weave4,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track4;
        !\Track:=track4;

        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{2}=FALSE bGantryInTrap{2}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds2{nRunningStep{2}+1}.position,-1,0,0),vWeld{5},seam_TRob2,Holdwd5,\Weave:=weave5,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track5;
        ENDWHILE

        IF 5>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=5;
        ArcL Welds2{5}.position,vWeld{5},seam_TRob2,wd5,\Weave:=weave5,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track5;
        !\Track:=track5;

        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{2}=FALSE bGantryInTrap{2}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds2{nRunningStep{2}+1}.position,-1,0,0),vWeld{6},seam_TRob2,Holdwd6,\Weave:=weave6,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track6;
        ENDWHILE

        IF 6>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=6;
        ArcL Welds2{6}.position,vWeld{6},seam_TRob2,wd6,\Weave:=weave6,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track6;
        !\Track:=track6;

        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{2}=FALSE bGantryInTrap{2}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds2{nRunningStep{2}+1}.position,-1,0,0),vWeld{7},seam_TRob2,Holdwd7,\Weave:=weave7,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track7;
        ENDWHILE

        IF 7>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=7;
        ArcL Welds2{7}.position,vWeld{7},seam_TRob2,wd7,\Weave:=weave7,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track7;
        !\Track:=track7;

        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{2}=FALSE bGantryInTrap{2}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds2{nRunningStep{2}+1}.position,-1,0,0),vWeld{8},seam_TRob2,Holdwd8,\Weave:=weave8,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track8;
        ENDWHILE

        IF 8>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=8;
        ArcL Welds2{8}.position,vWeld{8},seam_TRob2,wd8,\Weave:=weave8,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track8;
        !\Track:=track8;

        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{2}=FALSE bGantryInTrap{2}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds2{nRunningStep{2}+1}.position,-1,0,0),vWeld{9},seam_TRob2,Holdwd9,\Weave:=weave9,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track9;
            !\Track:=track9;
        ENDWHILE

        IF 9>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=9;
        ArcL Welds2{9}.position,vWeld{9},seam_TRob2,wd9,\Weave:=weave9,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track9;
        !\Track:=track9;

        WHILE (so_MoveG_PosHold=1) DO
            IF bGantryInTrap{2}=FALSE bGantryInTrap{2}:=TRUE;
            IF so_MoveG_PosHold=1 ArcL Offs(Welds2{nRunningStep{2}+1}.position,-1,0,0),vWeld{10},seam_TRob2,Holdwd10,\Weave:=weave10,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track10;
            !\Track:=track10;
        ENDWHILE

        IF 10>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=10;
        ArcL Welds2{10}.position,vWeld{10},seam_TRob2,wd10,\Weave:=weave10,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track10;
        !\Track:=track10;

        IF 11>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=11;
        ArcL Welds2{11}.position,vWeld{11},seam_TRob2,wd11,\Weave:=weave11,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track11;
        !\Track:=track11;

        IF 12>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=12;
        ArcL Welds2{12}.position,vWeld{12},seam_TRob2,wd12,\Weave:=weave12,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track12;
        !\Track:=track12;


        IF 13>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=13;
        ArcL Welds2{13}.position,vWeld{13},seam_TRob2,wd13,\Weave:=weave13,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track13;
        !\Track:=track13;

        IF 14>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=14;
        ArcL Welds2{14}.position,vWeld{14},seam_TRob2,wd14,\Weave:=weave14,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track14;
        !\Track:=track14;

        IF 15>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=15;
        ArcL Welds2{15}.position,vWeld{15},seam_TRob2,wd15,\Weave:=weave15,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track15;
        !\Track:=track15;

        IF 16>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=16;
        ArcL Welds2{16}.position,vWeld{16},seam_TRob2,wd16,\Weave:=weave16,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track16;
        !\Track:=track16;

        IF 17>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=17;
        ArcL Welds2{17}.position,vWeld{17},seam_TRob2,wd17,\Weave:=weave17,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track17;
        !\Track:=track17;

        IF 18>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=18;
        ArcL Welds2{18}.position,vWeld{18},seam_TRob2,wd18,\Weave:=weave18,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track18;
        !\Track:=track18;

        IF 19>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=19;
        ArcL Welds2{19}.position,vWeld{19},seam_TRob2,wd19,\Weave:=weave19,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track19;
        !\Track:=track19;

        IF 20>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=20;
        ArcL Welds2{20}.position,vWeld{20},seam_TRob2,wd20,\Weave:=weave20,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track20;
        !\Track:=track20;

        IF 21>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=21;
        ArcL Welds2{21}.position,vWeld{21},seam_TRob2,wd21,\Weave:=weave21,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track21;
        !\Track:=track21;

        IF 22>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=22;
        ArcL Welds2{22}.position,vWeld{22},seam_TRob2,wd22,\Weave:=weave22,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track22;
        !\Track:=track22;

        IF 23>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=23;
        ArcL Welds2{23}.position,vWeld{23},seam_TRob2,wd23,\Weave:=weave23,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track23;
        !\Track:=track23;

        IF 24>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=24;
        ArcL Welds2{24}.position,vWeld{24},seam_TRob2,wd24,\Weave:=weave24,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track24;
        !\Track:=track24;

        IF 25>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=25;
        ArcL Welds2{25}.position,vWeld{25},seam_TRob2,wd25,\Weave:=weave25,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track25;
        !\Track:=track25;

        IF 26>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=26;
        ArcL Welds2{26}.position,vWeld{26},seam_TRob2,wd26,\Weave:=weave26,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track26;
        !\Track:=track26;

        IF 27>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=27;
        ArcL Welds2{27}.position,vWeld{27},seam_TRob2,wd27,\Weave:=weave27,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track27;
        !\Track:=track27;

        IF 28>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=28;
        ArcL Welds2{28}.position,vWeld{28},seam_TRob2,wd28,\Weave:=weave28,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track28;
        !\Track:=track28;

        IF 29>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=29;
        ArcL Welds2{29}.position,vWeld{29},seam_TRob2,wd29,\Weave:=weave29,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track29;
        !\Track:=track29;

        IF 30>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=30;
        ArcL Welds2{30}.position,vWeld{30},seam_TRob2,wd30,\Weave:=weave30,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track30;
        !\Track:=track30;

        IF 31>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=31;
        ArcL Welds2{31}.position,vWeld{31},seam_TRob2,wd31,\Weave:=weave31,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track31;
        !\Track:=track31;

        IF 32>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=32;
        ArcL Welds2{32}.position,vWeld{32},seam_TRob2,wd32,\Weave:=weave32,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track32;
        !\Track:=track32;

        IF 33>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=33;
        ArcL Welds2{33}.position,vWeld{33},seam_TRob2,wd33,\Weave:=weave33,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track33;
        !\Track:=track33;

        IF 34>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=34;
        ArcL Welds2{34}.position,vWeld{34},seam_TRob2,wd34,\Weave:=weave34,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track34;
        !\Track:=track34;

        IF 35>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=35;
        ArcL Welds2{35}.position,vWeld{35},seam_TRob2,wd35,\Weave:=weave35,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track35;
        !\Track:=track35;

        IF 36>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=36;
        ArcL Welds2{36}.position,vWeld{36},seam_TRob2,wd36,\Weave:=weave36,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track36;
        !\Track:=track36;

        IF 37>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=37;
        ArcL Welds2{37}.position,vWeld{37},seam_TRob2,wd37,\Weave:=weave37,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track37;
        !\Track:=track37;

        IF 38>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=38;
        ArcL Welds2{38}.position,vWeld{38},seam_TRob2,wd38,\Weave:=weave38,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track38;
        !\Track:=track38;

        IF 39>=nMotionStepCount{2} GOTO MoveArcEnd;
        nRunningStep{2}:=39;
        ArcL Welds2{39}.position,vWeld{39},seam_TRob2,wd39,\Weave:=weave39,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track39;
        !\Track:=track39;

        MoveArcEnd:
        nRunningStep{2}:=40;

        ArcLEnd Welds2{40}.position,vWeld{40},seam_TRob2,wd40,\Weave:=weave40,fine,tWeld2\WObj:=wobjWeldLine2\Track:=track40;

        bArc_On{2}:=FALSE;
        ClkStop clockWeldTime;
        nclockWeldTime{2}:=ClkRead(clockWeldTime);
        !\Track:=track40;
        MoveL RelTool(Welds2{nMotionStepCount{2}}.position,0,0,-50),vTargetSpeed,fine,tWeld2\WObj:=wobjWeldLine2;
        ConfL\On;

        IDelete intOutGantryHold;

        stReact{2}:="WeldOk";
        WaitUntil stCommand="" OR stReact{1}="Error_Arc_Touch";
        IF stReact{1}="Error_Arc_Touch" rArcError;
        stReact{2}:="Ready";

    ENDPROC

    PROC rNoWeld012()
        VAR num nTempMmps;

        IDelete inumMoveG_PosHold;
        CONNECT inumMoveG_PosHold WITH trapMoveG_PosHold;
        ISignalDO so_MoveG_PosHold,1,inumMoveG_PosHold;
        WaitRob\ZeroSpeed;
        WaitSyncTask Wait{20},taskGroup123;
        nRunningStep{2}:=0;

        FOR i FROM 1 TO nMotionStepCount{2} DO
            !===========================================================!
            !!! [mm/sec] = [cm/sec]*10 = [cm/min]*10/60 = [cm/min]/6  !!!
            !===========================================================!
            nTempMmps:=Welds2{i}.cpm/6;
            vWeld{i}:=[nTempMmps,200,200,200];

            vWeld{i}.v_leax:=vWeld{i}.v_leax*1;
            vWeld{i}.v_ori:=vWeld{i}.v_ori*1;
            vWeld{i}.v_reax:=vWeld{i}.v_reax*1;
            vWeld{i}.v_tcp:=vWeld{i}.v_tcp*1;
            IF i=1 THEN
                MoveL RelTool(Welds2{1}.position,0,0,-50),vTargetSpeed,fine,tWeld2\WObj:=wobjWeldLine2;
            ENDIF
            IF nRunningStep{2}=0 THEN
                WaitUntil stReact{1}="T_ROB1_ArcOn";
                WaitUntil 2<=nWeldSequence;
            ENDIF
            nRunningStep{2}:=i;
            IF i=1 vWeld{1}:=vTargetSpeed;
            MoveL Welds2{i}.position,vWeld{i},fine,tWeld2\WObj:=wobjWeldLine2;
        ENDFOR
        MoveL RelTool(Welds2{nMotionStepCount{2}}.position,0,0,-50),vTargetSpeed,fine,tWeld2\WObj:=wobjWeldLine2;
        stReact{2}:="WeldOk";

        WaitUntil stCommand="";
        stReact{2}:="Ready";
        RETURN ;
    ENDPROC

    PROC rNoWeld34()
        VAR num nTempMmps;

        !        IDelete inumMoveG_PosHold;
        !        CONNECT inumMoveG_PosHold WITH trapMoveG_PosHold;
        !        ISignalDO so_MoveG_PosHold,1,inumMoveG_PosHold;
        WaitRob\ZeroSpeed;
        WaitSyncTask Wait{20},taskGroup123;

        nRunningStep{2}:=0;

        FOR i FROM 1 TO nMotionStepCount{2} DO
            !===========================================================!
            !!! [mm/sec] = [cm/sec]*10 = [cm/min]*10/60 = [cm/min]/6  !!!
            !===========================================================!
            nTempMmps:=Welds2{i}.cpm/6;
            vWeld{i}:=[nTempMmps,200,200,200];

            vWeld{i}.v_leax:=vWeld{i}.v_leax*1;
            vWeld{i}.v_ori:=vWeld{i}.v_ori*1;
            vWeld{i}.v_reax:=vWeld{i}.v_reax*1;
            vWeld{i}.v_tcp:=vWeld{i}.v_tcp*1;
            IF i=1 THEN
                MoveL RelTool(Welds2{1}.position,0,0,-50),vTargetSpeed,fine,tWeld2\WObj:=wobjWeldLine2;
            ENDIF
            nRunningStep{2}:=i;
            IF i=1 vWeld{1}:=vTargetSpeed;

            IF i>3 AND so_MoveG_PosHold=1 THEN
                WaitUntil so_MoveG_PosHold=0;
            ENDIF

            MoveL Welds2{i}.position,vWeld{i},fine,tWeld2\WObj:=wobjWeldLine2;
            IF nRunningStep{2}=1 stReact{2}:="T_ROB2_ArcOn";
            IF nRunningStep{2}=1 stReact{2}:="T_ROB2_GantryOn";
        ENDFOR
        MoveL RelTool(Welds2{nMotionStepCount{2}}.position,0,0,-50),vTargetSpeed,fine,tWeld2\WObj:=wobjWeldLine2;
        stReact{2}:="WeldOk";


        WaitUntil stCommand="";
        stReact{2}:="Ready";
        RETURN ;
    ENDPROC

    PROC rWireCut()
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
        !        WaitTime 2.25;
        jWireCut4.robax:=[90,90,-50,0,0,0];
        MoveAbsJ jWireCut4\NoEOffs,vTempFast,z100,tWeld2;
        MoveAbsJ jWireCut3\NoEOffs,vTempFast,z100,tWeld2;
        MoveAbsJ jWireCut2\NoEOffs,vTempFast,z100,tWeld2;
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
        MoveAbsJ jWireCut3\NoEOffs,vTempFast,z100,tWeld2;
        MoveAbsJ jWireCut4\NoEOffs,vTempFast,z100,tWeld2;
        WaitRob\ZeroSpeed;
        IF bWireCutSync=FALSE Reset do10_Wire_Cutter_Open;
        stReact{2}:="WireCutOk";
        WaitUntil stCommand="";
        stReact{2}:="Ready";
        WaitUntil stReact=["Ready","Ready","Ready"];
        RETURN ;
    ENDPROC

    PROC rWireCutMove()
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
        !        WaitTime 2.25;
        MoveAbsJ jWireCut3\NoEOffs,vTempFast,z100,tWeld2;
        MoveAbsJ jWireCut2\NoEOffs,vTempFast,z100,tWeld2;
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
        IF bWirecut=[FALSE,TRUE,FALSE] THEN
            MoveAbsJ jWireCut3\NoEOffs,vTempFast,z100,tWeld2;
            jWireCut4.robax:=[40,90,-90,0,0,0];
            MoveAbsJ jWireCut4\NoEOffs,vTempFast,z100,tWeld2;
        ENDIF
        IF bWireCutSync=FALSE Reset do10_Wire_Cutter_Open;
        stReact{2}:="WireCutOk";
        WaitUntil stCommand="";
        stReact{2}:="Ready";
        WaitUntil stReact=["Ready","Ready","Ready"];
        RETURN ;
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

    !    PROC rTrapNoWeldMove()
    !        VAR num i;
    !        VAR targetdata WeldsTemp;
    !        VAR robtarget pWeldTemp;

    !        StopMove;
    !        StorePath;

    !        i:=nRunningStep{2};
    !        WeldsTemp:=Welds2{i};
    !        pWeldTemp:=CRobT(\taskname:="T_ROB2"\Tool:=tWeld2\WObj:=wobjWeldLine2);
    !        WeldsTemp.position:=pWeldTemp;
    !        ConfL\Off;
    !        While (so_MoveG_PosHold=1) DO
    !            nTrapCheck_2:=1;
    !            MoveL RelTool(WeldsTemp.position,0,-0.1,0),vWeld{i},fine,tWeld2\WObj:=wobjWeldLine2;
    !            MoveL RelTool(WeldsTemp.position,0,0.1,0),vWeld{i},fine,tWeld2\WObj:=wobjWeldLine2;
    !        ENDWHILE
    !        ConfL\On;
    !        RestoPath;
    !        StartMove;
    !    ENDPROC

    PROC rTrapWeldMove()
        VAR num i;
        VAR robtarget pWeldTemp;
        VAR robtarget pTemp_pos;
        VAR num nTempMmps;
        VAR speeddata vWeldTemp;
        IDelete inumMoveG_PosHold;
        StopMove;
        !        ClearPath;
        !        StorePath;
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
        WaitSyncTask Wait{20},taskGroup123;

        !        IF pi32_Retry=0 nTouchRetryCount{2}:=0;

        IF (nMacro010{1}=3 AND nMacro010{2}=3) OR (nMacro010{1}=4 AND nMacro010{2}=4) THEN
            WaitUntil bGanTry_Last_pos=TRUE;
        ELSE
            WaitUntil bGanTry_Last_pos=TRUE AND bTouch_last_R1_Comp=TRUE;
        ENDIF
        nCorrFailOffs_Z:=10*nEntryRetryCount{2};
        IF bRobSwap=TRUE nCorrFailOffs_Y:=(10*nEntryRetryCount{2});
        IF bRobSwap=FALSE nCorrFailOffs_Y:=(10*nEntryRetryCount{2});

        TEST nMacro001{2}
        CASE 0,1,2,3,4,5:
            IF edgeEndBuffer2.Height>edgeEndBuffer2.Breadth THEN
                ! Setting Conditions
                IF nMacro001{2}=0 OR nMacro001{2}=1 OR nMacro001{2}=2 OR nMacro001{2}=5 n_X:=-15;
                IF nMacro001{2}=3 OR nMacro001{2}=4 OR nMacro001{2}=8 n_X:=0;
                !                n_Y:=TouchLimit(corrEnd{nMacro001{2}+1}.Y_StartOffset+nEndThick,edgeendBuffer2.Breadth)+nCorrFailOffs_Y;
                n_Y:=corrEnd{nMacro001{2}+1}.Y_StartOffset+nEndThick+nCorrFailOffs_Y;
                n_Y:=n_Y*(-1);
                n_Ret_Y:=TouchLimit(corrEnd{nMacro001{2}+1}.Y_ReturnLength,edgeEndBuffer2.Breadth);
                n_Ret_Y:=n_Ret_Y*(-1);
                n_Ret_Z:=TouchLimit(corrEnd{nMacro001{2}+1}.Z_ReturnLength,edgeEndBuffer2.Height);
                n_Z:=TouchLimit(corrEnd{nMacro001{2}+1}.Z_StartOffset,edgeEndBuffer2.Height)+nCorrFailOffs_Z;

                ! Touch Entry Location================================================================
                IWatch iErrorDuringEntry;

                rCheckWelder;

                rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir\LIN;
                Reset soLn2Touch;
                IDelete iErrorDuringEntry;
                nEntryRetryCount{2}:=0;
                IF bTouchWorkCount{3}=TRUE GOTO TouchComplete_End_Y;
                WaitTime 0;
                ! rCheckTouchAtStart;
                !=====================================================================================
                ! edge_Y
                IF bTouchWorkCount{1}=FALSE THEN
                    rCorrSearchWeldLineEdgeY n_X,n_Y,n_Z,(corrEnd{nMacro001{2}+1}.Y_Depth*(-1))+nCorrFailOffs_Y+(nEndThick*(-1)),n_Ret_Y,bEnd,bInstalldir,"End_Y";
                    bTouchWorkCount{1}:=TRUE;
                    nTouchRetryCount{2}:=0;
                ENDIF

                ! edge_Z
                IF bTouchWorkCount{2}=FALSE THEN
                    ! Setting Conditions
                    n_Y:=n_Ret_Y;
                    n_Ret_Z:=TouchLimit(corrEnd{nMacro001{2}+1}.Z_ReturnLength,edgeEndBuffer2.Height);

                    rCorrSearchWeldLineEdgeZ n_X,n_Y,n_Z,corrEnd{nMacro001{2}+1}.Z_Depth+nCorrFailOffs_Z,n_Ret_Z,bEnd,bInstalldir,"End_Z";
                    bTouchWorkCount{2}:=TRUE;
                    nTouchRetryCount{2}:=0;
                ENDIF

                ! Setting Conditions
                n_Z:=n_Ret_Z;
                rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;

                IF nMacro001{2}=3 OR nMacro001{2}=4 OR nMacro001{2}=8 GOTO TouchComplete_End_Y;
                IF nMacro001{2}=2 OR nMacro001{2}=5 THEN
                    IF nMacro001{2}=5 n_Z:=edgeEndBuffer2.HoleSize+1;
                ELSE
                    ! Setting Conditions
                    n_X:=corrEnd{nMacro001{2}+1}.X_StartOffset;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;
                    ! Setting Conditions
                    n_Y:=5;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;

                ENDIF

                ! edge_X
                IF bTouchWorkCount{3}=FALSE THEN
                    rCorrSearchWeldLineEdgeX n_X,n_Y,n_Z,corrEnd{nMacro001{2}+1}.X_Depth,corrEnd{nMacro001{2}+1}.X_ReturnLength,bEnd,bInstalldir,"End_X";
                    bTouchWorkCount{3}:=TRUE;
                    nTouchRetryCount{2}:=0;
                ENDIF
                ! Setting Conditions
                n_X:=corrEnd{nMacro001{2}+1}.X_ReturnLength;
                rMoveCorrConnect n_X,n_Y,n_Z,0,corrEnd{nMacro001{2}+1}.RY_Torch,0,nHeightBuffer,bEnd,bInstalldir;
                ! Labal
                TouchComplete_End_Y:
                ! Setting Conditions
                n_Y:=n_Ret_Y;
                rMoveCorrConnect n_X,n_Y,n_Z,0,corrEnd{nMacro001{2}+1}.RY_Torch+n_Angle,0,nHeightBuffer,bEnd,bInstalldir;

            ELSE

                ! Setting Conditions
                IF nMacro001{2}=0 OR nMacro001{2}=1 OR nMacro001{2}=2 OR nMacro001{2}=5 n_X:=-15;
                IF nMacro001{2}=3 OR nMacro001{2}=4 OR nMacro001{2}=8 n_X:=0;
                n_Y:=TouchLimit(corrEnd{nMacro001{2}+1}.Y_StartOffset+nEndThick,edgeEndBuffer2.Breadth)+nCorrFailOffs_Y;
                n_Y:=n_Y*(-1);
                n_Ret_Y:=TouchLimit(corrEnd{nMacro001{2}+1}.Y_ReturnLength,edgeEndBuffer2.Breadth);
                n_Ret_Y:=n_Ret_Y*(-1);
                n_Ret_Z:=TouchLimit(corrEnd{nMacro001{2}+1}.Z_ReturnLength,edgeEndBuffer2.Height);
                n_Z:=TouchLimit(corrEnd{nMacro001{2}+1}.Z_StartOffset,edgeEndBuffer2.Height)+nCorrFailOffs_Z;


                IWatch iErrorDuringEntry;

                rCheckWelder;

                rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir\LIN;
                Reset soLn2Touch;
                IDelete iErrorDuringEntry;
                nEntryRetryCount{2}:=0;
                IF bTouchWorkCount{3}=TRUE GOTO TouchComplete_End_Z;
                !    rCheckTouchAtStart;

                ! edge_Z
                IF bTouchWorkCount{1}=FALSE THEN
                    rCorrSearchWeldLineEdgeZ n_X,n_Y,n_Z,corrEnd{nMacro001{2}+1}.Z_Depth+nCorrFailOffs_Z,n_Ret_Z,bEnd,bInstalldir,"End_Z";
                    bTouchWorkCount{1}:=TRUE;
                    nTouchRetryCount{2}:=0;
                ENDIF

                ! edge_Y
                IF bTouchWorkCount{2}=FALSE THEN
                    ! Setting Conditions
                    n_Z:=n_Ret_Z;
                    rCorrSearchWeldLineEdgeY n_X,n_Y,n_Z,(corrEnd{nMacro001{2}+1}.Y_Depth*(-1))+nCorrFailOffs_Y+(nEndThick*(-1)),n_Ret_Y,bEnd,bInstalldir,"End_Y";
                    bTouchWorkCount{2}:=TRUE;
                    nTouchRetryCount{2}:=0;
                ENDIF

                ! Setting Conditions
                n_Y:=n_Ret_Y;
                rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;

                IF nMacro001{2}=3 OR nMacro001{2}=4 OR nMacro001{2}=8 GOTO TouchComplete_End_Z;
                IF nMacro001{2}=2 OR nMacro001{2}=5 THEN
                    IF nMacro001{2}=5 n_Z:=edgeEndBuffer2.HoleSize+1;
                ELSE

                    ! Setting Conditions
                    n_X:=corrEnd{nMacro001{2}+1}.X_StartOffset;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;
                    ! Setting Conditions
                    n_Y:=5;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bEnd,bInstalldir;

                ENDIF

                ! edge_X
                IF bTouchWorkCount{3}=FALSE THEN
                    rCorrSearchWeldLineEdgeX n_X,n_Y,n_Z,corrEnd{nMacro001{2}+1}.X_Depth,corrEnd{nMacro001{2}+1}.X_ReturnLength,bEnd,bInstalldir,"End_X";
                    bTouchWorkCount{3}:=TRUE;
                    nTouchRetryCount{2}:=0;
                ENDIF

                ! Setting Conditions
                n_X:=corrEnd{nMacro001{2}+1}.X_ReturnLength;
                rMoveCorrConnect n_X,n_Y,n_Z,0,corrEnd{nMacro001{2}+1}.RY_Torch,0,nHeightBuffer,bEnd,bInstalldir;
                ! Labal
                TouchComplete_End_Z:
                ! Setting Conditions
                n_Y:=n_Ret_Y;
                rMoveCorrConnect n_X,n_Y,n_Z,0,corrEnd{nMacro001{2}+1}.RY_Torch+n_Angle,0,nHeightBuffer,bEnd,bInstalldir;
            ENDIF
            IF nMacro001{2}=3 OR nMacro001{2}=4 OR nMacro001{2}=8 THEN
                !   IF bEndSearchComplete=FALSE pCorredSplitPos:=ConvertPosWeldLineToFloor(pSearchStart,nWeldLineLength+nCorrX_Store_End,nCorrY_Store_End,nCorrZ_Store_End);
            ENDIF
        DEFAULT:
            Stop;
            Stop;
            ExitCycle;
        ENDTEST

        bTouch_last_R2_Comp:=TRUE;
        bTouch_First_R2_Comp:=FALSE;
        pCorrTemp_End{2}:=CRobT(\TaskName:="T_ROB2"\Tool:=tWeld2\WObj:=wobjWeldLine2);
        pCorrTemp_End{2}.trans:=[nWeldLineLength_R2+nCorrX_Store_End{2},nCorrY_Store_End{2},nCorrZ_Store_End{2}];
        jCorrTemp_End{2}:=CalcJointT(pCorrTemp_End{2},tWeld2\WObj:=wobjWeldLine2);
        pCorrT_ROB2_End:=CalcRobT(jCorrTemp_End{2},Tool:=tWeld2\WObj:=wobjRotCtr2);
        IF (nMacro010{1}=3 AND nMacro010{2}=3) OR (nMacro010{1}=4 AND nMacro010{2}=4) THEN
            WaitUntil bGanTry_First_pos=TRUE;
        ELSE
            WaitUntil bGanTry_First_pos=TRUE AND bTouch_First_R1_Comp=TRUE;
        ENDIF
        !!! Start correctioning from start edge !!!
        TEST nMacro010{2}
        CASE 0,1,2,3,4,5:
            IF edgestartBuffer2.Height>edgestartBuffer2.Breadth THEN

                ! Setting Conditions
                IF nMacro010{2}=0 OR nMacro010{2}=1 OR nMacro010{2}=2 OR nMacro010{2}=5 n_X:=-15;
                IF nMacro010{2}=3 OR nMacro010{2}=4 OR nMacro010{2}=8 n_X:=0;
                !                n_Y:=TouchLimit(corrStart{nMacro010{2}+1}.Y_StartOffset+nStartThick,edgestartBuffer2.Breadth)+nCorrFailOffs_Y;
                n_Y:=corrStart{nMacro010{2}+1}.Y_StartOffset+nStartThick+nCorrFailOffs_Y;
                n_Y:=n_Y*(-1);
                n_Ret_Y:=TouchLimit(corrStart{nMacro010{2}+1}.Y_ReturnLength,edgestartBuffer2.Breadth);
                n_Ret_Y:=n_Ret_Y*(-1);
                n_Z:=TouchLimit(corrStart{nMacro010{2}+1}.Z_StartOffset,edgestartBuffer2.Height)+nCorrFailOffs_Z;
                n_Ret_Z:=TouchLimit(corrStart{nMacro010{2}+1}.Z_ReturnLength,edgestartBuffer2.Height);

                ! edge_Y
                rMoveCorrConnect n_X,n_Y,n_Z,0,corrStart{nMacro010{2}+1}.RY_Torch+n_Angle,0,nHeightBuffer,bStart,bInstalldir\LIN;
                !    rCheckTouchAtStart;

                IF bTouchWorkCount{4}=FALSE THEN
                    rCorrSearchWeldLineEdgeY n_X,n_Y,n_Z,(corrStart{nMacro010{2}+1}.Y_Depth*(-1))+nCorrFailOffs_Y+(nStartThick*(-1)),n_Ret_Y,bStart,bInstalldir,"Start_Y";
                    bTouchWorkCount{4}:=TRUE;
                    nTouchRetryCount{2}:=0;
                ENDIF

                ! edge_Z
                IF bTouchWorkCount{5}=FALSE THEN
                    ! Setting Conditions
                    n_Y:=n_Ret_Y;
                    n_Ret_Z:=TouchLimit(corrStart{nMacro010{2}+1}.Z_ReturnLength,edgestartBuffer2.Height);
                    rCorrSearchWeldLineEdgeZ n_X,n_Y,n_Z,corrStart{nMacro010{2}+1}.Z_Depth+nCorrFailOffs_Z,n_Ret_Z,bStart,bInstalldir,"Start_Z";
                    bTouchWorkCount{5}:=TRUE;
                    nTouchRetryCount{2}:=0;
                ENDIF

                ! Setting Conditions
                n_Z:=n_Ret_Z;
                rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;

                IF nMacro010{2}=3 OR nMacro010{2}=4 OR nMacro010{2}=8 GOTO TouchComplete_Start_Y;
                IF nMacro010{2}=2 OR nMacro010{2}=5 THEN
                    IF nMacro010{2}=5 n_Z:=edgestartBuffer2.HoleSize+1;
                ELSE
                    !         IF bTouchWorkCount{6}=FALSE THEN
                    ! Setting Conditions
                    n_X:=corrStart{nMacro010{2}+1}.X_StartOffset;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;
                    ! Setting Conditions
                    n_Y:=5;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;
                ENDIF
                !    ENDIF

                ! edge_X
                IF bTouchWorkCount{6}=FALSE THEN
                    rCorrSearchWeldLineEdgeX n_X,n_Y,n_Z,corrStart{nMacro010{2}+1}.X_Depth,corrStart{nMacro010{2}+1}.X_ReturnLength,bStart,bInstalldir,"Start_X";
                    bTouchWorkCount{6}:=TRUE;
                    nTouchRetryCount{2}:=0;
                ENDIF
                ! Setting Conditions
                n_X:=corrStart{nMacro010{2}+1}.X_ReturnLength;
                rMoveCorrConnect n_X,n_Y,n_Z,0,corrStart{nMacro010{2}+1}.RY_Torch,0,nHeightBuffer,bStart,bInstalldir;
                ! Labal
                TouchComplete_Start_Y:
            ELSE

                ! Setting Conditions
                IF nMacro010{2}=0 OR nMacro010{2}=1 OR nMacro010{2}=2 OR nMacro010{2}=5 n_X:=-15;
                IF nMacro010{2}=3 OR nMacro010{2}=4 OR nMacro010{2}=8 n_X:=0;
                n_Y:=TouchLimit(corrStart{nMacro010{2}+1}.Y_StartOffset+nStartThick,edgestartBuffer2.Breadth)+nCorrFailOffs_Y;
                n_Y:=n_Y*(-1);
                n_Ret_Y:=TouchLimit(corrStart{nMacro010{2}+1}.Y_ReturnLength,edgestartBuffer2.Breadth);
                n_Ret_Y:=n_Ret_Y*(-1);
                n_Ret_Z:=TouchLimit(corrStart{nMacro010{2}+1}.Z_ReturnLength,edgestartBuffer2.Height);
                n_Z:=TouchLimit(corrStart{nMacro010{2}+1}.Z_StartOffset,edgestartBuffer2.Height)+nCorrFailOffs_Z;

                rMoveCorrConnect n_X,n_Y,n_Z,0,corrStart{nMacro010{2}+1}.RY_Torch+n_Angle,0,nHeightBuffer,bStart,bInstalldir\LIN;
                ! rCheckTouchAtStart;


                ! edge_Z
                IF bTouchWorkCount{4}=FALSE THEN
                    rCorrSearchWeldLineEdgeZ n_X,n_Y,n_Z,corrStart{nMacro010{2}+1}.Z_Depth+nCorrFailOffs_Z,n_Ret_Z,bStart,bInstalldir,"Start_Z";
                    bTouchWorkCount{4}:=TRUE;
                    nTouchRetryCount{2}:=0;
                ENDIF
                ! Setting Conditions


                ! edge_Y
                IF bTouchWorkCount{5}=FALSE THEN
                    ! Setting Conditions
                    n_Z:=n_Ret_Z;
                    rCorrSearchWeldLineEdgeY n_X,n_Y,n_Z,(corrStart{nMacro010{2}+1}.Y_Depth*(-1))+nCorrFailOffs_Y+(nStartThick*(-1)),n_Ret_Y,bStart,bInstalldir,"Start_Y";
                    bTouchWorkCount{5}:=TRUE;
                    nTouchRetryCount{2}:=0;
                ENDIF

                ! Setting Conditions
                n_Y:=n_Ret_Y;
                rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;

                IF nMacro010{2}=3 OR nMacro010{2}=4 OR nMacro010{2}=8 GOTO TouchComplete_Start_Z;
                IF nMacro010{2}=2 OR nMacro010{2}=5 THEN
                    IF nMacro010{2}=5 n_Z:=edgestartBuffer2.HoleSize+1;
                ELSE
                    !    IF bTouchWorkCount{6}=FALSE THEN
                    ! Setting Conditions
                    n_X:=corrStart{nMacro010{2}+1}.X_StartOffset;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;
                    ! Setting Conditions
                    n_Y:=5;
                    rMoveCorrConnect n_X,n_Y,n_Z,0,0,0,nHeightBuffer,bStart,bInstalldir;
                ENDIF
                ! ENDIF

                ! edge_X
                IF bTouchWorkCount{6}=FALSE THEN
                    rCorrSearchWeldLineEdgeX n_X,n_Y,n_Z,corrStart{nMacro010{2}+1}.X_Depth,corrStart{nMacro010{2}+1}.X_ReturnLength,bStart,bInstalldir,"Start_X";
                    bTouchWorkCount{6}:=TRUE;
                    nTouchRetryCount{2}:=0;
                ENDIF
                ! Setting Conditions
                n_X:=corrStart{nMacro010{2}+1}.X_ReturnLength;
                rMoveCorrConnect n_X,n_Y,n_Z,0,corrStart{nMacro010{2}+1}.RY_Torch,0,nHeightBuffer,bStart,bInstalldir;

                ! Labal
                TouchComplete_Start_Z:
            ENDIF

        DEFAULT:
            Stop;
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
            !        pSearchStart:=ConvertTcpToGantryCoord(pWeldPosR2{1}.position);
            pSearchStart.rot:=Welds2{1}.position.rot;
            IF (CCW=FALSE) pSearchStart.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y*(-1)),nCorrZ_Store+(Z)];
        ELSEIF (isStartPos=bEnd) THEN
            !        pSearchStart:=ConvertTcpToGantryCoord(pWeldPosR2{nMotionStepCount}.position);
            !  pSearchStart.rot:=pWeldPosR2{nMotionStepCount{2}}.rot;
            pSearchStart.rot:=Welds2{nMotionStepCount{2}}.position.rot;
            IF (CCW=FALSE) pSearchStart.trans:=[nWeldLineLength_R2+nCorrX_Store+(X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart.trans:=[nWeldLineLength_R2+nCorrX_Store+(X),nCorrY_Store+(Y*(-1)),nCorrZ_Store+(Z)];
        ENDIF

        pSearchStart.robconf.cfx:=1;
        pSearchStart.extax:=[9e9,9e9,9e9,9e9,9e9,9e9];
        !    pSearchStart.extax.eax_d:=wobjWeldLine1.uframe.trans.z-(nRobCorrSpaceHeight+wobjWeldLine1.oframe.trans.z);

        pSearchEnd:=pSearchStart;
        IF (isStartPos=bStart) pSearchEnd.trans.x:=pSearchStart.trans.x+Depth;
        IF (isStartPos=bEnd) pSearchEnd.trans.x:=pSearchStart.trans.x-Depth;

        rCorrSearchByWire pSearchStart,pSearchEnd\X;

        IF (isStartPos=bStart) nCorrX_Store:=pCorredPosBuffer.x;
        IF (isStartPos=bEnd) nCorrX_Store:=pCorredPosBuffer.x-nWeldLineLength_R2;

        IF (isStartPos=bStart) THEN
            nCorrX_Store_Start{2}:=nCorrX_Store;
            nCorrY_Store_Start{2}:=nCorrY_Store;
            nCorrZ_Store_Start{2}:=nCorrZ_Store;
        ELSE
            nCorrX_Store_End{2}:=nCorrX_Store;
            nCorrY_Store_End{2}:=nCorrY_Store;
            nCorrZ_Store_End{2}:=nCorrZ_Store;
        ENDIF

        rMoveCorrConnect RetX,Y,Z,0,0,0,pSearchStart.extax.eax_d,isStartPos,CCW;
        nTouchRetryCount{2}:=0;
        TouchErrorDirMain:="Ready";

        RETURN ;
    ENDPROC

    PROC rCorrSearchWeldLineEdgeY(num X,num Y,num Z,num Depth,num RetY,bool isStartPos,bool CCW,string dirErrorCheck)
        VAR num nCorrX_Store;
        VAR num nCorrY_Store;
        VAR num nCorrZ_Store;
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
            !        pSearchStart:=ConvertTcpToGantryCoord(pWeldPosR2{1}.position);
            pSearchStart.rot:=Welds2{1}.position.rot;
            IF (CCW=FALSE) pSearchStart.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y*(-1)),nCorrZ_Store+Z];
        ELSEIF (isStartPos=bEnd) THEN
            !        pSearchStart:=ConvertTcpToGantryCoord(pWeldPosR2{nMotionStepCount}.position);
            !pSearchStart.rot:=pWeldPosR2{nMotionStepCount{2}}.rot;
            pSearchStart.rot:=Welds2{nMotionStepCount{2}}.position.rot;
            IF (CCW=FALSE) pSearchStart.trans:=[nWeldLineLength_R2+nCorrX_Store+(X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart.trans:=[nWeldLineLength_R2+nCorrX_Store+(X),nCorrY_Store+(Y*(-1)),nCorrZ_Store+(Z)];
        ENDIF

        pSearchStart.robconf.cfx:=1;
        !  pSearchStart.extax.eax_d:=wobjWeldLine1.uframe.trans.z-(nRobCorrSpaceHeight+wobjWeldLine1.oframe.trans.z);

        pSearchEnd:=pSearchStart;
        pSearchStart.extax:=[9e9,9e9,9e9,9e9,9e9,9e9];
        IF (CCW=FALSE) pSearchEnd.trans.y:=pSearchStart.trans.y-Depth;
        IF (CCW=TRUE) pSearchEnd.trans.y:=pSearchStart.trans.y+Depth;

        rCorrSearchByWire pSearchStart,pSearchEnd\Y;

        nCorrY_Store:=pCorredPosBuffer.y;

        IF (isStartPos=bStart) THEN
            nCorrX_Store_Start{2}:=nCorrX_Store;
            nCorrY_Store_Start{2}:=nCorrY_Store;
            nCorrZ_Store_Start{2}:=nCorrZ_Store;
        ELSE
            nCorrX_Store_End{2}:=nCorrX_Store;
            nCorrY_Store_End{2}:=nCorrY_Store;
            nCorrZ_Store_End{2}:=nCorrZ_Store;
        ENDIF

        rMoveCorrConnect X,RetY,Z,0,0,0,pSearchStart.extax.eax_d,isStartPos,CCW;
        nTouchRetryCount{2}:=0;
        TouchErrorDirMain:="Ready";

        RETURN ;
    ENDPROC

    PROC rCorrSearchWeldLineEdgeZ(num X,num Y,num Z,num Depth,num RetZ,bool isStartPos,bool CCW,string dirErrorCheck)
        VAR num nCorrX_Store;
        VAR num nCorrY_Store;
        VAR num nCorrZ_Store;
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
            !       pSearchStart:=ConvertTcpToGantryCoord(pWeldPosR2{1}.position);
            pSearchStart.rot:=Welds2{1}.position.rot;
            IF (CCW=FALSE) pSearchStart.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y*(-1)),nCorrZ_Store+(Z)];
        ELSEIF (isStartPos=bEnd) THEN
            !        pSearchStart:=ConvertTcpToGantryCoord(pWeldPosR2{nMotionStepCount}.position);
            pSearchStart.rot:=Welds2{nMotionStepCount{2}}.position.rot;
            ! pSearchStart.rot:=pWeldPosR2{nMotionStepCount{2}}.rot;
            IF (CCW=FALSE) pSearchStart.trans:=[nWeldLineLength_R2+nCorrX_Store+(X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart.trans:=[nWeldLineLength_R2+nCorrX_Store+(X),nCorrY_Store+(Y*(-1)),nCorrZ_Store+(Z)];
        ENDIF

        pSearchStart.robconf.cfx:=1;
        pSearchStart.extax:=[9e9,9e9,9e9,9e9,9e9,9e9];
        !  pSearchStart.extax.eax_d:=wobjWeldLine1.uframe.trans.z-(nRobCorrSpaceHeight+wobjWeldLine1.oframe.trans.z);

        pSearchEnd:=pSearchStart;
        pSearchEnd.trans.z:=pSearchStart.trans.z-Depth;

        rCorrSearchByWire pSearchStart,pSearchEnd\Z;

        nCorrZ_Store:=pCorredPosBuffer.z;

        IF (isStartPos=bStart) THEN
            nCorrX_Store_Start{2}:=nCorrX_Store;
            nCorrY_Store_Start{2}:=nCorrY_Store;
            nCorrZ_Store_Start{2}:=nCorrZ_Store;
        ELSE
            nCorrX_Store_End{2}:=nCorrX_Store;
            nCorrY_Store_End{2}:=nCorrY_Store;
            nCorrZ_Store_End{2}:=nCorrZ_Store;
        ENDIF

        rMoveCorrConnect X,Y,RetZ,0,0,0,pSearchStart.extax.eax_d,isStartPos,CCW;
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
        pCorredPosBuffer:=pTemp.trans;
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
    ENDPROC

    PROC rArcError()
        VAR robtarget pTemp;
        bArc_On{2}:=FALSE;
        TPWrite "TROB2_ArcError";
        PulseDO\High\PLength:=0.5,sdo_T_Rob1_StopProc;
        IDelete iMoveHome_RBT2;
        ClkStop clockWeldTime;
        nclockWeldTime{2}:=ClkRead(clockWeldTime);
        StopMove;
        ClearPath;
        StartMove;
        IF bRobSwap=FALSE THEN
            Set po37_ArcR2Error;
            MonitorweldErrorpostion.monPose1:=MonitorPosition.monPose1;
            MonitorweldErrorpostion.monPose2:=MonitorPosition.monPose2;
        ELSE
            Set po36_ArcR1Error;
            MonitorweldErrorpostion.monPose1:=MonitorPosition.monPose1;
            MonitorweldErrorpostion.monPose2:=MonitorPosition.monPose2;
        ENDIF

        pTemp:=CRobT(\TaskName:="T_ROB2"\Tool:=tWeld2\WObj:=wobjWeldLine2);
        MoveL RelTool(pTemp,0,0,-10),vTargetSpeed,z0,tWeld2\WObj:=wobjWeldLine2;

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
        stop;
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
        pTemp:=CRobT(\TaskName:="T_ROB2"\Tool:=tWeld2\WObj:=wobjWeldLine2);
        IF Abs(pTemp.trans.Y)<100 AND Abs(pTemp.trans.Z)<200 THEN
            IF pTemp.trans.Y>0 then
                pTemp.trans.y:=130;
                MoveL pTemp,v100,fine,tWeld2\WObj:=wobjWeldLine2;
            ENDIF
            IF pTemp.trans.Y<0 THEN
                pTemp.trans.y:=-130;
                MoveL pTemp,v100,fine,tWeld2\WObj:=wobjWeldLine2;
            ENDIF
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

ENDMODULE